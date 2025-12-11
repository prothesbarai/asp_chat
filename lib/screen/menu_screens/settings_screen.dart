import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/display_theme/theme_provider/theme_provider.dart';
import '../../services/display_theme/theme_selected_model/theme_selected_model.dart';
import '../../services/font_theme/font_selector_widget.dart';
import '../../services/font_theme/provider/font_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  /// >>> Need For Theme Changes Data ==========================================
  String _getDisplayThemeItemsName(AppThemeEnum theme){
    switch (theme){
      case AppThemeEnum.system:return "System Default";
      case AppThemeEnum.light:return "Light Mode";
      case AppThemeEnum.dark:return "Dark Mode";
    }
  }
  String _getFontItemsName(AppFont theme){
    switch (theme){
      case AppFont.defaults:return "Default";
      case AppFont.agbalumo:return "Agbalumo";
      case AppFont.poppins:return "Poppins";
    }
  }
  /// <<< Need For Theme Changes Data ==========================================

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);

    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text("Settings",),),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // PROFILE PHOTO + NAME + USERNAME
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(radius: 55, backgroundColor: Colors.red,),
                    CircleAvatar(radius: 18, child: Icon(Icons.camera_alt, size: 18),)
                  ],
                ),
                const SizedBox(height: 12),
                Text("Prothes Barai", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface,),),
                const SizedBox(height: 4),
                Text("@prothesbarai16", style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface,),),

              ],
            ),

            const SizedBox(height: 30),
            // SECTION: Home icon + name
            _menuItem(icon: Icons.home, title: "View security alerts",),
            const SizedBox(height: 10),
            // SECTION TITLE
            _sectionTitle("Accounts"),
            _menuItem(icon: Icons.switch_account, title: "Switch account",),
            const SizedBox(height: 20),
            _sectionTitle("Profile"),
            _menuItem(
              icon: Icons.dark_mode,
              title: "Select Theme",
              subtitle: _getDisplayThemeItemsName(themeProvider.selectedTheme),
              onTap: (){
                AppThemeEnum tempTheme = themeProvider.selectedTheme;
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text("Select Theme", style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          content: RadioGroup<AppThemeEnum>(
                            groupValue: tempTheme,
                            onChanged: (value) {
                              setState(() {tempTheme = value!;});
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile<AppThemeEnum>(value: AppThemeEnum.system,title: const Text("System Default"), activeColor: Colors.blue,),
                                RadioListTile<AppThemeEnum>(value: AppThemeEnum.light,title: const Text("Light Mode"), activeColor: Colors.blue,),
                                RadioListTile<AppThemeEnum>(value: AppThemeEnum.dark,title: const Text("Dark Mode"), activeColor: Colors.blue,)
                              ],
                            ),
                          ),
                          actions: [ElevatedButton(onPressed: () {themeProvider.updateTheme(tempTheme);Navigator.pop(context);}, child: const Text("Apply"),),],
                        );
                      },
                    );
                  },
                );
              },
            ),
            _menuItem(
              icon: Icons.font_download,
              title: "Select Font",
              subtitle: _getFontItemsName(fontProvider.selectedFont),
              onTap: (){
                AppFont fontTheme = fontProvider.selectedFont;
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AlertDialog(
                                title: Text("Select Font", style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                content: RadioGroup<AppFont>(
                                  groupValue: fontTheme,
                                  onChanged: (value) {
                                    setState(() {fontTheme = value!;});
                                    Navigator.pop(context);
                                  },
                                  child: FontSelectorWidget(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            _menuItem(icon: Icons.circle, title: "Active Status", subtitle: "On",),
            _menuItem(icon: Icons.alternate_email, title: "Username", subtitle: "m.me/prothesbarai16",),
            const SizedBox(height: 20),
            _sectionTitle("For families"),
            _menuItem(icon: Icons.family_restroom, title: "Family Centre",),
          ],
        ),
      ),
    );
  }

  // SECTION TITLE WIDGET
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(children: [Text(text, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),textAlign: TextAlign.start,),],),
    );
  }

  // MENU ITEM WIDGET
  Widget _menuItem({required IconData icon, required String title, String? subtitle, int? notificationCount,VoidCallback? onTap,}) {
    return ListTile(
      leading: Icon(icon,size: 28),
      title: Text(title, style: TextStyle(fontSize: 18)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 14)) : null,
      trailing: notificationCount != null ? Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle,),
        child: Text(notificationCount.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
      ) : null,
      onTap: onTap,
    );
  }
}
