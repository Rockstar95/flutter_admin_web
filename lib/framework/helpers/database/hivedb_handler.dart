import 'package:hive_flutter/hive_flutter.dart';

class HiveDbHandler {
  static HiveDbHandler? _hiveDbHandler;
  bool _initialized = false;

  factory HiveDbHandler() {
    if (_hiveDbHandler == null) {
      _hiveDbHandler = HiveDbHandler._internal();
    }
    return _hiveDbHandler!;
  }

  HiveDbHandler._internal();

  Future<void> _databaseInit() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
  }

  Future<Box> _getBox(String boxName) async {
    if (!_initialized) await _databaseInit();

    Box box;
    if (!Hive.isBoxOpen(boxName))
      box = await Hive.openBox(boxName);
    else
      box = Hive.box(boxName);

    return box;
  }

  Future<void> deleteData(String table, {List<String> keys = const [],}) async {
    Box box = await _getBox(table);

    /// If keys are specified, execute delete for those keys
    if (keys.isNotEmpty) {
      await box.deleteAll(keys);
      return;
    }

    /// If keys are not specified, delete the box
    box.deleteFromDisk();
    return;
  }

  Future<void> createData(String table, String key, Map<String, dynamic> value) async {
    Box box = await _getBox(table);
    await box.put(key, value);
  }

  Future<List<Map<String, dynamic>>> readData(
    String table, {
    List<String> keys = const [],
  }) async {
    Box box = await _getBox(table);

    if (keys.length == 0) {
      var boxMap = box.toMap();
      Map<String, dynamic> map = Map<String, dynamic>.from(box.toMap());
      List<Map<String, dynamic>> map2 = map.values.map((val) => Map<String, dynamic>.from(val)).toList();
      return map2;
      // return map.values.toList();
      // return [Map<String, dynamic>.from(box.toMap())];
    }

    List<Map<String, dynamic>> data = [];
    keys.forEach((key) {
      Map<String, dynamic> map = Map<String, dynamic>.from(box.get(key) ?? {});
      data.add(map);
    });
    return data;
  }
}
