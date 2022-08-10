import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/people_list_request.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';

import 'myConnection_repository_builder.dart';

class MyConnectionRepositoryPublic extends MyConnectionRepository {
  @override
  Future<Response?> getPeopleListResponseEvent(
      {int componentID = 0,
      int componentInstanceID = 0,
      int userID = 0,
      int siteID = 0,
      String locale = "",
      String sortBy = "",
      String sortType = "",
      int pageIndex = 0,
      int pageSize = 0,
      String filterType = "",
      String tabID = "",
      String searchText = "",
      String contentId = "",
      String location = "",
      String company = "",
      String skillLevels = "",
      String firstname = "",
      String lastname = "",
      String skillCats = "",
      String skills = "",
      String jobRoles = ""}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print("......PeopleList....${ApiEndpoints.getPeopleList()}");

      PeopleListRequest peopleListParam = new PeopleListRequest();
      peopleListParam.componentId = componentID;
      peopleListParam.componentInstanceId = componentInstanceID;
      peopleListParam.userId = strUserID;
      peopleListParam.siteId = strSiteID;
      peopleListParam.locale = language;
      peopleListParam.sortBy = sortBy;
      peopleListParam.sortType = sortType;
      peopleListParam.pageIndex = pageIndex;
      peopleListParam.pageSize = pageSize;
      peopleListParam.filterType = filterType;
      peopleListParam.tabId = tabID;
      peopleListParam.searchText = searchText;
      peopleListParam.contentid = contentId;
      peopleListParam.location = location;
      peopleListParam.company = company;
      peopleListParam.skilllevels = skillLevels;
      peopleListParam.firstname = firstname;
      peopleListParam.lastname = lastname;
      peopleListParam.skillcats = skillCats;
      peopleListParam.skills = skills;
      peopleListParam.jobroles = jobRoles;

      dynamic data = Map.from(peopleListParam.toJson());
      print(data);
      response = await RestClient.postApiData(ApiEndpoints.getPeopleList(), data);
    }
    catch (e) {
      print("Error in MyConnectionRepositoryPublic.getPeopleListResponseEvent():$e");
    }
    return response;
  }

  @override
  Future<Response?> addConnectionResponseEvent(
      {int selectedObjectID = 0,
      String selectAction = "",
      String userName = "",
      int mainSiteUserID = 0}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......PeopleListingAction....${ApiEndpoints.peopleListingAction()}");

      var data = {
        'SelectedObjectID': selectedObjectID,
        'SelectAction': selectAction,
        'UserName': userName,
        'UserID': strUserID,
        'MainSiteUserID': strUserID,
        'SiteID': strSiteID,
        'Locale': language
      };
      print('Post Data of people list' + data.toString());
      response = await RestClient.postApiData(ApiEndpoints.peopleListingAction(), data);
    } catch (e) {
      print(
          "Error in MyConnectionRepositoryPublic.addConnectionResponseEvent():$e");
    }
    return response;
  }

  @override
  Future<Response?> getDynamicTabEvent() async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......DynamicTabs....${ApiEndpoints.getDynamicTabs(strUserID, strSiteID, language)}");

      response = await RestClient.getPostData(
          ApiEndpoints.getDynamicTabs(strUserID, strSiteID, language));
    } catch (e) {
      print("Error in MyConnectionRepositoryPublic.getDynamicTabEvent():$e");
    }
    return response;
  }
}
