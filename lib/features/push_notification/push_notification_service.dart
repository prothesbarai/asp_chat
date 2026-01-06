import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:asp_chat/screen/global_screen/anniversary_screen/anniversary_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';
import '../../screen/global_screen/couple_daily_love/couple_daily_love.dart';
import 'in_app_dialogue.dart';


class PushNotificationService {

  /// >>> Initialising firebase message plugin =================================
  FirebaseMessaging messaging = FirebaseMessaging.instance ;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();
  /// <<< Initialising firebase message plugin =================================


  /// >>> Show notifications for android when app is active ====================
  void initLocalNotifications(RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(android: androidInitializationSettings , iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
        onDidReceiveNotificationResponse: (payload){
          // >>> handle interaction when app is active for android
          handleMessage(message);
        }
    );
  }
  /// <<< Show notifications for android when app is active ====================


  /// >>> Notification Initialization ==========================================
  void notificationInitialization(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;
      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if(Platform.isAndroid){
        initLocalNotifications(message);
        showNotification(message);
      }

      if(Platform.isIOS){
        foregroundMessage();
      }

      // >>> Only When App is Open then Show a Dialogue
      if (navigatorKey.currentState != null) {
        inAppDialogue(navigatorKey.currentState!, message, () {handleMessage(message);},);
      }
      // <<< Only When App is Open then Show a Dialogue

    });
  }
  /// <<< Notification Initialization ==========================================
  

  /// >>> FCM Token / Device Token =============================================
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }
  void isTokenRefresh()async{messaging.onTokenRefresh.listen((event) {event.toString();});}
  /// <<< FCM Token / Device Token =============================================


  /// >>> Subscribe all users to global topic ==================================
  Future<void> subscribeAllUsersTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("all_users");
    if (kDebugMode) {debugPrint("Subscribed to topic: all_users");}
  }
  /// <<< Subscribe all users to global topic ==================================


  /// >>> Set Notification Permission ==========================================
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(alert: true, announcement: true, badge: true, carPlay: true, criticalAlert: true, provisional: true, sound: true,);
    if (settings.authorizationStatus == AuthorizationStatus.authorized || settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('Notification permission granted');
      // >>> HERE topic subscribe
      await subscribeAllUsersTopic();
    }else {
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
        //sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
        //icon: largeIconPath
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true , presentBadge: true , presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero , (){_flutterLocalNotificationsPlugin.show(message.hashCode, message.notification!.title.toString(), message.notification!.body.toString(), notificationDetails ,);});
  }
  /// <<< Function to show visible notification when app is active =============


  /// >>> Handle tap on notification when app is in background or terminated ===
  Future<void> setupInteractMessage(BuildContext context)async{
    // >>> when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){handleMessage(initialMessage);}
    // >>> when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {handleMessage(event);});
  }
  /// <<< Handle tap on notification when app is in background or terminated ===


  /// >>> Navigate Page Handled Function =======================================
  void handleMessage(RemoteMessage message) {
    isOpenedFromNotification = true;
    final data = anyMapEmptySpaceRemover(message.data);
    final anniversary = data['anniversary'];
    final coupleDailyLove = data['coupleDailyLove'];
    final type3 = data['click_action_v1'];
    final type4 = data['click_action_v2'];
    final type5 = data['click_action'];
    if (kDebugMode) {print('FCM Data: $data');print('Type: $anniversary $coupleDailyLove $type3 $type4 $type5');}
    if (anniversary == 'anniversary') {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => AnniversaryScreen(),),);
    }
    else {
      // >>> default
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => CoupleDailyLove(),),);
    }
  }
  /// <<< Navigate Page Handled Function =======================================


  /// >>> For Only IOS Foreground Navigate Purpose =============================
  Future foregroundMessage() async {await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true,);}
  /// <<< For Only IOS Foreground Navigate Purpose =============================
  
  
  /// >>> For Empty Space Remover Method For Multipage Navigate ================
  Map<String,dynamic> anyMapEmptySpaceRemover(Map<String, dynamic> data){
    final cleanMap = <String,dynamic>{};
    data.forEach((key,value){
      cleanMap[key.trim()] = value is String ? value.trim() : value;
    });
    return cleanMap;
  }
  /// <<< For Empty Space Remover Method For Multipage Navigate ================
}