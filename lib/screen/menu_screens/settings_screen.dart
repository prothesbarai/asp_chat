import 'package:asp_chat/services/font_theme/provider/font_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/display_theme/theme_provider/theme_provider.dart';
import '../../services/display_theme/theme_selected_model/theme_selected_model.dart';
import '../../services/font_theme/font_selector_widget.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // >>> Display Theme =================================================
          ListTile(
            leading: Icon(Icons.color_lens,color: Theme.of(context).iconTheme.color,size: 35,),
            title: Text("App Preferences",style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),),
            subtitle: Text("Theme : ${_getDisplayThemeItemsName(themeProvider.selectedTheme)}",style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),),
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
          // <<< Display Theme =================================================

          // >>> Font Theme ====================================================
          ListTile(
            leading: Icon(Icons.font_download,color: Theme.of(context).iconTheme.color,size: 35,),
            title: Text("Selected Font",style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),),
            subtitle: Text("Font : ${_getFontItemsName(fontProvider.selectedFont)}",style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),),
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
          // <<< Font Theme ====================================================

        ],
      ),
    );
  }
}
