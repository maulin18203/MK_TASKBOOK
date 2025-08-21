import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlarmCreationWidget extends StatefulWidget {
  final Map<String, dynamic>? existingAlarm;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const AlarmCreationWidget({
    Key? key,
    this.existingAlarm,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<AlarmCreationWidget> createState() => _AlarmCreationWidgetState();
}

class _AlarmCreationWidgetState extends State<AlarmCreationWidget> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedRecurrence = 'once';
  String _selectedPriority = 'normal';
  String _selectedSound = 'default';
  String _selectedTaskType = 'reminder';
  int _snoozeInterval = 5;
  int _maxSnoozes = 3;
  bool _gradualVolume = true;
  bool _vibrate = true;

  final List<String> _recurrenceOptions = [
    'once',
    'daily',
    'weekly',
    'monthly',
    'yearly',
    'weekdays',
    'weekends',
  ];

  final List<String> _priorityOptions = ['low', 'normal', 'high'];
  final List<String> _taskTypeOptions = [
    'reminder',
    'task',
    'meeting',
    'birthday',
    'event'
  ];
  final List<String> _soundOptions = [
    'default',
    'gentle_wake',
    'classic_bell',
    'nature_sounds',
    'digital_beep',
    'custom',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingAlarm != null) {
      _loadExistingAlarm();
    }
  }

  void _loadExistingAlarm() {
    final alarm = widget.existingAlarm!;
    _labelController.text = alarm['label'] as String? ?? '';

    // Parse time
    final timeString = alarm['time'] as String? ?? '00:00';
    final timeParts = timeString.split(':');
    if (timeParts.length == 2) {
      _selectedTime = TimeOfDay(
        hour: int.tryParse(timeParts[0]) ?? 0,
        minute: int.tryParse(timeParts[1]) ?? 0,
      );
    }

    _selectedRecurrence = alarm['recurrence'] as String? ?? 'once';
    _selectedPriority = alarm['priority'] as String? ?? 'normal';
    _selectedSound = alarm['sound'] as String? ?? 'default';
    _selectedTaskType = alarm['taskType'] as String? ?? 'reminder';
    _snoozeInterval = alarm['snoozeInterval'] as int? ?? 5;
    _maxSnoozes = alarm['maxSnoozes'] as int? ?? 3;
    _gradualVolume = alarm['gradualVolume'] as bool? ?? true;
    _vibrate = alarm['vibrate'] as bool? ?? true;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryLight,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeDisplay(TimeOfDay time) {
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final displayHour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    return '$displayHour:$minute $period';
  }

  void _saveAlarm() {
    if (_formKey.currentState?.validate() ?? false) {
      final alarm = {
        'id': widget.existingAlarm?['id'] ??
            DateTime.now().millisecondsSinceEpoch,
        'time': _formatTime(_selectedTime),
        'label': _labelController.text.trim(),
        'recurrence': _selectedRecurrence,
        'priority': _selectedPriority,
        'sound': _selectedSound,
        'taskType': _selectedTaskType,
        'snoozeInterval': _snoozeInterval,
        'maxSnoozes': _maxSnoozes,
        'gradualVolume': _gradualVolume,
        'vibrate': _vibrate,
        'enabled': widget.existingAlarm?['enabled'] ?? true,
        'createdAt': widget.existingAlarm?['createdAt'] ??
            DateTime.now().toIso8601String(),
        'nextTrigger': _calculateNextTrigger(),
      };

      widget.onSave(alarm);
    }
  }

  String _calculateNextTrigger() {
    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    DateTime nextTrigger = alarmTime;
    if (alarmTime.isBefore(now)) {
      switch (_selectedRecurrence) {
        case 'daily':
          nextTrigger = alarmTime.add(const Duration(days: 1));
          break;
        case 'weekly':
          nextTrigger = alarmTime.add(const Duration(days: 7));
          break;
        case 'monthly':
          nextTrigger = DateTime(alarmTime.year, alarmTime.month + 1,
              alarmTime.day, alarmTime.hour, alarmTime.minute);
          break;
        case 'yearly':
          nextTrigger = DateTime(alarmTime.year + 1, alarmTime.month,
              alarmTime.day, alarmTime.hour, alarmTime.minute);
          break;
        case 'weekdays':
          nextTrigger = _getNextWeekday(alarmTime);
          break;
        case 'weekends':
          nextTrigger = _getNextWeekend(alarmTime);
          break;
        default:
          nextTrigger = alarmTime.add(const Duration(days: 1));
      }
    }

    return '${nextTrigger.day}/${nextTrigger.month}/${nextTrigger.year} at ${_formatTimeDisplay(TimeOfDay.fromDateTime(nextTrigger))}';
  }

  DateTime _getNextWeekday(DateTime alarmTime) {
    DateTime next = alarmTime.add(const Duration(days: 1));
    while (
        next.weekday == DateTime.saturday || next.weekday == DateTime.sunday) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  DateTime _getNextWeekend(DateTime alarmTime) {
    DateTime next = alarmTime.add(const Duration(days: 1));
    while (
        next.weekday != DateTime.saturday && next.weekday != DateTime.sunday) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onCancel,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.existingAlarm != null
                        ? 'Edit Alarm'
                        : 'Create Alarm',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: _saveAlarm,
                  child: Text(
                    'Save',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time selection
                    _buildSectionTitle('Time'),
                    GestureDetector(
                      onTap: _selectTime,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              size: 24,
                              color: AppTheme.primaryLight,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              _formatTimeDisplay(_selectedTime),
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            CustomIconWidget(
                              iconName: 'keyboard_arrow_right',
                              size: 24,
                              color: AppTheme.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Label input
                    _buildSectionTitle('Label'),
                    TextFormField(
                      controller: _labelController,
                      decoration: const InputDecoration(
                        hintText: 'Enter alarm label',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a label for the alarm';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Recurrence selection
                    _buildSectionTitle('Repeat'),
                    _buildDropdownField(
                      value: _selectedRecurrence,
                      items: _recurrenceOptions,
                      onChanged: (value) {
                        setState(() {
                          _selectedRecurrence = value!;
                        });
                      },
                      displayText: (value) {
                        switch (value) {
                          case 'once':
                            return 'Never';
                          case 'daily':
                            return 'Every day';
                          case 'weekly':
                            return 'Every week';
                          case 'monthly':
                            return 'Every month';
                          case 'yearly':
                            return 'Every year';
                          case 'weekdays':
                            return 'Weekdays (Mon-Fri)';
                          case 'weekends':
                            return 'Weekends (Sat-Sun)';
                          default:
                            return value;
                        }
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Priority and Task Type
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Priority'),
                              _buildDropdownField(
                                value: _selectedPriority,
                                items: _priorityOptions,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPriority = value!;
                                  });
                                },
                                displayText: (value) => value.toUpperCase(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Type'),
                              _buildDropdownField(
                                value: _selectedTaskType,
                                items: _taskTypeOptions,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTaskType = value!;
                                  });
                                },
                                displayText: (value) => value.toUpperCase(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Sound selection
                    _buildSectionTitle('Sound'),
                    _buildDropdownField(
                      value: _selectedSound,
                      items: _soundOptions,
                      onChanged: (value) {
                        setState(() {
                          _selectedSound = value!;
                        });
                      },
                      displayText: (value) {
                        switch (value) {
                          case 'default':
                            return 'Default';
                          case 'gentle_wake':
                            return 'Gentle Wake';
                          case 'classic_bell':
                            return 'Classic Bell';
                          case 'nature_sounds':
                            return 'Nature Sounds';
                          case 'digital_beep':
                            return 'Digital Beep';
                          case 'custom':
                            return 'Custom Sound';
                          default:
                            return value;
                        }
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Snooze settings
                    _buildSectionTitle('Snooze Settings'),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Snooze Interval',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Text(
                                '$_snoozeInterval minutes',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _snoozeInterval.toDouble(),
                            min: 1,
                            max: 60,
                            divisions: 59,
                            onChanged: (value) {
                              setState(() {
                                _snoozeInterval = value.round();
                              });
                            },
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Text(
                                'Max Snoozes',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Text(
                                '$_maxSnoozes times',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _maxSnoozes.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            onChanged: (value) {
                              setState(() {
                                _maxSnoozes = value.round();
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Additional settings
                    _buildSectionTitle('Additional Settings'),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: Column(
                        children: [
                          _buildSwitchRow(
                            'Gradual Volume Increase',
                            _gradualVolume,
                            (value) {
                              setState(() {
                                _gradualVolume = value;
                              });
                            },
                          ),
                          Divider(color: AppTheme.dividerLight),
                          _buildSwitchRow(
                            'Vibrate',
                            _vibrate,
                            (value) {
                              setState(() {
                                _vibrate = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String Function(String) displayText,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                displayText(item),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            size: 24,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
