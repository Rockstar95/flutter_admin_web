import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/competencies/model/user_skill_rating_request.dart';
import 'package:flutter_admin_web/framework/repository/competencies/my_competencies_repositry_builder.dart';

class MyCompetenciesRepositoryPublic extends MyCompetenciesRepository {
  @override
  Future<Response?> jobRolSkills(
      {int componentID = 0,
      int componentInstanceID = 0,
      int jobRoleID = 0}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> mapData = {
        'ComponentID': componentID,
        'ComponentInstanceID': componentInstanceID,
        'UserID': int.parse(strUserID),
        'SiteID': int.parse(strSiteID),
        'Locale': strLanguage,
        'JobRoleID': jobRoleID
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getJobRoleSkills(), mapData);
    } catch (e) {
      print('Error in MyCompetenciesRepositoryPublic.jobRolSkills():$e');
    }
    return response;
  }

  @override
  Future<Response?> prefCatList(
      {int componentID = 0,
      int componentInstanceID = 0,
      int jobRoleID = 0}) async {
    // TODO: implement userQuestionsListData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map<String, dynamic> mapData = {
        'ComponentID': componentID,
        'ComponentInstanceID': componentInstanceID,
        'UserID': int.parse(strUserID),
        'SiteID': int.parse(strSiteID),
        'JobRoleID': jobRoleID
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getPrefCatList(), mapData);
    } catch (e) {
      print('Error in MyCompetenciesRepositoryPublic.prefCatList():$e');
    }
    return response;
  }

  @override
  Future<Response?> userSkills(
      {int componentID = 0,
      int componentInstanceID = 0,
      int prefCatId = 0,
      int jobRoleID = 0}) async {
    // TODO: implement userQuestionsListData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map<String, dynamic> mapData = {
        'ComponentID': componentID,
        'ComponentInstanceID': componentInstanceID,
        'UserID': int.parse(strUserID),
        'SiteID': int.parse(strSiteID),
        'PrefCatid': prefCatId,
        'JobRoleID': jobRoleID
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getUserSkills(), mapData);
    } catch (e) {
      print('Error in MyCompetenciesRepositoryPublic.userSkills():$e');
    }
    return response;
  }

  @override
  Future<Response?> updateUserEvaluation({
    int componentID = 0,
    int componentInsID = 0,
    int jobRoleID = 0,
    int prefCategoryID = 0,
    String skillSetValue = "",
  }) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      UserSkillRatingRequest ratingRequest = new UserSkillRatingRequest();
      ratingRequest.componentID = componentID;
      ratingRequest.componentInsID = componentInsID;
      ratingRequest.jobRoleID = jobRoleID;
      ratingRequest.locale = strLanguage;
      ratingRequest.prefCategoryID = prefCategoryID;
      ratingRequest.siteID = int.parse(strSiteID);
      ratingRequest.skillSetValue = skillSetValue;
      ratingRequest.userID = int.parse(strUserID);

      String data = userSkillRatingRequestToJson(ratingRequest);

      response = await RestClient.postMethodData(
          ApiEndpoints.getUpdateUserEvalution(), data);

      print(
          "userEvaluationStateCode statusCode :- ${response?.statusCode.toString()}");
      print("userEvaluationObjectData Response :- ${response.toString()}");
    } catch (e) {
      print(
          'Error in MyCompetenciesRepositoryPublic.updateUserEvaluation():$e');
    }
    return response;
  }

  @override
  Future<Response?> getJobRoleData(
      {int componentID = 0,
      int componentInstanceID = 0,
      bool isParent = false}) async {
    // TODO: implement getJobRoleData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> mapData = {
        'ComponentID': componentID,
        'ComponentInstanceID': componentInstanceID,
        'IsParent': isParent,
        'Locale': strLanguage,
        'SiteID': int.parse(strSiteID),
        'UserID': int.parse(strUserID)
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getJobRoleData(), mapData);
    } catch (e) {
      print('Error in MyCompetenciesRepositoryPublic.getJobRoleData():$e');
    }
    return response;
  }

  @override
  Future<Response?> addJobRole(
      {int jobRoleIDs = 0, String tagName = ""}) async {
    // TODO: implement addJobRole
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> mapData = {
        'UserID': int.parse(strUserID),
        'JobRoleIDs': jobRoleIDs,
        'TagName': tagName,
      };
      String body = json.encode(mapData);
      print('Add JobRole  $body');
      response =
          await RestClient.postMethodData(ApiEndpoints.addJobRole(), body);

      print(" response ${response?.body.toString()}");
    } catch (e) {
      print('Error in MyCompetenciesRepositoryPublic.addJobRole():$e');
    }

    return response;
  }
}
