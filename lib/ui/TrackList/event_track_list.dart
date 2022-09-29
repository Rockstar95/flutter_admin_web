import 'dart:async';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:flutter_admin_web/controllers/event_track_controller.dart';
import 'package:flutter_admin_web/controllers/my_learning_download_controller.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/EventTrackList/bloc/event_track_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/EventTrackList/event/event_track_event.dart';
import 'package:flutter_admin_web/framework/bloc/EventTrackList/state/event_track_state.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/database/hivedb_handler.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/download_course.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/file_course_downloader.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/ResEventTrackTabs.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/glossary_local_model.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/resTrackBlock.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/resource_tab_response.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/provider/event_track_api_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_public.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/providers/connection_provider.dart';
import 'package:flutter_admin_web/ui/Discussions/discussion_main_home.dart';
import 'package:flutter_admin_web/ui/MyLearning/Assignmentcontentweb.dart';
import 'package:flutter_admin_web/ui/MyLearning/components/mylearning_component_card.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunchContenisolation.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/progress_report.dart';
import 'package:flutter_admin_web/ui/MyLearning/qr_code_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/view_certificate.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/modal_progress_hud.dart';
import 'package:flutter_admin_web/ui/myConnections/connections_screen.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/snakbar.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../framework/helpers/sync_helper.dart';
import '../../models/my_learning/download_feature/mylearning_download_model.dart';
import '../../providers/my_learning_download_provider.dart';
import '../common/app_colors.dart';
import '../common/bottomsheet_drager.dart';
import '../common/outline_button.dart';
import '../common/rounded_square_progress_indicator.dart';

class EventTrackList extends StatefulWidget {
  final DummyMyCatelogResponseTable2 myLearningModel;

  //If This is true then it is Track else it is Event
  final bool isTraxkList;
  final List<DummyMyCatelogResponseTable2> list;

  EventTrackList(this.myLearningModel, this.isTraxkList, this.list);

  @override
  _EventTrackListState createState() => _EventTrackListState();
}

class _EventTrackListState extends State<EventTrackList> with TickerProviderStateMixin {
  late FToast flutterToast;
  Logger logger = Logger();
  bool isFirst = true, isLoading = false;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late MyLearningBloc myLearningBloc;

  String assignmenturl = "";

  late MyLearningDetailsBloc detailsBloc;
  FileCourseDownloader? fileCourseDownloader;

  String imgUrl = "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

  // mylearning model veribles

  String objecttypeid = "";
  String siteurl = "";
  String scoid = "";
  String contentid = "";
  String userid = "";
  String folderpath = "";
  String startpage = "";
  String courseName = "";
  String jwvideokey = "";
  String siteid = "";
  String activityid = "";
  String folderid = "";
  String startPage = "";
  String endDuarationDate = "";

  // local veribles

  String typeFrom = "track";
  String language = "";
  String webApiUrl = "";
  String strUserID = "";
  String strSiteID = "";
  String urlpath = "";

  late EventTrackBloc eventTrackBloc;
  final GlobalKey<NestedScrollViewState> _key = GlobalKey<NestedScrollViewState>();

  TabController? _tabController;
  List<Tab> tabList = [];
  ScrollController _sc = ScrollController();
  ScrollController _scTabs = ScrollController();
  bool isReportEnabled = true;

  int pageNumber = 1;
  int totalPage = 10;
  bool isGetListEvent = false;
  bool isDownloaded = false;
  bool isDownloading = false;

  int pageArchiveNumber = 1;
  bool isGetArchiveListEvent = false;

  bool fileExists = false;

  String downloadDestFolderPath = "";
  String downloadResPath = '';
  String pathSeparator = "";

  // for cource lounch

  GotoCourseLaunch? courseLaunch;
  DownloadCourse? downloadCourse;
  late GeneralRepository generalRepository;

  StreamController<int> streamController = StreamController();
  bool download = false;
  int _downloadProgress = 0;
  bool _downloaded = false;

  int downloadedProgess = 0;
  bool isConnected = false;

  String firstHalf = "";
  String secondHalf = "";
  late ProfileBloc profileBloc;
  bool flag = true;
  bool isGlossary = false;
  bool isResource = false;

  bool menu1 = false,
      menu2 = false,
      menu4 = false,
      menu5 = false,
      menu6 = false;

  String contentIconPath = '';

  double pinnedHeaderHeight = 0;

  ButtonStyle textButtonStyle = TextButton.styleFrom(
    primary: Colors.blue,
  );
  bool networkAvailable = true;

  //region card functions
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
  //endregion card functions

  @override
  void dispose() {
    _sc.dispose();
    streamController.close(); //Streams must be closed when not needed
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    profileBloc = ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());
    tabList.clear();
    myLearningBloc = MyLearningBloc(myLearningRepository: MyLearningRepositoryPublic());

    eventTrackBloc = EventTrackBloc(eventTrackListRepository: EventTrackListApiRepository());
    refreshContent(null);

    detailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());

    generalRepository = GeneralRepositoryBuilder.repository();

    typeFrom = (widget.isTraxkList) ? 'track' : 'event';

    /*downloadPath(widget.myLearningModel.contentid, widget.myLearningModel);
    download = displayDownloadView(widget.myLearningModel);*/

    contentIconPath = widget.myLearningModel.iconpath;

    if (appBloc.uiSettingModel.azureRootPath != null) {
      contentIconPath = contentIconPath.startsWith('http')
          ? widget.myLearningModel.iconpath
          : appBloc.uiSettingModel.azureRootPath +
              widget.myLearningModel.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    } else {
      contentIconPath = widget.myLearningModel.siteurl + contentIconPath;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      networkAvailable = await AppDirectory.checkInternetConnectivity();
      setState(() {});
    });
  }

  /*bool displayDownloadView(DummyMyCatelogResponseTable2 table2) {
    print('obttypeid ${table2.objecttypeid}  ${table2.isdownloaded}');

    if ((table2.objecttypeid == 10 && table2.bit5) ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 688 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 27 ||
        table2.objecttypeid == 70) {
      print('download if');
      download = false;
      return download;
    } else if (table2.isdownloaded && table2.objecttypeid != 70) {
      print('download else if');
      download = false;
      return download;
    } else {
      download = true;
      return download;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    print("Parent Scoid:${widget.myLearningModel.scoid}, Progress:${widget.myLearningModel.progress}");

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    //widget.myLearningModel.progress = "0";

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.transparent,
      progressIndicator: const Center(
        child: RoundedSquareProgressIndicator(),
      ),
      child: Container(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: SafeArea(
          child: Scaffold(
            body: BlocConsumer<MyLearningBloc, MyLearningState>(
              bloc: myLearningBloc,
              listener: (context, state) {
                if (state is GetListState) {
                  if (state.status == Status.COMPLETED) {
                    refreshContent(null);
                  }
                }
                else if (state is CourseTrackingState) {
                  if (state.status == Status.COMPLETED) {
                    print(state.response);
                    if (AppDirectory.isValidString(state.response)) {
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
                }
                else if (state is TokenFromSessionIdState) {
                  if (state.status == Status.COMPLETED) {
                    if (AppDirectory.isValidString(state.response) &&
                        state.response.contains('failed')) {
                      launchCourse(state.table2, context, true);
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
              },
              builder: (context, state) {
                return BlocConsumer<MyLearningDetailsBloc, MyLearningDetailsState>(
                  bloc: detailsBloc,
                  listener: (BuildContext context, state) {
                    print("MyLearningDetailsBloc Listner Called For State:${state.runtimeType} with Status:${state.status}");

                    if (state is GetContentStatusState) {
                      if (state.status == Status.COMPLETED) {
                        print(
                            "Got Content Status for scoid:${state.table2.scoid}, content status:${state.contentstatus.contentStatus}, Progress:${state.contentstatus.progress}");
                        state.table2.corelessonstatus =
                            state.contentstatus.contentStatus;
                        state.table2.contentstatus =
                            state.contentstatus.contentStatus;
                        state.table2.progress = state.contentstatus.progress;
                      }
                    }
                  },
                  builder: (BuildContext context, state) {
                    return BlocConsumer<EventTrackBloc, EventTrackState>(
                        bloc: eventTrackBloc,
                        listener: (context, state) {
                          print("EVentTrackBloc Listner Called For State:${state.runtimeType} with Status:${state.status}");

                          if (state is GetTrackListState) {
                            if (state.status == Status.COMPLETED) {
//            print("List size ${state.list.length}");
                              tabList.clear();
                              isFirst = false;
                              if (eventTrackBloc.resEventTrackTabs.isNotEmpty) {
                                for (ResEventTrackTabs tab
                                    in eventTrackBloc.resEventTrackTabs) {
                                  tabList.add(Tab(
                                    text: tab.tabName,
                                  ));

                                  if (tab.tabidName == 'TGlossary') {
                                    eventTrackBloc.add(TrackListGlossary(
                                        contentId:
                                            widget.myLearningModel.contentid));
                                  }

                                  if (tab.tabidName == 'TResource') {
                                    eventTrackBloc.add(TrackListResources(
                                        contentId:
                                            widget.myLearningModel.contentid));
                                  }

                                  if (tab.tabidName == 'TOverview') {
                                    eventTrackBloc.add(TrackListOverView(
//                              userId: widget.myLearningModel.userid,
                                        contentId:
                                            widget.myLearningModel.contentid,
                                        objecttypeid: widget
                                            .myLearningModel.objecttypeid));
                                  }
                                }
                              }

                              _tabController = TabController(
                                  length: tabList.length, vsync: this);
                            } else if (state.status == Status.ERROR) {
                              print("listner Error ${state.message}");
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is CancelEnrollmentState) {
                            if (state.status == Status.COMPLETED) {
                              if (state.isSuccess == 'true') {
                                widget.myLearningModel.isaddedtomylearning = 0;
                                widget.myLearningModel.availableseats =
                                    widget.myLearningModel.availableseats + 1;

                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg:
                                          'Your enrollment for the course has been successfully canceled'),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                );
                                Navigator.of(context).pop();
                              } else {
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg: 'Something went wrong'),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
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
                              showCancelEnrollDialog(
                                  widget.myLearningModel, state.isSuccess);
                            } else if (state.status == Status.ERROR) {
                              if (state.message == '401') {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is TrackListOverViewState) {
                            if (state.status == Status.COMPLETED) {
                              if (eventTrackBloc.overviewResponse.isNotEmpty) {
                                String description = eventTrackBloc
                                        .overviewResponse[0].shortdescription +
                                    eventTrackBloc
                                        .overviewResponse[0].longdescription;
                                if (description.length > 100) {
                                  firstHalf = description.substring(0, 100);
                                  secondHalf = description.substring(
                                      100, description.length);
                                } else {
                                  firstHalf = description;
                                  secondHalf = "";
                                }
                              }
                            } else if (state.status == Status.ERROR) {
                              if (state.message == '401') {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is TrackAddtoArchiveCallState) {
                            setState(() {
                              detailsBloc.myLearningDetailsModel.setisArchived(true);
                              eventTrackBloc.add(GetTrackListData(
                                  isInternet: true,
                                  isTraxkList: true,
                                  myLearningModel: widget.myLearningModel,
                                  appBloc: appBloc));
                            });
                          }
                          else if (state is TrackRemovetoArchiveCallState) {
                            setState(() {
                              detailsBloc.myLearningDetailsModel
                                  .setisArchived(false);
                              eventTrackBloc.add(GetTrackListData(
                                  isInternet: true,
                                  isTraxkList: true,
                                  myLearningModel: widget.myLearningModel,
                                  appBloc: appBloc));
                            });
                          }
                          else if (state is TrackRemoveFromMyLearningState) {
                            print('statestaus ${state.status}');
                            if (state.status == Status.COMPLETED) {
                              setState(() {
                                detailsBloc.myLearningDetailsModel
                                    .setisArchived(false);
                                eventTrackBloc.add(GetTrackListData(
                                    isInternet: true,
                                    isTraxkList: true,
                                    myLearningModel: widget.myLearningModel,
                                    appBloc: appBloc));
                              });
                            } else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is TrackListResourceState) {
                            if (state.status == Status.COMPLETED) {
//              setState(() {
//              });
                            } else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is SetCompleteState) {
                            if (state.status == Status.LOADING) {
                              flutterToast.showToast(
                                child: CommonToast(displaymsg: 'Please wait'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 2),
                              );
                            } else if (state.status == Status.COMPLETED) {
                              flutterToast.showToast(
                                child: CommonToast(
                                    displaymsg:
                                        'Course completed successfully'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 2),
                              );
                              setState(() {
                                eventTrackBloc.add(GetTrackListData(
                                    isInternet: true,
                                    isTraxkList: true,
                                    myLearningModel: widget.myLearningModel,
                                    appBloc: appBloc));
                              });
                            } else if (state.status == Status.ERROR) {
                              flutterToast.showToast(
                                child: CommonToast(
                                    displaymsg:
                                        'Filed to update course status'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 2),
                              );
                            }
                          }
                          else if (state is TrackListGlossaryState) {
                            if (state.status == Status.COMPLETED) {
//              setState(() {
//              });
                            } else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is TrackSetCompleteState) {
                            if (state.status == Status.COMPLETED) {
                              setState(() {
                                state.table2.percentcompleted = '100.00';
                                state.table2.progress = '100';
                                state.table2.actualstatus = 'completed';
                                state.table2.corelessonstatus = 'Completed';
                              });

                              flutterToast.showToast(
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                  child: CommonToast(
                                      displaymsg:
                                          'Course completed successfully'));
                              print(
                                  'mystateuscomplete ${state.table2.percentcompleted}');

                              createParentUrl(widget.myLearningModel);
                            } else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is TrackGetContentStatusState) {
                            if (state.status == Status.COMPLETED) {
                              if (widget.myLearningModel.objecttypeid != 70) {
                                createParentUrl(widget.myLearningModel);
                              }

                              setState(() {
                                eventTrackBloc.isExpanded = true;
                                state.table2.actualstatus =
                                    state.contentstatus.name;
                                state.table2.progress =
                                    state.contentstatus.progress;
                                if (state.contentstatus.progress != null ||
                                    state.contentstatus.progress != '0') {
                                  state.table2.percentcompleted =
                                      state.contentstatus.progress;
                                }
                                state.table2.corelessonstatus =
                                    state.contentstatus.contentStatus;
                              });
                            } else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
//                  print('getcontentstatusvl ${state.contentstatus.name} ${state.contentstatus.progress} ${state.contentstatus.contentStatus}');

                          }
                          else if (state is ParentTrackGetContentStatusState) {
                            if (state.status == Status.COMPLETED) {
                              print(
                                  "Got Content Status for parent scoid:${state.table2.scoid}, content status:${state.contentstatus.contentStatus}, Progress:${state.contentstatus.progress}");

                              setState(() {
                                widget.myLearningModel.actualstatus =
                                    state.contentstatus.name;
                                widget.myLearningModel.corelessonstatus =
                                    state.contentstatus.contentStatus;
                                widget.myLearningModel.progress =
                                    state.contentstatus.progress;
                                if (state.contentstatus.progress != '0') {
                                  widget.myLearningModel.percentcompleted =
                                      state.contentstatus.progress;
                                  if (widget.myLearningModel.corelessonstatus ==
                                          "Completed" &&
                                      widget.myLearningModel.percentcompleted !=
                                          "100.00") {
                                    widget.myLearningModel.percentcompleted =
                                        "100.00";
                                    widget.myLearningModel.progress = "100.00";
                                  }
                                }
                              });
                            } else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
//                  print('getcontentstatusvl ${state.contentstatus.name} ${state.contentstatus.progress} ${state.contentstatus.contentStatus}');

                          }
                        },
                        builder: (context, state) {
                          if (state.status == Status.LOADING && state is GetTrackListState && isFirst) {
                            return _buildLoadingSpinner();
                          }
                          else if (state.status == Status.ERROR && state is GetTrackListState) {
                            return noDataFound(true);
                          }
                          else {
                            //This Code is to set parent progress on the basis of child completeness
                            //Ex. From 5 contents, 3 are completed and parent progress is lesser than that, so we will update
                            //parent progress to completed contents progress
                            //This is because even after completing content, main progress from api coming wrong untill we fetch
                            // catalog data in catalog or mylearning
                            int totalContent = eventTrackBloc.trackListData.length;
                            int completedContent = 0;
                            eventTrackBloc.trackListData.forEach((element) {
                              //print("Content Id:${element.contentid}, Content Name:${element.name}, Progress:'${element.corelessonstatus}'");
                              if (["Completed", "Completed (passed)"].contains(element.corelessonstatus)) {
                                completedContent++;
                              }
                            });
                            print("Total Contents:$totalContent, Completed Contents:$completedContent");
                            if (completedContent < totalContent) {
                              double completePer = 100 * (completedContent / totalContent);
                              double parentProgress = AppDirectory.isValidString(widget.myLearningModel.progress)
                                  ? (double.tryParse(widget.myLearningModel.progress) ??
                                      (double.tryParse(widget.myLearningModel.percentcompleted) ?? 0))
                                  : (double.tryParse(widget.myLearningModel.percentcompleted) ?? 0);

                              if (parentProgress < completePer) {
                                widget.myLearningModel.progress = completePer.toStringAsFixed(2);
                                widget.myLearningModel.percentcompleted = completePer.toStringAsFixed(2);
                              }
                            }

                            return _homeBody(
                              context: context,
                              itemWidth: itemWidth,
                              itemHeight: itemHeight,
                              body: getMainBody(eventTrackBloc, itemWidth, itemHeight),
                            );
                          }
                        },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getMainBody(EventTrackBloc eventTrackBloc, double itemWidth, double itemHeight) {
    if(eventTrackBloc.resEventTrackTabs.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: _myCourceList(),
      );
    }
    else {
      if(eventTrackBloc.trackBlockList.isNotEmpty) {

        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _expandableContent("Content"),
            ],
          ),
        );
      }
      else {
        if(eventTrackBloc.trackListData.isNotEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.h),
                  child: ResponsiveWidget(
                    mobile: ListView.builder(
                      shrinkWrap: true,
                      itemCount: eventTrackBloc.trackListData.length,
                      itemBuilder: (context, i) {
                        return Container(
                          child: widgetSessionsListItems(eventTrackBloc.trackListData[i], i),
                        );
                      },
                      controller: _sc,
                    ),
                    tab: GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery
                              .of(
                              context)
                              .size
                              .width /
                              (MediaQuery.of(
                                  context)
                                  .size
                                  .height /
                                  1.4),
                        ),
                        itemCount:
                        eventTrackBloc
                            .trackListData
                            .length,
                        itemBuilder:
                            (context, i) {
                          return Container(
                            child: widgetSessionsListItems(
                                eventTrackBloc
                                    .trackListData[i],
                                i),
                          );
                        },
                    ),
                    web: GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: MediaQuery
                                .of(
                                context)
                                .size
                                .width /
                                (MediaQuery.of(
                                    context)
                                    .size
                                    .height /
                                    1.4),
                          ),
                          itemCount:
                          eventTrackBloc
                              .trackListData
                              .length,
                          itemBuilder:
                              (context, i) {
                            return Container(
                              child: widgetSessionsListItems(
                                  eventTrackBloc
                                      .trackListData[i],
                                  i),
                            );
                          }),
                  ),
                ),
              ],
            ),
          );
        }
        else {
          return const SizedBox();
        }
      }
    }
  }

  Widget noDataFound(val) {
    return val
        ? Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            child: Center(
              child: Text(
                'No Data Found',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          )
        : Container();
  }

  Widget _homeBody({required BuildContext context, required double itemWidth, required double itemHeight, required Widget body}) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    //                  statusBar height   pinned SliverAppBar height in header
    pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return NestedScrollView(
      physics: const ClampingScrollPhysics(),
      headerSliverBuilder: (BuildContext c, bool f) {
        return buildSliverHeader2();
      },
      body: body,
    );
  }

  Widget _myCourceList() {
    return BlocConsumer<EventTrackBloc, EventTrackState>(
      bloc: eventTrackBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
          if (state.message == '401') {
            AppDirectory.sessionTimeOut(context);
          } else {
            // flutterToast.showToast(
            //     gravity: ToastGravity.BOTTOM,
            //     toastDuration: Duration(seconds: 2),
            //     child: CommonToast(displaymsg: 'Something went wrong'));
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && state is! TrackSetCompleteState && state is! ParentTrackGetContentStatusState) {
          return _buildLoadingSpinner();
        }
        else {
          if(!networkAvailable) {
            return _expandableContent('Tab1');
          }
          return Container(
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: Stack(
              children: <Widget>[
                _tabController != null
                    ? Container(
                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.getAppBGColor(),
                                  border: Border(bottom: BorderSide(color: AppColors.getNotificationCardBorderColor(), width: 1.5)),
                                ),
                                child: TabBar(
                                  isScrollable: eventTrackBloc.resEventTrackTabs.length > 3,
                                  controller: _tabController,
                                  indicatorColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: Colors.black,
                                  tabs: tabList,
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: eventTrackBloc.resEventTrackTabs.map((ResEventTrackTabs tab) {
                                    //print('keytabb ${tab.tabName}');
                                    return mytabs(tab);
                                  }).toList(),
                                ),
                              )
                            ]),
                      )
                    : Container(),
                (state.status == Status.LOADING && state is! ParentTrackGetContentStatusState)
                    ? _buildLoadingSpinner()
                    : Container()
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadingSpinner() {
    return Container(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
      child: Center(
        child: AbsorbPointer(
          child: SpinKitCircle(
            color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
            ),
            size: 70.h,
          ),
        ),
      ),
    );
  }

  Future<void> executeXAPICourse(DummyMyCatelogResponseTable2 learningModel) async {
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String paramsString = "strContentID=${learningModel.contentid}&UserID=$strUserID&SiteID=$strSiteID&SCOID=${learningModel.scoid}&CanTrack=true";

    String url = "${webApiUrl}CourseTracking/TrackLRSStatement?$paramsString";

    await generalRepository.executeXAPICourse(url);
  }

  //region course bottom sheet
  _settingMyCourseBottomSheet(
      context, DummyMyCatelogResponseTable2 table2, int i, String trackId,
      [String s = ""]) {
    print('bottomsheetobjit ${table2.objecttypeid}');

    MyLearningDownloadModel myLearningDownloadModel = MyLearningDownloadModel(
      contentId: "${widget.myLearningModel.contentid}_${table2.contentid}",
      table2: table2,
      isTrackContent: true,
      trackContentId: widget.myLearningModel.contentid,
      trackContentName: widget.myLearningModel.name,
    );

    MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(context, listen: false);
    List<MyLearningDownloadModel> downloads = myLearningDownloadProvider.downloads.where((element) => element.table2.contentid == table2.contentid).toList();
    if(downloads.isNotEmpty) {
      myLearningDownloadModel = downloads.first;
    }

    if (table2.objecttypeid == 70) {
      menu1 = false;
      menu2 = false;
      menu4 = false;
      menu5 = false;
      menu6 = false;

      String menu1Title = appBloc.localstr.eventsActionsheetEnrolloption;

      if (table2.isaddedtomylearning == 1) {
        menu1 = false;
        menu2 = false;
        menu4 = true;
      } else {
        if (table2.viewtype == 1) {
          menu2 = false;
          menu4 = false; //cancel enrollment
          if (AppDirectory.isValidString(table2.eventstartdatetime ?? "") &&
              !returnEventCompleted(table2.eventstartdatetime ?? "")) {
            if (AppDirectory.isValidString(table2.actionwaitlist) &&
                table2.actionwaitlist == "true") {
              menu1 = true;
              menu1Title = appBloc.localstr.eventsActionsheetWaitlistoption;
            } else {
              menu1 = true;
            }
          } else {
            if (appBloc.uiSettingModel.allowExpiredEventsSubscription ==
                "true") {
              menu1 = true;
            } else {
              // btnsLayout.setVisibility(View.GONE ;
              menu1 = true;
            }
          }
        } else if (table2.viewtype == 2) {
          menu1 = true;
          if (table2.eventscheduletype == 2) {
            menu1 = false;
          }
          if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true" &&
              returnEventCompleted(table2.eventenddatetime)) {
            menu1 = false;
          }
        } else if (table2.viewtype == 3) {
          menu1 = false;
          if (returnEventCompleted(table2.eventenddatetime) &&
              appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
            // uncomment here if required
            menu2 = true;
          }
        }
      }

      if (table2.isaddedtomylearning == 0 || table2.isaddedtomylearning == 2) {
        if (table2.iswishlistcontent == 1) {
          menu6 = true; //removeWishListed
        } else {
          menu5 = true; //isWishListed
        }
      }

      // expired event functionality
      if (AppDirectory.isValidString(table2.eventenddatetime ?? "") &&
          returnEventCompleted(table2.eventenddatetime ?? "")) {
        if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
          if (table2.isaddedtomylearning == 1) {
            if (table2.relatedconentcount != 0) {
              menu1 = false; //enroll
            }
          } else {
            if (table2.viewtype == 2) {
              menu1 = true; //enroll
            }
          }

//               menu0 =true ;//view

          menu2 = false; //buy
          menu4 = false; //cancel enrollment
        } else {
          menu2 = false; //buy
          menu1 = false; //enroll
          menu4 = false; //cancel enrollment
          menu5 = false; //isWishListed
          menu6 = false; //isWishListed

        }
      }

      showModalBottomSheet(
          backgroundColor: InsColor(appBloc).appBGColor,
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const BottomSheetDragger(),
                    menu1
                        ? ListTile(
                            title: Text(
                              menu1Title,
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                            ),
                            leading: Icon(
                              IconDataSolid(int.parse('0xf333')),
                              color: InsColor(appBloc).appIconColor,
                            ),
                          )
                        : Container(),
                    menu2
                        ? ListTile(
                            title: Text(
                                appBloc.localstr.eventsActionsheetBuynowoption,
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor)),
                            leading: Icon(
                              IconDataSolid(int.parse('0xf53d')),
                              color: InsColor(appBloc).appIconColor,
                            ),
                          )
                        : Container(),
                    menu4
                        ? ListTile(
                            onTap: () {
                              Navigator.of(context).pop();
                              if (table2.isbadcancellationenabled) {
                                badCancelEnrollmentMethod(table2);

                                // bad cancel
                              } else {
                                showCancelEnrollDialog(table2,
                                    table2.isbadcancellationenabled.toString());
                              }
                            },
                            title: Text(
                                appBloc.localstr
                                    .eventsActionsheetCancelenrollmentoption,
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor)),
                            leading: Icon(
                              IconDataSolid(int.parse('0xf410')),
                              color: InsColor(appBloc).appIconColor,
                            ),
                          )
                        : Container(),
                    menu5
                        ? ListTile(
                            title: Text(
                                appBloc
                                    .localstr.catalogActionsheetWishlistoption,
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor)),
                            leading: Icon(
                              IconDataSolid(int.parse('0xf004')),
                              color: InsColor(appBloc).appIconColor,
                            ),
                          )
                        : Container(),
                    menu6
                        ? ListTile(
                            title: Text(
                                appBloc.localstr
                                    .catalogActionsheetRemovefromwishlistoption,
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor)),
                            leading: Icon(
                              IconDataRegular(int.parse('0xf004')),
                              color: InsColor(appBloc).appIconColor,
                            ),
                          )
                        : Container(),

                    //sreekanth commented
                    // (table2?.ShareContentwithUser?.length ?? 0) > 0

                    // displaySendViaEmail(table2),
                  ],
                ),
              ),
            );
          });
    }
    else {
      showModalBottomSheet(
          backgroundColor: InsColor(appBloc).appBGColor,
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const BottomSheetDragger(),
                    displayPauseDownload(table2, myLearningDownloadModel),
                    /*displayResumeDownload(table2, myLearningDownloadModel),
                    displayCancelDownload(table2, myLearningDownloadModel),
                    displayRemoveFromDownload(table2, myLearningDownloadModel),*/

                    displayPlay(table2),
                    !AppDirectory.isValidString(s)
                        ? displayView(table2)
                        : Container(),
//                  displayDetails(table2),
                    displayJoin(table2),
                    // displayDownload(table2),
                    displayReport(table2, trackId, "${i + 1}"),
                    displayAddToCalendar(table2),
                    displaySetComplete(table2),
                    displayCancelEnrollemnt(table2),
                    displayDelete(myLearningDownloadModel, table2),
                    displayCertificate(table2),
                    displayQRCode(table2),
                    displayEventRecording(table2),
                  ],
                ),
              ),
            );
          });
    }
  }

  Widget displayPlay(DummyMyCatelogResponseTable2 table2) {
    if ([11, 14, 36, 28, 20, 21, 52].contains(table2.objecttypeid)) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return ListTile(
            leading: Icon(
              IconDataSolid(int.parse('0xf144')),
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(appBloc.localstr.mylearningActionsheetPlayoption,
                style: TextStyle(color: InsColor(appBloc).appTextColor)),
            onTap: () {
              Navigator.of(context).pop();

              if (AppDirectory.isValidString(
                  table2.viewprerequisitecontentstatus ?? "")) {
                String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
                alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(
                            appBloc.localstr.detailsAlerttitleStringalert,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(alertMessage),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          actions: <Widget>[
                            TextButton(
                              style: textButtonStyle,
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                  appBloc.localstr.eventsAlertbuttonOkbutton),
                            ),
                          ],
                        ));
              } else {
                launchCourse(table2, context, false);
              }
            });
      }
    }

    return Container();
  }

  Widget displayView(DummyMyCatelogResponseTable2 table2) {
    if ([11, 14, 36, 28, 20, 21, 52].contains(table2.objecttypeid)) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return Container();
      } else {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf06e')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetViewoption,
              style: TextStyle(color: InsColor(appBloc).appTextColor)),
          onTap: () {
            Navigator.of(context).pop();

            if (AppDirectory.isValidString(
                table2.viewprerequisitecontentstatus ?? "")) {
              String alertMessage =
                  appBloc.localstr.prerequistesalerttitle6Alerttitle6;
              alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          appBloc.localstr.detailsAlerttitleStringalert,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(alertMessage),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        actions: <Widget>[
                          TextButton(
                            style: textButtonStyle,
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                                appBloc.localstr.eventsAlertbuttonOkbutton),
                          ),
                        ],
                      ));
            } else {
              launchCourse(table2, context, false);
            }
          },
        );
      }
    } else if ([688, 70].contains(table2.objecttypeid)) {
      return Container();
    } else {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf06e')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text(appBloc.localstr.mylearningActionsheetViewoption,
            style: TextStyle(color: InsColor(appBloc).appTextColor)),
        onTap: () {
          Navigator.of(context).pop();

          if (AppDirectory.isValidString(
              table2.viewprerequisitecontentstatus ?? "")) {
            String alertMessage =
                appBloc.localstr.prerequistesalerttitle6Alerttitle6;
            alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        appBloc.localstr.detailsAlerttitleStringalert,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(alertMessage),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      actions: <Widget>[
                        TextButton(
                          style: textButtonStyle,
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child:
                              Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                        ),
                      ],
                    ));
          } else {
            launchCourse(table2, context, false);
          }
        },
      );
    }
  }

  Widget displayJoin(DummyMyCatelogResponseTable2 table2) {
    bool isStringValid =
        AppDirectory.isValidString(table2.eventenddatetime ?? "");
    bool isEventCompleted =
        !returnEventCompleted(table2.eventenddatetime ?? "");
    if (table2.objecttypeid == 70 &&
        isStringValid &&
        isEventCompleted &&
        table2.typeofevent == 2) {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf234')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text(appBloc.localstr.mylearningActionsheetJoinoption,
            style: TextStyle(color: InsColor(appBloc).appTextColor)),
        onTap: () {
          Navigator.pop(context);
          String joinUrl = table2.joinurl;

          if (joinUrl != null && joinUrl.length > 0) {
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
    }
    return Container();
  }

  Widget displayReport(
      DummyMyCatelogResponseTable2 table2, String trackId, String postion) {
    if ([11, 14, 36, 28, 20, 21, 52, 70, 688, 27]
        .contains(table2.objecttypeid)) {
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
            color: Colors.grey,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetReportoption,
              style: TextStyle(color: InsColor(appBloc).appTextColor)),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProgressReport(table2, detailsBloc, trackId, postion)));
          });
    }
  }

  Widget displayAddToCalendar(DummyMyCatelogResponseTable2 table2) {
    bool isStringValid =
        AppDirectory.isValidString(table2.eventenddatetime ?? "");
    bool isEventCompleted =
        !returnEventCompleted(table2.eventenddatetime ?? "");
    if (table2.objecttypeid == 70 && isStringValid && isEventCompleted) {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf271')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text(
            appBloc.localstr.mylearningActionsheetAddtocalendaroption,
            style: TextStyle(color: InsColor(appBloc).appTextColor)),
        onTap: () {
          addToCal(table2);
        },
      );
      // if (table2.eventscheduletype == 1 &&
      //     appBloc.uiSettingModel.EnableMultipleInstancesforEvent == 'true') {
      //   return Container();
      // }
    }

    return Container();
  }

  Widget displaySetComplete(DummyMyCatelogResponseTable2 table2) {
    bool isObjTypeValid =
        AppDirectory.isValidString(table2.objecttypeid.toString());
    bool isStatusValid = AppDirectory.isValidString(table2.corelessonstatus);
    bool notCompleted = table2.corelessonstatus.toLowerCase() != 'completed';
    if (isObjTypeValid &&
        [11, 14, 36, 28, 20, 21, 52].contains(table2.objecttypeid) &&
        isStatusValid &&
        notCompleted) {
      return ListTile(
          leading: SvgPicture.asset(
            'assets/SetComplete.svg',
            width: 25.h,
            height: 25.h,
            color: Colors.grey,
          ),
          title: Text(
              appBloc.localstr.mylearningActionsheetSetcompleteoption,
              style: TextStyle(color: InsColor(appBloc).appTextColor)),
          onTap: () {
            Navigator.pop(context);
            eventTrackBloc.add(TrackSetComplete(
                contentId: table2.contentid,
                scoId: table2.scoid.toString(),
                table2: table2));
          });
    }
    return Container();
  }

  Widget displayCancelEnrollemnt(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
      // returnEventCompleted
      if (AppDirectory.isValidString(table2.eventstartdatetime ?? "")) {
        if (!returnEventCompleted(table2.eventstartdatetime ?? "")) {
          if (table2.bit2 != null && table2.bit2) {
            return ListTile(
                leading: Icon(
                  IconDataSolid(int.parse('0xf410')),
                  color: InsColor(appBloc).appIconColor,
                ),
                title: Text(
                    appBloc
                        .localstr.mylearningActionsheetCancelenrollmentoption,
                    style: TextStyle(color: InsColor(appBloc).appTextColor)),
                onTap: () {
                  checkCancellation(table2, context);
                });
          }
// for schedule events
          if (table2.eventscheduletype == 1 &&
              appBloc.uiSettingModel.enableMultipleInstancesForEvent ==
                  'true') {
            return ListTile(
//                  leading: new Icon(Icons.people),
                title: Text(appBloc
                    .localstr.mylearningActionsheetCancelenrollmentoption),
                onTap: () {
                  checkCancellation(table2, context);
                });
          }
        }
      }
    }

    return Container();
  }

  Widget displayDelete(MyLearningDownloadModel myLearningDownloadModel, DummyMyCatelogResponseTable2 table2) {
    //downloadPath(table2.contentid, table2);

    if (table2.isdownloaded && table2.objecttypeid != 70) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf1f8')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetDeleteoption,
              style: TextStyle(color: InsColor(appBloc).appTextColor)),

          /// TODO : Sagar sir - delete offline file
          onTap: () async {
            Navigator.pop(context);

            bool fileDel = await eventTrackBloc.deleteFile(downloadDestFolderPath);

            await MyLearningDownloadController().removeFromDownload(myLearningDownloadModel);

            print('filedeleted $downloadDestFolderPath ${table2.contentid}');
            if (fileDel) {
              setState(() {
                isDownloaded = false;
                isDownloading = false;
                downloadedProgess = 0;
                table2.isdownloaded = false;
                table2.isDownloading = false;
              });
            }
          });
    }

    return Container();
  }

  Widget displayCertificate(DummyMyCatelogResponseTable2 table2) {
    if (AppDirectory.isValidString(table2.certificateaction)) {
      return ListTile(
          leading: SvgPicture.asset(
            'assets/Certificate.svg',
            width: 25.h,
            height: 25.h,
            color: Colors.grey,
          ),
          title: Text(
              appBloc.localstr.mylearningActionsheetViewcertificateoption,
              style: TextStyle(color: InsColor(appBloc).appTextColor)),
          onTap: () {
            if (detailsBloc.myLearningDetailsModel.certificateAction ==
                'notearned') {
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
                        content: Text(appBloc.localstr
                            .mylearningAlertsubtitleForviewcertificate),
                        backgroundColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        actions: <Widget>[
                          TextButton(
                            style: textButtonStyle,
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: Text(appBloc.localstr
                                .mylearningClosebuttonactionClosebuttonalerttitle),
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
      if (AppDirectory.isValidString(table2.qrimagename ?? "") &&
          AppDirectory.isValidString(table2.qrcodeimagepath ?? "") &&
          !table2.bit4) {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf029')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetViewqrcode,
              style: TextStyle(color: InsColor(appBloc).appTextColor)),
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QrCodeScreen(table2.qrimagename)))
          },
        );
      }
    }

    return Container();
  }

  Widget displayEventRecording(DummyMyCatelogResponseTable2 table2) {
    if (AppDirectory.isValidString(table2.eventrecording.toString()) &&
        table2.eventrecording) {
      if (detailsBloc.myLearningDetailsModel.addedToMyLearning == 1 ||
          typeFrom == "event" ||
          typeFrom == "track") {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf8d9')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.learningtrackLabelEventviewrecording,
              style: TextStyle(color: InsColor(appBloc).appTextColor)),
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

  //endregion course bottom sheet

  //region My Downloads Bottomsheet
  Widget displayPauseDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading || !downloadModel.table2.isDownloading) {
      return const SizedBox();
    }

    return ListTile(
      leading: Icon(
        Icons.pause,
        color: InsColor(appBloc).appIconColor,
      ),
      title: Text(
        "Pause Download",
        style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            )),
      ),
      onTap: () async {
        Navigator.of(context).pop();

        onDownloading(downloadModel);
      },
    );
  }

  Widget displayResumeDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading || downloadModel.table2.isDownloading) {
      return const SizedBox();
    }

    return ListTile(
      leading: Icon(
        Icons.play_arrow,
        color: InsColor(appBloc).appIconColor,
      ),
      title: Text(
        "Resume Download",
        style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            )),
      ),
      onTap: () async {
        Navigator.of(context).pop();

        onDownloadPaused(downloadModel);
      },
    );
  }

  Widget displayCancelDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading) {
      return const SizedBox();
    }

    return ListTile(
      leading: Icon(
        Icons.delete,
        color: InsColor(appBloc).appIconColor,
      ),
      title: Text(
        "Cancel Download",
        style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            )),
      ),
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
      return const SizedBox();
    }

    return ListTile(
      leading: Icon(
        Icons.delete,
        color: InsColor(appBloc).appIconColor,
      ),
      title: Text(
        "Remove from Downloads",
        style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            )),
      ),
      onTap: () async {
        MyPrint.printOnConsole('Cancel Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        await MyLearningDownloadController().removeFromDownload(downloadModel);
        setState(() {});
      },
    );
  }
  //endregion My Downloads Bottomsheet

  /*
  unused code
  Widget displaySendViaEmail(DummyMyCatelogResponseTable2 table2) {
    // if ((table2?.ShareContentwithUser?.length ?? 0) > 0) {
    if (privilegeCreateForumIdExists()) {
      if (table2.objecttypeid == 14) {
        return new ListTile(
          leading: Icon(
            Icons.email,
            //IconDataSolid(int.parse('0xf06e')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: new Text(
              appBloc.localstr.mylearningsendviaemailnewoption == null
                  ? 'Share via Email'
                  : appBloc.localstr.mylearningsendviaemailnewoption,
              style: TextStyle(
                  color: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(
                            1, 7).toUpperCase()}"),
                  ))),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SendviaEmailMylearning(
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

  bool privilegeCreateForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 1349) {
        return true;
      }
    }
    return false;
  }

  Widget displayArchive(DummyMyCatelogResponseTable2 table2) {
    if (!detailsBloc.myLearningDetailsModel.isArchived) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf187')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: new Text(appBloc.localstr.mylearningActionsheetArchiveoption),
          onTap: () {
            eventTrackBloc.add(TrackAddtoArchiveCall(
                isArchive: true, strContentID: table2.contentid));
            Navigator.pop(context);
          });
    } else {
      return Container();
    }
  }

  Widget displayUnArachive(DummyMyCatelogResponseTable2 table2) {
    if (detailsBloc.myLearningDetailsModel.isArchived) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf187')),
            color: InsColor(appBloc).appIconColor,
          ),
          title:
          new Text(appBloc.localstr.mylearningActionsheetUnarchiveoption),
          onTap: () {
            eventTrackBloc.add(TrackRemovetoArchiveCall(
                isArchive: false, strContentID: table2.contentid));
            Navigator.pop(context);
          });
    } else {
      return Container();
    }
  }

  Widget displayRemove(DummyMyCatelogResponseTable2 table2) {
    if ((table2.objecttypeid == 70 && table2.bit4 != null && table2.bit4) ||
        (table2.removelink != null && table2.removelink)) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf056')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: new Text(
              appBloc.localstr.mylearningActionsheetRemovefrommylearning),
          onTap: () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                new AlertDialog(
                  title: Text(
                    appBloc.localstr.mylearningAlerttitleStringareyousure,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(appBloc.localstr
                      .mylearningAlertsubtitleRemovethecontentitem),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5)),
                  actions: <Widget>[
                    new TextButton(
                      child: Text(
                          appBloc.localstr.mylearningAlertbuttonYesbutton),
                      style: textButtonStyle,
                      onPressed: () async {
                        Navigator.of(context).pop();

                        setState(() {
                          eventTrackBloc.add(TrackRemoveFromMyLearning(
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

  Widget displayReschedule(DummyMyCatelogResponseTable2 table2) {
    if (AppDirectory.isValidString(table2.reschduleparentid ?? "")) {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf783')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: new Text(
            appBloc.localstr.mylearningActionbuttonRescheduleactionbutton),

        // TODO : Sprint -3
      );
    }

    return Container();
  }
  */

  void checkCancellation(
      DummyMyCatelogResponseTable2 table2, BuildContext context) {
    if (table2.isbadcancellationenabled) {
//                mylearningInterface.badCancelEnrollment(true);
      // bad cancel
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                  appBloc.localstr.mylearningAlerttitleStringareyousure,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(appBloc.localstr
                    .mylearningAlertsubtitleDoyouwanttocancelenrolledevent),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                actions: <Widget>[
                  TextButton(
                    style: textButtonStyle,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                        appBloc.localstr.mylearningAlertbuttonCancelbutton),
                  ),
                  TextButton(
                    style: textButtonStyle,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      myLearningBloc.add(CancelEnrollment(
                          isBadCancel: table2.isbadcancellationenabled,
                          strContentID: table2.contentid));
//                  mylearningInterface.cancelEnrollment(true);
                    },
                    child:
                        Text(appBloc.localstr.mylearningAlertbuttonYesbutton),
                  ),
                ],
              ));
    }
  }

  /*
  unused code
  Widget displayRelatedContent(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
      if (table2.relatedconentcount != null && table2.relatedconentcount > 0) {
        return ListTile(
            leading: Icon(
              IconDataSolid(int.parse('0xf4f2')),
              color: InsColor(appBloc).appIconColor,
            ),
            title: new Text(
                appBloc.localstr.mylearningActionsheetSetcompleteoption,
                style: TextStyle(color: InsColor(appBloc).appTextColor)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RelatedContent()));
            });
      }
    }

    return Container();
  }
  */

  bool returnEventCompleted(String eventDate) {
    bool isCompleted = false;

    DateTime? fromDate;
    var difference;

    if (!AppDirectory.isValidString(eventDate)) return false;

    try {
      fromDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(eventDate);

      final date2 = DateTime.now();
      difference = date2.difference(fromDate).inDays;
    } catch (e) {
      //e.printStackTrace();
      isCompleted = false;
    }
    if (fromDate == null) return false;

    if (difference != null && difference < 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }

    return isCompleted;
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*
  unused code
  Widget displayDetails(DummyMyCatelogResponseTable2 table2) {
    if (typeFrom == "event" || typeFrom == "track") {
      return Container();
    }

    if (table2.objecttypeid == 70 && (table2.bit4 != null && table2.bit4)) {
      return Container();
    }
    return new ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf570')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: new Text(appBloc.localstr.mylearningActionsheetDetailsoption),
        onTap: () {
          Navigator.pop(context);

          detailsBloc.myLearningDetailsModel
              .setIsEnrollFutureInstance(table2.isenrollfutureinstance);
          detailsBloc.myLearningDetailsModel.setprogress(table2.progress);
          detailsBloc.myLearningDetailsModel
              .setPercentageCompleted(table2.percentcompleted);
          detailsBloc.myLearningDetailsModel
              .setCertificateAction(table2.certificateaction);
          detailsBloc.myLearningDetailsModel
              .setCertificateId(table2.certificateid);
          detailsBloc.myLearningDetailsModel
              .setCertificatePage(table2.certificatepage);
          detailsBloc.myLearningDetailsModel
              .seteventStartDateTime(table2.eventstartdatetime);
          detailsBloc.myLearningDetailsModel
              .seteventScheduleType(table2.eventscheduletype);
          detailsBloc.myLearningDetailsModel
              .setIscancelEventEnabled(table2.isbadcancellationenabled);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CommonDetailScreen(
                      screenType: ScreenType.MyLearning,
                      contentid: table2.contentid,
                      objtypeId: table2.objecttypeid,
                      detailsBloc: detailsBloc,
                      table2: table2,
                      isFromReschedule: false)));
        });
  }
   */

  /*void downloadPath(String contentid, DummyMyCatelogResponseTable2 table2) async {
    if (downloadDestFolderPath.isNotEmpty) return;
    String path =
        await eventTrackBloc.generateDownloadPath(contentid, table2, appBloc);

    bool result = await eventTrackBloc.checkFile(path);
    setState(() {
      downloadDestFolderPath = path;
      fileExists = result;
      table2.isdownloaded = result;
    });
  }*/

  /*
  unused code
  Widget displayDownload(DummyMyCatelogResponseTable2 table2) {
    print('obttypeid ${table2.objecttypeid}  ${table2.isdownloaded}');
    downloadPath(table2.contentid, table2);

    if ((table2.objecttypeid == 10 && table2.bit5 != null && table2.bit5) ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 688 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 27 ||
        table2.objecttypeid == 70) {
      return Container();
    } else if (table2.isdownloaded && table2.objecttypeid != 70) {
      return Container();
    } else {
      return new ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf019')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: new Text(appBloc.localstr.mylearningActionsheetDownloadoption,
            style: TextStyle(color: InsColor(appBloc).appTextColor)),

        /// TODO - sagar sir

        onTap: () async {
          Navigator.pop(context);

          if (!table2.isdownloaded) {
            setState(() {
              isDownloaded = false;
              isDownloading = true;
              downloadedProgess = 0;
            });
            PermissionStatus permission = await Permission.storage.status;

            if (permission != PermissionStatus.granted) {
              await Permission.storage.request();
              PermissionStatus permission = await Permission.storage.status;
              if (permission == PermissionStatus.granted) {
                /// Permission Granted
                setState(() {
                  downloadCourse = DownloadCourse(
                      context,
                      table2,
                      false,
                      appBloc.uiSettingModel,
                      0,
                      streamController,
                      doSomething);

                  downloadCourse?.downloadTheCourse();
                });
              } else {
                /// Notify User
              }
            } else {
              setState(() {
                downloadCourse = DownloadCourse(
                    context,
                    table2,
                    false,
                    appBloc.uiSettingModel,
                    0,
                    streamController,
                    doSomething);

                downloadCourse?.downloadTheCourse();
              });
            }
          }
        },
      );
    }
  }
   */

  void doSomething(int i, DummyMyCatelogResponseTable2 table2, int progress) {
    /* ... */
    print('dosomethingofdata $progress');

    try {
      if (i != null) {
        if (progress == -1) {
          setState(() {
            table2.isdownloaded = false;
            table2.isDownloading = false;
            downloadedProgess = progress;
          });

          flutterToast.showToast(
            child: CommonToast(displaymsg: 'Error while downloading'),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 2),
          );
        } else if (progress == 100) {
          setState(() {
            table2.isdownloaded = true;
            table2.isDownloading = false;

            flutterToast.showToast(
              child: CommonToast(displaymsg: 'Downloaded Successfully'),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );

            //sreekanth commented

            // if (appBloc.uiSettingModel.AutocompleteDocumentionDownload
            //         .toLowerCase() ==
            //     true) {
            //   eventTrackBloc.add(DownloadCompleteEvent(
            //       contentId: table2.contentid, ScoID: table2.scoid));
            // }
          });
        } else {
          setState(() {
//        myLearningBloc.list[i].isdownloaded = true;
            downloadedProgess = progress;
            table2.isDownloading = true;
          });
        }
      }

      print(
          'downloadedprog ${table2.isDownloading} ${table2.isdownloaded} $downloadedProgess');
    } catch (e) {
      setState(() {
        table2.isdownloaded = false;
        table2.isDownloading = false;
      });
    }
  }

  Widget _myList(String tabName) {
    return Stack(
      children: <Widget>[
        eventTrackBloc.glossaryExpandable.isNotEmpty
            ? ResponsiveWidget(
                mobile: ListView.builder(
//                key: const PageStorageKey<String>('Tab5'),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: eventTrackBloc.glossaryExpandable.length,
                    itemBuilder: (context, i) => Container(
                          child: getTabList(
                              tabName, i, eventTrackBloc.glossaryExpandable[i]),
                        )),
                tab: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.4),
                    ),
                    itemCount: eventTrackBloc.glossaryExpandable.length,
                    itemBuilder: (context, i) => Container(
                          child: getTabList(
                              tabName, i, eventTrackBloc.glossaryExpandable[i]),
                        )),
                web: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.4),
                    ),
                    itemCount: eventTrackBloc.glossaryExpandable.length,
                    itemBuilder: (context, i) => Container(
                      child: getTabList(
                          tabName, i, eventTrackBloc.glossaryExpandable[i]),
                    )),
              )
            : noDataFound(true)
      ],
    );
  }

  Widget getTabList(String tabName, int position, GlossaryExpandable glossaryExpandable) {
    return widgetGlosaryListItems(position, glossaryExpandable);
  }

  Widget widgetSessionsListItems(DummyMyCatelogResponseTable2 data, int i) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    Color statuscolor = const Color(0xff5750da);
    Color statusBarColor = Colors.grey;

    String thumbnailImg = "";

    if (data.thumbnailimagepath.isNotEmpty) {
      if (data.thumbnailimagepath.startsWith('http') ||
          data.thumbnailimagepath.startsWith('https')) {
        thumbnailImg = data.thumbnailimagepath;
      } else {
        thumbnailImg = '${ApiEndpoints.strSiteUrl}${data.thumbnailimagepath}';
      }
    }

    thumbnailImg = widget.myLearningModel.objecttypeid == 70
        ? data.imageData.toLowerCase()
        : thumbnailImg;

    if (data.progress == "100") {
      if (!["Completed", "Completed (passed)"]
          .contains(data.corelessonstatus)) {
        data.corelessonstatus = "Completed";
      }
    }

    if (["Completed", "Completed (passed)"]
        .contains(data.corelessonstatus.toString())) {
      statuscolor = const Color(0xff4ad963);
      statusBarColor = const Color(0xff4ad963);
    } else if (data.corelessonstatus.toString() == "Not Started") {
      statuscolor = const Color(0xfffe2c53);
      statusBarColor = Colors.grey;
    } else if (data.corelessonstatus.toString() == "In Progress") {
      statuscolor = const Color(0xffff9503);
      statusBarColor = const Color(0xffff9503);
    }
    String contentIconPath = data.iconpath;

    if (AppDirectory.isValidString(appBloc.uiSettingModel.azureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? data.iconpath
          : appBloc.uiSettingModel.azureRootPath + data.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    } else {
      contentIconPath = '${ApiEndpoints.strSiteUrl}$contentIconPath';
    }

    MyLearningDownloadModel? downloadModel;
    MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    List<MyLearningDownloadModel> downloads = myLearningDownloadProvider.downloads.where((element) => element.table2.contentid == data.contentid).toList();
    //MyPrint.printOnConsole("Downloads Length:${downloads.length}");
    if(downloads.isNotEmpty) {
      downloadModel = downloads.first;
    }

    return MyLearningComponentCard(
      table2: data,
      isArchive: false,
      trackContentId: widget.myLearningModel.contentid,
      trackContentName: widget.myLearningModel.name,
      isShowLock: true,
      isTrackContent: true,
      onMoreTap: () => _onMoreTap(data, i),
      onArchievedTap: () => _onArchivedTap(data),
      onReviewTap: () => _onReviewTap(data),
      onViewTap: () => _onViewTap(data),
      onNotDownloaded: () => _onDownloadTap(data),
      onDownloadPaused: () {
        onDownloadPaused(downloadModel);
      },
      onDownloading: () {
        onDownloading(downloadModel);
      },
      onDownloaded: () async {
        MyPrint.printOnConsole("onDownloaded called");
      },
    );

    /*
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(kCellThumbHeight),
                    child: InkWell(
                      onTap: () {
                        launchCourse(data, context, false);
                      },
                      child: CachedNetworkImage(
                        imageUrl: thumbnailImg,
                        width: MediaQuery.of(context).size.width,
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        placeholder: (context, url) => Container(
                            color: Colors.grey.withOpacity(0.5),
                            child: Center(
                                heightFactor: ScreenUtil().setWidth(20),
                                widthFactor: ScreenUtil().setWidth(20),
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.orange),
                                ))),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
                        fit: BoxFit.cover,
                      ),
                    ),

                    /*child: Image.network(
                      "https://qa.instancy.com"+table2.thumbnailimagepath,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),*/

                    /*decoration: new BoxDecoration(

                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.darken),
                          image: AssetImage(
                            "https://qa.instancy.com"+table2.thumbnailimagepath,
                          ),
                        )
                    ),*/
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
                          data.corelessonstatus,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(10),
                              color: Colors.white),
                        ),
                      )),
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
                            ))),
                  ))
                ],
              ),
              // LinearProgressIndicator(
              //   value: data.progress == null
              //       ? 0.0
              //       : double.parse(data.progress) / 100,
              //   valueColor: AlwaysStoppedAnimation<Color>(statusBarColor),
              //   backgroundColor: Colors.grey,
              // ),
              LinearProgressIndicator(
                value: AppDirectory.isValidString(data.progress)
                    ? double.parse(data.progress) / 100
                    : 0.0,
                valueColor: AlwaysStoppedAnimation<Color>(statuscolor),
                backgroundColor: Colors.grey,
              ),

              Container(
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
                                data.medianame,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              InkWell(
                                onTap: () {
                                  launchCourse(data, context, false);
                                },
                                child: Text(
                                  data.name,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(15),
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //createParentUrl(widget.myLearningModel);
                            _settingMyCourseBottomSheet(context, data, i,
                                widget.myLearningModel.contentid);
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: InsColor(appBloc).appIconColor,
                          ),

                          /*PopupMenuButton<String>(
                          // onSelected: handleClick,
                          itemBuilder: (BuildContext context) {
                            return {'Progress Report', 'Delete'}
                                .map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: GestureDetector(
                                  onTap: (){

                                  },
                                    child: Text(choice)),
                              );
                            }).toList();
                          },
                        ),*/
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Row(
                      children: <Widget>[
                        new Container(
                            width: ScreenUtil().setWidth(20),
                            height: ScreenUtil().setWidth(20),
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(imgUrl)))),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        Text(
                          data.author,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                  .withOpacity(0.5)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                    Text(
                      data.shortdescription,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(13),
                          color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                              .withOpacity(0.5)),
                    ),
                    (data.isDownloading != null && data.isDownloading)
                        ? LinearProgressIndicator(
                            value: downloadedProgess.toDouble() / 100,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                            backgroundColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          )
                        : Container(),
//
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    */
  }

  Widget widgetResourceListItems(int position, ReferenceItem refItem) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter

    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(10), right: 10.h, left: 10.h),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      navigateUrl(refItem);
                    },
                    child: (refItem.type == 'Document' &&
                            refItem.path.contains('pdf'))
                        ? Icon(
                            Icons.picture_as_pdf,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                            size: ScreenUtil().setHeight(60.h),
                          )
                        : refItem.type == 'Media resource'
                            ? Icon(
                                Icons.video_library,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                size: ScreenUtil().setHeight(60.h),
                              )
                            : Icon(
                                Icons.insert_drive_file,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                size: ScreenUtil().setHeight(60.h),
                              ),
                  ),
                ),
                Flexible(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.h),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            navigateUrl(refItem);
                          },
                          child: Text(
                            refItem.title,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          refItem.type,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          refItem.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
//                      Html(data: refItem.description)
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: refItem.type.toLowerCase() != 'url'
                      ? InkWell(
                          onTap: () async {
                            try {
                              PermissionStatus permission =
                                  await Permission.storage.status;

                              if (permission != PermissionStatus.granted) {
                                await Permission.storage.request();
                                PermissionStatus permission =
                                    await Permission.storage.status;
                                if (permission == PermissionStatus.granted) {
                                  /// Permission Granted
                                  ///
                                  ///
                                  downloadRes(refItem, position);
                                } else {
                                  /// Notify User

                                }
                              } else {
                                downloadRes(refItem, position);
                              }
                            } on Exception {
                              print('Could not get the downloads directory');
                            }
                          },
                          child: refItem.isDownloading
                              ? Text('$_downloadProgress %')
                              : Icon(
                                  Icons.cloud_download,
                                  size: 25.h,
                                ),
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.h),
              child: const Divider(),
            )
//              Stack(
//                children: <Widget>[
//                  Container(
//                    height: ScreenUtil().setHeight(100),
//                    child: CachedNetworkImage(
//                      imageUrl: imgUrl,
//                      width: MediaQuery.of(context).size.width,
//                      //placeholder: (context, url) => CircularProgressIndicator(),
//                      placeholder: (context, url) => Container(
//                          color: InsColor(appBloc).appIconColor.withOpacity(0.5),
//                          child: Center(
//                              heightFactor: ScreenUtil().setWidth(20),
//                              widthFactor: ScreenUtil().setWidth(20),
//                              child: CircularProgressIndicator(
//                                valueColor: new AlwaysStoppedAnimation<Color>(
//                                    Colors.orange),
//                              ))),
//                      errorWidget: (context, url, error) => Icon(Icons.error),
//                      fit: BoxFit.fill,
//                    ),
//
//                    /*child: Image.network(
//                      "https://qa.instancy.com"+table2.thumbnailimagepath,
//                      width: MediaQuery.of(context).size.width,
//                      fit: BoxFit.fill,
//                    ),*/
//
//                    /*decoration: new BoxDecoration(
//
//                        image: new DecorationImage(
//                          fit: BoxFit.fill,
//                          colorFilter: ColorFilter.mode(
//                              Colors.black.withOpacity(0.4), BlendMode.darken),
//                          image: AssetImage(
//                            "https://qa.instancy.com"+table2.thumbnailimagepath,
//                          ),
//                        )
//                    ),*/
//                  ),
//                  Positioned.fill(
//                    child: Align(
//                        alignment: Alignment.center,
//                        child: Container(
//                          child: Icon(
//                            Icons.picture_as_pdf,
//                            color: Colors.white,
//                            size: ScreenUtil().setHeight(30),
//                          ),
//                        )),
//                  ),
//                  Positioned(
//                      top: 15,
//                      left: 15,
//                      child: Container(
//                        decoration: BoxDecoration(
//                          color: Colors.orange,
//                          borderRadius: BorderRadius.circular(20),
//                        ),
//                        padding: EdgeInsets.only(
//                            top: ScreenUtil().setWidth(5),
//                            bottom: ScreenUtil().setWidth(5),
//                            left: ScreenUtil().setWidth(10),
//                            right: ScreenUtil().setWidth(10)),
//                        child: Text(
//                          "in Progress",
//                          style: TextStyle(
//                              fontSize: ScreenUtil().setSp(10),
//                              color: Colors.white),
//                        ),
//                      )),
//                ],
//              ),
//              LinearProgressIndicator(
//                value: 80,
//                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//                backgroundColor: Colors.grey,
//              ),
//              Container(
//                padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Expanded(
//                          flex: 1,
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                "ClassRoom",
//                                style: TextStyle(
//                                    fontSize: ScreenUtil().setSp(14),
//                                    color: Colors.black),
//                              ),
//                              SizedBox(
//                                height: ScreenUtil().setHeight(10),
//                              ),
//                              Text(
//                                "Office ergonomics review and observation",
//                                style: TextStyle(
//                                    fontSize: ScreenUtil().setSp(15),
//                                    color: Colors.black),
//                              ),
//                            ],
//                          ),
//                        ),
//                        GestureDetector(
//                          onTap: () {},
//                          child: Icon(
//                            Icons.more_vert,
//                            color: Colors.grey,
//                          ),
//                        ),
//
//                        /*PopupMenuButton<String>(
//                          // onSelected: handleClick,
//                          itemBuilder: (BuildContext context) {
//                            return {'Progress Report', 'Delete'}
//                                .map((String choice) {
//                              return PopupMenuItem<String>(
//                                value: choice,
//                                child: GestureDetector(
//                                  onTap: (){
//
//                                  },
//                                    child: Text(choice)),
//                              );
//                            }).toList();
//                          },
//                        ),*/
//                      ],
//                    ),
//                    SizedBox(
//                      height: ScreenUtil().setHeight(10),
//                    ),
//                    Row(
//                      children: <Widget>[
//                        new Container(
//                            width: ScreenUtil().setWidth(20),
//                            height: ScreenUtil().setWidth(20),
//                            decoration: new BoxDecoration(
//                                shape: BoxShape.circle,
//                                image: new DecorationImage(
//                                    fit: BoxFit.fill,
//                                    image: new NetworkImage(imgUrl)))),
//                        SizedBox(
//                          width: ScreenUtil().setWidth(5),
//                        ),
//                        Text(
//                          "Henk Fortuin, Tony Finny",
//                          style: TextStyle(
//                              fontSize: ScreenUtil().setSp(13),
//                              color: Colors.black.withOpacity(0.5)),
//                        ),
//                      ],
//                    ),
//                    SizedBox(
//                      height: ScreenUtil().setHeight(3),
//                    ),
//                    Row(
//                      children: <Widget>[
//                        SmoothStarRating(
//                            allowHalfRating: false,
//                            onRated: (v) {},
//                            starCount: 5,
//                            rating: 3,
//                            size: ScreenUtil().setHeight(20),
//                            isReadOnly: true,
//                            // filledIconData: Icons.blur_off,
//                            // halfFilledIconData: Icons.blur_on,
//                            color: Colors.orange,
//                            borderColor: Colors.orange,
//                            spacing: 0.0),
//                        SizedBox(
//                          width: ScreenUtil().setWidth(10),
//                        ),
//                        Expanded(
//                          child: Text(
//                            "See Reviews".toUpperCase(),
//                            style: TextStyle(
//                                fontSize: ScreenUtil().setSp(12),
//                                color: Colors.blue),
//                          ),
//                        ),
//                      ],
//                    ),
//                    SizedBox(
//                      height: ScreenUtil().setHeight(10),
//                    ),
//                    Text(
//                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                      style: TextStyle(
//                          fontSize: ScreenUtil().setSp(14),
//                          color: Colors.black.withOpacity(0.5)),
//                    ),
//                    SizedBox(
//                      height: ScreenUtil().setHeight(10),
//                    ),
//                    Row(
//                      children: <Widget>[
//                        Expanded(
//                            child: FlatButton.icon(
//                          color: Color(int.parse(
//                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                          icon: Icon(
//                            Icons.cloud_download,
//                            color: Colors.white,
//                            size: 25,
//                          ),
//                          label: Text(
//                            "Download".toUpperCase(),
//                            style: TextStyle(
//                                fontSize: ScreenUtil().setSp(14),
//                                color: Colors.white),
//                          ),
//                          onPressed: () {},
//                        )),
//                        SizedBox(
//                          width: ScreenUtil().setWidth(10),
//                        ),
//                        Expanded(
//                            child: FlatButton.icon(
//                          color: Color(int.parse(
//                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                          icon: Icon(
//                            Icons.remove_red_eye,
//                            color: Colors.white,
//                            size: 25,
//                          ),
//                          label: Text(
//                            "View".toUpperCase(),
//                            style: TextStyle(
//                                fontSize: ScreenUtil().setSp(14),
//                                color: Colors.white),
//                          ),
//                          onPressed: () {},
//                        ))
//                      ],
//                    ),
//                  ],
//                ),
//              ),
          ],
        ),
      ),
    );
  }

  Widget widgetGlosaryListItems(int position, GlossaryExpandable glossaryExpandable) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        glossaryExpandable.charName,
        style: TextStyle(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
          fontSize: 17.h,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: <Widget>[
        Column(
          children: _buildExpandableContent(glossaryExpandable),
        ),
      ],
//
//
    );
  }

  _buildExpandableContent(GlossaryExpandable glossaryExpandable) {
    List<Widget> columnContent = [];

    for (int i = 0; i < glossaryExpandable.glossaryitem.length; i++) {
      print("Html Content:${glossaryExpandable.glossaryitem[i].description}");

      columnContent.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*Text(
                glossaryExpandable.glossaryitem[i].title,
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),),
              ),
              SizedBox(
                height: 8.h,
              ),*/
              Text(
                glossaryExpandable.glossaryitem[i].description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                ),
              ),
              /*Html(
                data: glossaryExpandable.glossaryitem[i].description,
              ),*/
              (i != glossaryExpandable.glossaryitem.length - 1)
                  ? const Divider()
                  : Container()
            ],
          ),
        ),
      ));
    }

    return columnContent;
  }

  Widget downloadIcon(DummyMyCatelogResponseTable2 table2) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: 40.h,
        height: 40.h,
        child: InkWell(
            onTap: () async {
              if (!widget.myLearningModel.isdownloaded) {
                PermissionStatus permission = await Permission.storage.status;

                if (permission != PermissionStatus.granted) {
                  await Permission.storage.request();
                  PermissionStatus permission = await Permission.storage.status;
                  if (permission == PermissionStatus.granted) {
                    /// Permission Granted

                    downloadCourse = DownloadCourse(
                        context,
                        widget.myLearningModel,
                        false,
                        appBloc.uiSettingModel,
                        0,
                        streamController,
                        doSomething);

                    downloadCourse?.downloadTheCourse();
                  } else {
                    /// Notify User
                  }
                } else {
                  downloadCourse = DownloadCourse(
                      context,
                      widget.myLearningModel,
                      false,
                      appBloc.uiSettingModel,
                      0,
                      streamController,
                      doSomething);

                  downloadCourse?.downloadTheCourse();
                }
              }
            },
            child: (widget.myLearningModel.isDownloading != null &&
                    widget.myLearningModel.isDownloading)
                ? Center(child: Text('$downloadedProgess %'))
                : Icon(
                    Icons.file_download,
                    color: (widget.myLearningModel.isdownloaded != null &&
                            widget.myLearningModel.isdownloaded)
                        ? Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                        : Colors.black,
                  )));
  }

  /*
  Widget widgetMyCourceListItems(
      DummyMyCatelogResponseTable2 table2, bool isArchive, BuildContext context,
      [int i = 0]) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    print("contentid: ${table2.isdownloaded}");
    detailsBloc.myLearningDetailsModel.setisArchived(table2.isarchived);

    int objecttypeId = table2.objecttypeid;
    String actualstatus = table2.actualstatus;

    bool isratingbarVissble;
    bool isReviewVissble;

    double ratingRequired = 0;
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

    if (objecttypeId != 70 &&
            actualstatus.toLowerCase().contains("completed") ||
        actualstatus == "passed" ||
        actualstatus == "failed") {
      isratingbarVissble = true;
      isReviewVissble = true;
    } else if (actualstatus.toLowerCase().contains("completed") &&
        objecttypeId == 70) {
      isratingbarVissble = false;
      isReviewVissble = false;
    } else if (actualstatus == "attended" && objecttypeId == 70) {
      isratingbarVissble = false;
      isReviewVissble = true;
    }

    Color statuscolor = Color(0xff5750da);

    if (table2.corelessonstatus.toString().contains("Completed")) {
      statuscolor = Color(0xff4ad963);
    } else if (table2.corelessonstatus.toString() == "Not Started") {
      statuscolor = Color(0xfffe2c53);
    } else if (table2.corelessonstatus.toString() == "In Progress") {
      statuscolor = Color(0xffff9503);
    }
    String contentIconPath = table2.iconpath;

    if (AppDirectory.isValidString(appBloc.uiSettingModel.AzureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? table2.iconpath
          : appBloc.uiSettingModel.AzureRootPath + table2.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    } else {
      contentIconPath = table2.siteurl + contentIconPath;
    }
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: GestureDetector(
        onTap: () {
//          detailsBloc.myLearningDetailsModel
//              .setIsEnrollFutureInstance(table2.isenrollfutureinstance);
//          detailsBloc.myLearningDetailsModel.setprogress(table2.progress);
//          detailsBloc.myLearningDetailsModel
//              .setPercentageCompleted(table2.percentcompleted);
//          detailsBloc.myLearningDetailsModel
//              .setCertificateAction(table2.certificateaction);
//          detailsBloc.myLearningDetailsModel
//              .setCertificateId(table2.certificateid);
//          detailsBloc.myLearningDetailsModel
//              .setCertificatePage(table2.certificatepage);
//          detailsBloc.myLearningDetailsModel
//              .seteventStartDateTime(table2.eventstartdatetime);
//          detailsBloc.myLearningDetailsModel
//              .seteventScheduleType(table2.eventscheduletype);
//          detailsBloc.myLearningDetailsModel
//              .setIscancelEventEnabled(table2.isbadcancellationenabled);
//
//          Navigator.of(context).push(MaterialPageRoute(
//              builder: (context) => MyLearningDetails(
//                  contentid: table2.contentid,
//                  objtypeId: objecttypeId,
//                  detailsBloc: detailsBloc,
//                  table2: table2)));
        },
        child: Card(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (AppDirectory.isValidString(
                          table2.viewprerequisitecontentstatus ?? "")) {
                        String alertMessage =
                            appBloc.localstr.prerequistesalerttitle6Alerttitle6;
                        alertMessage = alertMessage +
                            "  \"" +
                            appBloc.localstr.prerequisLabelContenttypelabel +
                            "\" " +
                            appBloc.localstr.prerequistesalerttitle5Alerttitle7;

                        showDialog(
                            context: context,
                            builder: (BuildContext context) => new AlertDialog(
                                  title: Text(
                                    appBloc
                                        .localstr.detailsAlerttitleStringalert,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(alertMessage),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5)),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(appBloc
                                          .localstr.eventsAlertbuttonOkbutton),
                                      style: textButtonStyle,
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));
                      } else {
                        launchCourse(table2, context, false);
                      }
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(120),
                      child: CachedNetworkImage(
                        imageUrl: table2.thumbnailimagepath.startsWith('http')
                            ? table2.thumbnailimagepath
                            : ApiEndpoints.mainSiteURL +
                                table2.thumbnailimagepath,
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

                      /*child: Image.network(
                        "https://qa.instancy.com"+table2.thumbnailimagepath,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),*/

                      /*decoration: new BoxDecoration(

                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4), BlendMode.darken),
                            image: AssetImage(
                              "https://qa.instancy.com"+table2.thumbnailimagepath,
                            ),
                          )
                      ),*/
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
                              ),
                            ))
                        // Container(
                        //   child: Icon(
                        //     table2.objecttypeid == 14
                        //         ? Icons.picture_as_pdf
                        //         : (table2.objecttypeid == 11
                        //             ? Icons.video_library
                        //             : Icons.format_align_justify),
                        //     color: Colors.white,
                        //     size: ScreenUtil().setHeight(30),
                        //   ),
                        // )
                        ),
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
                          table2.corelessonstatus.toString(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(10),
                              color: Colors.white),
                        ),
                      )),
                ],
              ),
              // LinearProgressIndicator(
              //   value: table2.progress == null
              //       ? 0.0
              //       : double.parse(table2.progress) / 100,
              //   valueColor: AlwaysStoppedAnimation<Color>(statuscolor),
              //   backgroundColor: Colors.grey,
              // ),

              LinearProgressIndicator(
                value: AppDirectory.isValidString(table2.progress)
                    ? double.parse(table2.progress) / 100
                    : 0.0,
                valueColor: AlwaysStoppedAnimation<Color>(statuscolor),
                backgroundColor: Colors.grey,
              ),

              Container(
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
                                table2.description != null
                                    ? table2.description
                                    : '',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              InkWell(
                                onTap: () {
                                  if (AppDirectory.isValidString(
                                      table2.viewprerequisitecontentstatus ??
                                          "")) {
                                    String alertMessage = appBloc.localstr
                                        .prerequistesalerttitle6Alerttitle6;
                                    alertMessage = alertMessage +
                                        "  \"" +
                                        appBloc.localstr
                                            .prerequisLabelContenttypelabel +
                                        "\" " +
                                        appBloc.localstr
                                            .prerequistesalerttitle5Alerttitle7;

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            new AlertDialog(
                                              title: Text(
                                                appBloc.localstr
                                                    .detailsAlerttitleStringalert,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Text(alertMessage),
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5)),
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
                                    launchCourse(table2, context, false);
                                  }
                                },
                                child: Text(
                                  table2.name.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(15),
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _settingMyCourseBottomSheet(context, table2, i, "");
                          },
                          child: Icon(
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
                        new Container(
                            width: ScreenUtil().setWidth(20),
                            height: ScreenUtil().setWidth(20),
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(imgUrl)))),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        Text(
                          table2.author != null ? table2.author : '',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),

                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
//                    Text(
//                      table2.shortdescription,
//                      style: TextStyle(
//                          fontSize: ScreenUtil().setSp(14),
//                          color: Colors.black.withOpacity(0.5)),
//                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
//                    Row(
//                      children: <Widget>[
//                        displayDownloadTile(table2, i),
//                        SizedBox(
//                          width: ScreenUtil().setWidth(10),
//                        ),
//                        displayViewTile(table2),
//                        displayPlayTile(table2)
//                      ],
//                    ),
                    (table2.isDownloading != null && table2.isDownloading)
                        ? LinearProgressIndicator(
                            value: downloadedProgess.toDouble() / 100,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                            backgroundColor: Colors.grey,
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  */

  Widget displayPlayTile(DummyMyCatelogResponseTable2 table2) {
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
            table2, appBloc.localstr.mylearningActionsheetPlayoption);
      }
    }

    return Container();
  }

  Widget displayViewTile(DummyMyCatelogResponseTable2 table2) {
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
            table2, appBloc.localstr.mylearningActionsheetViewoption);
      }
    } else if (table2.objecttypeid == 688 || table2.objecttypeid == 70) {
      return Container();
    } else {
      return viewOption(
          table2, appBloc.localstr.mylearningActionsheetViewoption);
    }
  }

  Widget viewOption(DummyMyCatelogResponseTable2 table2, String mylearningActionsheetViewoption) {
    return Expanded(
      child: FlatButton.icon(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        icon: const Icon(
          Icons.remove_red_eye,
          color: Colors.white,
          size: 25,
        ),
        label: Text(
          mylearningActionsheetViewoption.toUpperCase(),
          style:
              TextStyle(fontSize: ScreenUtil().setSp(14), color: Colors.white),
        ),
        onPressed: () {
          if (AppDirectory.isValidString(
              table2.viewprerequisitecontentstatus ?? "")) {
            String alertMessage =
                appBloc.localstr.prerequistesalerttitle6Alerttitle6;
            alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        appBloc.localstr.detailsAlerttitleStringalert,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(alertMessage),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      actions: <Widget>[
                        TextButton(
                          style: textButtonStyle,
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child:
                              Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                        ),
                      ],
                    ));
          } else {
            launchCourse(table2, context, false);
          }
        },
      ),
    );
  }

  Widget displayDownloadTile(DummyMyCatelogResponseTable2 table2, [int i = 0]) {
    print('dummytable ${table2.isdownloaded}');

    if ((table2.objecttypeid == 10 && table2.bit5) ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 688 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 27 ||
        table2.objecttypeid == 70) {
      return Container();
    } else if (table2.isdownloaded && table2.objecttypeid != 70) {
      return Container();
    } else {
      return Expanded(
        child: Stack(
          children: <Widget>[
            !table2.isdownloaded
                ? Container(
                    child: FlatButton.icon(
                      disabledColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                          .withOpacity(0.5),
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      icon: const Icon(
                        Icons.cloud_download,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text(
                        appBloc.localstr.mylearningActionsheetDownloadoption
                            .toUpperCase(),
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.white),
                      ),
                      onPressed: table2.isdownloaded
                          ? null
                          : () async {
                              /// Download
                              /// Check For internet and download
                              ///
                              ///
                              ///
                              if (!table2.isdownloaded) {
                                setState(() {
                                  isDownloaded = false;
                                  isDownloading = true;
                                  downloadedProgess = 0;
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

                                    downloadCourse?.downloadTheCourse();
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

                                  downloadCourse?.downloadTheCourse();
                                }
                              }
                            },
                    ),
                  )
                : Container(),
//                (table2.isDownloading != null && table2.isDownloading)
//                ? Center(
//                    child: Container(
//                        height: 35.h,
//                        child: CircularProgressIndicator()))
//                : Container()
          ],
        ),
      );
    }
  }

  Widget _expandableContent(String s) {
    //MyPrint.printOnConsole("eventTrackBloc.trackListData length:${eventTrackBloc.trackListData.length}");
    if (eventTrackBloc.trackBlockList.isNotEmpty) {
      return Container(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
//        key: const PageStorageKey<String>('Tab1'),
                  physics: const ClampingScrollPhysics(),
                  itemCount: eventTrackBloc.trackBlockList.length,
                  itemBuilder: (context, i) {
                    return ExpansionTile(
                      initiallyExpanded: (eventTrackBloc.resEventTrackTabs.isEmpty && eventTrackBloc.trackBlockList.length == 1),
                      title: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          eventTrackBloc.trackBlockList[i].block,
                          style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 17.h,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      children: <Widget>[
                        Column(
                          children:
                          _buildContent(eventTrackBloc.trackBlockList[i]),
                        ),
                      ],
                    );
                  },
              ),
              eventTrackBloc.singleTempLATE.isNotEmpty
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          height: 15.h,
                          color: Colors.grey[200],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        buildBlockSingleList(eventTrackBloc.singleTempLATE),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      );
    }
    else if (eventTrackBloc.trackListData.isNotEmpty) {
      return buildBlockSingleList(eventTrackBloc.trackListData);
    }
    else {
      return noDataFound(true);
    }
  }

  Widget buildBlockSingleList(List<DummyMyCatelogResponseTable2> list) {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: ResponsiveWidget(
        mobile: ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, i) {
            return Container(
              child: widgetSessionsListItems(list[i], i),
            );
          },
          controller: _sc,
        ),
        tab: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.4),
          ),
          itemCount: list.length,
          itemBuilder: (context, i) {
            return Container(
              child: widgetSessionsListItems(list[i], i),
            );
          },
        ),
        web: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.4),
          ),
          itemCount: list.length,
          itemBuilder: (context, i) {
            return Container(
              child: widgetSessionsListItems(list[i], i),
            );
          },
        ),
      ),
    );
  }

  _buildContent(ResTrackBlocksList trackBlockList) {
    List<Widget> columnContent = [];

    for (int i = 0; i < trackBlockList.data.length; i++) {
      columnContent.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: widgetSessionsListItems(trackBlockList.data[i], i),
        ),
      ));
    }

    return columnContent;
  }

  Widget mytabs(ResEventTrackTabs tab) {
    switch (tab.tabidName) {
      case 'TOverview':
        return overView();
      case 'EContent':
        return _expandableContent('Tab1');
      case 'TContent':
        return _expandableContent('Tab1');
      case 'TDiscussion':
        return DiscussionMain(
          isFromDiscussionForumPage: false,
          contentId: widget.myLearningModel.contentid,
        );
      case 'TResource':
        return _myListResource();
      case 'TPeople':
        return ConnectionScreen(
          isFromConnectionPage: false,
          contentId: widget.myLearningModel.contentid,
          authorId: widget.myLearningModel.createduserid,
          scrollController: _sc,
        );
      case 'TGlossary':
        return _myList('Tab5');
      default:
        return comingSoon();
    }
  }

  /*
  unused code
//   Future<void> launchCourse(
//       DummyMyCatelogResponseTable2 table2, BuildContext context) async {
//     /// Need Some value
//     if (table2.objecttypeid == 102) {
//       executeXAPICourse(table2);
//     }
//
//     courseLaunch = GotoCourseLaunch(
//         context, table2, false, appBloc.uiSettingModel, myLearningBloc.list);
//     String url = await courseLaunch.getCourseUrl();
//     if (url.isNotEmpty) {
//       if (table2.objecttypeid == 26) {
//         await Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => AdvancedWebCourseLaunch(url, table2.name)));
//       } else {
//         await Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => InAppWebCourseLaunch(url, table2)));
//       }
//
//       logger.e(".....Refresh Me....");
//
//       createUrl(table2);
// //
//     }
//   }
   */

  Future<bool> decideCourseLaunchMethod({
    required BuildContext context,
    required DummyMyCatelogResponseTable2 table2,
    bool isContentisolation = false
  }) async {
    // bool networkAvailable = await AppDirectory.checkInternetConnectivity();
    // bool isCourseDownloaded = await EventTrackController().checkIfContentIsAvailableOffline(
    //   context: context,
    //   parentMyLearningModel: widget.myLearningModel,
    //   table2: table2,
    // );
    bool networkAvailable =true;
    bool isCourseDownloaded = false;

    if (networkAvailable && isCourseDownloaded) {
      // launch offline
      bool isLaunched = true;
      if(isLaunched) {
        await SyncData().syncData();
      }
      return isLaunched;
    } else if (!networkAvailable && isCourseDownloaded) {
      // launch offline
      return true;
    } else if (networkAvailable && !isCourseDownloaded) {
      // launch online
      launchCourse(table2, context, isContentisolation);
      return true;
    } else {
      // error dialog
      AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);
      EventTrackController().courseNotDownloadedDialog(context, appBloc);
      return false;
    }
  }

  Future<void> launchCourse(DummyMyCatelogResponseTable2 table2, BuildContext context, bool isContentisolation) async {
    print('helllllllllloooooo launchCourse ${table2.objecttypeid}');

    //table2.corelessonstatus = "In Progress";

    /// content isolation only for 8,9,10,11,26,27 /// Commented for am always a student client
    if (!isContentisolation) {
      if ([8, 9, 26, 102].contains(table2.objecttypeid)) {
        setState(() {
          isLoading = true;
        });

        /// remove after normal course launch
        GotoCourseLaunchContentisolation courseLaunch =
            GotoCourseLaunchContentisolation(
                context, table2, appBloc.uiSettingModel, myLearningBloc.list);

        String courseUrl = await courseLaunch.getCourseUrl();
        print("Course Url:$courseUrl");

        myLearningBloc.add(CourseTrackingEvent(
          courseUrl: courseUrl,
          table2: table2,
          userID: table2.userid.toString(),
          objecttypeId: "${table2.objecttypeid}",
          siteIDValue: "${table2.siteid}",
          scoId: "${table2.scoid}",
          contentID: table2.contentid,
        ));

        return;
      }
    }

    /// Need Some value
    if (table2.objecttypeid == 102) {
      executeXAPICourse(table2);
    }

    courseLaunch = GotoCourseLaunch(context, table2, false, appBloc.uiSettingModel, myLearningBloc.list);
    String url = await courseLaunch!.getCourseUrl();

    setState(() {
      isLoading = false;
    });

    print('urldataaaaa $url');
    if (url.isNotEmpty) {
      if (table2.objecttypeid == 26) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InAppWebCourseLaunch(url, table2)));
      } else {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InAppWebCourseLaunch(url, table2)));
      }
      // logger.e(".....Refresh Me....$url");

      /// Refresh Content Of My Learning

    }
    //sreekanth commented
    //Assignment content webview
    if (table2.objecttypeid == 694) {
      assignmenturl =
          '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}/ismobilecontentview/true';
      print('assignmenturl is : $assignmenturl');

      dynamic value = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Assignmentcontentweb(
                url: assignmenturl,
                myLearningModel: table2,
              )));
      if (value) {
        refreshContent(table2);
      }
    }
    //sreekanth commented
    if ([8, 9, 11, 14, 28, 102, 26].contains(table2.objecttypeid)) {
      String paramsString = "";

      paramsString = "userID=${table2.userid}&scoid=${table2.scoid}";

      String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      String url =
          "$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString";

      print('launchCourseUrl $url');

      detailsBloc.add(GetContentStatus(url: url, table2: table2));
      createParentUrl(widget.myLearningModel);
    }
  }

  Future<void> launchCourseContentisolation(DummyMyCatelogResponseTable2 table2, BuildContext context, String token) async {
    print(
        'launchCourseContentisolation called with object type id:${table2.objecttypeid}');

    /// refresh the content
    var objectTypeIds = [
      8,
      9,
      10,
      11,
      14,
      28,
      102,
      26, /*694*/
    ];

    setState(() {
      isLoading = false;
    });

    if (objectTypeIds.contains(table2.objecttypeid)) {
      String paramsString = '';
      if (table2.objecttypeid == 10 && table2.bit5) {
        paramsString = 'userID=${table2.userid.toString()}&scoid=${table2.scoid.toString()}&TrackObjectTypeID=${table2.objecttypeid.toString()}&TrackContentID=${table2.contentid}&TrackScoID=${table2.scoid.toString()}&SiteID=${table2.siteid.toString()}&OrgUnitID=${table2.siteid.toString()}&isonexist=onexit';
      } else {
        paramsString = 'userID=${table2.userid.toString()}' +
            '&scoid=${table2.scoid.toString()}';
      }

      if (token.isNotEmpty) {
        String courseUrl;
        if (AppDirectory.isValidString(appBloc.uiSettingModel.azureRootPath)) {
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
          // await Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         AdvancedWebCourseLaunch(courseUrl, table2.name),
          //   ),
          // );
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
                  /*eventTrackBloc.add(GetTrackListData(
                isInternet: true,
                appBloc: appBloc,
                isTraxkList: widget.isTraxkList,
                myLearningModel: widget.myLearningModel)),*/
                }
            },
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
                      /*eventTrackBloc.add(GetTrackListData(
                isInternet: true,
                appBloc: appBloc,
                isTraxkList: widget.isTraxkList,
                myLearningModel: widget.myLearningModel)),*/
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
      createParentUrl(widget.myLearningModel);
    }
  }

  Widget comingSoon() {
    return const Center(
      child: Text('Coming Soon'),
    );
  }

  Widget overView() {
    String startDate = '';
    String endDate = '';
    if (widget.myLearningModel.objecttypeid == 70) {
      if (widget.myLearningModel.eventstartdatedisplay.toString().isNotEmpty) {
        DateTime startTempDate = DateFormat("yyyy-MM-ddThh:mm:ss")
            .parse(widget.myLearningModel.eventstartdatedisplay);

        startDate =
            DateFormat("E dd/MMM/yyyy hh:mm:ss a").format(startTempDate);
      }

      if (widget.myLearningModel.eventenddatedisplay.toString().isNotEmpty) {
        DateTime endTempDate = DateFormat("yyyy-MM-ddThh:mm:ss")
            .parse(widget.myLearningModel.eventenddatedisplay);

        endDate = DateFormat("E dd/MMM/yyyy hh:mm:ss a").format(endTempDate);
      }
    }

    if (eventTrackBloc.overviewResponse.isEmpty) {
      return noDataFound(true);
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (eventTrackBloc.overviewResponse[0].shortdescription.isNotEmpty ||
                    eventTrackBloc
                        .overviewResponse[0].longdescription.isNotEmpty)
                ? Text(
                    appBloc.localstr.detailsLabelDescriptionlabel,
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 17.h,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(
              height: 5.h,
            ),
            secondHalf.isEmpty
                ? Text(
                    removeAllHtmlTags(
                        '${eventTrackBloc.overviewResponse[0].shortdescription} \n\n ${eventTrackBloc.overviewResponse[0].longdescription}'),
                    style: TextStyle(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        flag
                            ? removeAllHtmlTags("$firstHalf...")
                            : removeAllHtmlTags(firstHalf + secondHalf),
                        style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              flag ? "show more" : "show less",
                              style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                      ),
                    ],
                  ),
            SizedBox(
              height: 5.h,
            ),
            eventTrackBloc.overviewResponse[0].createddate.isNotEmpty
                ? Text(
                    'Created on',
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 17.h,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(
              height: 5.h,
            ),
            Text(
              eventTrackBloc.overviewResponse[0].createddate,
              style: TextStyle(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              ),
            ),
            widget.myLearningModel.objecttypeid == 70
                ? SizedBox(
                    height: 25.h,
                  )
                : Container(),
            widget.myLearningModel.objecttypeid == 70
                ? Text(
                    'Date and Time',
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 17.h,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
            widget.myLearningModel.objecttypeid == 70
                ? SizedBox(
                    height: 5.h,
                  )
                : Container(),
            widget.myLearningModel.objecttypeid == 70
                ? Row(
                    children: <Widget>[
                      Text(
                        'Start Date',
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        startDate,
                        style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.myLearningModel.objecttypeid == 70
                ? Row(
                    children: <Widget>[
                      Text(
                        'End Date',
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        endDate,
                        style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.myLearningModel.objecttypeid == 70
                ? Row(
                    children: <Widget>[
                      Text(
                        'Time zone',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        widget.myLearningModel.timezone,
                        style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.myLearningModel.objecttypeid == 70
                ? SizedBox(
                    height: 5.h,
                  )
                : Container(),
            widget.myLearningModel.objecttypeid == 70
                ? OutlineButton(
                    onPressed: () {
                      addToCal(widget.myLearningModel);
                    },
                    border: Border.all(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                    borderRadius:  BorderRadius.circular(5.h),
                    child: Text(appBloc
                        .localstr.mylearningActionsheetAddtocalendaroption),
                  )
                : Container(),
            SizedBox(
              height: 25.h,
            ),
            eventTrackBloc.overviewResponse[0].orgName.isNotEmpty
                ? Text(
                    'Community',
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 17.h,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(
              height: 5.h,
            ),
            Text(
              eventTrackBloc.overviewResponse[0].orgName,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              'About Author',
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  fontSize: 17.h,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.h,
            ),
            Card(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: eventTrackBloc
                                .overviewResponse[0].profileImgPath
                                .startsWith('http')
                            ? eventTrackBloc.overviewResponse[0].profileImgPath
                            : ApiEndpoints.strSiteUrl +
                                eventTrackBloc
                                    .overviewResponse[0].profileImgPath
                                    .trim(),
                        width: 50.h,
                        height: 50.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ClipOval(
                          child: CircleAvatar(
                            radius: 25.h,
                            backgroundColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                            child: Text(
                              eventTrackBloc.overviewResponse[0].displayName
                                      .isNotEmpty
                                  ? eventTrackBloc
                                      .overviewResponse[0].displayName[0]
                                  : 'N/A',
                              style: TextStyle(
                                  fontSize: 20.h, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => ClipOval(
                          child: CircleAvatar(
                            radius: 25.h,
                            backgroundColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                            child: Text(
                              eventTrackBloc.overviewResponse[0].displayName
                                      .isNotEmpty
                                  ? eventTrackBloc
                                      .overviewResponse[0].displayName[0]
                                  : 'NA',
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  fontSize: 30.h,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      removeAllHtmlTags(
                          eventTrackBloc.overviewResponse[0].displayName),
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontSize: 17.h,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      eventTrackBloc.overviewResponse[0].totalRatings,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.play_circle_outline,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(
                          eventTrackBloc.overviewResponse[0].contentCount,
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      eventTrackBloc.overviewResponse[0].about,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            eventTrackBloc.tag.isNotEmpty
                ? Text(
                    'Tags',
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 17.h,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(
              height: 5.h,
            ),
            Text(
              eventTrackBloc.tag,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListResource() {
    return SingleChildScrollView(
        child: eventTrackBloc.refItem.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  ListView.builder(
                      shrinkWrap: true,
//                    key: const PageStorageKey<String>('Tab3'),
                      physics: const ClampingScrollPhysics(),
                      itemCount: eventTrackBloc.refItem.length,
                      itemBuilder: (context, i) => Container(
                            child: widgetResourceListItems(
                                i, eventTrackBloc.refItem[i]),
                          )),
                ],
              )
            : noDataFound(true));
  }

  void initialiseModelDownloadAll() async {
    fileCourseDownloader?.startDownload();
  }

  Future<void> _downloaderCallBack(CallbackParam callbackParam, BuildContext context, int position, ReferenceItem refItem) async {
    try {
      setState(() {
        _downloadProgress = callbackParam.progress;
      });
      _downloaded = callbackParam.status == DownloadTaskStatus.complete;

      if (_downloadProgress == -1) {
        //nextScreenNav(context, false);
        print("PDF download have error ........");
        setState(() {
          refItem.isDownloaded = false;
          refItem.isDownloading = false;
        });

        flutterToast.showToast(
          child: CommonToast(displaymsg: 'Error while downloading'),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } else if (_downloadProgress == 100) {
        setState(() {
          refItem.isDownloaded = true;
          refItem.isDownloading = false;
        });

        flutterToast.showToast(
          child: CommonToast(displaymsg: 'Successfully downloaded'),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } else {
        setState(() {
          refItem.isDownloaded = false;
          refItem.isDownloading = true;
        });
      }
    } catch (e) {
      setState(() {
        refItem.isDownloaded = false;
        refItem.isDownloading = true;
      });
    }
  }

  String removeAllHtmlTags(String htmlText) {
    String parsedString = "";

    if (htmlText.isNotEmpty) {
      var document = parse(htmlText);

      parsedString =
          parse(document.body?.text ?? "").documentElement?.text ?? "";
    }

    return parsedString;
  }

  List<Widget> buildSliverHeader() {
    final List<Widget> widgets = <Widget>[];
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    final thumbnailImgHeight = useMobileLayout ? 160 : 440;

    widgets.add(
      SliverAppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          ),
          actions: <Widget>[
            widget.myLearningModel.objecttypeid != 70
                ? GestureDetector(
                    onTap: () {
                      _settingMyCourseBottomSheet(
                          context, widget.myLearningModel, 0, "", 'Main');
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: InsColor(appBloc).appIconColor,
                    ),
                  )
                : Container()
          ],
          expandedHeight: 0.h,
          pinned: false,
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
          elevation: 0,
          title: Text(
            widget.myLearningModel.name,
            style: TextStyle(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          )),
    );

    widgets.add(SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int pos) => Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          width: MediaQuery.of(context).size.width,
          child: ListView(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => Image.asset(
                      'assets/cellimage.jpg',
                      width: MediaQuery.of(context).size.width,
                      height: ScreenUtil().setHeight(thumbnailImgHeight),
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/cellimage.jpg',
                      width: MediaQuery.of(context).size.width,
                      height: ScreenUtil().setHeight(thumbnailImgHeight),
                      fit: BoxFit.cover,
                    ),
                    imageUrl: widget.myLearningModel.thumbnailimagepath
                            .startsWith("http")
                        ? widget.myLearningModel.thumbnailimagepath
                        : ApiEndpoints.strSiteUrl +
                            widget.myLearningModel.thumbnailimagepath,
                    height: ScreenUtil().setHeight(thumbnailImgHeight),
                    fit: BoxFit.cover,
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
                                  imageUrl: contentIconPath,
                                  width: 30,
                                  fit: BoxFit.contain,
                                )))),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
//
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      widget.myLearningModel.name,
                      style: TextStyle(
                        fontSize: 17.h,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )),
//                    SizedBox(
//                      width: 5.h,
//                    ),
//                    Icon(
//                      Icons.live_tv,
//                      color: Color(int.parse(
//                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Image.network(
                        imgUrl,
                        width: 25.h,
                        height: 25.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 5.h,
                    ),
                    Text(widget.myLearningModel.authordisplayname,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: SmoothStarRating(
                    allowHalfRating: false,
                    onRatingChanged: (v) {},
                    starCount: 5,
                    rating: widget.myLearningModel.ratingid,
                    size: ScreenUtil().setHeight(15),
                    // filledIconData: Icons.blur_off,
                    // halfFilledIconData: Icons.blur_on,
                    color: Colors.orange,
                    borderColor: Colors.orange,
                    spacing: 0.0),
              ),
              SizedBox(
                height: 20.h,
              ),
              AppDirectory.isValidString(widget.myLearningModel.progress)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 9,
                          child: Container(
                            height: 7.h,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey.shade400,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                              value: AppDirectory.isValidString(
                                      widget.myLearningModel.progress)
                                  ? double.parse(
                                          widget.myLearningModel.progress) /
                                      100
                                  : AppDirectory.isValidString(widget
                                          .myLearningModel.percentcompleted)
                                      ? double.parse(widget.myLearningModel
                                              .percentcompleted) /
                                          100
                                      : 0.0,
                            ),
                          ),
                        ),
                        Flexible(
                            flex: 2,
                            child: Text(AppDirectory.isValidString(
                                    widget.myLearningModel.progress)
                                ? '${widget.myLearningModel.progress.toString()} %'
                                : '${widget.myLearningModel.percentcompleted.toString()} %')),
                        Padding(
                          padding: EdgeInsets.all(8.h),
                          child: Text(!AppDirectory.isValidString(
                                      widget.myLearningModel.progress) &&
                                  widget.myLearningModel.percentcompleted == '0'
                              ? '${widget.myLearningModel.actualstatus}'
                              : ''),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
        childCount: 1,
      ),
    ));

    return widgets;
  }

  List<Widget> buildSliverHeader2() {
    final List<Widget> widgets = <Widget>[];
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    final thumbnailImgHeight = useMobileLayout ? 160 : 440;

    widgets.add(
      SliverAppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          ),
          actions: <Widget>[
            widget.myLearningModel.objecttypeid != 70
                ? GestureDetector(
              onTap: () {
                _settingMyCourseBottomSheet(
                    context, widget.myLearningModel, 0, "", 'Main');
              },
              child: Icon(
                Icons.more_vert,
                color: InsColor(appBloc).appIconColor,
              ),
            )
                : Container()
          ],
          expandedHeight: 0.h,
          pinned: false,
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
          elevation: 0,
          title: Text(
            widget.myLearningModel.name,
            style: TextStyle(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          )),
    );

    double completedPercentage = AppDirectory.isValidString(widget.myLearningModel.progress)
        ? double.parse(widget.myLearningModel.progress) / 100
        : AppDirectory.isValidString(widget.myLearningModel.percentcompleted)
          ? double.parse(widget.myLearningModel.percentcompleted) / 100
          : 0.0;

    widgets.add(SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int pos) {
          return Container(
            color: AppColors.getAppButtonBGColor(),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        width: 70.h,
                        height: 70.h,
                        placeholder: (context, url) => Image.asset(
                          'assets/cellimage.jpg',
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(thumbnailImgHeight),
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/cellimage.jpg',
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(thumbnailImgHeight),
                          fit: BoxFit.cover,
                        ),
                        imageUrl: widget.myLearningModel.thumbnailimagepath
                            .startsWith("http")
                            ? widget.myLearningModel.thumbnailimagepath
                            : ApiEndpoints.strSiteUrl +
                            widget.myLearningModel.thumbnailimagepath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.myLearningModel.name,
                            style: TextStyle(
                              fontSize: 16.h,
                              //fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            "By ${widget.myLearningModel.authordisplayname}",
                            style: TextStyle(
                              fontSize: 12.h,
                              //fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.getAppBGColor(),
                        ),
                        child: const Icon(Icons.download_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  height: 10.h,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade400,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.getProgressIndicatorColor()),
                    value: completedPercentage,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${(completedPercentage * 100).toStringAsFixed(0)}% Completed",
                      style: TextStyle(
                        fontSize: 12.h,
                        //fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        childCount: 1,
      ),
    ));

    return widgets;
  }

  void downloadRes(ReferenceItem refItem, int position) async {
    if (pathSeparator.trim().isEmpty) {
      pathSeparator = Platform.pathSeparator;
    }

    if (Platform.isAndroid) {
      //downloadResPath = '/sdcard/download/' + pathSeparator + refItem.title;
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        downloadResPath = directory.path;
        /*downloadResPath = directory.path.substring(0, directory.path.lastIndexOf("/"));
        downloadResPath = downloadResPath.substring(0, downloadResPath.lastIndexOf("/"));
        downloadResPath = downloadResPath.substring(0, downloadResPath.lastIndexOf("/"));
        downloadResPath = downloadResPath.substring(0, downloadResPath.lastIndexOf("/"));*/
        downloadResPath = downloadResPath + pathSeparator + refItem.title;
      } else {
        return;
      }
    } else {
      downloadResPath = (await getApplicationDocumentsDirectory()).path +
          pathSeparator +
          refItem.title;
    }

    final savedDir = Directory(downloadResPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create(recursive: true);
    }

    print("refItem.path:${refItem.path}");
    print("refItem.type:${refItem.type}");
    String extensionStr = refItem.path.split('/').last;

    print('extensionString $urlpath');

    if (refItem.type == 'url') {
      urlpath = refItem.path;
    } else {
      urlpath = ApiEndpoints.strSiteUrl
              .substring(0, ApiEndpoints.strSiteUrl.length - 1) +
          refItem.path;

      if (urlpath.toLowerCase().contains(".ppt") ||
          urlpath.toLowerCase().contains(".pptx") ||
//          urlpath.toLowerCase().contains(".pdf") ||
          urlpath.toLowerCase().contains(".doc") ||
          urlpath.toLowerCase().contains(".docx") ||
          urlpath.toLowerCase().contains(".xls") ||
          urlpath.toLowerCase().contains(".xlsx")) {
        urlpath = urlpath.replaceAll("file://", "");
        urlpath = "https://docs.google.com/gview?embedded=true&url=$urlpath";
      } else if (urlpath.toLowerCase().contains(".pdf")) {
        if (appBloc.uiSettingModel.isCloudStorageEnabled.toLowerCase() ==
            'true') {
          urlpath = "$urlpath?fromnativeapp=true";
        } else {
          urlpath = "$urlpath?fromNativeapp=true";
        }
      } else {
        urlpath = urlpath;
      }
    }

    print("Download Url:$urlpath");
    print("Download Path:${downloadResPath + pathSeparator + extensionStr}");

    fileCourseDownloader =
        FileCourseDownloader(urlpath, (CallbackParam? callbackParam) {
      if (callbackParam != null) {
        _downloaderCallBack(callbackParam, context, position, refItem);
      }
    }, downloadResPath, pathSeparator, extensionStr);

    initialiseModelDownloadAll();
  }

  void navigateUrl(ReferenceItem refItem) {
    print('urlpathh ${refItem.path}');

    if (refItem.type == 'url') {
      urlpath = refItem.path;
    } else {
      if (refItem.path.contains('jwplatform')) {
        urlpath = refItem.path.replaceAll('//', '');
      } else {
        urlpath = ApiEndpoints.strSiteUrl + refItem.path;
      }

      if (urlpath.toLowerCase().contains(".ppt") ||
          urlpath.toLowerCase().contains(".pptx") ||
          urlpath.toLowerCase().contains(".pdf") ||
          urlpath.toLowerCase().contains(".doc") ||
          urlpath.toLowerCase().contains(".docx") ||
          urlpath.toLowerCase().contains(".xls") ||
          urlpath.toLowerCase().contains(".xlsx")) {
        urlpath = urlpath.replaceAll("file://", "");
        if (appBloc.uiSettingModel.isCloudStorageEnabled.toLowerCase() ==
            'true') {
          urlpath = "https://docs.google.com/gview?embedded=true&url=$urlpath?fromnativeapp=true";
        } else {
          urlpath = "https://docs.google.com/gview?embedded=true&url=$urlpath?fromNativeapp=true";
        }
      } else if (urlpath.toLowerCase().contains(".jwplatform")) {
        urlpath = 'http://$urlpath';
      }
//      else if (urlpath.toLowerCase().contains(".pdf")) {
//        if (appBloc.uiSettingModel.isCloudStorageEnabled.toLowerCase() ==
//            'true') {
//          urlpath = "http://docs.google.com/gview?embedded=true&url="+ urlpath + "?fromnativeapp=true";
//        } else {
//          urlpath = "http://docs.google.com/gview?embedded=true&url=" +urlpath + "?fromNativeapp=true";
//        }
//      }
      else {
        urlpath = urlpath;
      }
    }

//     Navigator.of(context).push(MaterialPageRoute(
//        builder: (context) => InAppWebCourseLaunch('https://flutter.instancy.com//Content/Instancy V2 Folders/734/en-us/856acec4-56ff-4dec-aa24-652cb34f892a.pdf?fromNativeapp=true', table2)));

    print('finalurlpath $urlpath');
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            AdvancedWebCourseLaunch(urlpath.trim(), refItem.title)));
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => InAppWebCourseLaunch(urlpath.trim(), refItem),
    //   ),
    // )
    //     .then(
    //       (value) => {
    //     if (value ?? true)
    //       {
    //         /*eventTrackBloc.add(GetTrackListData(
    //             isInternet: true,
    //             appBloc: appBloc,
    //             isTraxkList: widget.isTraxkList,
    //             myLearningModel: widget.myLearningModel)),*/
    //       }
    //   },
    // );
  }

  /*
  Unused code
  void createUrl(DummyMyCatelogResponseTable2 table2) async {
    if (table2.objecttypeid == 8 ||
        table2.objecttypeid == 9 ||
        table2.objecttypeid == 10 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 26) {
      String paramsString = "";
      if (table2.objecttypeid == 10 && table2.bit5) {
        paramsString = "userID=" +
            table2.userid.toString() +
            "&scoid=" +
            table2.scoid.toString() +
            "&TrackObjectTypeID=" +
            table2.objecttypeid.toString() +
            "&TrackContentID=" +
            table2.contentid +
            "&TrackScoID=" +
            table2.scoid.toString() +
            "&SiteID=" +
            table2.siteid.toString() +
            "&OrgUnitID=" +
            table2.siteid.toString() +
            "&isonexist=onexit";
      } else {
        paramsString = "userID=" +
            table2.userid.toString() +
            "&scoid=" +
            table2.scoid.toString();
      }

      String webApiUrl = await sharePref_getString(sharedPref_webApiUrl);

      String url =
          webApiUrl + "/MobileLMS/MobileGetContentStatus?" + paramsString;

      print('launchCourseUrl $url');

      eventTrackBloc.add(TrackGetContentStatus(url: url, table2: table2));
    }
  }
  */

  void createParentUrl(DummyMyCatelogResponseTable2 table2) async {
    print("createParentUrl called");
    String paramsString = "userID=${table2.userid}&scoid=${table2.scoid}&TrackObjectTypeID=${table2.objecttypeid}&TrackContentID=${table2.contentid}&TrackScoID=${table2.scoid}&SiteID=${table2.siteid}&OrgUnitID=${table2.siteid}&isonexist=onexit";

    /*String paramsString = "parentcontentID=${table2.contentid}&siteID=${table2.siteid}&userID=${table2.userid}"
        "&objecttypeid=${table2.objecttypeid}&iscontentenrolled=true&scoid=${table2.scoid}&localeID=${locale}";*/

    String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String url =
        "$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString";
    //String url = webApiUrl + "EventTrackTabs/GetEventTrackHeaderData?$paramsString";

    print('Parent Content Status url:$url');

    eventTrackBloc.add(
        ParentTrackGetContentStatus(url: url, table2: widget.myLearningModel));
  }

  void addToCal(DummyMyCatelogResponseTable2 table2) {
    DateTime startDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(table2.eventstartdatetime);
    DateTime endDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(table2.eventenddatetime);

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
  }

  void cancelEnrollment(DummyMyCatelogResponseTable2 table2, String bool) {
    eventTrackBloc.add(TrackCancelEnrollment(
        isBadCancel: bool, strContentID: table2.contentid));
  }

  void badCancelEnrollmentMethod(DummyMyCatelogResponseTable2 table2) {
    eventTrackBloc.add(BadCancelEnrollment(contentid: table2.contentid));
  }

  void showCancelEnrollDialog(DummyMyCatelogResponseTable2 table2, String isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          appBloc.localstr.mylearningAlerttitleStringareyousure,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(appBloc
            .localstr.mylearningAlertsubtitleDoyouwanttocancelenrolledevent),
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        actions: <Widget>[
          TextButton(
            style: textButtonStyle,
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text(appBloc.localstr.catalogAlertbuttonCancelbutton),
          ),
          TextButton(
            style: textButtonStyle,
            onPressed: () async {
              Navigator.of(context).pop();
              cancelEnrollment(table2, isSuccess);
            },
            child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
          ),
        ],
      ),
    );
  }

  Future<void> refreshContent(DummyMyCatelogResponseTable2? table2) async {
    if(table2 != null) {
      if (['11', '14', '20', '21', '36', '52'].contains(
          table2.objecttypeid.toString()) && table2.isdownloaded) {
        await updateTrackStatus();
        detailsBloc.add(SetCompleteEvent(
          table2: table2,
          isTrackListItem: true,
          eventTrackModel: widget.myLearningModel,
        ));
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
    eventTrackBloc.add(GetTrackListData(
        isInternet: true,
        appBloc: appBloc,
        isTraxkList: widget.isTraxkList,
        myLearningModel: widget.myLearningModel));
  }

  Future<void> updateTrackStatus() async {
    String collectionName = "$tracklistCollection-${widget.myLearningModel.contentid}-${appBloc.userid}";
    var data = await HiveDbHandler().readData(collectionName);

    if(data.isEmpty) return;

    List<DummyMyCatelogResponseTable2> list = [];
    for(Map<String, dynamic> item in data) {
      if(item.containsKey('data')) {
        continue;
      }
      DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
      table2.fromJson(item);
      list.add(table2);
    }

    bool trackIsCompleted = false;
    int courseCount = list.length;
    int completeCount = 0;
    for (DummyMyCatelogResponseTable2 item in list) {
      if (item.progress == '100') {
        completeCount++;
      }
    }
    if (completeCount == courseCount) {
      trackIsCompleted = true;
    }

    /// Update progress for Learning Track
    var myLearningData = await HiveDbHandler()
        .readData("$myLearningCollection-${appBloc.userid}");
    if (myLearningData.isEmpty) return;

    List<DummyMyCatelogResponseTable2> myLearningDataList = [];
    for (Map<String, dynamic> item in myLearningData) {
      DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
      table2.fromJson(item);
      myLearningDataList.add(table2);
    }
    int idx = myLearningDataList.indexWhere((element) {
      return element.siteid == widget.myLearningModel.siteid &&
          element.scoid == widget.myLearningModel.scoid &&
          element.userid == widget.myLearningModel.userid;
    });
    if (idx != -1) {
      myLearningDataList[idx].corelessonstatus =
          trackIsCompleted ? 'Completed' : 'In Progress';
      myLearningDataList[idx].progress = trackIsCompleted ? '100' : '50';
      await HiveDbHandler().createData(
        "$myLearningCollection-${appBloc.userid}",
        myLearningDataList[idx].contentid,
        myLearningDataList[idx].toJson(),
      );
    }
  }

  //region card functions
  void _onMoreTap(DummyMyCatelogResponseTable2 table2, int idx) {
    _settingMyCourseBottomSheet(
        context, table2, idx, widget.myLearningModel.contentid);
  }

  void _onArchivedTap(DummyMyCatelogResponseTable2 table2) {
    print('_onArchivedTap');
  }

  void _onReviewTap(DummyMyCatelogResponseTable2 table2) {
    print('_onReviewTap');
  }

  void _onViewTap(DummyMyCatelogResponseTable2 table2) async {
    bool result = await decideCourseLaunchMethod(
      context: context,
      table2: table2,
      isContentisolation: false,
    );
    if (!result) {
      table2.isdownloaded = false;
      setState(() {});
    }

    refreshContent(table2);

    // bool networkAvailable = await AppDirectory.checkInternetConnectivity();
    // if (networkAvailable) {
    //   launchCourse(table2, context, false);
    // }
    // else {
    //   bool isShownOffline = await EventTrackController().launchCourseOffline(
    //     context: context,
    //     parentMyLearningModel: widget.myLearningModel,
    //     table2: table2,
    //
    //   );
    //   if (!isShownOffline) {
    //     table2.isdownloaded = false;
    //     setState(() {});
    //   }
    //   refreshContent(table2);
    // }
  }

  void _onDownloadTap(DummyMyCatelogResponseTable2 table2) async {
    MyPrint.printOnConsole("_onDownloadTap called");

    if (table2.isdownloaded) {
      return;
    }

    if(Provider.of<ConnectionProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false).isInternet) {
      setState(() {
        table2.isDownloading = true;
        //isLoading = true;
      });

      //bool isDownloaded = await MyLearningController().storeMyLearningContentOffline(context, table2, appBloc.userid);
      bool isDownloaded = await MyLearningDownloadController().storeMyLearningContentOffline(
        context,
        table2, appBloc.userid,
        isTrackEvent: true,
        trackData: widget.myLearningModel,
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
    else {
      CustomSnackbar().showErrorSnackbar(context, "No Internet");
    }
  }
//endregion card functions
}
