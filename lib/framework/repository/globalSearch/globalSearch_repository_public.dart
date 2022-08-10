import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/model/search_component_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';

import 'globalSearch_repository_builder.dart';

class GlobalSearchRepositoryPublic extends GlobalSearchRepository {
  @override
  Future<Response?> getSearchComponentListEvent() async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......GetSearchComponentList....${ApiEndpoints.getSearchComponentList(strUserID, strSiteID, language)}");

      response = await RestClient.getPostData(
          ApiEndpoints.getSearchComponentList(strUserID, strSiteID, language));

      print("......GetSearchComponentList.... Response:${response?.body}");
    } catch (e) {
      print(
          "Error in GlobalSearchRepositoryPublic.getSearchComponentListEvent():$e");
    }
    return response;
  }

  @override
  Future<Response?> getGlobalSearchResultsEvent(
      {int pageIndex = 0,
      int pageSize = 0,
      String searchStr = "",
      int source = 0,
      int type = 0,
      String fType = "",
      String fValue = "",
      String sortBy = "",
      String sortType = "",
      String keywords = "",
      String authorID = "",
      String groupBy = "",
      int userID = 0,
      int siteID = 0,
      int orgUnitId = 0,
      String locale = "",
      int componentId = 0,
      int componentInsId = 0,
      String multiLocation = "",
      int objComponentList = 0,
      int componentSiteID = 0,
      SearchComponent? searchComponent}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......GetGlobalSearchResults....${ApiEndpoints.getGlobalSearchResults(pageIndex, searchStr, strUserID, strSiteID, language, componentId.toString(), componentInsId.toString(), componentSiteID.toString(), fType, fValue)}");

      response = await RestClient.getPostData(
          ApiEndpoints.getGlobalSearchResults(
              pageIndex,
              searchStr,
              strUserID,
              strSiteID,
              language,
              componentId.toString(),
              componentInsId.toString(),
              componentSiteID.toString(),
              fType,
              fValue));
    } catch (e) {
      print(
          "Error in GlobalSearchRepositoryPublic.getSearchComponentListEvent():$e");
    }
    return response;
  }
}
