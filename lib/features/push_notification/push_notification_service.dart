import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  /// >>> Initialization Here ==================================================
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  /// <<< Initialization Here ==================================================


  /// >>> Set Notification Permission ==========================================
  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(alert: true,badge: true,sound: true,provisional: true,announcement: true);
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      debugPrint("User Granted Permission");
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      debugPrint("User Granted Provisional Permission");
    }else{
      // >>> If User Denied Notification Permission
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }
  /// <<< Set Notification Permission ==========================================

}