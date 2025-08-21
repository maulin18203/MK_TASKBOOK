import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selector.dart';
import './widgets/description_field.dart';
import './widgets/due_date_field.dart';
import './widgets/fast_completion_toggle.dart';
import './widgets/priority_picker.dart';
import './widgets/recurring_task_section.dart';
import './widgets/reminder_settings.dart';
import './widgets/task_form_header.dart';
import './widgets/task_title_field.dart';
import './widgets/time_estimation_slider.dart';

class TaskCreationEdit extends StatefulWidget {
  const TaskCreationEdit({Key? key}) : super(key: key);

  @override
  State<TaskCreationEdit> createState() => _TaskCreationEditState();
}

class _TaskCreationEditState extends State<TaskCreationEdit> {
  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Form state
  String _selectedCategory = 'Daily';
  String _selectedPriority = 'Normal';
  DateTime? _selectedDate;
  double _timeEstimation = 30.0; // minutes
  bool _isFastCompletion = false;
  bool _isRecurring = false;
  String _recurringFrequency = 'Daily';
  int _customInterval = 1;
  List<String> _selectedReminders = [];

  // UI state
  bool _isFormValid = false;
  bool _isVoiceInputActive = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _descriptionController.addListener(_limitDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _titleController.text.trim().isNotEmpty;
    });
  }

  void _limitDescription() {
    if (_descriptionController.text.length > 500) {
      _descriptionController.text =
          _descriptionController.text.substring(0, 500);
      _descriptionController.selection = TextSelection.fromPosition(
        TextPosition(offset: _descriptionController.text.length),
      );
    }
  }

  void _handleVoiceInput() async {
    setState(() {
      _isVoiceInputActive = true;
    });

    // Simulate voice input processing
    await Future.delayed(Duration(seconds: 2));

    // Mock voice input result - in real app, this would use speech recognition
    final mockVoiceResults = [
      "Meeting with client tomorrow at 3pm high priority",
      "Buy groceries today normal priority",
      "Complete project report next week high priority",
      "Call dentist for appointment low priority",
      "Review quarterly budget monthly high priority"
    ];

    final randomResult =
        mockVoiceResults[DateTime.now().millisecond % mockVoiceResults.length];

    // Parse voice input (simplified parsing)
    _parseVoiceInput(randomResult);

    setState(() {
      _isVoiceInputActive = false;
    });

    Fluttertoast.showToast(
      msg: "Voice input processed: \"$randomResult\"",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _parseVoiceInput(String voiceText) {
    final text = voiceText.toLowerCase();

    // Extract title (first part before time/priority keywords)
    String title = voiceText;
    if (text.contains(' at ') || text.contains(' priority')) {
      final parts =
          text.split(RegExp(r' at | priority| tomorrow| today| next week'));
      title = parts[0].trim();
      title = title[0].toUpperCase() + title.substring(1);
    }

    setState(() {
      _titleController.text = title;

      // Parse priority
      if (text.contains('high priority')) {
        _selectedPriority = 'High';
      } else if (text.contains('low priority')) {
        _selectedPriority = 'Low';
      } else {
        _selectedPriority = 'Normal';
      }

      // Parse date
      if (text.contains('today')) {
        _selectedDate = DateTime.now();
      } else if (text.contains('tomorrow')) {
        _selectedDate = DateTime.now().add(Duration(days: 1));
      } else if (text.contains('next week')) {
        _selectedDate = DateTime.now().add(Duration(days: 7));
      }

      // Parse category based on keywords
      if (text.contains('monthly') || text.contains('quarterly')) {
        _selectedCategory = 'Monthly';
      } else if (text.contains('yearly') || text.contains('annual')) {
        _selectedCategory = 'Yearly';
      } else {
        _selectedCategory = 'Daily';
      }
    });
  }

  void _handleSave() {
    if (!_isFormValid) return;

    // Calculate effective weight
    double priorityValue = _selectedPriority == 'High'
        ? 3.0
        : _selectedPriority == 'Normal'
            ? 2.0
            : 1.0;

    double deadlineUrgency = 1.0;
    if (_selectedDate != null) {
      final daysUntilDue = _selectedDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue <= 1) {
        deadlineUrgency = 3.0;
      } else if (daysUntilDue <= 3) {
        deadlineUrgency = 2.5;
      } else if (daysUntilDue <= 7) {
        deadlineUrgency = 2.0;
      } else {
        deadlineUrgency = 1.5;
      }
    }

    double timeFactor = _timeEstimation / 60;
    double effectiveWeight = priorityValue + (deadlineUrgency * timeFactor);

    // Create task data
    final taskData = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _selectedCategory,
      'priority': _selectedPriority,
      'dueDate': _selectedDate?.toIso8601String(),
      'timeEstimation': _timeEstimation,
      'effectiveWeight': effectiveWeight,
      'isFastCompletion': _isFastCompletion && _timeEstimation <= 15,
      'isRecurring': _isRecurring,
      'recurringFrequency': _isRecurring ? _recurringFrequency : null,
      'customInterval': _isRecurring ? _customInterval : null,
      'reminders': _selectedReminders,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Show success message
    Fluttertoast.showToast(
      msg: "Task created successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: Colors.white,
    );

    // Navigate back
    Navigator.pop(context, taskData);
  }

  void _handleCancel() {
    if (_titleController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Discard Changes?',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to discard them?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close screen
              },
              child: Text(
                'Discard',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _isVoiceInputActive
          ? Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      TaskFormHeader(
                        onCancel: _handleCancel,
                        onSave: _handleSave,
                        isSaveEnabled: _isFormValid,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TaskTitleField(
                                controller: _titleController,
                                onVoiceInput: _handleVoiceInput,
                                onChanged: (value) => _validateForm(),
                              ),
                              CategorySelector(
                                selectedCategory: _selectedCategory,
                                onCategoryChanged: (category) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                              ),
                              PriorityPicker(
                                selectedPriority: _selectedPriority,
                                onPriorityChanged: (priority) {
                                  setState(() {
                                    _selectedPriority = priority;
                                  });
                                },
                              ),
                              DueDateField(
                                selectedDate: _selectedDate,
                                onDateChanged: (date) {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                },
                              ),
                              TimeEstimationSlider(
                                timeEstimation: _timeEstimation,
                                onTimeChanged: (time) {
                                  setState(() {
                                    _timeEstimation = time;
                                    if (time > 15) {
                                      _isFastCompletion = false;
                                    }
                                  });
                                },
                                selectedPriority: _selectedPriority,
                                dueDate: _selectedDate,
                              ),
                              DescriptionField(
                                controller: _descriptionController,
                                onChanged: (value) => setState(() {}),
                              ),
                              FastCompletionToggle(
                                isFastCompletion: _isFastCompletion,
                                onToggleChanged: (value) {
                                  setState(() {
                                    _isFastCompletion = value;
                                  });
                                  if (value) {
                                    HapticFeedback.lightImpact();
                                  }
                                },
                                timeEstimation: _timeEstimation,
                              ),
                              RecurringTaskSection(
                                isRecurring: _isRecurring,
                                recurringFrequency: _recurringFrequency,
                                customInterval: _customInterval,
                                onRecurringToggle: (value) {
                                  setState(() {
                                    _isRecurring = value;
                                  });
                                },
                                onFrequencyChanged: (frequency) {
                                  setState(() {
                                    _recurringFrequency = frequency;
                                  });
                                },
                                onIntervalChanged: (interval) {
                                  setState(() {
                                    _customInterval = interval;
                                  });
                                },
                              ),
                              ReminderSettings(
                                selectedReminders: _selectedReminders,
                                onRemindersChanged: (reminders) {
                                  setState(() {
                                    _selectedReminders = reminders;
                                  });
                                },
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'mic',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 32,
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Listening...',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Say something like "Meeting tomorrow at 3pm high priority"',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SafeArea(
              child: Column(
                children: [
                  TaskFormHeader(
                    onCancel: _handleCancel,
                    onSave: _handleSave,
                    isSaveEnabled: _isFormValid,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaskTitleField(
                            controller: _titleController,
                            onVoiceInput: _handleVoiceInput,
                            onChanged: (value) => _validateForm(),
                          ),
                          CategorySelector(
                            selectedCategory: _selectedCategory,
                            onCategoryChanged: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                          PriorityPicker(
                            selectedPriority: _selectedPriority,
                            onPriorityChanged: (priority) {
                              setState(() {
                                _selectedPriority = priority;
                              });
                            },
                          ),
                          DueDateField(
                            selectedDate: _selectedDate,
                            onDateChanged: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                          ),
                          TimeEstimationSlider(
                            timeEstimation: _timeEstimation,
                            onTimeChanged: (time) {
                              setState(() {
                                _timeEstimation = time;
                                if (time > 15) {
                                  _isFastCompletion = false;
                                }
                              });
                            },
                            selectedPriority: _selectedPriority,
                            dueDate: _selectedDate,
                          ),
                          DescriptionField(
                            controller: _descriptionController,
                            onChanged: (value) => setState(() {}),
                          ),
                          FastCompletionToggle(
                            isFastCompletion: _isFastCompletion,
                            onToggleChanged: (value) {
                              setState(() {
                                _isFastCompletion = value;
                              });
                              if (value) {
                                HapticFeedback.lightImpact();
                              }
                            },
                            timeEstimation: _timeEstimation,
                          ),
                          RecurringTaskSection(
                            isRecurring: _isRecurring,
                            recurringFrequency: _recurringFrequency,
                            customInterval: _customInterval,
                            onRecurringToggle: (value) {
                              setState(() {
                                _isRecurring = value;
                              });
                            },
                            onFrequencyChanged: (frequency) {
                              setState(() {
                                _recurringFrequency = frequency;
                              });
                            },
                            onIntervalChanged: (interval) {
                              setState(() {
                                _customInterval = interval;
                              });
                            },
                          ),
                          ReminderSettings(
                            selectedReminders: _selectedReminders,
                            onRemindersChanged: (reminders) {
                              setState(() {
                                _selectedReminders = reminders;
                              });
                            },
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}