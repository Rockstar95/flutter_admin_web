import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/people_listing_tab.dart';
import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/Events/event_main_page.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/models/EventResourcePlusResponse.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../configs/constants.dart';
import '../../../../framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import '../../../../framework/repository/mylearning/mylearning_repositry_builder.dart';
import '../../../common/bottomsheet_drager.dart';
import '../../../common/bottomsheet_option_tile.dart';
import '../../../global_search_screen.dart';
import '../../common_detail_screen.dart';
import '../../helper/gotoCourseLaunchContenisolation.dart';
import '../../review_screen.dart';

class DashboardCalendarScreen extends StatefulWidget {
  final List<EventResourcePlusResponse> getEventresourcelist;
  final BuildContext myLearningPlusContext;

  const DashboardCalendarScreen({required this.getEventresourcelist,required this.myLearningPlusContext});

  @override
  DashboardCalendar createState() => DashboardCalendar();
}

class DashboardCalendar extends State<DashboardCalendarScreen> with TickerProviderStateMixin {
  late FToast flutterToast;
  // CalendarController _calendarController;
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  String tabValue = 'upcoming';
  late EvntModuleBloc eventModuleBloc;
  final _controller = ScrollController();
  ScrollController _sc = ScrollController();
  bool isGetListEvent = false;
  int selectedIndex = 0;
  int pageNumber = 1;
  late MyLearningDetailsBloc detailsBloc;
  DateTime? selectedDateInCalender = DateTime.now();
  late AnimationController animationController;
  final _selectedDay = DateTime.now();
  var myLearningRepository;

  // late Map<DateTime, List> _events;
  // late Map<DateTime, List<DateTime>> _holidays;
  late Map<DateTime, List<dynamic>> _filteredEvents;
  String typeFrom = '';

  final DateFormat formatter = DateFormat('mm/dd/yyyy hh:mm a');

  @override
  void initState() {
    myLearningBloc.add(ResetFilterEvent());
    myLearningBloc.add(GetFilterMenus(
        listNativeModel: appBloc.listNativeModel,
        localStr: appBloc.localstr,
        moduleName: "Training Events"));
    myLearningBloc.add(GetSortMenus("153"));
    eventModuleBloc = EvntModuleBloc(
        eventModuleRepository: EventRepositoryBuilder.repository());

    eventModuleBloc.add(GetPeopleListingTab());

    detailsBloc = MyLearningDetailsBloc(myLearningRepository: MyLearningRepositoryBuilder.repository());

    // _calendarController = CalendarController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 400),
    );
    animationController.forward();

    //_events = {};
    _filteredEvents = {};
    //_holidays = {};

    for (EventResourcePlusResponse item in widget.getEventresourcelist) {
      DateTime dateTime =
          DateFormat('yyyy-MM-ddThh:mm:ss').parse(item.start); //'mm/dd/yyyy hh:mm:ss a'
      _filteredEvents[_selectedDay.subtract(Duration(days: dateTime.day))] = [
        item
      ];
    }

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        print("Last Postion");
        if (isGetListEvent &&
            eventModuleBloc.listTotalCount > eventModuleBloc.list.length) {
          setState(() {
            isGetListEvent = false;
          });
          eventModuleBloc.add(GetTabContent(
              tabVal: tabValue,
              searchString: DateTime.now().toString(),
              myLearningBloc: myLearningBloc,
              pageIndex: pageNumber));
        }
      }
    });
    eventModuleBloc.add(GetTabContent(
        tabVal: tabValue,
        searchString: DateTime.now().toString(),
        myLearningBloc: myLearningBloc,
        pageIndex: 1,
    ));

    Future.delayed(const Duration(seconds: 4), () {
      eventModuleBloc.add(GetCalanderFilterListContent(
      startDate: DateTime.now().toString().split(" ")[0]));
    });

    // String ss = "";
    super.initState();
  }

  // DateTime _chosenDate = DateTime.now();

  @override
  void dispose() {
    // _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              'Calendar',
              style: TextStyle(color: Colors.black),
            ),

            // Container(
            //   //color: Colors.blue,
            //   child: TableCalendar(
            //     events: _filteredEvents,
            //     headerVisible: true,
            //     daysOfWeekStyle: DaysOfWeekStyle(
            //       weekendStyle: TextStyle().copyWith(color: Colors.green[600]),
            //     ),
            //     initialCalendarFormat: CalendarFormat.month,
            //     formatAnimation: FormatAnimation.slide,
            //     availableGestures: AvailableGestures.all,
            //     initialSelectedDay: _chosenDate,
            //     calendarStyle: CalendarStyle(
            //         canEventMarkersOverflow: false,
            //         outsideDaysVisible: false,
            //         todayColor: Colors.green,
            //         selectedColor: Theme.of(context).primaryColor,
            //         todayStyle: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18.0,
            //             color: Colors.black)),
            //     headerStyle: HeaderStyle(
            //       centerHeaderTitle: true,
            //       titleTextStyle: TextStyle(color: Colors.black),
            //       formatButtonDecoration: BoxDecoration(
            //         color: Colors.orange,
            //         border: Border.all(),
            //         borderRadius: BorderRadius.circular(20.0),
            //       ),
            //       formatButtonTextStyle: TextStyle(color: Colors.white),
            //       formatButtonShowsNext: false,
            //     ),
            //     startingDayOfWeek: StartingDayOfWeek.sunday,
            //     enabledDayPredicate: (DateTime timedate) {
            //       return true;
            //     },
            //     onDaySelected: (date, events, holydays) {
            //       print("DaySelected $date $events $holydays");
            //       // evntModuleBloc.add(GetPeopleListingTab());
            //       // evntModuleBloc.add(GetTabContent(
            //       //     tabVal: TABVALUE,
            //       //     searchString: date.toString(),
            //       //     myLearningBloc: myLearningBloc,
            //       //     pageIndex: 1));
            //       evntModuleBloc.add(
            //           GetCalanderFilterListContent(startDate: date.toString()));
            //       // evntModuleBloc.add(GetCalanderFilterListContent(
            //       //                                           startDate: date.toString()));
            //     },

            //     // onDaySelected: (date, events) {
            //     //   setState(() {
            //     //     _selectedEvents = events;
            //     //   });
            //     // },
            //     builders: CalendarBuilders(
            //       dayBuilder: (context, date, events) => Container(
            //           margin: const EdgeInsets.all(4.0),
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(50.0)),
            //           child: Text(
            //             date.day.toString(),
            //             style: TextStyle(color: Colors.black),
            //           )),
            //       selectedDayBuilder: (context, date, _) {
            //         return FadeTransition(
            //           opacity: Tween(begin: 0.0, end: 1.0)
            //               .animate(animationController),
            //           child: Container(
            //             margin: const EdgeInsets.all(4.0),
            //             // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            //             width: 100,
            //             height: 100,
            //             alignment: Alignment.center,
            //             decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: Colors.lightGreen,
            //             ),
            //             child: Text(
            //               '${date.day}',
            //               style: TextStyle()
            //                   .copyWith(fontSize: 16.0, color: Colors.white),
            //             ),
            //           ),
            //         );
            //       },
            //       todayDayBuilder: (context, date, _) {
            //         return Container(
            //           margin: const EdgeInsets.all(4.0),
            //           // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            //           alignment: Alignment.center,
            //           width: 100,
            //           height: 100,
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Colors.white,
            //           ),
            //           child: Text(
            //             '${date.day}',
            //             style: TextStyle()
            //                 .copyWith(fontSize: 16.0, color: Colors.black),
            //           ),
            //         );
            //       },
            //       markersBuilder: (context, date, events, holidays) {
            //         final children = <Widget>[];

            //         if (events.isNotEmpty) {
            //           children.add(
            //             Center(
            //               child: _buildEventsMarker(date, events),
            //             ),
            //           );
            //         }
            //         try {
            //           if (events.isNotEmpty) {
            //             EventResourcePlusResponse data = events.first;
            //           }
            //         } catch (error, stackTrace) {
            //           print(error);
            //           print(stackTrace);
            //         }

            //         if (holidays.isNotEmpty) {
            //           children.add(
            //             _buildHolidaysMarker(),
            //           );
            //         }

            //         return children;
            //       },
            //     ),
            //     calendarController: _calendarController,
            //   ),
            // ),

            //  _buildTableCalendarWithBuilders(),
            Expanded(child: getlistOfEvents()),
          ],
        ),
      ),
    );
  }

  Widget getlistOfEvents() {
    return BlocConsumer<EvntModuleBloc, EvntModuleState>(
      bloc: eventModuleBloc,
      listener: (context, state) {
        if (state is GetPeopleListingTabState) {
          if (state.status == Status.COMPLETED) {
            if (eventModuleBloc.tabList.isNotEmpty) {
              setState(() {
                tabValue = getTabValue(eventModuleBloc.tabList[1].tabId);
              });
              eventModuleBloc.tabList[0].selectedIndex = true;
            }

            eventModuleBloc.add(GetTabContent(
                tabVal: tabValue,
                searchString: DateTime.now().toString(),
                myLearningBloc: myLearningBloc,
                pageIndex: pageNumber));
          } else if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            } else {
              flutterToast.showToast(
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: const Duration(seconds: 2),
                  child: CommonToast(displaymsg: 'Something went wrong'));
            }
          }
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 15, 10),
                child: Stack(
                  children: <Widget>[
                    tabValue == "calendar"
                        ? Column(
                            // scrollDirection: Axis.vertical,
                            //shrinkWrap: true,
                            children: <Widget>[
                              Container(
                                // color: Color(int.parse(
                                //     "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      height: 250,
                                      child: SfCalendar(
                                        showNavigationArrow: true,
                                        // showCurrentTimeIndicator: false,
                                        backgroundColor: InsColor(appBloc).appBGColor,
                                        //         showDatePickerButton: true,
                                        view: CalendarView.month,
                                        cellEndPadding: 5,
                                        selectionDecoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color: const Color(0xFF0082E0),
                                              width: 1.5,
                                              style: BorderStyle.solid,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                                          shape: BoxShape.rectangle,
                                        ),
                                        cellBorderColor: Colors.transparent,
                                        dataSource: MeetingDataSource(_getDataSource()),

                                        //monthViewSettings: MonthViewSettings(showAgenda: true),

                                        //For showing eventnames in down side of the dates
                                        monthViewSettings: const MonthViewSettings(
                                           // numberOfWeeksInView: 4,
                                            appointmentDisplayCount: 1,
                                            
                                            // appointmentDisplayMode:
                                            //     MonthAppointmentDisplayMode
                                            //         .appointment,
                                            // showAgenda: false,
                                            // navigationDirection:
                                            //     MonthNavigationDirection
                                            //         .horizontal
                                        ),

                                        // monthViewSettings: DateRangePickerMonthViewSettings,
                                        // monthViewSettings: DateRa,
                                        // monthViewSettings:
                                        //     MonthViewSettings(
                                        //   monthCellStyle:
                                        //       MonthCellStyle(
                                        //     textStyle: Theme.of(
                                        //             context)
                                        //         .textTheme
                                        //         .bodyText1
                                        //         .apply(
                                        //             color: InsColor(
                                        //                     appBloc)
                                        //                 .appTextColor),
                                        //     leadingDatesTextStyle: Theme
                                        //             .of(context)
                                        //         .textTheme
                                        //         .bodyText2
                                        //         .apply(
                                        //             color: InsColor(
                                        //                     appBloc)
                                        //                 .appTextColor
                                        //                 .withOpacity(
                                        //                     0.5)),
                                        //     trailingDatesTextStyle: Theme
                                        //             .of(context)
                                        //         .textTheme
                                        //         .bodyText2
                                        //         .apply(
                                        //             color: InsColor(
                                        //                     appBloc)
                                        //                 .appTextColor
                                        //                 .withOpacity(
                                        //                     0.5)),

                                        //     // backgroundColor:
                                        //     //     Color(int.parse(
                                        //     //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        //   ),
                                        //   appointmentDisplayMode:
                                        //       MonthAppointmentDisplayMode
                                        //           .appointment,
                                        // ),
                                        onTap: (value) {
                                          // selecetdDateInCalender = DateTime.now();
                                          selectedDateInCalender = value.date;
                                          eventModuleBloc.add(
                                              GetCalanderFilterListContent(
                                                  startDate: value.date
                                                      .toString()
                                                      .split(" ")[0]));
                                        },
                                        onViewChanged: (ViewChangedDetails ee) {
                                          String startdate = "${ee.visibleDates[10].year}-${ee.visibleDates[10].month}-01";
                                          String enddate = "${ee.visibleDates[10].year}-${ee.visibleDates[10].month}-30";
                                          print("$startdate ~ $enddate");

                                          if (eventModuleBloc.calenderSelecteddates.isEmpty || eventModuleBloc.calenderSelecteddates != "$startdate ~ $enddate") {
                                            eventModuleBloc.calenderSelecteddates = "$startdate ~ $enddate";
                                            eventModuleBloc.list.clear();
                                            eventModuleBloc.add(GetTabContent(
                                                tabVal: tabValue,
                                                searchString: "",
                                                myLearningBloc: myLearningBloc,
                                                pageIndex: 1));

                                              Future.delayed(const Duration(seconds: 4), () {
                                              eventModuleBloc.add(GetCalanderFilterListContent(
                                              startDate: DateTime.now().toString().split(" ")[0]));
                                              });
                                          }
                                        },
                                        showDatePickerButton: false,
                                        headerStyle: CalendarHeaderStyle(
                                          textStyle: Theme.of(context).textTheme.headline1?.apply(color: InsColor(appBloc).appTextColor),
                                          textAlign: TextAlign.center,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),
                              /*evntModuleBloc.listTotalCount == 0?Center(
                                child: Text(
                                  appBloc.localstr.commoncomponentLabelNodatalabel,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ):Container(),*/
                              eventModuleBloc.list.length > 0
                                  ? displayEventContent(state)
                                  : Container(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Text(
                                            appBloc.localstr
                                                .commoncomponentLabelNodatalabel,
                                            style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                fontSize: 24)),
                                      ),
                                    ),
                            ],
                          )
                        : Container(
                            child: displayEventContent(state),
                          ),
                  ],
                ),
              ),
              // evntModuleBloc.tabList.isNotEmpty
              //     ? Align(
              //         alignment: Alignment.bottomLeft,
              //         child: SizedBox(
              //           width: MediaQuery.of(context).size.width,
              //           height: 43,
              //           child: Container(
              //             color: Color(int.parse(
              //                 "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
              //             child: evntModuleBloc.tabList.length < 3
              //                 ? ListView.builder(
              //                     controller: _controller,
              //                     scrollDirection: Axis.horizontal,
              //                     itemCount: evntModuleBloc.tabList.length,
              //                     itemBuilder: (context, i) {
              //                       return Container(
              //                         width: MediaQuery.of(context).size.width /
              //                                 evntModuleBloc.tabList.length +
              //                             1,
              //                         child: Align(
              //                           alignment: Alignment.center,
              //                           child: InkWell(
              //                             onTap: () => onItemTapped(
              //                                 evntModuleBloc
              //                                     .tabList[i].mobileDisplayName
              //                                     .toLowerCase(),
              //                                 evntModuleBloc.tabList[i],
              //                                 i),
              //                             child: Text(
              //                               evntModuleBloc
              //                                   .tabList[i].mobileDisplayName,
              //                               maxLines: 1,
              //                               style: (selectedIndex == i &&
              //                                       evntModuleBloc.tabList[i]
              //                                           .selectedIndex)
              //                                   ? TextStyle(
              //                                       color: Color(int.parse(
              //                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              //                                       fontWeight: FontWeight.bold,
              //                                       fontSize: 14)
              //                                   : TextStyle(
              //                                       color: Color(int.parse(
              //                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              //                                       fontSize: 14),
              //                             ),
              //                           ),
              //                         ),
              //                       );
              //                     })
              //                 : ListView.builder(
              //                     controller: _controller,
              //                     scrollDirection: Axis.horizontal,
              //                     itemCount: evntModuleBloc.tabList.length,
              //                     itemBuilder: (context, i) {
              //                       return Padding(
              //                         padding: const EdgeInsets.fromLTRB(
              //                             20, 10, 20, 10),
              //                         child: Container(
              //                           child: Align(
              //                             alignment: Alignment.center,
              //                             child: InkWell(
              //                               onTap: () => onItemTapped(
              //                                   evntModuleBloc.tabList[i]
              //                                       .mobileDisplayName
              //                                       .toLowerCase(),
              //                                   evntModuleBloc.tabList[i],
              //                                   i),
              //                               child: Text(
              //                                 evntModuleBloc
              //                                     .tabList[i].mobileDisplayName,
              //                                 maxLines: 1,
              //                                 style: (selectedIndex == i &&
              //                                         evntModuleBloc.tabList[i]
              //                                             .selectedIndex)
              //                                     ? TextStyle(
              //                                         color: Color(int.parse(
              //                                             "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
              //                                         fontWeight:
              //                                             FontWeight.bold,
              //                                         fontSize: 14)
              //                                     : TextStyle(
              //                                         color: Color(int.parse(
              //                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              //                                         fontSize: 14),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       );
              //                     }),
              //           ),
              //         ),
              //       )
              //     : Container(),
              (state.status == Status.LOADING &&
                      eventModuleBloc.list.length == 0)
                      ? Container()
                  // ? Center(
                  //     child: AbsorbPointer(
                  //       child: SpinKitCircle(
                  //         color: Colors.grey,
                  //         size: 70,
                  //       ),
                  //     ),
                  //   )
                  : Container(),
//                  (state.status == Status.LOADING)
//                      ? Center(
//                    child: AbsorbPointer(
//                      child: SpinKitCircle(
//                        color: Colors.grey,
//                        size: 70.h,
//                      ),
//                    ),
//                  )
//                      : Container(),
            ],
          ),
        );
      },
      // ),
      //   (state.status == Status.LOADING)
      //       ? Center(
      //           child: AbsorbPointer(
      //             child: SpinKitCircle(
      //               color: Colors.grey,
      //               size: 70.h,
      //             ),
      //           ),
      //         )
      //       : Container(),
      // ],
      //     ),
      //   );
      // },
    );
  }

  String getTabValue(String tabId) {
    String tabValue = 'upcoming';

    switch (tabId) {
      case "Upcoming-Courses":
      case "Calendar-Schedule":
        tabValue = "upcoming";

        break;
      case "Calendar-View":
        tabValue = "calendar";

        break;
      case "Past-Courses":
        tabValue = "past";
        break;
      case "My-Events":
        tabValue = "myevents";
        break;
      case "Additional-Program-Details":
        tabValue = "upcoming";
        break;
    }

    return tabValue;
  }


  Map<DateTime, List<dynamic>> _getfilterEvents() {
    var meetings = [];

    eventModuleBloc.calanderFilterList.forEach((element) {
      final DateTime today = DateTime.now();

      final DateTime startTime = DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(element.createddate);
      final DateTime endTime = startTime.add(const Duration(hours: 2));
          _filteredEvents[_selectedDay.subtract(Duration(days: startTime.day))] = [
        element
      ];
      
    });
    return _filteredEvents;
  }

  List<Meeting> _getDataSource() {
    List<Meeting> meetings = <Meeting>[];

    eventModuleBloc.calanderFilterList.forEach((element) {
      final DateTime today = DateTime.now();
      print("_getDataSource ${element.eventstartdatedisplay}");
      if(element.eventstartdatedisplay != ""){
      final DateTime startTime =  DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(element.eventstartdatedisplay);
      
      final DateTime endTime = startTime.add(const Duration(hours: 2));
     // if(!meetings.contains(Meeting("${element.name}",startTime,startTime,const Color(0xFF0F8644),false))){
      meetings.add(Meeting(
          "${element.name}",
          startTime,
          startTime,
          const Color(0xFF63B300),
          // Color(int.parse(
          //     "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          false));
      }
     // }
    });
    return meetings;
  }

  void onItemTapped(String label, GetPeopleTabListResponse res, int index) {
    myLearningBloc.add(ResetFilterEvent());
    eventModuleBloc.isEventSearch = false;
    eventModuleBloc.searchEventString = "";
    eventModuleBloc.isFirstLoading = true;
    eventModuleBloc.list.clear();
    setState(() {
      selectedIndex = index;
      //TABVALUE = getTabvalue(evntModuleBloc.tabList[index].tabId);
      res.selectedIndex = true;
      pageNumber = 1;
      eventModuleBloc.add(GetTabContent(
          tabVal: tabValue,
          searchString: "",
          myLearningBloc: myLearningBloc,
          pageIndex: pageNumber));
      _controller.animateTo(MediaQuery.of(context).size.width * index,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  Widget displayEventContent(EvntModuleState state) {
    switch (tabValue) {
      case 'upcoming':
        return displayUpcoming(state);
      case 'past':
        return displayUpcoming(state);
      case 'calendar':
        return displayUpcoming(state);
      case 'schedule':
        return displayUpcoming(state);
      case 'myevents':
        return displayUpcoming(state);
      default:
        return displayUpcoming(state);
    }
  }

  Widget displayUpcoming(EvntModuleState state) {
    // TODO: implement build
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    TextEditingController _controller;
    if (eventModuleBloc.isEventSearch) {
      _controller =
          TextEditingController(text: eventModuleBloc.searchEventString);
    } else {
      _controller = TextEditingController();
    }
    return tabValue == "calendar"
        ? ResponsiveWidget(
            mobile: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventModuleBloc.list.length,
                itemBuilder: (context, i) {
                  return widgetMyEventItems(eventModuleBloc.list[i],i);
                }),
            tab: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width / 960,
                ),
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventModuleBloc.list.length,
                itemBuilder: (context, i) {
                  return widgetMyEventItems(eventModuleBloc.list[i],i);
                }),
            web: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
              ),
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(),
              shrinkWrap: true,
              itemCount: eventModuleBloc.list.length,
              itemBuilder: (context, i) {
                return widgetMyEventItems(eventModuleBloc.list[i],i);
              },
            ),
          )
        : (eventModuleBloc.list.length > 0)
            ? Column(
                children: [
                  // Expanded(
                  //     flex: 1,
                  //     child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: InsSearchTextField(
                  //           onTapAction: () {
                  //             if (appBloc.uiSettingModel.IsGlobasearch ==
                  //                 'true') {
                  //               //_navigateToGlobalSearchScreen(context);
                  //             }
                  //           },
                  //           controller: _controller,
                  //           appBloc: appBloc,
                  //           suffixIcon: evntModuleBloc.isEventSearch
                  //               ? IconButton(
                  //                   onPressed: () {
                  //                     //search logic
                  //                     evntModuleBloc.isFirstLoading = true;
                  //                     evntModuleBloc.isEventSearch = false;
                  //                     evntModuleBloc.searchEventString = "";

                  //                     evntModuleBloc.add(GetTabContent(
                  //                         tabVal: TABVALUE,
                  //                         searchString: "",
                  //                         myLearningBloc: myLearningBloc,
                  //                         pageIndex: 1));
                  //                   },
                  //                   icon: Icon(
                  //                     Icons.close,
                  //                   ),
                  //                 )
                  //               : IconButton(
                  //                   onPressed: () async {
                  //                     await Navigator.of(context).push(
                  //                         MaterialPageRoute(
                  //                             builder: (context) =>
                  //                                 MyLearningFilter()));

                  //                     evntModuleBloc.isFirstLoading = true;
                  //                     evntModuleBloc.add(GetTabContent(
                  //                         tabVal: TABVALUE,
                  //                         searchString: "",
                  //                         myLearningBloc: myLearningBloc,
                  //                         pageIndex: 1));
                  //                   },
                  //                   icon: Icon(Icons.tune,
                  //                       color: Color(
                  //                         int.parse(
                  //                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  //                       )),
                  //                 ),
                  //           onSubmitAction: (value) {
                  //             if (value.toString().length > 0) {
                  //               evntModuleBloc.isFirstLoading = true;
                  //               evntModuleBloc.isEventSearch = true;
                  //               evntModuleBloc.searchEventString =
                  //                   value.toString();
                  //               evntModuleBloc.add(GetTabContent(
                  //                   tabVal: TABVALUE,
                  //                   searchString: value.toString(),
                  //                   myLearningBloc: myLearningBloc,
                  //                   pageIndex: 1));
                  //             }
                  //           },
                  //         ))),
                  Expanded(
                    flex: 9,
                    child: ResponsiveWidget(
                      mobile: ListView.builder(
                          controller: _sc,
                          scrollDirection: Axis.vertical,
                          itemCount: eventModuleBloc.list.length,
                          itemBuilder: (context, i) {
                            if (eventModuleBloc.list.length == 0) {
                              if (state.status == Status.LOADING &&
                                  state is GetTabContentState) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Opacity(
                                      opacity: 1.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return widgetMyEventItems(eventModuleBloc.list[i],i);
                            }
                          }),
                      tab: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width / 960,
                          ),
                          controller: _sc,
                          scrollDirection: Axis.vertical,
                          itemCount: eventModuleBloc.list.length,
                          itemBuilder: (context, i) {
                            if (eventModuleBloc.list.length == 0) {
                              if (state.status == Status.LOADING &&
                                  state is GetTabContentState) {
//                        print("gone in _buildProgressIndicator");
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Opacity(
                                      opacity: 1.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return widgetMyEventItems(eventModuleBloc.list[i],i);
                            }
                          }),
                      web: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 1,
                          ),
                          controller: _sc,
                          scrollDirection: Axis.vertical,
                          itemCount: eventModuleBloc.list.length,
                          itemBuilder: (context, i) {
                            if (eventModuleBloc.list.length == 0) {
                              if (state.status == Status.LOADING &&
                                  state is GetTabContentState) {
//                        print("gone in _buildProgressIndicator");
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Opacity(
                                      opacity: 1.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return widgetMyEventItems(eventModuleBloc.list[i],i);
                            }
                          }),
                    ),
                  ),
                ],
              )
            : (state.status == Status.COMPLETED)
                ? Column(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Text(
                              appBloc.localstr.commoncomponentLabelNodatalabel,
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  fontSize: 24)),
                        ),
                      ),
                    ],
                  )
                : Container();
  }

  _navigateToGlobalSearchScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const GlobalSearchScreen(menuId: 3219)),
    );

    print(result);

    if (result != null) {
      eventModuleBloc.isFirstLoading = true;
      eventModuleBloc.isEventSearch = true;
      eventModuleBloc.searchEventString = result.toString();
      eventModuleBloc.add(GetTabContent(
          tabVal: tabValue,
          searchString: result.toString(),
          myLearningBloc: myLearningBloc,
          pageIndex: 1));
    }
  }

  Widget widgetMyEventItems(DummyMyCatelogResponseTable2 table2,[int i = 0]) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    bool isratingbarVissble = false;
    bool isReviewVissble = false;

    double ratingRequired = 0;
    String availableSeat = '';
    String startDate = "";
    String endDate = "";

    //availableSeat = checkAvailableSeats(table2);
    print("event satrt and end time ${table2.eventstartdatedisplay} ${table2.eventenddatedisplay}");

    try {
      ratingRequired = double.parse(
          appBloc.uiSettingModel.minimumRatingRequiredToShowRating);
    } catch (e) {
      ratingRequired = 0;
    }

    if (table2.totalratings >=
            int.parse(
                appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating) &&
        table2.ratingid >= ratingRequired) {
      isReviewVissble = false;
      isratingbarVissble = true;
    }
    
    if(table2.eventstartdatedisplay != "" && table2.eventenddatedisplay != ""){
    DateTime startTempDate = DateFormat("yyyy-MM-ddThh:mm:ss")
        .parse(table2.eventstartdatedisplay);

    DateTime endTempDate =
        DateFormat("yyyy-MM-ddThh:mm:ss").parse(table2.eventenddatedisplay);

    startDate = 
           DateFormat("yyyy-MM-ddThh:mm:ss").format(startTempDate);
    endDate = DateFormat("yyyy-MM-ddThh:mm:ss").format(endTempDate);
    }

    String thumbnailPath = table2.thumbnailimagepath.startsWith("http")
        ? table2.thumbnailimagepath.trim()
        : table2.siteurl + table2.thumbnailimagepath.trim();

    String contentIconPath = table2.iconpath;

    // if (isValidString(appBloc.uiSettingModel.AzureRootPath)) {
    //   contentIconPath = contentIconPath.startsWith('http')
    //       ? table2.iconpath
    //       : appBloc.uiSettingModel.AzureRootPath + table2.iconpath;

    //   contentIconPath = contentIconPath.toLowerCase().trim();
    // } else {
    //   contentIconPath = table2.siteurl + contentIconPath;
    // }

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: Card(
        color: InsColor(appBloc).appBGColor,
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
                      // if (menu0) {
                      // //   checkRelatedContent(table2);
                      // // } else if (menu3) {
                      // //   Navigator.of(context).push(MaterialPageRoute(
                      // //       builder: (context) => ChangeNotifierProvider(
                      // //             create: (context) => ProviderModel(),
                      // //             child: CommonDetailScreen(
                      // //               screenType: ScreenType.Events,
                      // //               contentid: table2.contentid,
                      // //               objtypeId: table2.objecttypeid,
                      // //               detailsBloc: detailsBloc,
                      // //               table2: table2,
                      // //               isFromReschedule: false,
                      // //             ),
                      // //           )));
                      // }
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
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
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
                            padding: const EdgeInsets.all(2.0),
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
                        //if(mounted){
                        settingMyCourceBottomSheet(widget.myLearningPlusContext, table2, i);
                        //}
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
                        height: 10,
                        width: 1,
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
                              // onRated: (v) {},
                              starCount: 5,
                              rating: table2.ratingid,
                              size: ScreenUtil().setHeight(16),
                              // isReadOnly: true,
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ReviewScreen(
                                          table2.contentid, false, MyLearningDetailsBloc(myLearningRepository: myLearningRepository))));
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
                  // isValidString(table2.shortdescription)
                  // ? SizedBox(
                  //     height: ScreenUtil().setHeight(10),
                  //   )
                  // : Container(),
                  Text(
                    table2.shortdescription,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(13),
                        color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                            .withOpacity(0.5)),
                  ),
                  // isValidString(table2.shortdescription)
                  //     ? SizedBox(
                  //         height: ScreenUtil().setHeight(10),
                  //       )
                  //     : Container(),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Start Date :  ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: InsColor(appBloc)
                                  .appTextColor
                                  .withOpacity(0.8)),
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
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "End Date :    ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: InsColor(appBloc)
                                  .appTextColor
                                  .withOpacity(0.8)),
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
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Time Zone : ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: InsColor(appBloc)
                                  .appTextColor
                                  .withOpacity(0.8)),
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
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Location :     ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: InsColor(appBloc)
                                  .appTextColor
                                  .withOpacity(0.8)),
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
                            //buyOption(table2),
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

   settingMyCourceBottomSheet(
      context, DummyMyCatelogResponseTable2 table2, int i) {
//    print('bottomsheetobjit ${table2.objecttypeid}');
    showModalBottomSheet(
        context: context,
        shape: AppConstants().bottomSheetShapeBorder(),
        builder: (BuildContext bc) {
          return AppConstants().bottomSheetContainer(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  BottomSheetDragger(),
                  //displayPlay(table2),
                  displayView(table2),
                  displayDetails(table2, i),
                  displayJoin(table2),
                  // // // displayDownload(table2, i), commented for till offline implementation
                  // displayReport(table2),
                  displayaddToCalendar(table2),
                  // displaySetComplete(table2),
                  // displayRelatedContent(table2),
                  // displayCancelEnrollemnt(table2, i),
                  // displayDelete(table2),
                  // myLearningBloc.showArchieve == "true"
                  //     ? displayArchive(table2)
                  //     : Container(),

                  // displayUnArachive(table2),
                  // displayRemove(table2),
                  // displayReschedule(table2),
                  // displayCertificate(table2),
                  // displayQRCode(table2),
                  // displayEventRecording(table2),
                  // displayShare(table2),
                  // displayShareConnection(table2),

                  //sreekanth commented
                  // displaySendViaEmail(table2)
                ],
              ),
            ),
          );
        });
  }

  Widget displayView(DummyMyCatelogResponseTable2 table2) {
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
        return new BottomsheetOptionTile(
          iconData: IconDataSolid(int.parse('0xf06e')),
          text: appBloc.localstr.mylearningActionsheetViewoption,
          onTap: () {
            Navigator.of(context).pop();

            if ((table2.viewprerequisitecontentstatus != null) && isValidString(table2.viewprerequisitecontentstatus)) {
//              print('ifdataaaaa');
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
              launchCourse(table2, context, false);
            }
          },
        );
      }
    } else if (table2.objecttypeid == 688 || table2.objecttypeid == 70) {
      return Container();
    } else {
      return new BottomsheetOptionTile(
        iconData: IconDataSolid(int.parse('0xf06e')),
        text: appBloc.localstr.mylearningActionsheetViewoption,
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
            launchCourse(table2, context, false);
          }
        },
      );
    }
//    return Container();
  }

  Future<void> launchCourse(DummyMyCatelogResponseTable2 table2,
      BuildContext context, bool isContentisolation) async {
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
  }

  Widget displayDetails(DummyMyCatelogResponseTable2 table2, int i) {
    table2.isaddedtomylearning = 1;
    if (typeFrom == "event" || typeFrom == "track") {
      return Container();
    }

    if (table2.objecttypeid == 70 && (table2.bit4 != null && table2.bit4)) {
      return Container();
    }
    return new BottomsheetOptionTile(
        iconData: IconDataSolid(int.parse('0xf570')),
        text: appBloc.localstr.mylearningActionsheetDetailsoption,
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
                        { Container(),

                        // ApicallingByinput(currentTabStatus,'')

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
                         //ApicallingByinput(currentTabStatus,'')

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
 Container(),
                         // ApicallingByinput(currentTabStatus,'')

                          // myLearningBloc.add(GetListEvent(
                          //     pageNumber: 1, pageSize: 10, searchText: ""))
                        }
                    });
          }
        });
  }

  //  ApicallingByinput(String input,String searchvalue){ // Widget?
  //   try {
  //     // if (input == 'Archive') {
  //     //   myLearningBloc.add(GetArchiveListEvent(
  //     //       pageNumber: pageArchiveNumber, pageSize: 10, searchText:''));
  //     // }
  //     // if(input == 'NotStarted'){
  //     //   HashMap<String, String> map = new HashMap<String, String>();
  //     //   String parameter = selectedTabObj.parameterString;
  //     //   var dataSp = parameter.split('&');
  //     //   Map<String, String> mapData = Map();
  //     //   dataSp.forEach((element) =>
  //     //   mapData[element.split('=')[0]] =
  //     //   element.split('=')[1]);
  //     //   String contentstatus = mapData["contentstatus"] ?? "";
  //     //   myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
  //     //       pageNumber: pageNumber,
  //     //       pageSize: 100,
  //     //       searchText: searchvalue,
  //     //       Contentstatus: contentstatus,
  //     //       componentid: widget.nativeModel.componentId,
  //     //       componentInsId: widget.nativeModel.repositoryId,
  //     //       //componentInsId: '4232',
  //     //       iswait: false,
  //     //       iswishlistcount: 0,
  //     //       Datefilter: "",
  //     //       type: 'NotStarted'));
  //     // }

  //     if(input == 'Dashboard'){

  //       String parameter = selectedTabObj.parameterString;
  //       var dataSp = parameter.split('&');
  //       Map<String, String> mapData = Map();
  //       dataSp.forEach((element) =>
  //       mapData[element.split('=')[0]] =
  //       element.split('=')[1]);
  //       String FilterContentType = mapData["FilterContentType"] ?? "";
  //       // DueDateListView = mapData["DueDateListView"] ?? "";
  //       // DueDateCalendarView = mapData["DueDateCalendarView"] ?? "";
  //       // ShowLeaderboard = mapData["ShowLeaderboard"] ?? "";
  //       // ShowLeveldash = mapData["ShowLevel"] ?? "";
  //       // ShowPointdash = mapData["ShowPoint"] ?? "";
  //       // ShowBadgesdash = mapData["ShowBadges"] ?? "";

  //       // if(DueDateListView == "false"){
  //       //   if(DueDateCalendarView == "false"){
  //       //     if(ShowLeaderboard == "false"){
  //       //       gridcond = false;
  //       //       calendarcond = false;
  //       //       leadercond = false;
  //       //       globalCondition = '';
  //       //       dashtitle = '';
  //       //     }else{
  //       //       gridcond = false;
  //       //       calendarcond = false;
  //       //       leadercond = true;
  //       //       globalCondition = 'lead';
  //       //       dashtitle = 'Leaderboard';
  //       //     }
  //       //   }else {
  //       //     gridcond = false;
  //       //     calendarcond = true;
  //       //     leadercond = false;
  //       //     globalCondition = 'cal';
  //       //     dashtitle = 'Your Schedule';
  //       //   }
  //       // }else {
  //       //   gridcond = true;
  //       //   calendarcond = false;
  //       //   leadercond = false;
  //       //   globalCondition = 'grid';
  //       //   dashtitle = 'Your Schedule';
  //       // }

  //       myLearningBloc.add(GetUserAchievementDataPlusEvent(
  //         gameID: '3',
  //         locale: 'en-us',
  //         componentID: widget.nativeModel.componentId,
  //         componentInsID: widget.nativeModel.repositoryId,
  //         //componentInsID: '4232',

  //         siteID: '374',
  //         userID: '',
  //       ));

  //       myLearningBloc.add(GetLeaderboardLearnPlusEvent(
  //         gameID: '3',
  //         locale: 'en-us',
  //         componentID: widget.nativeModel.componentId,
  //         componentInsID: widget.nativeModel.repositoryId,
  //         //componentInsID: '4232',
  //         siteID: '',
  //         userID: '',
  //       ));

  //       myLearningBloc.add(GetEventResourceCalEvent(
  //           componentinsid: widget.nativeModel.repositoryId,
  //           //componentinsid: '4232',
  //           componentid: widget.nativeModel.componentId,
  //           enddate: '2021-12-01',
  //           startdate: '2021-11-01',
  //           eventid: '',
  //           multiLocation: '',
  //           objecttypes:'${FilterContentType}'));
  //       myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
  //           pageNumber: pageNumber,
  //           pageSize: 10,
  //           searchText: '',
  //           iswishlistcount: 0,
  //           iswait: false,
  //           Datefilter: 'today',
  //           componentid: tab.componentId, //'316',
  //           componentInsId: tab.tabComponentInstanceId, //'4233',
  //           objecttypeId: '${FilterContentType}',
  //           Contentstatus: '',
  //           type: 'today'));

  //       myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
  //           pageNumber: pageNumber,
  //           pageSize: 10,
  //           searchText: "",
  //           iswishlistcount: 0,
  //           iswait: false,
  //           Datefilter: 'thisweek',
  //           componentid: tab.componentId, //'316',
  //           componentInsId: tab.tabComponentInstanceId, //'4233',
  //          // componentid: '316',componentInsId: '4233',
  //           objecttypeId: '${FilterContentType}',
  //           Contentstatus: '',
  //           type: 'thisweek'));

  //       myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
  //           pageNumber: pageNumber,
  //           pageSize: 10,
  //           searchText: '',
  //           iswishlistcount: 0,
  //           iswait: false,
  //           Datefilter: 'thismonth',
  //           objecttypeId: '${FilterContentType}',
  //            componentid: tab.componentId, //'316',
  //           componentInsId: tab.tabComponentInstanceId, //'4233',
  //           // componentid: '316',componentInsId: '4233',
  //           Contentstatus: '',
  //           type: 'thismonth'));

  //       myLearningBloc.add(getMyLearnPlusLearningObjectsEvent(
  //           pageNumber: pageNumber,
  //           pageSize: 10,
  //           searchText: '',
  //           iswishlistcount: 0,
  //           iswait: false,
  //           Datefilter: 'future',
  //           objecttypeId: '${FilterContentType}',
  //           componentid: tab.componentId, //'316',
  //           componentInsId: tab.tabComponentInstanceId, //'4233',
  //           //componentid: '316',componentInsId: '4233',
  //           Contentstatus: '',
  //           type: 'future'));
  //     }

  //   } catch (e) {
  //     print("repo Error $e");
  //   }
  // }

  Widget displayJoin(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
      if ((table2.eventenddatetime != null) && isValidString(table2.eventenddatetime)) if (!returnEventCompleted(
          table2.eventenddatetime)) {
        if (table2.typeofevent == 2) {
          return new BottomsheetOptionTile(
            iconData: IconDataSolid(int.parse('0xf234')),
            text: appBloc.localstr.mylearningActionsheetJoinoption,
            onTap: () {
              Navigator.pop(context);
              String joinUrl = table2.joinurl;

              print('joinurllll ${table2.joinurl}');

              if (joinUrl.length > 0) {
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

   Widget displayaddToCalendar(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 70) {
//      print(
//          'addtocalendar ${table2.objecttypeid} ${table2.eventenddatetime} ${returnEventCompleted(table2.eventenddatetime)}');

      if ((table2.eventenddatetime != null) && isValidString(table2.eventenddatetime)) if (!returnEventCompleted(
          table2.eventenddatetime)) {
        return new BottomsheetOptionTile(
          iconData: IconDataSolid(int.parse('0xf271')),
          text: appBloc.localstr.mylearningActionsheetAddtocalendaroption,
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


   bool isValidString(String val) {
//    print('validstrinh $val');
    if (val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }


  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber,
        border: Border.all(color: Colors.white),
      ),
      width: 60.0,
      height: 60.0,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(60.0)),
        child: Center(
          child: Text(
            '${date.day}',
            style: const TextStyle().copyWith(
              color: Colors.black,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTableCalendarWithBuilders() {
  //   return TableCalendar(
  //     //locale: 'pl_PL',
  //     calendarController: _calendarController,
  //     events: _filteredEvents,
  //     initialCalendarFormat: CalendarFormat.month,
  //     formatAnimation: FormatAnimation.slide,
  //     startingDayOfWeek: StartingDayOfWeek.sunday,
  //     availableGestures: AvailableGestures.horizontalSwipe,
  //     availableCalendarFormats: const {
  //       CalendarFormat.month: '',
  //     },

  //     calendarStyle: CalendarStyle(
  //       outsideDaysVisible: true,
  //       weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
  //       holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
  //     ),
  //     daysOfWeekStyle: DaysOfWeekStyle(
  //       weekendStyle: TextStyle().copyWith(color: Colors.green[600]),
  //     ),
  //     headerStyle: HeaderStyle(
  //       centerHeaderTitle: true,
  //       formatButtonVisible: false,
  //     ),
  //     builders: CalendarBuilders(
  //       selectedDayBuilder: (context, date, _) {
  //         return FadeTransition(
  //           opacity: Tween(begin: 0.0, end: 1.0).animate(animationController),
  //           child: Container(
  //             margin: const EdgeInsets.all(4.0),
  //             // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
  //             width: 100,
  //             height: 100,
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.lightGreen,
  //             ),
  //             child: Text(
  //               '${date.day}',
  //               style:
  //                   TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
  //             ),
  //           ),
  //         );
  //       },
  //       todayDayBuilder: (context, date, _) {
  //         return Container(
  //           margin: const EdgeInsets.all(4.0),
  //           // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
  //           alignment: Alignment.center,
  //           width: 100,
  //           height: 100,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: Colors.blue,
  //           ),
  //           child: Text(
  //             '${date.day}',
  //             style: TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
  //           ),
  //         );
  //       },
  //       markersBuilder: (context, date, events, holidays) {
  //         final children = <Widget>[];

  //         if (events.isNotEmpty) {
  //           children.add(
  //             Center(
  //               child: _buildEventsMarker(date, events),
  //             ),
  //           );
  //         }
  //         try {
  //           if (events.isNotEmpty) {
  //             EventResourcePlusResponse data = events.first;
  //           }
  //         } catch (error, stackTrace) {
  //           print(error);
  //           print(stackTrace);
  //         }

  //         if (holidays.isNotEmpty) {
  //           children.add(
  //             _buildHolidaysMarker(),
  //           );
  //         }

  //         return children;
  //       },
  //     ),
  //     onDaySelected: (date, events, holidays) {
  //       try {} catch (error, stackTrace) {
  //         print("$error , $stackTrace");
  //       }
  //     },
  //     onVisibleDaysChanged: _onVisibleDaysChanged,
  //     onCalendarCreated: _onCalendarCreated,
  //   );
  // }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  Widget _buildHolidaysMarker() {
    return Positioned(
// right: 1,
// bottom: 2,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 1),
            shape: BoxShape.circle,
          ),
          width: 40,
          height: 40,
        ),
      ),
    );
  }

  Widget _buildHighlitedEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
// borderRadius: BorderRadius.circular(4),
/* color: _calendarController.isSelected(date)
? Colors.transparent
: _calendarController.isToday(date)
? Colors.green[300]
: Colors.red[400],*/
      ),
      width: 40.0,
      height: 40.0,
      child: Center(
        child: Text(
          '${date.day}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
