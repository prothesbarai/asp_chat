import 'package:asp_chat/widgets/custom_appbar.dart';
import 'package:asp_chat/widgets/custom_bottom_navigation_bar.dart';
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
    Demo(title: "Menu",),
  ];

  List<String> appBarTitles = ["Chats", "Stories", "Notifications", "Menu",];

  List<List<Widget>> appBarActions = [
    // Chats Page Actions
    [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black45),
            onPressed: () {
              print("Chat icon clicked");
            },
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey.shade700,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 14),
        ],
      ),
    ],
    // Stories Page Actions
    [
      IconButton(
        icon: Icon(Icons.camera_alt, color: Colors.black45),
        onPressed: () {
          print("Camera clicked");
        },
      ),
    ],
    // Notifications Page Actions
    [
      IconButton(
        icon: Icon(Icons.notifications, color: Colors.black45),
        onPressed: () {
          print("Notifications clicked");
        },
      ),
    ],
    // Menu Page Actions
    [
      IconButton(
        icon: Icon(Icons.settings, color: Colors.black45),
        onPressed: () {
          print("Settings clicked");
        },
      ),
    ],
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
