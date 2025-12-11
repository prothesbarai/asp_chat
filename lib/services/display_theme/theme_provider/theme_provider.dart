import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../theme_selected_model/theme_selected_model.dart';
class ThemeProvider with ChangeNotifier{

  static const String _themeKey = 'selectedTheme';
  final Box _themeBox = Hive.box("AppThemeEnumFlag");
  AppThemeEnum _selectedTheme = AppThemeEnum.system;
  bool _isDarkMode = false;

  AppThemeEnum get selectedTheme => _selectedTheme;
  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode{
    switch (_selectedTheme){
      case AppThemeEnum.light:
        return ThemeMode.light;
      case AppThemeEnum.dark:
        return ThemeMode.dark;
      case AppThemeEnum.system:
        return ThemeMode.system;
    }
  }

  ThemeProvider(){
    loadTheme();
  }


  // >>> First Time Load Theme =================================================
  Future<void> loadTheme() async{
    final savedTheme = _themeBox.get(_themeKey,defaultValue: AppThemeEnum.system);
    if(savedTheme is AppThemeEnum){
      _selectedTheme = savedTheme;
    }else{
      _selectedTheme = AppThemeEnum.system;
    }
    _updateDarkMode();
    notifyListeners();
  }
  // <<< First Time Load Theme =================================================




  // >>> Save Update Theme =====================================================
  Future<void> updateTheme(AppThemeEnum theme) async{
    _selectedTheme = theme;
    _updateDarkMode();
    await _themeBox.put(_themeKey, theme);
    notifyListeners();
  }
  // <<< Save Update Theme =====================================================




  // >>> Auto Update Dark Mode Value ===========================================
  void _updateDarkMode(){
    if(_selectedTheme == AppThemeEnum.dark){
      _isDarkMode = true;
    }else if(_selectedTheme == AppThemeEnum.light){
      _isDarkMode = false;
    }else{
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
    }
  }
  // <<< Auto Update Dark Mode Value ===========================================


  // >>> Clear Hive Data =======================================================
  Future<void> clearTheme() async{
    await _themeBox.clear();
    _isDarkMode = false;
    _selectedTheme = AppThemeEnum.system;
    notifyListeners();
  }
  // <<< Clear Hive Data =======================================================

}