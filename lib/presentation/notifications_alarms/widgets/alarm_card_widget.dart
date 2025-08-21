import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlarmCardWidget extends StatefulWidget {
  final Map<String, dynamic> alarm;
  final Function(Map<String, dynamic>) onToggle;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDuplicate;
  final Function(Map<String, dynamic>) onTestSound;
  final Function(Map<String, dynamic>) onDelete;

  const AlarmCardWidget({
    Key? key,
    required this.alarm,
    required this.onToggle,
    required this.onEdit,
    required this.onDuplicate,
    required this.onTestSound,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<AlarmCardWidget> createState() => _AlarmCardWidgetState();
}

class _AlarmCardWidgetState extends State<AlarmCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isExpanded = false;
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showActionButtons() {
    setState(() {
      _showActions = true;
    });
    _animationController.forward();
  }

  void _hideActionButtons() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showActions = false;
        });
      }
    });
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  String _getRecurrenceText(String recurrence) {
    switch (recurrence.toLowerCase()) {
      case 'daily':
        return 'Every day';
      case 'weekly':
        return 'Every week';
      case 'monthly':
        return 'Every month';
      case 'yearly':
        return 'Every year';
      case 'weekdays':
        return 'Mon - Fri';
      case 'weekends':
        return 'Sat - Sun';
      default:
        return 'Once';
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.error;
      case 'normal':
        return AppTheme.priorityNormal;
      case 'low':
        return AppTheme.priorityLow;
      default:
        return AppTheme.priorityNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.alarm['enabled'] as bool? ?? true;
    final time = widget.alarm['time'] as String? ?? '00:00';
    final label = widget.alarm['label'] as String? ?? 'Alarm';
    final recurrence = widget.alarm['recurrence'] as String? ?? 'once';
    final priority = widget.alarm['priority'] as String? ?? 'normal';
    final taskType = widget.alarm['taskType'] as String? ?? 'reminder';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Stack(
        children: [
          // Main alarm card
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! > 0) {
                  // Swipe right - show edit actions
                  _showActionButtons();
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left - show delete
                  _showDeleteConfirmation();
                }
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEnabled
                      ? _getPriorityColor(priority).withValues(alpha: 0.3)
                      : AppTheme.borderLight,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main alarm info
                  Row(
                    children: [
                      // Time display
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatTime(time),
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: isEnabled
                                    ? AppTheme.textPrimary
                                    : AppTheme.textDisabled,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              label,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: isEnabled
                                    ? AppTheme.textSecondary
                                    : AppTheme.textDisabled,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Priority indicator
                      Container(
                        width: 3,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: isEnabled
                              ? _getPriorityColor(priority)
                              : AppTheme.textDisabled,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      SizedBox(width: 3.w),

                      // Toggle switch
                      Switch(
                        value: isEnabled,
                        onChanged: (value) {
                          final updatedAlarm =
                              Map<String, dynamic>.from(widget.alarm);
                          updatedAlarm['enabled'] = value;
                          widget.onToggle(updatedAlarm);
                        },
                        activeColor: _getPriorityColor(priority),
                      ),
                    ],
                  ),

                  // Recurrence info
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'repeat',
                        size: 16,
                        color: isEnabled
                            ? AppTheme.textSecondary
                            : AppTheme.textDisabled,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _getRecurrenceText(recurrence),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isEnabled
                              ? AppTheme.textSecondary
                              : AppTheme.textDisabled,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(priority)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          taskType.toUpperCase(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: _getPriorityColor(priority),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Expanded details
                  if (_isExpanded) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Sound',
                              widget.alarm['sound'] as String? ?? 'Default'),
                          SizedBox(height: 1.h),
                          _buildDetailRow('Snooze',
                              '${widget.alarm['snoozeInterval'] ?? 5} minutes'),
                          SizedBox(height: 1.h),
                          _buildDetailRow('Max Snoozes',
                              '${widget.alarm['maxSnoozes'] ?? 3}'),
                          if (widget.alarm['nextTrigger'] != null) ...[
                            SizedBox(height: 1.h),
                            _buildDetailRow(
                                'Next', widget.alarm['nextTrigger'] as String),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action buttons overlay
          if (_showActions)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideActionButtons,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 60.w,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.cardColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadowLight,
                              blurRadius: 12,
                              offset: const Offset(-2, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton(
                              icon: 'edit',
                              label: 'Edit',
                              color: AppTheme.priorityNormal,
                              onTap: () {
                                _hideActionButtons();
                                widget.onEdit(widget.alarm);
                              },
                            ),
                            SizedBox(height: 2.h),
                            _buildActionButton(
                              icon: 'content_copy',
                              label: 'Duplicate',
                              color: AppTheme.secondaryLight,
                              onTap: () {
                                _hideActionButtons();
                                widget.onDuplicate(widget.alarm);
                              },
                            ),
                            SizedBox(height: 2.h),
                            _buildActionButton(
                              icon: 'volume_up',
                              label: 'Test Sound',
                              color: AppTheme.priorityLow,
                              onTap: () {
                                _hideActionButtons();
                                widget.onTestSound(widget.alarm);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 20,
              color: color,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Alarm',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete this alarm? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete(widget.alarm);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
              ),
              child: Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
