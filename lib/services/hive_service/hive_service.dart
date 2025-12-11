import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../display_theme/theme_selected_model/theme_selected_model.dart';

class HiveService {
  static Future<void> initHive() async{
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(AppThemeEnumAdapter());

    await Future.wait([
      Hive.openBox("onBoardingPage"),
      Hive.openBox("storeUserId"),
      Hive.openBox('settings'),
      Hive.openBox('AppThemeEnumFlag'), // For Light & Dark mode
    ]);
  }
}