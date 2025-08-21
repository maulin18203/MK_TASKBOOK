import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressCardWidget extends StatelessWidget {
  final double completionPercentage;
  final int streakCount;

  const ProgressCardWidget({
    Key? key,
    required this.completionPercentage,
    required this.streakCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  value: completionPercentage / 100,
                  strokeWidth: 6,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completionPercentage >= 80
                        ? AppTheme.success
                        : completionPercentage >= 50
                            ? AppTheme.warning
                            : AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
              Text(
                '${completionPercentage.toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
              ),
            ],
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: AppTheme.warning,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '$streakCount day streak',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  completionPercentage >= 80
                      ? 'Excellent work today!'
                      : completionPercentage >= 50
                          ? 'Keep pushing forward!'
                          : 'Let\'s get started!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
