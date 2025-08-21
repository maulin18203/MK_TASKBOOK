import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReminderSettings extends StatelessWidget {
  final List<String> selectedReminders;
  final Function(List<String>) onRemindersChanged;

  const ReminderSettings({
    Key? key,
    required this.selectedReminders,
    required this.onRemindersChanged,
  }) : super(key: key);

  void _toggleReminder(String reminder) {
    final updatedReminders = List<String>.from(selectedReminders);
    if (updatedReminders.contains(reminder)) {
      updatedReminders.remove(reminder);
    } else {
      updatedReminders.add(reminder);
    }
    onRemindersChanged(updatedReminders);
  }

  @override
  Widget build(BuildContext context) {
    final reminderOptions = [
      {'label': '1 day before', 'value': '1_day', 'icon': 'notifications'},
      {'label': '1 hour before', 'value': '1_hour', 'icon': 'access_time'},
      {'label': '15 minutes before', 'value': '15_minutes', 'icon': 'timer'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder Settings',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Get notified before the due date',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Column(
            children: reminderOptions.map((option) {
              final isSelected =
                  selectedReminders.contains(option['value'] as String);
              return Container(
                margin: EdgeInsets.only(bottom: 1.h),
                child: GestureDetector(
                  onTap: () => _toggleReminder(option['value'] as String),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primaryContainer
                              .withValues(alpha: 0.5)
                          : AppTheme.lightTheme.colorScheme.surface,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: isSelected
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        SizedBox(width: 3.w),
                        CustomIconWidget(
                          iconName: option['icon'] as String,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            option['label'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
