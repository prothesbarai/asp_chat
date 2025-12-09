import 'package:asp_chat/screen/splash_screen/splash_screen.dart';
import 'package:asp_chat/services/hive_service/hive_service.dart';
import 'package:asp_chat/services/network_connection_check/network_checker_provider.dart';
import 'package:asp_chat/services/network_connection_check/network_checker_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
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
        ],
      child: const AspChatApp(),
    )
  );
}

class AspChatApp extends StatelessWidget {
  const AspChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASPChat',
      debugShowCheckedModeBanner: false,
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

