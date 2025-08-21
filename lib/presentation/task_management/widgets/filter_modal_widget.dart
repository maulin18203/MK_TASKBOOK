import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  const FilterModalWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;
  final List<String> _expandedSections = [];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  void _toggleSection(String section) {
    setState(() {
      if (_expandedSections.contains(section)) {
        _expandedSections.remove(section);
      } else {
        _expandedSections.add(section);
      }
    });
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _filters[key] = value;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  'Filter Tasks',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  _buildFilterSection(
                    'Category',
                    'category',
                    ['Daily', 'Monthly', 'Yearly'],
                  ),
                  _buildFilterSection(
                    'Priority',
                    'priority',
                    ['High', 'Normal', 'Low'],
                  ),
                  _buildFilterSection(
                    'Status',
                    'status',
                    ['Done', 'Pending'],
                  ),
                  _buildDateRangeSection(),
                  _buildFastCompletionSection(),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'Apply Filters',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, String key, List<String> options) {
    final isExpanded = _expandedSections.contains(key);
    final selectedValues = _filters[key] as List<String>? ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Section header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleSection(key),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (selectedValues.isNotEmpty) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          selectedValues.length.toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    CustomIconWidget(
                      iconName: isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.textSecondary,
                      size: 6.w,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Section content
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                children: options.map((option) {
                  final isSelected = selectedValues.contains(option);

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        final newValues = List<String>.from(selectedValues);
                        if (isSelected) {
                          newValues.remove(option);
                        } else {
                          newValues.add(option);
                        }
                        _updateFilter(key, newValues);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.5.h,
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: isSelected
                                  ? 'check_box'
                                  : 'check_box_outline_blank',
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.textSecondary,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              option,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection() {
    final isExpanded = _expandedSections.contains('dateRange');

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Section header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleSection('dateRange'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Text(
                      'Due Date Range',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    CustomIconWidget(
                      iconName: isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.textSecondary,
                      size: 6.w,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Date range content
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            // Date picker implementation would go here
                          },
                          icon: CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 4.w,
                          ),
                          label: Text(
                            'Start Date',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            // Date picker implementation would go here
                          },
                          icon: CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 4.w,
                          ),
                          label: Text(
                            'End Date',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
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

  Widget _buildFastCompletionSection() {
    final isExpanded = _expandedSections.contains('fastCompletion');
    final showFastCompletion = _filters['fastCompletion'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Section header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleSection('fastCompletion'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'flash_on',
                      color: AppTheme.warning,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Fast Completion',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: showFastCompletion,
                      onChanged: (value) =>
                          _updateFilter('fastCompletion', value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
