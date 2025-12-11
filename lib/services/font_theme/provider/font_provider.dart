import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

enum AppFont {defaults, agbalumo, poppins}

class FontProvider with ChangeNotifier{
  AppFont _selectedFont = AppFont.defaults;
  AppFont get selectedFont => _selectedFont;

  FontProvider() {
    _loadFont();
  }

  void _loadFont() {
    final index = Hive.box('settings').get('font', defaultValue: 0);
    _selectedFont = AppFont.values[index];
  }


  void setFont(AppFont font) {
    _selectedFont = font;
    Hive.box('settings').put('font', font.index);
    notifyListeners();
  }


  TextStyle getTextStyle({double fontSize = 16, FontWeight fontWeight = FontWeight.normal,}) {
    switch (_selectedFont) {
      case AppFont.agbalumo:
        return GoogleFonts.agbalumo(fontSize: fontSize, fontWeight: fontWeight,);
      case AppFont.poppins:
        return GoogleFonts.poppins(fontSize: fontSize, fontWeight: fontWeight,);
      case AppFont.defaults:
        return TextStyle(fontSize: fontSize, fontWeight: fontWeight,);
    }
  }


}