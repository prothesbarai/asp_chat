import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:asp_chat/screen/global_screen/global_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class PushNotificationService {

  /// >>> Initialising firebase message plugin =================================
  FirebaseMessaging messaging = FirebaseMessaging.instance ;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();
  /// <<< Initialising firebase message plugin =================================


  /// >>> Show notifications for android when app is active ====================
  void initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(android: androidInitializationSettings , iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
        onDidReceiveNotificationResponse: (payload){
          // >>> handle interaction when app is active for android
          handleMessage(context, message);
        }
    );
  }
  /// <<< Show notifications for android when app is active ====================


  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;
      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }
      if(!context.mounted) return;
      if(Platform.isIOS){
        foregroundMessage();
      }
      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }


  /// >>> Set Notification Permission ==========================================
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(alert: true, announcement: true, badge: true, carPlay: true, criticalAlert: true, provisional: true, sound: true ,);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('user granted provisional permission');
    } else {
      // >>> If User Denied Notification
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      debugPrint('user denied permission');
    }
  }
  /// <<< Set Notification Permission ==========================================


  /// >>> Function to show visible notification when app is active =============
  Future<void> showNotification(RemoteMessage message)async{
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString() ,
        importance: Importance.max  ,
        //showBadge: true ,
        //playSound: true,
        //sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString() ,
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high ,
        ticker: 'ticker' ,
        //playSound: true,

        //sound: channel.sound
      //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true , presentBadge: true , presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero , (){_flutterLocalNotificationsPlugin.show(message.hashCode, message.notification!.title.toString(), message.notification!.body.toString(), notificationDetails ,);});
  }
  /// <<< Function to show visible notification when app is active =============


  /// >>> FCM Token / Device Token =============================================
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }
  void isTokenRefresh()async{messaging.onTokenRefresh.listen((event) {event.toString();});}
  /// <<< FCM Token / Device Token =============================================


  /// >>> Handle tap on notification when app is in background or terminated ===
  Future<void> setupInteractMessage(BuildContext context)async{
    // >>> when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(!context.mounted) return;
    if(initialMessage != null){handleMessage(context, initialMessage);}
    // >>> when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {if(!context.mounted) return;handleMessage(context, event);});
  }
  /// <<< Handle tap on notification when app is in background or terminated ===

  void handleMessage(BuildContext context, RemoteMessage message) {
    if(message.data['type'] =='msj'){}
    Navigator.push(context, MaterialPageRoute(builder: (context) => GlobalScreen(),));
  }


  Future foregroundMessage() async {await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true,);}


}