import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/daily_planner_preview_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/priority_task_card_widget.dart';
import './widgets/progress_card_widget.dart';
import './widgets/queue_visualization_widget.dart';
import './widgets/quick_actions_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  bool _isLoading = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Alex Johnson",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "streakCount": 7,
    "completionPercentage": 68.0,
  };

  // Mock priority tasks data
  final List<Map<String, dynamic>> _priorityTasks = [
    {
      "id": 1,
      "title": "Complete Project Proposal",
      "description":
          "Finalize the quarterly project proposal for client presentation",
      "priority": "high",
      "category": "Work",
      "dueTime": "2:00 PM",
      "isCompleted": false,
      "effectiveWeight": 95.5,
    },
    {
      "id": 2,
      "title": "Review Team Performance",
      "description": "Conduct monthly performance review with team members",
      "priority": "normal",
      "category": "Management",
      "dueTime": "4:30 PM",
      "isCompleted": false,
      "effectiveWeight": 78.2,
    },
    {
      "id": 3,
      "title": "Update Portfolio Website",
      "description": "Add recent projects and update skills section",
      "priority": "low",
      "category": "Personal",
      "dueTime": "Evening",
      "isCompleted": false,
      "effectiveWeight": 45.8,
    },
  ];

  // Mock daily planner data
  final Map<String, dynamic> _currentTimeBlock = {
    "time": "2:00 PM - 4:00 PM",
    "activity": "Project Work",
    "description":
        "Focus time for completing high-priority tasks and deep work sessions",
  };

  final Map<String, dynamic> _nextTimeBlock = {
    "time": "4:00 PM - 5:00 PM",
    "activity": "Team Meeting",
    "description": "Weekly sync with development team",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child:
            _priorityTasks.isEmpty ? _buildEmptyState() : _buildMainContent(),
      ),
      floatingActionButton:
          _priorityTasks.isNotEmpty ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      onAddFirstTask: _showTaskCreationBottomSheet,
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingHeaderWidget(
                  userName: _userData['name'] as String,
                  userAvatar: _userData['avatar'] as String,
                  onSettingsTap: _navigateToSettings,
                ),
                ProgressCardWidget(
                  completionPercentage:
                      _userData['completionPercentage'] as double,
                  streakCount: _userData['streakCount'] as int,
                ),
                SizedBox(height: 2.h),
                _buildPriorityTasksSection(),
                SizedBox(height: 2.h),
                DailyPlannerPreviewWidget(
                  currentTimeBlock: _currentTimeBlock,
                  nextTimeBlock: _nextTimeBlock,
                  onViewPlanner: _navigateToPlanner,
                ),
                SizedBox(height: 2.h),
                QueueVisualizationWidget(
                  totalTasks: _priorityTasks.length,
                  priorityTasks: _priorityTasks
                      .where((task) =>
                          (task['priority'] as String).toLowerCase() == 'high')
                      .length,
                  normalTasks: _priorityTasks
                      .where((task) =>
                          (task['priority'] as String).toLowerCase() ==
                          'normal')
                      .length,
                  lowTasks: _priorityTasks
                      .where((task) =>
                          (task['priority'] as String).toLowerCase() == 'low')
                      .length,
                  onQueueManagerTap: _navigateToTaskManagement,
                ),
                SizedBox(height: 2.h),
                QuickActionsWidget(
                  onAddTask: _showTaskCreationBottomSheet,
                  onStartTimer: _startTimer,
                  onViewPlanner: _navigateToPlanner,
                  onQueueManager: _navigateToTaskManagement,
                ),
                SizedBox(height: 10.h), // Space for FAB
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Text(
                'Priority Tasks',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _navigateToTaskManagement,
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _priorityTasks.length,
            itemBuilder: (context, index) {
              final task = _priorityTasks[index];
              return PriorityTaskCardWidget(
                task: task,
                onComplete: () => _toggleTaskCompletion(index),
                onTap: () => _navigateToTaskDetails(task),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showTaskCreationBottomSheet,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: Colors.white,
      icon: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 6.w,
      ),
      label: Text(
        'Add Task',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      // Update completion percentage based on completed tasks
      final completedTasks =
          _priorityTasks.where((task) => task['isCompleted'] as bool).length;
      _userData['completionPercentage'] = _priorityTasks.isNotEmpty
          ? (completedTasks / _priorityTasks.length * 100).toDouble()
          : 0.0;
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _priorityTasks[index]['isCompleted'] =
          !(_priorityTasks[index]['isCompleted'] as bool);

      // Update completion percentage
      final completedTasks =
          _priorityTasks.where((task) => task['isCompleted'] as bool).length;
      _userData['completionPercentage'] =
          (completedTasks / _priorityTasks.length * 100).toDouble();

      // Update streak if task completed
      if (_priorityTasks[index]['isCompleted'] as bool) {
        _userData['streakCount'] = (_userData['streakCount'] as int) + 1;
      }
    });

    // Show completion feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _priorityTasks[index]['isCompleted'] as bool
              ? 'Task completed! Great job! 🎉'
              : 'Task marked as pending',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTaskCreationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    'Create New Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'mic',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 6.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Tap to use voice input for quick task creation',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/task-creation-edit');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 2.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Open Task Creator',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToTaskManagement() {
    Navigator.pushNamed(context, '/task-management');
  }

  void _navigateToPlanner() {
    Navigator.pushNamed(context, '/daily-planner');
  }

  void _navigateToTaskDetails(Map<String, dynamic> task) {
    Navigator.pushNamed(
      context,
      '/task-creation-edit',
      arguments: task,
    );
  }

  void _startTimer() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'timer',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            const Text('Timer started! Focus mode activated.'),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: AppTheme.success,
      ),
    );
  }
}
