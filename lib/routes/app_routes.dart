import 'package:flutter/material.dart';
import '../presentation/task_creation_edit/task_creation_edit.dart';
import '../presentation/daily_planner/daily_planner.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/notifications_alarms/notifications_alarms.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/task_management/task_management.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String taskCreationEdit = '/task-creation-edit';
  static const String dailyPlanner = '/daily-planner';
  static const String splash = '/splash-screen';
  static const String notificationsAlarms = '/notifications-alarms';
  static const String dashboardHome = '/dashboard-home';
  static const String taskManagement = '/task-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    taskCreationEdit: (context) => const TaskCreationEdit(),
    dailyPlanner: (context) => const DailyPlanner(),
    splash: (context) => const SplashScreen(),
    notificationsAlarms: (context) => const NotificationsAlarms(),
    dashboardHome: (context) => const DashboardHome(),
    taskManagement: (context) => const TaskManagement(),
    // TODO: Add your other routes here
  };
}
