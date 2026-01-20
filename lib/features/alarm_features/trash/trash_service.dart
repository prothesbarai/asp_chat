/*
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmService {
  AlarmService._();
  static final AlarmService instance = AlarmService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  final bool _isExactAlarmPermitted = false;
  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const settings = InitializationSettings(android: androidInit);
      await _plugin.initialize(settings, onDidReceiveNotificationResponse: (response) {debugPrint('Notification tapped: ${response.payload}');},);
      await _createNotificationChannel();
      debugPrint('AlarmService initialized. Exact alarm permitted: $_isExactAlarmPermitted');
    } catch (e) {
      debugPrint('Error initializing AlarmService: $e');
    }
  }



  Future<void> _createNotificationChannel() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'alarm_channel_test',
        'Alarm Test Channel',
        description: 'Immediate test alarm notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm'),
        enableVibration: true,
      );
      await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    }
  }

  Future<void> fireImmediateAlarm() async {
    try {
      final notificationId = DateTime.now().millisecondsSinceEpoch % 10000;

      await _createNotificationChannel();

      final androidDetails = AndroidNotificationDetails(
        'alarm_channel_test',
        'Alarm Test Channel',
        channelDescription: 'Immediate test alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('alarm'),
        fullScreenIntent: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
        category: AndroidNotificationCategory.alarm,
        colorized: true,
        color: Colors.red,
      );

      // Try different approaches based on Android version
      if (Platform.isAndroid) {
        // For Android 14+, use a different approach
        await _showNotificationImmediately(notificationId, androidDetails);
      } else {
        // For older versions, use exact scheduling
        await _plugin.zonedSchedule(
          notificationId,
          '💊 Pill Reminder',
          'Medicine নেওয়ার সময় হয়েছে',
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
          NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }

      debugPrint('Alarm fired with ID: $notificationId');
    } catch (e) {
      debugPrint('Error firing alarm: $e');
    }
  }

  Future<void> _showNotificationImmediately(int id, AndroidNotificationDetails details) async {
    // Show notification immediately without exact scheduling
    await _plugin.show(
      id,
      '💊 Pill Reminder',
      'Medicine নেওয়ার সময় হয়েছে',
      NotificationDetails(android: details),
    );
  }
}*/
