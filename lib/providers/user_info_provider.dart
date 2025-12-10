import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class UserInfoProvider with ChangeNotifier{

  String? _userId;
  String? get userId => _userId;
  final _box = Hive.box("storeUserId");


  UserInfoProvider(){
    _loadFromHive();
  }


  Future<void> _loadFromHive() async {
    _userId = await _box.get("userId");
  }

  Future<void> loadUserInfo(String uid) async{
    await _box.put("userId", uid);
    _userId = uid;
    notifyListeners();
  }


}