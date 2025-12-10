import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static Future<void> initHive() async{
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    await Future.wait([
      Hive.openBox("onBoardingPage"),
      Hive.openBox("storeUserId")
    ]);
  }
}