import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PriorityTaskCardWidget extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onComplete;
  final VoidCallback onTap;

  const PriorityTaskCardWidget({
    Key? key,
    required this.task,
    required this.onComplete,
    required this.onTap,
  }) : super(key: key);

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.priorityHigh;
      case 'normal':
        return AppTheme.priorityNormal;
      case 'low':
        return AppTheme.priorityLow;
      default:
        return AppTheme.priorityNormal;
    }
  }

  String _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'priority_high';
      case 'normal':
        return 'remove';
      case 'low':
        return 'keyboard_arrow_down';
      default:
        return 'remove';
    }
  }

  @override
  Widget build(BuildContext context) {
    final priority = task['priority'] as String? ?? 'normal';
    final isCompleted = task['isCompleted'] as bool? ?? false;
    final priorityColor = _getPriorityColor(priority);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 3.w),
        width: 75.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: priorityColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: _getPriorityIcon(priority),
                        color: priorityColor,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        priority.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: priorityColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onComplete,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppTheme.success
                            : AppTheme.lightTheme.colorScheme.outline,
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
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              task['title'] as String? ?? 'Untitled Task',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (task['description'] != null &&
                (task['description'] as String).isNotEmpty) ...[
              SizedBox(height: 1.h),
              Text(
                task['description'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  task['dueTime'] as String? ?? 'No due time',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                ),
                const Spacer(),
                if (task['category'] != null) ...[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task['category'] as String,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
