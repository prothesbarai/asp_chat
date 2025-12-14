import 'package:asp_chat/providers/user_info_provider.dart';
import 'package:asp_chat/screen/splash_screen/splash_screen.dart';
import 'package:asp_chat/services/display_theme/custom_app_theme.dart';
import 'package:asp_chat/services/display_theme/theme_provider/theme_provider.dart';
import 'package:asp_chat/services/font_theme/build_font_text_theme.dart';
import 'package:asp_chat/services/font_theme/provider/font_provider.dart';
import 'package:asp_chat/services/hive_service/hive_service.dart';
import 'package:asp_chat/services/network_connection_check/network_checker_provider.dart';
import 'package:asp_chat/services/network_connection_check/network_checker_ui.dart';
import 'package:asp_chat/services/set_user_image/user_image_provider/user_image_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(),
    HiveService.initHive(),
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
          // >>> Theme Provider  ===============================================
          ChangeNotifierProvider(create: (_) => FontProvider()),
          // >>> Font Provider  ================================================
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          // >>> User Profile Image Provider  ==================================
          ChangeNotifierProvider(create: (context) => UserImageProvider()),
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ASPChat',
          debugShowCheckedModeBanner: false,
          // >>> Font With Light Dark Mode =====================================
          theme: CustomAppTheme.lightTheme.copyWith(textTheme: buildFontTextTheme(fontProvider),),
          darkTheme: CustomAppTheme.darkTheme.copyWith(textTheme: buildFontTextTheme(fontProvider, darkMode: true),),
          themeMode: themeProvider.themeMode,
          // <<< Font With Light Dark Mode =====================================
          // >>> Connection Checker ============================================
          builder: (context, child) {
            if(child == null) return const SizedBox.shrink();
            return NetworkCheckerUi(child: child);
          },
          // <<< Connection Checker ============================================
          home: const SplashScreen(),
        );
      },
    );
  }
}

