import 'dart:async';
import 'package:asp_chat/authentications/login_screen.dart';
import 'package:asp_chat/features/push_notification/push_notification_service.dart';
import 'package:asp_chat/providers/user_info_provider.dart';
import 'package:asp_chat/screen/home_screen/home_screen.dart';
import 'package:asp_chat/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _animation;
  late Timer _textTimer;

  final String _originalText = "ASPChat";
  String _currentText = "";
  int _charIndex = 0;

  PushNotificationService pushNotificationService = PushNotificationService();

  @override
  void initState() {
    super.initState();
    // >>> For Push Notification ===============================================
    pushNotificationService.requestNotificationPermission();
    pushNotificationService.firebaseInit(context);
    pushNotificationService.setupInteractMessage(context);
    pushNotificationService.foregroundMessage();
    pushNotificationService.getDeviceToken().then((value){
      debugPrint("Device Token");
      debugPrint(value);
      debugPrint("<<<Device Token>>>");
    });

    // <<< For Push Notification ===============================================
    final userData = Provider.of<UserInfoProvider>(context,listen: false);
    _animationController = AnimationController(vsync: this,duration: Duration(seconds: 2))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8,end: 1.2).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _textTimer = Timer.periodic(Duration(milliseconds: 150), (timer){
      if(_charIndex < _originalText.length){
        setState(() {
          _currentText += _originalText[_charIndex];
          _charIndex++;
        });
      }else{
        _textTimer.cancel();
        Future.microtask(() async {
          if(!mounted) return;
          final box = Hive.box("onBoardingPage");
          bool seen = await box.get("onboarding_seen",defaultValue: false);
          if(!mounted) return;
          if (isOpenedFromNotification) return;
          if(userData.isLoggedIn){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
          }else{
            if(seen){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),));
            }
          }
        });
      }
    });
  }



  @override
  void dispose() {
    _animationController.dispose();
    _textTimer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.splashGradient,),),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5),),],),
                  child: const Icon(Icons.chat, size: 80, color: AppColors.primaryColor,),
                ),
                const SizedBox(height: 20),
                Text(_currentText, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2,),),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}