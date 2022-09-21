import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/event_module/contract/event_module_repository.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/event_recording_resonse.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/people_listing_tab.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/session_event_response.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/waiting_list_response.dart';
import 'package:flutter_admin_web/generated/json/dummy_my_catelog_response_entity_helper.dart';

import '../../../../ui/common/log_util.dart';
import '../../../../utils/my_print.dart';

class EvntModuleBloc extends Bloc<EvntModuleEvent, EvntModuleState> {
  List<GetPeopleTabListResponse> tabList = [];

  List<DummyMyCatelogResponseTable2> list = [];
  List<DummyMyCatelogResponseTable2> calanderFilterList = [];
  List<DummyMyCatelogResponseTable2> eventWishlist = [];
  bool isFirstLoading = true;
  bool isEventSearch = false;
  String searchEventString = "";
  int listTotalCount = 0;
  List<CourseList> sessionCourseList = [];

  String calenderSelecteddates = "";

  EventModuleRepository eventModuleRepository;

  EvntModuleBloc({
    required this.eventModuleRepository,
  })  : assert(eventModuleRepository != null),
        super(EvntModuleState.completed(null)) {
    on<GetPeopleListingTab>(onEventHandler);
    on<GetTabContent>(onEventHandler);
    on<GetEventWishlistContent>(onEventHandler);
    on<GetCalanderFilterListContent>(onEventHandler);
    on<EventSession>(onEventHandler);
    on<BadCancelEnrollment>(onEventHandler);
    on<TrackCancelEnrollment>(onEventHandler);
    on<AddExpiryEvent>(onEventHandler);
    on<WaitingListEvent>(onEventHandler);
    on<ViewRecordingEvent>(onEventHandler);
    on<DownloadCompleteEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(EvntModuleEvent event, Emitter emit) async {
    print("EvntModuleBloc onEventHandler called for ${event.runtimeType}");
    Stream<EvntModuleState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (EvntModuleState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  EvntModuleState get initialState =>
      InitialEventState.completed('Intitalized');

  @override
  Stream<EvntModuleState> mapEventToState(event) async* {
    try {
      if (event is GetPeopleListingTab) {
        yield GetPeopleListingTabState.loading('Please wait');

        Response? response = await eventModuleRepository.getPeopleTabList();

        print('tabresponse ${response?.body}');
        if (response?.statusCode == 200) {
          String data = response?.body ?? "[]";
          tabList = getPeopleTabListResponseFromJson(data);

          yield GetPeopleListingTabState.completed(isSucces: true);
        }
        else if (response?.statusCode == 401) {
          yield GetPeopleListingTabState.error('401');
        }
        else {
          yield GetPeopleListingTabState.error('Something went wrong');
        }
      }
      else if (event is ViewRecordingEvent) {
        yield ViewRecordingState.loading('Please wait');

        Response? response =
            await eventModuleRepository.viewRecording(event.strContentID);

        print('ViewRecordingEvent ${response?.body}');
        if (response?.statusCode == 200) {
          EventRecordingResponse recordingResponse =
              eventRecordingResponseFromJson(response?.body ?? "{}");

          yield ViewRecordingState.completed(
              isSucces: true, eventRecordingResponse: recordingResponse);
        } else if (response?.statusCode == 401) {
          yield ViewRecordingState.error('401');
        }
        else {
          yield ViewRecordingState.error('Something went wrong');
        }
      }
      else if (event is GetTabContent) {
        if (isFirstLoading || event.searchString.length > 0) {
          list.clear();
          listTotalCount = 0;
        }
        calanderFilterList.clear();
        var strUserID = await sharePrefGetString(sharedPref_userid);
        var strSiteID = await sharePrefGetString(sharedPref_siteid);
        var language = await sharePrefGetString(sharedPref_AppLocale);

        String additinalParameters = '';
        String sortBy = 'C.Name asc';
        if (event.tabVal == "myevents") {
          additinalParameters =
              "EventComponentID=153~FilterContentType=70~eventtype=" +
                  event.tabVal +
                  "~HideCompleteStatus=true" +
                  "~EnableMyEvents=true";
        } else {
          additinalParameters =
              "EventComponentID=153~FilterContentType=70~eventtype=" +
                  event.tabVal +
                  "~HideCompleteStatus=true";
        }

        if (event.myLearningBloc.selectedSort.length > 0) {
          if (event.myLearningBloc.selectedSort == "MC.Name asc") {
            sortBy = 'C.Name asc';
          } else {
            sortBy = event.myLearningBloc.selectedSort;
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

        selectedGroupby = event.myLearningBloc.selectedGroupby;
        selectedcategories = event.myLearningBloc.selectedcategories.length != 0
            ? formatString(event.myLearningBloc.selectedcategories)
            : "";
        selectedobjectTypes =
            event.myLearningBloc.selectedobjectTypes.length != 0
                ? formatString(event.myLearningBloc.selectedobjectTypes)
                : "";
        selectedskillCats = event.myLearningBloc.selectedskillCats.length != 0
            ? formatString(event.myLearningBloc.selectedskillCats)
            : "";
        selectedjobRoles = event.myLearningBloc.selectedjobRoles.length != 0
            ? formatString(event.myLearningBloc.selectedjobRoles)
            : "";
        selectedinstructer = event.myLearningBloc.selectedinstructer.length != 0
            ? formatString(event.myLearningBloc.selectedinstructer)
            : "";
        //selectedCredits = event.myLearningBloc.selectedCredits;
        selectedRating = event.myLearningBloc.selectedRating;
        selectedeventdate = event.myLearningBloc.selectedDuration;
        selectedinstructer = event.myLearningBloc.selectedinstructer.length != 0
            ? formatString(event.myLearningBloc.selectedinstructer)
            : "";

//        String eventDate = "";
//        if (applyFilterModel.firstName.length() > 0) {
//          eventDate = applyFilterModel.firstName;
//        }
//        if (applyFilterModel.lastName.length() > 0) {
//          if (eventDate.length() > 0) {
//            eventDate = eventDate.concat("~" + applyFilterModel.lastName);
//          }
//        }

//        GetContentTabRequest req = GetContentTabRequest();
//        req.siteId = '374';
        String req = '';
        if (event.tabVal == 'calendar') {
          req =
              '{"pageIndex":1,"pageSize":100,"SearchText":"${event.searchString}","ContentID":"","sortBy":"","ComponentID":"153","ComponentInsID":"3497",'
              '"AdditionalParams":"$additinalParameters","SelectedTab":"",'
              '"AddtionalFilter":"","LocationFilter":"","UserID":"$strUserID","SiteID":"$strSiteID","OrgUnitID":"$strSiteID","Locale":"$language","groupBy":"",'
              '"categories":"","objecttypes":"","skillcats":"","skills":"","jobroles":"","solutions":"","keywords":"","ratings":"","pricerange":"",'
              '"eventdate":"$calenderSelecteddates",'
              '"certification":"all","filtercredits":"","duration":"","instructors":"","iswishlistcontent":""}';
        }
        else {
          req = '{"pageIndex":${event.pageIndex},'
              '"pageSize":10,'
              '"SearchText":"${event.searchString}",'
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

        yield GetTabContentState.loading('Please wait');

        print('reqvalll $req');

        Response? response = await eventModuleRepository.getTabContent(req);

        print('upcomingresponse ${response?.body}');

        if (response?.statusCode == 200) {
          isFirstLoading = false;
          DummyMyCatelogResponseEntity myCatelogResponseEntity = DummyMyCatelogResponseEntity();
          Map valueMap = json.decode(response?.body ?? "{}");
          myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(myCatelogResponseEntity, Map.castFrom(valueMap));

          print("totalrecordscount ${myCatelogResponseEntity.table[0].totalrecordscount}");
          listTotalCount = myCatelogResponseEntity.table[0].totalrecordscount;
          print("myCatelogResponseEntitytable 2 size ${myCatelogResponseEntity.table2.length}");
          if (/*event.tabVal == 'calendar' && myCatelogResponseEntity.table2.length == 0 && */event.pageIndex == 1) {
            list = [];
          }
          myCatelogResponseEntity.table2.forEach((DummyMyCatelogResponseTable2 element) {
            print("In Bloc Id:${element.contentid}, isWishlist:${element.iswishlistcontent}");

            list.add(element);
            calanderFilterList.add(element);
            setImageData(list);
            setImageData(calanderFilterList);
          });
          yield GetTabContentState.completed(isSucces: true);
        }
        else if (response?.statusCode == 401) {
          yield GetTabContentState.error('401');
        }
        else {
          yield GetTabContentState.error('Something went wrong');
        }
      }
      else if (event is DownloadCompleteEvent) {
        try {
          Response? response = await eventModuleRepository.downloadCompleteInfo(event.contentId, event.ScoID);

          print("Downloadcompleteinfo Response ${response?.body}");

          if (response?.statusCode == 200) {
            yield DownloadCompleteState.completed(isSucces: true);
          }
          else {
            print(response?.statusCode);
            yield DownloadCompleteState.error("${response?.statusCode}");
          }
        } catch (e, s) {
          print("Sagar sir log $e");
          print(s);
          yield DownloadCompleteState.error("Error  $e");
        }
      }
      else if (event is GetEventWishlistContent) {
        eventWishlist.clear();
        var strUserID = await sharePrefGetString(sharedPref_userid);
        var strSiteID = await sharePrefGetString(sharedPref_siteid);
        var language = await sharePrefGetString(sharedPref_AppLocale);

        String additinalParameters = '';
        //String sortBy = 'C.Name asc';
        if (event.tabVal == "myevents") {
          additinalParameters =
              "EventComponentID=153~FilterContentType=70~eventtype=" +
                  event.tabVal +
                  "~HideCompleteStatus=true" +
                  "~EnableMyEvents=true";
        }
        else {
          additinalParameters =
              "EventComponentID=153~FilterContentType=70~eventtype=" +
                  event.tabVal +
                  "~HideCompleteStatus=true";
        }

        //sortBy = 'C.Name asc';

        String req = '';
        if (event.tabVal == 'calendar') {
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

        yield GetTabContentState.loading('Please wait');

        print('reqvalll $req');

        Response? response = await eventModuleRepository.getTabContent(req);

        print('upcomingresponse ${response?.body}');

        if (response?.statusCode == 200) {
          DummyMyCatelogResponseEntity myCatelogResponseEntity =
              new DummyMyCatelogResponseEntity();
          Map valueMap = json.decode(response?.body ?? "{}");
          myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(
              myCatelogResponseEntity, Map.castFrom(valueMap));

          print("eventWishlist  size ${myCatelogResponseEntity.table2.length}");
          myCatelogResponseEntity.table2.forEach((element) {
            eventWishlist.add(element);
            setImageData(eventWishlist);
          });
          yield GetTabContentState.completed(isSucces: true);
        } else if (response?.statusCode == 401) {
          yield GetTabContentState.error('401');
        } else {
          yield GetTabContentState.error('Something went wrong');
        }
      }
      else if (event is EventSession) {
        yield GetSessionEventState.loading('Please wait');

        Response? response = await eventModuleRepository.getSessionList(event.contentid);

        if (response?.statusCode == 200) {
          SessionEventResponse sessionEventResponse = sessionEventResponseFromJson(response?.body ?? "{}");
          sessionCourseList = sessionEventResponse.courseList;

          yield GetSessionEventState.completed(isSucces: true);
        }
        else if (response?.statusCode == 401) {
          yield GetSessionEventState.error('401');
        }
        else {
          yield GetSessionEventState.error('Something went wrong');
        }
      }
      else if (event is BadCancelEnrollment) {
        yield BadCancelEnrollmentState.loading('Please wait...');
        Response? response;

        try {
          response = await eventModuleRepository.badCancelEnroll(event.contentid);
        } catch (e) {
          print("repo Error $e");
        }

        if (response?.statusCode == 200) {
          yield BadCancelEnrollmentState.completed(
              isSucces: response?.body ?? "{}", table2: event.table2);
        }
        else if (response?.statusCode == 401) {
          yield BadCancelEnrollmentState.error("401");
        }
        else {
          yield BadCancelEnrollmentState.error("Something went wrong");
        }
      }
      else if (event is TrackCancelEnrollment) {
        yield CancelEnrollmentState.loading('Please wait...');
        Response? response;

        try {
          response = await eventModuleRepository.cancelEnroll(event.strContentID, event.isBadCancel);
        } catch (e) {
          print("repo Error $e");
        }

        print(
            'TrackCancelEnrollment ${response?.body}  ${response?.statusCode}');

        if (response?.statusCode == 200) {
          yield CancelEnrollmentState.completed(isSucces: response?.body ?? "{}", table2: event.table2);
        }
        else if (response?.statusCode == 401) {
          yield CancelEnrollmentState.error("401");
        }
        else {
          yield CancelEnrollmentState.error("Something went wrong");
        }
      }
      else if (event is GetCalanderFilterListContent) {
        yield GetTabContentState.loading("Loading");
        list.clear();
        print("select date ${event.startDate}");
        calanderFilterList.forEach((element) {
          print(
              "select date ${element.eventstartdatedisplay.toString().split("T")[0]}");
          if (event.startDate ==
              element.eventstartdatedisplay.toString().split("T")[0]) {
            list.add(element);
          }
        });
        yield GetTabContentState.completed(isSucces: true);
      }
      else if (event is AddExpiryEvent) {
        yield ExpiryEventState.loading("Loading");
        Response? response;

        try {
          response =
              await eventModuleRepository.expiryEvents(event.strContentID);
        } catch (e) {
          print("repo Error $e");
        }
        if (response?.statusCode == 200) {
          yield ExpiryEventState.completed(
              isSucces: response?.body ?? "{}", table2: event.table2);
        } else if (response?.statusCode == 401) {
          yield ExpiryEventState.error("401");
        } else {
          yield ExpiryEventState.error("Something went wrong");
        }
      }
      else if (event is WaitingListEvent) {
        yield WaitingListState.loading("Loading");
        Response? response;

        try {
          response = await eventModuleRepository.waitingList(event.strContentID);

          print('waitinglistresp ${response?.body}');
        }
        catch (e) {
          print("repo Error $e");
        }
        if (response?.statusCode == 200) {
          WaitingListResponse waitingListResponse = waitingListResponseFromJson(response?.body ?? "{}");
          yield WaitingListState.completed(
              isSucces: response.toString(),
              table2: event.table2,
              waitingListResponse: waitingListResponse);
        } else if (response?.statusCode == 401) {
          yield WaitingListState.error("401");
        } else {
          yield WaitingListState.error("Something went wrong");
        }
      }
    }
    catch (e, s) {
      LogUtil().printLog(message: 'Error is ===> $e');
      MyPrint.printOnConsole("Error in EvntModuleBloc.mapEventToState():$e");
      MyPrint.printOnConsole(s);
    }
  }

  void setImageData(List<DummyMyCatelogResponseTable2> list) {
    for (DummyMyCatelogResponseTable2 table2 in list) {
//        print('thumbnailimage ${table2.thumbnailimagepath}');
//        var document = parse(table2.thumbnailimagepath);
//        String imagePathSet;
//        String iageList = '';
//
//        if (document != null) {
//          var imgList = document.querySelectorAll("img");
//
//          for (dom.Element img in imgList) {
//            print(img.attributes["src"]);
//            print(img.toString());
//            iageList = img.attributes["src"];
//          }
//        }
//
//        imagePathSet = ApiEndpoints.strSiteUrl + iageList;
//        print('imagepathset $imagePathSet');

      table2.imageData = ApiEndpoints.strSiteUrl + table2.thumbnailimagepath;
    }
  }

  String formatString(List x) {
    String formatted = '';
    for (var i in x) {
      formatted += '$i, ';
    }
    return formatted.replaceRange(formatted.length - 2, formatted.length, '');
  }
}
