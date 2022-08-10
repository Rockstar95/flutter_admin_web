import 'dart:developer';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/preference/preference_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/Userprofileresponse.dart';

class PreferenceRepositoryPublic extends PreferenceRepository {
  @override
  Future<Response?> getTimeZoneResponseEvent() async {
    // TODO: implement getWikiCategories
    Response? response;
    try {
      print("......catalog....${ApiEndpoints.getPreferenceTimeZone()}");

      response =
          await RestClient.getPostData(ApiEndpoints.getPreferenceTimeZone());

      print("getPreferenceTimeZone response ${response?.body.toString()}");
    } catch (e) {
      print(
          "Error in PreferenceRepositoryPublic.getTimeZoneResponseEvent():$e");
    }

    return response;
  }

  @override
  Future<Response?> savePreferenceEvent(
      {String timeZone = "",
      String languageSelection = "",
      String userLanguage = "",
      int activities = 0}) async {
    // TODO: implement savePreferenceEvent
    Response? response;
    try {
      print("....${ApiEndpoints.savePreference()}");

      var strUserID = await sharePrefGetString(sharedPref_userid);

      // var data = {
      //   "profilesettings":
      //       "{'securityQuestions':[],'ProfilePreferences':[{'Usertimezone':'$timeZone','UserLanguage':'$userLanguage','langselection':'$languageSelection','StartTime':'','EndTime':'','UserId':'$strUserID','Activites':'$activities'}]}",
      // };
      Map<String, String> data = {
        "profilesettings":
            "{\"securityQuestions\":[],\"ProfilePreferences\":[{\"Usertimezone\":\"$timeZone\",\"UserLanguage\":\"$userLanguage\",\"langselection\":\"$languageSelection\",\"StartTime\":\"\",\"EndTime\":\"\",\"UserId\":\"$strUserID\",\"Activites\":$activities,\"discussionforumnotificationsettings\":0}]}",
      };
      print(data);
      response = await RestClient.postApiData(ApiEndpoints.savePreference(), data);

      print("savePreferenceEvent response ${response?.body.toString()}");
    } catch (e) {
      print("Error in PreferenceRepositoryPublic.savePreferenceEvent():$e");
    }

    return response;
  }

  @override
  Future<Response?> getProfileSettingResponseEvent() async {
    // TODO: implement getProfileSettingResponseEvent
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "...... ${ApiEndpoints.getUserProfileSettings(strUserID, strSiteID, language)}");

      response = await RestClient.getPostData(
          ApiEndpoints.getUserProfileSettings(strUserID, strSiteID, language));

      print("getUserProfileSettings response ${response?.body.toString()}");
    } catch (e) {
      print(
          "Error in PreferenceRepositoryPublic.getProfileSettingResponseEvent():$e");
    }

    return response;
  }

  //PaymentHistory
  @override
  Future<Response?> getPaymentHistoryResponseEvent() async {
    // TODO: implement getPaymentResponseEvent
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      var data = {"UserID": strUserID, "SiteID": strSiteID, "Locale": language};
      print("......PaymentHistory....${ApiEndpoints.getPaymentHistory()}");

      response =
          await RestClient.postApiData(ApiEndpoints.getPaymentHistory(), data);

      print("getPaymentHistory response ${response?.body.toString()}");
    } catch (e) {
      print(
          "Error in PreferenceRepositoryPublic.getPaymentHistoryResponseEvent():$e");
    }

    return response;
  }

  @override
  Future<Response?> getActiveMembershipResponseEvent() async {
    // TODO: implement getMembershipResponseEvent
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      var data = {"UserID": strUserID, "SiteID": strSiteID, "Locale": language};
      print("......ActiveMembership....${ApiEndpoints.getActiveMembership()}");

      response = await RestClient.postApiData(
          ApiEndpoints.getActiveMembership(), data);

      print("getActiveMembership response ${response?.body}");
    } catch (e) {
      print(
          "Error in PreferenceRepositoryPublic.getActiveMembershipResponseEvent():$e");
    }

    return response;
  }

  @override
  Future<Response?> getMembershipPlanResponseEvent() async {
    // TODO: implement getMembershipPlanResponseEvent
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      var data = {"UserID": strUserID, "SiteID": strSiteID, "Locale": language};
      print("......MembershipPlans....${ApiEndpoints.getMembershipPlans()}");

      response =
          await RestClient.postApiData(ApiEndpoints.getMembershipPlans(), data);

      print("getMembershipPlans response ${response?.body}");
    } catch (e) {
      print(
          "Error in PreferenceRepositoryPublic.getMembershipPlanResponseEvent():$e");
    }

    return response;
  }

  @override
  Future<Response?> getPaymentGatewayResponseEvent(
      {String currency = ""}) async {
    // TODO: implement getMembershipPlanResponseEvent
    Response? response;
    try {
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      print(
          "......PaymentGateway....${ApiEndpoints.getPaymentGateway(currency, strSiteID)}");

      response = await RestClient.getPostData(
          ApiEndpoints.getPaymentGateway(currency, strSiteID));

      print("getPaymentGateway response ${response?.body}");
    } catch (e) {
      print(
          "Error in PreferenceRepositoryPublic.getPaymentGatewayResponseEvent():$e");
    }

    return response;
  }

  @override
  Future<Response?> getPrivaryFields() async {
    UserProfileResponse? profileResponse;
    Response? apiResponse;
    try {
      var userId = await sharePrefGetString(sharedPref_userid);
      var siteId = await sharePrefGetString(sharedPref_siteid);
      var locale = await sharePrefGetString(sharedPref_AppLocale);

      Response? response = await RestClient.getData(ApiEndpoints.GetPrivaryFields(userId, siteId, locale), false);

      log('GetPrivaryFields Status:${response?.statusCode}, Body:${response?.body}');

      if (response?.statusCode == 200) {
        profileResponse = privacyProfileResponseFromJson(response?.body ?? "{}");
      }

      //apiResponse = Response(data: profileResponse, statusCode: response?.statusCode, requestOptions: RequestOptions(path: ''),);
      apiResponse = response;
    } catch (e) {
      print("Error in PreferenceRepositoryPublic.GetPrivaryFields():$e");
    }

    return apiResponse;
  }

  @override
  Future<Response?> postPrivaryFields(int ispublic, String attributeid) async {
    Response? apiResponse;
    try {
      var userId = await sharePrefGetString(sharedPref_userid);

      Map data = {
        'UserID': userId,
        'attributeIDs': attributeid,
        'isPublic': ispublic.toString()
      };

      Response? response = await RestClient.postApiDataForm(ApiEndpoints.SavePrivaryFields(), data);

      print('responseprofile ${response?.body}');

      if (response?.statusCode == 200) {
        print('responseprofile $response');
      }

      apiResponse = response;
      // apiResponse = Response(data: response, statusCode: response?.statusCode, requestOptions: RequestOptions(path: ""));
    } catch (e) {
      print("Error in PreferenceRepositoryPublic.PostPrivaryFields():$e");
    }

    return apiResponse;
  }
}
