import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';

import 'mydashboard_repositry_builder.dart';

class MyDashboardRepositoryPublic extends MyDashboardRepository {
  @override
  Future<Response?> getGameList(
      {bool fromAchievement = false,
      String userID = "",
      String siteID = "",
      String locale = "",
      String componentID = "",
      String componentInsID = "",
      String leaderByGroup = "",
      String gameID = ""}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      // var strComponentID = await sharePref_getString(sharedPref_ComponentID);
      // var strRepositoryId = await sharePref_getString(sharedPref_RepositoryId);

      Map<String, dynamic> gameslistRequest = {
        'UserID': strUserID,
        'SiteID': strSiteID,
        'Locale': strLanguage,
        'ComponentID': componentID,
        'ComponentInsID': componentInsID,
        'LeaderByGroup': leaderByGroup,
        'GameID': gameID,
        'fromAchievement': fromAchievement
      };

      String body = json.encode(gameslistRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.getGameList(), body);
      // String body = json.encode(formData);
      print(response?.body);
    } catch (e) {
      print("Error in MyDashboardRepositoryPublic.getGameList():$e");
    }
    return response;
  }

  @override
  Future<Response?> getLeaderboardData(
      {String userID = "",
      String siteID = "",
      String locale = "",
      String componentID = "",
      String componentInsID = "",
      String gameID = ""}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      var strComponentID = await sharePrefGetString(sharedPref_ComponentID);
      var strRepositoryId = await sharePrefGetString(sharedPref_RepositoryId);

      Map<String, dynamic> leaderboardRequest = {
        'UserID': strUserID,
        'SiteID': strSiteID,
        'Locale': strLanguage,
        'ComponentID': componentID,
        'ComponentInsID': componentInsID,
        'GameID': gameID,
      };

      String body = json.encode(leaderboardRequest);

      response = await RestClient.postMethodData(
          ApiEndpoints.getLeaderboardData(), body);
      // String body = json.encode(formData);
      print(" response ${response?.body}");
    } catch (e) {
      print("Error in MyDashboardRepositoryPublic.getLeaderboardData():$e");
    }
    return response;
  }

  @override
  Future<Response?> getUserAchievementData(
      {String userID = "",
      String siteID = "",
      String locale = "",
      String gameID = "",
      String componentID = "",
      String componentInsID = ""}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      var strComponentID = await sharePrefGetString(sharedPref_ComponentID);
      var strRepositoryId = await sharePrefGetString(sharedPref_RepositoryId);

      Map<String, dynamic> userachivmentRequest = {
        'UserID': strUserID,
        'SiteID': strSiteID,
        'Locale': strLanguage,
        'ComponentID': componentID,
        'ComponentInsID': componentInsID,
        'GameID': gameID,
      };
      String body = json.encode(userachivmentRequest);

      response = await RestClient.postMethodData(
          ApiEndpoints.getUserAchievementData(), body);
      // String body = json.encode(formData);
    } catch (e) {
      print("Error in MyDashboardRepositoryPublic.getUserAchievementData():$e");
    }
    return response;
  }

  @override
  Future<Response?> getMyCreditCertificate(
      {String userID = "", String siteID = "", String localeID = ""}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      response =
          await RestClient.getPostData(ApiEndpoints.getMyCreditCertificate(
        strUserID,
        strSiteID,
        language,
      ));
    } catch (e) {
      print("Error in MyDashboardRepositoryPublic.getMyCreditCertificate():$e");
    }
    return response;
  }
}
