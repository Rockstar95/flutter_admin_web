import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/ui/Events/event_main_page.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/bottomsheet_drager.dart';
import 'package:flutter_admin_web/ui/common/common_widgets.dart';
import 'package:flutter_admin_web/ui/common/modal_progress_hud.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import '../../framework/bloc/mylearning/events/mylearning_event.dart';
import '../../framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import '../../framework/helpers/ResponsiveWidget.dart';
import '../../packages/smooth_star_rating.dart';
import '../MyLearning/mylearning_filter.dart';
import '../common/ins_search_textfield.dart';
import '../global_search_screen.dart';

class EventListScreen extends StatefulWidget {
  final String tabValue;
  final String searchString;
  final bool enableSearching;
  final MyLearningBloc? myLearningBloc;
  final ClassroomEventsController? classroomEventsController;

  const EventListScreen({
    Key? key,
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

  ScrollController _sc = new ScrollController();

  late TextEditingController _controller;
  bool enableSearching = true;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context, listen: false);

  String componentId = "";

  Future<void> getComponentId() async{
    componentId = await sharePrefGetString(sharedPref_ComponentID);
  }

  Future<void> _navigateToGlobalSearchScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GlobalSearchScreen(menuId: 3219)),
    );

    print(result);

    if (result != null) {
      searchEvents(searchString: result is String ? result : null);
    }
  }

  String checkAvailableSeats(DummyMyCatelogResponseTable2 table2) {
    int avaliableSeats = 0;
    String seatVal = "";

    try {
      avaliableSeats = table2.availableseats;
    } catch (nf) {
      avaliableSeats = 0;
      //nf.printStackTrace();
    }
    if (avaliableSeats > 0) {
      seatVal = 'Available seats ${table2.availableseats}';
    } else if (avaliableSeats <= 0) {
      if (table2.enrollmentlimit == table2.noofusersenrolled &&
              table2.waitlistlimit == 0 ||
          (table2.waitlistlimit != -1 &&
              table2.waitlistlimit == table2.waitlistenrolls)) {
        seatVal = 'Enrollment Closed';
      } else if (table2.waitlistlimit != -1 &&
          table2.waitlistlimit != table2.waitlistenrolls) {
        int waitlistSeatsLeftout =
            (table2.waitlistlimit ?? 0) - (table2.waitlistenrolls);

        if (waitlistSeatsLeftout > 0) {
          seatVal = 'Full | Waitlist seats $waitlistSeatsLeftout';
        }
      }
    }

    return seatVal;
  }

  Future<void> _buyProduct(DummyMyCatelogResponseTable2 product) async {
    classroomEventsController.buyClassroomEventEventHandler(context: context, product: product);
  }

  void searchEvents({bool isRefresh = true, String? searchString, String? calenderDate,}) {
    MyPrint.printOnConsole("Searching On ${classroomEventsController.hashCode} Object with isRefresh:$isRefresh");
    classroomEventsController.getTabContentEventHandler(
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

    DateFormat sdf = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime? strDate;
    DateTime? currentdate;

    currentdate = sdf.parse(DateTime.now().toString());

    if (!AppDirectory.isValidString(eventDate)) return false;

    try {
      var temp = new DateFormat("yyyy-MM-dd").parse(eventDate.split("T")[0]);
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
        //catalogBloc.add(AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
      else if (table2.viewtype == 1 || table2.viewtype == 2) {
        if (AppDirectory.isValidString(table2.eventenddatetime ?? "") && !returnEventCompleted(table2.eventenddatetime ?? "")) {
          if (AppDirectory.isValidString(table2.actionwaitlist) && table2.actionwaitlist == "true") {
            String alertMessage = appBloc.localstr
                .eventdetailsenrollementAlertsubtitleEventenrollmentlimit;
            showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                      title: Text(
                        appBloc.localstr.eventsActionsheetEnrolloption,
                        style: TextStyle(fontWeight: FontWeight.bold,color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),),
                      ),
                      content: Text(alertMessage,style: TextStyle(color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),)),
                      backgroundColor: AppColors.getAppBGColor(),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5)),
                      actions: <Widget>[
                        new FlatButton(
                          child: Text(appBloc
                              .localstr.mylearningAlertbuttonCancelbutton),
                          textColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: Text(
                              appBloc.localstr.myskillAlerttitleStringconfirm),
                          textColor: Colors.blue,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            //addToWaitList(table2);
                          },
                        ),
                      ],
                    ));
          }
          else {
            //catalogBloc.add(AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
          }
        }
//        (isValidString(table2.actionwaitlist) &&
//            table2.actionwaitlist == "true")

      }
      else {
        //catalogBloc.add(AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
    }
  }

  void _settingMyEventBottomSheet(
      BuildContext context, DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.viewtype}');

    bool menu0 = false;
    bool menu1 = false;
    bool menu2 = false;
    bool menu3 = false;
    bool menu4 = false;
    bool menu5 = false;
    bool menu6 = false;
    bool menu7 = false;

    String menu1Title = appBloc.localstr.eventsActionsheetEnrolloption;
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
      builder: (BuildContext bc) {
        return Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                BottomSheetDragger(),
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
                            //badCancelEnrollmentMethod(table2);

                            // bad cancel
                          }
                          else {
                            //showCancelEnrollDialog(table2, table2.isbadcancellationenabled.toString());
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
                          //catalogBloc.add(AddToWishListEvent(contentId: table2.contentid));
                        },
                        title: appBloc.localstr.catalogActionsheetWishlistoption,
                        iconData: IconDataSolid(int.parse('0xf004')),
                      )
                    : Container(),
                menu6
                    ? getListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          //catalogBloc.add(RemoveFromWishListEvent(contentId: table2.contentid));
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
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.getAppTextColor(),
        ),
      ),
      leading: Icon(
        Icons.add_circle,
        color: iconColor ?? AppColors.getAppTextColor(),
      ),
      onTap: () {
        onTap();
      },
    );
  }

  List<Meeting> _getDataSource() {
    List<Meeting> meetings = <Meeting>[];

    classroomEventsController.mainEventsList.forEach((element) {
      //final DateTime today = DateTime.now();

      DateTime startTime = DateTime.now();

      try {
        //print("Date:${element.eventstartdatedisplay}");
        if((element.eventstartdatedisplay?.toString() ?? "").isNotEmpty) startTime = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(element.eventstartdatedisplay);
      }
      catch(e, s) {
        print("Error in Date Format Parsing:$e");
        print(s);
      }

      //final DateTime endTime = startTime.add(Duration(hours: 2));
      meetings.add(Meeting(
          "${element.name}",
          startTime,
          startTime,
          Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          false));
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
      classroomEventsController = ClassroomEventsController(searchString: widget.searchString);
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

    return ChangeNotifierProvider<ClassroomEventsController>.value(
      value: classroomEventsController,
      child: Consumer(
        builder: (BuildContext context, ClassroomEventsController controller, Widget? child) {
          MyPrint.printOnConsole("ClassroomEventsController Consumer Called");

          return ModalProgressHUD(
            inAsyncCall: classroomEventsController.isLoading,
            progressIndicator: SpinKitCircle(color: AppColors.getAppButtonBGColor(),),
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
  }

  Widget getSearchTextField(ClassroomEventsController classroomEventsController) {
    if(!enableSearching) {
      return SizedBox();
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
                  icon: Icon(
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

    /*int length = 0;
    if()*/

    return RefreshIndicator(
      color: AppColors.getAppButtonBGColor(),
      onRefresh: () async {
        searchEvents(isRefresh: true);
      },
      child: ResponsiveWidget(
        mobile: ListView(
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            getCalenderWidget(classroomEventsController),
            ...getEventsListWidgets(classroomEventsController),
          ],
        ),
        tab: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width / 960,
          ),
          controller: _sc,
          scrollDirection: Axis.vertical,
          itemCount: classroomEventsController.listOfEventsToShow.length,
          itemBuilder: (context, i) {
            /*if (classroomEventBloc.list.length == 0) {
              if (state.status == Status.LOADING &&
                  state is GetTabContentState) {
//                        print("gone in _buildProgressIndicator");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: 1.0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else {

            }*/

            return widgetMyEventItems(classroomEventsController.listOfEventsToShow[i]);
          },
        ),
        web: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: MediaQuery.of(context).size.width / 960,
          ),
          controller: _sc,
          scrollDirection: Axis.vertical,
          itemCount: classroomEventsController.listOfEventsToShow.length,
          itemBuilder: (context, i) {
            /*if (classroomEventBloc.list.length == 0) {
              if (state.status == Status.LOADING &&
                  state is GetTabContentState) {
//                        print("gone in _buildProgressIndicator");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: 1.0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else {

            }*/

            return widgetMyEventItems(classroomEventsController.listOfEventsToShow[i]);
          },
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
            yield SizedBox();
          }
        }
        else {
          yield widgetMyEventItems(classroomEventsController.listOfEventsToShow[index]);
        }
      }
    }
  }

  Widget widgetMyEventItems(DummyMyCatelogResponseTable2 table2) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl = "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
    //print("Id:${table2.contentid}, isWishlist:${table2.iswishlistcontent}");

    bool isratingbarVissble = false;
    bool isReviewVissble = false;

    double ratingRequired = 0;
    String availableSeat = '';

    availableSeat = checkAvailableSeats(table2);

    try {
      ratingRequired = double.parse(appBloc.uiSettingModel.minimumRatingRequiredToShowRating);
    }
    catch (e) {
      ratingRequired = 0;
    }

    if (table2.totalratings >= int.parse(appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating) && table2.ratingid >= ratingRequired) {
      isReviewVissble = false;
      isratingbarVissble = true;
    }

    DateTime startTempDate = DateTime.now();

    try {
      //print("Date:${table2.eventstartdatedisplay}");
      if((table2.eventstartdatedisplay?.toString() ?? "").isNotEmpty) startTempDate = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(table2.eventstartdatedisplay);
    }
    catch(e, s) {
      print("Error in Date Format Parsing:$e");
      print(s);
    }

    DateTime endTempDate = DateTime.now();

    try {
      //print("Date:${table2.eventenddatedisplay}");
      if((table2.eventenddatedisplay?.toString() ?? "").isNotEmpty) endTempDate = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(table2.eventenddatedisplay);
    }
    catch(e, s) {
      print("Error in Date Format Parsing:$e");
      print(s);
    }

    String startDate = DateFormat("MM/dd/yyyy hh:mm:ss a").format(startTempDate);
    String endDate = DateFormat("MM/dd/yyyy hh:mm:ss a").format(endTempDate);

    String thumbnailPath = table2.thumbnailimagepath.startsWith("http")
        ? table2.thumbnailimagepath.trim()
        : table2.siteurl + table2.thumbnailimagepath.trim();

    String contentIconPath = table2.iconpath;

    if (AppDirectory.isValidString(appBloc.uiSettingModel.azureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? table2.iconpath
          : appBloc.uiSettingModel.azureRootPath + table2.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    }
    else {
      contentIconPath = table2.siteurl + contentIconPath;
    }

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: Card(
        color: AppColors.getAppBGColor(),
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
                      /*if (menu0) {
                        checkRelatedContent(table2);
                      }
                      else if (menu3) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ProviderModel(),
                              child: CommonDetailScreen(
                                screenType: ScreenType.Events,
                                contentid: table2.contentid,
                                objtypeId: table2.objecttypeid,
                                detailsBloc: detailsBloc,
                                table2: table2,
                                isFromReschedule: false,
                              ),
                            ),
                        ));
                      }*/
                    },
                    child: CachedNetworkImage(
                      imageUrl: thumbnailPath,
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
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/cellimage.jpg',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
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
                            )),
                      )),
                ),
              ],
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
                              table2.description,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Text(
                              table2.name,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //_settingMyEventBottomSheet(context, table2);
                        },
                        child: Icon(
                          Icons.more_vert,
                          color: AppColors.getAppTextColor(),
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
                        table2.authordisplayname,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                .withOpacity(0.5)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(5),
                      ),
                      Container(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        height: 10.h,
                        width: 1.h,
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(5),
                      ),
                      Text(availableSeat,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                .withOpacity(0.5),
                          ))
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
                              size: ScreenUtil().setHeight(16),
                              // filledIconData: Icons.blur_off,
                              // halfFilledIconData: Icons.blur_on,
                              color: Colors.orange,
                              borderColor: Colors.orange,
                              spacing: 0.0)
                          : Container(),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      isReviewVissble
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  /*Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ReviewScreen(
                                          table2.contentid,
                                          false,
                                          myLearningDetailsBloc)));*/
                                },
                                child: Text(
                                  "See Reviews".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(12),
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      /*QrImage(
                        data: "1234567890",
                        version: QrVersions.auto,
                        size: 70.h,
                      ),*/
                    ],
                  ),
                  AppDirectory.isValidString(table2.shortdescription)
                      ? SizedBox(
                          height: ScreenUtil().setHeight(10),
                        )
                      : Container(),
                  Text(
                    table2.shortdescription,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(13),
                        color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                            .withOpacity(0.5)),
                  ),
                  AppDirectory.isValidString(table2.shortdescription)
                      ? SizedBox(
                          height: ScreenUtil().setHeight(10),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Start Date :  ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: AppColors.getAppTextColor().withOpacity(0.8),
                          ),
                        ),
                        Text(
                          startDate.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "End Date :    ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: AppColors.getAppTextColor().withOpacity(0.8),
                          ),
                        ),
                        Text(
                          endDate.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Time Zone : ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: AppColors.getAppTextColor().withOpacity(0.8),
                          ),
                        ),
                        Text(
                          table2.timezone ?? "",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Location :     ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: AppColors.getAppTextColor().withOpacity(0.8),
                          ),
                        ),
                        Text(
                          table2.locationname,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
                  ),
                  (table2.viewtype == 3 && table2.isaddedtomylearning == 0)
                      ? Row(
                          children: <Widget>[
                            // commented till offline integration done
                            Text(
                              " ${table2.saleprice} \$",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.normal,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(140),
                            ),
                            buyOption(table2),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buyOption(DummyMyCatelogResponseTable2 table2) {
    return Expanded(
      child: FlatButton.icon(
        color: AppColors.getAppButtonBGColor(),
        icon: Icon(
          IconDataSolid(int.parse('0x${"f155"}')),
          color: AppColors.getAppButtonTextColor(),
        ),
        label: Text(
          appBloc.localstr.detailsButtonBuybutton.toUpperCase(),
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            color: AppColors.getAppButtonTextColor(),
          ),
        ),
        onPressed: () async {
          //  buy functionlaity here
          _buyProduct(table2);
        },
      ),
    );
  }

  Widget getCalenderWidget(ClassroomEventsController classroomEventsController) {
    if(widget.tabValue != "calendar") {
      return SizedBox();
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
              textAlign:
              TextAlign.center,
              backgroundColor: AppColors.getAppBGColor(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getLoadingWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getNoEventsFoundWidget(){
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 30),
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
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 30),
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
}
