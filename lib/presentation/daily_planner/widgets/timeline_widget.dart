import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimelineWidget extends StatelessWidget {
  final DateTime currentTime;

  const TimelineWidget({
    Key? key,
    required this.currentTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12.w,
      child: Column(
        children: List.generate(24, (index) {
          final hour = index;
          final isCurrentHour = _isCurrentHour(hour);

          return Container(
            height: 8.h,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      child: Text(
                        _formatHour(hour),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: isCurrentHour
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isCurrentHour ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrentHour
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
                if (isCurrentHour && _shouldShowCurrentTimeLine())
                  Container(
                    margin: EdgeInsets.only(
                        left: 10.w, top: _getCurrentTimeOffset()),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.error,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
              ],
            ),
          );
        }),
      ),
    );
  }

  bool _isCurrentHour(int hour) {
    return currentTime.hour == hour;
  }

  bool _shouldShowCurrentTimeLine() {
    final now = DateTime.now();
    return currentTime.year == now.year &&
        currentTime.month == now.month &&
        currentTime.day == now.day;
  }

  double _getCurrentTimeOffset() {
    final minutes = currentTime.minute;
    final percentage = minutes / 60.0;
    return (8.h * percentage) - 1.h;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }
}
