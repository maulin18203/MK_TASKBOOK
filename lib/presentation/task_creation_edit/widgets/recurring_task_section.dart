import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RecurringTaskSection extends StatelessWidget {
  final bool isRecurring;
  final String recurringFrequency;
  final int customInterval;
  final Function(bool) onRecurringToggle;
  final Function(String) onFrequencyChanged;
  final Function(int) onIntervalChanged;

  const RecurringTaskSection({
    Key? key,
    required this.isRecurring,
    required this.recurringFrequency,
    required this.customInterval,
    required this.onRecurringToggle,
    required this.onFrequencyChanged,
    required this.onIntervalChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recurring Task',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: isRecurring,
                onChanged: onRecurringToggle,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
          if (isRecurring) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.5),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequency',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: ['Daily', 'Weekly', 'Monthly', 'Yearly']
                        .map((frequency) {
                      final isSelected = recurringFrequency == frequency;
                      return GestureDetector(
                        onTap: () => onFrequencyChanged(frequency),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.surface,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            frequency,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (recurringFrequency != 'Daily') ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Custom Interval',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Text(
                          'Every',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 15.w,
                          child: TextFormField(
                            initialValue: customInterval.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final interval = int.tryParse(value) ?? 1;
                              onIntervalChanged(interval);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 1.h),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          recurringFrequency.toLowerCase(),
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
