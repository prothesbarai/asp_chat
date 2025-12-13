import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserImageProvider with ChangeNotifier{
  File? _profileImage;
  final _box = Hive.box("StoreUserImages");
  File? get profileImage => _profileImage;

  UserImageProvider(){initFetch();}

  /// >>> Initially Fetch User Profile Image From Hive =========================
  Future<void> initFetch() async{
    final String? imgPath =_box.get("store_user_image_path");
    if(imgPath != null){
      final File file = File(imgPath);
      if(await file.exists()){
        _profileImage = file;
        notifyListeners();
      }
    }
  }
  /// <<< Initially Fetch User Profile Image From Hive =========================


  /// >>> Save Profile Image to Hive ===========================================
  Future<void> saveUserProfileImage(File image) async{
    _profileImage = image;
    await _box.put("store_user_image_path", image.path);
    notifyListeners();
  }
  /// <<< Save Profile Image to Hive ===========================================


  /// >>> Remove Function From Hive User Profile Image =========================
  Future<void> removeUserProfileImage() async{
    _profileImage = null;
    await _box.delete("store_user_image_path");
    notifyListeners();
  }
  /// <<< Remove Function From Hive User Profile Image =========================

}