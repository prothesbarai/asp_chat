import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmService {
  AlarmService._();
  static final AlarmService instance = AlarmService._();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();


  static const MethodChannel _channel =
  MethodChannel('exact_alarm_permission');

  Future<void> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('requestExactAlarm');
    } catch (e) {
      debugPrint('Exact alarm permission error: $e');
    }
  }

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings =
    InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);
  }

  Future<void> setAlarm({required int id, required String title, required String body, required DateTime dateTime,}) async {
    await _plugin.zonedSchedule(id, title, body, tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('alarm_channel', 'Alarm Channel', importance: Importance.max, priority: Priority.high, playSound: true, fullScreenIntent: true,),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }


  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;

    const channel = MethodChannel('exact_alarm_permission');
    try {
      final bool allowed =
      await channel.invokeMethod('canScheduleExactAlarms');
      return allowed;
    } catch (_) {
      return false;
    }
  }


}
