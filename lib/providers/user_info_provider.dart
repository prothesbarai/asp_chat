import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserInfoProvider with ChangeNotifier {
  static const String _userKey = "userData";

  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? get userInfo => _userInfo;

  late final Box _box;

  /// Constructor
  UserInfoProvider() {
    _box = Hive.box("storeUserInfo");
    _loadFromHive();
  }

  /// Load user data from Hive
  void _loadFromHive() {
    final data = _box.get(_userKey);
    if (data != null && data is Map) {
      _userInfo = Map<String, dynamic>.from(data);
    } else {
      _userInfo = null;
    }
    notifyListeners();
  }

  /// Save user data to Hive
  Future<void> storeHive(Map<String, dynamic> userData) async {
    _userInfo = userData;
    await _box.put(_userKey, userData);
    notifyListeners();
  }

  /// >>> Force reload from Hive
  void refresh() {
    _loadFromHive();
  }

  /// >>> Clear data on logout
  Future<void> clearUser() async {
    _userInfo = null;
    await _box.delete(_userKey);
    notifyListeners();
  }

  /// >>>  Check login state ===================================================
  bool get isLoggedIn => _userInfo != null && _userInfo!["uid"] != null;
  /// <<<  Check login state ===================================================
}
