import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QueueVisualizerWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final String sortMode;
  final VoidCallback? onToggleView;

  const QueueVisualizerWidget({
    Key? key,
    required this.tasks,
    required this.sortMode,
    this.onToggleView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.3)),
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
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'analytics',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Queue Visualization',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getSortModeDescription(sortMode),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (onToggleView != null)
                  IconButton(
                    onPressed: onToggleView,
                    icon: CustomIconWidget(
                      iconName: 'view_list',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                  ),
              ],
            ),
          ),

          Divider(
            color: AppTheme.dividerLight,
            height: 1,
          ),

          // Queue visualization content
          if (tasks.isEmpty) _buildEmptyQueue() else _buildQueueContent(),
        ],
      ),
    );
  }

  Widget _buildEmptyQueue() {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'queue',
            color: AppTheme.textDisabled,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Queue is Empty',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add tasks to see the queue visualization',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQueueContent() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Queue statistics
          _buildQueueStats(),

          SizedBox(height: 3.h),

          // Visual queue representation
          _buildVisualQueue(),

          if (sortMode == 'priority_queue') ...[
            SizedBox(height: 3.h),
            _buildEffectiveWeightInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildQueueStats() {
    final totalTasks = tasks.length;
    final completedTasks =
        tasks.where((task) => task['status'] == 'Done').length;
    final pendingTasks = totalTasks - completedTasks;
    final highPriorityTasks =
        tasks.where((task) => task['priority'] == 'High').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total',
            totalTasks.toString(),
            AppTheme.lightTheme.primaryColor,
            'assignment',
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildStatCard(
            'Pending',
            pendingTasks.toString(),
            AppTheme.warning,
            'pending_actions',
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildStatCard(
            'High Priority',
            highPriorityTasks.toString(),
            AppTheme.priorityHigh,
            'priority_high',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 5.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualQueue() {
    final displayTasks = tasks.take(5).toList(); // Show first 5 tasks

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Queue Order',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getQueueDirection(sortMode),
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Visual queue items
        ...displayTasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          final isLast = index == displayTasks.length - 1;

          return Column(
            children: [
              _buildQueueItem(task, index + 1),
              if (!isLast) _buildQueueConnector(),
            ],
          );
        }).toList(),

        // Show more indicator
        if (tasks.length > 5) ...[
          _buildQueueConnector(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.borderLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.borderLight, style: BorderStyle.solid),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'more_horiz',
                  color: AppTheme.textSecondary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  '+${tasks.length - 5} more tasks',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQueueItem(Map<String, dynamic> task, int position) {
    final priority = task['priority'] ?? 'Normal';
    final isCompleted = task['status'] == 'Done';
    final effectiveWeight = _calculateEffectiveWeight(task);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.success.withValues(alpha: 0.1)
            : _getPriorityColor(priority).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted ? AppTheme.success : _getPriorityColor(priority),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Position indicator
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color:
                  isCompleted ? AppTheme.success : _getPriorityColor(priority),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                position.toString(),
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'] ?? 'Untitled Task',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      priority,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getPriorityColor(priority),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (sortMode == 'priority_queue' &&
                        effectiveWeight != null) ...[
                      SizedBox(width: 2.w),
                      Text(
                        '• Weight: ${effectiveWeight.toStringAsFixed(1)}',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Status indicator
          if (isCompleted)
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.success,
              size: 5.w,
            ),
        ],
      ),
    );
  }

  Widget _buildQueueConnector() {
    return Container(
      width: 2,
      height: 2.h,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.borderLight,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildEffectiveWeightInfo() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'EffectiveWeight Formula',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.borderLight.withValues(alpha: 0.3)),
            ),
            child: Text(
              'EffectiveWeight = PriorityValue + (DeadlineUrgency × TimeFactor)',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Higher weights appear first in the queue. Priority values: High=3, Normal=2, Low=1',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getSortModeDescription(String mode) {
    switch (mode) {
      case 'priority_queue':
        return 'Smart prioritization with mathematical weights';
      case 'fifo':
        return 'First In, First Out - oldest tasks first';
      case 'lilo':
        return 'Last In, Last Out - newest tasks first';
      case 'due_date':
        return 'Sorted by earliest due dates';
      case 'creation_date':
        return 'Sorted by creation time';
      default:
        return 'Custom sorting applied';
    }
  }

  String _getQueueDirection(String mode) {
    switch (mode) {
      case 'fifo':
        return 'FIFO →';
      case 'lilo':
        return '← LILO';
      case 'priority_queue':
        return '↑ Priority';
      default:
        return '→ Order';
    }
  }

  double? _calculateEffectiveWeight(Map<String, dynamic> task) {
    if (sortMode != 'priority_queue') return null;

    final priority = task['priority'] ?? 'Normal';
    final priorityValue = _getPriorityValue(priority);

    double deadlineUrgency = 1.0;
    if (task['dueDate'] != null) {
      final dueDate = DateTime.parse(task['dueDate']);
      final now = DateTime.now();
      final daysUntilDue = dueDate.difference(now).inDays;

      if (daysUntilDue <= 0) {
        deadlineUrgency = 5.0; // Overdue
      } else if (daysUntilDue <= 1) {
        deadlineUrgency = 4.0; // Due today/tomorrow
      } else if (daysUntilDue <= 7) {
        deadlineUrgency = 3.0; // Due this week
      } else {
        deadlineUrgency = 1.0; // Future
      }
    }

    final timeFactor = 1.0; // Could be based on estimated time

    return priorityValue + (deadlineUrgency * timeFactor);
  }

  double _getPriorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3.0;
      case 'normal':
        return 2.0;
      case 'low':
        return 1.0;
      default:
        return 2.0;
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
