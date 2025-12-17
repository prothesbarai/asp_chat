import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserInfoProvider with ChangeNotifier{

  Map<String,dynamic>? _userInfo;
  Map<String,dynamic>? get userInfo => _userInfo;
  final _box = Hive.box("storeUserInfo");


  UserInfoProvider(){
    _loadFromHive();
  }


  Future<void> _loadFromHive() async {
    _userInfo = await _box.get("userData");
    notifyListeners();
  }

  Future<void> storeHive(Map<String,dynamic> userData) async{
    await _box.put("userData", userData);
    _userInfo = userData;
    notifyListeners();
  }


  String? get uid => _userInfo?["uid"];
}