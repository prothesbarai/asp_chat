import 'package:asp_chat/features/font_theme/provider/font_provider.dart';
import 'package:flutter/material.dart';

TextTheme  buildFontTextTheme(FontProvider fontProvider, {bool darkMode = false}){
  return TextTheme(
    bodyLarge: fontProvider.getTextStyle(),
    bodyMedium: fontProvider.getTextStyle(),
    bodySmall: fontProvider.getTextStyle(),
    headlineLarge: fontProvider.getTextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: fontProvider.getTextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: fontProvider.getTextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    labelLarge: fontProvider.getTextStyle(fontWeight: FontWeight.bold,),
    labelMedium: fontProvider.getTextStyle(fontWeight: FontWeight.w500,),
    labelSmall: fontProvider.getTextStyle(fontWeight: FontWeight.normal,),
    titleLarge: fontProvider.getTextStyle(fontWeight: FontWeight.bold,),
    titleMedium: fontProvider.getTextStyle(fontWeight: FontWeight.w500,),
    titleSmall: fontProvider.getTextStyle(fontWeight: FontWeight.normal,),
    displayLarge: fontProvider.getTextStyle(fontWeight: FontWeight.bold,),
    displayMedium: fontProvider.getTextStyle(fontWeight: FontWeight.w500,),
    displaySmall: fontProvider.getTextStyle(fontWeight: FontWeight.normal,),
  );
}