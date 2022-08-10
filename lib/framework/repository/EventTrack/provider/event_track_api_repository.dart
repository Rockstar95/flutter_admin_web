import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/contract/event_track_repository.dart';
import 'package:logger/logger.dart';

class EventTrackListApiRepository implements EventTrackListRepository {
  Logger logger = Logger();

  @override
  Future<ApiResponse?> mobileGetMobileContentMetaData(String url) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;
    Response? response = await RestClient.getPostData(url);
    if (response?.statusCode == 200) {
      isSuccess = true;
    } else {
      isSuccess = false;
    }

    apiResponse =
        ApiResponse(data: response, status: response?.statusCode ?? 0);

    return apiResponse;
  }

  @override
  Future<Response?> updateMyLearningArchive(
      bool isArchive, String contentID) async {
    // TODO: implement UpdateMyLearningArchive

    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      int archV = 0;
      if (isArchive) {
        archV = 1;
      } else {
        archV = 0;
      }
      Map data = {
        'ContentID': contentID,
        'IsArchived': archV,
        'UserID': strUserID
      };

      String body = json.encode(data);

      print("updateMyLearningArchiveURL :--- $body");
      response = await RestClient.postMethodData(
          ApiEndpoints.updateMyLearningArchiveURL(), body);
    } catch (e) {
      print(
          "Error in EventTrackListApiRepository.UpdateMyLearningArchive():$e");
    }

    return response;
  }

  @override
  Future<Response?> cancelEnrollment(
      bool isBadCancel, String strContentID) async {
    // TODO: implement cancelEnrollment
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          'cancelenrollment_url ${ApiEndpoints.cancelEnrollment(strContentID, strUserID, isBadCancel, language, strSiteID)}');

      response = await RestClient.getPostData(ApiEndpoints.cancelEnrollment(
          strContentID, strUserID, isBadCancel, language, strSiteID));
    } catch (e) {
      print("Error in EventTrackListApiRepository.cancelEnrollment():$e");
    }

    return response;
  }

  @override
  Future<Response?> getEventTrackTabs(String url) async {
    Response? response = await RestClient.getPostData(url);

    return response;
  }

  @override
  Future<Response?> getTrackResources(String contentId) async {
    // TODO: implement getTrackResources
    Response? response = await RestClient.getPostData(
        ApiEndpoints.getTrackListResourceUrl(contentId));

    return response;
  }

  @override
  Future<Response?> getTrackGlossary(String contentId) async {
    Response? response = await RestClient.getPostData(
        ApiEndpoints.getTrackListGlossaryUrl(contentId));

    print('getglossaryresponse ${response?.body}');
    return response;
  }

  @override
  Future<Response?> setCompleteStatus(String contentId, String scoId) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      response = await RestClient.getPostData(ApiEndpoints.setStatusCompleted(
          contentId, strUserID.toString(), scoId, strSiteID));
    } catch (e) {
      print("Error in EventTrackListApiRepository.setCompleteStatus():$e");
    }

    return response;
  }

  @override
  Future<Response?> getOverview(
      String contentId, int objTypeId, String strUserID) async {
    // TODO: implement getOverview
    Response? response;

    try {
//      var strUserID = await sharePref_getString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          'getoverviewUrl ${ApiEndpoints.getTrackListOverviewUrl(contentId, strUserID.toString(), strSiteID, language, objTypeId.toString())}');

      response = await RestClient.getPostData(
          ApiEndpoints.getTrackListOverviewUrl(contentId, strUserID.toString(),
              strSiteID, language, objTypeId.toString()));

      print('getoverviewUrl ${response?.body}');
    } catch (e) {
      print("Error in EventTrackListApiRepository.getOverview():$e");
    }

    return response;
  }

  @override
  Future<Response?> badCancelEnroll(String contentid) async {
    Response? response;

    try {
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      print(
          'getoverviewUrl_badcancelenroll ${ApiEndpoints.badCancelEnrollment(contentid, strSiteID)}');

      response = await RestClient.getPostData(
          ApiEndpoints.badCancelEnrollment(contentid, strSiteID));

      print('getoverviewUrl_badcancelenroll $response');
    } catch (e) {
      print("Error in EventTrackListApiRepository.badcancelenroll():$e");
    }

    return response;
  }

  @override
  Future<Response?> cancelEnroll(String contentid, String isBadCancel) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      response = await RestClient.getPostData(ApiEndpoints.cancelEnroll(
          contentid, strUserID.toString(), isBadCancel, language, strSiteID));

      print('getoverviewUrl_cancelenroll ${response?.body}');
    } catch (e) {
      print("Error in EventTrackListApiRepository.cancelenroll():$e");
    }

    return response;
  }

  @override
  Future<Response?> downloadCompleteInfo(String contentId, int ScoID) async {
    // TODO: implement addToWishList
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map data = {
        "UserID": strUserID,
        "ContentID": contentId,
        "ScoID": ScoID,
      };

      String body = json.encode(data);
      response = await RestClient.postMethodData(
          ApiEndpoints.GetUpdateDownloadCompleteStatus(), body);

      print("Download complete status ${response?.body.toString()}");
    } catch (e) {
      print("Error in EventTrackListApiRepository.Downloadcompleteinfo():$e");
    }

    return response;
  }
}
