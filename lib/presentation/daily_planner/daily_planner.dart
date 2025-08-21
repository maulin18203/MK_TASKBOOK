import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calendar_picker_widget.dart';
import './widgets/date_header_widget.dart';
import './widgets/empty_time_slot_widget.dart';
import './widgets/time_block_widget.dart';
import './widgets/timeline_widget.dart';

class DailyPlanner extends StatefulWidget {
  const DailyPlanner({Key? key}) : super(key: key);

  @override
  State<DailyPlanner> createState() => _DailyPlannerState();
}

class _DailyPlannerState extends State<DailyPlanner> {
  DateTime _selectedDate = DateTime.now();
  bool _isCalendarExpanded = false;
  final ScrollController _scrollController = ScrollController();

  // Mock data for predefined time blocks
  final List<Map<String, dynamic>> _predefinedBlocks = [
    {
      'id': 1,
      'startTime': '6:00 AM',
      'endTime': '6:30 AM',
      'title': 'Wake-Up',
      'hasAlarm': true,
      'isCustom': false,
      'tasks': []
    },
    {
      'id': 2,
      'startTime': '6:30 AM',
      'endTime': '7:30 AM',
      'title': 'Morning Routine',
      'hasAlarm': true,
      'isCustom': false,
      'tasks': [
        {'id': 1, 'title': 'Brush teeth', 'isCompleted': true},
        {'id': 2, 'title': 'Exercise', 'isCompleted': false},
        {'id': 3, 'title': 'Meditation', 'isCompleted': false},
      ]
    },
    {
      'id': 3,
      'startTime': '7:30 AM',
      'endTime': '8:00 AM',
      'title': 'Breakfast',
      'hasAlarm': false,
      'isCustom': false,
      'tasks': []
    },
    {
      'id': 4,
      'startTime': '9:00 AM',
      'endTime': '12:00 PM',
      'title': 'Class/Work',
      'hasAlarm': true,
      'isCustom': false,
      'tasks': [
        {'id': 4, 'title': 'Team meeting', 'isCompleted': false},
        {'id': 5, 'title': 'Review project proposal', 'isCompleted': true},
        {'id': 6, 'title': 'Client presentation', 'isCompleted': false},
      ]
    },
    {
      'id': 5,
      'startTime': '2:00 PM',
      'endTime': '4:00 PM',
      'title': 'Project Work',
      'hasAlarm': false,
      'isCustom': false,
      'tasks': [
        {'id': 7, 'title': 'Code review', 'isCompleted': false},
        {'id': 8, 'title': 'Bug fixes', 'isCompleted': false},
      ]
    },
    {
      'id': 6,
      'startTime': '4:30 PM',
      'endTime': '6:00 PM',
      'title': 'Personal Work',
      'hasAlarm': false,
      'isCustom': false,
      'tasks': [
        {'id': 9, 'title': 'Read articles', 'isCompleted': true},
        {'id': 10, 'title': 'Update portfolio', 'isCompleted': false},
      ]
    },
    {
      'id': 7,
      'startTime': '12:00 PM',
      'endTime': '1:00 PM',
      'title': 'Lunch',
      'hasAlarm': false,
      'isCustom': false,
      'tasks': []
    },
    {
      'id': 8,
      'startTime': '7:00 PM',
      'endTime': '8:00 PM',
      'title': 'Dinner',
      'hasAlarm': false,
      'isCustom': false,
      'tasks': []
    },
    {
      'id': 9,
      'startTime': '8:30 PM',
      'endTime': '10:00 PM',
      'title': 'Relaxation',
      'hasAlarm': false,
      'isCustom': false,
      'tasks': [
        {'id': 11, 'title': 'Watch Netflix', 'isCompleted': false},
        {'id': 12, 'title': 'Listen to music', 'isCompleted': false},
      ]
    },
    {
      'id': 10,
      'startTime': '10:30 PM',
      'endTime': '6:00 AM',
      'title': 'Sleep',
      'hasAlarm': true,
      'isCustom': false,
      'tasks': []
    },
  ];

  List<Map<String, dynamic>> _customBlocks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTime() {
    if (!_isToday(_selectedDate)) return;

    final now = DateTime.now();
    final currentHour = now.hour;
    final scrollOffset = (currentHour * 8.h) - (20.h);

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        scrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isCurrentTimeBlock(Map<String, dynamic> block) {
    if (!_isToday(_selectedDate)) return false;

    final now = DateTime.now();
    final startTime = _parseTime(block['startTime'] as String);
    final endTime = _parseTime(block['endTime'] as String);

    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    var endMinutes = endTime.hour * 60 + endTime.minute;

    // Handle overnight blocks (like sleep)
    if (endMinutes < startMinutes) {
      endMinutes += 24 * 60;
    }

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  DateTime _parseTime(String timeString) {
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    var hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1] == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return DateTime(2023, 1, 1, hour, minute);
  }

  void _onPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _onNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  void _onTodayTap() {
    setState(() {
      _selectedDate = DateTime.now();
    });
    _scrollToCurrentTime();
  }

  void _onDateTap() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _isCalendarExpanded = false;
    });
    if (_isToday(date)) {
      _scrollToCurrentTime();
    }
  }

  void _onTimeBlockTap(Map<String, dynamic> block) {
    _showTimeBlockDialog(block);
  }

  void _onTimeBlockLongPress(Map<String, dynamic> block) {
    _showContextMenu(block);
  }

  void _showTimeBlockDialog(Map<String, dynamic> block) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          block['title'] as String,
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time: ${block['startTime']} - ${block['endTime']}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            if ((block['tasks'] as List).isNotEmpty) ...[
              Text(
                'Tasks:',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              ...(block['tasks'] as List)
                  .map((task) => Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: (task['isCompleted'] as bool)
                                  ? 'check_circle'
                                  : 'radio_button_unchecked',
                              color: (task['isCompleted'] as bool)
                                  ? AppTheme.success
                                  : AppTheme.lightTheme.colorScheme.outline,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                task['title'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to task creation/edit
              Navigator.pushNamed(context, '/task-creation-edit');
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> block) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              block['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              icon: 'content_copy',
              title: 'Duplicate',
              onTap: () {
                Navigator.pop(context);
                _duplicateBlock(block);
              },
            ),
            _buildContextMenuItem(
              icon: 'edit',
              title: 'Edit',
              onTap: () {
                Navigator.pop(context);
                _showTimeBlockDialog(block);
              },
            ),
            _buildContextMenuItem(
              icon: 'alarm',
              title: (block['hasAlarm'] as bool) ? 'Remove Alarm' : 'Set Alarm',
              onTap: () {
                Navigator.pop(context);
                _toggleAlarm(block);
              },
            ),
            if (block['isCustom'] as bool)
              _buildContextMenuItem(
                icon: 'delete',
                title: 'Delete',
                onTap: () {
                  Navigator.pop(context);
                  _deleteBlock(block);
                },
                isDestructive: true,
              ),
            _buildContextMenuItem(
              icon: 'save',
              title: 'Set as Template',
              onTap: () {
                Navigator.pop(context);
                _saveAsTemplate(block);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? AppTheme.error : null,
        ),
      ),
      onTap: onTap,
    );
  }

  void _duplicateBlock(Map<String, dynamic> block) {
    // Implementation for duplicating block
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Block duplicated')),
    );
  }

  void _toggleAlarm(Map<String, dynamic> block) {
    setState(() {
      block['hasAlarm'] = !(block['hasAlarm'] as bool);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          (block['hasAlarm'] as bool) ? 'Alarm set' : 'Alarm removed',
        ),
      ),
    );
  }

  void _deleteBlock(Map<String, dynamic> block) {
    setState(() {
      _customBlocks.removeWhere((b) => b['id'] == block['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Block deleted')),
    );
  }

  void _saveAsTemplate(Map<String, dynamic> block) {
    // Implementation for saving as template
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved as template')),
    );
  }

  void _onAddActivity(String timeSlot) {
    _showAddActivityDialog(timeSlot);
  }

  void _showAddActivityDialog(String timeSlot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Time: $timeSlot'),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Activity Name',
                hintText: 'Enter activity name',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addCustomBlock(timeSlot);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addCustomBlock(String timeSlot) {
    final newBlock = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'startTime': timeSlot,
      'endTime':
          '${int.parse(timeSlot.split(':')[0]) + 1}:00 ${timeSlot.contains('AM') ? 'AM' : 'PM'}',
      'title': 'Custom Activity',
      'hasAlarm': false,
      'isCustom': true,
      'tasks': [],
    };

    setState(() {
      _customBlocks.add(newBlock);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activity added')),
    );
  }

  List<Map<String, dynamic>> _getAllBlocks() {
    final allBlocks = [..._predefinedBlocks, ..._customBlocks];
    allBlocks.sort((a, b) {
      final aTime = _parseTime(a['startTime'] as String);
      final bTime = _parseTime(b['startTime'] as String);
      return aTime.compareTo(bTime);
    });
    return allBlocks;
  }

  List<String> _getEmptyTimeSlots() {
    final emptySlots = <String>[];
    final allBlocks = _getAllBlocks();

    for (int hour = 0; hour < 24; hour++) {
      final timeSlot = _formatHour(hour);
      final hasBlock = allBlocks.any((block) {
        final startTime = _parseTime(block['startTime'] as String);
        return startTime.hour == hour;
      });

      if (!hasBlock) {
        emptySlots.add(timeSlot);
      }
    }

    return emptySlots;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  @override
  Widget build(BuildContext context) {
    final allBlocks = _getAllBlocks();
    final emptySlots = _getEmptyTimeSlots();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '📓',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 2.w),
            Text(
              'Daily Planner',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/notifications-alarms'),
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/task-management'),
            icon: CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          DateHeaderWidget(
            selectedDate: _selectedDate,
            onPreviousDay: _onPreviousDay,
            onNextDay: _onNextDay,
            onTodayTap: _onTodayTap,
            onDateTap: _onDateTap,
          ),
          CalendarPickerWidget(
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelected,
            isExpanded: _isCalendarExpanded,
          ),
          if (_isCalendarExpanded) SizedBox(height: 2.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimelineWidget(currentTime: DateTime.now()),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Column(
                      children: [
                        ...allBlocks
                            .map((block) => TimeBlockWidget(
                                  timeBlock: block,
                                  onTap: () => _onTimeBlockTap(block),
                                  onLongPress: () =>
                                      _onTimeBlockLongPress(block),
                                  isCurrentTime: _isCurrentTimeBlock(block),
                                  tasks: (block['tasks'] as List)
                                      .cast<Map<String, dynamic>>(),
                                ))
                            .toList(),
                        ...emptySlots
                            .map((slot) => EmptyTimeSlotWidget(
                                  timeSlot: slot,
                                  onAddActivity: () => _onAddActivity(slot),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivityDialog('Custom Time'),
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
