import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVoiceInput;
  final VoidCallback? onFilter;
  final TextEditingController? controller;

  const SearchBarWidget({
    Key? key,
    this.hintText = 'Search tasks...',
    this.onChanged,
    this.onVoiceInput,
    this.onFilter,
    this.controller,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderLight.withValues(alpha: 0.3),
        ),
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
          // Search icon
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.textSecondary,
              size: 5.w,
            ),
          ),

          // Search input field
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.5.h,
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),

          // Clear button (when text is present)
          if (_hasText)
            GestureDetector(
              onTap: _clearSearch,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ),

          // Voice input button
          if (widget.onVoiceInput != null)
            GestureDetector(
              onTap: widget.onVoiceInput,
              child: Container(
                padding: EdgeInsets.all(2.w),
                margin: EdgeInsets.only(right: 1.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'mic',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 4.w,
                ),
              ),
            ),

          // Filter button
          if (widget.onFilter != null)
            GestureDetector(
              onTap: widget.onFilter,
              child: Container(
                padding: EdgeInsets.all(2.w),
                margin: EdgeInsets.only(right: 3.w, left: 1.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'tune',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 4.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
