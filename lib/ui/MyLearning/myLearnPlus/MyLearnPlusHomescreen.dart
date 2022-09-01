// ignore_for_file: dead_code

import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/WishlistResponse.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/connection_dynamic_tab_response.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_leaderboardresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_userachivmentsresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/MyLearningPlusCatelogResponse.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/MyLearning/Assignmentcontentweb.dart';
import 'package:flutter_admin_web/ui/MyLearning/SendviaEmailMylearning.dart';
import 'package:flutter_admin_web/ui/MyLearning/common_detail_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunchContenisolation.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/models/DashGridResponse.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/models/EventResourcePlusResponse.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/models/MenuComponentsResponse.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/widgets/DashboardCalendarScreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/widgets/DashboardLeaderboardScreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/mylearning_filter.dart';
import 'package:flutter_admin_web/ui/MyLearning/progress_report.dart';
import 'package:flutter_admin_web/ui/MyLearning/qr_code_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/MyLearning/view_certificate.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/ui/common/bottomsheet_drager.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/ui/global_search_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyLearnPlusHomeScreen extends StatefulWidget {
  final NativeMenuModel nativeModel;
  final String contentId;

  const MyLearnPlusHomeScreen({
    required this.nativeModel,
    required this.contentId,
  });

  @override
  State<MyLearnPlusHomeScreen> createState() => MyLearnPlusHome();
}

class MyLearnPlusHome extends State<MyLearnPlusHomeScreen> with SingleTickerProviderStateMixin {
  var myLearningRepository;

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);

  late MyLearningDetailsBloc detailsBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  String typeFrom = '';

  String dropdownValue = '';

  String dropdownGameID = '1';

  bool isReportEnabled = true;

  UserAchievementResponse userAchievementResponse =
      UserAchievementResponse();
  double progress = 0.0;
  int pageNumber = 1;
  late FToast flutterToast;
  int pageArchiveNumber = 1;
  bool isGetArchiveListEvent = false;
  ScrollController _scArchive = ScrollController();

  int pos = 0;

  String downloadDestFolderPath = "";
  bool fileExists = false;

  bool isDownloaded = false;
  bool isDownloading = false;
  int downloadedProgress = 0;
  String contentId = '';
  bool isGetListEvent = false;

  late ProfileBloc profileBloc;

  final kCellThumbHeight = 150; //ScreenUtil.screenWidth < 600 ? 150 : 150;


  List<ConnectionDynamicTab> dynamicTabList = [];
  List<Tab> tabList = [];
  TabController? _tabController;
  String imgUrl =
      "https://www.insertcart.com/wp-content/uploads/2018/05/thumbnail.jpg";

  String currentTabStatus = 'Dashboard';
  ConnectionDynamicTab selectedTabObj = ConnectionDynamicTab();

//  List<CourseList> mylearningplusinprolist;
  List<DummyMyCatelogResponseTable2> myLearningPlusCompletedList = [];

  List<DashGridResponse> dashGridList = [];

  List<DummyMyCatelogResponseTable2> myLearningPlusInProList = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusNotStartProList = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusAttendProList = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusWaitProList = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusWishlist = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusDummyWishlist = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusDashDayWishlist = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusDashWeekList = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusDashMonthList = [];
  List<DummyMyCatelogResponseTable2> myLearningPlusDashFutureList = [];

  List<DummyMyCatelogResponseTable2> listArchiveList = [];

  late MenuComponentsResponse componentsResponse;

  String showPoints = "";
  String showBadges = "";
  String showLevels = "";
  String headerBackgroundColor = "";
  String headerTextColor = "";
  String bannerBackgroundType = "";
  String showAchievements = "";

  String dueDateListView = "";
  String dueDateCalendarView = "";
  String showLeaderboard = "";
  String showLevelDash = "";
  String showPointDash = "";
  String showBadgesDash = "";


  List<EventResourcePlusResponse> getEventResourceList = [];

  String dashTitle = 'Your Schedule';
  Color statusThickColor = const Color(0xff000000);
  Color statusLightColor = const Color(0xff000000);

  late EvntModuleBloc eventModuleBloc;
  DateTime timeInfo = DateTime.now();

  String lastOfDay = '';
  String startOfDay = '';

  late GeneralRepository generalRepository;
  GotoCourseLaunch? courseLaunch;
  String assignmentUrl = "";

  String globalCondition = 'grid';
  bool gridCond = true;
  bool calendarCond = false;
  bool leaderCond = false;
  String compId = ""; String compInstId = "";

  LeaderBoardResponse leaderBoardResponse = LeaderBoardResponse(leaderBoardList: []);

  @override
  void initState() {
    componentsResponse =  MenuComponentsResponse();
    contentId = widget.contentId;
    profileBloc = ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());

    generalRepository = GeneralRepositoryBuilder.repository();

    eventModuleBloc = EvntModuleBloc(
        eventModuleRepository: EventRepositoryBuilder.repository());

    detailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());




    myLearningBloc.add(GetGamelistLearnPlusEvent(
      gameID: '-1',
      locale: 'en-us',
      componentID: '315',  //'',
      componentInsID: '4232', //'',
      fromAchievement: true,
      leaderByGroup: '',
      siteID: '',
      userID: '',
    ));

    myLearningBloc.add(GetWaitListEvent(pageNumber: pageNumber,pageSize: 10));

    myLearningBloc.add(GetDynamicTabsPlusEvent(
        componentid: widget.nativeModel == NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0) ? '' : widget.nativeModel.componentId == ""
            ? ''
            : widget.nativeModel.componentId,
        componentinsid: widget.nativeModel == NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0) ? '' : widget.nativeModel.repositoryId
        //componentinsid: widget.nativeModel == null ? '' : '4232'
    ));

    myLearningBloc.add(GetFilterMenus(
        listNativeModel: appBloc.listNativeModel,
        localStr: appBloc.localstr,
        moduleName: 'My Learning'));

    _scArchive.addListener(() {
      if (_scArchive.position.pixels == _scArchive.position.maxScrollExtent) {
        if (isGetArchiveListEvent && isGetListEvent &&
            myLearningBloc.listArchiveTotalCount >
                myLearningBloc.listArchive.length) {
          setState(() {
            isGetArchiveListEvent = false;
             isGetListEvent = false;
          });
          myLearningBloc.add(GetArchiveListEvent(
              pageNumber: pageArchiveNumber, pageSize: 10, searchText: ""));
        }
      }
    });


    try{
      String parameter = widget.nativeModel.conditions == "" ? '' : widget.nativeModel.conditions;
      var dataSp = parameter.split('#@#');
      Map<String, String> mapData = Map();
      dataSp.forEach((element) =>
      mapData[element.split('=')[0]] =
      element.split('=')[1]);

      showPoints = mapData["showPoints"] ?? "";
      showBadges = mapData["showBadges"] ?? "";
      showLevels = mapData["showLevels"] ?? "";
      headerBackgroundColor = mapData["HeaderBackgroundColor"] ?? "";
      headerTextColor = mapData["HeaderTextColor"] ?? "";
      bannerBackgroundType = mapData["BannerBackgroundType"] ?? "";
      showAchievements = mapData["ShowAchievements"] ?? "";
    }catch(e){
      print('${e.toString()}');
    }
    // myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
    //     pageNumber: pageNumber, pageSize: 10, searchText: "",Contentstatus: 'grade,inprogress,not attempted,incomplete,registered'));

    DateTime lastdate = DateTime(timeInfo.year, timeInfo.month + 1, 0);
    lastOfDay = '${lastdate.year}-${lastdate.month}-${lastdate.day}';
    // lastofday = lastdate.toString();
    startOfDay = '${timeInfo.year}-${timeInfo.month + 0}-01';

    print('the start : $startOfDay}');
    print('the last : $lastOfDay}');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);	
    return Scaffold(
      body: BlocConsumer<MyLearningBloc, MyLearningState>(
        bloc: myLearningBloc,
        listener: (context, state) {
          if (state is GetGameslistLearnPlusState) {
            if (state.status == Status.COMPLETED) {
              dropdownValue = myLearningBloc.gameslist.isNotEmpty
                  ? myLearningBloc.gameslist[0].gameName
                  : "Select game";
              dropdownGameID = myLearningBloc.gameslist.isNotEmpty
                  ? "${myLearningBloc.gameslist[0].gameID}"
                  : "1";
            } else if (state.status == Status.ERROR) {}
          } else if (state is GetListState) {
            if (state.status == Status.COMPLETED) {
//            print('List size ${state.list.length}');
              if (appBloc.uiSettingModel.isFromPush) {
                print(
                    'Data data : ${myLearningBloc.list.length}');
                myLearningBloc.list.asMap().forEach((i, element) {
                  if (element.contentid == contentId) {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => CommonDetailScreen(
                              screenType: ScreenType.MyLearning,
                              contentid: contentId,
                              objtypeId: element.objecttypeid,
                              detailsBloc: detailsBloc,
                              table2: element,
                              pos: i,
                              mylearninglist: myLearningBloc.list,
                              isFromReschedule: false,
                            ),
                          ),
                        )
                        .then((value) => {
                              if (value ?? true)
                                {
                                  appBloc.uiSettingModel
                                      .setIsFromPush(false),
                                  contentId = '',
                                  myLearningBloc.add(GetListEvent(
                                      pageNumber: pageNumber,
                                      pageSize: 10,
                                      searchText: myLearningBloc.searchMyCourseString))
                                }
                            });
                  }
                });
              }
              setState(() {
                isGetListEvent = true;
                pageNumber++;
              });
            } else if (state.status == Status.ERROR) {
              //if (state.message == '401') {
                AppDirectory.sessionTimeOut(context);
             // }
            }
          }
          else if (state is GetArchiveListState) {
            if (state.status == Status.COMPLETED) {
//            print("List size ${state.list.length}");
             // listArchiveList = [];
              listArchiveList = myLearningBloc.listArchive;
              print('archieve list length : ${listArchiveList.length}');
              setState(() {
                isGetArchiveListEvent = true;
                pageArchiveNumber++;
              });
            } else if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
              if (state.message == "401") {
                AppDirectory.sessionTimeOut(context);
              }
            }
          } else if (state is RemovetoArchiveCallState) {
            if (state.status == Status.COMPLETED) {
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: appBloc
                        .localstr.mylearningAlertsubtitleUnarchivedsuccesfully),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );

              //myLearningBloc.isArchiveFirstLoading = true;
              myLearningBloc.isFirstLoading = true;
              setState(() {
                pageNumber = 1;
                //pageArchiveNumber = 1;
              });
              /* myLearningBloc.add(GetArchiveListEvent(
            pageNumber: pageArchiveNumber, pageSize: 10, searchText: ""));*/
              myLearningBloc.add(GetListEvent(
                  pageNumber: pageNumber, pageSize: 10, searchText: ""));
            } else if (state.status == Status.ERROR) {
              if (state.message == "401") {
                AppDirectory.sessionTimeOut(context);
              }
            }
          }
          else if(state is AddtoArchiveCallState){
            if(state.status == Status.COMPLETED){
             flutterToast.showToast(
              child: CommonToast(displaymsg: 'Added to Archive.'),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
              myLearningBloc.isFirstLoading = true;
              setState(() {
                pageNumber = 1;
                //pageArchiveNumber = 1;
              });

              myLearningBloc.add(GetListEvent(
                  pageNumber: pageNumber, pageSize: 10, searchText: ""));

            }
            else if (state.status == Status.ERROR) {
              if (state.message == "401") {
                AppDirectory.sessionTimeOut(context);
              }
            }
          }



          // else if (state is GetMenuComponentsState) {
          //   if (state.status == Status.COMPLETED) {
          //     componentsResponse = state.menuresponse;
          //     String paramstr = componentsResponse.table1[0].parameterString;
          //     var dataSp = paramstr.split('&');
          //     Map<String, String> mapData = Map();
          //     dataSp.forEach((element) =>
          //     mapData[element.split('=')[0]] =
          //     element.split('=')[1]);
          //      showPoints = mapData["showPoints"];
          //      showBadges = mapData["showBadges"];
          //      showLevels = mapData["showLevels"];
          //      HeaderBackgroundColor = mapData["HeaderBackgroundColor"];
          //      HeaderTextColor = mapData["HeaderTextColor"];
          //      BannerBackgroundType = mapData["BannerBackgroundType"];
          //     String ss = "";
          //   } else if (state.status == Status.ERROR) {
          //     componentsResponse = new MenuComponentsResponse();
          //   }
          // }
          else if (state is GetUserAchievementDataPlusState) {
            if (state.status == Status.COMPLETED) {
              userAchievementResponse = state.userAchievementResponse;
              //progress = (userAchievementResponse.userOverAllData.overAllPoints)/(userAchievementResponse.userOverAllData.overAllPoints + userAchievementResponse.userOverAllData.neededPoints)*100;
            } else if (state.status == Status.ERROR) {
              userAchievementResponse = UserAchievementResponse();
            }
          }else if(state is GetFilterMenusState){
            if(state.status == Status.COMPLETED){
              myLearningBloc.isFilterMenu = true;
            }
           }
           else if (state is GetDynamicTabsPlusState) {
            if (state.status == Status.COMPLETED) {
              dynamicTabList = state.dynamicTabList;
              tabList = state.tabList;
              ConnectionDynamicTab dynamicTabobj = ConnectionDynamicTab();
              dynamicTabobj.tabId = "Archive";
              dynamicTabobj.mobileDisplayName = "Archive";
              dynamicTabobj.parameterString = 'sree = sds&dsd = dsds&ds = dsd';
              dynamicTabList.add(dynamicTabobj);
              _tabController = TabController(
                  length: dynamicTabList.length, vsync: this);
              print("Build level tabList ${tabList.length}  ${dynamicTabList.length}");
              // tabList.add(dynamicTabobj);

              for (ConnectionDynamicTab tab in dynamicTabList) {

                if (tab.tabId == 'Dashboard') {

                  //  ApicallingByinput(tab.tabId,'');

                  String parameter = tab.parameterString;
                  var dataSp = parameter.split('&');
                  Map<String, String> mapData = Map();
                  dataSp.forEach((element) =>
                  mapData[element.split('=')[0]] =
                  element.split('=')[1]);
                  String filterContentType = mapData["FilterContentType"] ?? "";
                  dueDateListView = mapData["DueDateListView"] ?? "";
                  dueDateCalendarView = mapData["DueDateCalendarView"] ?? "";
                  showLeaderboard = mapData["ShowLeaderboard"] ?? "";
                  showLevelDash = mapData["ShowLevel"] ?? "";
                  showPointDash = mapData["ShowPoint"] ?? "";
                  showBadgesDash = mapData["ShowBadges"] ?? "";

                  if(dueDateListView == "false"){
                    if(dueDateCalendarView == "false"){
                      if(showLeaderboard == "false"){
                        gridCond = false;
                        calendarCond = false;
                        leaderCond = false;
                        globalCondition = '';
                        dashTitle = '';
                      }else{
                        gridCond = false;
                        calendarCond = false;
                        leaderCond = true;
                        globalCondition = 'lead';
                        dashTitle = 'Leaderboard';
                      }
                    }else {
                      gridCond = false;
                      calendarCond = true;
                      leaderCond = false;
                      globalCondition = 'cal';
                      dashTitle = 'Your Schedule';
                    }
                  }else {
                    gridCond = true;
                    calendarCond = false;
                    leaderCond = false;
                    globalCondition = 'grid';
                    dashTitle = 'Your Schedule';
                  }

                  myLearningBloc.add(GetUserAchievementDataPlusEvent(
                    gameID: '3',
                    locale: 'en-us',
                    componentID: widget.nativeModel.componentId,
                    componentInsID: widget.nativeModel.repositoryId,
                    //componentInsID: '4232',
                    siteID: '374',
                    userID: '',
                  ));

                  myLearningBloc.add(GetLeaderboardLearnPlusEvent(
                    gameID: '3',
                    locale: 'en-us',
                    componentID: widget.nativeModel.componentId,
                    componentInsID: widget.nativeModel.repositoryId,
                    //componentInsID: '4232',
                    siteID: '',
                    userID: '',
                  ));

                  // myLearningBloc.add(GetEventResourceCalEvent(
                  //     componentinsid: widget.nativeModel.repositoryId,
                  //     //componentinsid: '4232',
                  //     componentid: widget.nativeModel.componentId,
                  //     enddate: '2021-12-01',
                  //     startdate: '2021-11-01',
                  //     eventid: '',
                  //     multiLocation: '',
                  //     objecttypes:'$FilterContentType'));
                  myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
                      pageNumber: pageNumber,
                      pageSize: 10,
                      searchText: '',
                      isWishlistCount: 0,
                      isWait: false,
                      dateFilter: 'today',
                      contentStatus: '',
                      componentId: tab.componentId, //'316',
                      componentInsId: tab.tabComponentInstanceId, //'4233',
                      //componentid: '316',componentInsId: '4233',
                      objectTypeId: '$filterContentType',
                      type: 'today'));

                  myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
                      pageNumber: pageNumber,
                      pageSize: 10,
                      searchText: "",
                      isWishlistCount: 0,
                      isWait: false,
                      dateFilter: 'thisweek',
                      componentId: tab.componentId, //'316',
                      componentInsId: tab.tabComponentInstanceId, //'4233',
                      //componentid: '316',componentInsId: '4233',
                      contentStatus: '',
                      objectTypeId: '$filterContentType',
                      type: 'thisweek'));

                  myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
                      pageNumber: pageNumber,
                      pageSize: 10,
                      searchText: '',
                      isWishlistCount: 0,
                      isWait: false,
                      dateFilter: 'thismonth',
                      componentId: tab.componentId, //'316',
                      componentInsId: tab.tabComponentInstanceId, //'4233',
                      //componentid: '316',componentInsId: '4233',
                      objectTypeId: '$filterContentType',
                      contentStatus: '',
                      type: 'thismonth'));

                  myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
                      pageNumber: pageNumber,
                      pageSize: 10,
                      searchText: '',
                      isWishlistCount: 0,
                      isWait: false,
                      dateFilter: 'future',
                      componentId: tab.componentId, //'316',
                      componentInsId: tab.tabComponentInstanceId, //'4233',
                     // componentid: '316',componentInsId: '4233',
                      objectTypeId: '$filterContentType',
                      contentStatus: '',
                      type: 'future'));
                }

                // if (tab.tabId == 'NotStarted') {
                //   HashMap<String, String> map =
                //       new HashMap<String, String>();
                //   String parameter = tab.parameterString;
                //   var dataSp = parameter.split('&');
                //   Map<String, String> mapData = Map();
                //   dataSp.forEach((element) =>
                //       mapData[element.split('=')[0]] =
                //           element.split('=')[1]);
                //   String contentstatus = mapData["contentstatus"];
                //   myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
                //       pageNumber: pageNumber,
                //       pageSize: 100,
                //       searchText: "",
                //       Contentstatus: contentstatus,
                //       componentid: widget.nativeModel.componentId,
                //       componentInsId: widget.nativeModel.repositoryId,
                //       //componentInsId: '4232',
                //       iswait: false,
                //       iswishlistcount: 0,
                //       Datefilter: "",
                //       type: 'NotStarted'));
                // }
                // if (tab.tabId == 'MyWishList') {
                //   List<WishListTable> WishListDetails = appBloc.wishlistResponse.WishListDetails;
                //   for(WishListTable table in WishListDetails){
                //     myLearningBloc.add(GetWishListPlusEvent(
                //         pageIndex: pageNumber, categaoryID: 0,type: 'plus',compid: table.componentid,compinsid: table.componentinstanceid));
                //   }
                // }
                // if (tab.tabId == 'WaitingList') {
                //   HashMap<String, String> map =
                //       new HashMap<String, String>();
                //   String parameter = tab.parameterString;
                //   var dataSp = parameter.split('&');
                //   Map<String, String> mapData = Map();
                //   dataSp.forEach((element) =>
                //       mapData[element.split('=')[0]] =
                //           element.split('=')[1]);
                //   String contentstatus = mapData["contentstatus"];
                //   myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
                //       pageNumber: pageNumber,
                //       pageSize: 100,
                //       searchText: "",
                //       iswishlistcount: 0,
                //       Contentstatus: contentstatus,
                //       iswait: true,
                //       Datefilter: "",
                //       type: 'waitlist'));
                // }
                // if (tab.tabId == 'Attending') {
                //   HashMap<String, String> map =
                //       new HashMap<String, String>();
                //   String parameter = tab.parameterString;
                //   var dataSp = parameter.split('&');
                //   Map<String, String> mapData = Map();
                //   dataSp.forEach((element) =>
                //       mapData[element.split('=')[0]] =
                //           element.split('=')[1]);
                //   String contentstatus = mapData["contentstatus"];
                //   myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
                //       pageNumber: pageNumber,
                //       pageSize: 100,
                //       searchText: "",
                //       Contentstatus: contentstatus,
                //       iswait: false,
                //       iswishlistcount: 0,
                //       Datefilter: "",
                //       type: 'attending'));
                // }
                //
                // if (tab.tabId == 'InProgress') {
                //   HashMap<String, String> map =
                //       new HashMap<String, String>();
                //   String parameter = tab.parameterString;
                //   var dataSp = parameter.split('&');
                //   Map<String, String> mapData = Map();
                //   dataSp.forEach((element) =>
                //       mapData[element.split('=')[0]] =
                //           element.split('=')[1]);
                //   String contentstatus = mapData["contentstatus"];
                //   myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
                //       pageNumber: pageNumber,
                //       pageSize: 100,
                //       searchText: "",
                //       iswishlistcount: 0,
                //       iswait: false,
                //       Datefilter: "",
                //       Contentstatus: contentstatus,
                //       type: 'inprogress'));
                // }
                // if (tab.tabId == 'Completed') {
                //   HashMap<String, String> map =
                //       new HashMap<String, String>();
                //   String parameter = tab.parameterString;
                //   var dataSp = parameter.split('&');
                //   Map<String, String> mapData = Map();
                //   dataSp.forEach((element) =>
                //       mapData[element.split('=')[0]] =
                //           element.split('=')[1]);
                //   String contentstatus = mapData["contentstatus"];
                //   myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
                //       pageNumber: pageNumber,
                //       pageSize: 100,
                //       searchText: "",
                //       iswishlistcount: 0,
                //       Datefilter: "",
                //       iswait: false,
                //       Contentstatus: contentstatus,
                //       type: 'completed'));
                // }
                // if (tab.tabId == 'Archive') {
                //
                //   myLearningBloc.add(GetArchiveListEvent(
                //       pageNumber: pageArchiveNumber, pageSize: 10, searchText:''));
                //
                // }
              }



            } else if (state.status == Status.ERROR) {
              userAchievementResponse = UserAchievementResponse();
            }
          } else if (state is GetWishListPlusState) {
            if (state.status == Status.COMPLETED) {
              //mylearningplusdummyWishlist = [];
             // mylearningplusWishlist = [];
              myLearningPlusDummyWishlist = myLearningBloc.catalogCatgoryWishlist;
             // mylearningplusWishlist = myLearningBloc.catalogCatgoryWishlist;
              if (myLearningPlusDummyWishlist.isNotEmpty) {
                myLearningPlusWishlist.addAll(myLearningPlusDummyWishlist);
              }
              print(
                  'The wish list count is : ${myLearningPlusWishlist.length}');
            } else if (state.status == Status.ERROR) {
              myLearningPlusWishlist = [];
            }
          } else if (state is GetMyLearnPlusLearningObjectsState) {
            if (state.status == Status.COMPLETED) {
             // print("SUCCESSCOMPLETED ${state.list[0].datefilter}");
             // print("SUCCESSCOMPLETED -----${state.list[0].actualstatus} ${state.list[0].datefilter}");
             // mylearningplusinprolist = state.list;

            //  if (state.status == Status.COMPLETED) {
            //   dashgridlist = [];
            //   mylearningplusdashdayWishlist = state.list;
            //   DashGridResponse gridResponse = new DashGridResponse();
            //   gridResponse.title = 'Future';
            //   gridResponse.dashcommonlist = mylearningplusdashdayWishlist;
            //   dashgridlist.add(gridResponse);
            // } else if (state.status == Status.ERROR) {
            //   mylearningplusdashdayWishlist = [];
            // }

            myLearningPlusCompletedList = [];//mylearningplusWishlist = [];
            //
              // mylearningpluscompletedlist = state.list;
              if(state.list.isNotEmpty && (state.list[0].actualstatus == "completed" || state.list[0].actualstatus == "registered") && (state.list[0].datefilter == "today" || state.list[0].datefilter == "thisweek" || state.list[0].datefilter == "thismonth" || state.list[0].datefilter == "future")){ // Dashbaord
              // dashgridlist = [];
             // mylearningplusdashdayWishlist = state.list;
             //if(state.list.length > 1){
             //state.list.forEach((element) {
              DashGridResponse gridResponse = DashGridResponse();
              gridResponse.dashcommonlist.addAll(state.list);
               print("gridResponse length ${gridResponse.dashcommonlist}");
             // if(!dashgridlist.contains(gridResponse))
              dashGridList.add(gridResponse);
              print("dashgrid length ${dashGridList.length}");

             //});
             //}
            //  else{
            //   DashGridResponse gridResponse = new DashGridResponse();
            //   gridResponse.dashcommonlist = state.list;
            //    print("gridResponse length ${gridResponse.dashcommonlist}");
            //  // if(!dashgridlist.contains(gridResponse))
            //   dashgridlist.add(gridResponse);
            //   print("dashgrid length ${dashgridlist.length}");

            //  }

              //gridResponse.title = 'In the Future';
              //dashtitle = 'In the Future';


            }
            else if (state.list.isNotEmpty && ((state.list[0].actualstatus == "completed") || (state.list[0].actualstatus == "passed") || (state.list[0].actualstatus == "failed"))) { //Completed
                myLearningPlusCompletedList.addAll(state.list);
             }
             else if(state.list.isNotEmpty && state.list[0].actualstatus == "incomplete"){ //In Progress ("inprogress,incomplete,grade")
             //mylearningplusinprolist.clear();
             myLearningPlusInProList = state.list;
             }
             else if(state.list.isNotEmpty && (state.list[0].actualstatus == "not attempted" || state.list[0].actualstatus == "registered")){ //Not started
             myLearningPlusNotStartProList = state.list;
             }
             else if(state.list.isNotEmpty && ((state.list[0].actualstatus == "attended") || (state.list[0].actualstatus == "notattended"))){  //Attending
             myLearningPlusAttendProList = state.list;
             }
            else if(state.list.isNotEmpty && (state.list[0].datefilter == "today" || state.list[0].datefilter == "thisweek" || state.list[0].datefilter == "future")){ // Dashbaord //state.list[0].datefilter == "thismonth" ||
               //dashgridlist = [];
              myLearningPlusDashDayWishlist = state.list;
              DashGridResponse gridResponse = DashGridResponse();
              //gridResponse.title = 'In the Future';
              //dashtitle = 'In the Future';
              gridResponse.dashcommonlist = myLearningPlusDashDayWishlist;
              dashGridList.add(gridResponse);
            }
            else if (state.status == Status.ERROR) {
              //print("ERROR FROM API ${state.list}");
              myLearningPlusInProList = [];
            }
            }
             else if (state.status == Status.ERROR) {
              print("ERROR FROM API ${state.list}");
              myLearningPlusInProList = [];
            }
          } else if (state
              is GetMyLearnPlusLearningObjectsNotStartedState) {
            if (state.status == Status.COMPLETED) {
              myLearningPlusNotStartProList = state.list;
            } else if (state.status == Status.ERROR) {
              myLearningPlusNotStartProList = [];
            }
          } else if (state is GetMyLearnPlusLearningObjectsCompleteState) {
            if (state.status == Status.COMPLETED) {

              myLearningPlusCompletedList = [];//mylearningplusWishlist = [];
              myLearningPlusCompletedList = state.list;
              if (myLearningPlusCompletedList.isNotEmpty) {
                myLearningPlusCompletedList.addAll(myLearningPlusCompletedList);
              }
              // mylearningpluscompletedlist = [];
              // mylearningpluscompletedlist.addAll(state.list);
              // //mylearningpluscompletedlist = state.list;
            } else if (state.status == Status.ERROR) {
             // print("ERROR FROM API ${state.list}");
              myLearningPlusCompletedList = [];
            }
          } else if (state is GetMyLearnPlusLearningObjectsAttendState) {
            if (state.status == Status.COMPLETED) {
              myLearningPlusAttendProList = state.list;
            } else if (state.status == Status.ERROR) {
              myLearningPlusAttendProList = [];
            }
          } else if (state is GetWaitListState) {
            if (state.status == Status.COMPLETED) {
              myLearningPlusWaitProList = state.list;
            } else if (state.status == Status.ERROR) {
              myLearningPlusWaitProList = [];
            }
          }
           else if (state is GetMyLearnPlusLearningObjectsDashdayState) {
            if (state.status == Status.COMPLETED) {
              dashGridList = [];
              myLearningPlusDashDayWishlist = state.list;
              DashGridResponse gridResponse = DashGridResponse();
              gridResponse.title = 'Today';
              gridResponse.dashcommonlist = myLearningPlusDashDayWishlist;
              dashGridList.add(gridResponse);
            } else if (state.status == Status.ERROR) {
              myLearningPlusDashDayWishlist = [];
            }
          } else if (state is GetMyLearnPlusLearningObjectsDashWeekState) {
            if (state.status == Status.COMPLETED) {
              myLearningPlusDashWeekList = state.list;
              DashGridResponse gridResponse = DashGridResponse();
              gridResponse.title = 'This Week';
              gridResponse.dashcommonlist = myLearningPlusDashWeekList;
              dashGridList.add(gridResponse);
            } else if (state.status == Status.ERROR) {
              myLearningPlusDashWeekList = [];
            }
          } else if (state is GetMyLearnPlusLearningObjectsDashMonthState) {
            if (state.status == Status.COMPLETED) {
              myLearningPlusDashMonthList = state.list;
              DashGridResponse gridResponse = DashGridResponse();
              gridResponse.title = 'This Month';
              gridResponse.dashcommonlist = myLearningPlusDashMonthList;
              dashGridList.add(gridResponse);
            } else if (state.status == Status.ERROR) {
              myLearningPlusDashMonthList = [];
            }
          } else if (state
              is GetMyLearnPlusLearningObjectsDashFutureState) {
            if (state.status == Status.COMPLETED) {
              myLearningPlusDashFutureList = state.list;
              DashGridResponse gridResponse = DashGridResponse();
              gridResponse.title = 'In The Future';
              gridResponse.dashcommonlist = myLearningPlusDashFutureList;
              dashGridList.add(gridResponse);
            } else if (state.status == Status.ERROR) {
              myLearningPlusDashFutureList = [];
            }
          } else if (state is GetLeaderboardLearnPlusState) {
            if (state.status == Status.COMPLETED) {
              leaderBoardResponse = state.leaderBoardResponse;
            } else if (state.status == Status.ERROR) {
              leaderBoardResponse = LeaderBoardResponse(leaderBoardList: []);
            }
          } else if (state is GetMyLearnPlusEventResourceState) {
            if (state.status == Status.COMPLETED) {
              getEventResourceList = state.list;
              String ss = "";
            } else if (state.status == Status.ERROR) {
              getEventResourceList = [];
            }
          }else if (state is CourseTrackingState) {
            if (state.status == Status.COMPLETED) {
              print(state.response);
               myLearningBloc.add(GetListEvent(pageNumber: 1, pageSize: 10, searchText: myLearningBloc.searchMyCourseString));
              if (isValidString(state.response)) {
                myLearningBloc.add(TokenFromSessionIdEvent(
                    table2: state.table2,
                    contentID: state.table2.contentid,
                    objecttypeId: "${state.table2.objecttypeid}",
                    userID: "${state.table2.objecttypeid}",
                    courseName: "${state.table2.name}",
                    courseURL: state.courseUrl,
                    learnerSCOID: "${state.table2.scoid}",
                    learnerSessionID: state.response.toString()));
              }
            } else if (state.status == Status.ERROR) {
              if (state.message == "401") {
                AppDirectory.sessionTimeOut(context);
              }
            }
          }else if (state is TokenFromSessionIdState) {
            if (state.status == Status.COMPLETED) {
               myLearningBloc.add(GetListEvent(pageNumber: 1, pageSize: 10, searchText: myLearningBloc.searchMyCourseString));
              if (isValidString(state.response) &&
                  state.response.contains('failed')) {
                launchCourse(state.table2, context, true, tabInfo: ConnectionDynamicTab());
              } else {
                launchCourseContentisolation(
                    state.table2, context, state.response.toString());
              }
            } else if (state.status == Status.ERROR) {
              if (state.message == "401") {
                AppDirectory.sessionTimeOut(context);
              }
            }
          }
          // else if (state is SetCompleteState) {
          //         if (state.status == Status.LOADING) {
          //           flutterToast.showToast(
          //             child: CommonToast(displaymsg: 'Please wait'),
          //             gravity: ToastGravity.BOTTOM,
          //             toastDuration: Duration(seconds: 2),
          //           );
          //         } else if (state.status == Status.COMPLETED) {
          //           flutterToast.showToast(
          //             child: CommonToast(
          //                 displaymsg: 'Course completed successfully'),
          //             gravity: ToastGravity.BOTTOM,
          //             toastDuration: Duration(seconds: 2),
          //           );
          //           setState(() {
          //             myLearningBloc.isFirstLoading = true;
          //             pageNumber = 1;
          //             myLearningBloc.add(GetListEvent(
          //                 pageNumber: pageNumber,
          //                 pageSize: 10,
          //                 searchText: myLearningBloc.SearchMyCourseString));
          //           });
          //         } else if (state.status == Status.ERROR) {
          //           flutterToast.showToast(
          //             child: CommonToast(
          //                 displaymsg: 'Filed to update course status'),
          //             gravity: ToastGravity.BOTTOM,
          //             toastDuration: Duration(seconds: 2),
          //           );
          //         }
          //       }
        },
        builder: (context, state) {
          if (state.status == Status.LOADING || _tabController == null) {
            return Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  ),
                  size: 70,
                ),
              ),
            );
          }
          return SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        (userAchievementResponse.userOverAllData != null)
                            ? showAchievements == "true" ? getAppBarView(context, userAchievementResponse):Container()
                            : Container(),
                          Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: TabBar(
                              isScrollable: dynamicTabList.length > 3 ? true : false,
                              controller: _tabController,
                              unselectedLabelColor: Colors.black,
                              indicatorColor: Color(int.parse("0xFF1D293F")),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.black,
                              onTap: (index){
                                currentTabStatus = dynamicTabList[index].tabId;
                                String selectedTab = dynamicTabList[index].tabId;
                                selectedTabObj = dynamicTabList[index];
                                if (currentTabStatus == 'Dashboard') {
                                  apiCallingByInput(currentTabStatus,'',dynamicTabList[index]);
                                }
                                if (currentTabStatus == 'NotStarted') {
                                  myLearningPlusNotStartProList = [];
                                  apiCallingByInput(currentTabStatus,'',dynamicTabList[index]);
                                }
                                if (currentTabStatus == 'MyWishList') {
                                  apiCallingByInput(currentTabStatus,'',dynamicTabList[index]);
                                }
                                if (currentTabStatus == 'WaitingList') {
                                  apiCallingByInput(currentTabStatus,'',dynamicTabList[index]);
                                }
                                if (currentTabStatus == 'Attending') {
                                  apiCallingByInput(currentTabStatus,'',dynamicTabList[index]);
                                }

                                if (currentTabStatus == 'InProgress') {
                                  myLearningPlusInProList.clear();
                                  apiCallingByInput(currentTabStatus,'',dynamicTabList[index]);
                                }
                                if (currentTabStatus == 'Completed') {
                                  apiCallingByInput(currentTabStatus,'',dynamicTabList[index]);
                                }
                                if (currentTabStatus == 'Archive') {
                                  apiCallingByInput(currentTabStatus,'',dynamicTabList[index]);
                                }
                                //  ApicallingByinput(tab.tabId,'');
                              },
                              tabs: tabList),
                        ),
                       // (dynamicTabList.isNotEmpty) ?
                             Expanded(
                                child: Container(height: 100,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: getList(),
                                    physics: const NeverScrollableScrollPhysics(),//PageScrollPhysics(),
                                  ),
                                ),
                              )//: SizedBox(),

                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

   List<Widget> getList(){
    if(dynamicTabList.isNotEmpty){
     return dynamicTabList.map((ConnectionDynamicTab element) {
        print('keytabb ${element.mobileDisplayName}');
        print("getList length ${tabList.length}  ${dynamicTabList.length}");
        return tabWiseScreen(element);
      }).toList();
     }
    //return Container();
     return [
       tabWiseScreen(ConnectionDynamicTab(componentId: "",componentName: "",displayIcon: "",displayName: "",mobileDisplayName: "",parameterString: "",tabComponentInstanceId: "",tabId: ""))
     ];
  }

  Future<void> launchCourseContentisolation(DummyMyCatelogResponseTable2 table2,
      BuildContext context, String token) async {
    print('helllllllllloooooo');

    /// refresh the content

    if (table2.objecttypeid == 8 ||
        table2.objecttypeid == 9 ||
        table2.objecttypeid == 10 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 102 ||
        //table2.objecttypeid == 694 ||
        table2.objecttypeid == 26) {
      String paramsString = "";
      if (table2.objecttypeid == 10 && table2.bit5) {
        paramsString = "userID=${table2.userid}&scoid=${table2.scoid}&TrackObjectTypeID=${table2.objecttypeid}&TrackContentID=${table2.contentid}&TrackScoID=${table2.scoid}&SiteID=${table2.siteid}&OrgUnitID=${table2.siteid}&isonexist=onexit";
      } else {
        paramsString = "userID=${table2.userid}&scoid=${table2.scoid}";
      }

      if (token.isNotEmpty) {
        String courseUrl;
        if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
          courseUrl = "${appBloc.uiSettingModel.azureRootPath}content/index.html?coursetoken=$token&TokenAPIURL=${ApiEndpoints.appAuthURL}";

          // assignmenturl = await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}';
        } else {
          courseUrl = "${ApiEndpoints.strSiteUrl}content/index.html?coursetoken=$token&TokenAPIURL=${ApiEndpoints.appAuthURL}";

          //assignmenturl = await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}';
        }

        if (table2.objecttypeid == 26) {
          // assignmenturl = await '$assignmenturl/ismobilecontentview/true';
          // print('assignmenturl is : $assignmenturl');
          await Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) =>
                  InAppWebCourseLaunch(courseUrl, table2)));
        } else {
          // assignmenturl = await '$assignmenturl/ismobilecontentview/true';
          //print('assignmenturl is : $assignmenturl');
          HashMap<String, String> map = HashMap<String, String>();
          String parameter = selectedTabObj.parameterString;
          var dataSp = parameter.split('&');
          Map<String, String> mapData = Map();
          String contentstatus = "";

          await Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) =>
                  InAppWebCourseLaunch(courseUrl, table2)))
              .then((value) => {
            if (value)
              {
                if(compId != "" && compInstId != ""){
                if((table2.actualstatus == "not attempted" || table2.actualstatus == "registered")) myLearningPlusNotStartProList.remove(table2) else myLearningPlusInProList.remove(table2),
                      dataSp.forEach((element) =>
                      mapData[element.split('=')[0]] =
                      element.split('=')[1]),
                      contentstatus = mapData["contentstatus"] ?? "",
                      myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
                      pageNumber: 1, //pageNumber,
                      pageSize: 10,
                      searchText: "",
                      contentStatus: contentstatus,
                      componentId: compId,  //widget.nativeModel.componentId,
                      componentInsId: compInstId,  //widget.nativeModel.repositoryId,
                      //componentInsId: '4232',
                      isWait: false,
                      isWishlistCount: 0,
                      dateFilter: "",
                      type: (table2.actualstatus == "not attempted" || table2.actualstatus == "registered") ? 'NotStarted' : (table2.actualstatus == "incomplete") ?  "InProgress" : "")),
                     }
              }
          });
        }
         // myLearningBloc.add(GetListEvent(
                //     pageNumber: 1, pageSize: 10, searchText: ""))
     //   logger.d(".....Refresh Me....${courseUrl}");

        /// Refresh Content Of My Learning

      }

      String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      String url =
          "$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString";

      detailsBloc.add(GetContentStatus(url: url, table2: table2));
      myLearningBloc.add(GetListEvent(pageNumber: 1, pageSize: 10, searchText: myLearningBloc.searchMyCourseString));
    }
  }

  apiCallingByInput(String input,String searchValue,ConnectionDynamicTab tab){ // Widget?
    try {
      if (input == 'Archive') {
        myLearningBloc.add(GetArchiveListEvent(
            pageNumber: pageArchiveNumber, pageSize: 10, searchText:''));
      }
      if(input == 'NotStarted'){
        HashMap<String, String> map = HashMap<String, String>();
        String parameter = selectedTabObj.parameterString;
        var dataSp = parameter.split('&');
        Map<String, String> mapData = Map();
        dataSp.forEach((element) =>
        mapData[element.split('=')[0]] =
        element.split('=')[1]);
        String contentstatus = mapData["contentstatus"] ?? "";
        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: 1, //pageNumber,
            pageSize: 10,
            searchText: searchValue,
            contentStatus: contentstatus,
            componentId: tab.componentId,  //widget.nativeModel.componentId,
            componentInsId: tab.tabComponentInstanceId,  //widget.nativeModel.repositoryId,
            //componentInsId: '4232',
            isWait: false,
            isWishlistCount: 0,
            dateFilter: "",
            type: 'NotStarted'));
      }

      if(input == 'Dashboard'){

        String parameter = selectedTabObj.parameterString;
        var dataSp = parameter.split('&');
        Map<String, String> mapData = Map();
        dataSp.forEach((element) =>
        mapData[element.split('=')[0]] =
        element.split('=')[1]);
        String filterContentType = mapData["FilterContentType"] ?? "";
        dueDateListView = mapData["DueDateListView"] ?? "";
        dueDateCalendarView = mapData["DueDateCalendarView"] ?? "";
        showLeaderboard = mapData["ShowLeaderboard"] ?? "";
        showLevelDash = mapData["ShowLevel"] ?? "";
        showPointDash = mapData["ShowPoint"] ?? "";
        showBadgesDash = mapData["ShowBadges"] ?? "";

        if(dueDateListView == "false"){
          if(dueDateCalendarView == "false"){
            if(showLeaderboard == "false"){
              gridCond = false;
              calendarCond = false;
              leaderCond = false;
              globalCondition = '';
              dashTitle = '';
            }else{
              gridCond = false;
              calendarCond = false;
              leaderCond = true;
              globalCondition = 'lead';
              dashTitle = 'Leaderboard';
            }
          }else {
            gridCond = false;
            calendarCond = true;
            leaderCond = false;
            globalCondition = 'cal';
            dashTitle = 'Your Schedule';
          }
        }else {
          gridCond = true;
          calendarCond = false;
          leaderCond = false;
          globalCondition = 'grid';
          dashTitle = 'Your Schedule';
        }

        myLearningBloc.add(GetUserAchievementDataPlusEvent(
          gameID: '3',
          locale: 'en-us',
          componentID: widget.nativeModel.componentId,
          componentInsID: widget.nativeModel.repositoryId,
          //componentInsID: '4232',
          
          siteID: '374',
          userID: '',
        ));

        myLearningBloc.add(GetLeaderboardLearnPlusEvent(
          gameID: '3',
          locale: 'en-us',
          componentID: widget.nativeModel.componentId,
          componentInsID: widget.nativeModel.repositoryId,
          //componentInsID: '4232',
          siteID: '',
          userID: '',
        ));

        // myLearningBloc.add(GetEventResourceCalEvent(
        //     componentinsid: widget.nativeModel.repositoryId,
        //     //componentinsid: '4232',
        //     componentid: widget.nativeModel.componentId,
        //     enddate: '2021-12-01',
        //     startdate: '2021-11-01',
        //     eventid: '',
        //     multiLocation: '',
        //     objecttypes:'${FilterContentType}'));
         dashGridList.clear();
        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: pageNumber,
            pageSize: 10,
            searchText: '',
            isWishlistCount: 0,
            isWait: false,
            dateFilter: 'today',
            componentId: tab.componentId, //'316',
            componentInsId: tab.tabComponentInstanceId, //'4233',
            objectTypeId: '$filterContentType',
            contentStatus: '',
            type: 'today'));

        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: pageNumber,
            pageSize: 10,
            searchText: "",
            isWishlistCount: 0,
            isWait: false,
            dateFilter: 'thisweek',
            componentId: tab.componentId, //'316',
            componentInsId: tab.tabComponentInstanceId, //'4233',
           // componentid: '316',componentInsId: '4233',
            objectTypeId: '$filterContentType',
            contentStatus: '',
            type: 'thisweek'));

        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: pageNumber,
            pageSize: 10,
            searchText: '',
            isWishlistCount: 0,
            isWait: false,
            dateFilter: 'thismonth',
            objectTypeId: '$filterContentType',
             componentId: tab.componentId, //'316',
            componentInsId: tab.tabComponentInstanceId, //'4233',
            // componentid: '316',componentInsId: '4233',
            contentStatus: '',
            type: 'thismonth'));

        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: pageNumber,
            pageSize: 10,
            searchText: '',
            isWishlistCount: 0,
            isWait: false,
            dateFilter: 'future',
            objectTypeId: '$filterContentType',
            componentId: tab.componentId, //'316',
            componentInsId: tab.tabComponentInstanceId, //'4233',
            //componentid: '316',componentInsId: '4233',
            contentStatus: '',
            type: 'future'));
      }

      if(input == 'WaitingList'){
        HashMap<String, String> map =
        HashMap<String, String>();
        String parameter = selectedTabObj.parameterString;
        var dataSp = parameter.split('&');
        Map<String, String> mapData = Map();
        dataSp.forEach((element) =>
        mapData[element.split('=')[0]] =
        element.split('=')[1]);
        String contentstatus = mapData["contentstatus"] ?? "";
        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: pageNumber,
            pageSize: 10,
            searchText: searchValue,
            isWishlistCount: 0,
            contentStatus: contentstatus,
            isWait: true,
            componentId: tab.componentId,
            componentInsId: tab.tabComponentInstanceId,
            // componentid: "3",
            // componentInsId: "4236",
            dateFilter: "",
            type: 'waitlist'));
      }
      if(input == 'Attending'){
        HashMap<String, String> map =
        HashMap<String, String>();
        String parameter = selectedTabObj.parameterString;
        var dataSp = parameter.split('&');
        Map<String, String> mapData = Map();
        dataSp.forEach((element) =>
        mapData[element.split('=')[0]] =
        element.split('=')[1]);
        String contentstatus = mapData["contentstatus"] ?? "";
        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: pageNumber,
            pageSize: 10,
            searchText:searchValue,
            contentStatus: contentstatus,
            isWait: false,
            componentId: tab.componentId,
            componentInsId: tab.tabComponentInstanceId,
            // componentid: "3",
            // componentInsId: "4235",
            isWishlistCount: 0,
            dateFilter: "",
            type: 'attending'));
      }
      if(input == 'InProgress'){
        myLearningPlusInProList.clear();
        HashMap<String, String> map =
        HashMap<String, String>();
        String parameter = selectedTabObj.parameterString;
        var dataSp = parameter.split('&');
        Map<String, String> mapData = Map();
        dataSp.forEach((element) =>
        mapData[element.split('=')[0]] =
        element.split('=')[1]);
        String contentstatus = mapData["contentstatus"] ?? "";
        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: 1,
            pageSize: 100,
            searchText: searchValue,
            isWishlistCount: 0,
            isWait: false,
             componentId: tab.componentId,
            componentInsId: tab.tabComponentInstanceId,
            // componentid: "3",
            // componentInsId: "4238",
            dateFilter: "",
            contentStatus: contentstatus,
            type: 'inprogress'));
      }
      if(input == 'Completed'){
        HashMap<String, String> map =
        HashMap<String, String>();
        String parameter = selectedTabObj.parameterString;
        var dataSp = parameter.split('&');
        Map<String, String> mapData = Map();
        dataSp.forEach((element) =>
        mapData[element.split('=')[0]] =
        element.split('=')[1]);
        String contentstatus = mapData["contentstatus"] ?? "";
        myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
            pageNumber: 1,
            pageSize: 100,
            searchText:searchValue,
            isWishlistCount: 0,
            dateFilter: "",
            isWait: false,
            componentId: tab.componentId,
            componentInsId: tab.tabComponentInstanceId,
            // componentid: "3",
            // componentInsId: "4238",
            contentStatus: contentstatus,
            type: 'completed'));
      }
      if(input == 'MyWishList'){
        myLearningPlusWishlist = [];
        List<WishListTable> wishListDetails = appBloc.wishlistResponse.wishListDetails;
        // HashMap<String, String> map =
        // new HashMap<String, String>();
        // String parameter = selectedTabObj.parameterString;
        // var dataSp = parameter.split('&');
        // Map<String, String> mapData = Map();
        // dataSp.forEach((element) =>
        // mapData[element.split('=')[0]] =
        // element.split('=')[1]);
        // String contentstatus = mapData["contentstatus"] ?? "";

        for(WishListTable table in wishListDetails){
          myLearningBloc.add(GetWishListPlusEvent(pageIndex: pageNumber, categaoryID: 0,type: 'plus',compid: table.componentid,compinsid: table.componentinstanceid,parameterString: table.parameterstring));
        }
      }

    } catch (e) {
      print("repo Error $e");
    }
  }

  Widget tabWiseScreen(ConnectionDynamicTab tab) {  // Widget?
    try {
      switch (tab.tabId) {
        case 'Dashboard':
          return dashboardScreen(dashGridList,tab);
          break;
        case 'WaitingList':
          return myLearningPlusWaitProList.isEmpty
              ? comingSoon()
              : inprogressscreen(myLearningPlusWaitProList, 'vertical', [],false,tab);
          break;
        case 'NotStarted':
          return myLearningPlusNotStartProList.isEmpty
              ? comingSoon()
              : inprogressscreen(myLearningPlusNotStartProList, 'vertical', [],false,tab);
          break;
        case 'Attending':
          return myLearningPlusAttendProList.isEmpty
              ? comingSoon()
              : inprogressscreen(myLearningPlusAttendProList, 'vertical', [],false,tab);
          break;
        case 'InProgress':
          return myLearningPlusInProList.isEmpty
              ? comingSoon()
              : inprogressscreen(myLearningPlusInProList, 'vertical', [],false,tab);
          break;
        case 'Completed':
          return myLearningPlusCompletedList.isEmpty
              ? comingSoon()
              : inprogressscreen(myLearningPlusCompletedList, 'vertical', [],false,tab);
          break;
        case 'MyWishList':
          return myLearningPlusWishlist.isEmpty
              ? comingSoon()
              : inprogressscreen(myLearningPlusWishlist, 'vertical', [],false,tab);
          break;
        case 'Archive':
          return listArchiveList.isEmpty
              ? comingSoon()
              : inprogressscreen(listArchiveList, 'vertical', [],true,tab);
          break;
        default:
          return comingSoon();
      }
    } catch (e) {
      print("repo Error $e");
      return Container();
    }
  }

  Widget comingSoon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(child: Center(child: Text(appBloc.localstr.filterLblLblnodata,style: const TextStyle(color: Colors.black,),),))
        // Center(
        //   child: Text('Coming Soon',style: TextStyle(
        //                 color: Colors.lightGreen,
        //                 fontSize: 15,
        //               ),),
        // ),
      ],
    );
  }

  Widget dashboardScreen(List<DashGridResponse> dashgridlist,ConnectionDynamicTab tab) {
    print('The Dash list : ${dashgridlist.length}');
    String headerTitle = "";
    if(dashgridlist.isNotEmpty) {
    if (dashgridlist[0].dashcommonlist[0].datefilter == "thisweek") headerTitle = "In This Week";
    else if(dashgridlist[0].dashcommonlist[0].datefilter == "today") headerTitle = "Today";
    else if(dashgridlist[0].dashcommonlist[0].datefilter == "thismonth") headerTitle = "In this Month";
    else if(dashgridlist[0].dashcommonlist[0].datefilter == "future") headerTitle = "In Future";
    else headerTitle = "Your Schedule";
    }  //: 'Your Schedule',
   //if(dashgridlist.length > 0) dashtitle = dashgridlist[0].title;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    headerTitle,
                    style: const TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dueDateListView == "true"? Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              gridCond = true;
                              calendarCond = false;
                              leaderCond = false;
                              globalCondition = 'grid';
                              dashTitle = (dashgridlist.isNotEmpty) ? dashgridlist[0].title :'';
                            });
                          },
                          child: Icon(Icons.grid_view,
                              color: gridCond == true
                                  ? statusThickColor
                                  : Colors.grey),
                        ),
                      ):Container(),
                      //SizedBox(width:10.0),
                      dueDateCalendarView == "true" ? Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              gridCond = false;
                              calendarCond = true;
                              leaderCond = false;
                              globalCondition = 'cal';
                              dashTitle = 'Calender';
                            });
                          },
                          child: Icon(Icons.calendar_today,
                              color: calendarCond == true
                                  ? statusThickColor
                                  : Colors.grey),
                        ),
                      ):Container(),
                      //SizedBox(width:10.0),
                      showLeaderboard == "true" ? Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              gridCond = false;
                              calendarCond = false;
                              leaderCond = true;
                              globalCondition = 'lead';
                              dashTitle = 'Leaderboard';
                            });
                          },
                          child: Icon(Icons.stars,
                              color: leaderCond == true
                                  ? statusThickColor
                                  : Colors.grey),
                        ),
                      ):Container(),
                      //SizedBox(width:10.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black),
          Expanded(
            child: clickWiseScreen(globalCondition, dashgridlist,tab),
          ),
        ],
      ),
    );
  }

   clickWiseScreen(
      String selectedicon, List<DashGridResponse> dashgridlist,ConnectionDynamicTab tab) {
    try {
      switch (selectedicon) {
        case 'grid':
          return inprogressscreen([], 'horizontal', dashgridlist,false,tab);
          break;
        case 'cal':
         // dashtitle = "Calender";
          return DashboardCalendarScreen(getEventresourcelist: getEventResourceList,myLearningPlusContext: this.context,);
          break;
        // case 'cal':
        //   return comingSoon();
        //   break;
        case 'lead':
          //dashtitle = "LeaderBoard";
          return DashboardLeaderboardScreen(
            leaderBoardResponse: leaderBoardResponse,
            achievementResponse: userAchievementResponse,
            badges: showBadgesDash,
            levels: showLevelDash,
            points: showPointDash,
          );
          //   return Container();
          break;
        default:
          return comingSoon();
      }
    } catch (e) {
      print("repo Error $e");
    }
  }

  _navigateToGlobalSearchScreen(BuildContext context,ConnectionDynamicTab tab) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const GlobalSearchScreen(menuId: 4180)),
    );

    print(result);

    if (result != null) {
      myLearningBloc.isFirstLoading = true;
      myLearningBloc.isMyCourseSearch = true;
      myLearningBloc.searchMyCourseString = result.toString();
      setState(() {
        pageNumber = 1;
      });
      myLearningBloc.add(GetArchiveListEvent(
          pageNumber: pageArchiveNumber, pageSize: 10, searchText: result));

      apiCallingByInput(currentTabStatus,result,tab);


      // myLearningBloc.add(GetListEvent(
      //     pageNumber: pageNumber, pageSize: 10, searchText: result));
    }
  }

  Widget inprogressscreen(List<DummyMyCatelogResponseTable2> commonlist, //Widget?
      String type, List<DashGridResponse> dashgridlist,bool isArchive,ConnectionDynamicTab tab) {
    String label = "";
    print('The Dash list : ${dashgridlist.length}');
    print('The type : $type');
    try {
      var _controller;
      if (myLearningBloc.isMyCourseSearch) {
        _controller =
            TextEditingController(text: myLearningBloc.searchMyCourseString);
      } else {
        _controller = TextEditingController();
      }

         return BlocConsumer<MyLearningDetailsBloc,
                    MyLearningDetailsState>(
                  bloc: detailsBloc,
                  listener: (context, state) {
                     if (state is SetCompleteState) {
                      if (state.status == Status.LOADING) {
                        flutterToast.showToast(
                          child: CommonToast(displaymsg: 'Please wait'),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: const Duration(seconds: 2),
                        );
                      } else if (state.status == Status.COMPLETED) {
                        flutterToast.showToast(
                          child: CommonToast(
                              displaymsg: 'Course completed successfully'),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: const Duration(seconds: 2),
                        );
                        setState(() {
                          myLearningPlusInProList.clear();
                          myLearningBloc.isFirstLoading = true;
                          pageNumber = 1;
                          myLearningBloc.add(GetListEvent(
                              pageNumber: pageNumber,
                              pageSize: 10,
                              searchText: myLearningBloc.searchMyCourseString));
                            HashMap<String, String> map =
                            HashMap<String, String>();
                            String parameter = selectedTabObj.parameterString;
                            var dataSp = parameter.split('&');
                            Map<String, String> mapData = Map();
                            dataSp.forEach((element) =>
                            mapData[element.split('=')[0]] =
                            element.split('=')[1]);
                            String contentstatus = mapData["contentstatus"] ?? "";

                              myLearningBloc.add(GetMyLearnPlusLearningObjectsEvent(
                              pageNumber: 1,
                              pageSize: 100,
                              searchText: "",
                              isWishlistCount: 0,
                              isWait: false,
                              componentId: tab.componentId,
                              componentInsId: tab.tabComponentInstanceId,
                              // componentid: "3",
                              // componentInsId: "4238",
                              dateFilter: "",
                              contentStatus: contentstatus,
                              type: 'inprogress'));
                        });
                      } else if (state.status == Status.ERROR) {
                        flutterToast.showToast(
                          child: CommonToast(
                              displaymsg: 'Filed to update course status'),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: const Duration(seconds: 2),
                        );
                      }
                    }
                    },
                      // ignore: unnecessary_statements
                     builder: (context, state) {

                        return type == 'vertical'
          ? commonlist.isEmpty
              ? Container()
              : commonlist.isNotEmpty
                  ? Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 40.0,
                                child:InsSearchTextField(
                        onTapAction: () {
                          if (appBloc.uiSettingModel.isGlobalSearch == 'true') {
                            _navigateToGlobalSearchScreen(context,tab);
                          }
                        },
                        controller: _controller,
                        appBloc: appBloc,
                        suffixIcon: myLearningBloc.isArchiveSearch
                            ? IconButton(
                                onPressed: () {
                                  myLearningBloc.isArchiveFirstLoading = true;
                                  myLearningBloc.isArchiveSearch = false;
                                  myLearningBloc.searchArchiveString = '';
                                  setState(() {
                                    pageArchiveNumber = 1;
                                  });
                                  myLearningBloc.add(GetArchiveListEvent(
                                      pageNumber: pageNumber,
                                      pageSize: 10,
                                      searchText: myLearningBloc.searchArchiveString));
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Color(int.parse(
                                      '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                                ),
                              )
                            : (myLearningBloc.isFilterMenu)
                                ? IconButton(
                                    onPressed: () async{
                                      myLearningBloc.add(GetFilterMenus(
                                      listNativeModel: appBloc.listNativeModel,
                                      localStr: appBloc.localstr,
                                      moduleName: 'My Learning'));

                                       await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyLearningFilter(componentId: "3",)));

                                        myLearningBloc.isFirstLoading = true;
                                        myLearningBloc.isMyCourseSearch = false;
                                        myLearningBloc.searchMyCourseString = '';
                                        setState(() {
                                          pageNumber = 1;
                                        });

                                        //  mylearningplusWishlist = [];
                                        //   List<WishListTable> WishListDetails = appBloc.wishlistResponse.WishListDetails;
                                        //   for(WishListTable table in WishListDetails){
                                        //     myLearningBloc.add(GetWishListPlusEvent(pageIndex: pageNumber, categaoryID: 0,type: 'plus',compid: table.componentid,compinsid: table.componentinstanceid,parameterString: table.parameterstring));
                                        //   }
                                        // HashMap<String, String> map = new HashMap<String, String>();
                                        // String parameter = selectedTabObj.parameterString;
                                        // var dataSp = parameter.split('&');
                                        // Map<String, String> mapData = Map();
                                        // // dataSp.forEach((element) =>
                                        // // mapData[element.split('=')[0]] =
                                        // // element.split('=')[1]);
                                        // String contentstatus = mapData["contentstatus"] ?? "";
                                        //  myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
                                        //   pageNumber: 1, //pageNumber,
                                        //   pageSize: 10,
                                        //   searchText: "",
                                        //   Contentstatus: contentstatus,
                                        //   componentid: tab.componentId,  //widget.nativeModel.componentId,
                                        //   componentInsId: tab.tabComponentInstanceId,  //widget.nativeModel.repositoryId,
                                        //   //componentInsId: '4232',
                                        //   iswait: false,
                                        //   iswishlistcount: 0,
                                        //   Datefilter: "",
                                        //   type: tab.tabId));

                                        myLearningBloc.add(GetListEvent(
                                            pageNumber: pageNumber,
                                            pageSize: 10,
                                            searchText: myLearningBloc.searchMyCourseString));
                                                }, //We need to set => tab.componentId as parameter for MyLearningFilter but seeting it to "3" beacuse there is "3" is not assigned for In progree and dashboard tabs gettings issues
                                    icon: Icon(
                                      Icons.tune,
                                      color: Color(int.parse(
                                          '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                                    ),
                                  )
                                : null,
                        onSubmitAction: (value) {
                          if (value.toString().isNotEmpty) {
                            myLearningBloc.isArchiveFirstLoading = true;
                            myLearningBloc.isArchiveSearch = true;
                            myLearningBloc.searchArchiveString =
                                value.toString();
                            setState(() {
                              pageArchiveNumber = 1;
                            });
                            myLearningBloc.add(GetArchiveListEvent(
                                pageNumber: pageNumber,
                                pageSize: 10,
                                searchText: myLearningBloc.searchArchiveString));

                            myLearningBloc.add(GetListEvent(
                                      pageNumber: pageNumber,
                                      pageSize: 10,
                                      searchText: myLearningBloc.searchMyCourseString));
                          }
                        },
                      ),
                                // child: InsSearchTextField(
                                //   onTapAction: () {
                                //     if (appBloc.uiSettingModel.IsGlobasearch ==
                                //         'true') {
                                //       _navigateToGlobalSearchScreen(context);
                                //     }
                                //   },
                                //   controller: _controller,
                                //   appBloc: appBloc,
                                //   suffixIcon: myLearningBloc.isMyCourseSearch
                                //       ? IconButton(
                                //           onPressed: () {
                                //             myLearningBloc.isFirstLoading =
                                //                 true;
                                //             myLearningBloc.isMyCourseSearch =
                                //                 false;
                                //             myLearningBloc
                                //                 .SearchMyCourseString = "";
                                //             setState(() {
                                //               pageNumber = 1;
                                //             });

                                //             ApicallingByinput(currentTabStatus,'');

                                //             // myLearningBloc.add(GetListEvent(
                                //             //     pageNumber: pageNumber,
                                //             //     pageSize: 10,
                                //             //     searchText: ""));
                                //           },
                                //           icon: Icon(
                                //             Icons.close,
                                //             color: Color(int.parse(
                                //                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                //           ),
                                //         )
                                //       : (myLearningBloc.isFilterMenu)
                                //           ? IconButton(
                                //               onPressed: () async {
                                //                 await Navigator.of(context)
                                //                     .push(MaterialPageRoute(
                                //                         builder: (context) =>
                                //                             MyLearningFilter()));

                                //                 myLearningBloc.isFirstLoading =
                                //                     true;
                                //                 myLearningBloc
                                //                     .isMyCourseSearch = false;
                                //                 myLearningBloc
                                //                     .SearchMyCourseString = "";
                                //                 setState(() {
                                //                   pageNumber = 1;
                                //                 });


                                //                 ApicallingByinput(currentTabStatus,'');

                                //                 // myLearningBloc.add(GetListEvent(
                                //                 //     pageNumber: pageNumber,
                                //                 //     pageSize: 10,
                                //                 //     searchText: "")
                                //                 // );
                                //               },
                                //               icon: Icon(Icons.tune,
                                //                   color: Color(
                                //                     int.parse(
                                //                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                //                   )
                                //                   ),
                                //             )
                                //           : null,
                                //   onSubmitAction: (value) {
                                //     if (value.toString().length > 0) {
                                //       myLearningBloc.isFirstLoading = true;
                                //       myLearningBloc.isMyCourseSearch = true;
                                //       myLearningBloc.SearchMyCourseString =
                                //           value.toString();
                                //       setState(() {
                                //         pageNumber = 1;
                                //       });
                                //       ApicallingByinput(currentTabStatus,'');
                                //       // myLearningBloc.add(GetListEvent(
                                //       //     pageNumber: pageNumber,
                                //       //     pageSize: 10,
                                //       //     searchText: value.toString())
                                //       //);
                                //     }
                                //   },
                                // ),
                              )),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: commonlist.length,
                              itemBuilder: (context, i) {
                                if (commonlist.isEmpty) {
                                  //if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                  return _buildProgressIndicator();
                                  //}
                                } else {
                                  return Container(
                                    child: widgetMyLearnplusListItems(
                                        commonlist[i],isArchive, context,tab, i),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(child: Center(child: Text(appBloc.localstr.filterLblLblnodata,style: const TextStyle(color: Colors.black,),),))
          : ((dashgridlist.isEmpty )) ? Container(child: Center(child: Text(appBloc.localstr.filterLblLblnodata,style: const TextStyle(color: Colors.black,),),)) : Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: dashgridlist.length,
                itemBuilder: (context, i) {
                  return 
                  Column(
                    children: <Widget>[
                      // Align(
                      //   child: Padding(
                      //     padding:
                      //         const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                      //     child: Text(dashgridlist[i].title,
                      //         style: TextStyle(
                      //             fontSize: ScreenUtil().setSp(16),
                      //             color: Colors.black)),
                      //   ),
                      //   alignment: Alignment.centerLeft,
                      // ),
                      ((dashgridlist.isNotEmpty && dashgridlist[0].dashcommonlist.isEmpty )) ? Container(child: Center(child: Text(appBloc.localstr.filterLblLblnodata,style: const TextStyle(color: Colors.black,),),)) :
                      Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.43,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: dashgridlist[i].dashcommonlist.length,
                          itemBuilder: (context, j) {
                            DummyMyCatelogResponseTable2 tableobj = dashgridlist[i].dashcommonlist[j];
                            if (tableobj.datefilter == "today")  label = "Today"; else if (tableobj.datefilter == "thisweek") label = "In this Week"; else if (tableobj.datefilter == "future") label = "In Future";
                            return Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // (i > 0) ?
                                (!label.contains(tableobj.datefilter)) ?
                                Padding(
                                  padding: const EdgeInsets.only(left:15.0),
                                  child: Container(alignment: Alignment.centerLeft,
                                    child:Text(
                                    label,
                                    style: const TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 15,
                                    ),
                                  ),),
                                 ):Container(),
                                 //:Container(),
                                // (i > 0) ? Padding(
                                //   padding: const EdgeInsets.all(10.0),
                                //   child: Container(height: 1,width: MediaQuery.of(context).size.width * 0.95,color: Colors.grey,),
                                // ):Container(),
                                // Divider(),
                                Expanded(
                                  child: Container(
                                    child: widgetDashListItems(tableobj, false, context,tab, i),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                  //:Container(child: Center(child: Text(appBloc.localstr.filterLblLblnodata,style: TextStyle(color: Colors.black,),),));

//                   if (dashgridlist[i].dashcommonlist.length == 0) {
//                     //if (state.status == Status.LOADING) {
// //                          print("gone in _buildProgressIndicator");
//                     return Container();
//                     //}
//                   } else {}
                },
              ),
            );


                      },

                  );

    } catch (e, st) {
      print('The plus error is : ${e.toString()} == $st}');
      return Container();
    }
  }

   widgetDashListItems(DummyMyCatelogResponseTable2 obj, bool isArchive, BuildContext context,ConnectionDynamicTab tab, [int i = 0]) {
    try {
      String imgUrl =
          "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

      Color statuscolor = const Color(0xff5750da);
      String statusval = obj.corelessonstatus.toString();
      double ratingRequired = 0;
      if (statusval.trim().contains('Completed')) {
        statuscolor = const Color(0xff4ad963);
      }
      else if (statusval.trim() == 'Not Started') {
        statuscolor = const Color(0xfffe2c53);
      }
      else if (statusval.trim() == 'In Progress') {
        statuscolor = const Color(0xffff9503);
      }

      bool isratingbarVissble = false;
      bool isReviewVissble = false;

      try {
        ratingRequired = double.parse(
            appBloc.uiSettingModel.minimumRatingRequiredToShowRating);
      } catch (e) {
        ratingRequired = 0;
      }

      if (obj.totalratings >= int.parse(appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating) && obj.ratingid >= ratingRequired) {
        isReviewVissble = false;
        isratingbarVissble = true;
      }

      if (statusval.toLowerCase().contains("completed") ||
          statusval == "passed" ||
          statusval == "failed") {
        isratingbarVissble = true;
        isReviewVissble = true;
      } else if (statusval.toLowerCase().contains("completed")) {
        isratingbarVissble = false;
        isReviewVissble = false;
      } else if (statusval == "attended") {
        isratingbarVissble = false;
        isReviewVissble = true;
      }

      bool isExpired = false;
      if (obj.durationenddate != null) {
        DateTime tempDate =
            DateFormat("yyyy-MM-ddThh:mm:ss").parse(obj.durationenddate);
        String dateStr = DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDate);

        //var isExpire = tempDate.isAfter(DateTime.now());
        isExpired = tempDate.isBefore(DateTime.now());
        print(dateStr);
        print(DateTime.now());
        print(isExpired);
        if (isExpired) {
          statuscolor = const Color(0xfffe2c53);
        }
        //print(isExpire);
      }

       return BlocConsumer<EvntModuleBloc, EvntModuleState>(
      bloc: eventModuleBloc,
      listener: (context, state) {
        if (state is CancelEnrollmentState) {
          if (state.status == Status.COMPLETED) {
            if (state.isSucces == '"true"') {
              Future.delayed(const Duration(seconds: 1), () {
                // 5s over, navigate to a page
                flutterToast.showToast(
                  child: CommonToast(
                      displaymsg:
                          'Your enrollment for the course has been successfully canceled'),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: const Duration(seconds: 1),
                );
                setState(() {
                dashGridList.remove(obj);
                });
              });

              print('positionnnn $pos');

              setState(() {
                state.table2.isaddedtomylearning = 0;
                myLearningBloc.list.removeAt(pos);
              });
            } else {
              flutterToast.showToast(
                child: CommonToast(displaymsg: 'Something went wrong'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            }
          } else if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            }
          }
        } else if (state is BadCancelEnrollmentState) {
          if (state.status == Status.COMPLETED) {
            showCancelEnrollDialog(state.table2, state.isSucces);
          } else if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            }
          }
        }
      },

      builder: (context, state) => InkWell(
        onTap: (){
          if ((obj.viewprerequisitecontentstatus != null) && (isValidString(obj.viewprerequisitecontentstatus))) {
            print('ifdataaaaa');
            String alertMessage =
                appBloc.localstr.prerequistesalerttitle6Alerttitle6;
            alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    'Pre-requisite Sequence',
                    style: TextStyle(
                        color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        ),
                        fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alertMessage,
                          style: TextStyle(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                      Text(
                          '\n${obj.viewprerequisitecontentstatus
                                  .toString()
                                  .split('#%')[1]
                                  .split('\$;')[0]}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue,
                          )),
                      Text(
                          obj.viewprerequisitecontentstatus
                              .toString()
                              .split('#%')[1]
                              .split('\$;')[1],
                          style: TextStyle(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              )))
                    ],
                  ),
                  backgroundColor: InsColor(appBloc).appBGColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                      textColor: Colors.blue,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
          } else {
            launchCourse(obj, context, false,tabInfo:tab);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Card(
              elevation: 10,
              color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            width: ScreenUtil().setHeight(200),
                            child: CachedNetworkImage(
                              imageUrl: obj.thumbnailimagepath.startsWith('http')
                                  ? obj.thumbnailimagepath
                                  : ApiEndpoints.strBaseUrl +
                                      obj.thumbnailimagepath,
                              width: MediaQuery.of(context).size.width,
                              //placeholder: (context, url) => CircularProgressIndicator(),
                              placeholder: (context, url) => Image.asset(
                                'assets/cellimage.jpg',
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/cellimage.jpg',
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: Visibility(
                                  visible: kShowContentTypeIcon,
                                  child: Container(
                                      padding: const EdgeInsets.all(2.0),
                                      color: Colors.white,
                                      child: CachedNetworkImage(
                                        height: 30,
                                        imageUrl: obj.thumbnailimagepath.isEmpty
                                            ? imgUrl
                                            : obj.thumbnailimagepath,
                                        width: 30,
                                        fit: BoxFit.contain,
                                      )
                                      //     Icon(
                                      //   table2.objecttypeid == 14
                                      //       ? Icons.picture_as_pdf
                                      //       : (table2.objecttypeid == 11
                                      //           ? Icons.video_library
                                      //           : Icons.format_align_justify),
                                      //   color: Colors.white,
                                      //   size: ScreenUtil().setHeight(30),
                                      // ),
                                      ),
                                )),
                          ),
                          Positioned(
                            top: 15,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF007BFF),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(5),
                                  bottom: ScreenUtil().setWidth(5),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10)),
                              child: Text(
                                isExpired
                                    ? 'Expired'
                                    : obj.corelessonstatus.toString(),
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(10),
                                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: ScreenUtil().setHeight(210),
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${obj.contenttype.toLowerCase().toUpperCase()}',
                                style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              flex: 9,
                            ),

                            Expanded(
                              flex: 1,
                              child: isArchive
                                  ? GestureDetector(
                                      onTap: isExpired
                                          ? null
                                          : () {
                                              myLearningBloc.add(RemoveToArchiveCall(isArchive: false, strContentID: obj.contentid, table2: obj));
                                            },
                                      child: Icon(
                                        Icons.archive,
                                        color: InsColor(appBloc).appIconColor,
                                        size: ScreenUtil().setHeight(30),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: isExpired
                                          ? null
                                          : () {
                                              settingMyCourceBottomSheet(
                                                  context, obj, i,tab);
                                            },
                                      child: isExpired
                                          ? Container()
                                          : Icon(
                                              Icons.more_vert,
                                              color: InsColor(appBloc).appIconColor,
                                            ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: ScreenUtil().setHeight(210),
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${obj.name.toString().trim()}',
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              fontSize: 13.0),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: ScreenUtil().setHeight(210),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setWidth(20),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(imgUrl)))),
                            SizedBox(
                              width: ScreenUtil().setWidth(5),
                            ),
                            Text(
                              obj.authordisplayname,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(13),
                                  color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                      .withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: ScreenUtil().setHeight(210),
                        child: Row(
                          children: <Widget>[
                            // isratingbarVissble == null
                            //     ? false
                            //     : isratingbarVissble
                            //         ? 
                            SmoothStarRating(
                                        allowHalfRating: false,
                                        //onRated: (v) {},
                                        starCount: 5,
                                        rating: obj.ratingid,
                                        size: ScreenUtil().setHeight(20),
                                        //isReadOnly: true,
                                        // filledIconData: Icons.blur_off,
                                        // halfFilledIconData: Icons.blur_on,
                                        color: Colors.orange,
                                        borderColor: Colors.orange,
                                        spacing: 0.0),
                                    //: Container(),
                            SizedBox(
                              width: ScreenUtil().setWidth(5),
                            ),
                            isReviewVissble
                                ? Expanded(
                                    child: GestureDetector(
                                      onTap: isExpired
                                          ? null
                                          : () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReviewScreen(
                                                              obj.contentid,
                                                              false,
                                                              MyLearningDetailsBloc(myLearningRepository: myLearningRepository))))
                                                  .then((value) => {
                                                        if (value == true)
                                                          {

                                                            apiCallingByInput(currentTabStatus,'',tab)

                                                            // myLearningBloc.add(
                                                            //     GetListEvent(
                                                            //         pageNumber: 1,
                                                            //         pageSize: 10,
                                                            //         searchText: ""))
                                                          }
                                                      });
                                            },
                                      child: Text(
                                        appBloc
                                            .localstr.mylearningButtonReviewbutton,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(12),
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: ScreenUtil().setHeight(210),
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          obj.shortdescription,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                  .withOpacity(0.5)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isExpired
                          ? Container()
                          : Container(
                              width: ScreenUtil().setHeight(210),
                              child: Row(
                                children: <Widget>[
                                  // commented till offline integration done
                                  //displayDownloadTile(table2, i),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(10),
                                  ),
                                  displayViewTile(obj,tab),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  displayPlayTile(obj,tab)
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ));
    } catch (e, st) {
      print('The Dash grid error is : ${e.toString()} === $st');
    }
  }

   widgetMyLearnplusListItems(
      DummyMyCatelogResponseTable2 obj, bool isArchive, BuildContext context,ConnectionDynamicTab tab,
      [int i = 0]) {
    try {
      String imgUrl =
          "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

      Color statuscolor = const Color(0xff5750da);
      String statusval = obj.corelessonstatus.toString();
      double ratingRequired = 0;
      if (statusval.trim().contains('Completed')) {
        statuscolor = const Color(0xff4ad963);
      }
      else if (statusval.trim() == 'Not Started') {
        statuscolor = const Color(0xfffe2c53);
      }
      else if (statusval.trim() == 'In Progress') {
        statuscolor = const Color(0xffff9503);
      }

      bool isratingbarVissble = false;
      bool isReviewVissble = false;

      try {
        ratingRequired = double.parse(
            appBloc.uiSettingModel.minimumRatingRequiredToShowRating);
      } catch (e) {
        ratingRequired = 0;
      }

      if (obj.totalratings >=
              int.parse(appBloc
                  .uiSettingModel.numberOfRatingsRequiredToShowRating) &&
          obj.ratingid >= ratingRequired) {
        isReviewVissble = false;
        isratingbarVissble = true;
      }

      if (statusval.toLowerCase().contains("completed") ||
          statusval == "passed" ||
          statusval == "failed") {
        isratingbarVissble = true;
        isReviewVissble = true;
      } else if (statusval.toLowerCase().contains("completed")) {
        isratingbarVissble = false;
        isReviewVissble = false;
      } else if (statusval == "attended") {
        isratingbarVissble = false;
        isReviewVissble = true;
      }

      bool isExpired = false;
      if (obj.durationenddate != null) {
        DateTime tempDate =
            DateFormat("yyyy-MM-ddThh:mm:ss").parse(obj.durationenddate);
        String dateStr = DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDate);

        //var isExpire = tempDate.isAfter(DateTime.now());
        isExpired = tempDate.isBefore(DateTime.now());
        print(dateStr);
        print(DateTime.now());
        print(isExpired);
        if (isExpired) {
          statuscolor = const Color(0xfffe2c53);
        }
        //print(isExpire);
      }

      return BlocConsumer<MyLearningBloc, MyLearningState>(
        bloc:myLearningBloc,
        listener: (context,state){

           if (state is GetListState) {
                if (state.status == Status.COMPLETED) {
//            print('List size ${state.list.length}');
                  if (appBloc.uiSettingModel.isFromPush) {
                    print(
                        'Data data : ${myLearningBloc.list.length}');
                    myLearningBloc.list.asMap().forEach((i, element) {
                      if (element.contentid == contentId) {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => CommonDetailScreen(
                                  screenType: ScreenType.MyLearning,
                                  contentid: contentId,
                                  objtypeId: element.objecttypeid,
                                  detailsBloc: detailsBloc,
                                  table2: element,
                                  pos: i,
                                  mylearninglist: myLearningBloc.list,
                                  isFromReschedule: false,
                                ),
                              ),
                            )
                            .then((value) => {
                                  if (value ?? true)
                                    {
                                      appBloc.uiSettingModel
                                          .setIsFromPush(false),
                                      contentId = '',
                                      myLearningBloc.add(GetListEvent(
                                          pageNumber: pageNumber,
                                          pageSize: 10,
                                          searchText: myLearningBloc.searchMyCourseString))
                                    }
                                });
                      }
                    });
                  }
                  setState(() {
                    isGetListEvent = true;
                    pageNumber++;
                  });
                } else if (state.status == Status.ERROR) {
                  //if (state.message == '401') {
                    AppDirectory.sessionTimeOut(context);
                 // }
                }
              }
              else if(state is GetMyLearnPlusLearningObjectsState){
                if(state.status == Status.COMPLETED){
                if (state.list.isNotEmpty && ((state.list[0].actualstatus == "completed") || (state.list[0].actualstatus == "passed") || (state.list[0].actualstatus == "failed"))) { //Completed
                    myLearningPlusCompletedList.clear();
                    myLearningPlusCompletedList.addAll(state.list);
                 }
                 else if(state.list.isNotEmpty && state.list[0].actualstatus == "incomplete"){ //In Progress ("inprogress,incomplete,grade")
                 myLearningPlusInProList.clear();
                 myLearningPlusInProList = state.list;
                 }
                 else if(state.list.isNotEmpty && (state.list[0].actualstatus == "not attempted" || state.list[0].actualstatus == "registered")){ //Not started
                 myLearningPlusNotStartProList.clear();
                 myLearningPlusNotStartProList = state.list;
                 }
                 else if(state.list.isNotEmpty && ((state.list[0].actualstatus == "attended") || (state.list[0].actualstatus == "notattended"))){  //Attending
                 myLearningPlusAttendProList.clear();
                 myLearningPlusAttendProList = state.list;
                 }
                }
              }

              //  else if (state is getMyLearnPlusLearningObjectsState) {
              //   if (state.status == Status.COMPLETED) {
              //      if(state.list.length > 0 && state.list[0].actualstatus == "incomplete"){
              //   // mylearningplusinprolist.clear();
              //    mylearningplusinprolist = state.list;
              //    }
              //   } else if (state.status == Status.ERROR) {
              //     mylearningplusinprolist = [];
              //   }
              // }

        },
        builder: (context,state){
          return InkWell(
        onTap: (){
          if ((obj.viewprerequisitecontentstatus != null ) && (isValidString(obj.viewprerequisitecontentstatus))) {
            print('ifdataaaaa');
            String alertMessage =
                appBloc.localstr.prerequistesalerttitle6Alerttitle6;
            alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    'Pre-requisite Sequence',
                    style: TextStyle(
                        color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        ),
                        fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alertMessage,
                          style: TextStyle(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                      Text(
                          '\n${obj.viewprerequisitecontentstatus
                                  .toString()
                                  .split('#%')[1]
                                  .split('\$;')[0]}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue,
                          )),
                      Text(
                          obj.viewprerequisitecontentstatus
                              .toString()
                              .split('#%')[1]
                              .split('\$;')[1],
                          style: TextStyle(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              )))
                    ],
                  ),
                  backgroundColor: InsColor(appBloc).appBGColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                      textColor: Colors.blue,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
          } else {
            launchCourse(obj, context, false,tabInfo:tab);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Card(
              elevation: 10,
              color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(kCellThumbHeight),
                          child: CachedNetworkImage(
                            imageUrl: obj.thumbnailimagepath.startsWith('http')
                                ? obj.thumbnailimagepath
                                : ApiEndpoints.strBaseUrl +
                                    obj.thumbnailimagepath,
                            width: MediaQuery.of(context).size.width,
                            //placeholder: (context, url) => CircularProgressIndicator(),
                            placeholder: (context, url) => Image.asset(
                              'assets/cellimage.jpg',
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/cellimage.jpg',
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.center,
                              child: Visibility(
                                visible: kShowContentTypeIcon,
                                child: Container(
                                    padding: const EdgeInsets.all(2.0),
                                    color: Colors.white,
                                    child: CachedNetworkImage(
                                      height: 30,
                                      imageUrl: obj.thumbnailimagepath.isEmpty
                                          ? imgUrl
                                          : obj.thumbnailimagepath,
                                      width: 30,
                                      fit: BoxFit.contain,
                                    )
                                    //     Icon(
                                    //   table2.objecttypeid == 14
                                    //       ? Icons.picture_as_pdf
                                    //       : (table2.objecttypeid == 11
                                    //           ? Icons.video_library
                                    //           : Icons.format_align_justify),
                                    //   color: Colors.white,
                                    //   size: ScreenUtil().setHeight(30),
                                    // ),
                                    ),
                              )),
                        ),
                        Positioned(
                            top: 15,
                            left: 15,
                            child: obj.corelessonstatus.isEmpty ? Container() : Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF007BFF),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(5),
                                  bottom: ScreenUtil().setWidth(5),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10)),
                              child: Text(
                                isExpired
                                    ? 'Expired'
                                    : obj.corelessonstatus.isEmpty? "" : obj.corelessonstatus.toString(),
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(10),
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"))),
                              ),
                            )),
                      ],
                    ),

                    LinearProgressIndicator(
                      value: obj.progress.isNotEmpty
                          ? obj.progress == ''
                              ? 0.0
                              : double.parse(obj.progress) / 100
                          : 0.0,
                      valueColor: AlwaysStoppedAnimation<Color>(statuscolor),
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${obj.contenttype.toLowerCase().toUpperCase()}',
                              style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            flex: 9,
                          ),
                          Expanded(
                            flex: 1,
                            child: isArchive
                                ? GestureDetector(
                                    onTap: isExpired
                                        ? null
                                        : () {
                                            myLearningBloc.add(
                                                RemoveToArchiveCall(
                                                  isArchive: false,
                                                  strContentID: obj.contentid,
                                                  table2: obj,
                                                ));
                                          },
                                    child: Icon(
                                      Icons.archive,
                                      color: InsColor(appBloc).appIconColor,
                                      size: ScreenUtil().setHeight(30),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: isExpired
                                        ? null
                                        : () {
                                            settingMyCourceBottomSheet(
                                                context, obj, i,tab);
                                          },
                                    child: isExpired
                                        ? Container()
                                        : Icon(
                                            Icons.more_vert,
                                            color: InsColor(appBloc).appIconColor,
                                          ),
                                  ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${obj.name.toString().trim()}',
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 13.0),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    Row(
                      children: <Widget>[
                        Container(
                            width: ScreenUtil().setWidth(20),
                            height: ScreenUtil().setWidth(20),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(imgUrl)))),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        Text(
                          obj.authordisplayname,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                  .withOpacity(0.5)),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: <Widget>[
                        // isratingbarVissble == null
                        //     ? false
                        //     : isratingbarVissble
                        //         ? 
                                SmoothStarRating(
                                    allowHalfRating: false,
                                    //onRated: (v) {},
                                    starCount: 5,
                                    rating: obj.ratingid,
                                    size: ScreenUtil().setHeight(20),
                                    //isReadOnly: true,
                                    // filledIconData: Icons.blur_off,
                                    // halfFilledIconData: Icons.blur_on,
                                    color: Colors.orange,
                                    borderColor: Colors.orange,
                                    spacing: 0.0),
                               // : Container(),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        isReviewVissble
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: isExpired
                                      ? null
                                      : () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewScreen(obj.contentid,
                                                          false, MyLearningDetailsBloc(myLearningRepository: myLearningRepository))))
                                              .then((value) => {
                                                    if (value == true)
                                                      {

                                                        apiCallingByInput(currentTabStatus,'',tab)

                                                        // myLearningBloc.add(
                                                        //     GetListEvent(
                                                        //         pageNumber: 1,
                                                        //         pageSize: 10,
                                                        //         searchText: ""))
                                                      }
                                                  });
                                        },
                                  child: Text(
                                    appBloc.localstr.mylearningButtonReviewbutton,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        obj.shortdescription,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                .withOpacity(0.5)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isExpired
                        ? Container()
                        : Row(
                            children: <Widget>[
                              // commented till offline integration done
                              //displayDownloadTile(table2, i),
                              SizedBox(
                                width: ScreenUtil().setWidth(10),
                              ),
                             (obj.iswishlistcontent != 1) ? displayViewTile(obj,tab) : Container(),
                              const SizedBox(
                                width: 10,
                              ),
                              displayPlayTile(obj,tab)
                            ],
                          ),

                    // (obj.isDownloading != null && table2.isDownloading)
                    //     ? LinearProgressIndicator(
                    //   value: downloadedProgess.toDouble() / 100,
                    //   valueColor: AlwaysStoppedAnimation<Color>(Color(int.parse(
                    //       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                    //   backgroundColor: Colors.grey,
                    // )
                    //     : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
        },
      );
    } catch (e, st) {
      print('The plus main error is ${e.toString()} == $st');
    }
  }

  Widget displayViewTile(DummyMyCatelogResponseTable2 table2,ConnectionDynamicTab tabInfo) {
    if (table2.objecttypeid == 11 ||
        table2.objecttypeid == 14 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 20 ||
        table2.objecttypeid == 21 ||
        table2.objecttypeid == 52) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return Container();
      } else {
        return viewOption(
            table2, appBloc.localstr.mylearningActionsheetViewoption,tabInfo);
      }
    } else if (table2.objecttypeid == 688 || table2.objecttypeid == 70) {
      return Container();
    } else {
      return viewOption(
          table2, appBloc.localstr.mylearningActionsheetViewoption,tabInfo);
    }
  }

  Widget displayPlayTile(DummyMyCatelogResponseTable2 table2,ConnectionDynamicTab tabInfo) {
    if (table2.objecttypeid == 11 ||
        table2.objecttypeid == 14 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 20 ||
        table2.objecttypeid == 21 ||
        table2.objecttypeid == 52) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return viewOption(
            table2, appBloc.localstr.mylearningActionsheetPlayoption,tabInfo);
      }
    }

    return Container();
  }

  Widget displayDownloadTile(CourseList table2, [int i = 0]) {
    if ((table2.contentTypeId == 10 && table2.bit5) ||
        table2.contentTypeId == 28 ||
        table2.contentTypeId == 20 ||
        table2.contentTypeId == 688 ||
        table2.contentTypeId == 693 ||
        table2.contentTypeId == 36 ||
        table2.contentTypeId == 102 ||
        table2.contentTypeId == 27 ||
        table2.contentTypeId == 70) {
      return Container();
    } else {
      return Expanded(
        child: Stack(
          children: <Widget>[
            Container(
              child: FlatButton.icon(
                disabledColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                    .withOpacity(0.5),
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                icon: Icon(
                  Icons.cloud_download,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                  size: 25,
                ),
                label: Text(
                  appBloc.localstr.mylearningActionsheetDownloadoption
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                  ),
                ), onPressed: () {  },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget viewOption(DummyMyCatelogResponseTable2 table2,
      String mylearningActionsheetViewoption,ConnectionDynamicTab tabInfo) {
    return Expanded(
        child: FlatButton.icon(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
      icon: Icon(
        Icons.remove_red_eye,
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
        size: 25,
      ),
      label: Text(
        mylearningActionsheetViewoption.toUpperCase(),
        style: TextStyle(
          fontSize: ScreenUtil().setSp(14),
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
        ),
      ),
      onPressed: () async {

//            print("......GO TO ......${table2.objecttypeid}");

        if ((table2.viewprerequisitecontentstatus != null) && (isValidString(table2.viewprerequisitecontentstatus))) {
          print('ifdataaaaa');
          String alertMessage =
              appBloc.localstr.prerequistesalerttitle6Alerttitle6;
          alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      'Pre-requisite Sequence',
                      style: TextStyle(
                          color: Color(
                            int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                          ),
                          fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alertMessage,
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ))),
                        Text(
                            '\n${table2.viewprerequisitecontentstatus
                                    .toString()
                                    .split('#%')[1]
                                    .split('\$;')[0]}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.blue,
                            )),
                        Text(
                            table2.viewprerequisitecontentstatus
                                .toString()
                                .split('#%')[1]
                                .split('\$;')[1],
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )))
                      ],
                    ),
                    backgroundColor: InsColor(appBloc).appBGColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                        textColor: Colors.blue,
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        } else {
          launchCourse(table2, context, false,tabInfo:tabInfo);
        }
      },
    ));
  }

  Future<void> launchCourse(DummyMyCatelogResponseTable2 table2,
      BuildContext context, bool isContentisolation,{required ConnectionDynamicTab tabInfo}) async {
    print('helllllllllloooooo');

    /* //TODO: This content for testing purpuse
    courseLaunch = GotoCourseLaunch(
        context, table2, false, appBloc.uiSettingModel, myLearningBloc.list);
    String url = await courseLaunch.getCourseUrl();

    print('urldataaaaa $url');
    if (url.isNotEmpty) {
      if (table2.objecttypeid == 26) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AdvancedWebCourseLaunch(url, table2.name)));
      } else {
        //await FlutterWebBrowser.openWebPage(url: url, androidToolbarColor: Colors.deepPurple);

        //await launch(url);
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InAppWebCourseLaunch(url, table2)));
      }

      logger.e(".....Refresh Me....$url");

      /// Refresh Content Of My Learning

    }
    return;
    */

    /// content isolation only for 8,9,10,11,26,27
    if (!isContentisolation) {
      if (table2.objecttypeid == 8 ||
          table2.objecttypeid == 9 ||
          (table2.objecttypeid == 10 && !table2.bit5) ||
          table2.objecttypeid == 26 ||
          // table2.objecttypeid == 694 ||
          table2.objecttypeid == 102) {
        /// remove after normal course launch
        GotoCourseLaunchContentisolation courseLaunch =
            GotoCourseLaunchContentisolation(
                context, table2, appBloc.uiSettingModel, myLearningBloc.list);

        String courseUrl = await courseLaunch.getCourseUrl();
        compId = ""; compInstId = "";
        compId = tabInfo.componentId; compInstId = tabInfo.tabComponentInstanceId;

        if(context != null){
        myLearningBloc.add(CourseTrackingEvent(
          courseUrl: courseUrl,
          table2: table2,
          userID: table2.userid.toString(),
          objecttypeId: "${table2.objecttypeid}",
          siteIDValue: "${table2.siteid}",
          scoId: "${table2.scoid}",
          contentID: table2.contentid,
        ));
        }
        else{
           setState(() { });
        }
        return;
      }
    }

    /// Need Some value
    if (table2.objecttypeid == 102) {
      executeXAPICourse(table2);
    }

    if (table2.objecttypeid == 10 && table2.bit5) {
      // Need to open EventTrackListTabsActivity
      if(context != null){
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventTrackList(
                table2,
                true,
                myLearningBloc.list,
              )));
      }
       else{

        setState(() {

        });

      }
      setState(() {});
      return;
    } else {
       if(context != null){
      courseLaunch = GotoCourseLaunch(
          context, table2, false, appBloc.uiSettingModel, myLearningBloc.list);
      String? url = await courseLaunch?.getCourseUrl();



      print('urldataaaaa $url');
      if (url!.isNotEmpty) {
        if (table2.objecttypeid == 26) {
          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(url, table2)))
              .then((value) => {
            if (value)
              {
                //  ApicallingByinput(currentTabStatus,'',tabInfo)
                myLearningBloc.add(GetListEvent(pageNumber: 1, pageSize: 10, searchText: myLearningBloc.searchMyCourseString))

                // myLearningBloc.add(GetListEvent(
                //     pageNumber: 1, pageSize: 100, searchText: ""))
              }
          });
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => InAppWebCourseLaunch(url, table2)))
              .then((value) => {
                    if (value)
                      {
                        //  ApicallingByinput(currentTabStatus,'',tabInfo)
                        myLearningBloc.add(GetListEvent(pageNumber: 1, pageSize: 10, searchText: myLearningBloc.searchMyCourseString))

                        // myLearningBloc.add(GetListEvent(
                        //     pageNumber: 1, pageSize: 100, searchText: ""))
                      }
                  });
        }
        // logger.e(".....Refresh Me....$url");

        /// Refresh Content Of My Learning

      }
      }else{ setState(() { }); }
    }

    //sreekanth commented
    //Assignment content webview
    if (table2.objecttypeid == 694) {
      if(context != null){
      assignmentUrl =
          await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}/ismobilecontentview/true';
      print('assignmenturl is : $assignmentUrl');

      await Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => Assignmentcontentweb(
                    url: assignmentUrl,
                    myLearningModel: table2,
                  )))
          .then((value) => {
                if (value)
                  {

                    // ApicallingByinput(currentTabStatus,'',ConnectionDynamicTab())
                    myLearningBloc.add(GetListEvent(pageNumber: 1, pageSize: 10, searchText: myLearningBloc.searchMyCourseString))

                    // myLearningBloc.add(GetListEvent(
                    //     pageNumber: 1, pageSize: 10, searchText: ""))
                  }
              });

      String ss = "";
      }else{ setState(() { }); }

    }
    //sreekanth commented

    if (table2.objecttypeid == 8 ||
        table2.objecttypeid == 9 ||
        table2.objecttypeid == 10 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 26) {
      String paramsString = "";
      if (table2.objecttypeid == 10 && table2.bit5) {
         if(context != null){
        paramsString = "userID=${table2.userid}&scoid=${table2.scoid}&TrackObjectTypeID=${table2.objecttypeid}&TrackContentID=${table2.contentid}&TrackScoID=${table2.scoid}&SiteID=${table2.siteid}&OrgUnitID=${table2.siteid}&isonexist=onexit";
      } else {
        paramsString = "userID=${table2.userid}&scoid=${table2.scoid}";
      }

      String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      String url =
          "$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString";

      print('launchCourseUrl $url');

      detailsBloc.add(GetContentStatus(url: url, table2: table2));
    }
    }else{ setState(() { }); }
  }


  Widget _buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: 1.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  bool isValidString(String val) {
//    print('validstrinh $val');
    if (val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }

  Future<void> executeXAPICourse(
      DummyMyCatelogResponseTable2 learningModel) async {
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String paramsString = "strContentID=${learningModel.contentid}&UserID=$strUserID&SiteID=$strSiteID&SCOID=${learningModel.scoid}&CanTrack=true";

    String url = "${webApiUrl}CourseTracking/TrackLRSStatement?$paramsString";

    ApiResponse? apiResponse = await generalRepository.executeXAPICourse(url);
  }

  settingMyCourceBottomSheet(
      context, DummyMyCatelogResponseTable2 table2, int i,ConnectionDynamicTab tabInfo) {
//    print('bottomsheetobjit ${table2.objecttypeid}');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const BottomSheetDragger(),
                  displayPlay(table2,tabInfo),
                  displayView(table2,tabInfo),
                  (table2.iswishlistcontent == 1) ? displayAddToMyLearning(table2): Container(),
                  displayDetails(table2, i,tabInfo),
                  (table2.iswishlistcontent == 1) ? displayRemovefromwishlist(table2) : Container(),
                  displayJoin(table2),
                  // // displayDownload(table2, i), commented for till offline implementation
                  displayReport(table2),
                  displayaddToCalendar(table2),
                  displaySetComplete(table2),
                  displayRelatedContent(table2),
                  displayCancelEnrollemnt(table2, i),
                  displayDelete(table2),
                  myLearningBloc.showArchieve == "true"
                      ?  (table2.iswishlistcontent != 1) ? displayArchive(table2) : Container()
                      : Container(),

                  displayUnArachive(table2),
                  displayRemove(table2),
                  displayReschedule(table2,tabInfo),
                  displayCertificate(table2),
                  displayQRCode(table2),
                  displayEventRecording(table2),
                  displayShare(table2),
                  displayShareConnection(table2),

                  //sreekanth commented
                  // displaySendViaEmail(table2)
                ],
              ),
            ),
          );
        });
  }

  bool privilegeCreateForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 1349) {
        return true;
      }
    }
    return false;
  }

  Widget displaySendViaEmail(DummyMyCatelogResponseTable2 table2) {
    //if ((table2?.ShareContentwithUser?.length ?? 0) > 0) {
    if (privilegeCreateForumIdExists()) {
      if (table2.objecttypeid == 14) {
        return ListTile(
          leading: Icon(
            Icons.email,
            // IconDataSolid(int.parse('0xf06e')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(
              appBloc.localstr.mylearningsendviaemailnewoption.isEmpty
                  ? 'Share via Email'
                  : appBloc.localstr.mylearningsendviaemailnewoption,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SendviaEmailMylearning(
                      table2,
                      true,
                      myLearningBloc.list,
                    )));
          },
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }

//    return Container();
  }

  Widget displayShare(DummyMyCatelogResponseTable2 table2) {
    if ((table2.suggesttoconnlink.isNotEmpty ||
        table2.suggesttoconnlink.isNotEmpty) && table2.iswishlistcontent != 1) {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf1e0')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text('Share with Connection',
            style: TextStyle(
                color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
            ))),
        onTap: () {
          Navigator.pop(context);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShareWithConnections(
                  false, false, table2.name, table2.contentid)));
        },
      );
    }

    return Container();
  }

  Widget displayShareConnection(DummyMyCatelogResponseTable2 table2) {
    if ((table2.suggestwithfriendlink.isNotEmpty ||
        table2.suggestwithfriendlink.isNotEmpty) && table2.iswishlistcontent != 1) {
      return ListTile(
        leading: Icon(
          IconDataSolid(
            int.parse('0xf079'),
          ),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text("Share with People",
            style: TextStyle(
                color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
            ))),
        onTap: () {
          Navigator.pop(context);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShareMainScreen(
                  true, false, false, table2.contentid, table2.name)));
        },
      );
    }

    return Container();
  }

  Widget displayUnArachive(DummyMyCatelogResponseTable2 table2) {
    if (detailsBloc.myLearningDetailsModel.isArchived) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf187')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetUnarchiveoption,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            myLearningBloc.add(RemoveToArchiveCall(
              isArchive: false,
              strContentID: table2.contentid,
              table2: table2,
            ));
            Navigator.pop(context);
          });
    } else {
      return Container();
    }
  }

  Widget displayRemove(DummyMyCatelogResponseTable2 table2) {
//    print('removetable ${table2.removelink}');
    if ((table2.objecttypeid == 70 && table2.bit4 != null && table2.bit4) ||
        (table2.removelink)) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf056')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(
              appBloc.localstr.mylearningActionsheetRemovefrommylearning,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        appBloc.localstr.mylearningAlerttitleStringareyousure,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                      ),
                      content: Text(
                        appBloc.localstr
                            .mylearningAlertsubtitleRemovethecontentitem,
                        style: TextStyle(
                            color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        )),
                      ),
                      backgroundColor: Color(
                        int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                              appBloc.localstr.mylearningAlertbuttonYesbutton),
                          textColor: Colors.blue,
                          onPressed: () async {
                            Navigator.of(context).pop();

                            setState(() {
                              myLearningBloc.isFirstLoading = true;
                              myLearningBloc.add(RemoveFromMyLearning(
                                  contentId: table2.contentid));
                            });
                          },
                        ),
                      ],
                    ));
//
          });
    } else {
      return Container();
    }
  }

  Widget displayReschedule(DummyMyCatelogResponseTable2 table2,ConnectionDynamicTab tabInfo) {
    if ((table2.reschduleparentid != null) && (isValidString(table2.reschduleparentid))) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf783')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(
              appBloc.localstr.mylearningActionbuttonRescheduleactionbutton,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),

          // TODO : Sprint -3

          onTap: () {
            Navigator.pop(context);
            if ((table2.objecttypeid == 70 && table2.eventscheduletype == 2) ||
                table2.objecttypeid == 70 && table2.eventscheduletype == 1) {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => CommonDetailScreen(
                        screenType: ScreenType.MyLearning,
                        contentid: table2.reschduleparentid,
                        objtypeId: table2.objecttypeid,
                        detailsBloc: detailsBloc,
                        table2: table2,
                        //     nativeModel: widget.nativeModel,
                        isFromReschedule: true,
                        //isFromMyLearning: true
                      )))
                  .then((value) => {
                        if (true)
                          {

                            apiCallingByInput(currentTabStatus,'',tabInfo)

                            // myLearningBloc.add(GetListEvent(
                            //     pageNumber: 1, pageSize: 10, searchText: ""))
                          }
                      });
            }
          });
    }

    return Container();
  }

  Widget displayCertificate(DummyMyCatelogResponseTable2 table2) {
    if ((table2.certificateaction != null) && isValidString(table2.certificateaction)) {
      return ListTile(
          leading: SvgPicture.asset(
            'assets/Certificate.svg',
            width: 25.h,
            height: 25.h,
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(
              appBloc.localstr.mylearningActionsheetViewcertificateoption,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            if ((table2.certificateaction != null) && !isValidString(table2.certificateaction) ||
                table2.certificateaction == 'notearned') {
              Navigator.of(context).pop();

              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          appBloc.localstr
                              .mylearningActionsheetViewcertificateoption,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        content: Text(
                          appBloc.localstr
                              .mylearningAlertsubtitleForviewcertificate,
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        backgroundColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(appBloc.localstr
                                .mylearningClosebuttonactionClosebuttonalerttitle),
                            textColor: Colors.blue,
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            } else {
              detailsBloc.myLearningDetailsModel.setcontentID(table2.contentid);
              detailsBloc.myLearningDetailsModel
                  .setCertificateId(table2.certificateid);
              detailsBloc.myLearningDetailsModel
                  .setCertificatePage(table2.certificatepage);

              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ViewCertificate(detailsBloc: detailsBloc)));
            }
          });
    }
    return Container();
  }

  Widget displayQRCode(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
      if ((table2.qrimagename != null) && isValidString(table2.qrimagename) &&
          (table2.qrcodeimagepath != null) && isValidString(table2.qrcodeimagepath) &&
          !table2.bit4) {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf029')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetViewqrcode,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QrCodeScreen(
                    ApiEndpoints.strSiteUrl + table2.qrcodeimagepath)));
          },
        );
      }
    }

    return Container();
  }

  Widget displayEventRecording(DummyMyCatelogResponseTable2 table2) {
    if (isValidString(table2.eventrecording.toString()) &&
        table2.eventrecording) {
      if (table2.isaddedtomylearning == 1 ||
          typeFrom == "event" ||
          typeFrom == "track") {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf8d9')),
            color: InsColor(appBloc).appIconColor,
          ),
          title:
              Text(appBloc.localstr.learningtrackLabelEventviewrecording),
          onTap: () => {
            //todo : sprint -3
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => QrCodeScreen(table2.qrimagename)))
          },
        );
      } else {
        return Container();
      }
    }

    return Container();
  }

  Widget displayArchive(DummyMyCatelogResponseTable2 table2) {
    if (!detailsBloc.myLearningDetailsModel.isArchived) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf187')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetArchiveoption,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            myLearningBloc.add(AddToArchiveCall(isArchive: true, strContentID: table2.contentid, table2: table2));
            if (table2.actualstatus == "completed") { //Completed
              myLearningPlusCompletedList.remove(table2);
            }
            else if(table2.actualstatus == "incomplete"){ //In Progress ("inprogress,incomplete,grade")
              //mylearningplusinprolist.clear();
              myLearningPlusInProList.remove(table2);
            }
            else if((table2.actualstatus == "not attempted" || table2.actualstatus == "registered")){ //Not started
              myLearningPlusNotStartProList.remove(table2);
            }
            else if((table2.actualstatus == "attended") || (table2.actualstatus == "notattended")){  //Attending
              myLearningPlusAttendProList.remove(table2);
            }
            else if(table2.waitlistenrolls == 1 || table2.waitlistlimit == 1) { // waitlist tab related
              myLearningPlusWaitProList.remove(table2);
            }
            Navigator.pop(context);
          });
    } else {
      return Container();
    }
  }

  Widget displayPlay(DummyMyCatelogResponseTable2 table2,ConnectionDynamicTab tabInfo) {
    if (table2.objecttypeid == 11 ||
        table2.objecttypeid == 14 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 20 ||
        table2.objecttypeid == 21 ||
        table2.objecttypeid == 52) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return ListTile(
            leading: Icon(
              IconDataSolid(int.parse('0xf144')),
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(
              (appBloc.localstr.mylearningActionsheetPlayoption != null) ? appBloc.localstr.mylearningActionsheetPlayoption : '',
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              )),
            ),
            onTap: () {
              Navigator.of(context).pop();

              if ((table2.viewprerequisitecontentstatus != null) && isValidString(table2.viewprerequisitecontentstatus)) {
//                print('ifdataaaaa');
                String alertMessage =
                    appBloc.localstr.prerequistesalerttitle6Alerttitle6;
                alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(
                            appBloc.localstr.detailsAlerttitleStringalert,
                            style: TextStyle(
                                color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                ),
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            alertMessage,
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                          ),
                          backgroundColor: InsColor(appBloc).appBGColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                  appBloc.localstr.eventsAlertbuttonOkbutton),
                              textColor: Colors.blue,
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
              } else {
                launchCourse(table2, context, false,tabInfo:tabInfo);
              }
            });
      }
    }

    return Container();
  }

  Widget displayDetails(DummyMyCatelogResponseTable2 table2, int i,ConnectionDynamicTab tabInfo) {
    table2.isaddedtomylearning = 1;
    if (typeFrom == "event" || typeFrom == "track") {
      return Container();
    }

    if (table2.objecttypeid == 70 && (table2.bit4 != null && table2.bit4)) {
      return Container();
    }
    return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf570')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text((appBloc.localstr.mylearningActionsheetDetailsoption != null) ? appBloc.localstr.mylearningActionsheetDetailsoption : appBloc.localstr.mylearningActionsheetDetailsoption,
            style: TextStyle(
                color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
            ))),
        onTap: () {
          Navigator.pop(context);
          if (table2.objecttypeid == 70 && table2.eventscheduletype == 2
              /*appBloc.uiSettingModel.EnableMultipleInstancesforEvent ==
                  'true'*/
              ) {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => CommonDetailScreen(
                      screenType: ScreenType.MyLearning,
                      contentid: table2.contentid,
                      objtypeId: table2.objecttypeid,
                      detailsBloc: detailsBloc,
                      table2: table2,
                      //     nativeModel: widget.nativeModel,
                      isFromReschedule: false,
                      //isFromMyLearning: false
                    )))
                .then((value) => {
                      if (value == true)
                        {

                          apiCallingByInput(currentTabStatus,'',tabInfo)

                          // myLearningBloc.add(GetListEvent(
                          //     pageNumber: 1, pageSize: 10, searchText: ""))
                        }
                    });
          } else if (table2.objecttypeid == 70) {
            print(
                'isaddedtomylearning${table2.isaddedtomylearning}');
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => CommonDetailScreen(
                        screenType: ScreenType.MyLearning,
                        contentid: table2.contentid,
                        objtypeId: table2.objecttypeid,
                        detailsBloc: detailsBloc,
                        table2: table2,
                        isFromReschedule: false)))
                .then((value) => {
                      if (value == true)
                        {
                          apiCallingByInput(currentTabStatus,'',tabInfo)

                          // myLearningBloc.add(GetListEvent(
                          //     pageNumber: 1, pageSize: 10, searchText: ""))
                        }
                    });
          } else {
            print(
                'isaddedtomylearning${table2.isaddedtomylearning}');
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => CommonDetailScreen(
                        screenType: ScreenType.MyLearning,
                        contentid: table2.contentid,
                        objtypeId: table2.objecttypeid,
                        detailsBloc: detailsBloc,
                        table2: table2,
                        pos: i,
                        mylearninglist: myLearningBloc.list,
                        isFromReschedule: false
                        //isFromMyLearning: true
                        )))
                .then((value) => {
                      if (value == true)
                        {
                          apiCallingByInput(currentTabStatus,'',tabInfo)

                          // myLearningBloc.add(GetListEvent(
                          //     pageNumber: 1, pageSize: 10, searchText: ""))
                        }
                    });
          }
        });
  }

  Widget displayRemovefromwishlist(DummyMyCatelogResponseTable2 table2){
    return ListTile(
      title: Text(
          appBloc.localstr
              .catalogActionsheetRemovefromwishlistoption,
          style: TextStyle(
              color: InsColor(appBloc).appTextColor)),
      leading: Icon(
        Icons.favorite,
        color: InsColor(appBloc).appIconColor,
      ),
      onTap: () {
        catalogBloc.add(RemoveFromWishListEvent(
            contentId: table2.contentid));
        Navigator.of(context).pop();
      },
    );
  }

  Widget displayJoin(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
      if ((table2.eventenddatetime != null) && isValidString(table2.eventenddatetime)) if (!returnEventCompleted(
          table2.eventenddatetime)) {
        if (table2.typeofevent == 2) {
          return ListTile(
            leading: Icon(
              IconDataSolid(int.parse('0xf234')),
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(appBloc.localstr.mylearningActionsheetJoinoption,
                style: TextStyle(
                    color: Color(
                  int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                ))),
            onTap: () {
              Navigator.pop(context);
              String joinUrl = table2.joinurl;

              print('joinurllll ${table2.joinurl}');

              if (joinUrl.isNotEmpty) {
                _launchInBrowser(joinUrl);
              } else {
                flutterToast.showToast(
                  child: CommonToast(displaymsg: 'No url found'),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: const Duration(seconds: 2),
                );
//              Toast.makeText(v.getContext(), "No Url Found", Toast.LENGTH_SHORT).show();
              }
            },
          );
        } else if (table2.typeofevent == 1) {
          return Container();
        }
      }
    }
//
    return Container();
  }

  Widget displayView(DummyMyCatelogResponseTable2 table2,ConnectionDynamicTab tabInfo) {
    if (table2.objecttypeid == 11 ||
        table2.objecttypeid == 14 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 20 ||
        table2.objecttypeid == 21 ||
        table2.objecttypeid == 52) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return Container();
      } else {
        if(table2.iswishlistcontent != 1){
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf06e')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text((appBloc.localstr.mylearningActionsheetViewoption != null) ? appBloc.localstr.mylearningActionsheetViewoption: '',
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            Navigator.of(context).pop();

            if ((table2.viewprerequisitecontentstatus != null) && isValidString(table2.viewprerequisitecontentstatus)) {
//              print('ifdataaaaa');
              String alertMessage =
                  appBloc.localstr.prerequistesalerttitle6Alerttitle6;
              alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          appBloc.localstr.detailsAlerttitleStringalert,
                          style: TextStyle(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ),
                              fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          children: [
                            Text(alertMessage,
                                style: TextStyle(
                                    color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                ))),
                            Text(
                                table2.viewprerequisitecontentstatus
                                    .toString()
                                    .split('#%')[1]
                                    .split('\$;')[0],
                                style: TextStyle(
                                    color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                ))),
                            Text(
                                table2.viewprerequisitecontentstatus
                                    .toString()
                                    .split('#%')[1]
                                    .split('\$;')[1],
                                style: TextStyle(
                                    color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                )))
                          ],
                        ),
                        backgroundColor: InsColor(appBloc).appBGColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                                appBloc.localstr.eventsAlertbuttonOkbutton),
                            textColor: Colors.blue,
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            } else {
//
              launchCourse(table2, context, false,tabInfo:tabInfo);
            }
          },
        );}else return Container();
      }
    } else if (table2.objecttypeid == 688 || table2.objecttypeid == 70) {
      return Container();
    } else {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf06e')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text(appBloc.localstr.mylearningActionsheetViewoption,
            style: TextStyle(
                color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
            ))),
        onTap: () {
          Navigator.of(context).pop();

          if ((table2.viewprerequisitecontentstatus != null) && isValidString(table2.viewprerequisitecontentstatus)) {
//            print('ifdataaaaa');
            String alertMessage =
                appBloc.localstr.prerequistesalerttitle6Alerttitle6;
            alertMessage = alertMessage;
            // "  \"" +
            // appBloc.localstr.prerequisLabelContenttypelabel +
            // "\" " +
            // appBloc.localstr.prerequistesalerttitle5Alerttitle7;

            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        'Pre-requisite Sequence',
                        style: TextStyle(
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ),
                            fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alertMessage,
                              style: TextStyle(
                                  color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                          Text(
                              '\n${table2.viewprerequisitecontentstatus
                                      .toString()
                                      .split('#%')[1]
                                      .split('\$;')[0]}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.blue,
                              )),
                          Text(
                              table2.viewprerequisitecontentstatus
                                  .toString()
                                  .split('#%')[1]
                                  .split('\$;')[1],
                              style: TextStyle(
                                  color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              )))
                        ],
                      ),
                      backgroundColor: InsColor(appBloc).appBGColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      actions: <Widget>[
                        FlatButton(
                          child:
                              Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                          textColor: Colors.blue,
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          } else {
//
            launchCourse(table2, context, false,tabInfo:tabInfo);
          }
        },
      );
    }
//    return Container();
  }

  Widget displayAddToMyLearning(DummyMyCatelogResponseTable2 table2,){
   return  ListTile(
    title: Text(
        appBloc.localstr
            .catalogActionsheetAddtomylearningoption,
        style: TextStyle(
            color: InsColor(appBloc).appTextColor)),
    leading: Icon(
      Icons.add,
      color: InsColor(appBloc).appIconColor,
    ),
    onTap: () {
      catalogBloc.add(AddToMyLearningEvent(
          contentId: table2.contentid,
          table2: table2));
      Navigator.of(context).pop();
    },
  );
  }

  Widget displayReport(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 11 ||
        table2.objecttypeid == 14 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 20 ||
        table2.objecttypeid == 21 ||
        table2.objecttypeid == 52) {
      return Container();
    } else if (table2.objecttypeid == 70) {
      return Container();
    } else if (table2.objecttypeid == 688) {
      return Container();
    } else {
      if (table2.objecttypeid == 27) {
        return Container();
      } else {
        if (!isReportEnabled) {
          return Container();
        }

        return ListTile(
            leading: SvgPicture.asset(
              'assets/Report.svg',
              width: 25.h,
              height: 25.h,
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(appBloc.localstr.mylearningActionsheetReportoption,
                style: TextStyle(
                    color: Color(
                  int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                ))),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProgressReport(table2, detailsBloc, "", "-1")));
            });
      }
    }

    return Container();
  }

  Widget displayaddToCalendar(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70 && table2.iswishlistcontent != 1) {
//      print(
//          'addtocalendar ${table2.objecttypeid} ${table2.eventenddatetime} ${returnEventCompleted(table2.eventenddatetime)}');

      if ((table2.eventenddatetime != null) && isValidString(table2.eventenddatetime)) if (!returnEventCompleted(
          table2.eventenddatetime)) {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf271')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(
              appBloc.localstr.mylearningActionsheetAddtocalendaroption,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            DateTime startDate = DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(table2.eventstartdatetime);
            DateTime endDate = DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(table2.eventenddatetime);

//            print(
//                'event start-end time ${table2.eventstartdatetime}  ${table2.eventenddatetime}');
            Event event = Event(
              title: table2.name,
              description: table2.shortdescription,
              location: table2.locationname,
              startDate: startDate,
              endDate: endDate,
              allDay: false,
            );

            Add2Calendar.addEvent2Cal(event).then((success) {
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: success
                        ? 'Event added successfully'
                        : 'Error occured while adding event'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            });
          },
        );
      }

      if (table2.eventscheduletype == 1 &&
          appBloc.uiSettingModel.enableMultipleInstancesForEvent == 'true') {
        return Container();
      }
    }

    return Container();
  }

  Widget displaySetComplete(DummyMyCatelogResponseTable2 table2) {
//    print('actualstatuss ${table2.actualstatus} ${table2.objecttypeid}');
    if ((table2.objecttypeid != null) && isValidString(table2.objecttypeid.toString()) &&
        (table2.objecttypeid == 11 ||
            table2.objecttypeid == 14 ||
            table2.objecttypeid == 36 ||
            table2.objecttypeid == 28 ||
            table2.objecttypeid == 20 ||
            table2.objecttypeid == 21 ||
            table2.objecttypeid == 52)) {
      if ((table2.actualstatus != null) && isValidString(table2.actualstatus) &&
          ((table2.actualstatus != 'completed') &&
            (table2.actualstatus != 'not attempted'))) {
        return ListTile(
            leading: SvgPicture.asset(
              'assets/SetComplete.svg',
              width: 25.h,
              height: 25.h,
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(
                appBloc.localstr.mylearningActionsheetSetcompleteoption,
                style: TextStyle(
                    color: Color(
                  int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                ))),
            onTap: () {
              Navigator.pop(context);
              detailsBloc.add(SetCompleteEvent(table2: table2));
            });
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget displayRelatedContent(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
      if (table2.relatedconentcount > 0) {
        return ListTile(
            leading: Icon(
              Icons.content_copy,
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(
                appBloc.localstr.mylearningActionsheetRelatedcontentoption,
                style: TextStyle(
                    color: Color(
                  int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                ))),
            onTap: () {
              Navigator.of(context).pop();

              if ((table2.viewprerequisitecontentstatus != null) && isValidString(table2.viewprerequisitecontentstatus)) {
                String alertMessage =
                    appBloc.localstr.prerequistesalerttitle6Alerttitle6;
                alertMessage = "${alertMessage +
                    " \"" +
                    table2.viewprerequisitecontentstatus}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(
                            appBloc.localstr.detailsAlerttitleStringalert,
                            style: TextStyle(
                                color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                ),
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            alertMessage,
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                          ),
                          backgroundColor: InsColor(appBloc).appBGColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                  appBloc.localstr.eventsAlertbuttonOkbutton),
                              textColor: Colors.blue,
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
              } else {
                if (table2.objecttypeid == 70) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EventTrackList(
                            table2,
                            false,
                            myLearningBloc.list
                          )));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EventTrackList(
                            table2,
                            true,
                            myLearningBloc.list
                          )));
                }
              }
            });
      }
    }

    return Container();
  }

  Widget displayCancelEnrollemnt(DummyMyCatelogResponseTable2 table2, int i) {
    pos = i;

    if (table2.objecttypeid == 70 && table2.iswishlistcontent != 1) {
      // returnEventCompleted
      if ((table2.eventstartdatetime != null) && isValidString(table2.eventstartdatetime)) if (!returnEventCompleted(
          table2.eventstartdatetime)) {
//
        if (table2.bit2 != null && table2.bit2) {
          return ListTile(
              leading: Icon(
                IconDataSolid(int.parse('0xf410')),
                color: InsColor(appBloc).appIconColor,
              ),
              title: Text(
                  appBloc.localstr.mylearningActionsheetCancelenrollmentoption,
                  style: TextStyle(
                      color: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  ))),
              onTap: () {
                checkCancellation(table2, context);
              });
        }
// for schedule events
        if (table2.eventscheduletype == 1 &&
            appBloc.uiSettingModel.enableMultipleInstancesForEvent == 'true') {
          return ListTile(
              leading: const Icon(Icons.cancel),
              title: Text(
                  appBloc.localstr.mylearningActionsheetCancelenrollmentoption,
                  style: TextStyle(
                      color: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  ))),
              onTap: () {
                checkCancellation(table2, context);
              });
        }
      }
    }

    return Container();
  }

  void downloadPath(
      String contentid, DummyMyCatelogResponseTable2 table2) async {
    String path = "${await AppDirectory.getDocumentsDirectory()}/.Mydownloads/Contentdownloads/$contentid";

    setState(() {
      downloadDestFolderPath = path;
    });

    final File myFile = File(downloadDestFolderPath);

    print('myfiledata $myFile');

    checkFile(downloadDestFolderPath, table2);
  }

  void checkFile(String path, DummyMyCatelogResponseTable2 table2) async {
    final savedDir = Directory(path);
    if (await savedDir.exists()) {
      setState(() {
        fileExists = true;
        table2.isdownloaded = true;
      });
    } else {
      setState(() {
        fileExists = false;
        table2.isdownloaded = false;
      });
    }

    print('ifmufileexsit $fileExists');
  }

  Widget displayDelete(DummyMyCatelogResponseTable2 table2) {
    downloadPath(table2.contentid, table2);

    if (table2.isdownloaded && table2.objecttypeid != 70) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf1f8')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetDeleteoption,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),

          /// TODO : Sagar sir - delete offline file
          onTap: () async {
            Navigator.pop(context);

            bool fileDel = await deleteFile(downloadDestFolderPath);

            if (fileDel) {
              setState(() {
                isDownloaded = false;
                isDownloading = false;
                downloadedProgress = 0;
                table2.isdownloaded = false;
                table2.isDownloading = false;
              });
            }
          });
    }

    return Container();
  }

  Future<bool> deleteFile(String downloadDestFolderPath) async {
    try {
      final savedDir = Directory(downloadDestFolderPath);
      if (await savedDir.exists()) {
        await savedDir.delete(recursive: true);
        print('dir existes');
        return true;
      } else {
        print('dir does not existes');
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  void checkCancellation(
      DummyMyCatelogResponseTable2 table2, BuildContext context) {
    print('checkcancellation ${table2.isbadcancellationenabled}');

    Navigator.of(context).pop();
    if (table2.isbadcancellationenabled) {
      badCancelEnrollmentMethod(table2);

      // bad cancel
    } else {
      showCancelEnrollDialog(
          table2, table2.isbadcancellationenabled.toString());
    }
  }

  void badCancelEnrollmentMethod(DummyMyCatelogResponseTable2 table2) {
    eventModuleBloc
        .add(BadCancelEnrollment(contentid: table2.contentid, table2: table2));
  }

  void showCancelEnrollDialog(
      DummyMyCatelogResponseTable2 table2, String isSuccess) {
    showDialog(
        context: context,barrierColor: Colors.transparent.withOpacity(0.25),
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                appBloc.localstr.mylearningAlerttitleStringareyousure,
                style: TextStyle(
                    color: InsColor(appBloc).appTextColor,
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                appBloc.localstr
                    .mylearningAlertsubtitleDoyouwanttocancelenrolledevent,
                style: TextStyle(
                    color: InsColor(appBloc).appTextColor,
                    fontWeight: FontWeight.normal),
              ),
              backgroundColor: InsColor(appBloc).appBGColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              actions: <Widget>[
                FlatButton(
                  child: Text(appBloc.localstr.catalogAlertbuttonCancelbutton),
                  textColor: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                  textColor: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    cancelEnrollment(table2, isSuccess);
                  },
                ),
              ],
            ));
  }

  void cancelEnrollment(DummyMyCatelogResponseTable2 table2, String bool) {
    eventModuleBloc.add(TrackCancelEnrollment(
        isBadCancel: bool, strContentID: table2.contentid, table2: table2));
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool returnEventCompleted(String eventDate) {
//
    if (eventDate.isEmpty) return false;
//
    bool isCompleted = false;
//

    DateTime? fromDate;
    var difference;

    if (!isValidString(eventDate)) return false;

    try {
      fromDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(eventDate);

      final date2 = DateTime.now();
      difference = date2.difference(fromDate).inDays;
    } catch (e) {
      //e.printStackTrace();
      isCompleted = false;
    }
    if (fromDate == null) return false;

//    print('fiffenrecedays $difference');
    if (difference != null && difference < 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }

    return isCompleted;
  }



  Widget getAppBarView(
      BuildContext context, UserAchievementResponse achievementResponse) {
    String overallPoints = "", totalPointsString = "";

    String pointsString = "";
    String badgesString = "";

      if (userAchievementResponse.userOverAllData != null) {
      int needpoints = userAchievementResponse.userOverAllData != null
        ? userAchievementResponse.userOverAllData!.neededPoints
        : 0;
      int currentpoints = userAchievementResponse.userOverAllData != null
          ? userAchievementResponse.userOverAllData!.overAllPoints
          : 0;
      int totalpoints = needpoints + currentpoints;

      String pointslevel = userAchievementResponse.userOverAllData != null
        ? userAchievementResponse.userOverAllData!.neededLevel
        : "Beginner";
      overallPoints = "$needpoints Points to $pointslevel";
      pointsString = "$currentpoints";
      totalPointsString = "$totalpoints";
      badgesString = "${userAchievementResponse.userOverAllData?.badges ?? 0}";

      progress = currentpoints / totalpoints;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      color: bannerBackgroundType == "true" ?
      Color(int.parse(
          "0xFF${headerBackgroundColor.substring(1, 7).toUpperCase()}"))
          : Colors.lightGreen,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Container(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: achievementResponse
                                        .userOverAllData?.userProfilePath !=
                                    null
                                ? achievementResponse
                                    .userOverAllData!.userProfilePath
                                : imgUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => ClipOval(
                              child: CircleAvatar(
                                radius: 25,
                                child: Text(
                                  achievementResponse.userOverAllData?.userDisplayName ==
                                          null
                                      ? ''
                                      : achievementResponse
                                          .userOverAllData!.userDisplayName[0],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
                                ),
                                backgroundColor: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                              ),
                            ),
                            errorWidget: (context, url, error) => ClipOval(
                              child: CircleAvatar(
                                radius: 25,
                                child: Text(
                                  achievementResponse.userOverAllData
                                              ?.userDisplayName ==
                                          null
                                      ? ''
                                      : achievementResponse
                                          .userOverAllData!.userDisplayName[0],
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
                                ),
                                backgroundColor: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${achievementResponse.userOverAllData?.userDisplayName}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            showLevels == "true"?
                            Text(
                              '${achievementResponse.userOverAllData?.userLevel}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ):Container(),
                          ],
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 4,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: showPoints == "true" ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Points',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${achievementResponse.userOverAllData?.overAllPoints}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ):Container(),
                        ),
                        Expanded(
                            flex: 1,
                            child: showBadges == "true" ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Badges',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${achievementResponse.userOverAllData?.badges}',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ):Container()),
                      ],
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          showLevels == "true" ?
          LinearProgressIndicator(
            minHeight: 8,
            value: progress,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffff9503)),
            backgroundColor: Colors.grey,
          ):Container(),
          const SizedBox(
            height: 15,
          ),
          achievementResponse.userOverAllData?.neededLevel == null ? Container() :
          showLevels == "true" ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  '${achievementResponse.userOverAllData?.neededPoints} Points to next level : ${achievementResponse.userOverAllData?.neededLevel}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${(achievementResponse.userOverAllData?.overAllPoints ?? 0) + (achievementResponse.userOverAllData?.neededPoints ?? 0)} Points',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ):Container(),
        ],
      ),
    );
  }

//Show Bottomsheet

}
