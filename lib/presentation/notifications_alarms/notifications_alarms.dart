import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alarm_card_widget.dart';
import './widgets/alarm_creation_widget.dart';
import './widgets/alarm_statistics_widget.dart';
import './widgets/notification_preview_widget.dart';

class NotificationsAlarms extends StatefulWidget {
  const NotificationsAlarms({Key? key}) : super(key: key);

  @override
  State<NotificationsAlarms> createState() => _NotificationsAlarmsState();
}

class _NotificationsAlarmsState extends State<NotificationsAlarms>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isBulkEditMode = false;
  List<int> _selectedAlarmIds = [];
  String _searchQuery = '';
  String _filterBy = 'all';
  String _sortBy = 'time';

  final List<Map<String, dynamic>> _alarms = [
    {
      'id': 1,
      'time': '07:00',
      'label': 'Morning Workout',
      'recurrence': 'daily',
      'priority': 'high',
      'taskType': 'task',
      'sound': 'gentle_wake',
      'snoozeInterval': 5,
      'maxSnoozes': 3,
      'gradualVolume': true,
      'vibrate': true,
      'enabled': true,
      'createdAt': '2025-08-20T10:30:00.000Z',
      'nextTrigger': '22/08/2025 at 7:00 AM',
      'completedOnTime': true,
      'snoozedOnce': false,
    },
    {
      'id': 2,
      'time': '09:30',
      'label': 'Team Meeting - Project Review',
      'recurrence': 'weekdays',
      'priority': 'high',
      'taskType': 'meeting',
      'sound': 'classic_bell',
      'snoozeInterval': 10,
      'maxSnoozes': 2,
      'gradualVolume': false,
      'vibrate': true,
      'enabled': true,
      'createdAt': '2025-08-19T15:45:00.000Z',
      'nextTrigger': '22/08/2025 at 9:30 AM',
      'completedOnTime': false,
      'snoozedOnce': true,
    },
    {
      'id': 3,
      'time': '14:00',
      'label': 'Project Deadline Reminder',
      'recurrence': 'once',
      'priority': 'high',
      'taskType': 'reminder',
      'sound': 'digital_beep',
      'snoozeInterval': 15,
      'maxSnoozes': 1,
      'gradualVolume': true,
      'vibrate': true,
      'enabled': false,
      'createdAt': '2025-08-18T09:15:00.000Z',
      'nextTrigger': '22/08/2025 at 2:00 PM',
      'completedOnTime': false,
      'snoozedOnce': false,
    },
    {
      'id': 4,
      'time': '18:30',
      'label': 'Dinner with Family',
      'recurrence': 'daily',
      'priority': 'normal',
      'taskType': 'reminder',
      'sound': 'nature_sounds',
      'snoozeInterval': 5,
      'maxSnoozes': 2,
      'gradualVolume': true,
      'vibrate': false,
      'enabled': true,
      'createdAt': '2025-08-17T12:00:00.000Z',
      'nextTrigger': '21/08/2025 at 6:30 PM',
      'completedOnTime': true,
      'snoozedOnce': false,
    },
    {
      'id': 5,
      'time': '22:00',
      'label': 'Bedtime Routine',
      'recurrence': 'daily',
      'priority': 'low',
      'taskType': 'reminder',
      'sound': 'gentle_wake',
      'snoozeInterval': 10,
      'maxSnoozes': 1,
      'gradualVolume': true,
      'vibrate': false,
      'enabled': true,
      'createdAt': '2025-08-16T20:30:00.000Z',
      'nextTrigger': '21/08/2025 at 10:00 PM',
      'completedOnTime': true,
      'snoozedOnce': false,
    },
    {
      'id': 6,
      'time': '12:00',
      'label': 'Mom\'s Birthday Call',
      'recurrence': 'yearly',
      'priority': 'high',
      'taskType': 'birthday',
      'sound': 'default',
      'snoozeInterval': 30,
      'maxSnoozes': 5,
      'gradualVolume': false,
      'vibrate': true,
      'enabled': true,
      'createdAt': '2025-01-15T08:00:00.000Z',
      'nextTrigger': '15/01/2026 at 12:00 PM',
      'completedOnTime': true,
      'snoozedOnce': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAlarms {
    List<Map<String, dynamic>> filtered = List.from(_alarms);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((alarm) {
        final label = (alarm['label'] as String).toLowerCase();
        final taskType = (alarm['taskType'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return label.contains(query) || taskType.contains(query);
      }).toList();
    }

    // Apply category filter
    switch (_filterBy) {
      case 'enabled':
        filtered = filtered.where((alarm) => alarm['enabled'] == true).toList();
        break;
      case 'disabled':
        filtered =
            filtered.where((alarm) => alarm['enabled'] == false).toList();
        break;
      case 'high_priority':
        filtered =
            filtered.where((alarm) => alarm['priority'] == 'high').toList();
        break;
      case 'recurring':
        filtered =
            filtered.where((alarm) => alarm['recurrence'] != 'once').toList();
        break;
    }

    // Apply sorting
    switch (_sortBy) {
      case 'time':
        filtered.sort(
            (a, b) => (a['time'] as String).compareTo(b['time'] as String));
        break;
      case 'priority':
        final priorityOrder = {'high': 0, 'normal': 1, 'low': 2};
        filtered.sort((a, b) => priorityOrder[a['priority']]!
            .compareTo(priorityOrder[b['priority']]!));
        break;
      case 'created':
        filtered.sort((a, b) =>
            (b['createdAt'] as String).compareTo(a['createdAt'] as String));
        break;
    }

    return filtered;
  }

  void _toggleAlarm(Map<String, dynamic> alarm) {
    setState(() {
      final index = _alarms.indexWhere((a) => a['id'] == alarm['id']);
      if (index != -1) {
        _alarms[index] = alarm;
      }
    });

    final status = alarm['enabled'] ? 'enabled' : 'disabled';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm ${alarm['label']} $status'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editAlarm(Map<String, dynamic> alarm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlarmCreationWidget(
        existingAlarm: alarm,
        onSave: (updatedAlarm) {
          setState(() {
            final index =
                _alarms.indexWhere((a) => a['id'] == updatedAlarm['id']);
            if (index != -1) {
              _alarms[index] = updatedAlarm;
            }
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Alarm "${updatedAlarm['label']}" updated'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _duplicateAlarm(Map<String, dynamic> alarm) {
    final duplicatedAlarm = Map<String, dynamic>.from(alarm);
    duplicatedAlarm['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedAlarm['label'] = '${alarm['label']} (Copy)';
    duplicatedAlarm['createdAt'] = DateTime.now().toIso8601String();

    setState(() {
      _alarms.add(duplicatedAlarm);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm duplicated: ${duplicatedAlarm['label']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _testSound(Map<String, dynamic> alarm) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing sound: ${alarm['sound']}'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Stop',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _deleteAlarm(Map<String, dynamic> alarm) {
    setState(() {
      _alarms.removeWhere((a) => a['id'] == alarm['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm "${alarm['label']}" deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _alarms.add(alarm);
            });
          },
        ),
      ),
    );
  }

  void _createNewAlarm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlarmCreationWidget(
        onSave: (newAlarm) {
          setState(() {
            _alarms.add(newAlarm);
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Alarm "${newAlarm['label']}" created'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _showNotificationPreview(Map<String, dynamic> alarm) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: NotificationPreviewWidget(
          alarm: alarm,
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showStatistics() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlarmStatisticsWidget(
        alarms: _alarms,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _toggleBulkEdit() {
    setState(() {
      _isBulkEditMode = !_isBulkEditMode;
      if (!_isBulkEditMode) {
        _selectedAlarmIds.clear();
      }
    });
  }

  void _bulkDeleteSelected() {
    if (_selectedAlarmIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Selected Alarms',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete ${_selectedAlarmIds.length} selected alarm(s)? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _alarms.removeWhere(
                    (alarm) => _selectedAlarmIds.contains(alarm['id']));
                _selectedAlarmIds.clear();
                _isBulkEditMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selected alarms deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bulkToggleSelected() {
    if (_selectedAlarmIds.isEmpty) return;

    setState(() {
      for (int i = 0; i < _alarms.length; i++) {
        if (_selectedAlarmIds.contains(_alarms[i]['id'])) {
          _alarms[i]['enabled'] = !(_alarms[i]['enabled'] as bool);
        }
      }
      _selectedAlarmIds.clear();
      _isBulkEditMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selected alarms toggled'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAlarms = _filteredAlarms;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications & Alarms',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          if (_isBulkEditMode) ...[
            if (_selectedAlarmIds.isNotEmpty) ...[
              IconButton(
                onPressed: _bulkToggleSelected,
                icon: CustomIconWidget(
                  iconName: 'toggle_on',
                  size: 24,
                  color: AppTheme.primaryLight,
                ),
              ),
              IconButton(
                onPressed: _bulkDeleteSelected,
                icon: CustomIconWidget(
                  iconName: 'delete',
                  size: 24,
                  color: AppTheme.error,
                ),
              ),
            ],
            TextButton(
              onPressed: _toggleBulkEdit,
              child: Text(
                'Done',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _showStatistics,
              icon: CustomIconWidget(
                iconName: 'analytics',
                size: 24,
                color: AppTheme.textPrimary,
              ),
            ),
            IconButton(
              onPressed: _toggleBulkEdit,
              icon: CustomIconWidget(
                iconName: 'edit',
                size: 24,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Alarms'),
            Tab(text: 'Upcoming'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and filter bar
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search alarms...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        size: 20,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              size: 20,
                              color: AppTheme.textSecondary,
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),

                SizedBox(height: 2.h),

                // Filter and sort options
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildSortDropdown(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Alarms tab
                _buildAlarmsList(filteredAlarms),

                // Upcoming tab
                _buildAlarmsList(
                  filteredAlarms
                      .where((alarm) => alarm['enabled'] == true)
                      .toList(),
                ),

                // History tab
                _buildHistoryList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewAlarm,
        child: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _filterBy,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All')),
            DropdownMenuItem(value: 'enabled', child: Text('Enabled')),
            DropdownMenuItem(value: 'disabled', child: Text('Disabled')),
            DropdownMenuItem(
                value: 'high_priority', child: Text('High Priority')),
            DropdownMenuItem(value: 'recurring', child: Text('Recurring')),
          ],
          onChanged: (value) {
            setState(() {
              _filterBy = value!;
            });
          },
          icon: CustomIconWidget(
            iconName: 'filter_list',
            size: 20,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'time', child: Text('Time')),
            DropdownMenuItem(value: 'priority', child: Text('Priority')),
            DropdownMenuItem(value: 'created', child: Text('Created')),
          ],
          onChanged: (value) {
            setState(() {
              _sortBy = value!;
            });
          },
          icon: CustomIconWidget(
            iconName: 'sort',
            size: 20,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAlarmsList(List<Map<String, dynamic>> alarms) {
    if (alarms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'alarm_off',
              size: 64,
              color: AppTheme.textDisabled,
            ),
            SizedBox(height: 2.h),
            Text(
              'No alarms found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textDisabled,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Create your first alarm to get started',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: alarms.length,
      itemBuilder: (context, index) {
        final alarm = alarms[index];
        final isSelected = _selectedAlarmIds.contains(alarm['id']);

        return GestureDetector(
          onTap: _isBulkEditMode
              ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedAlarmIds.remove(alarm['id']);
                    } else {
                      _selectedAlarmIds.add(alarm['id'] as int);
                    }
                  });
                }
              : null,
          onLongPress: () {
            _showNotificationPreview(alarm);
          },
          child: Stack(
            children: [
              AlarmCardWidget(
                alarm: alarm,
                onToggle: _toggleAlarm,
                onEdit: _editAlarm,
                onDuplicate: _duplicateAlarm,
                onTestSound: _testSound,
                onDelete: _deleteAlarm,
              ),
              if (_isBulkEditMode)
                Positioned(
                  top: 2.h,
                  right: 6.w,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryLight
                            : AppTheme.borderLight,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    final historyItems = [
      {
        'date': '2025-08-21',
        'time': '07:00',
        'label': 'Morning Workout',
        'status': 'completed',
        'snoozes': 0,
      },
      {
        'date': '2025-08-21',
        'time': '09:30',
        'label': 'Team Meeting',
        'status': 'snoozed',
        'snoozes': 1,
      },
      {
        'date': '2025-08-20',
        'time': '22:00',
        'label': 'Bedtime Reminder',
        'status': 'completed',
        'snoozes': 0,
      },
      {
        'date': '2025-08-20',
        'time': '14:00',
        'label': 'Project Deadline',
        'status': 'missed',
        'snoozes': 3,
      },
    ];

    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: historyItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.h),
      itemBuilder: (context, index) {
        final item = historyItems[index];
        final status = item['status'] as String;
        final snoozes = item['snoozes'] as int;

        Color statusColor;
        String statusIcon;

        switch (status) {
          case 'completed':
            statusColor = AppTheme.success;
            statusIcon = 'check_circle';
            break;
          case 'snoozed':
            statusColor = AppTheme.warning;
            statusIcon = 'snooze';
            break;
          case 'missed':
            statusColor = AppTheme.error;
            statusIcon = 'cancel';
            break;
          default:
            statusColor = AppTheme.textSecondary;
            statusIcon = 'help';
        }

        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
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
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: statusIcon,
                  size: 24,
                  color: statusColor,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['label'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${item['date']} at ${item['time']}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (snoozes > 0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$snoozes snooze${snoozes > 1 ? 's' : ''}',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.warning,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
