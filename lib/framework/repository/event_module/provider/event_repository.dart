import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/event_module/contract/event_module_repository.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/expiry_events.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/waitinglist_request.dart';

class EventInfoRepository implements EventModuleRepository {
  @override
  Future<Response?> getPeopleTabList() async {
    Response? response;

    try {
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      var userid = await sharePrefGetString(sharedPref_userid);
      response = await RestClient.getPostData(ApiEndpoints.getPeopleTabList(
          '153', '3497', strSiteID, language, userid));

      print('apiresponseval $response');
    } catch (e) {
      print("Error in EventInfoRepository.getPeopleTabList():$e");
    }

    return response;
  }

  @override
  Future<Response?> getTabContent(String tabRequest) async {
    Response? response;

    try {
      response = await RestClient.postApiData(
          ApiEndpoints.getMobileCatalogObjectsDataURL(),
          jsonDecode(tabRequest));

      print('getcontenttabre ${response?.body}');
    } catch (e) {
      print("Error in EventInfoRepository.getTabContent():$e");
    }

    return response;
  }

  @override
  Future<Response?> getSessionList(String contentid) async {
    Response? response;

    try {
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      var userid = await sharePrefGetString(sharedPref_userid);

      response = await RestClient.getPostData(ApiEndpoints.getEventSessionData(
          contentid, userid, strSiteID, language));

      print('apiresponseval $response');
    } catch (e) {
      print("Error in EventInfoRepository.getSessionList():$e");
    }

    return response;
  }

  @override
  Future<Response?> badCancelEnroll(String contentId) async {
    Response? response;

    try {
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      print(
          'getoverviewUrl_badcancelenroll ${ApiEndpoints.badCancelEnrollment(contentId, strSiteID)}');

      response = await RestClient.getPostData(
          ApiEndpoints.badCancelEnrollment(contentId, strSiteID));

      print('getoverviewUrl_badcancelenroll ${response?.body}');
    } catch (e) {
      print("Error in EventInfoRepository.badcancelenroll():$e");
    }

    return response;
  }

  @override
  Future<Response?> cancelEnroll(String contentId, String isBadCancel) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      response = await RestClient.getPostData(ApiEndpoints.cancelEnroll(
          contentId, strUserID.toString(), isBadCancel, language, strSiteID));

      print('getoverviewUrl_cancelenroll $response');
    } catch (e) {
      print("Error in EventInfoRepository.cancelenroll():$e");
    }

    return response;
  }

  @override
  Future<Response?> expiryEvents(String strContentID) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      ExpiryEventsRequest eventsRequest = ExpiryEventsRequest();
      eventsRequest.selectedContent = strContentID;
      eventsRequest.userId = strUserID;
      eventsRequest.siteId = strSiteID;
      eventsRequest.orgUnitId = strSiteID;
      eventsRequest.locale = language;

      String data = expiryEventsRequestToJson(eventsRequest);

      response = await RestClient.postApiData(ApiEndpoints.expiryEvent, data);

      print('getoverviewUrl_cancelenroll $response');
    } catch (e) {
      print("Error in EventInfoRepository.expiryEvents():$e");
    }

    return response;
  }

  @override
  Future<Response?> waitingList(String strContentID) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      WaitingListRequest waitingListRequest = WaitingListRequest();
      waitingListRequest.wlContentId = strContentID;
      waitingListRequest.userId = strUserID;
      waitingListRequest.siteid = strSiteID;
      waitingListRequest.locale = language;

      String data = waitingListRequestToJson(waitingListRequest);

      response = await RestClient.postApiData(ApiEndpoints.waitingList, data);
    } catch (e) {
      print("Error in EventInfoRepository.waitingList():$e");
    }

    return response;
  }

  @override
  Future<Response?> viewRecording(String contentId) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      response = await RestClient.getPostData(
          ApiEndpoints.eventRecording(contentId, strUserID.toString()));

      print('getoverviewUrl_cancelenroll $response');
    } catch (e) {
      print("Error in EventInfoRepository.viewRecording():$e");
    }

    return response;
  }

  @override
  Future<Response?> downloadCompleteInfo(String contentId, int scoID) async {
    // TODO: implement addToWishList
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map data = {
        "UserID": strUserID,
        "ContentID": contentId,
        "ScoID": scoID,
      };

      String body = json.encode(data);
      response = await RestClient.postMethodData(
          ApiEndpoints.GetUpdateDownloadCompleteStatus(), body);

      print("Download complete status ${response?.body.toString()}");
    } catch (e) {
      print("Error in EventInfoRepository.Downloadcompleteinfo():$e");
    }

    return response;
  }
}
