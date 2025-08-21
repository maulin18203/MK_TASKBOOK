import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const FilterChipWidget({
    Key? key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.borderLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (count > 0) ...[
                  SizedBox(width: 1.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.5.w,
                      vertical: 0.2.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.textSecondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
                if (isSelected && onRemove != null) ...[
                  SizedBox(width: 1.w),
                  GestureDetector(
                    onTap: onRemove,
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 4.w,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
