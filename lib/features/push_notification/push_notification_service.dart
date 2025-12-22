import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class PushNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// >>> Set Notification Permission ==========================================
  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(alert: true, announcement: true, badge: true, sound: true, provisional: true,);
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
  // >>> Refresh Token
  void isTokenRefresh() async{messaging.onTokenRefresh.listen((event){event.toString();});}
  /// <<< FCM Token / Device Token =============================================



  /// >>> Local Notification Initialization ====================================
  void initLocalNotification() async{
    var androidInitialization = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialization, iOS: iosInitialization);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {

      },
    );
  }
  /// <<< Local Notification Initialization ====================================



  /// >>> Show Notification Foreground Background Or Terminated State ==========
  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message){
      if (message.notification != null) {
        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);
        showFirebaseNotification(message);
      }else {
        debugPrint('Notification is null, data message received');
      }
    });
  }

  Future<void> showFirebaseNotification(RemoteMessage message) async{

    if (message.notification == null) return;

    // >>> For Android ==========
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',  // ID
      'High Importance Notifications', // title
      description: "This channel is used for important notifications.",
      importance: Importance.max, // Very Very Important this Notification
      showBadge: true,
      //playSound: true,
      //sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: channel.description.toString(),
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker' ,
      //playSound: true,
      //sound: channel.sound
    );

    // >>> For IOS
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails,iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero,() {
      _flutterLocalNotificationsPlugin.show(message.hashCode, message.notification!.title.toString(), message.notification!.body.toString(), notificationDetails);
    },);


  }
/// <<< Show Notification Foreground Background Or Terminated State ==========



}