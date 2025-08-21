import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PriorityPicker extends StatelessWidget {
  final String selectedPriority;
  final Function(String) onPriorityChanged;

  const PriorityPicker({
    Key? key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  }) : super(key: key);

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppTheme.priorityHigh;
      case 'Normal':
        return AppTheme.priorityNormal;
      case 'Low':
        return AppTheme.priorityLow;
      default:
        return AppTheme.priorityNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorities = ['High', 'Normal', 'Low'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Column(
            children: priorities.map((priority) {
              final isSelected = selectedPriority == priority;
              final priorityColor = _getPriorityColor(priority);

              return GestureDetector(
                onTap: () => onPriorityChanged(priority),
                child: Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? priorityColor.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? priorityColor
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
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: priorityColor,
                            width: 2,
                          ),
                          color:
                              isSelected ? priorityColor : Colors.transparent,
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 2.w,
                                  height: 2.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        priority,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: isSelected
                              ? priorityColor
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: priorityColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
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
