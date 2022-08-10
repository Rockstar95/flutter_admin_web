import 'dart:async';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  static HiveManager? _instance;

  // File path to a file in the current directory
  String dbName = 'mydatabase';
  String boxName = 'mybox';

  Box? hivebox;

  factory HiveManager() {
    if(_instance == null) {
      _instance = HiveManager._();
    }
    return _instance!;
  }

  HiveManager._();

  Future<Box> get box async {
    if(hivebox == null) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      final dbPath = "${appDocumentDir.path}/$dbName";
      Hive.init(dbPath);
      hivebox = await Hive.openBox(boxName);
    }
    return hivebox!;
  }

  Future<dynamic> get(String key, {dynamic defaultValue}) async {
    Box db = await box;

    return db.get(key, defaultValue: defaultValue);
  }

  Future<dynamic> set(String key, dynamic value) async {
    Box db = await box;
    await db.put(key, value);
  }
}