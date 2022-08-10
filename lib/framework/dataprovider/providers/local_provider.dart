import 'dart:async';

import 'package:flutter_admin_web/framework/dataprovider/interfaces/local_provider_contract.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLDataProvider implements LocalDataProviderContract {
  static const String kOmegaDatabase = 'omega.db';

  late Database database;

  SQLDataProvider() {
    _databaseInit();
  }

  void _databaseInit() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'instancy.db'),
      onOpen: (database) async =>
          await database.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
//        await db.execute("CREATE TABLE $tableWeather("
//            "$columnWeatherId INTEGER PRIMARY KEY AUTOINCREMENT, "
//            "$columnName TEXT, "
//            "$columnLat REAL, "
//            "$columnLng REAL, "
//            "$columnHome INT, "
//            "$columnTimestamp INT) ");
      },
      version: 1,
    );
  }

  @override
  Future<void> deleteData(
    String table, {
    String whereClauseValue = "",
    List whereClauseArgs = const [],
    List<String> keys = const [],
  }) async {
    if (database == null)
      database = await _openDatabase(databaseName: kOmegaDatabase);
    await database.delete(
      table,
      where: whereClauseValue,
      whereArgs: whereClauseArgs,
    );
  }

  @override
  Future<void> rawDeleteData(
    String table, {
    Map<String, dynamic> queries = const {},
  }) async {
    if (database == null)
      database = await _openDatabase(databaseName: kOmegaDatabase);
    String query = "DELETE FROM [$table] WHERE ";
    for (int i = 0; i < queries.keys.length; i++) {
      if (i == queries.keys.length - 1) {
        query = query +
            "${queries.keys.toList()[i]} == ${queries[queries.keys.toList()[i]]}";
      } else {
        query = query +
            "${queries.keys.toList()[i]} == ${queries[queries.keys.toList()[i]]} AND ";
      }
    }
    await database.rawDelete(query);
  }

  @override
  Future<List<Map<String, dynamic>>> rawReadData(
    String table, {
    Map<String, dynamic> queries = const {},
  }) async {
    if (database == null)
      database = await _openDatabase(databaseName: kOmegaDatabase);
    String query = "SELECT * FROM [$table] WHERE ";
    for (int i = 0; i < queries.keys.length; i++) {
      if (i == queries.keys.length - 1) {
        query = query +
            "${queries.keys.toList()[i]} == ${queries[queries.keys.toList()[i]]}";
      } else {
        query = query +
            "${queries.keys.toList()[i]} == ${queries[queries.keys.toList()[i]]} AND ";
      }
    }
    return await database.rawQuery(query);
  }

  @override
  Future insertData(String table, Map<String, dynamic> values) async {
    if (database == null)
      database = await _openDatabase(databaseName: kOmegaDatabase);

    return await database.insert(table, values);
  }

  @override
  Future<List<Map<String, dynamic>>> readData(String table,
      {bool distinct = false,
      List<String> columns = const [],
      List<String> keys = const [],
      String whereClauseValue = "",
      List whereClauseArgs = const [],
      String groupBy = "",
      String having = "",
      String orderBy = "",
      int limit = 0}) async {
    if (database == null)
      database = await _openDatabase(databaseName: kOmegaDatabase);
    return await database.query(table,
        where: whereClauseValue,
        whereArgs: whereClauseArgs,
        orderBy: orderBy,
        limit: limit);
  }

  @override
  Future updateData(String table, Map<String, dynamic> values,
      {String whereClauseValue = "", List whereClauseArgs = const []}) async {
    if (database == null)
      database = await _openDatabase(databaseName: kOmegaDatabase);
    return await database.update(table, values,
        where: whereClauseValue, whereArgs: whereClauseArgs);
  }

  @override
  Future<dynamic> runRawQuery(
      {String query = "", List<dynamic> arguments = const []}) async {
    if (database == null)
      database = await _openDatabase(databaseName: kOmegaDatabase);
    return await database.rawQuery(query, arguments);
  }

  Future _openDatabase({String databaseName = ""}) async {
    return await openDatabase(
      databaseName,
      onOpen: (database) async =>
          await database.execute('PRAGMA foreign_keys = ON'),
    );
  }
}
