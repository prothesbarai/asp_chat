import 'package:asp_chat/screen/bottom_navigator_items_screens/menu_screens/sub_menu_screens/entertainment/entertainment_screen.dart';
import 'package:asp_chat/screen/bottom_navigator_items_screens/menu_screens/sub_menu_screens/settings_screen.dart';
import 'package:asp_chat/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../authentications/login_screen.dart';
import '../../../providers/user_info_provider.dart';
import '../../../services/set_user_image/user_image_provider/user_image_provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {


  void _navigateLoginPage(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false,);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<UserImageProvider>(context);
    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userProvider.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {return  Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),);}
            if (!snapshot.hasData || snapshot.data == null) {return const Center(child: Text("User data not found"));}
            final userData = snapshot.data!;
            final name = userData['name'];
            final email = userData['email'];
            final username = email != null ? email.split('@').first : 'prothesbarai';
            return ListView(
              children: [
                // >>> Profile Section ===============================================
                ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: (imageProvider.profileImage == null) ? Color(0xff1f2b3b) : null,
                    backgroundImage: (imageProvider.profileImage != null) ? FileImage(imageProvider.profileImage!) : null,
                    child: (imageProvider.profileImage == null) ? Icon(Icons.person, size: 34,) : null,
                  ),
                  title: Text(name ?? "Prothes Barai", style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("@$username"),
                  onTap: () {},
                ),
                // <<< Profile Section ===============================================

                const Divider(),
                menuItem(icon: Icons.settings, title: "Settings",onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));}),
                const Divider(thickness: 6),
                menuItem(icon: Icons.movie_filter_outlined, title: "Entertainment",onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => EntertainmentScreen(),));}),
                menuItem(icon: Icons.message, title: "Message requests",onTap: (){}),
                menuItem(icon: Icons.archive, title: "Archive",onTap: (){}),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("More", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey,),),
                ),
                menuItem(
                  icon: Icons.logout,
                  title: "Log out",
                  onTap: () async {
                    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);
                    await userProvider.clearUser();
                    if (!mounted) return;
                    _navigateLoginPage();
                  },
                ),

              ],
            );
          },
      )
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
}
