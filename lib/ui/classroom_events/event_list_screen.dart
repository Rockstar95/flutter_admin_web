import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/backend/app_controller.dart';
import 'package:flutter_admin_web/backend/classroom_events/classroom_events_controller.dart';
import 'package:flutter_admin_web/configs/app_strings.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/waiting_list_response.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/ui/classroom_events/components/classroom_event_card.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/bottomsheet_drager.dart';
import 'package:flutter_admin_web/ui/common/common_widgets.dart';
import 'package:flutter_admin_web/ui/common/modal_progress_hud.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../configs/constants.dart';
import '../../framework/bloc/app/events/app_event.dart';
import '../../framework/bloc/catalog/bloc/catalog_bloc.dart';
import '../../framework/bloc/catalog/event/catalog_event.dart';
import '../../framework/bloc/catalog/state/catalog_state.dart';
import '../../framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import '../../framework/bloc/mylearning/events/mylearning_event.dart';
import '../../framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import '../../framework/helpers/ResponsiveWidget.dart';
import '../MyLearning/mylearning_filter.dart';
import '../common/bottomsheet_option_tile.dart';
import '../common/ins_search_textfield.dart';
import '../global_search_screen.dart';

class EventListScreen extends StatefulWidget {
  final String tabId, tabValue;
  final String searchString;
  final bool enableSearching;
  final MyLearningBloc? myLearningBloc;
  final ClassroomEventsController? classroomEventsController;

  const EventListScreen({
    Key? key,
    required this.tabId,
    required this.tabValue,
    this.searchString = "",
    this.enableSearching = true,
    this.myLearningBloc,
    this.classroomEventsController,
  }) : super(key: key);

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> with AutomaticKeepAliveClientMixin {
  late String tabValue;
  late MyLearningBloc myLearningBloc;
  late ClassroomEventsController classroomEventsController;
  late MyLearningDetailsBloc detailsBloc;

  bool pageMounted = false;

  ScrollController _sc = ScrollController();

  late TextEditingController _controller;
  bool enableSearching = true;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context, listen: false);
  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);

  String componentId = "";

  void mySetState() {
    if(!mounted) {
      return;
    }

    if(pageMounted) {
      setState(() {});
    }
    else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    }
  }

  Future<void> getComponentId() async{
    componentId = await sharePrefGetString(sharedPref_ComponentID);
  }

  Future<void> _navigateToGlobalSearchScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GlobalSearchScreen(menuId: 3219)),
    );

    print(result);

    if (result != null) {
      searchEvents(searchString: result is String ? result : null);
    }
  }

  Future<void> _buyProduct(DummyMyCatelogResponseTable2 product) async {
    classroomEventsController.buyClassroomEventEventHandler(context: context, product: product);
  }

  void searchEvents({bool isRefresh = true, String? searchString, String? calenderDate,}) {
    MyPrint.printOnConsole("Searching On ${classroomEventsController.hashCode} Object with isRefresh:$isRefresh");
    classroomEventsController.getTabContent(
      myLearningBloc: myLearningBloc,
      tabVal: tabValue,
      isRefresh: isRefresh,
      searchString: searchString ?? classroomEventsController.searchEventString,
      callenderSelectedDates: calenderDate ?? classroomEventsController.calenderSelecteddates,
      isNotify: mounted && pageMounted,
    );
  }

  bool returnEventCompleted(String eventDate) {
    if (eventDate.isEmpty) return false;

    bool isCompleted = false;

    DateFormat sdf = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime? strDate;
    DateTime? currentdate;

    currentdate = sdf.parse(DateTime.now().toString());

    if (!AppDirectory.isValidString(eventDate)) return false;

    try {
      var temp = DateFormat("yyyy-MM-dd").parse(eventDate.split("T")[0]);
      strDate = sdf.parse(temp.toString());
    }
    catch (e) {
      print("catch");
      isCompleted = false;
    }
    if (strDate == null) {
      return false;
    }

    if (currentdate.isAfter(strDate)) {
      isCompleted = true;
    }
    else {
      isCompleted = false;
    }

    return isCompleted;
  }

  void addExpiryEvets(DummyMyCatelogResponseTable2 table2, int position) {
    //eventModuleBloc.add(AddExpiryEvent(table2: table2, strContentID: table2.contentid));
    classroomEventsController.addExpiryEvents(contentId: table2.contentid);
  }

  void addToWaitList(DummyMyCatelogResponseTable2 catalogModel) async {
    WaitingListResponse? waitingListResponse = await classroomEventsController.waitingList(contentId: catalogModel.contentid);
    if (waitingListResponse?.isSuccess ?? false) {
      MyPrint.printOnConsole("IsSuccess");
      MyToast.showToast(context, waitingListResponse!.message.trim().isNotEmpty ? waitingListResponse.message : "Operation Successful");

      setState(() {
        catalogModel.waitlistenrolls = catalogModel.waitlistenrolls + 1;
        catalogModel.actionwaitlist = '';
      });
    }
    else {
      MyPrint.printOnConsole("Failed");
      MyToast.showToast(context, (waitingListResponse?.message.trim().isNotEmpty ?? false) ? waitingListResponse!.message : "Operation Failed");
    }
  }

  void addToEnroll(DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.availableseats}');

    if (appBloc.uiSettingModel.allowExpiredEventsSubscription == 'true' && returnEventCompleted(table2.eventenddatetime ?? "")) {
      print("in If");

      try {
        addExpiryEvets(table2, 0);
      } catch (e) {
        e.toString();
      }
    }
    else {
      print("in Else");

      int avaliableSeats = 0;
      avaliableSeats = table2.availableseats ?? 0;

      if (avaliableSeats > 0) {
        catalogBloc.add(AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
      else if (table2.viewtype == 1 || table2.viewtype == 2) {
        if (AppDirectory.isValidString(table2.eventenddatetime ?? "") && !returnEventCompleted(table2.eventenddatetime ?? "")) {
          if (AppDirectory.isValidString(table2.actionwaitlist) && table2.actionwaitlist == "true") {
            String alertMessage = appBloc.localstr.eventdetailsenrollementAlertsubtitleEventenrollmentlimit;
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    appBloc.localstr.eventsActionsheetEnrolloption,
                    style: TextStyle(fontWeight: FontWeight.bold,color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),),
                  ),
                  content: Text(alertMessage,style: TextStyle(color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),)),
                  backgroundColor: AppColors.getAppBGColor(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(appBloc
                          .localstr.mylearningAlertbuttonCancelbutton),
                      textColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                          appBloc.localstr.myskillAlerttitleStringconfirm),
                      textColor: Colors.blue,
                      onPressed: () async {
                        Navigator.of(context).pop();
                        addToWaitList(table2);
                      },
                    ),
                  ],
                ),
            );
          }
          else {
            catalogBloc.add(AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
          }
        }
      }
      else {
        catalogBloc.add(AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
    }
  }

  void showTrackCancelEnrollDialog(DummyMyCatelogResponseTable2 table2, String isBadCancel) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          appBloc.localstr.mylearningAlerttitleStringareyousure,
          style: Theme.of(context).textTheme.headline2?.apply(color: AppColors.getAppTextColor(),),
        ),
        content: Text(
          appBloc.localstr.mylearningAlertsubtitleDoyouwanttocancelenrolledevent,
          style: Theme.of(context).textTheme.headline2?.apply(color: AppColors.getAppTextColor()),
        ),
        backgroundColor: AppColors.getAppBGColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        actions: <Widget>[
          FlatButton(
            child: Text(appBloc.localstr.catalogAlertbuttonCancelbutton),
            textColor: AppColors.getAppTextColor(),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
            textColor: Colors.blue,
            onPressed: () async {
              Navigator.of(context).pop();
              cancelTrackEnrollment(table2, isBadCancel);
            },
          ),
        ],
      ),
    );
  }

  Future<void> cancelEnrollment(DummyMyCatelogResponseTable2 table2) async {
    bool isCancelled = await classroomEventsController.cancelEventEnrollment(contentId: table2.contentid);
    showTrackCancelEnrollDialog(table2, isCancelled.toString());
  }

  Future<void> cancelTrackEnrollment(DummyMyCatelogResponseTable2 table2, String isBadCancel) async {
    bool isCancelled = await classroomEventsController.cancelTrackEventEnrollment(contentId: table2.contentid, isBadCancel: isBadCancel);
    if (isCancelled) {
      table2.isaddedtomylearning = 0;
      table2.availableseats = table2.availableseats + 1;
      mySetState();
      MyToast.showToast(context, 'Your enrollment for the course has been successfully canceled');
    }
  }

  void _settingMyEventBottomSheet(BuildContext context, DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.viewtype}');

    bool menu0 = false;
    bool menu1 = false;
    bool menu2 = false;
    bool menu3 = false;
    bool menu4 = false;
    bool menu5 = false;
    bool menu6 = false;
    bool menu7 = false;

    // String menu1Title = appBloc.localstr.eventsActionsheetEnrolloption;
    String menu1Title = "Enroll Now";
    print("relatedconentcount ${table2.relatedconentcount}");
    print("isaddedtomylearning ${table2.isaddedtomylearning}");
    if (table2.isaddedtomylearning == 1) {
      if (table2.relatedconentcount != 0) {
        menu0 = true;
      }

      menu1 = false;
      menu2 = false;
      menu3 = true;
      menu4 = true;
    }
    else {
      if (table2.viewtype == 1) {
        menu0 = false;
        menu2 = false;
        menu3 = true;
        menu4 = false; //cancel enrollment

        print('actionwaitlist ${table2.viewtype} ${table2.actionwaitlist}');

        if (AppDirectory.isValidString(table2.eventenddatetime ?? "") && !returnEventCompleted(table2.eventenddatetime ?? "")) {
          if (AppDirectory.isValidString(table2.actionwaitlist) && table2.actionwaitlist == "true") {
            menu1 = true;
            menu1Title = appBloc.localstr.eventsActionsheetWaitlistoption;
          }
          else if (table2.availableseats > 0) {
            menu1 = true;
          }
        }
        else {
          if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
            menu1 = true;
          } else {
            // btnsLayout.setVisibility(View.GONE ;
            menu1 = true;
          }
        }
      }
      else if (table2.viewtype == 2) {
        menu0 = false;
        menu1 = false;
        menu3 = true;
        if (table2.eventscheduletype == 2) {
          menu1 = false;
        }
        if (AppDirectory.isValidString(table2.eventenddatetime ?? "") && !returnEventCompleted(table2.eventenddatetime ?? "")) {
          if (AppDirectory.isValidString(table2.actionwaitlist) && table2.actionwaitlist == "true") {
            menu1 = true;
            menu1Title = appBloc.localstr.eventsActionsheetWaitlistoption;
          }
          else if (table2.availableseats > 0) {
            menu1 = true;
          }
        }
        else if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true" && returnEventCompleted(table2.eventenddatetime ?? "")) {
          menu1 = false;
        }
      }
      else if (table2.viewtype == 3) {
        menu0 = false;
        menu3 = true;
        menu1 = false;
        menu2 = true;
      }
    }
    print("isaddedtomylearning upendra ${table2.isaddedtomylearning}");
    if (table2.isaddedtomylearning == 0 || table2.isaddedtomylearning == 2) {
      if (table2.iswishlistcontent == 1) {
        menu6 = true; //removeWishListed
      } else {
        menu5 = true; //isWishListed
      }
    } else if (table2.isaddedtomylearning == 1) {
      menu5 = false;
      menu6 = false;
    }

    print("isaddedtomylearning om ${table2.isaddedtomylearning}");
    print("returnEventCompleted om ${returnEventCompleted(table2.eventenddatetime ?? "")}");
    print("AllowExpiredEventsSubscription om ${appBloc.uiSettingModel.allowExpiredEventsSubscription}");

    if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true" &&
        returnEventCompleted(table2.eventenddatetime ?? "")) {
      if (table2.isaddedtomylearning != 1) {
        if (table2.viewtype == 2) {
          if (table2.availableseats > 0) {
            menu7 = true;
          }
        }
      }
    }
    // expired event functionality
    if (AppDirectory.isValidString(table2.eventenddatetime ?? "") && returnEventCompleted(table2.eventenddatetime ?? "")) {
      if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
        if (table2.isaddedtomylearning == 1) {
          if (table2.relatedconentcount != 0) {
            menu0 = true;
            menu1 = false; //enroll
          }
        } else {
          if (table2.viewtype == 2) {
            // menu1 = true; //enroll

          }
        }

//               menu0 =true ;//view

        menu2 = false; //buy
        menu3 = true; //detail
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
      context: context,
      shape: AppConstants().bottomSheetShapeBorder(),
      builder: (BuildContext bc) {
        return AppConstants().bottomSheetContainer(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const BottomSheetDragger(),
                menu0
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          AppController().checkRelatedContent(context: context, table2: table2, isTrackList: false);
                        },
                        title: appBloc.localstr.eventsActionsheetRelatedcontentoption,
                        iconData: Icons.content_copy,
                      )
                    : Container(),
                menu1
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          addToEnroll(table2);
                        },
                        title: menu1Title,
                        iconData: IconDataSolid(int.parse('0xf271')),
                      )
                    : Container(),
                menu2
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          _buyProduct(table2);
                        },
                        title: appBloc.localstr.eventsActionsheetBuynowoption,
                        iconData: IconDataSolid(int.parse('0xf53d')),
                      )
                    : Container(),
                menu3
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          NavigationController().navigateToCommonDetailsScreen(
                            context: context,
                            table2: table2,
                            detailsBloc: detailsBloc,
                            isFromReschedule: false,
                            screenType: ScreenType.Events,
                          );
                        },
                        title: appBloc.localstr.eventsActionsheetDetailsoption,
                        iconData: IconDataSolid(int.parse('0xf570')),
                      )
                    : Container(),
                menu4
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          if (table2.isbadcancellationenabled) {
                            cancelEnrollment(table2);
                          }
                          else {
                            showTrackCancelEnrollDialog(table2, "false");
                          }
                        },
                        title: appBloc.localstr.eventsActionsheetCancelenrollmentoption,
                        iconData: IconDataSolid(int.parse('0xf410')),
                      )
                    : Container(),
                menu5
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          catalogBloc.add(AddToWishListEvent(contentId: table2.contentid));
                        },
                        title: appBloc.localstr.catalogActionsheetWishlistoption,
                        iconData: IconDataSolid(int.parse('0xf004')),
                      )
                    : Container(),
                menu6
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          catalogBloc.add(RemoveFromWishListEvent(contentId: table2.contentid));
                        },
                        title: appBloc.localstr.catalogActionsheetRemovefromwishlistoption,
                        iconData: IconDataSolid(int.parse('0xf004')),
                      )
                    : Container(),
                menu7
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          try {
                            addExpiryEvets(table2, 0);
                          }
                          catch (e) {
                            e.toString();
                          }
                        },
                        title: appBloc.localstr.catalogActionsheetAddtomylearningoption,
                        iconData: Icons.add_circle,
                      )
                    : Container(),
                /*(table2.suggesttoconnlink != null)
                    ? (table2.suggesttoconnlink.isNotEmpty)
                        ? */
                getListTile(
                  onTap: () async {
                    Navigator.of(context).pop();
                    NavigationController().navigateToShareWithConnectionsScreen(
                      context: context,
                      isFromForum: false,
                      isFromQuesion: false,
                      contentId: table2.contentid,
                      contentName: table2.name,
                    );
                  },
                  title: AppStrings.share_with_connection,
                  iconData: IconDataSolid(int.parse('0xf1e0')),
                ),
                getListTile(
                  onTap: () async {
                    Navigator.of(context).pop();
                    NavigationController().navigateToShareMainScreen(
                      context: context,
                      isPeople: true,
                      isFromForum: false,
                      isFromQuestion: false,
                      contentId: table2.contentid,
                      contentName: table2.name,
                    );
                  },
                  title: AppStrings.share_with_people,
                  iconData: IconDataSolid(int.parse('0xf079')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getListTile({required String title, IconData? iconData, Color? iconColor, Color? textColor, required Future<void> Function() onTap}) {
    return BottomsheetOptionTile(
       text: title,
        iconData:iconData ?? Icons.add_circle,
        onTap: () {
          onTap();
        },
    );
  }

  List<Meeting> _getDataSource() {
    List<Meeting> meetings = <Meeting>[];

    classroomEventsController.mainEventsList.forEach((element) {
      //final DateTime today = DateTime.now();

      if(classroomEventsController.mainMapOfEvents[element] != null) {
        DummyMyCatelogResponseTable2 event = classroomEventsController.mainMapOfEvents[element]!;

        DateTime startTime = DateTime.now();

        try {
          //print("Date:${element.eventstartdatedisplay}");
          if((event.eventstartdatedisplay?.toString() ?? "").isNotEmpty) startTime = DateFormat("yyyy-MM-ddThh:mm:ss").parse(event.eventstartdatedisplay);
        }
        catch(e, s) {
          print("Error in Date Format Parsing:$e");
          print(s);
        }

        //final DateTime endTime = startTime.add(Duration(hours: 2));
        meetings.add(Meeting(
          "${event.name}",
          startTime,
          startTime,
          AppColors.getAppButtonBGColor(),
          false,
        ));
      }
    });
    return meetings;
  }

  @override
  void initState() {
    MyPrint.printOnConsole("EventListScreen Init Called With Tab:${widget.tabValue}");

    getComponentId();

    tabValue = widget.tabValue;

    if(widget.myLearningBloc != null) {
      myLearningBloc = widget.myLearningBloc!;
    }
    else {
      myLearningBloc = MyLearningBloc(myLearningRepository: MyLearningRepositoryBuilder.repository());
      myLearningBloc.add(ResetFilterEvent());
      myLearningBloc.add(GetFilterMenus(
        listNativeModel: appBloc.listNativeModel,
        localStr: appBloc.localstr,
        moduleName: "Training Events",
      ));
      myLearningBloc.add(GetSortMenus("153"));
    }

    detailsBloc = MyLearningDetailsBloc(myLearningRepository: MyLearningRepositoryBuilder.repository());

    _controller = TextEditingController(text: widget.searchString);
    enableSearching = widget.enableSearching;

    if(widget.classroomEventsController != null) {
      classroomEventsController = widget.classroomEventsController!;
      if(classroomEventsController.listOfEventsToShow.isEmpty) {
        searchEvents();
      }
    }
    else {
      classroomEventsController = ClassroomEventsController(searchString: widget.searchString, mainMapOfEvents: {});
      searchEvents();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant EventListScreen oldWidget) {
    bool isUpdated = false;
    if(widget.tabValue != oldWidget.tabValue) {
      isUpdated = true;
      tabValue = widget.tabValue;
      _controller.text = "";
    }
    if(widget.searchString != oldWidget.searchString) {
      isUpdated = true;
      _controller.text = widget.searchString;
    }
    if(widget.enableSearching != oldWidget.enableSearching) {
      isUpdated = true;
      enableSearching = widget.enableSearching;
      _controller.text = widget.enableSearching ? _controller.text : "";
    }

    if(isUpdated) {
      searchEvents();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    MyPrint.printOnConsole("EventListScreen Dispose Called With Tab:${widget.tabValue}");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    pageMounted = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pageMounted = true;
    });

    MyPrint.printOnConsole("ClassroomEventsController Consumer Called");

    //MyPrint.printOnConsole("TabId:${widget.tabId}, TabValue:${widget.tabValue}");

    return BlocConsumer<CatalogBloc, CatalogState>(
      bloc: catalogBloc,
      listener: (context, catalogstate) {
        //print("Status:${state.status}, State:${state.runtimeType}");

        if (catalogstate is AddToWishListState || catalogstate is RemoveFromWishListState) {
          if (catalogstate.status == Status.COMPLETED) {
            //evntModuleBloc.isFirstLoading = true;

            //(state as AddToWishListState).contentId
            searchEvents();
            if (catalogstate is AddToWishListState) {
              MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleItemaddedtowishlistsuccesfully);
              appBloc.add(WishlistCountEvent());
            }
            if (catalogstate is RemoveFromWishListState) {
              MyToast.showToast(context, appBloc.localstr.catalogActionsheetRemovefromwishlistoption);
              appBloc.add(WishlistCountEvent());
            }
          }
        }
        else if (catalogstate is AddToMyLearningState) {
          if (catalogstate.status == Status.COMPLETED) {
            MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);

            setState(() {
              catalogstate.table2.isaddedtomylearning = 1;
              catalogstate.table2.availableseats = catalogstate.table2.availableseats - 1;
            });

            searchEvents();
          }
        }
        else if(catalogstate is SaveInAppPurchaseState) {
          if (AppDirectory.isValidString(catalogstate.response) && catalogstate.response.contains('success')) {
            MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);

            searchEvents();
          }
        }
      },
      builder: (context, catalogstate) {
        return ChangeNotifierProvider<ClassroomEventsController>.value(
          value: classroomEventsController,
          child: Consumer(
            builder: (BuildContext context, ClassroomEventsController controller, Widget? child) {
              MyPrint.printOnConsole("ClassroomEventsController Consumer Called");

              return ModalProgressHUD(
                inAsyncCall: classroomEventsController.isLoading || catalogstate.status == Status.LOADING,
                progressIndicator: getCommonLoading(color: AppColors.getAppButtonBGColor()),
                child: Container(
                  child: Scaffold(
                    body: Column(
                      children: [
                        getSearchTextField(classroomEventsController),
                        Expanded(
                          child: getEventsListViewWidget(classroomEventsController),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget getSearchTextField(ClassroomEventsController classroomEventsController) {
    if(!enableSearching) {
      return const SizedBox();
    }

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InsSearchTextField(
          onTapAction: () {
            if (appBloc.uiSettingModel.isGlobalSearch == 'true') {
              _navigateToGlobalSearchScreen(context);
            }
          },
          controller: _controller,
          appBloc: appBloc,
          suffixIcon: classroomEventsController.searchEventString.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    searchEvents(isRefresh: true, searchString: "");
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyLearningFilter(componentId: componentId,)));

                    searchEvents(isRefresh: true,);
                  },
                  icon: Icon(Icons.tune, color: AppColors.getAppTextColor()),
                ),
          onSubmitAction: (String value) {
            searchEvents();
          },
        ),
    );
  }

  Widget getEventsListViewWidget(ClassroomEventsController classroomEventsController) {
    MyPrint.printOnConsole("Object in Event List Screen:${classroomEventsController.hashCode}");

    return RefreshIndicator(
      color: AppColors.getAppButtonBGColor(),
      onRefresh: () async {
        searchEvents(isRefresh: true);
      },
      child: ResponsiveWidget(
        mobile: ListView(
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            getCalenderWidget(classroomEventsController),
            ...getEventsListWidgets(classroomEventsController),
          ],
        ),
        tab: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width / 960,
          ),
          controller: _sc,
          scrollDirection: Axis.vertical,
          children: getEventsListWidgets(classroomEventsController).toList(),
        ),
        web: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
          ),
          controller: _sc,
          scrollDirection: Axis.vertical,
          children: getEventsListWidgets(classroomEventsController).toList(),
        ),
      ),
    );
  }

  Iterable<Widget> getEventsListWidgets(ClassroomEventsController classroomEventsController) sync* {
    if (classroomEventsController.isFirstLoading) {
      yield getCommonLoading();
    }
    else if(classroomEventsController.listOfEventsToShow.isEmpty) {
      yield getNoEventsFoundWidget2();
    }
    else {
      for(int index = 0; index < (classroomEventsController.listOfEventsToShow.length + 1); index++) {
        if((classroomEventsController.listOfEventsToShow.isEmpty && index == 0) || index == classroomEventsController.listOfEventsToShow.length) {
          //return Shimmer
          if(classroomEventsController.isLoadingEvents) {
            yield SizedBox(
              height: 100,
              child: getCommonLoading(),
            );
          }
          else {
            yield const SizedBox();
          }
        }
        else {
          // yield widgetMyEventItems(classroomEventsController.listOfEventsToShow[index]);
          DummyMyCatelogResponseTable2? event = classroomEventsController.mainMapOfEvents[classroomEventsController.listOfEventsToShow[index]];
          if(event != null) {
            yield ClassroomEventCard(
              table2: event,
              tabVal: widget.tabValue,
              classroomEventCardType: ["Calendar-Schedule"].contains(widget.tabId) ? ClassroomEventCardType.SCHEDULE : ClassroomEventCardType.NORMAL,
              detailsBloc: detailsBloc,
              onMoreTap: _settingMyEventBottomSheet,
              onBuyTap: _buyProduct,
              onEnrollTap: addToEnroll,
              onViewTap: (DummyMyCatelogResponseTable2 table2) {
                NavigationController().navigateToCommonDetailsScreen(
                  context: context,
                  table2: table2,
                  detailsBloc: detailsBloc,
                  isFromReschedule: false,
                  screenType: ScreenType.Events,
                );
              },
            );
          }
        }
      }
    }
  }

  Widget getCalenderWidget(ClassroomEventsController classroomEventsController) {
    if(widget.tabValue != "calendar") {
      return const SizedBox();
    }

    MyPrint.printOnConsole("classroomEventsController.calenderSelecteddates:${classroomEventsController.calenderSelecteddates}");

    return Container(
      color: AppColors.getAppHeaderColor(),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SizedBox(
          height: 250.h,
          child: SfCalendar(
            backgroundColor: AppColors.getAppBGColor(),
            view: CalendarView.month,
            allowViewNavigation: true,
            showNavigationArrow: true,
            cellBorderColor: Colors.transparent,
            dataSource: MeetingDataSource(_getDataSource()),
            monthViewSettings: MonthViewSettings(
              monthCellStyle: MonthCellStyle(
                textStyle: Theme.of(context).textTheme.bodyText1?.apply(color: AppColors.getAppTextColor()),
                leadingDatesTextStyle: Theme.of(context).textTheme.bodyText2?.apply(color: AppColors.getAppTextColor().withOpacity(0.5)),
                trailingDatesTextStyle: Theme.of(context).textTheme.bodyText2?.apply(color: AppColors.getAppTextColor().withOpacity(0.5)),
                // backgroundColor:
                //     Color(int.parse(
                //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
              ),
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
            onTap: (CalendarTapDetails value) {
              classroomEventsController.applyFilterOnEventsByDate(startDate: value.date.toString().split(" ")[0]);
            },
            onViewChanged: (ViewChangedDetails ee) {
              MyPrint.printOnConsole("onViewChanged called:${ee.visibleDates}");
              String startdate = "${ee.visibleDates[10].year}-${ee.visibleDates[10].month}-01";
              String enddate = "${ee.visibleDates[10].year}-${ee.visibleDates[10].month}-30";
              MyPrint.printOnConsole("$startdate ~ $enddate");

              if (classroomEventsController.calenderSelecteddates.isEmpty|| classroomEventsController.calenderSelecteddates != "$startdate ~ $enddate") {
                searchEvents(calenderDate: "$startdate ~ $enddate");
              }
            },
            headerStyle: CalendarHeaderStyle(
              textStyle: Theme.of(context).textTheme.headline1?.apply(color: AppColors.getAppTextColor()),
              textAlign: TextAlign.center,
              backgroundColor: AppColors.getAppBGColor(),


            ),
          ),
        ),
      ),
    );
  }

  Widget getLoadingWidget() {
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

  Widget getNoEventsFoundWidget(){
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.h,
            ),
            Text(
              "No Data Found",
              style: TextStyle(
                color: AppColors.getAppTextColor(),
                fontSize: 24,
              )
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        )
      ],
    );
  }

  Widget getNoEventsFoundWidget2(){
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      shrinkWrap: true,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.h,
            ),
            Text(
              "No Data Found",
              style: TextStyle(
                color: AppColors.getAppTextColor(),
                fontSize: 24,
              )
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
  // bool get wantKeepAlive => false;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments?[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments?[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments?[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments?[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments?[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}