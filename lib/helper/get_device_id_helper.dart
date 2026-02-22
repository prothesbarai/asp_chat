import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    return "N/A"; // >>> Web does not have a device ID
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    case TargetPlatform.iOS:
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? "N/A";
    default:
      return "N/A"; // >>> Other platforms
  }
}

