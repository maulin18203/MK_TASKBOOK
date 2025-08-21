import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlarmStatisticsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> alarms;
  final VoidCallback onClose;

  const AlarmStatisticsWidget({
    Key? key,
    required this.alarms,
    required this.onClose,
  }) : super(key: key);

  Map<String, int> _getAlarmEffectiveness() {
    int totalAlarms = alarms.length;
    int completedOnTime = (alarms
                .where((alarm) => (alarm['completedOnTime'] as bool? ?? false))
                .length *
            0.7)
        .round();
    int snoozedOnce = (alarms
                .where((alarm) => (alarm['snoozedOnce'] as bool? ?? false))
                .length *
            0.2)
        .round();
    int missedAlarms = totalAlarms - completedOnTime - snoozedOnce;

    return {
      'completed': completedOnTime,
      'snoozed': snoozedOnce,
      'missed': missedAlarms > 0 ? missedAlarms : (totalAlarms * 0.1).round(),
    };
  }

  Map<String, double> _getSnoozePatterns() {
    return {
      'Mon': 2.5,
      'Tue': 1.8,
      'Wed': 3.2,
      'Thu': 2.1,
      'Fri': 4.5,
      'Sat': 1.2,
      'Sun': 0.8,
    };
  }

  List<Map<String, dynamic>> _getRecentActivity() {
    return [
      {
        'date': '2025-08-21',
        'time': '07:00',
        'label': 'Morning Workout',
        'status': 'completed',
        'snoozes': 0,
      },
      {
        'date': '2025-08-21',
        'time': '09:30',
        'label': 'Team Meeting',
        'status': 'snoozed',
        'snoozes': 1,
      },
      {
        'date': '2025-08-20',
        'time': '22:00',
        'label': 'Bedtime Reminder',
        'status': 'completed',
        'snoozes': 0,
      },
      {
        'date': '2025-08-20',
        'time': '14:00',
        'label': 'Project Deadline',
        'status': 'missed',
        'snoozes': 3,
      },
      {
        'date': '2025-08-19',
        'time': '08:00',
        'label': 'Daily Standup',
        'status': 'completed',
        'snoozes': 0,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final effectiveness = _getAlarmEffectiveness();
    final snoozePatterns = _getSnoozePatterns();
    final recentActivity = _getRecentActivity();

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Alarm Statistics',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 48), // Balance the close button
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Alarms',
                          '${alarms.length}',
                          AppTheme.primaryLight,
                          'alarm',
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildStatCard(
                          'Active',
                          '${alarms.where((a) => a['enabled'] == true).length}',
                          AppTheme.success,
                          'notifications_active',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Avg Snoozes',
                          '1.8',
                          AppTheme.warning,
                          'snooze',
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildStatCard(
                          'Success Rate',
                          '78%',
                          AppTheme.priorityLow,
                          'trending_up',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Effectiveness chart
                  Text(
                    'Alarm Effectiveness',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Container(
                    height: 30.h,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: effectiveness['completed']!.toDouble(),
                                  color: AppTheme.success,
                                  title: '${effectiveness['completed']}',
                                  radius: 60,
                                  titleStyle: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: effectiveness['snoozed']!.toDouble(),
                                  color: AppTheme.warning,
                                  title: '${effectiveness['snoozed']}',
                                  radius: 60,
                                  titleStyle: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: effectiveness['missed']!.toDouble(),
                                  color: AppTheme.error,
                                  title: '${effectiveness['missed']}',
                                  radius: 60,
                                  titleStyle: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegendItem('Completed', AppTheme.success),
                            _buildLegendItem('Snoozed', AppTheme.warning),
                            _buildLegendItem('Missed', AppTheme.error),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Snooze patterns
                  Text(
                    'Weekly Snooze Patterns',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Container(
                    height: 25.h,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 5,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun'
                                ];
                                return Text(
                                  days[value.toInt()],
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: snoozePatterns.entries.map((entry) {
                          final index =
                              snoozePatterns.keys.toList().indexOf(entry.key);
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value,
                                color: AppTheme.primaryLight,
                                width: 20,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Recent activity
                  Text(
                    'Recent Activity',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentActivity.length,
                      separatorBuilder: (context, index) => Divider(
                        color: AppTheme.dividerLight,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final activity = recentActivity[index];
                        return _buildActivityItem(activity);
                      },
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                size: 24,
                color: color,
              ),
              const Spacer(),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final status = activity['status'] as String;
    final snoozes = activity['snoozes'] as int;

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'completed':
        statusColor = AppTheme.success;
        statusIcon = Icons.check_circle;
        break;
      case 'snoozed':
        statusColor = AppTheme.warning;
        statusIcon = Icons.snooze;
        break;
      case 'missed':
        statusColor = AppTheme.error;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppTheme.textSecondary;
        statusIcon = Icons.help;
    }

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['label'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${activity['date']} at ${activity['time']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (snoozes > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$snoozes snooze${snoozes > 1 ? 's' : ''}',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.warning,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
