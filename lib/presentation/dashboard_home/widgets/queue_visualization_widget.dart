import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QueueVisualizationWidget extends StatelessWidget {
  final int totalTasks;
  final int priorityTasks;
  final int normalTasks;
  final int lowTasks;
  final VoidCallback onQueueManagerTap;

  const QueueVisualizationWidget({
    Key? key,
    required this.totalTasks,
    required this.priorityTasks,
    required this.normalTasks,
    required this.lowTasks,
    required this.onQueueManagerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'queue',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Task Queue',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalTasks tasks',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildQueueStack(context),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildPriorityBreakdown(context),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onQueueManagerTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Manage Queue',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueStack(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Queue Stack',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 2.h),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: List.generate(
                (totalTasks > 5 ? 5 : totalTasks).clamp(0, 5),
                (index) => Container(
                  margin: EdgeInsets.only(bottom: 0.5.h),
                  width: double.infinity,
                  height: 1.5.h,
                  decoration: BoxDecoration(
                    color: index == 0
                        ? AppTheme.priorityHigh.withValues(alpha: 0.8)
                        : index == 1
                            ? AppTheme.priorityNormal.withValues(alpha: 0.8)
                            : AppTheme.priorityLow.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ).reversed.toList(),
            ),
            if (totalTasks > 5)
              Positioned(
                top: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '+${totalTasks - 5}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityBreakdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Breakdown',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 2.h),
        _buildPriorityItem(
            context, 'High', priorityTasks, AppTheme.priorityHigh),
        SizedBox(height: 1.h),
        _buildPriorityItem(
            context, 'Normal', normalTasks, AppTheme.priorityNormal),
        SizedBox(height: 1.h),
        _buildPriorityItem(context, 'Low', lowTasks, AppTheme.priorityLow),
      ],
    );
  }

  Widget _buildPriorityItem(
      BuildContext context, String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Text(
          '$count',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}
