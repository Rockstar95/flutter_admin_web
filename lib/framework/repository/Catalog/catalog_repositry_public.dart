import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/contract/catalog_repositry.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/auth_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
import 'package:intl/intl.dart';

class CatalogRepositoryPublic extends CatalogRepository {
  @override
  Future<Response?> getCategoryForBrowse() async {
    // TODO: implement getCategoryForBrowse

    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      String urlStr =
          "${ApiEndpoints.getCategoryForBrowseURL()}strType=cat&intComponentID=1&intSiteID=$strSiteID&intUserID=$strUserID&Locale=$language";
      print("getCategoryForBrowseURL $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print("repo Error $e");
    }

    return response;
  }

  @override
  Future<Response?> getMobileMyCatalogObjectsData(
      int pageIndex,
      int selectedcategaoryID,
      String searchTxt,
      bool isWishList,
      String selectedSort,
      String selectedGroupBy,
      String selectedcategories,
      String selectedobjectTypes,
      String selectedskillCats,
      String selectedjobRoles,
      String selectedCredits,
      String selectedinstructer,
      String selectedrating,
      String learningprotals,
      String type,
      String selectedPriceRange,
      String compid,
      String compinsid) async {
    // TODO: implement getMobileMyCatalogObjectsData
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
        "ComponentID": type == 'plus' ? compid : strComponentID,
        "ComponentInsID": type == 'plus' ? compinsid : strRepositoryId,
        "AdditionalParams": "",
        "SelectedTab": "",
        "AddtionalFilter": "",
        "LocationFilter": "",
        "UserID": strUserID,
        "SiteID": strSiteID,
        "OrgUnitID": strSiteID,
        "Locale": language,
        "groupBy": selectedGroupBy,
        "categories":
            selectedcategaoryID == 0 ? selectedcategories : selectedcategaoryID,
        "objecttypes": selectedobjectTypes,
        "skillcats": selectedskillCats,
        "skills": "",
        "jobroles": selectedjobRoles,
        "solutions": "",
        "keywords": "",
        "ratings": selectedrating,
        "pricerange": selectedPriceRange,
        "eventdate": "",
        "certification": "",
        "duration": "",
        "instructors": selectedinstructer,
        //"learningprotals": "377,378",
        "learningprotals": learningprotals,
        "iswishlistcontent": isWishList ? 1 : ""
      };

      String body = json.encode(data);
      response = await RestClient.postMethodData(
          ApiEndpoints.getMobileCatalogObjectsDataURL(), body);
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> addToWishList(String contentId) async {
    // TODO: implement addToWishList
    Response? response;
    try {
      print(
          "......catalog....${ApiEndpoints.getMobileCatalogObjectsDataURL()}");

      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strComponentID = await sharePrefGetString(sharedPref_ComponentID);
      var strRepositoryId = await sharePrefGetString(sharedPref_RepositoryId);
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final String dateString = formatter.format(now);

      Map data = {
        "ContentID": contentId,
        "AddedDate": dateString,
        "UserID": strUserID,
        "ComponentID": strComponentID,
        "ComponentInstanceID": strRepositoryId,
      };

      String body = json.encode(data);
      response =
          await RestClient.postMethodData(ApiEndpoints.AddtoWishList(), body);

      print("Add to wish response ${response?.body}");
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> removeFromWishList(String contentId) async {
    // TODO: implement removeFromWishList
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      String urlStr =
          "${ApiEndpoints.RemoveWishListURl()}ContentID=$contentId&instUserID=$strUserID";
      print("RemoveWishListURl $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> doSubSiteLogin(String username, String password,
      String mobileSiteUrl, String downloadContent, String siteId) async {
    // TODO: implement doSubSiteLogin
    try {
      Login login = Login();
      login.userName = username;
      login.password = password;
      login.mobileSiteUrl = mobileSiteUrl;
      login.downloadContent = downloadContent;
      login.siteId = siteId;
      login.isFromSignUp = false;

      var data = loginToJson(login);
      print('login req $data');

      Response? response =
          await RestClient.postData(ApiEndpoints.apiLogin(), data);
      print('MyResponse $response');
      if (response?.statusCode == 200) {
        if ((response?.body ?? "{}").contains('successfulluserlogin')) {
          // SubsiteLoginResponse subsiteLoginResponse =
          //     loginResponseFromJson(response.toString());
          // await sharePref_saveString(
          //     sharedPref_image, loginResponse.successFullUserLogin[0].image);
          // await sharePref_saveString(sharedPref_userid,
          //     loginResponse.successFullUserLogin[0].userid.toString());
          // await sharePref_saveString(sharedPref_bearer,
          //     loginResponse.successFullUserLogin[0].jwttoken.toString());
          // await sharePref_saveString(sharedPref_LoginUserName,
          //     loginResponse.successFullUserLogin[0].username);
          // await sharePref_saveString(sharedPref_LoginPassword, password);
          // await sharePref_saveString(sharedPref_LoginUserID, username);
          // await sharePref_saveString(sharedPref_tempProfileImage,
          //     '${ApiEndpoints.strSiteUrl}/Content/SiteFiles/374/ProfileImages/${loginResponse.successFullUserLogin[0].image}');
          // print('bindedresposne $subsiteLoginResponse');
        } else {}
      } else {}

      return response;
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
      return null;
    }
  }

  @override
  Future<Response?> getFileUploadControls(
      String siteId, String localeId, String compInsId) async {
    // TODO: implement getFileUploadControls
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      String urlStr =
          "${ApiEndpoints.GetFileUploadControls(localeId, siteId, compInsId)}";
      print("GetFileUploadControls $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getScheduleData(
      {String eventID = "",
      String multiInstanceEventEnroll = "",
      String multiLocation = ""}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print("getScheduleData Event Id:$eventID");
      Map<String, dynamic> scheduleDataRequest = {
        'EventID': eventID,
        'LocalID': language,
        'UserID': int.parse(strUserID),
        'SiteID': int.parse(strSiteID),
        'multiInstanceEventEnroll': multiInstanceEventEnroll,
        'MultiLocation': multiLocation,
      };

      response = await RestClient.postMethodWithQueryParamData(ApiEndpoints.getScheduleData(), scheduleDataRequest);
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> addToEnrollContent(
      {String selectedContent = "",
      int orgUnitID = 0,
      int componentID = 0,
      int componentInsID = 0,
      String additionalParams = "",
      String targetDate = "",
      String rescheduleEnroll = ""}) async {
    // TODO: implement addToEnrollContent
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map data = {
        "SelectedContent": selectedContent,
        'UserID': int.parse(strUserID),
        "SiteID": strSiteID,
        "OrgUnitID": strSiteID,
        'Locale': strLanguage,
        "ComponentID": componentID,
        "ComponentInsID": componentInsID,
        'AdditionalParams': '',
        'TargetDate': '',
        'MultiInstanceEventEnroll': rescheduleEnroll
      };

      String body = json.encode(data);
      print('body $body');
      response = await RestClient.postMethodData(ApiEndpoints.addEnrollContent(), body);

      log("Add to learning response ${response?.body}");
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getPrerequisiteDetails(
      String contentID, String userID) async {
    // TODO: implement GetPrequisiteDetails
    Response? response;
    try {
      // var strUserID = await sharePref_getString(sharedPref_userid);
      String urlStr = ApiEndpoints.GetPrequisiteDetails(contentID, userID);
      print("GetPrequisiteDetails $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getAssociatedContent(
    String contentID,
    String componentID,
    String componentInstanceID,
    String instancedata,
    String preRequisiteSequncePathID,
  ) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      String urlStr = ApiEndpoints.getAssociatedContentApi(
          contentID,
          strUserID,
          componentID,
          componentInstanceID,
          strSiteID,
          instancedata,
          preRequisiteSequncePathID,
          strLanguage);
      print("getAssociatedContent $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getCatalogDetails(MyLearningDetailsRequest request) async {
    Response? response;

    String data = myLearningDetailsRequestToJson(request);

    print('detailrequest $data');

    try {
      response = await RestClient.postMethodData(
          ApiEndpoints.getMyLearningDetails, data);
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> saveInAppPurchaseDetails(
      String userId,
      String siteURl,
      String contentID,
      String orderId,
      String purchaseToken,
      String productId,
      String purchaseTime,
      String deviceType) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      String urlStr = ApiEndpoints.mobileSaveInAppPurchaseDetails(
          strUserID,
          siteURl,
          contentID,
          orderId,
          purchaseToken,
          productId,
          purchaseTime,
          deviceType);
      print("getAssociatedContent $urlStr");
      response = await RestClient.getPostData(urlStr);
    } catch (e) {
      print(
          "Error in CatalogRepositoryPublic.getMobileMyCatalogObjectsData():$e");
    }

    return response;
  }

  @override
  Future<Response?> associatedAddToMyLearning(
      {String selectedContent = "",
      String componentID = "",
      String componentInsID = "",
      String additionalParams = "",
      String addLearnerPreRequisiteContent = "",
      String addMultiInstancesWithPrice = "",
      String addWaitListContentIDs = "",
      String multiInstanceEventEnroll = ""}) async {
    // TODO: implement associatedAddToMyLearning
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map data = {
        "SelectedContent": selectedContent,
        'UserID': int.parse(strUserID),
        "SiteID": strSiteID,
        "OrgUnitID": strSiteID,
        'Locale': strLanguage,
        "ComponentID": componentID,
        "ComponentInsID": componentInsID,
        'AdditionalParams': '',
        'AddLearnerPreRequisiteContent': '',
        'MultiInstanceEventEnroll': '',
        'AddMultiinstanceswithprice': '',
        'AddWaitlistContentIDs': ''
      };

      String body = json.encode(data);
      print('body $body');
      response = await RestClient.postMethodData(
          ApiEndpoints.associatedAddtoMyLearning(), body);
    } catch (e) {
      print("repo Error $e");
    }

    print('response $response');

    return response;
  }
}
