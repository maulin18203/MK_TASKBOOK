import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FastCompletionToggle extends StatelessWidget {
  final bool isFastCompletion;
  final Function(bool) onToggleChanged;
  final double timeEstimation;

  const FastCompletionToggle({
    Key? key,
    required this.isFastCompletion,
    required this.onToggleChanged,
    required this.timeEstimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEligible = timeEstimation <= 15;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isFastCompletion && isEligible
              ? AppTheme.warning.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isFastCompletion && isEligible
                ? AppTheme.warning
                : AppTheme.lightTheme.colorScheme.outline,
            width: isFastCompletion && isEligible ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isFastCompletion && isEligible
                        ? AppTheme.warning.withValues(alpha: 0.2)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'flash_on',
                    color: isFastCompletion && isEligible
                        ? AppTheme.warning
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fast Completion Mode',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isFastCompletion && isEligible
                              ? AppTheme.warning
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        isEligible
                            ? 'Quick tasks under 15 minutes'
                            : 'Only available for tasks ≤ 15 minutes',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isEligible
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isFastCompletion && isEligible,
                  onChanged: isEligible ? onToggleChanged : null,
                  activeColor: AppTheme.warning,
                ),
              ],
            ),
            if (isFastCompletion && isEligible) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.warning.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'bolt',
                      color: AppTheme.warning,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'This task will be prioritized for immediate completion',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
