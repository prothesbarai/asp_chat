import 'package:asp_chat/screen/bottom_navigator_items_screens/menu_screens/sub_menu_screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/set_user_image/user_image_provider/user_image_provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<UserImageProvider>(context);
    return Scaffold(
      body: ListView(
        children: [
          // >>> Profile Section ===============================================
          ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: (imageProvider.profileImage == null) ? Color(0xff1f2b3b) : null,
              backgroundImage: (imageProvider.profileImage != null) ? FileImage(imageProvider.profileImage!) : null,
              child: (imageProvider.profileImage == null) ? Icon(Icons.person, size: 34,) : null,
            ),
            title: const Text("Prothes Barai", style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: const Text("username"),
            onTap: () {},
          ),
          // <<< Profile Section ===============================================

          const Divider(),
          menuItem(icon: Icons.settings, title: "Settings",onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));}),
          const Divider(thickness: 6),
          menuItem(icon: Icons.storefront, title: "Marketplace",onTap: (){}),
          menuItem(icon: Icons.message, title: "Message requests",onTap: (){}),
          menuItem(icon: Icons.archive, title: "Archive",onTap: (){}),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("More", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey,),),
          ),
          menuItem(icon: Icons.group, title: "Friend requests",onTap: (){}),
        ],
      ),
    );
  }


  /// >>> Menu Items Builder ===================================================
  Widget menuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16),),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
  /// <<< Menu Items Builder ===================================================
}
