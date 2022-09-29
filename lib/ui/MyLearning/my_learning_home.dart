import 'dart:async';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/controllers/connection_controller.dart';
import 'package:flutter_admin_web/controllers/my_learning_download_controller.dart';
import 'package:flutter_admin_web/controllers/mylearning_controller.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/EventTrackList/bloc/event_track_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
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
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/download_course.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/catalog_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/models/my_learning/download_feature/mylearning_download_model.dart';
import 'package:flutter_admin_web/providers/my_learning_download_provider.dart';
import 'package:flutter_admin_web/ui/MyLearning/SendviaEmailMylearning.dart';
import 'package:flutter_admin_web/ui/MyLearning/components/mylearning_component_card.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/mylearning_filter.dart';
import 'package:flutter_admin_web/ui/MyLearning/progress_report.dart';
import 'package:flutter_admin_web/ui/MyLearning/qr_code_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/MyLearning/view_certificate.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/bottomsheet_drager.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/ui/common/modal_progress_hud.dart';
import 'package:flutter_admin_web/ui/common/rounded_square_progress_indicator.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../global_search_screen.dart';
import 'common_detail_screen.dart';

class ActMyLearning extends StatefulWidget {
  final NativeMenuModel nativeModel;
  final String contentId;

  ActMyLearning({
    required this.nativeModel,
    required this.contentId,
  });

  @override
  _ActMyLearningState createState() => _ActMyLearningState();
}

class _ActMyLearningState extends State<ActMyLearning> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String contentId = '';

  late TabController _tabController;
  List<Tab> tabList = [];
  ScrollController _sc = ScrollController();
  ScrollController _scArchive = ScrollController();
  bool isReportEnabled = true;

  int pageNumber = 1;
  int totalPage = 10;
  bool isGetListEvent = false;

  int pageArchiveNumber = 1;
  bool isGetArchiveListEvent = false;

  bool fileExists = false;
  String componentId = "";

  String typeFrom = '';
  String downloadDestFolderPath = '';

  bool isShownMyDownloadBottomsheet = false;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  EventTrackBloc get eventTrackBloc => BlocProvider.of<EventTrackBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);
  late MyLearningDetailsBloc detailsBloc;
  late FToast flutterToast;
  late ProfileBloc profileBloc;
  late CatalogBloc catalogBloc;

  String assignmenturl = '';

  // for cource lounch

  GotoCourseLaunch? courseLaunch;
  DownloadCourse? downloadCourse;
  late GeneralRepository generalRepository;

  StreamController<int> streamController = StreamController();

  Logger logger = Logger();

  late EvntModuleBloc evntModuleBloc;

  int pos = 0;

  ButtonStyle textButtonStyle = TextButton.styleFrom(
    primary: Colors.blue,
  );

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: Colors.black,
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _settingMyCourceBottomSheet(context, DummyMyCatelogResponseTable2 table2, int i) async {

    MyLearningDownloadModel myLearningDownloadModel = MyLearningDownloadModel(table2: table2);

    MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(context, listen: false);
    List<MyLearningDownloadModel> downloads = myLearningDownloadProvider.downloads.where((element) => element.table2.contentid == table2.contentid).toList();
    if(downloads.isNotEmpty) {
      myLearningDownloadModel = downloads.first;
    }

    await showModalBottomSheet(
      context: context,
      shape: AppConstants().bottomSheetShapeBorder(),
      builder: (BuildContext bc) {
        return AppConstants().bottomSheetContainer(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BottomSheetDragger(),
                displayPauseDownload(table2, myLearningDownloadModel),
                displayResumeDownload(table2, myLearningDownloadModel),
                displayCancelDownload(table2, myLearningDownloadModel),
                displayRemoveFromDownload(table2, myLearningDownloadModel),
                displayPlay(table2),
                displayView(table2),
                displayDetails(table2, i),
                displayJoin(table2),
                // displayDownload(table2, i), commented for till offline implementation
                displayReport(table2),
                displayaddToCalendar(table2),
                displaySetComplete(table2),
                displayRelatedContent(table2),
                displayCancelEnrollemnt(table2, i),
                //displayDelete(table2),
                myLearningBloc.showArchieve == 'true'
                    ? displayArchive(table2)
                    : Container(),
                displayUnArachive(table2),
                displayRemove(table2),
                displayReschedule(table2),
                displayCertificate(table2),
                displayQRCode(table2),
                displayEventRecording(table2),
                displayShare(table2),
                displayShareConnection(table2),
                //sreekanth commented
                displaySendViaEmail(table2)
              ],
            ),
          ),
        );
      },
    );
    //await myLearningBloc.checkifFileExist(myLearningBloc.list);
    setState(() {});
  }

  Future<void> showBottomSheetForMyDownloads(context, DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) async {
    isShownMyDownloadBottomsheet = true;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Color(
            int.parse(
                '0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}'),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BottomSheetDragger(),
                displayPauseDownload(table2, downloadModel),
                displayResumeDownload(table2, downloadModel),
                displayCancelDownload(table2, downloadModel),
                displayRemoveFromDownload(table2, downloadModel),
              ],
            ),
          ),
        );
      },
    );
    isShownMyDownloadBottomsheet = false;
  }

  //region card functions
  void _onMoreTap(DummyMyCatelogResponseTable2 table2, int i, bool isFromMyDownloads, {MyLearningDownloadModel? downloadModel}) {
    if (isFromMyDownloads) {
      if(downloadModel != null) {
        showBottomSheetForMyDownloads(context, table2, downloadModel);
      }
    }
    else {
      _settingMyCourceBottomSheet(context, table2, i);
    }
  }

  void _onArchivedTap(DummyMyCatelogResponseTable2 table2) {
    myLearningBloc.add(RemoveToArchiveCall(
      isArchive: false,
      strContentID: table2.contentid,
      table2: table2,
    ));
  }

  void _onReviewTap(DummyMyCatelogResponseTable2 table2) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ReviewScreen(
        table2.contentid,
        false,
        detailsBloc,
      );
    })).then((value) {
      if (value == true) {
        refreshMyLearningContents();
      }
    });
  }

  void _onViewTap(DummyMyCatelogResponseTable2 table2, {bool isArchieved = false}) async {
    bool isValidate = isValidString(table2.viewprerequisitecontentstatus ?? '');
    print('isValidate:$isValidate');

    if (isValidate) {
      print('ifdataaaaa');
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = alertMessage +
          '  \"' +
          appBloc.localstr.prerequisLabelContenttypelabel +
          '\" ' +
          appBloc.localstr.prerequistesalerttitle5Alerttitle7;

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'Pre-requisite Sequence',
              style: TextStyle(
                  color: Color(
                    int.parse(
                        '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
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
                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                        ))),
                Text(
                    '\n' +
                        table2.viewprerequisitecontentstatus
                            .toString()
                            .split('#%')[1]
                            .split('\$;')[0],
                    style: TextStyle(
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
                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                        )))
              ],
            ),
            backgroundColor: InsColor(appBloc).appBGColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            actions: <Widget>[
              TextButton(
                child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                style: textButtonStyle,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    }
    else {
      // covered
      bool result = await MyLearningController().decideCourseLaunchMethod(
        context: context,
        table2: table2,
        isContentisolation: false,
      );
      if (!result) {
        table2.isdownloaded = false;
        setState(() {});
      }

      // bool networkAvailable = await AppDirectory.checkInternetConnectivity();
      // if (networkAvailable) {
      //   await MyLearningController().launchCourse(context: context, table2: table2, isContentisolation: false);
      // }
      // else {
      //   //launchCourseOffline(table2);
      //   bool isShownOffline = await MyLearningController().launchCourseOffline(context: context, table2: table2);
      //   if (!isShownOffline) {
      //     table2.isdownloaded = false;
      //     setState(() {});
      //   }
      // }
      refreshContent(table2);
    }
  }

  void onDownloadPaused(MyLearningDownloadModel? downloadModel) {
    MyPrint.printOnConsole("onDownloadPaused called:$downloadModel, Task Id:${downloadModel?.taskId}");
    if(downloadModel != null && downloadModel.taskId.isNotEmpty) {
      MyLearningDownloadController().resumeDownload(downloadModel);
    }
  }

  void onDownloading(MyLearningDownloadModel? downloadModel) {
    MyPrint.printOnConsole("onDownloading called");
    if(downloadModel != null && downloadModel.taskId.isNotEmpty) {
      MyLearningDownloadController().pauseDownload(downloadModel);
    }
  }

  void _onDownloadTap(DummyMyCatelogResponseTable2 table2) async {
    MyPrint.printOnConsole("_onDownloadTap called");

    if (table2.isdownloaded) {
      return;
    }

    if(ConnectionController().checkConnection(context: NavigationController().actbaseScaffoldKey.currentContext!)) {
      setState(() {
        table2.isDownloading = true;
        //isLoading = true;
      });

      //bool isDownloaded = await MyLearningController().storeMyLearningContentOffline(context, table2, appBloc.userid);
      bool isDownloaded = await MyLearningDownloadController().storeMyLearningContentOffline(
        context,
        table2, appBloc.userid,
        /*checkFileOnServerCallback: () {
          isLoading = false;
          setState(() {});

          //Snakbar().show_info_snakbar(context, "Download Started...");
        },*/
      );
      setState(() {
        table2.isdownloaded = isDownloaded;
        table2.isDownloading = false;
      });
    }
  }
  //endregion card functions

  @override
  void initState() {
    super.initState();
    contentId = widget.contentId;
   getComponentId();

    evntModuleBloc = EvntModuleBloc(
        eventModuleRepository: EventRepositoryBuilder.repository());

    print('appBloc.uiSettingModel.IsGlobasearch' +
        appBloc.uiSettingModel.isGlobalSearch);
    profileBloc =
        ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());

    catalogBloc =
        CatalogBloc(catalogRepository: CatalogRepositoryBuilder.repository());
    myLearningBloc.isFirstLoading = true;
    myLearningBloc.isArchiveFirstLoading = true;
    myLearningBloc.add(ResetFilterEvent());
    myLearningBloc.add(GetFilterMenus(
        listNativeModel: appBloc.listNativeModel,
        localStr: appBloc.localstr,
        moduleName: 'My Learning'));
    myLearningBloc.add(GetSortMenus('3'));
    tabList.add(Tab(
      text: appBloc.localstr.mylearningHeaderMylearningtitlelabel,
    ));
    tabList.add(Tab(
      text: appBloc.localstr.mylearningHeaderArchivetitlelabel,
    ));
    /*tabList.add(Tab(
      text: "My Downloads",
    ));*/
    _tabController = TabController(length: tabList.length, vsync: this);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        print('Last Postion');
        MyPrint.printOnConsole("isGetListEvent:$isGetListEvent");
        MyPrint.printOnConsole("myLearningBloc.listTotalCount:${myLearningBloc.listTotalCount}");
        MyPrint.printOnConsole("myLearningBloc.list.length:${myLearningBloc.list.length}");
        if (isGetListEvent && myLearningBloc.listTotalCount > myLearningBloc.list.length) {
          setState(() {
            isGetListEvent = false;
          });
          myLearningBloc.add(GetListEvent(pageNumber: pageNumber, pageSize: 10, searchText: ''));
        }
      }
    });

    _scArchive.addListener(() {
      if (_scArchive.position.pixels == _scArchive.position.maxScrollExtent) {
        if (isGetArchiveListEvent &&
            myLearningBloc.listArchiveTotalCount >
                myLearningBloc.listArchive.length) {
          setState(() {
            isGetArchiveListEvent = false;
          });
          myLearningBloc.add(GetArchiveListEvent(
              pageNumber: pageArchiveNumber,
              pageSize: 10,
              searchText: myLearningBloc.searchArchiveString));
        }
      }
    });

    //MyLearningController().tempGetMyLearningContentsInOffline();

    print("Getlist Called");
    refreshMyLearningContents();
    refreshMyLearningArchieveContents();

    detailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());

    generalRepository = GeneralRepositoryBuilder.repository();

    if (appBloc.uiSettingModel.isFromPush) {
      MyPrint.printOnConsole("Is From push");
      myLearningBloc.add(
        GetListEvent(
            pageNumber: pageNumber,
            pageSize: 100,
            searchText: myLearningBloc.searchMyCourseString,
            contentID: contentId),
      );
      /*  myLearningBloc.list.asMap().forEach((i, element) {
          if (element.contentid == contentId) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => ProviderModel(),
                  child: CommonDetailScreen(
                      screenType: ScreenType.MyLearning,
                      contentid: contentId,
                      objtypeId: element.objecttypeid,
                      detailsBloc: detailsBloc,
                      table2: element,
                      pos: i,
                      mylearninglist: myLearningBloc.list,
                      isFromReschedule: false),
                )));
          }
        });*/
    }

    MyLearningDownloadController().checkDownloadedContentSubscribed().then((value) {
      MyLearningController().getMyDownloads(withoutNotify: true);
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

//    streamController.stream.listen((data) async {
//      print('DataReceived: $data');
//
//      setState(() {
//        downloadedProgess = data;
//        isDownloading = true;
//        isDownloaded = false;
//      });
//    }, onDone: () {
//      print('Task Done');
//      setState(() {
//        isDownloaded = true;
//        isDownloading = false;
//      });
//    }, onError: (error) {
//      print('Some Error');
//      setState(() {
//        isDownloaded = false;
//        isDownloading = false;
//      });
//    });

 WidgetsBinding.instance.addObserver(this);
  }

getComponentId() async{
   componentId = await sharePrefGetString(sharedPref_ComponentID);
}

  @override
  void dispose() {
    _sc.dispose();
     WidgetsBinding.instance.removeObserver(this);
    _scArchive.dispose();
    streamController.close(); //Streams must be closed when not needed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    //print('My Learning Build');

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: Center(
        child: RoundedSquareProgressIndicator(),
      ),
      color: Colors.transparent,
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: Color(int.parse('0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}')),
          child: Stack(
            children: <Widget>[
              _homeBody(context, itemWidth, itemHeight),
            ],
          ),
        ),
      ),
    );
  }

  _navigateToGlobalSearchScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => GlobalSearchScreen(menuId: 4180)),
    );

    print(result);

    if (result != null) {
      myLearningBloc.isMyCourseSearch = true;
      myLearningBloc.searchMyCourseString = result.toString();

      setState(() {
        detailsBloc.myLearningDetailsModel.setisArchived(false);
      });
      refreshMyLearningContents();
      refreshMyLearningArchieveContents();
    }
  }

  void doSomething(int i, DummyMyCatelogResponseTable2 table2, int progress) {
    print('dosomethingofdata $progress');

    try {
      if (progress == -1) {
        setState(() {
          table2.isdownloaded = false;
          table2.isDownloading = false;
        });

        flutterToast.showToast(
          child: CommonToast(displaymsg: 'Error while downloading'),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 2),
        );
      }
      if (progress == 100) {
        setState(() {
          table2.isdownloaded = true;
          table2.isDownloading = false;
        });

        flutterToast.showToast(
          child: CommonToast(displaymsg: 'Downloaded Successfully'),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 2),
        );

        //sreekanth commented
        // if (appBloc.uiSettingModel.AutocompleteDocumentionDownload
        //         .toLowerCase() ==
        //     true) {
        //   evntModuleBloc.add(DownloadCompleteEvent(
        //       contentId: table2.contentid, ScoID: table2.scoid));
        // }
      } else {
        setState(() {
//        myLearningBloc.list[i].isdownloaded = true;
          //downloadedProgess = progress;
          table2.isDownloading = true;
        });
      }
    } catch (e) {
      setState(() {
        table2.isdownloaded = false;
        table2.isDownloading = false;
      });
    }
  }

  Widget _homeBody(BuildContext context, double itemWidth, double itemHeight) {
    return Container(
      margin: myLearningBloc.showArchieve == 'false'
          ? const EdgeInsets.symmetric(horizontal: 3.0)
          : const EdgeInsets.only(top: 0.0),
      child: myLearningBloc.showArchieve == 'false'
          ? _myCourceList()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 1),
                  decoration: BoxDecoration(
                    color: AppColors.getAppBGColor(),
                    //color: Colors.red,
                    boxShadow: [
                      BoxShadow(color: AppColors.getAppTextColor().withOpacity(0.2), offset: Offset(5, 5), spreadRadius: 2, blurRadius: 10),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.getAppTextColor(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: AppColors.getAppButtonBGColor(),
                    tabs: tabList,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color(int.parse(
                        '0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}')),
                    height: double.maxFinite,
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        _myCourceList(),
                        _archiveList(),
                        // getMyDownloadsListView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _archiveList() {
    MyPrint.printOnConsole("pageNumber:$pageNumber");
    MyPrint.printOnConsole("pageArchiveNumber:$pageArchiveNumber");

    var _controller;
    if (myLearningBloc.isArchiveSearch) {
      _controller =
          TextEditingController(text: myLearningBloc.searchArchiveString);
    } else {
      _controller = TextEditingController();
    }
    return BlocConsumer<MyLearningBloc, MyLearningState>(
      bloc: myLearningBloc,
      listener: (context, state) {
        if (state is GetArchiveListState) {
          if (state.status == Status.COMPLETED) {
//            print('List size ${state.list.length}');
            setState(() {
              isGetArchiveListEvent = true;
              pageArchiveNumber++;
            });
          } else if (state.status == Status.ERROR) {
//            print('listner Error ${state.message}');
            //if (state.data == '401') {
              AppDirectory.sessionTimeOut(context);
           // }
          }
        } else if (state is RemovetoArchiveCallState) {
          if (state.status == Status.COMPLETED) {
            flutterToast.showToast(
              child: CommonToast(
                  displaymsg: appBloc
                      .localstr.mylearningAlertsubtitleUnarchivedsuccesfully),
              gravity: ToastGravity.BOTTOM,
              toastDuration: Duration(seconds: 2),
            );

            setState(() {
              detailsBloc.myLearningDetailsModel.setisArchived(false);
            });
            refreshMyLearningContents();
            refreshMyLearningArchieveContents();
          } else if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            }
          }
        } else if (state is RemoveFromMyLearningState) {
          print('statestaus ${state.status}');
          if (state.status == Status.COMPLETED) {
            refreshMyLearningArchieveContents();
          } else if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            }
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && myLearningBloc.isArchiveFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70),
            ),
          );
        }
        else if (state.status == Status.ERROR) {
          return noDataFound(true);
        }
        else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InsSearchTextField(
                  onTapAction: () {
                    if (appBloc.uiSettingModel.isGlobalSearch == 'true') {
                      _navigateToGlobalSearchScreen(context);
                    }
                  },
                  controller: _controller,
                  appBloc: appBloc,
                  suffixIcon: myLearningBloc.isArchiveSearch
                      ? IconButton(
                    onPressed: () {
                      myLearningBloc.isArchiveSearch = false;
                      myLearningBloc.searchArchiveString = '';
                      refreshMyLearningArchieveContents();
                    },
                    icon: Icon(
                      Icons.close,
                      // color: Color(0xffB5BBC6)
                      color:
                      Color(int.parse(
                          '0xFF${appBloc.uiSettingModel.expiredBGColor.substring(1, 7).toUpperCase()}')),
                    ),
                  )
                      : (myLearningBloc.isFilterMenu)
                      ? IconButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                MyLearningFilter(componentId: componentId,))),
                    icon: Icon(
                      Icons.tune,
                      color: Color(int.parse('0xFF${appBloc.uiSettingModel.expiredBGColor.substring(1, 7).toUpperCase()}')),
                    ),
                  )
                      : null,
                  onSubmitAction: (value) {
                    if (value.toString().length > 0) {
                      myLearningBloc.isArchiveSearch = true;
                      myLearningBloc.searchArchiveString = value.toString();
                      refreshMyLearningArchieveContents();
                    }
                  },
                ),
              ),
              Expanded(
                child: ResponsiveWidget(
                  mobile: RefreshIndicator(
                    onRefresh: () async {
                      refreshMyLearningArchieveContents();
                      MyLearningDownloadController().checkDownloadedContentSubscribed();
                    },
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    child: myLearningBloc.listArchive.length == 0
                        ? ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
                        Container(
                          child: Center(
                            child: Text(
                                appBloc.localstr.commoncomponentLabelNodatalabel,
                                style: TextStyle(
                                    color: Color(int.parse(
                                        '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                                    fontSize: 24)),
                          ),
                        ),
                      ],
                    )
                        : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: myLearningBloc.listArchive.length + 1,
                      itemBuilder: (context, i) {
                        if ((myLearningBloc.listArchive.isEmpty &&
                            i == 0) ||
                            i == myLearningBloc.listArchive.length) {
                          if (myLearningBloc.isLoadingArchievedCources) {
                            return Center(
                              child: AbsorbPointer(
                                child: AppConstants().getLoaderWidget(iconSize: 70),
                              ),
                            );
                          } else
                            return SizedBox();
                        }

                        return Container(
                          child: _widgetMyCourseListItems(
                              myLearningBloc.listArchive[i],
                              true,
                              context,
                              i),
                        );
                      },
                      controller: _scArchive,
                    ),
                  ),
                  tab: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width / 900,
                    ),
                    shrinkWrap: true,
                    itemCount: myLearningBloc.listArchive.length,
                    itemBuilder: (context, i) {
                      if (myLearningBloc.listArchive.length == 0) {
                        if (state.status == Status.LOADING) {
//                        print('gone in _buildProgressIndicator');
                          return _buildProgressIndicator();
                        } else {
                          return Container();
                        }
                      } else {
                        return Container(
                          child: _widgetMyCourseListItems(
                              myLearningBloc.listArchive[i],
                              true,
                              context,
                              i),
                        );
                      }
                    },
                    controller: _scArchive,
                  ),
                  web: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 0.65,
                    ),
                    shrinkWrap: true,
                    itemCount: myLearningBloc.listArchive.length,
                    itemBuilder: (context, i) {
                      if (myLearningBloc.listArchive.length == 0) {
                        if (state.status == Status.LOADING) {
//                        print('gone in _buildProgressIndicator');
                          return _buildProgressIndicator();
                        } else {
                          return Container();
                        }
                      } else {
                        return Container(
                          child: _widgetMyCourseListItems(
                              myLearningBloc.listArchive[i],
                              true,
                              context,
                              i),
                        );
                      }
                    },
                    controller: _scArchive,
                  ),
                ),
              ),
            ],
          );

          /*return myLearningBloc.listArchive.length == 0
              ? Column(
                  children: <Widget>[

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                                      refreshMyLearningArchieveContents();
                        },
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                        child: Container(
                          child: ListView(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
                              Container(
                                child: Center(
                                  child: Text(
                                      appBloc.localstr.commoncomponentLabelNodatalabel,
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                                          fontSize: 24)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InsSearchTextField(
                          onTapAction: () {
                            if (appBloc.uiSettingModel.IsGlobasearch ==
                                'true') {
                              _navigateToGlobalSearchScreen(context);
                            }
                          },
                          controller: _controller,
                          appBloc: appBloc,
                          suffixIcon: myLearningBloc.isArchiveSearch
                              ? IconButton(
                                  onPressed: () {
                                    myLearningBloc.isArchiveSearch = false;
                                    myLearningBloc.SearchArchiveString = '';
                                    refreshMyLearningArchieveContents();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                  ),
                                )
                              : (myLearningBloc.isFilterMenu)
                                  ? IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  MyLearningFilter(componentId: componentId,))),
                                      icon: Icon(Icons.tune,
                                          color: Color(
                                            int.parse(
                                                '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                          )),
                                    )
                                  : null,
                          onSubmitAction: (value) {
                            if (value.toString().length > 0) {
                              myLearningBloc.isArchiveSearch = true;
                              myLearningBloc.SearchArchiveString = value.toString();
                              refreshMyLearningArchieveContents();
                            }
                          },
                        )),
                    Expanded(
                      flex: 9,
                      child: ResponsiveWidget(
                        mobile: RefreshIndicator(
                          onRefresh: () async {
                            refreshMyLearningArchieveContents();
                          },
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: myLearningBloc.listArchive.length + 1,
                            itemBuilder: (context, i) {
                              if ((myLearningBloc.listArchive.isEmpty &&
                                      i == 0) ||
                                  i == myLearningBloc.listArchive.length) {
                                if (myLearningBloc.isLoadingArchievedCources) {
                                  return Center(
                                    child: AbsorbPointer(
                                      child: AppConstants().getLoaderWidget(iconSize: 70)
                                    ),
                                  );
                                } else
                                  return SizedBox();
                              }

                              return Container(
                                child: _widgetMyCourseListItems(
                                    myLearningBloc.listArchive[i],
                                    true,
                                    context,
                                    i),
                              );
                            },
                            controller: _scArchive,
                          ),
                        ),
                        tab: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width / 900,
                          ),
                          shrinkWrap: true,
                          itemCount: myLearningBloc.listArchive.length,
                          itemBuilder: (context, i) {
                            if (myLearningBloc.listArchive.length == 0) {
                              if (state.status == Status.LOADING) {
//                        print('gone in _buildProgressIndicator');
                                return _buildProgressIndicator();
                              } else {
                                return Container();
                              }
                            } else {
                              return Container(
                                child: _widgetMyCourseListItems(
                                    myLearningBloc.listArchive[i],
                                    true,
                                    context,
                                    i),
                              );
                            }
                          },
                          controller: _scArchive,
                        ),
                      ),
                    ),
                  ],
                );*/
        }
      },
    );
  }

  Widget _myCourceList() {
    //print('_myCourceList Build called');

    TextEditingController _controller = TextEditingController();
    if (myLearningBloc.isMyCourseSearch) {
      _controller.text = myLearningBloc.searchMyCourseString;
    }

    return BlocConsumer<EvntModuleBloc, EvntModuleState>(
      bloc: evntModuleBloc,
      listener: (context, state) {
        if (state is CancelEnrollmentState) {
          if (state.status == Status.COMPLETED) {
            if (state.isSucces == '"true"') {
              Future.delayed(Duration(seconds: 1), () {
                // 5s over, navigate to a page
                flutterToast.showToast(
                  child: CommonToast(
                      displaymsg:
                          'Your enrollment for the course has been successfully canceled'),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: Duration(seconds: 1),
                );
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
                toastDuration: Duration(seconds: 2),
              );
            }
          } else if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            }
          }
        }
        else if (state is BadCancelEnrollmentState) {
          if (state.status == Status.COMPLETED) {
            showCancelEnrollDialog(state.table2, state.isSucces);
          } else if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            }
          }
        }
      },
      builder: (context, state) => Stack(
        children: <Widget>[
          BlocConsumer<MyLearningBloc, MyLearningState>(
            bloc: myLearningBloc,
            listener: (context, state) async {
              if (state is GetListState) {
                if (state.status == Status.COMPLETED) {
//            print('List size ${state.list.length}');
                  if (appBloc.uiSettingModel.isFromPush) {
                    print(
                        'Data data : ' + myLearningBloc.list.length.toString());
                    myLearningBloc.list.asMap().forEach((i, element) {
                      if (element.contentid == contentId) {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider(
                                  create: (context) => ProviderModel(),
                                  child: CommonDetailScreen(
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
                          ),
                        )
                            .then((value) =>
                        {
                          if (value ?? true)
                            {
                              appBloc.uiSettingModel.setIsFromPush(false),
                              contentId = '',
                              refreshMyLearningContents(),
                            }
                        });
                      }
                    });
                  }
                  setState(() {
                    isGetListEvent = true;
                    pageNumber++;
                  });
                }
                else if (state.status == Status.ERROR) {
                  if (state.message == '401') {
                    AppDirectory.sessionTimeOut(context);
                    // }
                  }
                }
              }
              else if (state is AddtoArchiveCallState) {
                  flutterToast.showToast(
                    child: CommonToast(
                        displaymsg: appBloc
                            .localstr
                            .mylearningAlertsubtitleArchivedsuccesfully),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );

                  setState(() {
                    detailsBloc.myLearningDetailsModel.setisArchived(false);
                  });
                  refreshMyLearningContents();
                  refreshMyLearningArchieveContents();
                }
                else if (state is RemovetoArchiveCallState) {
                  flutterToast.showToast(
                    child: CommonToast(
                        displaymsg: appBloc.localstr
                            .mylearningAlertsubtitleUnarchivedsuccesfully),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );

                  setState(() {
                    detailsBloc.myLearningDetailsModel.setisArchived(false);
                  });
                  refreshMyLearningContents();
                  refreshMyLearningArchieveContents();
                }
                else if (state is RemoveFromMyLearningState) {
                  print('statestaus ${state.status}');
                  if (state.status == Status.COMPLETED) {
                    setState(() {
                      detailsBloc.myLearningDetailsModel.setisArchived(false);
                      refreshMyLearningContents();
                    });
                  } else if (state.status == Status.ERROR) {
                    if (state.message == '401') {
                      AppDirectory.sessionTimeOut(context);
                    }
                  }
                }
                else if (state is CourseTrackingState) {
                  if (state.status == Status.COMPLETED) {
                    print(state.response);
                    if (isValidString(state.response)) {
                      myLearningBloc.add(TokenFromSessionIdEvent(
                          table2: state.table2,
                          contentID: state.table2.contentid,
                          objecttypeId: '${state.table2.objecttypeid}',
                          userID: '${state.table2.objecttypeid}',
                          courseName: '${state.table2.name}',
                          courseURL: state.courseUrl,
                          learnerSCOID: '${state.table2.scoid}',
                          learnerSessionID: state.response.toString()));
                    }
                  } else if (state.status == Status.ERROR) {
                    if (state.message == '401') {
                      AppDirectory.sessionTimeOut(context);
                    }
                  }
                }
                else if (state is TokenFromSessionIdState) {
                  if (state.status == Status.COMPLETED) {
                    if (isValidString(state.response) &&
                        state.response.contains('failed')) {
                      bool result = await MyLearningController().decideCourseLaunchMethod(
                        context: context,
                        table2: state.table2,
                        isContentisolation: true,
                      );
                      if (!result) {
                        state.table2.isdownloaded = false;
                        setState(() {});
                      }

                      // bool networkAvailable = await AppDirectory
                      //     .checkInternetConnectivity();
                      // if (networkAvailable) {
                      //   await MyLearningController().launchCourse(
                      //       table2: state.table2,
                      //       context: context,
                      //       isContentisolation: true);
                      // }
                      // else {
                      //   await MyLearningController().launchCourseOffline(
                      //       context: context, table2: state.table2);
                      // }
                      refreshContent(state.table2);
                    }
                    else {
                      launchCourseContentisolation(
                          state.table2, context, state.response.toString());
                    }
                  }
                  else if (state.status == Status.ERROR) {
                    if (state.message == '401') {
                      AppDirectory.sessionTimeOut(context);
                    }
                  }
                }
            },
            builder: (context, state) {
              print('MyLearningBloc Builder in MyLearningHome called for state:${state.runtimeType}, Status:${state.status}');

              if (myLearningBloc.isFirstLoading == true) {
                return Center(
                  child: AbsorbPointer(
                    child: AppConstants().getLoaderWidget(iconSize: 70)
                  ),
                );
              }
              else if (state.status == Status.ERROR) {
                return noDataFound(true);
              }
              else {
                print("My Learning Contents Length:${myLearningBloc.list.length}");
                if (myLearningBloc.list.length == 0) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InsSearchTextField(
                          onTapAction: () {
                            if (appBloc.uiSettingModel.isGlobalSearch ==
                                'true') {
                              _navigateToGlobalSearchScreen(context);
                            }
                          },
                          controller: _controller,
                          appBloc: appBloc,
                          suffixIcon: myLearningBloc.isMyCourseSearch
                              ? IconButton(
                                  onPressed: () {
                                    myLearningBloc.isMyCourseSearch = false;
                                    myLearningBloc.searchMyCourseString = '';
                                    refreshMyLearningContents();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Color(int.parse(
                                        '0xFF${appBloc.uiSettingModel.expiredBGColor.substring(1, 7).toUpperCase()}')),
                                  ),
                                )
                              : (myLearningBloc.isFilterMenu)
                                  ? IconButton(
                                      onPressed: () async {
                                        await Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) =>
                                                    MyLearningFilter(componentId: componentId,)));

                                        myLearningBloc.isMyCourseSearch = false;
                                        myLearningBloc.searchMyCourseString = '';
                                        refreshMyLearningContents();
                                      },
                                      icon: Icon(
                                        Icons.tune,
                                        color: Color(int.parse(
                                            '0xFF${appBloc.uiSettingModel.expiredBGColor.substring(1, 7).toUpperCase()}')),
                                      ),
                                    )
                                  : null,
                          onSubmitAction: (value) {
                            if (value.toString().length > 0) {
                              myLearningBloc.isMyCourseSearch = true;
                              myLearningBloc.searchMyCourseString = value.toString();
                              refreshMyLearningContents();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            refreshMyLearningContents();
                            MyLearningDownloadController().checkDownloadedContentSubscribed();
                          },
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          child: ListView(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
                              Container(
                                child: Center(
                                  child: Text(
                                      appBloc.localstr.commoncomponentLabelNodatalabel,
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                                          fontSize: 24)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return BlocConsumer<MyLearningDetailsBloc, MyLearningDetailsState>(
                  bloc: detailsBloc,
                  listener: (context, state) {
                    if (state is SetCompleteState) {
                      if (state.status == Status.LOADING) {
                        flutterToast.showToast(
                          child: CommonToast(displaymsg: 'Please wait'),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: Duration(seconds: 2),
                        );
                      } else if (state.status == Status.COMPLETED) {
                        flutterToast.showToast(
                          child: CommonToast(
                              displaymsg: 'Course completed successfully'),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: Duration(seconds: 2),
                        );
                        refreshMyLearningContents();
                      } else if (state.status == Status.ERROR) {
                        flutterToast.showToast(
                          child: CommonToast(
                              displaymsg: 'Filed to update course status'),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: Duration(seconds: 2),
                        );
                      }
                    } else if (state is GetContentStatusState) {
                      if (state.status == Status.COMPLETED) {
                        print(
                            'getcontentstatusvl ${state.contentstatus.name} ${state.contentstatus.progress} ${state.contentstatus.contentStatus}');
                        setState(() {
                          state.table2.actualstatus = state.contentstatus.name;
                          state.table2.progress = state.contentstatus.progress;
                          if (state.contentstatus.progress != '0') {
                            state.table2.percentcompleted =
                                state.contentstatus.progress;
                          }
                          state.table2.corelessonstatus =
                              state.contentstatus.contentStatus;
                        });
                      }
                    } else if (state.status == Status.ERROR) {
                      flutterToast.showToast(
                        child: CommonToast(
                            displaymsg: 'Filed to update course status'),
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: Duration(seconds: 2),
                      );
                    }

//                    print('detailstate $state');
                  },
                  builder: (_, s) {
                    //print('MyLearningDetailsBloc Builder called, length:${myLearningBloc.list.length}');

                    return Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InsSearchTextField(
                              onTapAction: () {
                                if (appBloc.uiSettingModel.isGlobalSearch ==
                                    'true') {
                                  _navigateToGlobalSearchScreen(context);
                                }
                              },
                              controller: _controller,
                              appBloc: appBloc,
                              suffixIcon: myLearningBloc.isMyCourseSearch
                                  ? IconButton(
                                      onPressed: () {
                                        myLearningBloc.isMyCourseSearch = false;
                                        myLearningBloc.searchMyCourseString =
                                            '';
                                        refreshMyLearningContents();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Color(int.parse(
                                            '0xFF${appBloc.uiSettingModel.expiredBGColor.substring(1, 7).toUpperCase()}')),
                                      ),
                                    )
                                  : (myLearningBloc.isFilterMenu)
                                      ? IconButton(
                                          onPressed: () async {
                                            await Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyLearningFilter(componentId: componentId,)));

                                            myLearningBloc.isMyCourseSearch =
                                            false;
                                            myLearningBloc.searchMyCourseString = '';
                                            refreshMyLearningContents();
                                          },
                                          icon: Icon(Icons.tune,
                                              color: Color(
                                                int.parse(
                                                    '0xFF${appBloc.uiSettingModel.expiredBGColor.substring(1, 7).toUpperCase()}'),
                                              )),
                                        )
                                      : null,
                              onSubmitAction: (value) {
                                if (value.toString().length > 0) {
                                  myLearningBloc.isMyCourseSearch = true;
                                  myLearningBloc.searchMyCourseString = value.toString();
                                  refreshMyLearningContents();
                                }
                              },
                            )),
                        Expanded(
                          flex: 9,
                          child: ResponsiveWidget(
                            mobile: RefreshIndicator(
                              onRefresh: () async {
                                refreshMyLearningContents();
                                MyLearningDownloadController().checkDownloadedContentSubscribed();
                              },
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: myLearningBloc.list.length + 1,
                                itemBuilder: (context, i) {
                                  //print('In ListView Builder');
                                  if ((myLearningBloc.list.isEmpty && i == 0) ||
                                      i == myLearningBloc.list.length) {
                                    if (myLearningBloc.isLoadingMyCources) {
                                      return Center(
                                        child: AbsorbPointer(
                                          child: AppConstants().getLoaderWidget(iconSize: 70)
                                        ),
                                      );
                                    } else
                                      return SizedBox();
                                  }

                                  if (myLearningBloc.list.length == 0) {
                                    return _buildProgressIndicator();
                                  }
                                  return _widgetMyCourseListItems(
                                    myLearningBloc.list[i],
                                    false,
                                    context,
                                    i,
                                  );
                                },
                                controller: _sc,
                              ),
                            ),
                            tab: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    MediaQuery.of(context).size.width / 900,
                              ),
                              shrinkWrap: true,
                              itemCount: myLearningBloc.list.length,
                              itemBuilder: (context, i) {
                                print('In GridView Builder');

                                if (myLearningBloc.list.length == 0) {
                                  return _buildProgressIndicator();
                                }
                                return _widgetMyCourseListItems(
                                  myLearningBloc.list[i],
                                  false,
                                  context,
                                  i,
                                );
                              },
                              controller: _sc,
                            ),
                            web: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 0.65,
                              ),
                              shrinkWrap: true,
                              itemCount: myLearningBloc.list.length,
                              itemBuilder: (context, i) {
                                print('In GridView Builder');

                                if (myLearningBloc.list.length == 0) {
                                  return _buildProgressIndicator();
                                }
                                return _widgetMyCourseListItems(
                                  myLearningBloc.list[i],
                                  false,
                                  context,
                                  i,
                                );
                              },
                              controller: _sc,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          (state.status == Status.LOADING)
              ? Center(
                  child: AbsorbPointer(
                    child: AppConstants().getLoaderWidget(iconSize: 70)
                  ),
                )
              : SizedBox(
                  width: 1,
                )
        ],
      ),
    );
  }

  Widget getMyDownloadsListView() {
    return Consumer<MyLearningDownloadProvider>(
      builder: (BuildContext context, MyLearningDownloadProvider myLearningDownloadProvider, Widget? child) {
        //List<MyLearningDownloadModel> list = myLearningDownloadProvider.downloads.where((element) => element.isTrackContent == false).toList();
        List<MyLearningDownloadModel> list = myLearningDownloadProvider.downloads;

        if(myLearningDownloadProvider.isLoadingMyDownloads) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Color(
                  int.parse('0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                ),
                size: 70.h,
              ),
            ),
          );
        }
        else if (list.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await MyLearningDownloadController().checkDownloadedContentSubscribed();
              MyLearningController().getMyDownloads();
            },
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Downloads",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        color: Color(int.parse(
                            '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        else {
          //MyPrint.printOnConsole("MyDownloads Length:${myLearningDownloadProvider.downloads.length}");

          return ResponsiveWidget(
            mobile: RefreshIndicator(
              onRefresh: () async {
                await MyLearningDownloadController().checkDownloadedContentSubscribed();
                MyLearningController().getMyDownloads();
              },
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
              child: Container(
                height: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: list.length + 1,
                  itemBuilder: (context, i) {
                    if ((list.isEmpty && i == 0) || i == list.length) {
                      if (myLearningBloc.isLoadingArchievedCources) {
                        return Center(
                          child: AbsorbPointer(
                            child: AppConstants().getLoaderWidget(iconSize: 70),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }

                    MyLearningDownloadModel myLearningDownloadModel = list[i];

                    //MyPrint.printOnConsole("Content Id:${myLearningDownloadModel.table2.contentid}, Name:${myLearningDownloadModel.table2.name}");

                    return Container(
                      child: _widgetMyCourseListItems(
                        myLearningDownloadModel.table2,
                        false,
                        context,
                        0,
                        isFromMyDownloads: true,
                        downloadModel: myLearningDownloadModel,
                      ),
                    );
                  },
                ),
              ),
            ),
            tab: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width / 900,
              ),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                MyLearningDownloadModel myLearningDownloadModel = list[i];

                return Container(
                  child: _widgetMyCourseListItems(
                    myLearningDownloadModel.table2,
                    false,
                    context,
                    i,
                    isFromMyDownloads: true,
                    downloadModel: myLearningDownloadModel,
                  ),
                );
              },
            ),
            web: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 0.65,
              ),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                MyLearningDownloadModel myLearningDownloadModel = list[i];

                return Container(
                  child: _widgetMyCourseListItems(
                    myLearningDownloadModel.table2,
                    false,
                    context,
                    i,
                    isFromMyDownloads: true,
                    downloadModel: myLearningDownloadModel,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: 1.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  noInternetFound(val) {
    return val
        ? Container(
            child: Center(
              child: Text(
                'No Internet',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          )
        : Container();
  }

  Widget noDataFound(val) {
    return val
        ? Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InsSearchTextField(
                    onTapAction: () {
                      if (appBloc.uiSettingModel.isGlobalSearch == 'true') {
                        _navigateToGlobalSearchScreen(context);
                      }
                    },
                    appBloc: appBloc,
                    suffixIcon: (myLearningBloc.isFilterMenu)
                        ? IconButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => MyLearningFilter(componentId: componentId,))),
                            icon: Icon(
                              Icons.tune,
                              color: Color(int.parse(
                                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                            ),
                          )
                        : null,
                    onSubmitAction: (value) {
                      if (value.toString().length > 0) {
                        refreshMyLearningContents();
                      }
                    },
                  )
                  // TextField(
                  //   onTap: () {
                  //     if (appBloc.uiSettingModel.IsGlobasearch == 'true') {
                  //       _navigateToGlobalSearchScreen(context);
                  //       // Navigator.of(context)
                  //       //     .push(MaterialPageRoute(
                  //       //         builder: (context) =>
                  //       //             GlobalSearchScreen(menuId: 4180)))
                  //       //     .then((value) => () {
                  //       //           if (value != null) {}
                  //       //           print(value);
                  //       //         });
                  //     }
                  //   },
                  //   cursorColor: Color(int.parse(
                  //       '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')),
                  //   style: TextStyle(
                  //       fontSize: ScreenUtil().setSp(14), color: Colors.black),
                  //   decoration: InputDecoration(
                  //     focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.grey)),
                  //     enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.grey)),
                  //     hintText: 'Search ...',
                  //     suffixIcon: (myLearningBloc.isFilterMenu)
                  //         ? IconButton(
                  //             onPressed: () => Navigator.of(context).push(
                  //                 MaterialPageRoute(
                  //                     builder: (context) => MyLearningFilter())),
                  //             icon: Icon(
                  //               Icons.tune,
                  //             ),
                  //           )
                  //         : null,
                  //   ),
                  //   onSubmitted: (value) {
//                      refreshMyLearningContents();
                  //   },
                  // ),
                  ),
              Container(
                child: Center(
                  child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                      style: TextStyle(
                          color: Color(int.parse(
                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                          fontSize: 24)),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _widgetMyCourseListItems(DummyMyCatelogResponseTable2 table2, bool isArchive, BuildContext context, int i,
      {bool isFromMyDownloads = false, MyLearningDownloadModel? downloadModel}) {
    return Consumer<MyLearningDownloadProvider>(
      builder: (BuildContext context, MyLearningDownloadProvider myLearningDownloadProvider, Widget? child) {
        if(downloadModel == null) {
          MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
          List<MyLearningDownloadModel> downloads = myLearningDownloadProvider.downloads.where((element) => element.table2.contentid == table2.contentid).toList();
          //MyPrint.printOnConsole("Downloads Length:${downloads.length}");
          if(downloads.isNotEmpty) {
            downloadModel = downloads.first;
          }
        }

        return MyLearningComponentCard(
          table2: table2,
          trackModel: downloadModel?.trackModel,
          trackContentId: downloadModel?.trackContentId ?? "",
          trackContentName: downloadModel?.trackContentName ?? "",
          isArchive: isArchive,
          isTrackContent: isFromMyDownloads ? (downloadModel?.isTrackContent ?? false) : false,
          isDownloadCard: isFromMyDownloads,
          onMoreTap: () => _onMoreTap(table2, i, isFromMyDownloads, downloadModel: downloadModel),
          onArchievedTap: () => _onArchivedTap(table2),
          onReviewTap: () => _onReviewTap(table2),
          onViewTap: () => _onViewTap(table2, isArchieved: isArchive),
          onDownloadPaused: () {
            onDownloadPaused(downloadModel);
          },
          onDownloading: () {
            onDownloading(downloadModel);
          },
          onDownloaded: () async {
            MyPrint.printOnConsole("onDownloaded called");
          },
          onNotDownloaded: () => _onDownloadTap(table2),
        );
      },
    );

    //print("Name:${table2.name}, ObjectTypeId:${table2.objecttypeid}, Description:${table2.description}");

    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    /*String imgUrl =
        'https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg';

    detailsBloc.myLearningDetailsModel.setisArchived(table2.isarchived);

    int objecttypeId = table2.objecttypeid;
    String actualstatus = table2.actualstatus;

    bool isratingbarVissble = false;
    bool isReviewVissble = false;

    double ratingRequired = 0;
    Color statuscolor = Color(0xff5750da);

    if (table2.corelessonstatus.toString().contains('Completed')) {
      statuscolor = Color(0xff4ad963);
    } else if (table2.corelessonstatus.toString() == 'Not Started') {
      statuscolor = Color(0xfffe2c53);
    } else if (table2.corelessonstatus.toString() == 'In Progress') {
      statuscolor = Color(0xffff9503);
    }

    try {
      ratingRequired = double.parse(
          appBloc.uiSettingModel.MinimimRatingRequiredToShowRating);
    } catch (e) {
      ratingRequired = 0;
    }

    if (table2.totalratings >=
            int.parse(
                appBloc.uiSettingModel.NumberOfRatingsRequiredToShowRating) &&
        table2.ratingid >= ratingRequired) {
      isReviewVissble = false;
      isratingbarVissble = true;
    }

    if (objecttypeId != 70 && actualstatus.toLowerCase().contains('completed') || actualstatus == 'passed' || actualstatus == 'failed') {
      isratingbarVissble = true;
      isReviewVissble = true;
    }
    else if (actualstatus.toLowerCase().contains('completed') && objecttypeId == 70) {
      isratingbarVissble = false;
      isReviewVissble = false;
    }
    else if (actualstatus == 'attended' && objecttypeId == 70) {
      isratingbarVissble = false;
      isReviewVissble = true;
    }

    bool isExpired = false;
    if (table2.expirydate != null) {
      DateTime tempDate = DateFormat('yyyy-MM-ddThh:mm:ss').parse(table2.expirydate);
      String dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempDate);

      //var isExpire = tempDate.isAfter(DateTime.now());
      isExpired = tempDate.isBefore(DateTime.now());
      print(dateStr);
      print(DateTime.now());
      print(isExpired);
      if (isExpired) {
        statuscolor = Color(0xfffe2c53);
      }
      //print(isExpire);
    }

    String contentIconPath = table2.iconpath;

    if (isValidString(appBloc.uiSettingModel.AzureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? table2.iconpath
          : appBloc.uiSettingModel.AzureRootPath + table2.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    } else {
      contentIconPath = table2.siteurl + contentIconPath;
    }

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: Card(
        color: InsColor(appBloc).appBGColor,
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isArchive || (table2.headerlocationname == '')
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        table2.headerlocationname,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.black),
                      ),
                    ),
                  ),
            Stack(
              children: <Widget>[
                InkWell(
                  onTap: isExpired
                      ? null
                      : () async {
                          print(
                              'ontitemtapp ${table2.objecttypeid} ${table2.relatedconentcount}');
                          if (isValidString(
                              table2.viewprerequisitecontentstatus ?? '')) {
//                        print('ifdataaaaa');
                            String alertMessage = appBloc
                                .localstr.prerequistesalerttitle6Alerttitle6;
                            alertMessage = alertMessage +
                                '  \"' +
                                appBloc
                                    .localstr.prerequisLabelContenttypelabel +
                                '\" ' +
                                appBloc.localstr
                                    .prerequistesalerttitle5Alerttitle7;

                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                        appBloc.localstr
                                            .detailsAlerttitleStringalert,
                                        style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                            ),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        alertMessage,
                                        style: TextStyle(
                                            color: Color(
                                          int.parse(
                                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                        )),
                                      ),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(appBloc.localstr
                                              .eventsAlertbuttonOkbutton),
                                          style: textButtonStyle,
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ));
                          } else {
                            if (table2.objecttypeid == 70) {
                              if (table2.relatedconentcount != 0) {
                                checkRelatedContent(table2);
                              }
                            } else {
                              // covered
                              bool networkAvailable = await AppDirectory
                                  .checkInternetConnectivity();
                              if (networkAvailable) {
                                launchCourse(table2, context, false);
                              } else {
                                launchCourseOffline(table2);
                              }
                            }
                          }
                        },
                  child: Container(
                    height: ScreenUtil().setHeight(kCellThumbHeight),
                    child: CachedNetworkImage(
                      imageUrl: table2.thumbnailimagepath.startsWith('http')
                          ? table2.thumbnailimagepath
                          : table2.siteurl + table2.thumbnailimagepath,
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

                    */ /*child: Image.network(
                      'https://qa.instancy.com'+table2.thumbnailimagepath,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),*/ /*

                    */ /*decoration:  BoxDecoration(

                        image:  DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.darken),
                          image: AssetImage(
                            'https://qa.instancy.com'+table2.thumbnailimagepath,
                          ),
                        )
                    ),*/ /*
                  ),
                ),
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: kShowContentTypeIcon,
                        child: Container(
                            padding: EdgeInsets.all(2.0),
                            color: Colors.white,
                            child: CachedNetworkImage(
                              height: 30,
                              imageUrl: contentIconPath,
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: statuscolor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(5),
                          bottom: ScreenUtil().setWidth(5),
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(10)),
                      child: Text(
                        isExpired
                            ? 'Expired'
                            : table2.corelessonstatus.toString(),
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(10),
                            color: Colors.white),
                      ),
                    )),
              ],
            ),
            LinearProgressIndicator(
              value: isValidString(table2.progress)
                  ? double.parse(table2.progress) / 100
                  : 0.0,
              valueColor: AlwaysStoppedAnimation<Color>(statuscolor),
              backgroundColor: Colors.grey,
            ),
            Container(
              color: isExpired
                  ? Color(int.parse('0xFF${appBloc.uiSettingModel.expiredBGColor.substring(1, 7).toUpperCase()}')).withOpacity(0.8)
                  : Color(int.parse('0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}')),
              padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              table2.description,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  color: Color(int.parse(
                                      '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'))),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: isExpired
                                  ? null
                                  : () async {
                                      if (isValidString(table2
                                              .viewprerequisitecontentstatus ??
                                          '')) {
//                                    print('ifdataaaaa');
                                        String alertMessage = appBloc.localstr
                                            .prerequistesalerttitle6Alerttitle6;
                                        alertMessage = alertMessage +
                                            '  \"' +
                                            appBloc.localstr
                                                .prerequisLabelContenttypelabel +
                                            '\" ' +
                                            appBloc.localstr
                                                .prerequistesalerttitle5Alerttitle7;

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text(
                                                    appBloc.localstr
                                                        .detailsAlerttitleStringalert,
                                                    style: TextStyle(
                                                        color: Color(
                                                          int.parse(
                                                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  content: Text(
                                                    alertMessage,
                                                    style: TextStyle(
                                                        color: Color(
                                                      int.parse(
                                                          '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                                    )),
                                                  ),
                                                  backgroundColor:
                                                      InsColor(appBloc)
                                                          .appBGColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(appBloc
                                                          .localstr
                                                          .eventsAlertbuttonOkbutton),
                                                      style: textButtonStyle,
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ));
                                      } else {
                                        // covered
                                        bool networkAvailable =
                                            await AppDirectory
                                                .checkInternetConnectivity();
                                        if (networkAvailable) {
                                          launchCourse(table2, context, false);
                                        } else {
                                          launchCourseOffline(table2);
                                        }
                                      }
                                    },
                              child: Text(
                                table2.name,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: Color(int.parse(
                                        '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isArchive
                          ? GestureDetector(
                              onTap: isExpired
                                  ? null
                                  : () {
                                      myLearningBloc.add(RemovetoArchiveCall(
                                          isArchive: false,
                                          strContentID: table2.contentid));
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
                                      _settingMyCourceBottomSheet(
                                          context, table2, i);
                                    },
                              child: isExpired
                                  ? Container()
                                  : Icon(
                                      Icons.more_vert,
                                      color: InsColor(appBloc).appIconColor,
                                    ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
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
                        table2.objecttypeid == 70
                            ? table2.presenter
                            : table2.authordisplayname,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: Color(int.parse(
                                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'))
                                .withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(3),
                  ),
                  Row(
                    children: <Widget>[
                      isratingbarVissble
                          ? SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) {},
                              starCount: 5,
                              rating: table2.ratingid,
                              size: ScreenUtil().setHeight(20),
                              // filledIconData: Icons.blur_off,
                              // halfFilledIconData: Icons.blur_on,
                              color: Colors.orange,
                              borderColor: Colors.orange,
                              spacing: 0.0)
                          : Container(),
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
                                                        table2.contentid,
                                                        false,
                                                        detailsBloc)))
                                            .then((value) => {
                                                  if (value == true)
                                                    {
                                                      refreshMyLearningContents()
                                                    }
                                                });
                                      },
                                child: Text(
                                  appBloc.localstr.mylearningButtonReviewbutton,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(12),
                                      color: Color(int.parse(
                                          '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}'))),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(2),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1.0, bottom: 1.0, left: 1.0, right: 1.0),
                    child: Text(
                      table2.sitename,
                      style: TextStyle(
                        color: Color(0xff34aadc),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(2),
                  ),
                  Text(
                    table2.shortdescription,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        color: Color(int.parse(
                                '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'))
                            .withOpacity(0.5)),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  isExpired
                      ? Container()
                      : Row(
                          children: <Widget>[
                            // commented till offline integration done
                            //displayDownloadTile(table2, i),
                            displayDownloadTile2(table2),
                            SizedBox(
                              width: 10.w,
                            ),
                            displayViewTile(table2),
                            SizedBox(
                              width: 10.w,
                            ),
                            displayPlayTile(table2)
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );*/
  }

  /*
  _settingMyEventBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}'),
            ),
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Add to calender'),
                    onTap: () => {}),
                ListTile(
                  leading: Icon(Icons.video_library),
                  title: Text('Related Content'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(Icons.play_arrow),
                  title: Text('View Recording'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(Icons.archive),
                  title: Text('Archive'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Cancel Enrollment'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }
  */

  //region My Learning Bottomsheet Options
  Widget displayPlay(DummyMyCatelogResponseTable2 table2) {
    if ([11, 14, 20, 21, 28, 36, 52].contains(table2.objecttypeid)) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return BottomsheetOptionTile(
            text: (appBloc.localstr.mylearningActionsheetPlayoption != null) ? appBloc.localstr.mylearningActionsheetPlayoption : '',
            iconData:  IconDataSolid(int.parse('0xf144')),

            onTap: () async {
              Navigator.of(context).pop();

              if (isValidString(table2.viewprerequisitecontentstatus ?? '')) {
//                print('ifdataaaaa');
                String alertMessage =
                    appBloc.localstr.prerequistesalerttitle6Alerttitle6;
                alertMessage = alertMessage +
                    '  \"' +
                    appBloc.localstr.prerequisLabelContenttypelabel +
                    '\" ' +
                    appBloc.localstr.prerequistesalerttitle5Alerttitle7;

                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(
                            appBloc.localstr.detailsAlerttitleStringalert,
                            style: TextStyle(
                                color: Color(
                                  int.parse(
                                      '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                ),
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            alertMessage,
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                            )),
                          ),
                          backgroundColor: InsColor(appBloc).appBGColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                  appBloc.localstr.eventsAlertbuttonOkbutton),
                              style: textButtonStyle,
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
              } else {
                // covered
                bool result = await MyLearningController().decideCourseLaunchMethod(
                  context: context,
                  table2: table2,
                  isContentisolation: false,
                );
                if (!result) {
                  table2.isdownloaded = false;
                  setState(() {});
                }

                // bool networkAvailable =
                //     await AppDirectory.checkInternetConnectivity();
                // if (networkAvailable) {
                //   await MyLearningController().launchCourse(
                //       table2: table2,
                //       context: context,
                //       isContentisolation: false);
                // }
                // else {
                //   bool isShownOffline = await MyLearningController().launchCourseOffline(context: context, table2: table2);
                //   if (!isShownOffline) {
                //     table2.isdownloaded = false;
                //     setState(() {});
                //   }
                // }
                refreshContent(table2);
              }
            });
      }
    }

    return Container();
  }

  Widget displayView(DummyMyCatelogResponseTable2 table2) {
    if ([11, 14, 20, 21, 28, 36, 52].contains(table2.objecttypeid)) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return Container();
      } else {
        return BottomsheetOptionTile(

          text: (appBloc.localstr.mylearningActionsheetViewoption != null) ? appBloc.localstr.mylearningActionsheetViewoption: '',
          iconData:IconDataSolid(int.parse('0xf06e')),

          onTap: () async {
            Navigator.of(context).pop();

            if (isValidString(table2.viewprerequisitecontentstatus ?? '')) {
//              print('ifdataaaaa');
              String alertMessage =
                  appBloc.localstr.prerequistesalerttitle6Alerttitle6;
              alertMessage = alertMessage +
                  '  \"' +
                  appBloc.localstr.prerequisLabelContenttypelabel +
                  '\" ' +
                  appBloc.localstr.prerequistesalerttitle5Alerttitle7;

              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          appBloc.localstr.detailsAlerttitleStringalert,
                          style: TextStyle(
                              color: Color(
                                int.parse(
                                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                              ),
                              fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          children: [
                            Text(alertMessage,
                                style: TextStyle(
                                    color: Color(
                                  int.parse(
                                      '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                ))),
                            Text(
                                table2.viewprerequisitecontentstatus
                                    .toString()
                                    .split('#%')[1]
                                    .split('\$;')[0],
                                style: TextStyle(
                                    color: Color(
                                  int.parse(
                                      '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                ))),
                            Text(
                                table2.viewprerequisitecontentstatus
                                    .toString()
                                    .split('#%')[1]
                                    .split('\$;')[1],
                                style: TextStyle(
                                    color: Color(
                                  int.parse(
                                      '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                                )))
                          ],
                        ),
                        backgroundColor: InsColor(appBloc).appBGColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                                appBloc.localstr.eventsAlertbuttonOkbutton),
                            style: textButtonStyle,
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            } else {
//
              bool result = await MyLearningController().decideCourseLaunchMethod(
                context: context,
                table2: table2,
                isContentisolation: false,
              );
              if (!result) {
                table2.isdownloaded = false;
                setState(() {});
              }
              // bool networkAvailable =
              //     await AppDirectory.checkInternetConnectivity();
              // if (networkAvailable) {
              //   await MyLearningController().launchCourse(
              //       table2: table2,
              //       context: context,
              //       isContentisolation: false);
              // } else {
              //   bool isShownOffline = await MyLearningController()
              //       .launchCourseOffline(context: context, table2: table2);
              //   if (!isShownOffline) {
              //     table2.isdownloaded = false;
              //     setState(() {});
              //   }
              // }
              refreshContent(table2);
            }
          },
        );
      }
    }
    else if ([70, 688].contains(table2.objecttypeid)) {
      return Container();
    }
    else {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf06e')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text(appBloc.localstr.mylearningActionsheetViewoption,
            style: TextStyle(
                color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            ))),
        onTap: () async {
          Navigator.of(context).pop();

          if (isValidString(table2.viewprerequisitecontentstatus ?? '')) {
//            print('ifdataaaaa');
            String alertMessage =
                appBloc.localstr.prerequistesalerttitle6Alerttitle6;
            alertMessage = alertMessage;
            // '  \"' +
            // appBloc.localstr.prerequisLabelContenttypelabel +
            // '\" ' +
            // appBloc.localstr.prerequistesalerttitle5Alerttitle7;

            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        'Pre-requisite Sequence',
                        style: TextStyle(
                            color: Color(
                              int.parse(
                                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
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
                                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                              ))),
                          Text(
                              '\n' +
                                  table2.viewprerequisitecontentstatus
                                      .toString()
                                      .split('#%')[1]
                                      .split('\$;')[0],
                              style: TextStyle(
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
                                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                              )))
                        ],
                      ),
                      backgroundColor: InsColor(appBloc).appBGColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      actions: <Widget>[
                        TextButton(
                          child:
                              Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                          style: textButtonStyle,
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          } else {
//
            // covered
            bool result = await MyLearningController().decideCourseLaunchMethod(
              context: context,
              table2: table2,
              isContentisolation: false,
            );
            if (!result) {
              table2.isdownloaded = false;
              setState(() {});
            }
            // bool networkAvailable =
            //     await AppDirectory.checkInternetConnectivity();
            // if (networkAvailable) {
            //   await MyLearningController().launchCourse(table2: table2, context: context, isContentisolation: false);
            // } else {
            //   bool isShownOffline = await MyLearningController()
            //       .launchCourseOffline(context: context, table2: table2);
            //   if (!isShownOffline) {
            //     table2.isdownloaded = false;
            //     setState(() {});
            //   }
            // }
            refreshContent(table2);
          }
        },
      );
    }
//    return Container();
  }

  Widget displayDetails(DummyMyCatelogResponseTable2 table2, int i) {
    table2.isaddedtomylearning = 1;
    if (typeFrom == 'event' || typeFrom == 'track') {
      return Container();
    }

    if (table2.objecttypeid == 70 && (table2.bit4 != null && table2.bit4)) {
      return Container();
    }
    return BottomsheetOptionTile(
        iconData: IconDataSolid(int.parse('0xf570')),
        text: appBloc.localstr.mylearningActionsheetDetailsoption,
        onTap: () {
          Navigator.pop(context);
          print("Object Type Id:${table2.objecttypeid}");
          if (table2.objecttypeid == 70 && table2.eventscheduletype == 2 /*appBloc.uiSettingModel.EnableMultipleInstancesforEvent == 'true'*/) {
            Navigator.of(context)
                .push(MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => ProviderModel(),
                  child: CommonDetailScreen(
                    screenType: ScreenType.MyLearning,
                    contentid: table2.contentid,
                    objtypeId: table2.objecttypeid,
                    detailsBloc: detailsBloc,
                    table2: table2,
                    //     nativeModel: widget.nativeModel,
                    isFromReschedule: false,
                    //isFromMyLearning: false
                  ),
                )))
                .then((value) => {
              if (value == true)
                {
                  refreshMyLearningContents()
                }
            });
          }
          else if (table2.objecttypeid == 70) {
            print(
                'isaddedtomylearning' + table2.isaddedtomylearning.toString());
            Navigator.of(context)
                .push(MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => ProviderModel(),
                  child: CommonDetailScreen(
                      screenType: ScreenType.MyLearning,
                      contentid: table2.contentid,
                      objtypeId: table2.objecttypeid,
                      detailsBloc: detailsBloc,
                      table2: table2,
                      isFromReschedule: false),
                )))
                .then((value) => {
              if (value == true)
                {
                  refreshMyLearningContents()
                }
            });
          }
          else {
            print(
                'isaddedtomylearning' + table2.isaddedtomylearning.toString());
            Navigator.of(context)
                .push(MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => ProviderModel(),
                  child: CommonDetailScreen(
                      screenType: ScreenType.MyLearning,
                      contentid: table2.contentid,
                      objtypeId: table2.objecttypeid,
                      detailsBloc: detailsBloc,
                      table2: table2,
                      pos: i,
                      mylearninglist: myLearningBloc.list,
                      isFromReschedule: false
                    //isFromMyLearning: true
                  ),
                )))
                .then((value) => {
              if (value == true)
                {
                  print(
                      "Search String:${myLearningBloc.searchMyCourseString}"),
                  refreshMyLearningContents()
                }
            });
          }
        });
  }

  Widget displayJoin(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
      if (isValidString(table2.eventenddatetime ??
          "")) if (!returnEventCompleted(table2.eventenddatetime ?? "")) {
        if (table2.typeofevent == 2) {
          return BottomsheetOptionTile(iconData: IconDataSolid(int.parse('0xf234')), text: appBloc.localstr.mylearningActionsheetJoinoption,

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
                  toastDuration: Duration(seconds: 2),
                );
//              Toast.makeText(v.getContext(), 'No Url Found', Toast.LENGTH_SHORT).show();
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

  Widget displayReport(DummyMyCatelogResponseTable2 table2) {
    if ([11, 14, 20, 21, 36, 52].contains(table2.objecttypeid)) {
      return Container();
    }
    else if ([27, 70, 688].contains(table2.objecttypeid) || table2.objecttypeid == 70) {
      return Container();
    }
    else {
      if (!isReportEnabled) {
        return Container();
      }

      return BottomsheetOptionTile(
          text: appBloc.localstr.mylearningActionsheetReportoption,
          svgImageUrl:"assets/Report.svg",
          iconColor:InsColor(appBloc).appIconColor,
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProgressReport(table2, detailsBloc, '', '-1')));
          },
      );
    }
  }

  Widget displayaddToCalendar(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
//      print(
//          'addtocalendar ${table2.objecttypeid} ${table2.eventenddatetime} ${returnEventCompleted(table2.eventenddatetime)}');

      if (isValidString(table2.eventenddatetime ??
          "")) if (!returnEventCompleted(table2.eventenddatetime ?? "")) {
        return BottomsheetOptionTile(
          iconData:
            IconDataSolid(int.parse('0xf271')),
          text: appBloc.localstr.mylearningActionsheetAddtocalendaroption,
          onTap: () {
            DateTime startDate = DateFormat('yyyy-MM-ddTHH:mm:ss')
                .parse(table2.eventstartdatetime ?? "");
            DateTime endDate = DateFormat('yyyy-MM-ddTHH:mm:ss')
                .parse(table2.eventenddatetime ?? "");

//            print(
//                'event start-end time ${table2.eventstartdatetime ?? ""}  ${table2.eventenddatetime}');
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
                toastDuration: Duration(seconds: 2),
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
    if ([11, 14, 20, 21, 28, 36, 52].contains(table2.objecttypeid)) {
      if (isValidString(table2.actualstatus) &&
          ((table2.actualstatus != 'completed') &&
              (table2.actualstatus != 'not attempted'))) {
        return BottomsheetOptionTile(
              svgImageUrl: 'assets/SetComplete.svg',
              iconColor: InsColor(appBloc).appIconColor,
            text:appBloc.localstr.mylearningActionsheetSetcompleteoption,
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
        return BottomsheetOptionTile(
iconData:            Icons.content_copy,
          text:appBloc.localstr.mylearningActionsheetRelatedcontentoption,
          onTap: () {
            Navigator.of(context).pop();

            if (isValidString(table2.viewprerequisitecontentstatus ?? "")) {
              String alertMessage =
                  appBloc.localstr.prerequistesalerttitle6Alerttitle6;
              alertMessage = alertMessage +
                  ' \"${table2.viewprerequisitecontentstatus}' +
                  '\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}';

              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    appBloc.localstr.detailsAlerttitleStringalert,
                    style: TextStyle(
                      color: Color(
                        int.parse(
                            '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    alertMessage,
                    style: TextStyle(
                        color: Color(
                          int.parse(
                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                        )),
                  ),
                  backgroundColor: InsColor(appBloc).appBGColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  actions: <Widget>[
                    TextButton(
                      child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                      style: textButtonStyle,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } else {
              if (table2.objecttypeid == 70) {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => EventTrackList(
                      table2,
                      false,
                      [],
                    ),
                  ),
                )
                    .then((value) {
                  setState(() {});
                });
              } else {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => EventTrackList(
                      table2,
                      true,
                      myLearningBloc.list,
                    ),
                  ),
                )
                    .then((value) {
                  setState(() {});
                });
              }
            }
          },
        );
      }
    }

    return Container();
  }

  Widget displayCancelEnrollemnt(DummyMyCatelogResponseTable2 table2, int i) {
    pos = i;

    if (table2.objecttypeid != 70) {
      return Container();
    }

    print("Event Start Date:${table2.eventstartdatetime}");
    print("table2.bit2:${table2.bit2}");
    print(
        "returnEventCompleted:${returnEventCompleted(table2.eventstartdatetime ?? "")}");

    // returnEventCompleted
    if (isValidString(table2.eventstartdatetime ?? "")) {
      if (!returnEventCompleted(table2.eventstartdatetime ?? "")) {
        if (table2.bit2 != null && table2.bit2) {
          return BottomsheetOptionTile(
            iconData:IconDataSolid(int.parse('0xf410')),
            text:appBloc.localstr.mylearningActionsheetCancelenrollmentoption,
            onTap: () {
              Navigator.of(context).pop();
              checkCancellation(table2, context);
            },
          );
        }

        // for schedule events
        if (table2.eventscheduletype == 1 &&
            appBloc.uiSettingModel.enableMultipleInstancesForEvent == 'true') {
          return BottomsheetOptionTile(
              iconData:Icons.cancel,
                  text:appBloc.localstr.mylearningActionsheetCancelenrollmentoption,
              onTap: () {
                 Navigator.of(context).pop();
                checkCancellation(table2, context);
              });
        }
      }
    }

    return Container();
  }

  Widget displayDelete(DummyMyCatelogResponseTable2 table2) {
    downloadPath(table2.contentid, table2);

    if (table2.isdownloaded && table2.objecttypeid != 70) {
      return BottomsheetOptionTile(
      iconData: IconDataSolid(int.parse('0xf1f8')),
      text: appBloc.localstr.mylearningActionsheetDeleteoption,

        /// TODO : Sagar sir - delete offline file
        onTap: () async {
          Navigator.pop(context);

          bool fileDel = await deleteFile(downloadDestFolderPath);

          print('filedeleted $downloadDestFolderPath ${table2.contentid}');
          if (fileDel) {
            setState(() {
              table2.isdownloaded = false;
              table2.isDownloading = false;
            });
          }
        },
      );
    }

    return Container();
  }

  Widget displayArchive(DummyMyCatelogResponseTable2 table2) {
    if (table2.isarchived) {
      return Container();
    }
    return BottomsheetOptionTile(
      iconData:        IconDataSolid(int.parse('0xf187')),
      text:        appBloc.localstr.mylearningActionsheetArchiveoption,
      onTap: () {
        myLearningBloc.add(
          AddToArchiveCall(
            isArchive: true,
            strContentID: table2.contentid,
            table2: table2,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  Widget displayUnArachive(DummyMyCatelogResponseTable2 table2) {
    if (!table2.isarchived) {
      return Container();
    }
    return BottomsheetOptionTile(
      iconData:        IconDataSolid(int.parse('0xf187')),
      text:        appBloc.localstr.mylearningActionsheetUnarchiveoption,
      onTap: () {
        myLearningBloc.add(
          RemoveToArchiveCall(
            isArchive: false,
            strContentID: table2.contentid,
            table2: table2,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  Widget displayRemove(DummyMyCatelogResponseTable2 table2) {
    if ((table2.objecttypeid == 70 && table2.bit4 != null && table2.bit4) || table2.removelink) {
      return BottomsheetOptionTile(
          iconData: IconDataSolid(int.parse('0xf056')),
          text: appBloc.localstr.mylearningActionsheetRemovefrommylearning,
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
                          '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                    ),
                  ),
                ),
                content: Text(
                  appBloc.localstr.mylearningAlertsubtitleRemovethecontentitem,
                  style: TextStyle(
                    color: Color(
                      int.parse(
                          '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                    ),
                  ),
                ),
                backgroundColor: Color(
                  int.parse(
                      '0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}'),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                actions: <Widget>[
                  TextButton(
                    child:
                    Text(appBloc.localstr.mylearningAlertbuttonYesbutton),
                    style: textButtonStyle,
                    onPressed: () async {
                      Navigator.of(context).pop();

                      setState(() {
                        myLearningBloc.isFirstLoading = true;
                        myLearningBloc.add(
                            RemoveFromMyLearning(contentId: table2.contentid));
                      });
                    },
                  ),
                ],
              ),
            );
          });
    }
    else {
      return Container();
    }
  }

  Widget displayReschedule(DummyMyCatelogResponseTable2 table2) {
    if (!isValidString(table2.reschduleparentid ?? '')) {
      return Container();
    }

    return BottomsheetOptionTile(
      iconData: IconDataSolid(int.parse('0xf783')),
      text: appBloc.localstr.mylearningActionbuttonRescheduleactionbutton,
              // TODO : Sprint -3

        onTap: () {
          Navigator.pop(context);
          if ((table2.objecttypeid == 70 && table2.eventscheduletype == 2) ||
              table2.objecttypeid == 70 && table2.eventscheduletype == 1) {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => ProviderModel(),
                  child: CommonDetailScreen(
                    screenType: ScreenType.MyLearning,
                    contentid: table2.reschduleparentid,
                    objtypeId: table2.objecttypeid,
                    detailsBloc: detailsBloc,
                    table2: table2,
                    isFromReschedule: true,
                    isShowShedule: true,
                  ),
                ),
              ),
            )
                .then((value) {
              refreshMyLearningContents();
            });
          }
        });
  }

  Widget displayCertificate(DummyMyCatelogResponseTable2 table2) {
    if (isValidString(table2.certificateaction)) {
      return BottomsheetOptionTile(
          svgImageUrl: 'assets/Certificate.svg',
            iconColor: InsColor(appBloc).appIconColor,
          text:
          appBloc.localstr.mylearningActionsheetViewcertificateoption,
          onTap: () {
            if (!isValidString(table2.certificateaction) ||
                table2.certificateaction == 'notearned') {
              Navigator.of(context).pop();

              if(!ConnectionController().checkConnection(context: NavigationController().actbaseScaffoldKey.currentContext!)) {
                return;
              }

              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    appBloc.localstr.mylearningActionsheetViewcertificateoption,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(int.parse(
                            '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'))),
                  ),
                  content: Text(
                    appBloc.localstr.mylearningAlertsubtitleForviewcertificate,
                    style: TextStyle(
                        color: Color(int.parse(
                            '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'))),
                  ),
                  backgroundColor: Color(int.parse(
                      '0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}')),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  actions: <Widget>[
                    TextButton(
                      child: Text(appBloc.localstr
                          .mylearningClosebuttonactionClosebuttonalerttitle),
                      style: textButtonStyle,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } else {
              detailsBloc.myLearningDetailsModel.setcontentID(table2.contentid);
              detailsBloc.myLearningDetailsModel
                  .setCertificateId(table2.certificateid);
              detailsBloc.myLearningDetailsModel
                  .setCertificatePage(table2.certificatepage);

              Navigator.pop(context);

              if(!ConnectionController().checkConnection(context: NavigationController().actbaseScaffoldKey.currentContext!)) {
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewCertificate(
                    detailsBloc: detailsBloc,
                  ),
                ),
              );
            }
          });
    }
    return Container();
  }

  Widget displayQRCode(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
      if (isValidString(table2.qrimagename) &&
          isValidString(table2.qrcodeimagepath) &&
          !table2.bit4) {
        return BottomsheetOptionTile(
           iconData: IconDataSolid(int.parse('0xf029')),
            text:appBloc.localstr.mylearningActionsheetViewqrcode,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QrCodeScreen(
                      '${ApiEndpoints.strSiteUrl}${table2.qrcodeimagepath}'),
                ),
              );
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
          typeFrom == 'event' ||
          typeFrom == 'track') {
        return BottomsheetOptionTile(
            iconData:IconDataSolid(int.parse('0xf8d9')),
          text: appBloc.localstr.learningtrackLabelEventviewrecording,
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

  Widget displayShare(DummyMyCatelogResponseTable2 table2) {
    if (table2.suggesttoconnlink.isEmpty) {
      return Container();
    }

    return BottomsheetOptionTile(
        iconData:IconDataSolid(int.parse('0xf1e0')),
text:        'Share with Connection',
      onTap: () {
        Navigator.pop(context);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShareWithConnections(
              false,
              false,
              table2.name,
              table2.contentid,
            ),
          ),
        );
      },
    );
  }

  Widget displayShareConnection(DummyMyCatelogResponseTable2 table2) {
    if (table2.suggestwithfriendlink.isEmpty) {
      return Container();
    }

    return BottomsheetOptionTile(
      iconData:IconDataSolid(int.parse('0xf079'),),
      text: 'Share with People',
      onTap: () {
        Navigator.pop(context);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShareMainScreen(
                true, false, false, table2.contentid, table2.name),
          ),
        );
      },
    );
  }

  Widget displaySendViaEmail(DummyMyCatelogResponseTable2 table2) {
    //if ((table2?.ShareContentwithUser?.length ?? 0) > 0) {
    if (privilegeCreateForumIdExists()) {
      if (table2.objecttypeid == 14) {
        return BottomsheetOptionTile(
            iconData:Icons.email,
            text:  appBloc.localstr.mylearningsendviaemailnewoption.isEmpty
                  ? 'Share via Email'
                  : appBloc.localstr.mylearningsendviaemailnewoption,

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
  //endregion My Learning Bottomsheet Options

  //region My Downloads Bottomsheet
  Widget displayPauseDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading || !downloadModel.table2.isDownloading) {
      return SizedBox();
    }

    return BottomsheetOptionTile(
        iconData:Icons.pause,
text:        "Pause Download",
      onTap: () async {
        Navigator.of(context).pop();

        onDownloading(downloadModel);
      },
    );
  }

  Widget displayResumeDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading || downloadModel.table2.isDownloading) {
      return SizedBox();
    }

    return BottomsheetOptionTile(
        iconData:Icons.play_arrow,
text:        "Resume Download",
      onTap: () async {
        Navigator.of(context).pop();

        onDownloadPaused(downloadModel);
      },
    );
  }

  Widget displayCancelDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading) {
      return SizedBox();
    }

    return BottomsheetOptionTile(
        iconData:Icons.delete,
text:        "Cancel Download",
      onTap: () async {
        MyPrint.printOnConsole('Cancel Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        await MyLearningDownloadController().cancelDownload(downloadModel);
        setState(() {});
      },
    );
  }

  Widget displayRemoveFromDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(!downloadModel.isFileDownloaded) {
      return SizedBox();
    }

    return BottomsheetOptionTile(
        iconData:Icons.delete,
        text:  "Remove from Downloads",
        onTap: () async {
        MyPrint.printOnConsole('Cancel Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        await MyLearningDownloadController().removeFromDownload(downloadModel);
        setState(() {});
      },
    );
  }
  //endregion My Downloads Bottomsheet


  bool privilegeCreateForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 1349) {
        return true;
      }
    }
    return false;
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
      fromDate = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(eventDate);

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

  bool isValidString(String val) {
    if (val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
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

  void downloadPath(
      String contentid, DummyMyCatelogResponseTable2 table2) async {
    String path = await AppDirectory.getDocumentsDirectory() +
        '/.Mydownloads/Contentdownloads' +
        '/' +
        contentid;

    setState(() {
      downloadDestFolderPath = path;
    });

    final File myFile = File(downloadDestFolderPath);

    print('myfiledata $myFile');

    checkFile(downloadDestFolderPath, table2);
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

  Future<void> executeXAPICourse(
      DummyMyCatelogResponseTable2 learningModel) async {
    print("executeXAPICourse called");

    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String paramsString = 'strContentID=${learningModel.contentid}' +
        '&UserID=$strUserID' +
        '&SiteID=$strSiteID' +
        '&SCOID=${learningModel.scoid.toString()}' +
        '&CanTrack=true';

    String url = webApiUrl + 'CourseTracking/TrackLRSStatement?' + paramsString;

    ApiResponse? apiResponse = await generalRepository.executeXAPICourse(url);
    print("XApi Response:${apiResponse?.data}");
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
    evntModuleBloc
        .add(BadCancelEnrollment(contentid: table2.contentid, table2: table2));
  }

  void cancelEnrollment(DummyMyCatelogResponseTable2 table2, String bool) {
    evntModuleBloc.add(TrackCancelEnrollment(
        isBadCancel: bool, strContentID: table2.contentid, table2: table2));
  }

  void showCancelEnrollDialog(
      DummyMyCatelogResponseTable2 table2, String isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          appBloc.localstr.mylearningAlerttitleStringareyousure,
          style: TextStyle(
              color: InsColor(appBloc).appTextColor,
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          appBloc
              .localstr.mylearningAlertsubtitleDoyouwanttocancelenrolledevent,
          style: TextStyle(
              color: InsColor(appBloc).appTextColor,
              fontWeight: FontWeight.normal),
        ),
        backgroundColor: InsColor(appBloc).appBGColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        actions: <Widget>[
          TextButton(
            child: Text(appBloc.localstr.catalogAlertbuttonCancelbutton),
            style: textButtonStyle,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
            style: textButtonStyle,
            onPressed: () async {
              Navigator.of(context).pop();
              cancelEnrollment(table2, isSuccess);
            },
          ),
        ],
      ),
    );
  }

  Widget callLoader(int i) {
    if (i == 0) {
      return Container();
    } else if (i == 1) {
      return Container(
        height: 200,
        width: 200,
        color: Colors.red,
        child: Text('Loading'),
      );
    } else if (i == 2) {
      return Text('Error');
    } else
      return SizedBox();
  }

  Widget displayDownloadTile(DummyMyCatelogResponseTable2 table2, [int i = 0]) {
    print('dummytable ${table2.isdownloaded}');

    if ((table2.objecttypeid == 10 && table2.bit5) ||
        [20, 27, 28, 36, 70, 102, 688, 693].contains(table2.objecttypeid)) {
      return Container();
    } else if (table2.isdownloaded && table2.objecttypeid != 70) {
      return Container();
    } else {
      return Expanded(
        child: Stack(
          children: <Widget>[
            !table2.isdownloaded
                ? Container(
                    child: TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Color(int.parse(
                                  '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}'));
                            }
                            return Color(int.parse(
                                '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')); // Defer to the widget's default.
                          },
                        ),
                      ),
                      icon: Icon(
                        Icons.cloud_download,
                        color: Color(int.parse(
                            '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                        size: 25,
                      ),
                      label: Text(
                        appBloc.localstr.mylearningActionsheetDownloadoption
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: Color(int.parse(
                              '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                        ),
                      ),
                      onPressed: (table2.isdownloaded)
                          ? null
                          : () async {
                              /// Download
                              /// Check For internet and download
                              ///
                              ///
                              ///
//                       print('downloadpathh  $fileExists');
                              if (!table2.isdownloaded) {
                                setState(() {
                                  table2.isDownloading = true;
                                });
                                PermissionStatus permission =
                                    await Permission.storage.status;

                                if (permission != PermissionStatus.granted) {
                                  await Permission.storage.request();
                                  PermissionStatus permission =
                                      await Permission.storage.status;
                                  if (permission == PermissionStatus.granted) {
                                    /// Permission Granted

                                    downloadCourse = DownloadCourse(
                                        context,
                                        table2,
                                        false,
                                        appBloc.uiSettingModel,
                                        i,
                                        streamController,
                                        doSomething);

                                    downloadCourse!.downloadTheCourse();
                                  } else {
                                    /// Notify User
                                  }
                                } else {
                                  downloadCourse = DownloadCourse(
                                      context,
                                      table2,
                                      false,
                                      appBloc.uiSettingModel,
                                      i,
                                      streamController,
                                      doSomething);

                                  downloadCourse!.downloadTheCourse();
                                }
                              }

                              /*    downloadCourse=DownloadCourse(context,table2,false,appBloc.uiSettingModel,0);

                                    downloadCourse.downloadTheCourse();*/

/*
                                    if (isNetworkConnectionAvailable(context, -1)) {
                                      downloadTheCourse(myLearningModelsList.get(position), view, position);
                                    }
                                    else {
                                      showToast(context, getLocalizationValue(JsonLocalekeys.network_alerttitle_nointernet));
                                    }*/
                            },
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }
  }

  Widget displayDownloadTile2(DummyMyCatelogResponseTable2 table2,
      [int i = 0]) {
    //table2.isdownloaded = false;
    print('isdownloaded ${table2.isdownloaded}');

    String buttonText =
        appBloc.localstr.mylearningActionsheetDownloadoption.toUpperCase();
    if (table2.isdownloaded) {
      buttonText = 'DOWNLOADED';
    } else if (table2.isDownloading) {
      buttonText = 'DOWNLOADING';
    }

    //if ([8, 9, 10, 26, 52, 102].contains(table2.objecttypeid) || (table2.objecttypeid == 11)) {
    if ([8, 9].contains(table2.objecttypeid)) {
      return Expanded(
        child: GestureDetector(
          child: Container(
            height: 38,
            width: 1.0.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: table2.isdownloaded
                  ? Color(int.parse(
                          '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}'))
                      .withOpacity(0.5)
                  : Color(int.parse(
                      '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                table2.isDownloading
                    ? SpinKitRing(
                        color: Color(
                          int.parse(
                              '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}'),
                        ),
                        size: 18,
                        lineWidth: 2.0,
                      )
                    : Icon(
                        Icons.cloud_download,
                        color: Color(int.parse(
                            '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                        size: 25,
                      ),
                SizedBox(width: 8.0.w),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color(int.parse(
                        '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                  ),
                ),
              ],
            ),
          ),
          onTap: (table2.isdownloaded)
              ? () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) =>
                  //         OfflineContentLauncherInAppWebview(
                  //       table2: table2,
                  //     ),
                  //   ),
                  // );
                }
              : () async {
                  if (!table2.isdownloaded) {
                    setState(() {
                      table2.isDownloading = true;
                    });

                    bool isDownloaded = await MyLearningController()
                        .storeMyLearningContentOffline(
                            context, table2, appBloc.userid);
                    setState(() {
                      table2.isdownloaded = isDownloaded;
                      table2.isDownloading = false;
                    });
                  }
                },
        ),
      );
    } else {
      return SizedBox(width: 0.0);
    }
  }

  Widget displayViewTile(DummyMyCatelogResponseTable2 table2) {
    if ([11, 14, 20, 21, 28, 36, 52].contains(table2.objecttypeid)) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return Container();
      } else {
        return viewOption(
            table2, appBloc.localstr.mylearningActionsheetViewoption);
      }
    } else if (table2.objecttypeid == 688 || table2.objecttypeid == 70) {
      return Container();
    } else {
      return viewOption(
          table2, appBloc.localstr.mylearningActionsheetViewoption);
    }
  }

  Widget viewOption(DummyMyCatelogResponseTable2 table2,
      String mylearningActionsheetViewoption) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          height: 38,
          width: 1.0.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Color(int.parse(
                '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.remove_red_eye,
                color: Color(int.parse(
                    '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                size: 24,
              ),
              SizedBox(width: 8.0.w),
              Text(
                mylearningActionsheetViewoption.toUpperCase(),
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  color: Color(int.parse(
                      '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          bool isValidate =
              isValidString(table2.viewprerequisitecontentstatus ?? '');
          print('isValidate:$isValidate');

          if (isValidate) {
            print('ifdataaaaa');
            String alertMessage =
                appBloc.localstr.prerequistesalerttitle6Alerttitle6;
            alertMessage = alertMessage +
                '  \"' +
                appBloc.localstr.prerequisLabelContenttypelabel +
                '\" ' +
                appBloc.localstr.prerequistesalerttitle5Alerttitle7;

            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        'Pre-requisite Sequence',
                        style: TextStyle(
                            color: Color(
                              int.parse(
                                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
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
                                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                              ))),
                          Text(
                              '\n' +
                                  table2.viewprerequisitecontentstatus
                                      .toString()
                                      .split('#%')[1]
                                      .split('\$;')[0],
                              style: TextStyle(
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
                                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                              )))
                        ],
                      ),
                      backgroundColor: InsColor(appBloc).appBGColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      actions: <Widget>[
                        TextButton(
                          child:
                              Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                          style: textButtonStyle,
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          } else {
            // covered
            bool result = await MyLearningController().decideCourseLaunchMethod(
              context: context,
              table2: table2,
              isContentisolation: false,
            );
            if (!result) {
              table2.isdownloaded = false;
              setState(() {});
            }
            // bool networkAvailable = await AppDirectory.checkInternetConnectivity();
            // if (networkAvailable) {
            //   await MyLearningController().launchCourse(table2: table2, context: context, isContentisolation: false);
            // } else {
            //   bool isShownOffline = await MyLearningController()
            //       .launchCourseOffline(context: context, table2: table2);
            //   if (!isShownOffline) {
            //     table2.isdownloaded = false;
            //     setState(() {});
            //   }
            // }
            refreshContent(table2);
          }
        },
      ),
    );
  }

  Widget displayPlayTile(DummyMyCatelogResponseTable2 table2) {
    var objectTypeIds1 = [11, 14, 36, 28, 20, 21, 52];
    if (objectTypeIds1.contains(table2.objecttypeid)) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return viewOption(
            table2, appBloc.localstr.mylearningActionsheetPlayoption);
      }
    }

    return Container();
  }

  Future<void> launchCourseContentisolation(DummyMyCatelogResponseTable2 table2,
      BuildContext context, String token) async {
    print(
        'launchCourseContentisolation called with object type id:${table2.objecttypeid}');

    /// refresh the content
    var objectTypeIds = [
      8,
      9,
      10,
      28,
      102,
      26, /*694*/
    ];
    if (objectTypeIds.contains(table2.objecttypeid)) {
      String paramsString = '';
      if (table2.objecttypeid == 10 && table2.bit5) {
        paramsString = 'userID=${table2.userid.toString()}' +
            '&scoid=${table2.scoid.toString()}' +
            '&TrackObjectTypeID=${table2.objecttypeid.toString()}' +
            '&TrackContentID=${table2.contentid}' +
            '&TrackScoID=${table2.scoid.toString()}' +
            '&SiteID=${table2.siteid.toString()}' +
            '&OrgUnitID=${table2.siteid.toString()}' +
            '&isonexist=onexit';
      } else {
        paramsString = 'userID=${table2.userid.toString()}' +
            '&scoid=${table2.scoid.toString()}';
      }

      if (token.isNotEmpty) {
        String courseUrl;
        if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
          courseUrl =
              '${appBloc.uiSettingModel.azureRootPath}content/index.html?coursetoken=$token&TokenAPIURL=${ApiEndpoints.appAuthURL}';

          // assignmenturl = await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}';
        } else {
          courseUrl =
              '${ApiEndpoints.strSiteUrl}content/index.html?coursetoken=$token&TokenAPIURL=${ApiEndpoints.appAuthURL}';

          //assignmenturl = await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}';
        }

        if (table2.objecttypeid == 26) {
          // assignmenturl = await '$assignmenturl/ismobilecontentview/true';
          // print('assignmenturl is : $assignmenturl');
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  AdvancedWebCourseLaunch(courseUrl, table2.name),
            ),
          );
        } else {
          // assignmenturl = await '$assignmenturl/ismobilecontentview/true';
          print('Course Url:$courseUrl');
          await Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => InAppWebCourseLaunch(courseUrl, table2),
                ),
              )
              .then(
                (value) => {
                  if (value ?? true)
                    {
                      refreshMyLearningContents()
                    }
                },
              );
        }
        logger.d('.....Refresh Me....$courseUrl');

        /// Refresh Content Of My Learning

      }

      String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      String url = '$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString';

      print('launchCourseUrl $url');

      // https: //stagingesperanza.instancy.com/content/CourseMedium/index.html?coursetoken=76726415-995f-46f0-98c6-7936bd4db2d3

      detailsBloc.add(GetContentStatus(url: url, table2: table2));
    }
  }

  void refreshContent(DummyMyCatelogResponseTable2 table2) {
    MyPrint.printOnConsole("refreshContent called with objecttypeid:${table2.objecttypeid}");
    if(['11', '14', '20', '21', '36', '52'].contains(table2.objecttypeid.toString()) && table2.isdownloaded) {
      detailsBloc.add(SetCompleteEvent(table2: table2));
    }

    if(table2.isarchived) {
      refreshMyLearningArchieveContents();
    }
    else {
      refreshMyLearningContents();
    }
  }

  void refreshMyLearningContents() {
    myLearningBloc.isFirstLoading = true;
    pageNumber = 1;
    myLearningBloc.add(
      GetListEvent(
        pageNumber: 1,
        pageSize: 10,
        searchText: myLearningBloc.searchMyCourseString,
        isRefresh: true,
      ),
    );
  }

  void refreshMyLearningArchieveContents() {
    myLearningBloc.isArchiveFirstLoading = true;
    pageArchiveNumber = 1;
    myLearningBloc.add(
      GetArchiveListEvent(
        pageNumber: 1,
        pageSize: 10,
        searchText: myLearningBloc.searchArchiveString,
      ),
    );
  }

  /*Future<void> launchCourse(DummyMyCatelogResponseTable2 table2, BuildContext context, bool isContentisolation) async {
    print('launchCourse called with isContentisolation:$isContentisolation');

    */ /*
    //TODO: This content for testing purpuse
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

      logger.e('.....Refresh Me....$url');

      /// Refresh Content Of My Learning

    }
    return;
    */ /*

    /// content isolation only for 8,9,10,11,26,27
    if (!isContentisolation) {
      if (table2.objecttypeid == 8 ||
          table2.objecttypeid == 9 ||
          (table2.objecttypeid == 10 && !table2.bit5) ||
          table2.objecttypeid == 26 ||
          table2.objecttypeid == 102) {
        /// remove after normal course launch
        GotoCourseLaunchContentisolation courseLaunch =
            GotoCourseLaunchContentisolation(
                context, table2, appBloc.uiSettingModel, myLearningBloc.list);

        String courseUrl = await courseLaunch.getCourseUrl();

        myLearningBloc.add(CourseTrackingEvent(
          courseUrl: courseUrl,
          table2: table2,
          userID: table2.userid.toString(),
          objecttypeId: '${table2.objecttypeid}',
          siteIDValue: '${table2.siteid}',
          scoId: '${table2.scoid}',
          contentID: table2.contentid,
        ));
        return;
      }
    }

    /// Need Some value
    if (table2.objecttypeid == 102) {
      await executeXAPICourse(table2);
    }

    print('Table2 Objet Id:${table2.objecttypeid}');
    if (table2.objecttypeid == 10 && table2.bit5) {
      // Need to open EventTrackListTabsActivity
      print('Navigation to EventTrackList called');

      if(context != null){
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventTrackList(
            table2,
            true,
            myLearningBloc.list,
          ),
        ),
      );}
      else{

        setState(() {

        });

      }
      setState(() {});
      return;
    } else if (table2.objecttypeid == 694) {
      assignmenturl =
          '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}/ismobilecontentview/true';
      print('assignmenturl is : $assignmenturl');

      await Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => Assignmentcontentweb(
                url: assignmenturl,
                myLearningModel: table2,
              ),
            ),
          )
          .then(
            (value) => {
              if (value ?? true)
                {
                  refreshMyLearningContents()
                }
            },
          );
    }
    //sreekanth commented

    else if (table2.objecttypeid == 8 ||
        table2.objecttypeid == 9 ||
        table2.objecttypeid == 10 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 26) {
      String paramsString = '';
      if (table2.objecttypeid == 10 && table2.bit5) {
        paramsString = 'userID=${table2.userid.toString()}' +
            '&scoid=${table2.scoid.toString()}' +
            '&TrackObjectTypeID=${table2.objecttypeid.toString()}' +
            '&TrackContentID=${table2.contentid}' +
            '&TrackScoID=${table2.scoid.toString()}' +
            '&SiteID=${table2.siteid.toString()}' +
            '&OrgUnitID=${table2.siteid.toString()}' +
            '&isonexist=onexit';
      } else {
        paramsString = 'userID=${table2.userid.toString()}' +
            '&scoid=${table2.scoid.toString()}';
      }

      String webApiUrl = await sharePref_getString(sharedPref_webApiUrl);

      String url = '$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString';

      print('launchCourseUrl $url');

      detailsBloc.add(GetContentStatus(url: url, table2: table2));
    } else {
      courseLaunch = GotoCourseLaunch(
        context,
        table2,
        false,
        appBloc.uiSettingModel,
        myLearningBloc.list,
      );
      String url = await courseLaunch!.getCourseUrl();

      print('urldataaaaa $url');
      if (url.isNotEmpty) {
        if (table2.objecttypeid == 26) {
          print('Navigation to AdvancedWebCourseLaunch called');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdvancedWebCourseLaunch(url, table2.name),
            ),
          );
          return;
        } else {
          print('Navigation to InAppWebCourseLaunch called');
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => InAppWebCourseLaunch(
                    url,
                    table2,
                  ),
                ),
              )
              .then(
                (value) => {
                  if (value ?? true)
                    {
                      refreshMyLearningContents()
                    }
                },
              );
          return;
        }
        // logger.e('.....Refresh Me....$url');

        /// Refresh Content Of My Learning

      }
    }

    //sreekanth commented
    //Assignment content webview
  }
  */

  /*
  Future<void> launchCourseOffline(DummyMyCatelogResponseTable2 table2) async {
    bool fileCheck =
        await myLearningBloc.fileExistCheck(table2, appBloc.userid);
    print("launchCourseOffline called with isDownloaded:$fileCheck");

    if (!fileCheck) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(
                color: Color(
                  int.parse(
                      '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                ),
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            'This course has not been downloaded. Please download in order to view it.',
            style: TextStyle(
              color: Color(
                int.parse(
                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
              ),
            ),
          ),
          backgroundColor: InsColor(appBloc).appBGColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          actions: <Widget>[
            TextButton(
              child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
              style: textButtonStyle,
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OfflineContentLauncherInAppWebview(
          table2: table2,
        ),
      ),
    );
    return;
  }*/

  void checkRelatedContent(DummyMyCatelogResponseTable2 table2) {
    if (isValidString(table2.viewprerequisitecontentstatus ?? "")) {
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      String status = table2.viewprerequisitecontentstatus?.toString() ?? "";
      String prerequisite = appBloc.localstr.prerequistesalerttitle5Alerttitle7;
      alertMessage = '$alertMessage \"$status\" $prerequisite';

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            appBloc.localstr.detailsAlerttitleStringalert,
            style: TextStyle(
              color: Color(
                int.parse(
                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            alertMessage,
            style: TextStyle(
              color: Color(
                int.parse(
                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
              ),
            ),
          ),
          backgroundColor: InsColor(appBloc).appBGColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
              style: textButtonStyle,
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => EventTrackList(
            table2,
            false,
            myLearningBloc.list,
          ),
        ),
      )
          .then((value) {
        setState(() {});
      });
    }
  }
}
