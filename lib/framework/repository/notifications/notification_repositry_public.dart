import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/notifications/notification_repository_builder.dart';

class NotificationRepositoryPublic extends NotificationRepository {
  @override
  Future<Response?> getNotificationDat({int recordCount = 0}) async {
    // TODO: implement getNotificationDat
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map<String, dynamic> progressReportRequest = {
        'SiteID': int.parse(strSiteID),
        'UserID': int.parse(strUserID),
        // 'RecordCount': recordCount,
        'PageIndex': 1,
        'PageSize': 10
      };

      response = await RestClient.postMethodWithQueryParamData(ApiEndpoints.getNotificationData(), progressReportRequest);
    } catch (e) {
      print('Error in NotificationRepositoryPublic.getNotificationDat():$e');
    }
    return response;
  }

  @override
  Future<Response?> clearNotifiaction({String userNotificationID = ""}) async {
    // TODO: implement clearNotifiaction
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> mapData = {
        'UserID': int.parse(strUserID),
        'UserNotificationID': userNotificationID,
      };
      String body = json.encode(mapData);
      print('userNotificationID  $body');
      response = await RestClient.postMethodData(
          ApiEndpoints.clearAllNotification(), body);

      print(" response ${response?.body.toString()}");
    } catch (e) {
      print('Error in NotificationRepositoryPublic.clearNotifiaction():$e');
    }

    return response;
  }

  @override
  Future<Response?> markRead() async {
    // TODO: implement getNotificationDat
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> progressReportRequest = {
        'UserID': int.parse(strUserID),
      };

      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.removeNotification(), progressReportRequest);
    } catch (e) {
      print('Error in NotificationRepositoryPublic.markRead():$e');
    }
    return response;
  }

  @override
  Future<Response?> deleteNotifiaction({String userNotificationID = ""}) async {
    // TODO: implement clearNotifiaction
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> mapData = {
        'UserID': int.parse(strUserID),
        'UserNotificationID': userNotificationID,
      };
      String body = json.encode(mapData);
      print('userNotificationID  $body');
      response = await RestClient.postMethodData(
          ApiEndpoints.deleteNotification(), body);

      print(" response ${response?.body.toString()}");
    } catch (e) {
      print('Error in NotificationRepositoryPublic.deleteNotifiaction():$e');
    }

    return response;
  }

  @override
  Future<Response?> markNotification({String userNotificationID = ""}) async {
    // TODO: implement clearNotifiaction
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      print("removeIndividualNotification  " +
          ApiEndpoints.removeIndividualNotification(
              strUserID, userNotificationID));
      response = await RestClient.getPostData(
          ApiEndpoints.removeIndividualNotification(
              strUserID, userNotificationID));

      print(" response ${response?.body.toString()}");
    } catch (e) {
      print('Error in NotificationRepositoryPublic.markNotification():$e');
    }

    return response;
  }

  @override
  Future<Response?> doPeopleListingAction({
    int selectedObjectID = 0,
    String selectAction = "",
    String userName = "",
    String currentMenu = "",
    String consolidationType = "",
  }) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> doPeopleListingAction = {
        'SelectedObjectID': selectedObjectID,
        'SelectAction': selectAction,
        'userName': userName,
        'UserID': int.parse(strUserID),
        'mainSiteUserID': int.parse(strUserID),
        'siteID': int.parse(strSiteID),
        'currentMenu': currentMenu,
        'consolidationType': consolidationType,
        'Locale': strLanguage
      };

      String body = json.encode(doPeopleListingAction);

      response = await RestClient.postMethodData(
          ApiEndpoints.doPeopleListingAction(), body);
      // String body = json.encode(formData);
      print(response?.body);
    } catch (e) {
      print('Error in NotificationRepositoryPublic.doPeopleListingAction():$e');
    }
    return response;
  }
}
