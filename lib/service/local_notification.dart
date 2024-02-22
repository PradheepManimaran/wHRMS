import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> notification() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int? id, String? name, String? body, String? payload) async {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    linux: null,
    macOS: null,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Check Notification Permissions
  await _requestNotificationPermissions();
}

Future<void> _requestNotificationPermissions() async {
  final PermissionStatus permissionStatus =
      await Permission.notification.status;
  if (kDebugMode) {
    print('Notification Permission Status: $permissionStatus');
  }

  final PermissionStatus updatedStatus =
      await Permission.notification.request();
  if (kDebugMode) {
    print('Updated Notification Permission Status: $updatedStatus');
  }
}
