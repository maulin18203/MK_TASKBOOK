import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String category;
  final VoidCallback? onAddTask;

  const EmptyStateWidget({
    Key? key,
    required this.category,
    this.onAddTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emptyStateData = _getEmptyStateData(category);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: emptyStateData['icon'] as String,
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              emptyStateData['title'] as String,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              emptyStateData['description'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Add task button
            if (onAddTask != null)
              ElevatedButton.icon(
                onPressed: onAddTask,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 5.w,
                ),
                label: Text(
                  'Add ${category == 'all' ? 'Task' : '$category Task'}',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 2.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getEmptyStateData(String category) {
    switch (category.toLowerCase()) {
      case 'daily':
        return {
          'icon': 'today',
          'title': 'No Daily Tasks Yet',
          'description':
              'Start organizing your day by adding daily tasks and routines that help you stay productive.',
        };
      case 'monthly':
        return {
          'icon': 'calendar_view_month',
          'title': 'No Monthly Goals',
          'description':
              'Set monthly objectives and milestones to track your progress over longer periods.',
        };
      case 'yearly':
        return {
          'icon': 'calendar_view_year',
          'title': 'No Yearly Plans',
          'description':
              'Create yearly goals and long-term projects to achieve your biggest aspirations.',
        };
      case 'completed':
        return {
          'icon': 'task_alt',
          'title': 'No Completed Tasks',
          'description':
              'Complete some tasks to see your achievements and track your productivity progress.',
        };
      case 'pending':
        return {
          'icon': 'pending_actions',
          'title': 'No Pending Tasks',
          'description':
              'Great job! You\'ve completed all your tasks. Add new ones to keep the momentum going.',
        };
      case 'high_priority':
        return {
          'icon': 'priority_high',
          'title': 'No High Priority Tasks',
          'description':
              'No urgent tasks at the moment. Focus on your other tasks or plan ahead.',
        };
      case 'fast_completion':
        return {
          'icon': 'flash_on',
          'title': 'No Quick Tasks',
          'description':
              'No tasks under 15 minutes found. Break down larger tasks into smaller, manageable chunks.',
        };
      default:
        return {
          'icon': 'assignment',
          'title': 'No Tasks Found',
          'description':
              'Start your productivity journey by creating your first task. Organize, prioritize, and achieve your goals.',
        };
    }
  }
}
