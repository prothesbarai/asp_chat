import 'package:asp_chat/widgets/custom_appbar.dart';
import 'package:asp_chat/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../menu_screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    Center(child: Text("Chats Page", style: TextStyle(fontSize: 20))),
    Center(child: Text("Stories Page", style: TextStyle(fontSize: 20))),
    Center(child: Text("Notifications Page", style: TextStyle(fontSize: 20))),
    //Center(child: Text("Menu Page", style: TextStyle(fontSize: 20))),
    SettingsScreen()
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "ASPChat"),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _currentIndex, onTap: (index) {setState(() {_currentIndex = index;});},),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50),),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text("Search....", style: TextStyle(color: Colors.grey.shade400, fontSize: 16,),),),
              ],
            ),
          ),

          // Body content
          Expanded(child: pages[_currentIndex],),
        ],
      ),
    );
  }
}
