import 'package:flutter/foundation.dart';
import 'package:flutter_admin_web/backend/classroom_events/classroom_events_isolats.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

@immutable
class ClassroomEventsRepository {
  const ClassroomEventsRepository();

  Future<dynamic> getPeopleTabList() async {
    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);

    dynamic response = await compute<List, dynamic>(getPeopleTabListComputeMethod, [
      ApiEndpoints.getPeopleTabList('153', '3497', strSiteID, language, strUserID),
      strUserID,
      strSiteID,
      ApiEndpoints.strSiteUrl,
      language,
      token,
    ]);

    MyPrint.printOnConsole("Response From getPeopleTabListComputeMethod:${response.runtimeType}");
    return response;
  }

  Future<dynamic> getTabContent({required String tabVal, required MyLearningBloc myLearningBloc, required int pageIndex, required String searchString,
    required String calenderSelecteddates,}) async {
    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);

    String additinalParameters = '';
    String sortBy = 'C.Name asc';
    if (tabVal == "myevents") {
      additinalParameters = "EventComponentID=153~FilterContentType=70~eventtype=" + tabVal + "~HideCompleteStatus=true" + "~EnableMyEvents=true";
    }
    else {
      additinalParameters = "EventComponentID=153~FilterContentType=70~eventtype=" + tabVal + "~HideCompleteStatus=true";
    }

    if (myLearningBloc.selectedSort.length > 0) {
      if (myLearningBloc.selectedSort == "MC.Name asc") {
        sortBy = 'C.Name asc';
      }
      else {
        sortBy = myLearningBloc.selectedSort;
      }
    }

    String selectedGroupby;
    String selectedcategories;
    String selectedobjectTypes;
    String selectedskillCats;
    String selectedjobRoles;
    //String selectedCredits;
    String selectedRating;
    String selectedinstructer;
    String selectedeventdate;

    selectedGroupby = myLearningBloc.selectedGroupby;
    selectedcategories = myLearningBloc.selectedcategories.length != 0 ? _formatString(myLearningBloc.selectedcategories) : "";
    selectedobjectTypes = myLearningBloc.selectedobjectTypes.length != 0 ? _formatString(myLearningBloc.selectedobjectTypes) : "";
    selectedskillCats = myLearningBloc.selectedskillCats.length != 0 ? _formatString(myLearningBloc.selectedskillCats) : "";
    selectedjobRoles = myLearningBloc.selectedjobRoles.length != 0 ? _formatString(myLearningBloc.selectedjobRoles) : "";
    selectedinstructer = myLearningBloc.selectedinstructer.length != 0 ? _formatString(myLearningBloc.selectedinstructer) : "";
    //selectedCredits = myLearningBloc.selectedCredits;
    selectedRating = myLearningBloc.selectedRating;
    selectedeventdate = myLearningBloc.selectedDuration;
    selectedinstructer = myLearningBloc.selectedinstructer.length != 0 ? _formatString(myLearningBloc.selectedinstructer) : "";

    String req = '';
    if (tabVal == 'calendar') {
      req = '{"pageIndex":1,"pageSize":100,"SearchText":"${searchString}","ContentID":"","sortBy":"","ComponentID":"153","ComponentInsID":"3497",'
          '"AdditionalParams":"$additinalParameters","SelectedTab":"",'
          '"AddtionalFilter":"","LocationFilter":"","UserID":"$strUserID","SiteID":"$strSiteID","OrgUnitID":"$strSiteID","Locale":"$language","groupBy":"",'
          '"categories":"","objecttypes":"","skillcats":"","skills":"","jobroles":"","solutions":"","keywords":"","ratings":"","pricerange":"",'
          '"eventdate":"${calenderSelecteddates}",'
          '"certification":"all","filtercredits":"","duration":"","instructors":"","iswishlistcontent":""}';
    }
    else {
      req = '{"pageIndex":${pageIndex},'
          '"pageSize":10,'
          '"SearchText":"${searchString}",'
          '"ContentID":"",'
          '"sortBy":"$sortBy",'
          '"ComponentID":"153",'
          '"ComponentInsID":"3497",'
          '"AdditionalParams":"$additinalParameters",'
          '"SelectedTab":"","AddtionalFilter":"","LocationFilter":"",'
          '"UserID":"$strUserID","SiteID":"$strSiteID","OrgUnitID":"$strSiteID","Locale":"$language","groupBy":"$selectedGroupby",'
          '"categories":"$selectedcategories","objecttypes":"$selectedobjectTypes","skillcats":"$selectedskillCats","skills":"","jobroles":"$selectedjobRoles",'
          '"solutions":"","keywords":"","ratings":"$selectedRating","pricerange":"",'
          '"eventdate":"$selectedeventdate","certification":"all","filtercredits":"",'
          '"duration":"","instructors":"$selectedinstructer","iswishlistcontent":0}';
    }

    print('reqvalll $req');

    dynamic response = await compute<List, dynamic>(getTabContentComputeMethod, [
      ApiEndpoints.getMobileCatalogObjectsDataURL(),
      strUserID,
      strSiteID,
      ApiEndpoints.strSiteUrl,
      language,
      token,
      req,
    ]);

    MyPrint.printOnConsole("Response From getTabContentComputeMethod:${response.runtimeType}");
    return response;
  }

  String _formatString(List x) {
    String formatted = '';
    for (var i in x) {
      formatted += '$i, ';
    }
    return formatted.replaceRange(formatted.length - 2, formatted.length, '');
  }
}