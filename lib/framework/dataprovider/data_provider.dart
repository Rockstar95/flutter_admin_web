import 'package:flutter_admin_web/framework/dataprovider/providers/hive_provider.dart';

import 'helper/local_database_helper.dart';
import 'interfaces/local_provider_contract.dart';
import 'providers/local_provider.dart';

class LocalDataProvider {
  LocalDataProviderContract _localDataProviderContract = SQLDataProvider();

  LocalDataProvider({
    LocalDataProviderType localDataProviderType = LocalDataProviderType.sqlite,
  }) {
    switch (localDataProviderType) {
      case LocalDataProviderType.sqlite:
        _localDataProviderContract = SQLDataProvider();
        break;
      case LocalDataProviderType.hive:
        _localDataProviderContract = HiveDataProvider();
        break;
    }
  }

  /// Method to handle local data
  Future localService({
    required LocalDatabaseOperation enumLocalDatabaseOperation,
    String table = "",
    String rawQuery = "",
    List<dynamic> rawQueryArguments = const [],
    Map<String, dynamic> values = const {},
    List<String> keys = const [],
    String whereClauseValue = "",
    List<dynamic> whereClauseArgs = const [],
    String orderBy = "",
    int limit = 0,
  }) async {
    assert(enumLocalDatabaseOperation != null);

    switch (enumLocalDatabaseOperation) {
      case LocalDatabaseOperation.create:
        return await _localDataProviderContract.insertData(table, values);
      case LocalDatabaseOperation.read:
        return await _localDataProviderContract.readData(table,
            keys: keys,
            whereClauseArgs: whereClauseArgs,
            whereClauseValue: whereClauseValue,
            orderBy: orderBy,
            limit: limit,
            columns: []);
      case LocalDatabaseOperation.update:
        return await _localDataProviderContract.updateData(
          table,
          values,
          whereClauseArgs: whereClauseArgs,
          whereClauseValue: whereClauseValue,
        );
      case LocalDatabaseOperation.delete:
        return await _localDataProviderContract.deleteData(
          table,
          whereClauseArgs: whereClauseArgs,
          whereClauseValue: whereClauseValue,
          keys: keys,
        );
      case LocalDatabaseOperation.rawQuery:
        return await _localDataProviderContract.runRawQuery(
          query: rawQuery,
          arguments: rawQueryArguments,
        );
      default:
        return null;
    }
  }
}

//class WebDataProvider {
//  ApiDataProviderContract _apiDataProviderContract;
//
//  WebDataProvider() {
//    _apiDataProviderContract =
//        ApiDataProvider(); // Provide the concrete implementation
//  }
//
//  /// Method to handle web API calls
//  Future<R> webService<R>(String url,
//      {dynamic body,
//      R Function(dynamic) parser,
//      Map<String, String> headers,
//      HttpMethod enumHttpMethod,
//      bool retry = true,
//      bool isDefaultAuth = true}) async {
//    if (enumHttpMethod == HttpMethod.get) {
//      return await _apiDataProviderContract.get(
//          url, parser, await TokenHandler().handleToken(headers, isDefaultAuth: isDefaultAuth));
//    } else if (enumHttpMethod == HttpMethod.post) {
//      return await _apiDataProviderContract.post(
//          url, body, parser, await TokenHandler().handleToken(headers, isDefaultAuth: isDefaultAuth)) as R;
//    } else if (enumHttpMethod == HttpMethod.delete) {
//      return await _apiDataProviderContract.delete(
//          url, await TokenHandler().handleToken(headers, isDefaultAuth: isDefaultAuth), parser);
//    } else if (enumHttpMethod == HttpMethod.patch) {
//      return await _apiDataProviderContract.patch(
//          url, body, await TokenHandler().handleToken(headers, isDefaultAuth: isDefaultAuth), parser);
//    } else if (enumHttpMethod == HttpMethod.put) {
//      return await _apiDataProviderContract.put(
//          url, body, await TokenHandler().handleToken(headers, isDefaultAuth: isDefaultAuth), parser);
//    }
//    throw UnimplementedError('Invalid enum method');
//  }
//}
