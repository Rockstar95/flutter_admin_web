/// Local Data Provider Interface class
abstract class LocalDataProviderContract {
  Future<void> insertData(String table, Map<String, dynamic> values) async {}

  Future<List<Map<String, dynamic>>> readData(
    String table, {
    bool distinct,
    required List<String> keys,
    required List<String> columns,
    String whereClauseValue,
    required List<dynamic> whereClauseArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
  });

  Future updateData(
    String table,
    Map<String, dynamic> values, {
    String whereClauseValue = "",
    required List<dynamic> whereClauseArgs,
  }) async {}

  Future deleteData(
    String table, {
    String whereClauseValue = "",
    required List<dynamic> whereClauseArgs,
    required List<String> keys,
  }) async {}

  Future<dynamic> runRawQuery(
      {String query = "", required List<dynamic> arguments}) async {}

  Future<void> rawDeleteData(
    String table, {
    required Map<String, dynamic> queries,
  }) async {}

  Future<List<Map<String, dynamic>>> rawReadData(
    String table, {
    Map<String, dynamic> queries,
  });
}
