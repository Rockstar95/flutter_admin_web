import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter_admin_web/configs/app_strings.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/people_listing_tab.dart';
import 'package:flutter_admin_web/generated/json/dummy_my_catelog_response_entity_helper.dart';
import 'package:flutter_admin_web/main.dart';
import 'package:flutter_admin_web/models/app_error_model.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

Future<dynamic> getPeopleTabListComputeMethod(List<dynamic> arguments) async {
  String url = arguments[0];
  String intUserID = arguments[1];
  String intSiteID = arguments[2];
  String siteUrl = arguments[3];
  String strLocale = arguments[4];
  String token = arguments[5];

  Response? response;

  try {
    HttpOverrides.global = MyHttpOverrides();

    response = await RestClient.getPostData(
      url,
      isFetchDataFromSharedPreference: false,
      userid: intUserID,
      language: strLocale,
      siteId: intSiteID,
      authtoken: token,
      siteUrl: siteUrl,
    );

    print('getcontenttabre ${response?.body}');

    if (response?.statusCode == 200) {
      String data = response?.body ?? "[]";
      List<GetPeopleTabListResponse> tabList = getPeopleTabListResponseFromJson(data);

      return tabList;
    }
    else if (response?.statusCode == 401) {
      return AppErrorModel(
        message: AppStrings.token_expired,
        code: 401,
      );
    }
    else {
      return AppErrorModel(
        message: AppStrings.error_in_api_call,
      );
    }
  }
  on Exception catch (e, s) {
    print("Error in ClassroomEventsRepository.getPeopleTabListComputeMethod():$e");
    MyPrint.printOnConsole(s);

    return AppErrorModel(
      message: AppStrings.error_in_api_call,
      exception: e,
      stackTrace: s,
    );
  }
  catch(e, s) {
    print("Error in ClassroomEventsRepository.getPeopleTabListComputeMethod():$e");
    MyPrint.printOnConsole(s);

    return AppErrorModel(
      message: AppStrings.error_in_api_call,
      stackTrace: s,
    );
  }
}

Future<dynamic> getTabContentComputeMethod(List<dynamic> arguments) async {
  String url = arguments[0];
  String intUserID = arguments[1];
  String intSiteID = arguments[2];
  String siteUrl = arguments[3];
  String strLocale = arguments[4];
  String token = arguments[5];
  String req = arguments[6];

  Response? response;

  try {
    HttpOverrides.global = MyHttpOverrides();

    response = await RestClient.postApiData(
      url,
      jsonDecode(req),
      isFetchDataFromSharedPreference: false,
      userid: intUserID,
      language: strLocale,
      siteId: intSiteID,
      authtoken: token,
      siteUrl: siteUrl,
    );

    print('getcontenttabre ${response?.body}');

    if (response?.statusCode == 200) {
      Map valueMap = json.decode(response?.body ?? "{}");
      DummyMyCatelogResponseEntity myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(DummyMyCatelogResponseEntity(), Map.castFrom(valueMap));

      return myCatelogResponseEntity;
    }
    else if (response?.statusCode == 401) {
      return AppErrorModel(
          message: AppStrings.token_expired,
          code: 401,
        );
    }
    else {
      return AppErrorModel(
        message: AppStrings.error_in_api_call,
      );
    }
  }
  on Exception catch (e, s) {
    print("Error in ClassroomEventsRepository.getTabContentComputeMethod():$e");
    MyPrint.printOnConsole(s);

    return AppErrorModel(
      message: AppStrings.error_in_api_call,
      exception: e,
      stackTrace: s,
    );
  }
  catch(e, s) {
    print("Error in ClassroomEventsRepository.getTabContentComputeMethod():$e");
    MyPrint.printOnConsole(s);

    return AppErrorModel(
      message: AppStrings.error_in_api_call,
      stackTrace: s,
    );
  }
}

