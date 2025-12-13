import 'package:asp_chat/screen/bottom_navigator_items_screens/menu_screens/menu_screen.dart';
import 'package:asp_chat/widgets/custom_appbar.dart';
import 'package:asp_chat/widgets/custom_bottom_navigation_bar.dart';
import 'package:asp_chat/widgets/qr_code_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../demo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> pages = [
    Demo(title: "Chats",),
    Demo(title: "Stories",),
    Demo(title: "Notifications",),
    MenuScreen()
  ];

  List<String> appBarTitles = ["Chats", "Stories", "Notifications", "Menu",];

  List<List<Widget>> get appBarActions => [
    // Chats Page Actions
    [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
            onPressed: () {
              print("Chat icon clicked");
            },
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey.shade700,
            child: Icon(Icons.person,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
          ),
          const SizedBox(width: 14),
        ],
      ),
    ],
    // Stories Page Actions
    [
      IconButton(
        icon: Icon(Icons.camera_alt,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
        onPressed: () {
          print("Camera clicked");
        },
      ),
    ],
    // Notifications Page Actions
    [
      IconButton(
        icon: Icon(Icons.notifications,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
        onPressed: () {
          print("Notifications clicked");
        },
      ),
    ],
    // >>> QR Code Generator ===================================================
    [
      IconButton(
        icon: Icon(Icons.qr_code, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24)),),
            builder: (context) {return QrCodeBottomSheet(qrData: "qrData", userName: "userName", userHandle: "userHandle",);},
          );
        },
      ),

    ],
    // <<< QR Code Generator ===================================================
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: appBarTitles[_currentIndex], actions: appBarActions[_currentIndex],),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _currentIndex, onTap: (index) {setState(() {_currentIndex = index;});},),
      body: pages[_currentIndex],
    );
  }
}
