import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
class PushNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// >>> Set Notification Permission ==========================================
  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(alert: true, announcement: true, badge: true,sound: true,provisional: true);
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      debugPrint("User Granted Permission");
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      debugPrint("User Granted Provisional Permission");
    }else{
      // >>> If User Denied Notification Dis-allow
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }
  /// <<< Set Notification Permission ==========================================


  /// >>> FCM Token / Device Token =============================================
  Future<String?> getDeviceToken() async{
    final token = await messaging.getToken();
    return token;
  }
  /// <<< FCM Token / Device Token =============================================


  /// >>> Show Notification Foreground Background Or Terminated State ==========

  /// <<< Show Notification Foreground Background Or Terminated State ==========



}