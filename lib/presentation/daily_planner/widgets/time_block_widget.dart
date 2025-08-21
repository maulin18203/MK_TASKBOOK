import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimeBlockWidget extends StatelessWidget {
  final Map<String, dynamic> timeBlock;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isCurrentTime;
  final List<Map<String, dynamic>> tasks;

  const TimeBlockWidget({
    Key? key,
    required this.timeBlock,
    this.onTap,
    this.onLongPress,
    this.isCurrentTime = false,
    this.tasks = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startTime = timeBlock['startTime'] as String;
    final endTime = timeBlock['endTime'] as String;
    final title = timeBlock['title'] as String;
    final hasAlarm = timeBlock['hasAlarm'] as bool? ?? false;
    final isCustom = timeBlock['isCustom'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: isCurrentTime
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentTime
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: isCurrentTime ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: _getBlockColor(title),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$startTime - $endTime',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const Spacer(),
                              if (hasAlarm) ...[
                                CustomIconWidget(
                                  iconName: 'alarm',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 16,
                                ),
                                SizedBox(width: 2.w),
                              ],
                              if (isCustom)
                                CustomIconWidget(
                                  iconName: 'edit',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 16,
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            title,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (tasks.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  ...tasks.map((task) => _buildTaskItem(task)).toList(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    final title = task['title'] as String;
    final isCompleted = task['isCompleted'] as bool? ?? false;

    return Padding(
      padding: EdgeInsets.only(left: 7.w, bottom: 1.h),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted
                    ? AppTheme.success
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 2,
              ),
              color: isCompleted ? AppTheme.success : Colors.transparent,
            ),
            child: isCompleted
                ? CustomIconWidget(
                    iconName: 'check',
                    color: Colors.white,
                    size: 12,
                  )
                : null,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBlockColor(String title) {
    switch (title.toLowerCase()) {
      case 'wake-up':
        return const Color(0xFFFFB74D);
      case 'morning routine':
        return const Color(0xFF81C784);
      case 'breakfast':
        return const Color(0xFFFFD54F);
      case 'class/work':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'project work':
        return const Color(0xFF9575CD);
      case 'personal work':
        return const Color(0xFF64B5F6);
      case 'lunch':
        return const Color(0xFFFF8A65);
      case 'dinner':
        return const Color(0xFFFF7043);
      case 'relaxation':
        return const Color(0xFFA5D6A7);
      case 'sleep':
        return const Color(0xFF90A4AE);
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }
}
