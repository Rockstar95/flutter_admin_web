import 'dart:developer';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/contract/splash_repository.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/model/basicAuthResponse.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

class SplashRepositoryPublic extends SplashRepository {
  @override
  Future<BasicAuthResponce?> getBasicAuth() async {
    /// fpr auth details
    /// for all app auth details
    // TODO: implement getBasicAuth
    BasicAuthResponce? loginResponce;
    try {
      print("......getBasicAuth....${ApiEndpoints.apiSplash()}");
      Response? response =
          await RestClient.getData(ApiEndpoints.apiSplash(), false);
      print("getBasicAuth Response :- ${response?.body}");
      print("getBasicAuth statusCode :- ${response?.statusCode.toString()}");
      if (response?.statusCode == 200) {
        loginResponce = basicAuthResponceFromJson(response?.body ?? "{}");
      }
    }
    catch (e, s) {
      print("Error in SplashRepositoryPublic.getBasicAuth():$e");
      MyPrint.printOnConsole(s);
    }

    return loginResponce;
  }

  @override
  Future<Response?> getMobileGetLearningPortalInfo() async {
    /// for all app configurations and ui colours
    // TODO: implement getMobileGetLearningPortalInfo
    Response? response;

    try {
      print(
          "......mobileGetLearningPortalInfo......${ApiEndpoints.apiMobileGetLearningPortalInfo()}");
      String basicAuth = await sharePrefGetString(sharedPref_basicAuth);
      print("basic auth $basicAuth");
      response = await RestClient.getDataToken(
          ApiEndpoints.apiMobileGetLearningPortalInfo(), basicAuth);
      print(
          "mobileGetLearningPortalInfo Response :- ${response?.body.toString()}");
      print(
          "mobileGetLearningPortalInfo statusCode :- ${response?.statusCode.toString()}");
    } catch (e) {
      print(
          "Error in SplashRepositoryPublic.getMobileGetLearningPortalInfo():$e");
    }

    return response;
  }

  @override
  Future<Response?> getMobileGetNativeMenus() async {
    Response? response;

    /// api call for native menus
    try {
      String basicAuth = await sharePrefGetString(sharedPref_basicAuth);
      String language = await sharePrefGetString(sharedPref_AppLocale);
      print(
          "......MobileGetNativeMenus......${ApiEndpoints.apiMobileGetNativeMenus(language)}");
      response = await RestClient.getDataToken(
          ApiEndpoints.apiMobileGetNativeMenus(
              language.isNotEmpty ? language : "en-us"),
          basicAuth);
      print("MobileGetNativeMenus Response :- ${response?.body}");
      print(
          "MobileGetNativeMenus statusCode :- ${response?.statusCode.toString()}");
    } catch (e) {
      print("Error in SplashRepositoryPublic.getMobileGetNativeMenus():$e");
    }

    return response;
  }

  @override
  Future<Response?> getMobileTinCanConfigurations() async {
    Response? response;

    try {
      var basicAuth = await sharePrefGetString(sharedPref_basicAuth);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      print(
          "......MobileTinCanConfigurations....${ApiEndpoints.apiMobileTinCanConfigurations(language)}");
      response = await RestClient.getDataToken(
          ApiEndpoints.apiMobileTinCanConfigurations(language), basicAuth);
      print("MobileTinCanConfigurations Response :- ${response?.body}");
      print(
          "MobileTinCanConfigurations statusCode :- ${response?.statusCode.toString()}");
    } catch (e) {
      print(
          "Error in SplashRepositoryPublic.getMobileTinCanConfigurations():$e");
    }

    return response;
  }

  @override
  Future<Response?> getLanguageJsonFile(String langCode) async {
    Response? response;

    try {
      print(
          "......getLanguageJsonFile.....${ApiEndpoints.apiGetJsonFile(langCode, "${ApiEndpoints.siteID}")}");
      var basicAuth = await sharePrefGetString(sharedPref_basicAuth);
      response = await RestClient.getDataToken(
          ApiEndpoints.apiGetJsonFile(langCode, "${ApiEndpoints.siteID}"),
          basicAuth);
    } catch (e) {
      print("Error in SplashRepositoryPublic.getLanguageJsonFile():$e");
    }

    return response;
  }

  @override
  Future<Response?> notificationCount() async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> notificationRequest = {
        'UserID': strUserID,
      };

      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.viewNotificationCount(), notificationRequest);

      print("Aman: ${response?.body}");
    } catch (e) {
      print("Error in SplashRepositoryPublic.notificationCount():$e");
    }
    return response;
  }

  @override
  Future<Response?> wishlistcount() async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map<String, dynamic> wishlistRequest = {
        'UserID': strUserID,
        'SiteID': strSiteID,
        'Locale': "en-us",
      };

      response = await RestClient.postApiDataForm(
          ApiEndpoints.GetWishListComponentDetails(), wishlistRequest);

      log("Wishlist Response: ${response?.body}");
    } catch (e) {
      print("Error in SplashRepositoryPublic.wishlistcount():$e");
    }
    return response;
  }
}
