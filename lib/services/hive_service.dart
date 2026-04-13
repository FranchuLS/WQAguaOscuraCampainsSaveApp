import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String campaignBoxName = 'campaigns';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(campaignBoxName);
  }

  static Box getBox(String name) {
    return Hive.box(name);
  }
}