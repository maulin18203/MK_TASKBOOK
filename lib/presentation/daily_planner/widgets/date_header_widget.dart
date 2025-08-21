import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateHeaderWidget extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onTodayTap;
  final VoidCallback onDateTap;

  const DateHeaderWidget({
    Key? key,
    required this.selectedDate,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onTodayTap,
    required this.onDateTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(selectedDate);
    final dateText = _formatDate(selectedDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPreviousDay,
            icon: CustomIconWidget(
              iconName: 'chevron_left',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            padding: EdgeInsets.all(2.w),
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onDateTap,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Column(
                  children: [
                    Text(
                      dateText,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isToday) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        _getDayOfWeek(selectedDate),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (!isToday)
            TextButton(
              onPressed: onTodayTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                minimumSize: const Size(44, 44),
              ),
              child: Text(
                'Today',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            IconButton(
              onPressed: onNextDay,
              icon: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              padding: EdgeInsets.all(2.w),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          if (!isToday)
            IconButton(
              onPressed: onNextDay,
              icon: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              padding: EdgeInsets.all(2.w),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (_isToday(date)) {
      return 'Today';
    } else if (date.difference(now).inDays == 1) {
      return 'Tomorrow';
    } else if (date.difference(now).inDays == -1) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String _getDayOfWeek(DateTime date) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[date.weekday - 1];
  }
}
