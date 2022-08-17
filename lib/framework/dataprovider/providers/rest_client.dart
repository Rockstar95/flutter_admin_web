import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:uuid/uuid.dart';

const apiCallPageSize = 20;

class RestClient {
  //post method for authorization
  static Future<Response?> postData(String endpoint, String data) async {
    Response? response;
    try {
      print("$endpoint");

      Map<String, String> headers = {
        "content-type": "application/json",
        "ClientURL": ApiEndpoints.strSiteUrl,
        ApiEndpoints.allowfromExternalHostKey: 'allow'
      };

      print("Base Url:${ApiEndpoints.strBaseUrl}");

      /*Dio dioauth = Dio(BaseOptions(
        headers: {
          "content-type": "application/json",
          "ClientURL": ApiEndpoints.strSiteUrl,
          ApiEndpoints.allowfromExternalHostKey: 'allow'
        },
        baseUrl: ApiEndpoints.strBaseUrl,
        connectTimeout: 20 * 1000,
        receiveTimeout: 20 * 1000,
        receiveDataWhenStatusError: true,
      ));
      dioauth.interceptors.add(CacheInterceptor());*/

      print("Headers:$headers");
      print("Url:$endpoint");
      print("Data:$data");

      Response response1 =
          await post(Uri.parse(endpoint), headers: headers, body: data);
      print(
          'Response , status code:${response1.statusCode}, Data:${response1.body}');
      response = response1;
      //response = await dioauth.post(endpoint, data: data);
    } catch (e, s) {
      print("Error in RestClient.postData():$e");
      print(s);
    }

    print(
        'Response , status code:${response?.statusCode}, Data:${response?.body}');

    return response;
  }

//post method for authorization
  static Future<Response?> postDataWithHeader(
      String endpoint, String data, Map<String, dynamic> header) async {
    Response? response;

    print("Headers:$header");
    print("Url:$endpoint");
    print("Data:$data");

    try {
      response = await post(Uri.parse(endpoint), body: data);
    } catch (e, s) {
      print("Error in RestClient.postDataWithHeader():$e");
      print(s);
    }
    return response;
  }

//get method for forgotpwd
  static Future<Response?> getForgotPasswordData(
    String endpoint,
  ) async {
    //var basicAuth = await sharePrefGetString(sharedPref_basicAuth);
    var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

    Map<String, String> headers = {
      //"Authorization": basicAuth,
      ApiEndpoints.allowfromExternalHostKey: 'allow',
      "ClientURL": ApiEndpoints.strSiteUrl,
      "UserID": '-1',
      "Locale": '$strLanguage',
    };

    Response? response;

    print("Headers:$headers");
    print("Url:$endpoint");

    try {
      response = await get(Uri.parse(endpoint), headers: headers);
    } catch (e, s) {
      print("Error in RestClient.getForgotPasswordData():$e");
      print(s);
    }

    return response;
  }

  static Future<Response?> getDataToken(String endpoint, String basicAuth, {String userId = ''}) async {
    var token = await sharePrefGetString(sharedPref_bearer);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
    print('tokenval $token');

    Map<String, String> headers = {
      "content-type": "application/json",
      "ClientURL": ApiEndpoints.strSiteUrl,
      "Authorization": 'Bearer $token',
      ApiEndpoints.allowfromExternalHostKey: 'allow',
      "UserID": userId.isEmpty ? '-1' : userId,
      "SiteID": '$strSiteID',
      "Locale": '$strLanguage',
    };
    // var dioauth = Dio(BaseOptions(headers: {
    //   "content-type": "application/json",
    //   ApiEndpoints.allowfromExternalHostKey: 'allow'
    // }));

    try {
      print("Headers:$headers");
      print("Url:$endpoint");

      Response response = await get(Uri.parse(endpoint), headers: headers);
      return response;
    }
    catch (e, s) {
      print("Error in Getting Response in getDataToken():$e");
      print(s);
      return null;
    }
  }

//get signup fields
  static Future<Response?> getSignupData(
    String endpoint,
  ) async {
    Map<String, String> headers = {
      'ComponentID': "47",
      'ComponentInstanceID': "3104",
      'Locale': 'en-us',
      'SiteID': "374",
      'SiteURL': ApiEndpoints.strSiteUrl,
      ApiEndpoints.allowfromExternalHostKey: 'allow'
    };

    try {
      Response response = await get(Uri.parse(endpoint), headers: headers);
      return response;
    } catch (e, s) {
      print("Error in RestClient.getSignupData():$e");
      print(s);
      return null;
    }
  }

  static Future<Response?> getData(String endpoint, bool clientUrl) async {
    Map<String, String> headers = {
      "content-type": "application/json",
      "ClientURL": clientUrl ? endpoint : ApiEndpoints.strSiteUrl,
      ApiEndpoints.allowfromExternalHostKey: 'allow'
    };

    Response? response;

    print("Headers:$headers");
    print("Url:$endpoint");

    try {
      response = await get(Uri.parse(endpoint), headers: headers);
    } catch (e, s) {
      print("Error in RestClient.getData():$e");
      print(s);
    }

    return response;
  }

//register user
  static Future<Response?> signUpUser(String endpoint, String data) async {
    Response? response;

    Map<String, String> headers = {
      "content-type": "application/json",
      'clienturl': ApiEndpoints.strSiteUrl,
      ApiEndpoints.allowfromExternalHostKey: 'allow'
    };

    print("Headers:$headers");
    print("Url:$endpoint");
    print("Data:$data");

    try {
      response = await post(Uri.parse(endpoint), body: data, headers: headers);
    } catch (e, s) {
      print("Error in RestClient.signUpUser():$e");
      print(s);
    }

    return response;
  }

//after login - get method
  static Future<Response?> getPostData(String endpoint, {bool isFetchDataFromSharedPreference = true, String authtoken = "", String userid = "",
    String siteId = "", String siteUrl = "", String language = ""}) async {
    Response? response;

    String token = "", strUserID = "", strSiteID = "", strSiteUrl = "", strLanguage = "";

    if(isFetchDataFromSharedPreference) {
      token = await sharePrefGetString(sharedPref_bearer);
      strUserID = await sharePrefGetString(sharedPref_userid);
      strSiteID = await sharePrefGetString(sharedPref_siteid);
      strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      strSiteUrl = ApiEndpoints.strSiteUrl;
    }
    else {
      token = authtoken;
      strUserID = userid;
      strSiteID = siteId;
      strLanguage = language;
      strSiteUrl = siteUrl;
    }

    Map<String, String> headers = {
      "content-type": "application/json",
      "ClientURL": strSiteUrl,
      "Authorization": 'Bearer $token',
      ApiEndpoints.allowfromExternalHostKey: 'allow',
      "UserID": '$strUserID',
      "SiteID": '$strSiteID',
      "Locale": '$strLanguage',
    };

    String newId = Uuid().v1().replaceAll("-", "");

    print("$newId:Url:$endpoint");
    print("$newId:Headers:$headers");

    try {
      response = await get(Uri.parse(endpoint), headers: headers);
      print("$newId:Response Status:${response.statusCode}, Data:${response.body}");
    } catch (e, s) {
      print("Error in RestClient.getPostData():$e}");
      print(s);
    }

    return response;
  }

  static Future<Response?> postApiData(String endpoint, dynamic data, {bool isFetchDataFromSharedPreference = true, String authtoken = "", String userid = "",
    String siteId = "", String siteUrl = "", String language = ""}) async {
    Response? response;

    String token = "", strUserID = "", strSiteID = "", strSiteUrl = "", strLanguage = "";

    if(isFetchDataFromSharedPreference) {
      token = await sharePrefGetString(sharedPref_bearer);
      strUserID = await sharePrefGetString(sharedPref_userid);
      strSiteID = await sharePrefGetString(sharedPref_siteid);
      strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      strSiteUrl = ApiEndpoints.strSiteUrl;
    }
    else {
      token = authtoken;
      strUserID = userid;
      strSiteID = siteId;
      strLanguage = language;
      strSiteUrl = siteUrl;
    }

    Map<String, String> headers = {
      "content-type": "application/json",
      "ClientURL": strSiteUrl,
      "Authorization": 'Bearer $token',
      ApiEndpoints.allowfromExternalHostKey: 'allow',
      "UserID": '$strUserID',
      "SiteID": '$strSiteID',
      "Locale": '$strLanguage',
    };

    String newId = Uuid().v1().replaceAll("-", "");
    print("$newId Url:$endpoint");
    print("$newId Header:$headers");
    print("$newId Data:${jsonEncode(data)}");

    try {
      response = await post(Uri.parse(endpoint), body: jsonEncode(data), headers: headers);
      MyPrint.printOnConsole("$newId Response Status:${response.statusCode}");
      MyPrint.logOnConsole("$newId Response Data:${response.body}");
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in RestClient.postApiData():$e");
      print(s);
    }

    return response;
  }

  static Future<Response?> postApiDataForm(String endpoint, dynamic data, {bool isFetchDataFromSharedPreference = true, String authtoken = "", String userid = "",
  String siteId = "", String language = ""}) async {
    Response? response;

    String token = "", strUserID = "", strSiteID = "", strLanguage = "";

    if(isFetchDataFromSharedPreference) {
      token = await sharePrefGetString(sharedPref_bearer);
      strUserID = await sharePrefGetString(sharedPref_userid);
      strSiteID = await sharePrefGetString(sharedPref_siteid);
      strLanguage = await sharePrefGetString(sharedPref_AppLocale);
    }
    else {
      token = authtoken;
      strUserID = userid;
      strSiteID = siteId;
      strLanguage = language;
    }

    Map<String, String> headers = {
      "content-type": "application/x-www-form-urlencoded",
      "ClientURL": ApiEndpoints.strSiteUrl,
      "Authorization": 'Bearer $token',
      ApiEndpoints.allowfromExternalHostKey: 'allow',
      "UserID": '$strUserID',
      "SiteID": '$strSiteID',
      "Locale": '$strLanguage',
    };

    print("Url:$endpoint");
    print("Header:$headers");
    log("Data:$data");

    try {
      response = await post(Uri.parse(endpoint), body: data, headers: headers);
    } catch (e, s) {
      print("Error in RestClient.postApiDataForm():$e");
      print(s);
    }
    return response;
  }

  //after login - POST method
  static Future<Response?> postMethodData(String endpoint, String data, {bool isFetchDataFromSharedPreference = true, String authtoken = "", String userid = "",
  String siteId = "", String siteUrl = "", String language = ""}) async {
    Response? response;

    String token = "", strUserID = "", strSiteID = "", strSiteUrl = "", strLanguage = "";

    if(isFetchDataFromSharedPreference) {
      token = await sharePrefGetString(sharedPref_bearer);
      strUserID = await sharePrefGetString(sharedPref_userid);
      strSiteID = await sharePrefGetString(sharedPref_siteid);
      strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      strSiteUrl = ApiEndpoints.strSiteUrl;
    }
    else {
      token = authtoken;
      strUserID = userid;
      strSiteID = siteId;
      strLanguage = language;
      strSiteUrl = siteUrl;
    }

    String newId = Uuid().v1().replaceAll("-", "");

    Map<String, String> headers = {
      "content-type": "application/json",
      "ClientURL": strSiteUrl,
      "Authorization": 'Bearer $token',
      ApiEndpoints.allowfromExternalHostKey: 'allow',
      "UserID": '$strUserID',
      "SiteID": '$strSiteID',
      "Locale": '$strLanguage',
    };

    print("$newId Url:$endpoint");
    print("$newId Header:$headers");
    log("$newId Data:$data");

    try {
      response = await post(Uri.parse(endpoint), body: data, headers: headers);

      print("$newId Response Status:${response.statusCode}");
      log("$newId Response Body:${response.body}");
    } catch (e, s) {
      print("Error in RestClient.postMethodData():$e");
      print(s);
    }

    return response;
  }

  static Future<Response?> postMethodWithQueryParamData(
      String endpoint, Map<String, dynamic> queryParameters) async {
    Response? response;
    var token = await sharePrefGetString(sharedPref_bearer);
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
    print('tokenval $token');
    print('query parameters $queryParameters');
    print('endpoint $endpoint');

    Map<String, String> headers = {
      "content-type": "application/json",
      "ClientURL": ApiEndpoints.strSiteUrl,
      "Authorization": 'Bearer $token',
      ApiEndpoints.allowfromExternalHostKey: 'allow',
      "UserID": '$strUserID',
      "SiteID": '$strSiteID',
      "Locale": '$strLanguage',
    };

    try {
      endpoint += "?";
      queryParameters.forEach((key, value) {
        endpoint += "$key=$value&";
      });
      endpoint = endpoint.substring(0, endpoint.length - 1);

      String newId = Uuid().v1().replaceAll("-", "");

      print("$newId:Final Endpoint:$endpoint");
      print("$newId:Headers:$headers");

      response = await get(Uri.parse(endpoint), headers: headers);

      print("$newId:Response Status:${response.statusCode}");
      log("$newId:Response Body:${response.body}");
    } catch (e, s) {
      print("Error in RestClient.postMethodWithQueryParamData():$e}");
      print(s);
    }
    return response;
  }

  static Future<Response?> postMethodWithoutToken(String endpoint, Map<String, dynamic> data,)async{
    Response? response;
    Map<String, String> headers = {
      //"content-type": "multipart/form-data",
      'Content-Type': 'application/json',
      // "ClientURL": ApiEndpoints.mainSiteURL,
      ApiEndpoints.allowfromExternalHostKey: 'allow',
    };
    print('Url:$endpoint');
    print('Header:$headers');
    print('data:$data');
    try {
      // endpoint += "?";
      // queryParameters.forEach((key, value) {
      //   endpoint += "$key=$value&";
      // });
      // endpoint = endpoint.substring(0, endpoint.length - 1);
      print("Final Endpoint:$endpoint");

      response = await  post(Uri.parse(endpoint), body: jsonEncode(data), headers: headers);

      print("Response Status:${response.statusCode}, Body:${response.body}");
    } catch (e, s) {
      print("Error in RestClient.postMethodWithoutToken():$e}");
      print(s);
    }
    return response;
  }

  static Future<Response?> uploadFilesData(String endpoint, Map<String, String> data, {List<MultipartFile> files = const [], Map<String, String> fileNamesPaths = const {}}) async {
    Response? response;
    var token = await sharePrefGetString(sharedPref_bearer);
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

    Map<String, String> headers = {
      //"content-type": "multipart/form-data",
      "ClientURL": ApiEndpoints.strSiteUrl,
      "Authorization": 'Bearer $token',
      ApiEndpoints.allowfromExternalHostKey: 'allow',
      "UserID": '$strUserID',
      "SiteID": '$strSiteID',
      "Locale": '$strLanguage',
    };

    print('Url:$endpoint');
    print('Header:$headers');
    print('Data:$data');
    print("Files:${files.isNotEmpty ? files.first.field : ""}");

    try {
      MultipartRequest request = MultipartRequest("POST", Uri.parse(endpoint));
      request.fields.addAll(data);
      request.files.addAll(files);
      for(String key in fileNamesPaths.keys.toList()) {
        request.files.add(await MultipartFile.fromPath(key, fileNamesPaths[key] ?? ""));
      }
      request.headers.addAll(headers);

      StreamedResponse streamedResponse = await request.send();
      response = Response(
        (await streamedResponse.stream.bytesToString()),
        streamedResponse.statusCode,
        headers: streamedResponse.headers,
        isRedirect: streamedResponse.isRedirect,
        persistentConnection: streamedResponse.persistentConnection,
        reasonPhrase: streamedResponse.reasonPhrase,
        request: streamedResponse.request,
      );
    }
    catch (e, s) {
      print("Error in RestClient.uploadFilesData():$e");
      print(s);
    }
    return response;
  }

  static Future<dio.Response?> uploadGenericFileData(String endpoint, String filePath, String fileName) async {
    dio.Response? response;
    var token = await sharePrefGetString(sharedPref_bearer);
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

    print('tokenval $token');
    //print('data $data');
    print('endpoint $endpoint');

    dio.FormData formData = dio.FormData.fromMap({
      'File': await dio.MultipartFile.fromFile(filePath),
      'FilePath': fileServerLocation
    });

    var dioAuth = dio.Dio(dio.BaseOptions(headers: {
      // "content-type": "multipart/form-data",
      "ClientURL": ApiEndpoints.strSiteUrl,
      "Authorization": 'Bearer $token',
      'AllowWindowsandMobileApps': 'allow',
      "UserID": '$strUserID',
      "SiteID": '$strSiteID',
      "Locale": '$strLanguage',
    }));
    try {
      response = await dioAuth.post(endpoint, data: formData);
      print(response);
    } catch (e, s) {
      if (e is dio.DioError) {
        //handle DioError here by error type or by error code
        print("Upload error :- ${e.response?.statusCode}");
        return e.response;
      }
      print(s);
    }
    return response;
  }
}
