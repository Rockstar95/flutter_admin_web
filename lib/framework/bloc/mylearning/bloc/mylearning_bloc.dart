import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/controllers/my_learning_download_controller.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/notification_count_res.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/connection_dynamic_tab_response.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_gameslistresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_leaderboardresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_userachivmentsresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/all_filter_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/content_filter_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/credit_response_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/filterby_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/filterby_model_learning.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/instructer_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/sort_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/sort_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_asset_progress_data_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_learaning_progress_data_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_learningmodule_progress_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/getsummarydata_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/database/database_handler.dart';
import 'package:flutter_admin_web/framework/helpers/database/hivedb_handler.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/contract/mylearning_repositry.dart';
import 'package:flutter_admin_web/generated/json/dummy_my_catelog_response_entity_helper.dart';
import 'package:flutter_admin_web/providers/my_learning_download_provider.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/models/EventResourcePlusResponse.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/models/MenuComponentsResponse.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../configs/constants.dart';
import '../../../../controllers/mylearning_controller.dart';
import '../../app/bloc/app_bloc.dart';

class MyLearningBloc extends Bloc<MyLearningEVent, MyLearningState> {
  MyLearningRepository myLearningRepository;
  NotificationCountRes notificationCountRes = NotificationCountRes(table: []);

  List<MydashboardGameModel> gameslist = [];
  List<DummyMyCatelogResponseTable2> catalogCatgoryWishlist = [];

  int wishlistCatalogTotalCount = 0;

  List<DummyMyCatelogResponseTable2> list = [];
  List<DummyMyCatelogResponseTable2> pluslist = [];
  bool isFirstLoading = true, isLoadingMyCources = false, hasMoreMyCources = false;
  bool isMyCourseSearch = false;
  String searchMyCourseString = "";
  int listTotalCount = 0;

  List<DummyMyCatelogResponseTable2> listArchive = [];
  bool isArchiveFirstLoading = true,
      isLoadingArchievedCources = false,
      hasMoreArchievedCources = false;
  bool isArchiveSearch = false;
  String searchArchiveString = "";
  int listArchiveTotalCount = 0;

  List<DummyMyCatelogResponseTable2> listWait = [];
  bool isWaitFirstLoading = true;
  int listWaitTotalCount = 0;

  List<ConnectionDynamicTab> dynamicTabList = [];

  LeaderBoardResponse leaderBoardResponse =
      LeaderBoardResponse(leaderBoardList: []);

  //filter lists
  Map<String, String> filterMenus = {};

  String filterContentType = "",
      consolidationType = "all",
      sortBy = "",
      ddlSortList = "",
      ddlSortType = "",
      contentFilterType = "",
      showArchieve = 'true',
      showWaitlist = 'true';

  bool isFilterMenu = false;

  List<ContentFilterByModel> contentFilterByModelList = [];

  List<AllFilterModel> allFilterModelList = [];

  UserAchievementResponse userAchievementResponse = UserAchievementResponse();

  List<SortModel> groupList = [];
  List<SortModel> sortList = [];

  String selectedSort =  "MC.DateAssigned desc";//"MC.Name asc";
  String selectedSortName = "";
  String selectedGroupby = "";
  String selectedGroupbyName = "";
  String selectedRating = "";
  String selectedPriceRange = "";
  String selectedDuration = "";
  String selectedMainCategoryId = "";

  List<String> selectedcategories = [];
  List<String> selectedobjectTypes = [];
  List<String> selectedskillCats = [];
  List<String> selectedjobRoles = [];
  List<String> selectedinstructer = [];
  List<String> selectedlearningproviders = [];

  String selectedCredits = "";

  List<FilterByModel> mainFilterByList = [];
  List<LearnTable> mainFilterByLearnList = [];
  List<FilterByModel> filterByList = [];
  List<LearnTable> filterByLearnList = [];

  FilterByModelLearning learnobj = FilterByModelLearning(Table: []);

  List<Map<String, dynamic>> selectedfilterByList = [];

  List<CreditModel> filterByCreditList = [];

  //report array
  List<GetSummaryDataResponse> getSummaryDatalist = [];
  GetLearaningProgressDataResponse getLearaningProgressDataResponse =
      GetLearaningProgressDataResponse(table: [], table1: [], table2: []);
  GetAssetProgressDataResponse getAssetProgressDataResponse =
      GetAssetProgressDataResponse(
          table: [],
          table1: [],
          table2: [],
          table3: [],
          table4: [],
          table5: [],
          table6: []);
  GeLearningModuleProgressDataResponse getLearningModuleProgressDataResponse =
      GeLearningModuleProgressDataResponse(
          table: [],
          table1: [],
          table2: [],
          table3: [],
          table4: [],
          table5: [],
          table6: []);
  InstructerListResponse instructerListResponse =
      InstructerListResponse(table: []);

  bool isCatalog = false;

  // final LocalDataProvider _localHelper =
  //     LocalDataProvider(localDataProviderType: LocalDataProviderType.hive);

  MyLearningBloc({
    required this.myLearningRepository,
  }) : super(MyLearningState.completed(null)) {
    on<GetListEvent>(onEventHandler);
    on<GetMyLearnPlusLearningObjectsEvent>(onEventHandler);
    on<GetArchiveListEvent>(onEventHandler);
    on<GetWaitListEvent>(onEventHandler);
    on<GetWishListEvent>(onEventHandler);
    on<GetFilterMenus>(onEventHandler);
    on<GetSortMenus>(onEventHandler);
    on<AddToArchiveCall>(onEventHandler);
    on<RemoveToArchiveCall>(onEventHandler);
    on<CancelEnrollment>(onEventHandler);
    on<GetCategoriesTreeEvent>(onEventHandler);
    on<GetLearningtreeEvent>(onEventHandler);
    on<SelectCategoriesEvent>(onEventHandler);
    on<GetFilterDurationEvent>(onEventHandler);
    on<GetFilterIntructorListEvent>(onEventHandler);
    on<RemoveFromMyLearning>(onEventHandler);
    on<GetProgresReportEvent>(onEventHandler);
    on<ResetFilterEvent>(onEventHandler);
    on<ApplyFilterEvent>(onEventHandler);
    on<CourseTrackingEvent>(onEventHandler);
    on<TokenFromSessionIdEvent>(onEventHandler);
    on<UpdateCompleteStatusEvent>(onEventHandler);
    on<GetUserAchievementDataPlusEvent>(onEventHandler);
    on<GetLeaderboardLearnPlusEvent>(onEventHandler);
    on<GetDynamicTabsPlusEvent>(onEventHandler);
    on<GetGamelistLearnPlusEvent>(onEventHandler);
    on<GetEventResourceCalEvent>(onEventHandler);
    on<GetWishListPlusEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(MyLearningEVent event, Emitter emit) async {
    print("MyLearningBloc onEventHandler called for ${event.runtimeType}");
    Stream<MyLearningState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (MyLearningState authState) {
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
  MyLearningState get initialState =>
      IntitialSampleStateState.completed("Intitalized");

  @override
  Stream<MyLearningState> mapEventToState(event) async* {
    try {
      if (event is GetListEvent) {
        print("Enter GetListEvent");
        print("selectedGroupby -- $selectedGroupby");
        print("selectedSort -- $selectedSort");
        print("Search Text -- ${event.searchText}");
        print("GetListEvent called with pageNumber:${event.pageNumber}");
        /*  print("selectedcategories---------${formatString(selectedcategories)}");
        print("selectedskillCats---------${selectedskillCats.length}");
        print("selectedobjectTypes---------${selectedobjectTypes.length}");
        print("selectedjobRoles---------${selectedjobRoles.length}");*/
        isLoadingMyCources = true;

        yield GetListState.loading('Loading...please wait');
        if (isFirstLoading /* || event.searchText.length > 0*/) {
          list = [];
          listTotalCount = 0;
        }
        try {
          Response? response = await myLearningRepository.getMobileMyCatalogObjectsData(
            event.pageNumber,
            event.pageSize,
            false,
            false,
            event.searchText,
            selectedSort,
            selectedGroupby,
            selectedcategories.length != 0
                ? formatString(selectedcategories)
                : "",
            selectedobjectTypes.length != 0
                ? formatString(selectedobjectTypes)
                : "",
            selectedskillCats.length != 0
                ? formatString(selectedskillCats)
                : "",
            selectedjobRoles.length != 0 ? formatString(selectedjobRoles) : "",
            selectedCredits,
            selectedinstructer.length != 0
                ? formatString(selectedinstructer)
                : "",
            event.contentID,
            event.contentStatus,
          );
          //MyCatalogResponse myCatalogResponse = myCatalogResponseFromJson(response.toString());
          if (response == null) throw Exception('Null response');

          if (response.statusCode == 200) {
            DummyMyCatelogResponseEntity myCatelogResponseEntity = new DummyMyCatelogResponseEntity();
            print("Response:${response.body}");
            Map valueMap = json.decode(response.body) ?? {};
            List table2List = Map.castFrom(valueMap)['table2'] ?? [];
            for (Map<String, dynamic> table2MapItem in table2List) {
              MyLearningModel myLearningModel = MyLearningModel.fromJson(table2MapItem);
              await SqlDatabaseHandler().injectMyLearningIntoTable(myLearningModel);
              print('Stef');
            }
            myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(myCatelogResponseEntity, Map.castFrom(valueMap));
            DummyMyCatelogResponseTable? table = myCatelogResponseEntity.table.isNotEmpty
                    ? myCatelogResponseEntity.table.first
                    : null;
            print("totalrecordscount ${table?.totalrecordscount}");
            listTotalCount = table?.totalrecordscount ?? 0;
            print("myCatelogResponseEntitytable 2 size ${myCatelogResponseEntity.table2.length}");
            if (event.pageNumber == 1) {
              list = [];
            }

            AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
            String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";

            myCatelogResponseEntity.table2.forEach((element) {
              list.add(element);
            });
            setImageData(list);
            await checkifFileExist(list);

            MyPrint.printOnConsole("Create Entries in Hive Called For MyLearning");
            for(DummyMyCatelogResponseTable2 tempTable2 in list) {
              await HiveDbHandler().createData(
                hiveCollectionName,
                tempTable2.contentid,
                tempTable2.toJson(),
              );
            }

            //await MyLearningController().tempGetMyLearningContentsInOffline();

            print("object bloc 200 if  ${response.statusCode} ");
            isFirstLoading = false;
            print("list ${list.length}");

            list.map((e) {
              if(e.isdownloaded) {
                // create obj
              }
            }).toList();

            isLoadingMyCources = false;

            MyLearningController().getMyDownloads();

            yield GetListState.completed(
              list: list,
            );
          } else {
            print("object bloc else part ${response.statusCode} ");
            isLoadingMyCources = false;
            yield GetListState.error("${response.statusCode}");
          }
        }
        catch (e, s) {
          print("Sagar sir log $e");
          print(s);

          list.clear();
          listTotalCount = 0;

          AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
          String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";
          var data = await HiveDbHandler().readData(hiveCollectionName);
          MyPrint.printOnConsole("MyLearning Data From Hive:$data");
          MyPrint.printOnConsole("MyLearning Data Length From Hive:${data.length}");

          /// by default, hive will return an empty object.
          /// If there is cached data, it will be returned data.
          /// If there is nothing, then it will yeild an error
          if (data.isNotEmpty) {
            listTotalCount = data.length;

            for(Map<String, dynamic> item in data) {
              DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
              table2.fromJson(item);
              if(table2.contentid.isNotEmpty) {
                list.add(table2);
              }
              else {
                HiveDbHandler().deleteData(hiveCollectionName, keys: [""]);
              }
            }
            list.sort((a, b) => a.name.compareTo(b.name));

            isFirstLoading = false;
            print("list ${list.length}");
            await checkifFileExist(list);
            setImageData(list);

            isLoadingMyCources = false;

            MyLearningController().getMyDownloads();

            yield GetListState.completed(
              list: list,
            );
          }
          else {
            isLoadingMyCources = false;
            yield GetListState.error("Error  $e");
          }
        }
      }
      else if (event is GetMyLearnPlusLearningObjectsEvent) {
        List<String> eventTypes = [
          'inprogress',
          'completed',
          'incomplete',
          'NotStarted',
          'waitlist',
          'wishlist',
          'attending',
          'today',
          'thisweek',
          'thismonth',
          'future',
        ];
        eventTypes.contains(event.type);
        if (eventTypes.contains(event.type)) {
          yield GetMyLearnPlusLearningObjectsState
              .loading('Loading...please wait');
        }

        if (isFirstLoading || event.searchText.length > 0) {
          pluslist = [];
          listTotalCount = 0;
        }
        // String componentId = "";String componentInsId = "";
        // if(event.type == "today" || event.type == "thisweek" || event.type == "thismonth" || event.type == "future"){
        //   componentId = event.componentInsId;
         
        // }
        try {
          Response? response =
              await myLearningRepository.getMobileMyLearningPlusObjectsData(
                  event.pageNumber,
                  event.pageSize,
                  false,
                  event.isWait ? true : false,
                  event.searchText,
                  selectedSort,
                  selectedGroupby,
                  selectedcategories.length != 0
                      ? formatString(selectedcategories)
                      : "",
                  event.objectTypeId,
                  // selectedobjectTypes.length != 0
                  //     ? event.objecttypeId         //formatString(selectedobjectTypes)
                  //     : "",
                  selectedskillCats.length != 0
                      ? formatString(selectedskillCats)
                      : "",
                  selectedjobRoles.length != 0
                      ? formatString(selectedjobRoles)
                      : "",
                  selectedCredits,
                  selectedinstructer.length != 0
                      ? formatString(selectedinstructer)
                      : "",
                  event.contentID,
                  event.contentStatus,
                  event.componentId,
                  event.componentInsId,
                  event.isWishlistCount,
                  event.dateFilter,
                  );

          print(
              "getMobileMyLearningPlusObjectsData response Status:${response?.statusCode}, Body:'${response?.body}'");

          DummyMyCatelogResponseEntity myCatelogResponseEntity =
               DummyMyCatelogResponseEntity();
          // pluslist = [];    
          Map valueMap = json.decode(response?.body.trim() ?? "{}");
          myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(
              myCatelogResponseEntity, Map.castFrom(valueMap));

          if (response?.statusCode == 200) {
            print(
                "totalrecordscount ${myCatelogResponseEntity.table.isNotEmpty ? myCatelogResponseEntity.table[0].totalrecordscount : 0}");
            listTotalCount = myCatelogResponseEntity.table.isNotEmpty
                ? myCatelogResponseEntity.table[0].totalrecordscount
                : 0;
            print(
                "myCatelogResponseEntitytable 2 size ${myCatelogResponseEntity.table2.length} for type:${event.type}");
            if (event.pageNumber == 1) {
              pluslist = [];
            }
            myCatelogResponseEntity.table2.forEach((element) {
              pluslist.add(element);
              setImageData(list);
            });
          }
          if (response?.statusCode == 200) {
            print("object bloc 200 if  ${response?.statusCode} ");
            isFirstLoading = false;
            print("list ${pluslist.length}");
            await checkifFileExist(pluslist);
            setImageData(pluslist);

            if (eventTypes.contains(event.type)) {
              yield GetMyLearnPlusLearningObjectsState.completed(
                  list: pluslist);
            }
          } else {
            print("object bloc else part ${response?.statusCode} ");
            if (eventTypes.contains(event.type)) {
              yield GetMyLearnPlusLearningObjectsState
                  .error("${response?.statusCode}");
            }
          }
        } catch (e, st) {
          print("Sagar sir log $e \n $st ");
          print(st);
          if (eventTypes.contains(event.type)) {
            yield GetMyLearnPlusLearningObjectsState.error("Error  $e");
          }
        }
      }
      else if (event is GetEventResourceCalEvent) {
        yield GetMyLearnPlusEventResourceState.loading('Loading...please wait');
        try {
          Response? response = await myLearningRepository.getEventResourceInfo(
              event.componentid,
              event.componentinsid,
              event.objecttypes,
              event.multiLocation,
              event.startdate,
              event.enddate,
              event.eventid);

          if (response?.statusCode == 200) {
            List<EventResourcePlusResponse> eventlist =
                eventResourcePlusResponseFromJson(response?.body ?? "[]");
            yield GetMyLearnPlusEventResourceState.completed(list: eventlist);
          } else {
            yield GetMyLearnPlusEventResourceState.completed(list: []);
          }
        } catch (e, st) {
          print('the calendar error is : ${e.toString()} == $st');
          yield GetMyLearnPlusEventResourceState.error('Error $e');
        }
      }
      else if (event is GetArchiveListEvent) {
        print("Enter GetArchiveListEvent");
        isLoadingArchievedCources = true;
        yield GetArchiveListState.loading('Loading...please wait');
        try {
          if (isArchiveFirstLoading || event.searchText.length > 0) {
            listArchive = [];
            listArchiveTotalCount = 0;
            /*await _localHelper.localService(
              enumLocalDatabaseOperation: LocalDatabaseOperation.delete,
              table: 'archiveList',
            );*/
          }
          listArchive = [];
          Response? response = await myLearningRepository.getMobileMyCatalogObjectsData(
            event.pageNumber,
            event.pageSize,
            true,
            false,
            event.searchText,
            selectedSort,
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
          );
          //MyCatalogResponse myCatalogResponse = myCatalogResponseFromJson(response.toString());

          if (response == null) throw Exception('Null response');

          if (response.statusCode == 200) {
            DummyMyCatelogResponseEntity myCatelogResponseEntity = DummyMyCatelogResponseEntity();
            Map valueMap = json.decode(response.body == "null" ? "{}" : response.body);

            List table2List = Map.castFrom(valueMap)['table2'] ?? [];
            for (Map<String, dynamic> table2MapItem in table2List) {
              MyLearningModel myLearningModel = MyLearningModel.fromJson(table2MapItem);
              await SqlDatabaseHandler().injectMyLearningIntoTable(myLearningModel);
              print('Stef');
            }

            myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(myCatelogResponseEntity, Map.castFrom(valueMap));

            print("totalrecordscount ${myCatelogResponseEntity.table.isNotEmpty ? myCatelogResponseEntity.table[0].totalrecordscount : 0}");
            listArchiveTotalCount = myCatelogResponseEntity.table.isNotEmpty
                ? myCatelogResponseEntity.table[0].totalrecordscount
                : 0;
            print("mylistArchiveResponseEntitytable 2 size ${myCatelogResponseEntity.table2.length}");
            myCatelogResponseEntity.table2.forEach((element) {
              //if(!listArchive.contains(element))
              listArchive.add(element);
            });

            isArchiveFirstLoading = false;
            print("listArchive ${listArchive.length}");
            await checkifFileExist(listArchive);
            setImageData(listArchive);
            isLoadingArchievedCources = false;

            AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
            String hiveCollectionName = "$archiveList-${appBloc.userid}";
            for(DummyMyCatelogResponseTable2 tempTable2 in listArchive) {
              await HiveDbHandler().createData(
                hiveCollectionName,
                tempTable2.contentid,
                tempTable2.toJson(),
              );
            }

            MyLearningController().getMyDownloads();

            yield GetArchiveListState.completed(list: listArchive);
          }
          else {
            print(response.statusCode);
            isLoadingArchievedCources = false;
            yield GetArchiveListState.error("${response.statusCode}");
          }
        } catch (e, s) {
          print("log $e");
          print(s);

          listArchive.clear();
          listArchiveTotalCount = 0;

          AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
          String hiveCollectionName = "$archiveList-${appBloc.userid}";

          var data = await HiveDbHandler().readData(hiveCollectionName);
          MyPrint.printOnConsole("Archieved Data From Hive:$data");
          MyPrint.printOnConsole("Archieved Data Length From Hive:${data.length}");

          // var data = await _localHelper.localService(
          //   enumLocalDatabaseOperation: LocalDatabaseOperation.read,
          //   table: 'archiveList',
          // );

          /// by default, hive will return an empty object.
          /// If there is cached data, it will be returned data.
          /// If there is nothing, then it will yeild an error
          if (data.isNotEmpty) {
            for(Map<String, dynamic> item in data) {
              DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
              table2.fromJson(item);
              if(table2.contentid.isNotEmpty) {
                listArchive.add(table2);
              }
              else {
                HiveDbHandler().deleteData(hiveCollectionName, keys: [""]);
              }
            }
            listArchive.sort((a, b) => a.name.compareTo(b.name));
            MyPrint.printOnConsole("Archieved Data Length After Add:${listArchive.length}");

            listArchiveTotalCount = listArchive.length;

            isFirstLoading = false;
            print("listArchive ${listArchive.length}");
            await checkifFileExist(listArchive);
            setImageData(listArchive);
            isLoadingArchievedCources = false;

            MyLearningController().getMyDownloads();

            yield GetArchiveListState.completed(
              list: listArchive,
            );
          }
          else {
            isLoadingArchievedCources = false;
            yield GetArchiveListState.error("Error  $e");
          }
        }
      }
      else if (event is GetWishListPlusEvent) {
        yield GetWishListPlusState.loading("Loading....");
        try {//8thparam
          Response? response =
              await myLearningRepository.getMobileMyCatalogObjectsPlusData(
            event.pageIndex,
            event.categaoryID,
            "",
            true,
            "c.name",
            //'',
            (event.compid == 1) ? "" : 'EventComponentID=153~FilterContentType=70~eventtype=upcoming~HideCompleteStatus=true', //eventtype != null & EventComponentID != null  & FilterContentType != null
            '',
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            event.type,
            "",
            event.compid.toString(),
            event.compinsid.toString(),
            1,
          );

          print(" wise statusCode ${response?.statusCode}");
          print(" wise Response ${response?.body}");
          //catalogCatgoryWishlist = [];

          DummyMyCatelogResponseEntity myCatelogResponseEntity =
              DummyMyCatelogResponseEntity();
          Map valueMap = json.decode(response?.body ?? "{}");
          myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(
              myCatelogResponseEntity, Map.castFrom(valueMap));

          if (response?.statusCode == 200) {
            print(
                "wise totalrecordscount ${myCatelogResponseEntity.table.isNotEmpty ? myCatelogResponseEntity.table[0].totalrecordscount : 0}");
            print(
                "wise catalogCatgoryWishlist size ${myCatelogResponseEntity.table2.length}");
            wishlistCatalogTotalCount = myCatelogResponseEntity.table.isNotEmpty
                ? myCatelogResponseEntity.table[0].totalrecordscount
                : 0;
            catalogCatgoryWishlist = myCatelogResponseEntity.table2;

            yield GetWishListPlusState.completed(list: catalogCatgoryWishlist);
          } else if (response?.statusCode == 401) {
            yield GetWishListPlusState.error("401");
          } else {
            yield GetWishListPlusState.error("Error");
          }
        } catch (e) {
          print(e);
        }
      }
      else if (event is GetWaitListEvent) {
        print("Enter GetWaitListEvent");
        yield GetWaitListState.loading('Loading...please wait');
        if (isWaitFirstLoading) {
          listWait = [];
          listWaitTotalCount = 0;
        }
        try {
          Response? response =
              await myLearningRepository.getMobileMyCatalogObjectsData(
            event.pageNumber,
            event.pageSize,
            false,
            true,
            "",
            selectedSort,
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
          );
          //MyCatalogResponse myCatalogResponse = myCatalogResponseFromJson(response.toString());

          if (event.pageNumber < event.pageSize &&
              response?.statusCode == 200) {
            DummyMyCatelogResponseEntity myCatelogResponseEntity =
                DummyMyCatelogResponseEntity();
            Map valueMap = json.decode(response?.body.toString() ?? "{}");
            myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(
                myCatelogResponseEntity, Map.castFrom(valueMap));

            print("table size ${myCatelogResponseEntity.table.length}");
            print(
                "totalrecordscount ${myCatelogResponseEntity.table.isNotEmpty ? myCatelogResponseEntity.table[0].totalrecordscount : 0}");
            listWaitTotalCount = myCatelogResponseEntity.table.isNotEmpty
                ? myCatelogResponseEntity.table[0].totalrecordscount
                : 0;
            print(
                "myWaitResponseEntitytable 2 size ${myCatelogResponseEntity.table2.length}");
            myCatelogResponseEntity.table2.forEach((element) {
              listWait.add(element);
            });
          }
          if (response?.statusCode == 200) {
            isWaitFirstLoading = false;
            print("listWait ${listWait.length}");
            await checkifFileExist(listWait);
            setImageData(listWait);
            yield GetWaitListState.completed(list: listWait);
          } else {
            print(response?.statusCode);
            yield GetWaitListState.error("${response?.statusCode}");
          }
        } catch (e) {
          print("log $e");
          yield GetWaitListState.error("Error  $e");
        }
      }
      else if (event is CancelEnrollment) {
        /*Response? response = */await myLearningRepository.cancelEnrollment(event.isBadCancel, event.strContentID);
      }
      else if (event is GetFilterMenus) {
        String strConditions = "";
        // print("listNativeModel ${event.listNativeModel.removeLast()}");
        event.listNativeModel.forEach((element) {
          /*print("element  ####### moduleName ${element.displayname}");
          print("element  ####### componentId ${element.componentId}");
          print("element  ####### landingpageType ${element.landingpageType}");*/
          if (element.displayname == event.moduleName) {
            strConditions = element.conditions;
          }
        });
        //print("strConditions   $strConditions");
        filterMenus = Map();

        if (strConditions != null && strConditions != "") {
          if (strConditions.contains("#@#")) {
            var conditionsArray = strConditions.split("#@#");
            int conditionCount = conditionsArray.length;
            if (conditionCount > 0) {
              filterMenus = generateHashMap(conditionsArray);
            }
          }
        }
        if (filterMenus != null && filterMenus.containsKey("ShowIndexes")) {
          String showIndexes = filterMenus["ShowIndexes"] ?? "";
          print("ShowIndexes $showIndexes");
          if (showIndexes == "top" || showIndexes == "true") {
            isFilterMenu = true;
          } else {
            isFilterMenu = false;
          }
        } else {
          // No such key
          isFilterMenu = false;
        }

        if (filterMenus != null &&
            filterMenus.containsKey("showconsolidatedlearning")) {
          String consolidate = filterMenus["showconsolidatedlearning"] ?? "";
          if (consolidate == "true") {
            consolidationType = "consolidate";
          } else {
            consolidationType = "all";
          }
        } else {
          // No such key
          consolidationType = "all";
        }
        if (filterMenus != null && filterMenus.containsKey("sortby")) {
          sortBy = filterMenus["sortby"] ?? "";
        } else {
          // No such key
          sortBy = "";
        }

        // added extra parameters
        if (filterMenus != null && filterMenus.containsKey("ddlSortList")) {
          ddlSortList = filterMenus["ddlSortList"] ?? "";
        } else {
          // No such key
          ddlSortList = "publisheddate";
        }

        if (filterMenus != null && filterMenus.containsKey("ddlSortType")) {
          ddlSortType = filterMenus["ddlSortType"] ?? "";
        } else {
          // No such key
          ddlSortType = "asc";
        }

        if (filterMenus != null &&
            filterMenus.containsKey("FilterContentType")) {
          filterContentType = filterMenus["FilterContentType"] ?? "";
        } else {
          // No such key
          filterContentType = "";
        }

        if (filterMenus != null && filterMenus.containsKey("ShowArchieve")) {
          showArchieve = filterMenus["ShowArchieve"] ?? "";
        } else {
          // No such key
          showArchieve = "true";
        }

        if (filterMenus != null && filterMenus.containsKey("ShowWaitlist")) {
          showWaitlist = filterMenus["ShowWaitlist"] ?? "";
        } else {
          // No such key
          showWaitlist = "true";
        }

        if (filterMenus != null && filterMenus.containsKey("ContentFilterBy")) {
          contentFilterType = filterMenus["ContentFilterBy"] ?? "";
        } else {
          // No such key
          contentFilterType = "";
        }
        print("contentFilterType ----------$contentFilterType");
        contentFilterByModelList = [];
        contentFilterByModelList = generateContentFilters(event.localStr);

        allFilterModelList = getAllFilterModelList(event.localStr);

        yield GetFilterMenusState.completed(filterMenus: filterMenus);
      }
      else if (event is GetSortMenus) {
        try {
          Response? response = await myLearningRepository
              .getComponentSortOptions(event.componentID);

          print("Sort Response ${response?.body.toString()}");

          SortResponse sortResponse =
              sortResponseFromJson(response?.body ?? "{}");
          print("Got Sort Response");
          List<SortTable> sortMenuList = sortResponse.table;
          sortList.clear();
          sortMenuList.forEach((element) {
            SortModel sortModel = new SortModel();

            sortModel.optionDisplayText = element.optionText;
            sortModel.optionIdValue = element.optionValue;
            sortModel.componentID = element.componentId;
            sortModel.localID = element.localId;
            sortModel.categoryID = element.id;

            sortList.add(sortModel);
          });

          selectedSort = sortList.isNotEmpty ? sortList[0].optionIdValue : "";

          yield GetSortMenusState.completed(sortList: sortList);
        } catch (e, s) {
          print("Sagar sir log $e");
          print(s);
          yield GetSortMenusState.error("Error  $e");
        }
      }
      else if (event is AddToArchiveCall) {
        try {
          Response? response =
              await myLearningRepository.updateMyLearningArchive(
                  event.isArchive, event.strContentID);

          print("Sort Response ${response?.body}");

          if (response?.statusCode == 200) {
            list.removeWhere((element) => (element.contentid == event.strContentID));

            AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
            String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";

            await HiveDbHandler().deleteData(
              hiveCollectionName,
              keys: [event.strContentID],
            );

            String archiveHiveCollectionName = "$archiveList-${appBloc.userid}";

            await HiveDbHandler().createData(
              archiveHiveCollectionName,
              event.strContentID,
              event.table2.toJson(),
            );

            //MyLearningController().getMyDownloads();

            yield AddtoArchiveCallState.completed(isScusses: true);
          } else {
            print(response?.statusCode);
            yield AddtoArchiveCallState.error("${response?.statusCode}");
          }
        } catch (e, s) {
          print("Sagar sir log $e");
          print(s);
          yield AddtoArchiveCallState.error("Error  $e");
        }
      }
      else if (event is RemoveToArchiveCall) {
        try {
          Response? response = await myLearningRepository.updateMyLearningArchive(event.isArchive, event.strContentID);

          print("UpdateMyLearningArchive Response ${response.toString()}");

          if (response?.statusCode == 200) {
            listArchive.removeWhere((element) => (element.contentid == event.strContentID));

            AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
            String archiveHiveCollectionName = "$archiveList-${appBloc.userid}";

            await HiveDbHandler().deleteData(
              archiveHiveCollectionName,
              keys: [event.strContentID],
            );

            String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";

            await HiveDbHandler().createData(
              hiveCollectionName,
              event.strContentID,
              event.table2.toJson(),
            );

            //MyLearningController().getMyDownloads();

            yield RemovetoArchiveCallState.completed(isScusses: true);
          }
          else {
            print(response?.statusCode);
            yield RemovetoArchiveCallState.error("${response?.statusCode}");
          }
        } catch (e) {
          print("Sagar sir log $e");
          yield RemovetoArchiveCallState.error("Error  $e");
        }
      }
      else if (event is GetLearningtreeEvent) {
        yield GetLearningTreeState.loading('Loading...please wait');
        try {
          filterByLearnList.clear();
          Response? response =
              await myLearningRepository.getLearningProviderTree();

          print("GetLearningTreeState statusCode ${response?.statusCode}");
          print("GetLearningTreeState response ${response?.body}");

          print("jsonenccodedat response ${response?.body}");
          if (response?.statusCode == 200) {
            learnobj = filterByModelFromLearnJson(response?.body ?? "{}");
            filterByLearnList = learnobj.Table;

            yield GetLearningTreeState.completed(filterByList: learnobj);
          } else if (response?.statusCode == 401) {
            yield GetLearningTreeState.error("401");
          } else {
            yield GetLearningTreeState.error("Error");
          }
        } catch (e) {
          print("log $e");
          yield GetLearningTreeState.error("Error  $e");
        }
      }
      else if (event is GetCategoriesTreeEvent) {
        yield GetCategoriesTreeState.loading('Loading...please wait');
        try {
          filterByList.clear();
          Response? response =
              await myLearningRepository.getCategoriesTree(event.categoryID,event.componentId);

          print("GetCategoriesTreeState statusCode ${response?.statusCode}");
          print("GetCategoriesTreeState response ${response?.body}");
          // if(response.data.length == 0 && event.categoryID)
          contentFilterByModelList.removeWhere((ee) =>
              ee.categoryID == (event.categoryID = "cat") &&
              response?.body.length == 0);

          if (response?.statusCode == 200) {
            mainFilterByList = filterByModelFromJson(response?.body ?? '');

            mainFilterByList.forEach((element) {
              if (element.parentId == 0 || element.parentId == "0") {
                if (element.categoryId != null) {
                  if (checkfilterbyChild(element.categoryId)) {
                    element.hasChild = true;
                  }
                }
                filterByList.add(element);
              }
            });

            yield GetCategoriesTreeState.completed(filterByList: filterByList);
          } else if (response?.statusCode == 401) {
            yield GetCategoriesTreeState.error("401");
          } else {
            yield GetCategoriesTreeState.error("Error");
          }
        } catch (e) {
          print("log $e");
          yield GetCategoriesTreeState.error("Error  $e");
        }
      }
      else if (event is SelectCategoriesEvent) {
        bool isAdd = true;

        for (int i = 0; i < selectedfilterByList.length; i++) {
          if (selectedfilterByList[i]["CategoryID"] ==
                  event.seletedCategoryID &&
              selectedfilterByList[i]["mainCategory"] == event.mainCategory) {
            print("object Matched Removed");
            selectedfilterByList.removeAt(i);
            isAdd = false;
            break;
          }
        }
        if (isAdd) {
          print("object Not - Matched Added");
          Map<String, dynamic> map = new Map();
          map["CategoryID"] = event.seletedCategoryID;
          map["mainCategory"] = event.mainCategory;
          map["categoryDisplayName"] = event.categoryDisplayName;
          selectedfilterByList.add(map);
        }

        print("selectedfilterByList -------${selectedfilterByList.toString()}");

        yield SelectCategoriesState.completed(list: selectedfilterByList);
      }
      else if (event is GetFilterDurationEvent) {
        yield GetFilterDurationState.loading('Loading...please wait');
        try {
          String urlStr = "${ApiEndpoints.GetFilterDurationURL()}";

          print("GetFilterDurationEvent $urlStr");
          Response? response = await RestClient.getPostData(urlStr);

          print("GetFilterDurationEvent statusCode ${response?.statusCode}");
          print("GetFilterDurationEvent response ${response?.body}");

          if (response?.statusCode == 200) {
            CreditResponseModel responseModel =
                creditResponseModelFromJson(response?.body ?? "{}");
            filterByCreditList = responseModel.table1;
            yield GetFilterDurationState.completed(list: filterByCreditList);
          } else {
            yield GetFilterDurationState.error("Error");
          }
        } catch (e) {
          print("log $e");
          yield GetFilterDurationState.error("Error  $e");
        }
      }
      else if (event is RemoveFromMyLearning) {
        try {
          yield RemoveFromMyLearningState.loading('Please wait...');

          var strUserID = await sharePrefGetString(sharedPref_userid);
          var strSiteID = await sharePrefGetString(sharedPref_siteid);

          String urlStr =
              "${ApiEndpoints.removeFromMyLearning(event.contentId, strUserID, strSiteID)}";

          Response? response = await RestClient.getPostData(urlStr);
          print('removeFrommyLearning $response');
          if (response?.statusCode == 200) {
            if ((response?.body ?? "") == 'true') {
              AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);

              String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";
              String archieveHiveCollectionName = "$archiveList-${appBloc.userid}";
              String hiveMyDownloadsTable = "$MY_DOWNLOADS_HIVE_COLLECTION_NAME-${appBloc.userid}";

              await Future.wait([
                HiveDbHandler().deleteData(hiveCollectionName, keys: [event.contentId]),
                HiveDbHandler().deleteData(archieveHiveCollectionName, keys: [event.contentId]),
                HiveDbHandler().deleteData(hiveMyDownloadsTable, keys: [event.contentId]),
                MyLearningDownloadController().setRemoveFromDownloadsForContent(contentid: event.contentId, isRemoved: true),
              ]);

              MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
              myLearningDownloadProvider.downloads.removeWhere((element) => element.table2.contentid == event.contentId);
              myLearningDownloadProvider.notifyListeners();

              yield RemoveFromMyLearningState.completed(response: true);
            } else {
              yield RemoveFromMyLearningState.error("Error");
            }
          } else if (response?.statusCode == 401) {
            yield RemoveFromMyLearningState.error("401");
          } else {
            yield RemoveFromMyLearningState.error("Error");
          }
        } catch (e) {
          print("log $e");
          yield RemoveFromMyLearningState.error("Error  $e");
        }
      }
      else if (event is GetProgresReportEvent) {
        yield GetProgresReportState.loading("Loading ........");
        try {
          var strUserID = await sharePrefGetString(sharedPref_userid);
          //var strSiteID = await sharePrefGetString(sharedPref_siteid);
          var language = await sharePrefGetString(sharedPref_AppLocale);

          final DateTime now = DateTime.now();
          final DateTime start = DateTime.now().subtract(Duration(days: 10));
          final DateFormat formatter = DateFormat('MM/dd/yyyy');
          final String enddate = formatter.format(now);
          final String startdate = formatter.format(start);

          String paramsString =
              "${ApiEndpoints.strBaseUrl}/MobileLMS/getsummarydata?CID=${event.contentID}&ObjectTypeID=${event.objectTypeID}&UserID=$strUserID&StartDate=$startdate&EndDate=$enddate&SeqID=${event.postion}&TrackID=${event.trackID}&locale=$language&EventID=";
          print("getsummarydata URL ......... $paramsString");
          Response? response = await RestClient.getPostData(paramsString);

          String paramsString1 =
              "${ApiEndpoints.strBaseUrl}/Progressummary/getprogressdatadetails?CID=${event.contentID}&ObjectTypeID=${event.objectTypeID}&UserID=$strUserID&StartDate=$startdate&EndDate=$enddate&SeqID=${event.postion}&TrackID=${event.trackID}&locale=$language";
          print("getprogressdatadetails URL ......... $paramsString1");
          Response? response1 = await RestClient.getPostData(paramsString1);

          if (response?.statusCode == 200) {
            var jsonenccodedat = response?.body ?? "[]";
            print("jsonenccodedat response $jsonenccodedat");
            print(
                "getsummarydata StatusCode ......... ${response?.statusCode}");

            getSummaryDatalist =
                getSummaryDataResponseFromJson(jsonenccodedat.toString());

            yield GetProgresReportState.completed(list: getSummaryDatalist);
          } else {
            yield GetProgresReportState.error("Error");
          }

          if (response1?.statusCode == 200) {
            var jsonenccodedat1 = response1?.body ?? "{}";
            print("getprogressdatadetails response $jsonenccodedat1");
            print(
                "getprogressdatadetails StatusCode ......... ${response1?.statusCode}");

            if (event.objectTypeID == "10") {
              getLearaningProgressDataResponse =
                  GetLearaningProgressDataResponse(
                      table1: [], table2: [], table: []);
              getLearaningProgressDataResponse =
                  getLearaningProgressDataResponseFromJson(
                      jsonenccodedat1.toString());
            } else if (event.objectTypeID == "9") {
              getAssetProgressDataResponse = GetAssetProgressDataResponse(
                  table: [],
                  table1: [],
                  table2: [],
                  table3: [],
                  table4: [],
                  table5: [],
                  table6: []);
              getAssetProgressDataResponse =
                  getAssetProgressDataResponseFromJson(
                      jsonenccodedat1.toString());
            } else if (event.objectTypeID == "8") {
              getLearningModuleProgressDataResponse =
                  GeLearningModuleProgressDataResponse(
                      table: [],
                      table1: [],
                      table2: [],
                      table3: [],
                      table4: [],
                      table5: [],
                      table6: []);
              print("Aman : " + jsonenccodedat1.toString());
              getLearningModuleProgressDataResponse =
                  geLearningModuleProgressDataResponseFromJson(
                      jsonenccodedat1.toString());
            }
          }
        } catch (e, s) {
          print("Error:$e");
          print(s);
        }
      }
      else if (event is ResetFilterEvent) {
        selectedSort = "MC.Name asc";
        selectedSortName = "";
        selectedGroupby = "";
        selectedGroupbyName = "";
        selectedCredits = "";
        selectedRating = "";
        selectedPriceRange = "";
        selectedDuration = "";
        selectedcategories.clear();
        selectedobjectTypes.clear();
        selectedskillCats.clear();
        selectedjobRoles.clear();
        selectedinstructer.clear();
        selectedfilterByList.clear();
        selectedlearningproviders.clear();

        yield ResetFilterState.completed(response: true);
      }
      else if (event is ApplyFilterEvent) {
        selectedcategories.clear();
        selectedobjectTypes.clear();
        selectedskillCats.clear();
        selectedjobRoles.clear();
        selectedinstructer.clear();
        selectedlearningproviders.clear();
        selectedlearningproviders.clear();

        /* for (int i = 0; i < selectedfilterByList.length; i++) {

          print("mainCategory---------${ selectedfilterByList[i]["mainCategory"]}");
          print("CategoryID---------${selectedfilterByList[i]["CategoryID"]}");

        }*/

        selectedfilterByList.forEach((element) {
          if (element["mainCategory"] == "cat" ||
              element["mainCategory"] == "subcat") {
            selectedcategories.add(element["CategoryID"]);
          } else if (element["mainCategory"] == "skills" ||
              element["mainCategory"] == "subskills") {
            selectedskillCats.add(element["CategoryID"]);
          } else if (element["mainCategory"] == "bytype") {
            selectedobjectTypes.add(element["CategoryID"]);
          } else if (element["mainCategory"] == "jobroles") {
            selectedjobRoles.add(element["CategoryID"]);
          } else if (element["mainCategory"] == "inst") {
            selectedinstructer.add(element["CategoryID"]);
          } else if (element["mainCategory"] == "learningprovider") {
            selectedlearningproviders.add(element["CategoryID"]);
          }
        });
        yield ResetFilterState.completed(response: true);
      }
      else if (event is GetFilterIntructorListEvent) {
        yield InstructerListState.loading("data");
        var strUserID = await sharePrefGetString(sharedPref_userid);
        var strSiteID = await sharePrefGetString(sharedPref_siteid);
        String paramsString =
            "${ApiEndpoints.strBaseUrl}/catalog/GetInstructorListForFilter?instSiteID=$strSiteID&instUserID=$strUserID";
        print("getsummarydata URL ......... $paramsString");
        Response? response = await RestClient.getPostData(paramsString);
        var jsonenccodedat = response?.body ?? "{}";
        print("GetInstructorListForFilter response $jsonenccodedat");

        if (response?.statusCode == 200) {
          instructerListResponse =
              instructerListResponseFromJson(jsonenccodedat.toString());
          yield InstructerListState.completed(response: instructerListResponse);
        } else {
          yield InstructerListState.error("Error");
        }
      }
      else if (event is TokenFromSessionIdEvent) {
        yield TokenFromSessionIdState.loading("data");

        // var strUserID = await sharePref_getString(sharedPref_userid);
        // var strSiteID = await sharePref_getString(sharedPref_siteid);

        Response? response =
            await myLearningRepository.tokenFromSessionIdAiCall(
          event.courseURL,
          event.courseName,
          event.contentID,
          event.objecttypeId,
          event.learnerSCOID,
          event.learnerSessionID,
          event.userID,
        );

        print("TokenFromSessionIdState response ${response?.body.toString()}");

        if (response?.statusCode == 200) {
          yield TokenFromSessionIdState.completed(
            response: jsonDecode(response?.body ?? "{}").toString(),
            table2: event.table2,
          );
        } else {
          yield TokenFromSessionIdState.error("Error");
        }
      }
      else if (event is CourseTrackingEvent) {
        yield CourseTrackingState.loading("data");
        // var strUserID = await sharePref_getString(sharedPref_userid);
        // var strSiteID = await sharePref_getString(sharedPref_siteid);
        Response? response = await myLearningRepository.courseTrackingApiCall(
          event.courseUrl,
          event.userID,
          event.scoId,
          event.objecttypeId,
          event.contentID,
          event.siteIDValue,
        );

        // var jsonenccodedate = json.encode(response.data);
        print("GetInstructorListForFilter response ${response?.body}");

        if (response?.statusCode == 200) {
          yield CourseTrackingState.completed(
            response: response?.body.toString() ?? "",
            table2: event.table2,
            courseUrl: event.courseUrl,
          );
        } else {
          yield CourseTrackingState.error("Error");
        }
      }
      else if (event is UpdateCompleteStatusEvent) {
        // yield UpdateCompleteStatusState.loading("data");
        var strUserID = await sharePrefGetString(sharedPref_userid);
        // var strSiteID = await sharePref_getString(sharedPref_siteid);
        Response? response = await myLearningRepository
            .updateCompleteStatusCall(event.contentID, strUserID, event.scoID);

        print("updateCompleteStatusCall response ${response?.body}");

        if (response?.statusCode == 200) {
          yield UpdateCompleteStatusState.completed(
              response: response?.body.toString() ?? "");
        } else {
          yield UpdateCompleteStatusState.error("Error");
        }
      }
      else if (event is GetUserAchievementDataPlusEvent) {
        Response? apiResponse =
            await myLearningRepository.getUserAchievementPlusData(
          userID: event.userID,
          siteID: event.siteID,
          locale: event.locale,
          gameID: event.gameID,
          componentInsID: event.componentInsID,
          componentID: event.componentID,
        );
        if (apiResponse?.statusCode == 200) {
          print(
              "GetUserAchievementDataPlusEvent Response:${apiResponse?.body}");

          Map valueMap = json.decode(apiResponse?.body ?? "{}");

          userAchievementResponse =
              UserAchievementResponse.fromJson(Map.castFrom(valueMap));

          yield GetUserAchievementDataPlusState.completed(
              userAchievementResponse: userAchievementResponse);
        } else if (apiResponse?.statusCode == 401) {
          yield GetUserAchievementDataPlusState.error('401');
        } else {
          yield GetUserAchievementDataPlusState.error('Something went wrong');
        }
      }
      else if (event is GetLeaderboardLearnPlusEvent) {
        yield GetLeaderboardLearnPlusState.loading('Please wait');
        Response? apiResponse =
            await myLearningRepository.getLearnPlusLeaderboardData(
          userID: event.userID,
          siteID: event.siteID,
          locale: event.locale,
          componentID: event.componentID,
          componentInsID: event.componentInsID,
          gameID: event.gameID,
        ); //event.jobroles);
        if (apiResponse?.statusCode == 200) {
          Map valueMap = json.decode(apiResponse?.body ?? "{}");

          leaderBoardResponse =
              LeaderBoardResponse.fromJson(Map.castFrom(valueMap));

          print(leaderBoardResponse.leaderBoardList);

          yield GetLeaderboardLearnPlusState.completed(
              leaderBoardResponse: leaderBoardResponse);
        } else if (apiResponse?.statusCode == 401) {
          yield GetLeaderboardLearnPlusState.error('401');
        } else {
          yield GetLeaderboardLearnPlusState.error('Something went wrong');
        }
      }
      else if (event is GetDynamicTabsPlusEvent) {
        yield GetDynamicTabsPlusState.loading('Please wait');
        List<Tab> tabList = [];
        Response? apiResponse = await myLearningRepository
            .getDynamicTabPlusEvent(event.componentid, event.componentinsid);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          var jsonArray =
              new List<dynamic>.from(jsonDecode(apiResponse?.body ?? "[]"));
          dynamicTabList = jsonArray
              .map((e) => new ConnectionDynamicTab.fromJson(e))
              .toList();
          print("REsponse ${apiResponse?.body.toString() ?? ""}");
          for (ConnectionDynamicTab tab in dynamicTabList) {
            tabList.add(new Tab(
              text: tab.mobileDisplayName,
            ));
          }
          tabList.add(new Tab(
            text: "Archive",
          ));
          yield GetDynamicTabsPlusState.completed(
              dynamicTabList: dynamicTabList, tabList: tabList);
        } else if (apiResponse?.statusCode == 401) {
          yield GetDynamicTabsPlusState.error('401');
        } else {
          yield GetDynamicTabsPlusState.error('Something went wrong');
        }
      }
      else if (event is GetMenuComponentsEvent) {
        try {
          yield GetMenuComponentsState.loading('Please wait');
          Response? apiResponse = (await myLearningRepository.getMenuComponents(
              event.menuid, event.menuUrl, event.roleId));
          if (apiResponse?.statusCode == 200) {
            isFirstLoading = false;

            MenuComponentsResponse componentsResponse =
                MenuComponentsResponse();
            //Map valueMap = json.decode(apiResponse?.body ?? "{}");
            componentsResponse =
                menuComponentsResponseFromJson(apiResponse?.body ?? "{}");

            // MenuComponentsResponse componentsResponse = menuComponentsResponseFromJson(apiResponse.data);
            print("Response  ${apiResponse?.body.toString() ?? ""}");
            yield GetMenuComponentsState.completed(
                menuresponse: componentsResponse);
          } else if (apiResponse?.statusCode == 401) {
            yield GetMenuComponentsState.error('401');
          } else {
            yield GetMenuComponentsState.error('Something went wrong');
          }
        } catch (e, st) {
          print("Om Error $e  stack trace $st");
        }
      }
      else if (event is GetGamelistLearnPlusEvent) {
        yield GetGameslistLearnPlusState.loading('Please wait');
        Response? apiResponse = await myLearningRepository.getGameLearnPlusList(
          componentID: event.componentID,
          componentInsID: event.componentInsID,
          fromAchievement: event.fromAchievement,
          gameID: event.gameID,
          leaderByGroup: event.leaderByGroup,
          locale: event.locale,
          siteID: event.siteID,
          userID: event.userID,
        );
        if (apiResponse?.statusCode == 200) {
          var jsonArray =
              new List<dynamic>.from(jsonDecode(apiResponse?.body ?? "[]"));
          gameslist =
              jsonArray.map((e) => MydashboardGameModel.fromJson(e)).toList();
          print("REsponse ${gameslist.length}");
          yield GetGameslistLearnPlusState.completed(
              message: apiResponse?.body.toString() ?? "");
        } else if (apiResponse?.statusCode == 401) {
          yield GetGameslistLearnPlusState.error('401');
        } else {
          yield GetGameslistLearnPlusState.error('Something went wrong');
        }
      }
    } catch (e, s) {
      print("Error in MyLearningBloc.mapEventToState():$e");
      print(s);
      //yield GetListState.error("Error  $e");
    }
  }

  String formatString(List x) {
    String formatted = '';
    for (var i in x) {
      formatted += '$i, ';
    }
    return formatted.replaceRange(formatted.length - 2, formatted.length, '');
  }

  Map<String, String> generateHashMap(List<String> conditionsArray) {
    Map<String, String> map = new Map();
    if (conditionsArray.length != 0) {
      for (int i = 0; i < conditionsArray.length; i++) {
        var filterArray = conditionsArray[i].split("=");
        //print(" forvalue   $filterArray");
        if (filterArray.length > 1) {
          map[filterArray[0]] = filterArray[1];
        }
      }
    } else {}
    return map;
  }

  List<ContentFilterByModel> generateContentFilters(LocalStr localStr) {
    List<ContentFilterByModel> contentFilterByModelList = [];
    if (contentFilterType != null && contentFilterType.length > 0) {
      List<String> filterCategoriesArray =
          getArrayListFromString(contentFilterType);

      if (filterCategoriesArray != null && filterCategoriesArray.length > 0) {
        for (int i = 0; i < filterCategoriesArray.length; i++) {
          ContentFilterByModel contentFilterByModel = ContentFilterByModel();
          switch (filterCategoriesArray[i]) {
            case "categories":
              contentFilterByModel.categoryName = filterCategoriesArray[i];
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "cat";
              contentFilterByModel.categoryDisplayName =
                  localStr.filterLblCaegoriestitlelabel;
              contentFilterByModel.goInside = true;
              break;
            case "skills":
              contentFilterByModel.categoryName = filterCategoriesArray[i];
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "skills";
              contentFilterByModel.categoryDisplayName =
                  localStr.filterLblByskills;
              contentFilterByModel.goInside = true;
              break;
            case "objecttypeid":
              contentFilterByModel.categoryName = filterCategoriesArray[i];
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "bytype";
              contentFilterByModel.categoryDisplayName =
                  localStr.filterLblContenttype;
              contentFilterByModel.goInside = false;
              break;
            case "jobroles":
            case "job":
              contentFilterByModel.categoryName = filterCategoriesArray[i];
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "jobroles";
              contentFilterByModel.categoryDisplayName =
                  localStr.filterLblJobrolesHeader;
              contentFilterByModel.goInside = false;
              break;
            case "solutions":
              contentFilterByModel.categoryName = filterCategoriesArray[i];
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "tag";
              contentFilterByModel.categoryDisplayName = localStr.filterLblTag;
              contentFilterByModel.goInside = false;
              break;
            case "rating":
              if (filterMenus != null &&
                  filterMenus.containsKey("ShowrRatings")) {
                String showrRatings = filterMenus["ShowrRatings"] ?? "";
                if (showrRatings.contains("true") &&
                    contentFilterByModelList.length > 0) {
                  contentFilterByModel.categoryName = "Show Ratings";
                  contentFilterByModel.categoryIcon = "";
                  contentFilterByModel.categoryID = "rate";
                  contentFilterByModel.categoryDisplayName =
                      localStr.filterLblRating;

                  contentFilterByModel.goInside = false;
                }
              }
              break;
            case "eventduration":
              if (filterMenus != null &&
                  filterMenus.containsKey("SprateEvents")) {
                String showrRatings = filterMenus["SprateEvents"] ?? "";
                if (showrRatings.contains("true") &&
                    contentFilterByModelList.length > 0) {
                  contentFilterByModel.categoryName = "SprateEvents";
                  contentFilterByModel.categoryIcon = "";
                  contentFilterByModel.categoryID = "duration";
                  contentFilterByModel.categoryDisplayName =
                      localStr.filterLblDuration;

                  contentFilterByModel.goInside = false;
                }
              }
              break;
            case "ecommerceprice":
              if (/*uiSettingsModel.isEnableEcommerce() &&*/ filterMenus !=
                      null /* &&
                  filterMenus.containsKey("EnableEcommerce")*/
                  ) {
                // String showrRatings = filterMenus["EnableEcommerce"];
                if (/*showrRatings.contains("true") &&*/ contentFilterByModelList
                        .length >
                    0) {
                  contentFilterByModel.categoryName = "EnableEcommerce";
                  contentFilterByModel.categoryIcon = "";
                  contentFilterByModel.categoryID = "price Range";
                  contentFilterByModel.categoryDisplayName =
                      localStr.filterLblPricerange;
                  contentFilterByModel.goInside = false;
                }
              }
              break;
            case "instructor":
              contentFilterByModel.categoryName = "Instructor";
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "inst";
              contentFilterByModel.categoryDisplayName =
                  localStr.filterLblInstructor;
              contentFilterByModel.goInside = false;
              break;
            case "certificate":
              break;
            case "eventdates":
              contentFilterByModel.categoryName = "Event dates";
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "eventdates";
              contentFilterByModel.categoryDisplayName =
                  localStr.filterLblEventdatedate;
              contentFilterByModel.goInside = false;
              break;
            case "creditpoints":
              contentFilterByModel.categoryName = "creditpoints";
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "creditpoints";
              contentFilterByModel.categoryDisplayName =
                  localStr.filterLblCredits;
              contentFilterByModel.goInside = false;
              break;
            case "learningprovider":
              contentFilterByModel.categoryName = "learningprovider";
              contentFilterByModel.categoryIcon = "";
              contentFilterByModel.categoryID = "learningprovider";
              contentFilterByModel.categoryDisplayName = 'Learning Provider';
              contentFilterByModel.goInside = false;
              break;
            //  https://learningapi.instancy.com/api/catalog/GetLearningProviderForFilter?instSiteID=374&instUserID=396&PrivacyType=public
          }
          if (contentFilterByModel.categoryID.length != 0) {
            contentFilterByModelList.add(contentFilterByModel);
          }
        }
//                ContentFilterByModel contentFilterByModel = new ContentFilterByModel();
//                contentFilterByModel.categoryName = "EnableEcommerce";
//                contentFilterByModel.categoryIcon = "";
//                contentFilterByModel.categoryID = "priceRange";
//                contentFilterByModel.categoryDisplayName = "PriceRange";
//                contentFilterByModelList.add(contentFilterByModel);
//                contentFilterByModel.goInside = false;

      }
    }
    return contentFilterByModelList;
  }

  List<String> getArrayListFromString(String questionCategoriesString) {
    List<String> questionCategoriesArray = [];

    if (questionCategoriesString.length <= 0) return questionCategoriesArray;

    questionCategoriesArray = questionCategoriesString.split(",");

    return questionCategoriesArray;
  }

  List<AllFilterModel> getAllFilterModelList(LocalStr localStr) {
    List<AllFilterModel> allFilterModelList = [];

    AllFilterModel advFilterModel = new AllFilterModel();
    advFilterModel.categoryName = localStr.filterLblFilterbytitlelabel;
    advFilterModel.categoryID = 1;
    allFilterModelList.add(advFilterModel);

    if (filterMenus != null && filterMenus.containsKey("EnableGroupby")) {
      String enableGroupby = filterMenus["EnableGroupby"] ?? "";
      if (enableGroupby != null && enableGroupby == "true") {
        AllFilterModel groupFilterModel = new AllFilterModel();
        groupFilterModel.categoryName = localStr.filterLblGroupbytitlelabel;
        groupFilterModel.categoryID = 2;
        groupFilterModel.isGroup = true;
        groupFilterModel.categorySelectedData = "";
        if (filterMenus != null && filterMenus.containsKey("ddlGroupby")) {
          String ddlGroupby = filterMenus["ddlGroupby"] ?? "";
          print("getAllFilterModelList: $ddlGroupby");
          groupFilterModel.groupArrayList = getArrayListFromString(ddlGroupby);

          if (groupFilterModel.groupArrayList != null &&
              groupFilterModel.groupArrayList.length > 0) {
            int i = 0;
            groupList.clear();
            groupFilterModel.groupArrayList.forEach((element) {
              SortModel sortModel = new SortModel();
              sortModel.optionIdValue = element;
              switch (element) {
                case "duedates":
                  sortModel.optionDisplayText = localStr.filterLblDuedates;
                  break;
                case "Job":
                  sortModel.optionDisplayText =
                      localStr.filterLblJobrolesHeader;
                  break;
                case "Skills":
                  sortModel.optionDisplayText = localStr.filterLblByskills;
                  break;
                case "ContentTypes":
                  sortModel.optionDisplayText = localStr.filterLblContenttype;
                  break;
                case "Categories":
                  sortModel.optionDisplayText =
                      localStr.filterLblCaegoriestitlelabel;
                  break;
                case "progress":
                  sortModel.optionDisplayText =
                      localStr.filterLblProgresstitlelabel;
                  break;
              }

              sortModel.categoryID = i;
              i++;
              groupList.add(sortModel);
            });

            allFilterModelList.add(groupFilterModel);
          }
        }
      }
    }

    if (filterMenus != null && filterMenus.containsKey("ContentFilterBy")) {
      String enableSortby = filterMenus["ContentFilterBy"] ?? "";
      if (enableSortby != null &&
          enableSortby.toLowerCase().contains("sortitemsby")) {
        AllFilterModel sortFilterModel = new AllFilterModel();
        sortFilterModel.categoryName = localStr.filterLblSortbytitlelabel;
        sortFilterModel.categoryID = 3;
        sortFilterModel.categorySelectedData = "";
        sortFilterModel.categorySelectedDataDisplay = "";
        allFilterModelList.add(sortFilterModel);
      }
    }

    return allFilterModelList;
  }

  Future<void> checkifFileExist(List<DummyMyCatelogResponseTable2> list) async {
    if(kIsWeb) return;

    String userId = await sharePrefGetString(sharedPref_userid);
    Map<String, bool> removedFromDownloadsMap = await MyLearningDownloadController().getRemovedFromDownloadMap();

    for (DummyMyCatelogResponseTable2 table2 in list) {
      if(removedFromDownloadsMap[table2.contentid] != true) {
        await downloadPath(table2.contentid, table2, userId);
      }
      else {
        table2.isdownloaded = false;
      }
      /*if(table2.isdownloaded) {
        await downloadPath(table2.contentid, table2, userId);
      }*/
    }
  }

  Future<void> downloadPath(String contentid, DummyMyCatelogResponseTable2 table2, String appUserId) async {
    String pathSeparator = Platform.pathSeparator;


    String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
        "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads" +
        "$pathSeparator" +
        contentid +
        '-' +
        appUserId;
    await checkFile(downloadDestFolderPath, table2);
  }

  Future<void> checkFile(String path, DummyMyCatelogResponseTable2 table2) async {
    print('checkdownloadedpath $path ${table2.videointroduction}');
    final savedDir = Directory(path);
    if (await savedDir.exists()) {
      table2.isdownloaded = true;
    }
    else {
      table2.isdownloaded = false;
    }
    print('ifmufileexsit ${table2.isdownloaded}');
  }

  Future<bool> fileExistCheck(DummyMyCatelogResponseTable2 table2, String appUserId) async {
    String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
        "/.Mydownloads/Contentdownloads" +
        "/" +
        table2.contentid +
        '-' +
        appUserId;
    final savedDir = Directory(downloadDestFolderPath);
    return (await savedDir.exists());
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

  bool checkfilterbyChild(categoryId) {
    bool haschild = false;

    mainFilterByList.forEach((element) {
      if (element.parentId == categoryId) {
        haschild = true;
      }
    });

    return haschild;
  }

  bool checkfilterbyLearnChild(learnid) {
    bool haschild = false;

    mainFilterByLearnList.forEach((element) {
      if (element.SiteID == learnid) {
        haschild = true;
      }
    });

    return haschild;
  }
}
