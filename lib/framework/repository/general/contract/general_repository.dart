import 'package:flutter_admin_web/framework/common/api_response.dart';

abstract class GeneralRepository {
  Future<ApiResponse?> checkFileFoundOrNot(String url);

  Future<ApiResponse?> getContentTrackedData(String url);

  Future<ApiResponse?> getMobileContentMetaData(String url);

  Future<ApiResponse?> executeXAPICourse(String url);
}
//
