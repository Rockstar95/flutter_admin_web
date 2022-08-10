import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_admin_web/framework/dataprovider/helper/data_provider_base.dart';
import 'package:flutter_admin_web/framework/dataprovider/interfaces/local_provider_contract.dart';

/// Concrete implementation for local hive data provider
class HiveDataProvider extends DataProviderBase implements LocalDataProviderContract {
  bool _initialized = false;

  HiveDataProvider() {
    _databaseInit();
  }

  /// Open Hive connection
  Future<void> _databaseInit() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
  }

  /// Open and return hive box
  Future<Box> _getBox(String boxName) async {
    if (!_initialized) await _databaseInit();

    Box box;
    if (!Hive.isBoxOpen(boxName)) {
      //MyPrint.printOnConsole("Box '${boxName}' was Not Opened");
      box = await Hive.openBox(boxName);
    }
    else {
      //MyPrint.printOnConsole("Box '${boxName}' was Opened");
      box = Hive.box(boxName);
    }

    return box;
  }

  @override
  Future deleteData(
    String table, {
    String whereClauseValue = "",
    required List whereClauseArgs,
    required List<String> keys,
  }) async {
    Box box = await _getBox(table);

    // empty box
    if (keys == null || keys.length == 0) {
      await box.clear();
      return;
    }

    await Future.wait(keys.map((key) => box.delete(key)));

    keys.forEach((String key) {
      box.delete(key);
    });
  }

  @override
  Future<void> insertData(String table, Map<String, dynamic> values) async {
    Box box = await _getBox(table);
    if (values.isNotEmpty) {
      values.forEach((key, value) {
        //MyPrint.printOnConsole("Adding Value In Hive for '${table}' Table");
        box.put(key, value);
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readData(
    String table, {
    bool distinct = false,
    List<String> keys = const [],
    List<String> columns = const [],
    String whereClauseValue = "",
    List whereClauseArgs = const [],
    String groupBy = "",
    String having = "",
    String orderBy = "",
    int limit = 0,
  }) async {
    Box box = await _getBox(table);
    // return all data from box
    if (keys.length == 0) {
      return [Map<String, dynamic>.from(box.toMap())];
    }

    Map<String, dynamic> data = {};
    keys.forEach((key) {
      data[key] = box.get(key);
    });
    return [data];
  }

  @override
  Future updateData(
    String table,
    Map<String, dynamic> values, {
    String whereClauseValue = "",
    List whereClauseArgs = const [],
  }) async {
    Box box = await _getBox(table);
    if (values != null && values.length != 0) {
      values.forEach((key, value) {
        box.put(key, value);
      });
    }
    return null;
  }

  @override
  Future runRawQuery({String query = "", List arguments = const []}) async {
    return null;
  }

  @override
  Future<void> rawDeleteData(String table,
      {Map<String, dynamic> queries = const {}}) {
    // TODO: implement rawDeleteData
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> rawReadData(String table,
      {Map<String, dynamic> queries = const {}}) {
    // TODO: implement rawReadData
    throw UnimplementedError();
  }
}
