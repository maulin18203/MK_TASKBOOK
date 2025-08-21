import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DueDateField extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateChanged;

  const DueDateField({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Today';
    } else if (selectedDay == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Due Date',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          selectedDate != null
                              ? _formatDate(selectedDate!)
                              : 'Select date',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: selectedDate != null
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _QuickDateButton(
                label: 'Today',
                onTap: () => onDateChanged(DateTime.now()),
                isSelected: selectedDate != null &&
                    DateTime(selectedDate!.year, selectedDate!.month,
                            selectedDate!.day) ==
                        DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day),
              ),
              SizedBox(width: 2.w),
              _QuickDateButton(
                label: 'Tomorrow',
                onTap: () =>
                    onDateChanged(DateTime.now().add(Duration(days: 1))),
                isSelected: selectedDate != null &&
                    DateTime(selectedDate!.year, selectedDate!.month,
                            selectedDate!.day) ==
                        DateTime.now().add(Duration(days: 1)),
              ),
              SizedBox(width: 2.w),
              _QuickDateButton(
                label: 'Next Week',
                onTap: () =>
                    onDateChanged(DateTime.now().add(Duration(days: 7))),
                isSelected: selectedDate != null &&
                    DateTime(selectedDate!.year, selectedDate!.month,
                            selectedDate!.day) ==
                        DateTime.now().add(Duration(days: 7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickDateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const _QuickDateButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
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
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
