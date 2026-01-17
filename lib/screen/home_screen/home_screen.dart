import 'package:asp_chat/screen/bottom_navigator_items_screens/menu_screens/menu_screen.dart';
import 'package:asp_chat/widgets/custom_appbar.dart';
import 'package:asp_chat/widgets/custom_bottom_navigation_bar.dart';
import 'package:asp_chat/widgets/qr_code_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dialogue/exit_app_alert_dialogue.dart';
import '../../providers/user_info_provider.dart';
import '../bottom_navigator_items_screens/chat_gpt_screen/chat_gpt_screen.dart';
import '../bottom_navigator_items_screens/chat_screens/chat_screen.dart';
import '../bottom_navigator_items_screens/gemini_screen/gemini_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> pages = [ChatScreen(), GeminiScreen(), ChatGptScreen(), MenuScreen()];
  List<String> appBarTitles = ["Chats", "Gemini", "ChatGPT", "Menu",];
  List<List<Widget>> get appBarActions => [

    // Chats Page Actions
    [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 14, backgroundImage: AssetImage("assets/icon/icon.png"),),
          const SizedBox(width: 14),
        ],
      ),
    ],
    // Stories Page Actions
    [
      IconButton(
        icon: Icon(Icons.rocket_launch,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
        onPressed: () {},
      ),
    ],
    // Notifications Page Actions
    [
      IconButton(
        icon: Icon(Icons.rocket_launch,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
        onPressed: () {},
      ),
    ],
    // >>> QR Code Generator ===================================================
    [
      IconButton(
        icon: Icon(Icons.qr_code, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
        onPressed: _openQrBottomSheet,
      ),

    ],
    // <<< QR Code Generator ===================================================
  ];



  Future<void> _openQrBottomSheet() async {
    final userProvider = context.read<UserInfoProvider>();
    Map<String, dynamic>? userData = userProvider.userInfo;
    if (userData == null || userData.isEmpty) {userData = await userProvider.getUserData();}
    if (!mounted || userData == null) return;
    String? email = userData["email"];
    String? name = userData["name"];
    String username = email != null ? email.split('@').first : 'prothesbarai';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24)),),
      builder: (_) {return QrCodeBottomSheet(qrData: email ?? "", userName: name ?? "", userHandle: username,);},
    );
  }




  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic) {  if (didPop) {return;}  ExitAppAlertDialogue.willPopScope(context);},
      child: Scaffold(
        appBar: CustomAppbar(title: appBarTitles[_currentIndex], actions: appBarActions[_currentIndex],),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _currentIndex, onTap: (index) {setState(() {_currentIndex = index;});},),
        body: pages[_currentIndex],
      ),
    );
  }
}
