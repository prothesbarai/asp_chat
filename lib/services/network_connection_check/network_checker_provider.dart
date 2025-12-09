import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkCheckerProvider with ChangeNotifier{
  bool _isOnline = true;
  bool get isOnline => _isOnline;
  late StreamSubscription _connectivitySubscription;
  late StreamSubscription _internetStatusSubscription;

  NetworkCheckerProvider(){_initProvider();}

  void _initProvider(){
    // >>> First Time Check
    _checkConnection();
    // >>> For Wifi / Mobile connectivity
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((event){_checkConnection();});
    // >>> For real internet status
    _internetStatusSubscription = InternetConnectionChecker().onStatusChange.listen((status){
      bool connected = status == InternetConnectionStatus.connected;
      if(connected != _isOnline){
        _isOnline = connected;
        notifyListeners();
      }
    });
  }


  // >>> Check Internet Connection =============================================
  Future<void> _checkConnection() async{
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if(hasInternet != _isOnline){
      _isOnline = hasInternet;
      notifyListeners();
    }
  }
  // <<< Check Internet Connection =============================================


  // >>> Retry Method For Button ===============================================
  Future<void> retry() async{
    await _checkConnection();
  }
  // <<< Retry Method For Button ===============================================


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _internetStatusSubscription.cancel();
    super.dispose();
  }

}