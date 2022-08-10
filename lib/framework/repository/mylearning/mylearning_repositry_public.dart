import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/contract/mylearning_repositry.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/delete_user_review_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/get_user_rating_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mycatalog_req.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearnplus_req.dart';
import 'package:intl/intl.dart';

class MyLearningRepositoryPublic extends MyLearningRepository {
  @override
  Future<Response?> getMobileMyCatalogObjectsData(
      int pageIndex,
      int pageSize,
      bool isArchive,
      bool isWaitList,
      String searchTxt,
      String selectedSort,
      String selectedGroupBy,
      String selectedCategories,
      String selectedObjectTypes,
      String selectedSkillCats,
      String selectedJobRoles,
      String selectedCredits,
      String selectedInstructor,
      String contentID,
      String contentStatus) async {
    Response? response;
    try {
      print(
          "......getMobileMyCatalogObjectsData....${ApiEndpoints.getMobileMyCatalogObjectsData()}");

      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      MyCatalogRequest learningModel = new MyCatalogRequest();
      learningModel.pageIndex = pageIndex;
      learningModel.pageSize = pageSize;
      learningModel.searchText = searchTxt;
      learningModel.source = 0;
      learningModel.type = 0;
      learningModel.sortBy = selectedSort;
      learningModel.componentId = "3";
      learningModel.componentInsId = "3134";
      learningModel.hideComplete = "false";
      learningModel.userId = strUserID;
      learningModel.siteId = strSiteID;
      learningModel.orgUnitId = strSiteID;
      learningModel.locale = language.isNotEmpty ? language : "en-us";
      learningModel.groupBy = selectedGroupBy;
      learningModel.categories = selectedCategories;
      learningModel.objectTypes = selectedObjectTypes;
      learningModel.skillCats = selectedSkillCats;
      learningModel.skills = "";
      learningModel.jobRoles = selectedJobRoles;
      learningModel.solutions = "";
      learningModel.ratings = "";
      learningModel.keywords = "";
      learningModel.priceRange = "";
      learningModel.duration = "";
      learningModel.instructors = selectedInstructor;
      learningModel.isArchived = isArchive ? 1 : 0;
      learningModel.isWaitList = isWaitList ? 1 : 0;
      learningModel.filterCredits = selectedCredits;
      learningModel.multiLocation = "";
      learningModel.contentID = contentID;
      learningModel.contentStatus = contentStatus;

      String data = myCatalogRequestToJson(learningModel);

      response = await RestClient.postMethodData(
          ApiEndpoints.getMobileMyCatalogObjectsData(), data);
      //print("getMobileMyCatalogObjectsData statusCode :- ${response?.statusCode.toString()}");
      //log("getMobileMyCatalogObjectsData Response :- ${response?.body.toString()}");
    } catch (e) {
      print(
          "Error in MyLearningRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getMobileMyLearningPlusObjectsData(
      int pageIndex,
      int pageSize,
      bool isArchive,
      bool isWaitList,
      String searchTxt,
      String selectedSort,
      String selectedGroupBy,
      String selectedCategories,
      String selectedObjectTypes,
      String selectedSkillCats,
      String selectedJobRoles,
      String selectedCredits,
      String selectedInstructor,
      String contentID,
      String contentStatus,
      String compId,
      String compInsId,
     int isWishlistCount,
     String dateFilter
      ) async {
    Response? response;
    try {
      print(
          "......getMobileMyLearningPlusObjectsData....${ApiEndpoints.getMobileMyCatalogObjectsData()}");

      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      MyLearningPlusRequest learningModel = new MyLearningPlusRequest();

      learningModel.pageIndex = pageIndex;
      learningModel.pageSize = pageSize;
      learningModel.searchText = searchTxt;
      learningModel.source = 0;
      learningModel.type = 0;
      learningModel.sortBy = "MC.DateAssigned desc";
      learningModel.componentId = compId;   ///"3";
      learningModel.componentInsId = compInsId;  //"4238";
      learningModel.hideComplete = "false";
      learningModel.userId = strUserID;
      learningModel.siteId = strSiteID;
      learningModel.orgUnitId = strSiteID;
      learningModel.locale = language;
      learningModel.groupBy = selectedGroupBy;
      learningModel.categories = selectedCategories;
      learningModel.objectTypes = selectedObjectTypes;
      learningModel.skillCats = selectedSkillCats;
      learningModel.skills = "";
      learningModel.jobRoles = selectedJobRoles;
      learningModel.solutions = "";
      learningModel.ratings = "";
      learningModel.keywords = "";
      learningModel.priceRange = "";
      learningModel.duration = "";
      learningModel.instructors = selectedInstructor;
      learningModel.isArchived = isArchive ? 1 : 0;
      learningModel.isWaitList = isWaitList ? 1 : 0;
      learningModel.filterCredits = selectedCredits;
      learningModel.multiLocation = "";
      learningModel.contentStatus = contentStatus;
      learningModel.isWishListContent = isWishlistCount;
      learningModel.dateFilter = dateFilter;

      //passed,failed,attended,notattended,completed

      String data = myLearnPlusRequestToJson(learningModel);
      response = await RestClient.postMethodData(
          ApiEndpoints.getMobileMyCatalogObjectsData(), data);

      print(
          "getMobileMyLearningPlusObjectsData statusCode :- ${response?.statusCode.toString()}");
      print(
          "getMobileMyLearningPlusObjectsData Response :- ${response?.body.toString()}");
    } catch (e) {
      print(
          "Error in MyLearningRepositoryPublic.getMobileMyLearningPlusObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getUserRatingsOfTheContent(
      String contentID, int skippedRows) async {
    Response? response;
    try {
      print("......getUserRatingsURL....${ApiEndpoints.getUserRatingsURL()}");
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      GetReviewRequest getReviewRequest = new GetReviewRequest();
      getReviewRequest.contentId = contentID;
      getReviewRequest.locale = language;
      getReviewRequest.metadata = "0";
      getReviewRequest.intUserId = strUserID;
      getReviewRequest.cartId = "";
      getReviewRequest.iCms = "0";
      getReviewRequest.componentId = "3";
      getReviewRequest.siteId = strSiteID;
      getReviewRequest.detailsCompId = "107";
      getReviewRequest.detailsCompInsId = "3291";
      getReviewRequest.eRitems = "false";
      getReviewRequest.skippedRows = skippedRows;
      getReviewRequest.noofRows = 3;

      String data = getReviewRequestToJson(getReviewRequest);
      print('myratungresponse $data');

      response = await RestClient.postMethodData(
          ApiEndpoints.getUserRatingsURL(), data);

      print(
          "getUserRatingsURL statusCode :- ${response?.statusCode.toString()}");
      print("getUserRatingsURL Response :- ${response?.body.toString()}");
    } catch (e) {
      print(
          "Error in MyLearningRepositoryPublic.getUserRatingsOfTheContent():$e");
    }

    return response;
  }

  @override
  Future<Response?> deleteRatingsOfTheContent(String contentID) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final String dateString = formatter.format(now);

      DeleteReviewRequest deleteReviewRequest = new DeleteReviewRequest();
      deleteReviewRequest.contentId = contentID;
      deleteReviewRequest.userId = strUserID;
      deleteReviewRequest.title = "";
      deleteReviewRequest.description = "";
      deleteReviewRequest.reviewDate = dateString;
      deleteReviewRequest.rating = 0;

      String data = deleteReviewRequestToJson(deleteReviewRequest);

      print("deleteUserRatingsURL Request :- ${data.toString()}");

      response = await RestClient.postMethodData(
          ApiEndpoints.deleteUserRatingsURL(), data);

      print(
          "deleteUserRatingsURL statusCode :- ${response?.statusCode.toString()}");
      print("deleteUserRatingsURL Response :- ${response?.body.toString()}");
    } catch (e) {
      print(
          "Error in MyLearningRepositoryPublic.deleteRatingsOfTheContent():$e");
    }

    return response;
  }

  @override
  Future<Response?> addRatingsOfTheContent(
      String contentID, String strReview, int ratingID) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final String dateString = formatter.format(now);

      DeleteReviewRequest deleteReviewRequest = new DeleteReviewRequest();
      deleteReviewRequest.contentId = contentID;
      deleteReviewRequest.userId = strUserID;
      deleteReviewRequest.title = "";
      deleteReviewRequest.description = strReview;
      deleteReviewRequest.reviewDate = dateString;
      deleteReviewRequest.rating = ratingID;

      String data = deleteReviewRequestToJson(deleteReviewRequest);

      print("addUserRatingsURL Request :- ${data.toString()}");

      response = await RestClient.postMethodData(
          ApiEndpoints.addUserRatingsURL(), data);

      print(
          "addUserRatingsURL statusCode :- ${response?.statusCode.toString()}");
      print("addUserRatingsURL Response :- ${response?.body.toString()}");
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.addRatingsOfTheContent():$e");
    }

    return response;
  }

  @override
  Future<Response?> getMyLearningDetails(
      MyLearningDetailsRequest request) async {
    Response? response;

    String data = myLearningDetailsRequestToJson(request);

    print('detailrequest $data');

    try {
      response = await RestClient.postMethodData(ApiEndpoints.getMyLearningDetails, data);
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.getMyLearningDetails():$e");
    }

    return response;
  }

  Future<Response?> getMyLearningDetails2(String contentId) async {
    Response? response;

    print('contentid:$contentId');

    try {
      response = await RestClient.getPostData(ApiEndpoints.getMyLearningDetails2 + "?insContentID=$contentId");
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.getMyLearningDetails2():$e");
    }

    return response;
  }

  @override
  Future<Response?> setCompleteStatus(String contentId, String scoId) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      response = await RestClient.getPostData(ApiEndpoints.setStatusCompleted(
          contentId, strUserID.toString(), scoId, '374'));
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.setCompleteStatus():$e");
    }

    return response;
  }

  @override
  Future<Response?> getCertificate(
      String certificateId,
      String certificatePage,
      String siteUrl,
      String certificateId2,
      String contentId,
      String scoId) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      print(
          'getscertificateapi ${ApiEndpoints.getCertificate(contentId, strUserID, '374', certificateId, certificatePage)}');

      response = await RestClient.getPostData(ApiEndpoints.getCertificate(
          contentId, strUserID, '374', certificateId, certificatePage));

      print('responsecertifivate $response ${response?.statusCode}');
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.getCertificate():$e");
    }

    return response;
  }

  @override
  Future<Response?> getComponentSortOptions(String strComponentID) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      String urlStr =
          "${ApiEndpoints.GetComponentSortOptionsURL()}OrgUnitID=$strSiteID&UserID=$strUserID&ComponentID=$strComponentID&LocaleID=$language";
      print("getComponentSortOptions $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.getComponentSortOptions():$e");
    }

    return response;
  }

  @override
  Future<Response?> updateMyLearningArchive(
      bool isArchive, String contentID) async {
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
      print("Error in MyLearningRepositoryPublic.UpdateMyLearningArchive():$e");
    }

    return response;
  }

  @override
  Future<Response?> getMyConnectionListForShareContent(String searchTxt) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      String urlStr =
          "${ApiEndpoints.GetMyconnectionListForShareContentURL()}UserID=$strUserID&Category=MyConnections&SiteID=$strSiteID&OUList=$strSiteID&SearchText=$searchTxt";
      print("GetMyconnectionListForShareContent $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print(
          "Error in MyLearningRepositoryPublic.GetMyconnectionListForShareContent():$e");
    }

    return response;
  }

  @override
  Future<Response?> sendMailToPeople(
      String toEmail,
      String subject,
      String message,
      String emailList,
      bool isPeople,
      bool isFromForm,
      bool isFromQuestion,
      String contentId) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      String body;
      Map data;

      print(
          'isPeople:$isPeople, isFromForm:$isFromForm, isFromQuestion:$isFromQuestion');

      if (isPeople) {
        if (isFromForm) {
          data = {
            'astrUserEmail': '',
            'astrUserName': '',
            'isSuggesttoConnections': false,
            'SiteID': strSiteID,
            'UserID': strUserID,
            'UserIDList': '',
            'LocaleID': "en-us",
            'UserMails': toEmail,
            'Subject': subject,
            'Message': message,
            'Contentid': 'e6fc963d-5f7e-4eae-b090-db1792acdfce',
            'ForumID': int.parse(contentId),
            'TopicID': null,
            'quesID': '',
            "AskQuestionLink": "",
            "DiscusssionForumLink": "true",
            'GameNotify': false
          };
        }
        else if (isFromQuestion) {
          data = {
            'astrUserEmail': '',
            'astrUserName': '',
            'isSuggesttoConnections': false,
            'SiteID': strSiteID,
            'UserID': strUserID,
            'UserIDList': '',
            'LocaleID': "en-us",
            'UserMails': toEmail,
            'Subject': subject,
            'Message': message,
            'Contentid': '',
            'ForumID': '',
            'TopicID': '',
            'quesID': int.parse(contentId),
            'AskQuestionLink': 'true',
            'GameNotify': false
          };
        }
        else {
          data = {
            'astrUserEmail': '',
            'astrUserName': '',
            'isSuggesttoConnections': false,
            'SiteID': strSiteID,
            'UserID': strUserID,
            'UserIDList': '',
            'LocaleID': "en-us",
            'UserMails': toEmail,
            'Subject': subject,
            'Message': message,
            'Contentid': contentId,
            'ForumID': '',
            'TopicID': '',
            'quesID': '',
            'AskQuestionLink': '',
            'GameNotify': false
          };
        }
        body = json.encode(data);
      }
      else {
        if (isFromForm) {
          data = {
            'astrUserEmail': '',
            'astrUserName': '',
            'isSuggesttoConnections': true,
            'SiteID': strSiteID,
            'UserID': strUserID,
            'UserIDList': emailList, //send iDs
            'LocaleID': language,
            'UserMails': '',
            'Subject': subject,
            'Message': message,
            'Contentid': '',
            "TopicID":null,
            "AskQuestionLink": "",
            "DiscusssionForumLink": "true",
            'ForumID': int.parse(contentId),
            'GameNotify': false,
          };
        }
        else if (isFromQuestion) {
          data = {
            'astrUserEmail': '',
            'astrUserName': '',
            'isSuggesttoConnections': true,
            'SiteID': strSiteID,
            'UserID': strUserID,
            'UserIDList': emailList, //send iDs
            'LocaleID': language,
            'UserMails': '',
            'Subject': subject,
            'Message': message,
            'Contentid': '',
            'ForumID': '',
            'TopicID': '',
            'AskQuestionLink': true,
            'DiscusssionForumLink': '',
            'quesID': int.parse(contentId),
            'GameNotify': false,
          };
        } else {
          data = {
            'astrUserEmail': '',
            'astrUserName': '',
            'isSuggesttoConnections': true,
            'SiteID': strSiteID,
            'UserID': strUserID,
            'UserIDList': emailList, //send iDs
            'LocaleID': language,
            'UserMails': '',
            'Subject': subject,
            'Message': message,
            'Contentid': contentId,
            'TopicID': '',
            'AskQuestionLink': '',
            'DiscusssionForumLink': '',
            'GameNotify': false,
          };
        }
        body = json.encode(data);
      }

      print("SendMailToPeopleURL :--- $body");
      response = await RestClient.postMethodData(
          ApiEndpoints.SendMailToPeopleURL(), body);
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.SendMailToPeople():$e");
    }

    return response;
  }

  @override
  Future<Response?> cancelEnrollment(
      bool isBadCancel, String strContentID) async {
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
      print("Error in MyLearningRepositoryPublic.cancelEnrollment():$e");
    }

    return response;
  }

  Future<Response?> getCategoriesTree(String categoryID,String componentId) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      //var strComponentID = await sharePref_getString(sharedPref_ComponentID);  ==> removed this as component Id differe throught places to places.

      print('cancelenrollment_response $response');
      String urlStr =
          "${ApiEndpoints.GetCategoriesTreeURL()}SiteID=$strSiteID&UserID=$strUserID&ComponentID=$componentId&Type=$categoryID&FilterMediaType=&EventType=&SprateEvents=false&IsCompetencypath=false&Locale=$language&CatalogCategoriesID=";

      print("GetCategoriesTree $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.GetCategoriesTree():$e");
    }

    return response;
  }

  Future<Response?> getLearningProviderTree() async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      print('learningprovider_response $response');
      String urlStr =
          ApiEndpoints.GetLearningproviderURL(strSiteID, strUserID, 'public');

      print("GetLearningprovideTree $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.GetLearningproviderTree():$e");
    }

    return response;
  }

  @override
  Future<Response?> getContentStatus(String url) async {
    Response? response;

    try {
      print("Get Content Status Url:$url");
      response = await RestClient.getPostData(url);
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.getContentStatus():$e");
    }

    return response;
  }

  @override
  Future<Response?> courseTrackingApiCall(
      String courseURL,
      String userID,
      String scoId,
      String objectTypeId,
      String contentID,
      String siteIDValue) async {
    Response? response;

    try {
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      print('cancelenrollment_response $response');
      String urlStr =
          "${ApiEndpoints.webAPIInitialiseTrackingApiCall(userID, scoId, objectTypeId, contentID, strSiteID)}";

      print("courseTrackingApiCall $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.courseTrackingApiCall():$e");
    }

    return response;
  }

  @override
  Future<Response?> tokenFromSessionIdAiCall(
      String courseURL,
      String courseName,
      String contentID,
      String objectTypeId,
      String learnerSCOID,
      String learnerSessionID,
      String userID) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      var webAPIUrl = await sharePrefGetString(sharedPref_webApiUrl);
      var lMSUrl = await sharePrefGetString(sharedPref_lmsUrl);
      var learnerURL = await sharePrefGetString(sharedPref_learnerUrl);
      var loginUserId = await sharePrefGetString(sharedPref_LoginUserID);
      var userSessionID = await sharePrefGetString(sharedPref_sessionid);
      var token = await sharePrefGetString(sharedPref_bearer);

      Map chidPlatformdata;
      Map childCourseData;
      Map mainCourseDetails;

      print("learnerSessionID:${learnerSessionID.replaceAll('"', "")}");

      childCourseData = {
        'Course_URL': courseURL,
        'courseName': courseName,
        'ContentID': contentID,
        'Obj_Type_ID': objectTypeId,
        'learnerSCOID': learnerSCOID,
        'learnerSessionID': learnerSessionID.replaceAll('"', ""),
        'UserID': strUserID,
        'UserSessionID': userSessionID,
        'usermailid': loginUserId,
        'locale': language,
        'siteid': strSiteID,
        'SaltKey': ApiEndpoints.saltKey,
        "LoginUserId" : strUserID,
      };

      chidPlatformdata = {
        'WebAPIUrl': webAPIUrl,
        'LMSUrl': lMSUrl,
        'LearnerURL': learnerURL,
        'UniqueID': '$token',
        'currentOrigin': 'frommobile',
      };

      mainCourseDetails = {
        'CourseDetails': json.encode(childCourseData),
        'APIData': json.encode(chidPlatformdata),
      };

      log("InsertCourseDataByTokenApiCall :--- $mainCourseDetails");
      response = await RestClient.postApiDataForm(ApiEndpoints.InsertCourseDataByTokenApiCall(), mainCourseDetails);
    }
    catch (e, s) {
      print("Error in MyLearningRepositoryPublic.tokenFromSessionIdAiCall():$e");
      print(s);
    }
    return response;
  }

  @override
  Future<Response?> updateCompleteStatusCall(
      String contentId, String userID, String scoId) async {
    Response? response;

    try {
      String urlStr = "${ApiEndpoints.updateCompleteStatus()}";

      Map data = {'ContentID': contentId, 'UserId': userID, 'ScoID': scoId};
      print("updateCompleteStatus $urlStr");
      response = await RestClient.postApiData(urlStr, data);
      print('updateCompleteStatus ${response?.body}');
    } catch (e) {
      print(
          "Error in MyLearningRepositoryPublic.updateCompleteStatusCall():$e");
    }

    return response;
  }

  @override
  Future<Response?> sendViaEmailMyLearn(String userMails, String subject,
      String message, bool isAttachDocument, String contentId) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map data = {
        'SiteID': strSiteID,
        'UserID': strUserID,
        'UserMails': userMails,
        'Subject': subject,
        'Message': message,
        'Contentid': contentId,
        'LocaleID': strLanguage,
        'isattachDocument': isAttachDocument
      };

      String body = json.encode(data);
      response = await RestClient.postMethodData(
          ApiEndpoints.sendviaemailmylearn(), body);

      print('updateCompleteStatus ${response?.body}');
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.sendviaemailmylearn():$e");
    }

    return response;
  }

  @override
  Future<Response?> getUserAchievementPlusData(
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

      Map<String, dynamic> userachivmentRequest = {
        'UserID': strUserID,
        'SiteID': strSiteID,
        'Locale': strLanguage,
        'ComponentID': componentID,
        'ComponentInsID': componentInsID,
        'GameID': gameID,
      };
      String body = json.encode(userachivmentRequest);

      response = await RestClient.postMethodData(ApiEndpoints.getUserAchievementData(), body);
      print("getUserAchievementPlusData Status:${response?.statusCode}, Body:${response?.body}");
      // String body = json.encode(formData);
    } catch (e, s) {
      print(
          "Error in MyLearningRepositoryPublic.getUserAchievementPlusData():$e");
      print(s);
    }
    return response;
  }

  @override
  Future<Response?> getDynamicTabPlusEvent(
      String compId, String compInsId) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......DynamicTabs....${ApiEndpoints.getDynamicTabsPlus(strUserID, strSiteID, language, compId, compInsId)}");

      response = await RestClient.getPostData(ApiEndpoints.getDynamicTabsPlus(
          strUserID, strSiteID, language, compId, compInsId));

      print('Dynamic tabs response --- $response ');
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.getDynamicTabPlusEvent():$e");
    }
    return response;
  }

  @override
  Future<Response?> getGameLearnPlusList(
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
      print(response);
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.getGameLearnPlusList():$e");
    }
    return response;
  }

  @override
  Future<Response?> getLearnPlusLeaderboardData(
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
      print(" response $response");
    } catch (e) {
      print(
          "Error in MyLearningRepositoryPublic.getLearnPlusLeaderboardData():$e");
    }
    return response;
  }

  @override
  Future<Response?> getEventResourceInfo(
      String componentId,
      String componentInsId,
      String objectTypes,
      String multiLocation,
      String startDate,
      String endDate,
      String eventId) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> request = {
        'UserID': strUserID,
        'SiteID': strSiteID,
        'ComponentID': componentId,
        'ComponentInstanceID': componentInsId,
        'StartDate': startDate,
        'EndDate': endDate,
        'EventID': eventId,
        'Locale': strLanguage,
        'ShowEvents': "1",
        'ShowLearnerContent': "1",
        'ShowRelated': "1",
        'multiLocation': multiLocation,
        'Objecttypes': objectTypes,
      };

      String body = json.encode(request);

      response = await RestClient.postMethodData(
          ApiEndpoints.getEventResourceDetails(), body);
      // String body = json.encode(formData);
      print(
          "getEventResourceinfo response Status:${response?.statusCode}, Body:${response?.body}");
    } catch (e) {
      print("Error in MyLearningRepositoryPublic.getEventResourceinfo():$e");
    }
    return response;
  }

  @override
  Future<Response?> getMobileMyCatalogObjectsPlusData(
      int pageIndex,
      int selectedCategoryID,
      String searchTxt,
      bool isWishList,
      String selectedSort,
      String additionalParams,
      String selectedGroupBy,
      String selectedCategories,
      String selectedObjectTypes,
      String selectedSkillCats,
      String selectedJobRoles,
      String selectedCredits,
      String selectedInstructor,
      String selectedRating,
      String learningPortals,
      String type,
      String selectedPriceRange,
      String compId,
      String compInsId,
      int isWishlistContent) async {
    Response? response;
    try {
      print(
          "......catalog....${ApiEndpoints.getMobileCatalogObjectsDataURL()}");

      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      var strComponentID = await sharePrefGetString(sharedPref_ComponentID);
      var strRepositoryId = await sharePrefGetString(sharedPref_RepositoryId);

      Map data = {
        "pageIndex": 1,
        "pageSize": 50,
        "SearchText": searchTxt,
        "ContentID": "",
        "sortBy": selectedSort,
        "ComponentID": type == 'plus' ? compId : strComponentID,
        "ComponentInsID": type == 'plus' ? compInsId : strRepositoryId,
        "AdditionalParams": additionalParams, //"EventComponentID=153~FilterContentType=70~eventtype=upcoming~HideCompleteStatus=true",
        "SelectedTab": "",
        "AddtionalFilter": "",
        "LocationFilter": "",
        "UserID": strUserID,
        "SiteID": strSiteID,
        "OrgUnitID": strSiteID,
        "Locale": language,
        "groupBy": selectedGroupBy,
        "categories":
            selectedCategoryID == 0 ? selectedCategories : selectedCategoryID,
        "objecttypes": selectedObjectTypes,
        "skillcats": selectedSkillCats,
        "skills": "",
        "jobroles": selectedJobRoles,
        "solutions": "",
        "keywords": "",
        "ratings": selectedRating,
        "pricerange": selectedPriceRange,
        "eventdate": "",
        "certification": "",
        "duration": "",
        "instructors": selectedInstructor,
        //"learningprotals": "377,378",
        "learningprotals": learningPortals,
        "iswishlistcontent": 1,
        //"iswishlistcontent": isWishList ? 1 : ""
      };

      String body = json.encode(data);
       print(
          "getMobileMyCatalogObjectsPlusData  Body:${response?.body}");
      response = await RestClient.postMethodData(
          ApiEndpoints.getMobileCatalogObjectsDataURL(), body);
     
    } catch (e) {
      print(
          "Error in MyLearningRepositoryPublic.getMobileMyCatalogObjectsPlusData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getMenuComponents(int menuId, String menuUrl, int roleId) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......menu component response....${ApiEndpoints.getMenuComponents(strUserID, menuId.toString(), language,menuUrl,menuId.toString())}");

      response = await RestClient.getPostData(
          ApiEndpoints.getMenuComponents(strUserID, menuId.toString(), language,menuUrl,roleId.toString()));

      print('menu component response --- $response ');

    } catch (e) {
      print("repo Error $e");
    }
    return response;
  }
}
