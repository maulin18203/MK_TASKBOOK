import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const DescriptionField({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Add task description...',
              alignLabelWithHint: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
            style: AppTheme.lightTheme.textTheme.bodyLarge,
            maxLines: 4,
            minLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(height: 0.5.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${controller.text.length}/500',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: controller.text.length > 450
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
