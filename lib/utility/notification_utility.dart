import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showNotification(String name, String message) async {
  tz.initializeTimeZones();
  final location = tz.getLocation('Asia/Tokyo');
  final now = tz.TZDateTime.now(location);
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    name,
    message,
    now,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        styleInformation: BigTextStyleInformation(
          message,
        ),
        icon: 'ic_notification',
      ),
      iOS: const DarwinNotificationDetails(
        badgeNumber: 1,
      ),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> requestPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}
