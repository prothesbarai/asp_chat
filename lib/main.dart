import 'package:asp_chat/providers/user_info_provider.dart';
import 'package:asp_chat/screen/splash_screen/splash_screen.dart';
import 'package:asp_chat/services/font_theme/provider/font_provider.dart';
import 'package:asp_chat/services/hive_service/hive_service.dart';
import 'package:asp_chat/services/network_connection_check/network_checker_provider.dart';
import 'package:asp_chat/services/network_connection_check/network_checker_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    HiveService.initHive(),
    Firebase.initializeApp(),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]),
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, systemNavigationBarColor: Colors.transparent, systemNavigationBarDividerColor: Colors.transparent, statusBarIconBrightness: Brightness.light, systemNavigationBarIconBrightness: Brightness.light,),);

  runApp(
    MultiProvider(
        providers: [
          // >>> Connection Checker ============================================
          ChangeNotifierProvider(create: (_) => NetworkCheckerProvider()),
          // >>> UserInfoProvider  =============================================
          ChangeNotifierProvider(create: (_) => UserInfoProvider()),
          // >>> Font Provider  ================================================
          ChangeNotifierProvider(create: (_) => FontProvider()),
        ],
      child: const AspChatApp(),
    )
  );
}

class AspChatApp extends StatelessWidget {
  const AspChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    return MaterialApp(
      title: 'ASPChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: fontProvider.getTextStyle(),
          bodyMedium: fontProvider.getTextStyle(),
          bodySmall: fontProvider.getTextStyle(),
          headlineLarge: fontProvider.getTextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: fontProvider.getTextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          headlineSmall: fontProvider.getTextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          labelLarge: fontProvider.getTextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          labelMedium: fontProvider.getTextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelSmall: fontProvider.getTextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          titleLarge: fontProvider.getTextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          titleMedium: fontProvider.getTextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          titleSmall: fontProvider.getTextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          displayLarge: fontProvider.getTextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: fontProvider.getTextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          displaySmall: fontProvider.getTextStyle(fontWeight: FontWeight.normal, color: Colors.white),
        ),
      ),
      // >>> Connection Checker ================================================
      builder: (context, child) {
        if(child == null) return const SizedBox.shrink();
        return NetworkCheckerUi(child: child);
      },
      // <<< Connection Checker ================================================
      home: const SplashScreen(),
    );
  }
}

