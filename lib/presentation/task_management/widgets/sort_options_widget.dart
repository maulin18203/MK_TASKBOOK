import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SortOptionsWidget extends StatelessWidget {
  final String currentSort;
  final ValueChanged<String> onSortChanged;

  const SortOptionsWidget({
    Key? key,
    required this.currentSort,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              children: [
                Text(
                  'Sort Tasks',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Sort options
          ..._buildSortOptions(),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  List<Widget> _buildSortOptions() {
    final sortOptions = [
      {
        'key': 'priority_queue',
        'title': 'Priority Queue',
        'subtitle': 'Smart prioritization with EffectiveWeight',
        'icon': 'trending_up',
      },
      {
        'key': 'fifo',
        'title': 'FIFO (First In, First Out)',
        'subtitle': 'Oldest tasks first',
        'icon': 'first_page',
      },
      {
        'key': 'lilo',
        'title': 'LILO (Last In, Last Out)',
        'subtitle': 'Newest tasks first',
        'icon': 'last_page',
      },
      {
        'key': 'due_date',
        'title': 'Due Date',
        'subtitle': 'Earliest deadlines first',
        'icon': 'schedule',
      },
      {
        'key': 'creation_date',
        'title': 'Creation Date',
        'subtitle': 'Recently created first',
        'icon': 'access_time',
      },
    ];

    return sortOptions.map((option) {
      final isSelected = currentSort == option['key'];

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onSortChanged(option['key'] as String);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 2.h,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
                        : AppTheme.borderLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: option['icon'] as String,
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.textSecondary,
                      size: 5.w,
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        option['subtitle'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}