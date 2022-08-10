import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/model/ResCmiData.dart';
import 'package:flutter_admin_web/framework/repository/general/model/TrackData.dart';
import 'package:logger/logger.dart';

class GeneralApiRepository implements GeneralRepository {
  Logger logger = Logger();

  @override
  Future<ApiResponse?> checkFileFoundOrNot(String url) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;
    Response? response = await RestClient.getData(url, false);
    if (response?.statusCode == 200) {
      isSuccess = true;
    } else {
      isSuccess = false;
    }

    apiResponse =
        ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);

    return apiResponse;
  }

  @override
  Future<ApiResponse?> getContentTrackedData(String url) async {
    ApiResponse? apiResponse;
    ResCmiData resCmiData = ResCmiData.fromJson({});
    Response? response = await RestClient.getPostData(url);
    if (response?.statusCode == 200) {
      resCmiData = resCmiDataFromJson(response?.body ?? "{}");

      apiResponse =
          ApiResponse(data: resCmiData, status: response?.statusCode ?? 0);
    } else {
      //isSuccess=false;
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> getMobileContentMetaData(String url) async {
    ApiResponse? apiResponse;
    Response? response = await RestClient.getPostData(url);
    if (response?.statusCode == 200) {
      TrackData trackData = trackDataFromJson(response?.body ?? "{}");

      /// insert data in to  db in method insertTrackObjects

    } else {
      //isSuccess=false;
    }

    apiResponse =
        ApiResponse(data: response, status: response?.statusCode ?? 0);

    return apiResponse;
  }

  @override
  Future<ApiResponse?> executeXAPICourse(String url) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;
    Response? response = await RestClient.getPostData(url);
    if (response?.statusCode == 200) {
      isSuccess = true;
    } else {
      isSuccess = false;
    }

    apiResponse =
        ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);

    return apiResponse;
  }
}
