import 'package:flutter/material.dart';

import '../../utils/constant/app_colors.dart';

class CustomAppTheme {
  static const primaryColor = AppColors.primaryColor;
  static const secondaryColor = AppColors.secondaryColor;

  // >>> ================================
  // LIGHT THEME
  // <<< ================================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(primary: primaryColor, secondary: secondaryColor, brightness: Brightness.light,),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: primaryColor, foregroundColor: secondaryColor, elevation: 3,),
    drawerTheme: const DrawerThemeData(backgroundColor: Color(0xffE3F2FD),shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20),),),),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: primaryColor, selectedItemColor: Colors.white, unselectedItemColor: Colors.white70,),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),), padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),),),
    inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: const Color(0xffE3F2FD), focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: primaryColor, width: 2), borderRadius: BorderRadius.circular(10),), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: secondaryColor), borderRadius: BorderRadius.circular(10),),),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black87), bodyMedium: TextStyle(color: Colors.black87), bodySmall: TextStyle(color: Colors.black54), displayLarge: TextStyle(color: Colors.black87), displayMedium: TextStyle(color: Colors.black87), displaySmall: TextStyle(color: Colors.black87), headlineLarge: TextStyle(color: Colors.black87), headlineMedium: TextStyle(color: Colors.black87), headlineSmall: TextStyle(color: Colors.black87), labelLarge: TextStyle(color: secondaryColor), labelMedium: TextStyle(color: secondaryColor), labelSmall: TextStyle(color: secondaryColor), titleLarge: TextStyle(color: primaryColor), titleMedium: TextStyle(color: primaryColor), titleSmall: TextStyle(color: primaryColor),),
    iconTheme: const IconThemeData(color: primaryColor, size: 24,),
    listTileTheme: const ListTileThemeData(iconColor: primaryColor, textColor: Colors.black87, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),),),
  );

  // >>> ================================
  // DARK THEME (Night Mode)
  // <<< ================================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(primary: primaryColor, secondary: secondaryColor, brightness: Brightness.dark,),
    scaffoldBackgroundColor: Color(0xff121212),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xff0A0A0A), foregroundColor: Colors.white, elevation: 2,),
    drawerTheme: const DrawerThemeData(backgroundColor: Color(0xff1E1E1E),shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20),),),),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Color(0xff0A0A0A), selectedItemColor: secondaryColor, unselectedItemColor: Colors.white60,),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),), padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),),),
    inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Color(0xff1E1E1E), focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: secondaryColor, width: 2), borderRadius: BorderRadius.circular(10),), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30), borderRadius: BorderRadius.circular(10),), labelStyle: TextStyle(color: secondaryColor), hintStyle: TextStyle(color: Colors.white60),),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white), bodyMedium: TextStyle(color: Colors.white70), bodySmall: TextStyle(color: Colors.white60), displayLarge: TextStyle(color: Colors.white), displayMedium: TextStyle(color: Colors.white), displaySmall: TextStyle(color: Colors.white), headlineLarge: TextStyle(color: Colors.white), headlineMedium: TextStyle(color: Colors.white), headlineSmall: TextStyle(color: Colors.white), labelLarge: TextStyle(color: primaryColor), labelMedium: TextStyle(color: primaryColor), labelSmall: TextStyle(color: primaryColor), titleLarge: TextStyle(color: secondaryColor), titleMedium: TextStyle(color: secondaryColor), titleSmall: TextStyle(color: secondaryColor),),
    iconTheme: const IconThemeData(color: secondaryColor),
    listTileTheme: const ListTileThemeData(iconColor: secondaryColor, textColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),),),
  );
}
