import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmNotificationService {
  AlarmNotificationService._();
  static final AlarmNotificationService instance = AlarmNotificationService._();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit);
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        // Notification tap handle (app open / background)
        print("Alarm Notification Clicked: $payload");
      },
    );
  }

  Future<void> scheduleAlarm(DateTime dateTime) async {
    await _plugin.zonedSchedule(
      1001,
      'Alarm',
      'Time is up!',
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notification',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm1'),
          fullScreenIntent: true,
        )
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      /*uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,*/
    );
  }

  Future<void> cancelAlarm() async {
    await _plugin.cancel(1001);
  }
}


