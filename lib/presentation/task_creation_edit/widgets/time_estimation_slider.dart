import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimeEstimationSlider extends StatelessWidget {
  final double timeEstimation;
  final Function(double) onTimeChanged;
  final String selectedPriority;
  final DateTime? dueDate;

  const TimeEstimationSlider({
    Key? key,
    required this.timeEstimation,
    required this.onTimeChanged,
    required this.selectedPriority,
    required this.dueDate,
  }) : super(key: key);

  double _calculateEffectiveWeight() {
    // Priority values: High = 3, Normal = 2, Low = 1
    double priorityValue = selectedPriority == 'High'
        ? 3.0
        : selectedPriority == 'Normal'
            ? 2.0
            : 1.0;

    // Deadline urgency calculation
    double deadlineUrgency = 1.0;
    if (dueDate != null) {
      final daysUntilDue = dueDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue <= 1) {
        deadlineUrgency = 3.0;
      } else if (daysUntilDue <= 3) {
        deadlineUrgency = 2.5;
      } else if (daysUntilDue <= 7) {
        deadlineUrgency = 2.0;
      } else {
        deadlineUrgency = 1.5;
      }
    }

    // Time factor (longer tasks get slightly higher weight)
    double timeFactor = timeEstimation / 60; // Convert minutes to hours

    // EffectiveWeight = PriorityValue + (DeadlineUrgency × TimeFactor)
    return priorityValue + (deadlineUrgency * timeFactor);
  }

  String _formatTime(double minutes) {
    if (minutes < 60) {
      return '${minutes.round()} min';
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = (minutes % 60).round();
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveWeight = _calculateEffectiveWeight();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Estimation',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duration: ${_formatTime(timeEstimation)}',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Weight: ${effectiveWeight.toStringAsFixed(1)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
                    inactiveTrackColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    thumbColor: AppTheme.lightTheme.colorScheme.primary,
                    overlayColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.2),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                  ),
                  child: Slider(
                    value: timeEstimation,
                    min: 5,
                    max: 480, // 8 hours
                    divisions: 95,
                    onChanged: onTimeChanged,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5 min',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '8 hours',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
