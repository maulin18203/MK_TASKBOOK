import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreviewWidget extends StatelessWidget {
  final Map<String, dynamic> alarm;
  final VoidCallback onClose;

  const NotificationPreviewWidget({
    Key? key,
    required this.alarm,
    required this.onClose,
  }) : super(key: key);

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.error;
      case 'normal':
        return AppTheme.priorityNormal;
      case 'low':
        return AppTheme.priorityLow;
      default:
        return AppTheme.priorityNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = alarm['time'] as String? ?? '00:00';
    final label = alarm['label'] as String? ?? 'Alarm';
    final priority = alarm['priority'] as String? ?? 'normal';
    final taskType = alarm['taskType'] as String? ?? 'reminder';

    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  'Notification Preview',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Phone mockup
          Container(
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Phone status bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Row(
                    children: [
                      Text(
                        '9:41',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      CustomIconWidget(
                        iconName: 'signal_cellular_4_bar',
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'wifi',
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'battery_full',
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Notification content
                Container(
                  margin: EdgeInsets.all(3.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App header
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '📓',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'M.K Taskbooks',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'now',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(priority)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              priority.toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getPriorityColor(priority),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Notification title
                      Text(
                        '⏰ ${taskType.toUpperCase()} REMINDER',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getPriorityColor(priority),
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Notification content
                      Text(
                        label,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 0.5.h),

                      Text(
                        'Scheduled for ${_formatTime(time)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              'Complete Task',
                              AppTheme.success,
                              CustomIconWidget(
                                iconName: 'check_circle',
                                size: 18,
                                color: AppTheme.success,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildActionButton(
                              'Snooze',
                              AppTheme.warning,
                              CustomIconWidget(
                                iconName: 'snooze',
                                size: 18,
                                color: AppTheme.warning,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      SizedBox(
                        width: double.infinity,
                        child: _buildActionButton(
                          'Reschedule',
                          AppTheme.priorityNormal,
                          CustomIconWidget(
                            iconName: 'schedule',
                            size: 18,
                            color: AppTheme.priorityNormal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Preview info
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Details',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildDetailRow(
                    'Sound', alarm['sound'] as String? ?? 'Default'),
                _buildDetailRow(
                    'Vibration',
                    (alarm['vibrate'] as bool? ?? true)
                        ? 'Enabled'
                        : 'Disabled'),
                _buildDetailRow('Snooze Interval',
                    '${alarm['snoozeInterval'] ?? 5} minutes'),
                _buildDetailRow(
                    'Max Snoozes', '${alarm['maxSnoozes'] ?? 3} times'),
                _buildDetailRow(
                    'Volume',
                    (alarm['gradualVolume'] as bool? ?? true)
                        ? 'Gradual increase'
                        : 'Full volume'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, Widget icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 1.w),
          Flexible(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
