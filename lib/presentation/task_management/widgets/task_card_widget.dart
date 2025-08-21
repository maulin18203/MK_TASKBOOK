import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskCardWidget extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onSetReminder;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool isMultiSelectMode;

  const TaskCardWidget({
    Key? key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onEdit,
    this.onDuplicate,
    this.onSetReminder,
    this.onDelete,
    this.isSelected = false,
    this.isMultiSelectMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task['status'] == 'Done';
    final String priority = task['priority'] ?? 'Normal';
    final String category = task['category'] ?? 'Daily';
    final DateTime? dueDate =
        task['dueDate'] != null ? DateTime.parse(task['dueDate']) : null;
    final bool isFastCompletion = (task['estimatedMinutes'] ?? 0) <= 15;

    return Dismissible(
      key: Key('task_${task['id']}'),
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
        } else {
          onDelete?.call();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppTheme.lightTheme.primaryColor, width: 2)
              : Border.all(color: AppTheme.borderLight.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isMultiSelectMode ? onTap : null,
            onLongPress: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Checkbox for completion
                  GestureDetector(
                    onTap: onToggleComplete,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppTheme.success
                              : AppTheme.borderLight,
                          width: 2,
                        ),
                        color:
                            isCompleted ? AppTheme.success : Colors.transparent,
                      ),
                      child: isCompleted
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 4.w,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 3.w),

                  // Task content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Task title
                            Expanded(
                              child: Text(
                                task['title'] ?? 'Untitled Task',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isCompleted
                                      ? AppTheme.textSecondary
                                      : AppTheme.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Fast completion indicator
                            if (isFastCompletion && !isCompleted) ...[
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'flash_on',
                                color: AppTheme.warning,
                                size: 4.w,
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: 1.h),

                        // Category and priority row
                        Row(
                          children: [
                            // Category badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(category)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                category,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: _getCategoryColor(category),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(width: 2.w),

                            // Priority indicator
                            Container(
                              width: 3.w,
                              height: 3.w,
                              decoration: BoxDecoration(
                                color: _getPriorityColor(priority),
                                shape: BoxShape.circle,
                              ),
                            ),

                            SizedBox(width: 1.w),

                            Text(
                              priority,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getPriorityColor(priority),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Spacer(),

                            // Due date countdown
                            if (dueDate != null) _buildDueDateWidget(dueDate),
                          ],
                        ),

                        // Description if available
                        if (task['description'] != null &&
                            (task['description'] as String).isNotEmpty) ...[
                          SizedBox(height: 1.h),
                          Text(
                            task['description'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Multi-select checkbox
                  if (isMultiSelectMode) ...[
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: isSelected
                          ? 'check_circle'
                          : 'radio_button_unchecked',
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.textSecondary,
                      size: 6.w,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isLeftSwipe) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeftSwipe ? AppTheme.lightTheme.primaryColor : AppTheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeftSwipe ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeftSwipe ? 'edit' : 'delete',
                color: Colors.white,
                size: 6.w,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeftSwipe ? 'Edit' : 'Delete',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDueDateWidget(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    final isOverdue = difference.isNegative;
    final days = difference.inDays.abs();
    final hours = difference.inHours.abs();

    String timeText;
    Color timeColor;

    if (isOverdue) {
      timeColor = AppTheme.error;
      if (days > 0) {
        timeText = '${days}d overdue';
      } else if (hours > 0) {
        timeText = '${hours}h overdue';
      } else {
        timeText = 'Overdue';
      }
    } else {
      if (days > 7) {
        timeColor = AppTheme.textSecondary;
        timeText = '${days}d left';
      } else if (days > 1) {
        timeColor = AppTheme.warning;
        timeText = '${days}d left';
      } else if (hours > 1) {
        timeColor = AppTheme.error;
        timeText = '${hours}h left';
      } else {
        timeColor = AppTheme.error;
        timeText = 'Due soon';
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: 'schedule',
          color: timeColor,
          size: 3.w,
        ),
        SizedBox(width: 1.w),
        Text(
          timeText,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: timeColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'daily':
        return AppTheme.lightTheme.primaryColor;
      case 'monthly':
        return AppTheme.secondaryLight;
      case 'yearly':
        return AppTheme.priorityNormal;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.priorityHigh;
      case 'normal':
        return AppTheme.priorityNormal;
      case 'low':
        return AppTheme.priorityLow;
      default:
        return AppTheme.textSecondary;
    }
  }
}
