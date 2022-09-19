import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_admin_web/backend/classroom_events/classroom_events_isolats.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:http/http.dart';

import '../../configs/app_status_codes.dart';
import '../../configs/app_strings.dart';
import '../../framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import '../../framework/dataprovider/providers/rest_client.dart';
import '../../framework/repository/event_module/model/event_recording_resonse.dart';
import '../../framework/repository/event_module/model/expiry_events.dart';
import '../../framework/repository/event_module/model/people_listing_tab.dart';
import '../../framework/repository/event_module/model/session_event_response.dart';
import '../../framework/repository/event_module/model/waiting_list_response.dart';
import '../../framework/repository/event_module/model/waitinglist_request.dart';
import '../../models/api_response_model.dart';
import '../../models/app_error_model.dart';

@immutable
class ClassroomEventsRepository {
  const ClassroomEventsRepository();

  Future<ApiResponseModel<List<GetPeopleTabListResponse>>> getPeopleTabList() async {
    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);

    ApiResponseModel<List<GetPeopleTabListResponse>> response = await compute<List, ApiResponseModel<List<GetPeopleTabListResponse>>>(ClassroomEventsIsolates.getPeopleTabListComputeMethod, [
      ApiEndpoints.getPeopleTabList('153', '3497', strSiteID, language, strUserID),
      strUserID,
      strSiteID,
      ApiEndpoints.strSiteUrl,
      language,
      token,
    ]);

    MyPrint.printOnConsole("Response From getPeopleTabListComputeMethod:$response");
    return response;
  }

  Future<ApiResponseModel<EventRecordingResponse>> viewRecording({required String contentId}) async {
    Response? response;

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      response = await RestClient.getPostData(ApiEndpoints.eventRecording(contentId, strUserID.toString()));

      print('getoverviewUrl_cancelenroll $response');

      if(response != null) {
        if(response.statusCode == AppApiStatusCodes.SUCCESS) {
          EventRecordingResponse recordingResponse = eventRecordingResponseFromJson(response.body);
          return ApiResponseModel<EventRecordingResponse>(
            data: recordingResponse,
          );
        }
        else if(response.statusCode == 401) {
          return ApiResponseModel<EventRecordingResponse>(
            appErrorModel: AppErrorModel(
              message: AppStrings.token_expired,
              code: 401,
            ),
          );
        }
        else {
          return ApiResponseModel<EventRecordingResponse>(
            appErrorModel: AppErrorModel(
              message: AppStrings.error_in_api_call,
            ),
          );
        }
      }
      else {
        return ApiResponseModel<EventRecordingResponse>(
          appErrorModel: AppErrorModel(
            message: AppStrings.error_in_api_call,
          ),
        );
      }
    }
    on Exception catch (e, s) {
      print("Error Exception in ClassroomEventsRepository.viewRecording():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<EventRecordingResponse>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          exception: e,
          stackTrace: s,
        ),
      );
    }
    catch(e, s) {
      print("Error in ClassroomEventsRepository.viewRecording():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<EventRecordingResponse>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          stackTrace: s,
        ),
      );
    }
  }

  Future<ApiResponseModel<DummyMyCatelogResponseEntity>> getTabContent({required String tabVal, required MyLearningBloc myLearningBloc, required int pageIndex, required String searchString,
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
      req = '{"pageIndex":1,"pageSize":100,"SearchText":"$searchString","ContentID":"","sortBy":"","ComponentID":"153","ComponentInsID":"3497",'
          '"AdditionalParams":"$additinalParameters","SelectedTab":"",'
          '"AddtionalFilter":"","LocationFilter":"","UserID":"$strUserID","SiteID":"$strSiteID","OrgUnitID":"$strSiteID","Locale":"$language","groupBy":"",'
          '"categories":"","objecttypes":"","skillcats":"","skills":"","jobroles":"","solutions":"","keywords":"","ratings":"","pricerange":"",'
          '"eventdate":"$calenderSelecteddates",'
          '"certification":"all","filtercredits":"","duration":"","instructors":"","iswishlistcontent":""}';
    }
    else {
      req = '{"pageIndex":$pageIndex,'
          '"pageSize":10,'
          '"SearchText":"$searchString",'
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

    ApiResponseModel<DummyMyCatelogResponseEntity> response = await compute<List, ApiResponseModel<DummyMyCatelogResponseEntity>>(ClassroomEventsIsolates.getTabContentComputeMethod, [
      ApiEndpoints.getMobileCatalogObjectsDataURL(),
      strUserID,
      strSiteID,
      ApiEndpoints.strSiteUrl,
      language,
      token,
      req,
    ]);

    MyPrint.printOnConsole("Response From getTabContentComputeMethod:$response");
    return response;
  }

  Future<ApiResponseModel<bool>> downloadComplete({required String contentId, required int scoID}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map data = {
        "UserID": strUserID,
        "ContentID": contentId,
        "ScoID": scoID,
      };

      String body = json.encode(data);
      response = await RestClient.postMethodData(ApiEndpoints.GetUpdateDownloadCompleteStatus(), body);

      if(response != null) {
        if(response.statusCode == AppApiStatusCodes.SUCCESS) {
          return ApiResponseModel<bool>(
            data: true,
          );
        }
        else if(response.statusCode == 401) {
          return ApiResponseModel<bool>(
            appErrorModel: AppErrorModel(
              message: AppStrings.token_expired,
              code: 401,
            ),
          );
        }
        else {
          return ApiResponseModel<bool>(
            appErrorModel: AppErrorModel(
              message: AppStrings.error_in_api_call,
            ),
          );
        }
      }
      else {
        return ApiResponseModel<bool>(
          appErrorModel: AppErrorModel(
            message: AppStrings.error_in_api_call,
          ),
        );
      }
    }
    on Exception catch (e, s) {
      print("Error Exception in ClassroomEventsRepository.downloadCompleteInfo():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<bool>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          exception: e,
          stackTrace: s,
        ),
      );
    }
    catch(e, s) {
      print("Error in ClassroomEventsRepository.downloadCompleteInfo():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<bool>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          stackTrace: s,
        ),
      );
    }
  }

  Future<ApiResponseModel<DummyMyCatelogResponseEntity>> getWishlistContent({required String tabVal}) async {
    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);


    String additinalParameters = '';
    //String sortBy = 'C.Name asc';
    if (tabVal == "myevents") {
      additinalParameters = "EventComponentID=153~FilterContentType=70~eventtype=" + tabVal + "~HideCompleteStatus=true" + "~EnableMyEvents=true";
    }
    else {
      additinalParameters = "EventComponentID=153~FilterContentType=70~eventtype=" + tabVal + "~HideCompleteStatus=true";
    }

    //sortBy = 'C.Name asc';

    String req = '';
    if (tabVal == 'calendar') {
      req =
          '{"pageIndex":1,"pageSize":100,"SearchText":"","ContentID":"","sortBy":"","ComponentID":"153","ComponentInsID":"3497",'
          '"AdditionalParams":"$additinalParameters","SelectedTab":"",'
          '"AddtionalFilter":"","LocationFilter":"","UserID":"$strUserID","SiteID":"$strSiteID","OrgUnitID":"$strSiteID","Locale":"$language","groupBy":"",'
          '"categories":"","objecttypes":"","skillcats":"","skills":"","jobroles":"","solutions":"","keywords":"","ratings":"","pricerange":"",'
          '"eventdate":"2020-09-01 12:00:00~2020-09-30 00:00:00",'
          '"certification":"all","filtercredits":"","duration":"","instructors":"","iswishlistcontent":""}';
    }
    else {
      req =
          '{"pageIndex":1,"pageSize":100,"SearchText":"","ContentID":"","sortBy":"","ComponentID":"153","ComponentInsID":"3497",'
          '"AdditionalParams":"$additinalParameters","SelectedTab":"",'
          '"AddtionalFilter":"","LocationFilter":"","UserID":"$strUserID","SiteID":"$strSiteID","OrgUnitID":"$strSiteID","Locale":"$language","groupBy":"",'
          '"categories":"","objecttypes":"","skillcats":"","skills":"","jobroles":"","solutions":"","keywords":"","ratings":"","pricerange":"",'
          '"eventdate":"",'
          '"certification":"all","filtercredits":"","duration":"","instructors":"","iswishlistcontent":"1"}';
    }

    print('reqvalll $req');

    ApiResponseModel<DummyMyCatelogResponseEntity> response = await compute<List, ApiResponseModel<DummyMyCatelogResponseEntity>>(ClassroomEventsIsolates.getTabContentComputeMethod, [
      ApiEndpoints.getMobileCatalogObjectsDataURL(),
      strUserID,
      strSiteID,
      ApiEndpoints.strSiteUrl,
      language,
      token,
      req,
    ]);

    MyPrint.printOnConsole("Response From getTabContentComputeMethod:$response");
    return response;
  }

  Future<ApiResponseModel<List<CourseList>>> getEventSessionCoursesList({required String contentId}) async {
    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);

    ApiResponseModel<List<CourseList>> response = await compute<List, dynamic>(ClassroomEventsIsolates.getEventSessionCourseListComputeMethod, [
      ApiEndpoints.getEventSessionData(contentId, strUserID, strSiteID, language),
      strUserID,
      strSiteID,
      ApiEndpoints.strSiteUrl,
      language,
      token,
    ]);

    MyPrint.printOnConsole("Response From getEventSessionCoursesList:$response");
    return response;
  }

  Future<ApiResponseModel<bool>> cancelEventEnrollment({required String contentId}) async {
    Response? response;
    try {
      var strSiteId = await sharePrefGetString(sharedPref_siteid);

      response = await RestClient.getPostData(ApiEndpoints.badCancelEnrollment(contentId, strSiteId));

      if(response != null) {
        if(response.statusCode == AppApiStatusCodes.SUCCESS) {
          return ApiResponseModel<bool>(
            data: response.body.toLowerCase().contains("true"),
          );
        }
        else if(response.statusCode == 401) {
          return ApiResponseModel<bool>(
            appErrorModel: AppErrorModel(
              message: AppStrings.token_expired,
              code: 401,
            ),
          );
        }
        else {
          return ApiResponseModel<bool>(
            appErrorModel: AppErrorModel(
              message: AppStrings.error_in_api_call,
            ),
          );
        }
      }
      else {
        return ApiResponseModel<bool>(
          appErrorModel: AppErrorModel(
            message: AppStrings.error_in_api_call,
          ),
        );
      }
    }
    on Exception catch (e, s) {
      print("Error Exception in ClassroomEventsRepository.cancelEventEnrollment():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<bool>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          exception: e,
          stackTrace: s,
        ),
      );
    }
    catch(e, s) {
      print("Error in ClassroomEventsRepository.cancelEventEnrollment():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<bool>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          stackTrace: s,
        ),
      );
    }
  }

  Future<ApiResponseModel<bool>> cancelTrackEventEnrollment({required String contentId, required String isBadCancel}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteId = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      response = await RestClient.getPostData(ApiEndpoints.cancelEnroll(contentId, strUserID.toString(), isBadCancel, language, strSiteId));

      if(response != null) {
        if(response.statusCode == AppApiStatusCodes.SUCCESS) {
          return ApiResponseModel<bool>(
            data: response.body.toLowerCase().contains("true"),
          );
        }
        else if(response.statusCode == 401) {
          return ApiResponseModel<bool>(
            appErrorModel: AppErrorModel(
              message: AppStrings.token_expired,
              code: 401,
            ),
          );
        }
        else {
          return ApiResponseModel<bool>(
            appErrorModel: AppErrorModel(
              message: AppStrings.error_in_api_call,
            ),
          );
        }
      }
      else {
        return ApiResponseModel<bool>(
          appErrorModel: AppErrorModel(
            message: AppStrings.error_in_api_call,
          ),
        );
      }
    }
    on Exception catch (e, s) {
      print("Error Exception in ClassroomEventsRepository.cancelTrackEventEnrollment():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<bool>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          exception: e,
          stackTrace: s,
        ),
      );
    }
    catch(e, s) {
      print("Error in ClassroomEventsRepository.cancelTrackEventEnrollment():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<bool>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          stackTrace: s,
        ),
      );
    }
  }

  Future<ApiResponseModel<bool>> addExpiryEvents({required String strContentID}) async {
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

      if(response != null) {
        if(response.statusCode == AppApiStatusCodes.SUCCESS) {
          return ApiResponseModel<bool>(
            data: response.body.toLowerCase().contains("true"),
          );
        }
        else if(response.statusCode == 401) {
          return ApiResponseModel<bool>(
            appErrorModel: AppErrorModel(
              message: AppStrings.token_expired,
              code: 401,
            ),
          );
        }
        else {
          return ApiResponseModel<bool>(
            appErrorModel: AppErrorModel(
              message: AppStrings.error_in_api_call,
            ),
          );
        }
      }
      else {
        return ApiResponseModel<bool>(
          appErrorModel: AppErrorModel(
            message: AppStrings.error_in_api_call,
          ),
        );
      }
    }
    on Exception catch (e, s) {
      print("Error Exception in ClassroomEventsRepository.expiryEvents():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<bool>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          exception: e,
          stackTrace: s,
        ),
      );
    }
    catch(e, s) {
      print("Error in ClassroomEventsRepository.expiryEvents():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<bool>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          stackTrace: s,
        ),
      );
    }
  }

  Future<ApiResponseModel<WaitingListResponse>> waitingList({required String strContentID}) async {
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

      if(response != null) {
        if(response.statusCode == AppApiStatusCodes.SUCCESS) {
          WaitingListResponse waitingListResponse = waitingListResponseFromJson(response.body);
          return ApiResponseModel<WaitingListResponse>(
            data: waitingListResponse,
          );
        }
        else if(response.statusCode == 401) {
          return ApiResponseModel<WaitingListResponse>(
            appErrorModel: AppErrorModel(
              message: AppStrings.token_expired,
              code: 401,
            ),
          );
        }
        else {
          return ApiResponseModel<WaitingListResponse>(
            appErrorModel: AppErrorModel(
              message: AppStrings.error_in_api_call,
            ),
          );
        }
      }
      else {
        return ApiResponseModel<WaitingListResponse>(
          appErrorModel: AppErrorModel(
            message: AppStrings.error_in_api_call,
          ),
        );
      }
    }
    on Exception catch (e, s) {
      print("Error Exception in ClassroomEventsRepository.expiryEvents():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<WaitingListResponse>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          exception: e,
          stackTrace: s,
        ),
      );
    }
    catch(e, s) {
      print("Error in ClassroomEventsRepository.expiryEvents():$e");
      MyPrint.printOnConsole(s);

      return ApiResponseModel<WaitingListResponse>(
        appErrorModel: AppErrorModel(
          message: AppStrings.error_in_api_call,
          stackTrace: s,
        ),
      );
    }
  }

  String _formatString(List x) {
    String formatted = '';
    for (var i in x) {
      formatted += '$i, ';
    }
    return formatted.replaceRange(formatted.length - 2, formatted.length, '');
  }
}