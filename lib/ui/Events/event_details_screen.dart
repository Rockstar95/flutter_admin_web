// import 'package:add_2_calendar/add_2_calendar.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:html/parser.dart';
// import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
// import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
// import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/event_module/event/classroom_events_event.dart';
// import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning_details_response.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
// import 'package:flutter_admin_web/framework/common/constants.dart';
// import 'package:flutter_admin_web/framework/common/enums.dart';
// import 'package:flutter_admin_web/framework/common/pref_manger.dart';
// import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
// import 'package:flutter_admin_web/framework/helpers/utils.dart';
// import 'package:flutter_admin_web/framework/repository/event_module/model/event_recording_resonse.dart';
// import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository_builder.dart';
// import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
// import 'package:flutter_admin_web/ui/Events/session_event.dart';
// import 'package:flutter_admin_web/ui/MyLearning/common_detail_screen.dart';
// import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
// import 'package:flutter_admin_web/ui/MyLearning/progress_report.dart';
// import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
// import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
// import 'package:flutter_admin_web/ui/common/common_toast.dart';
// import 'package:intl/intl.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
//
// class EventDetailScreen extends StatefulWidget {
//   final String contentid;
//   final int objtypeId;
//   final DummyMyCatelogResponseTable2 table2;
//   final MyLearningDetailsBloc detailsBloc;
//   final bool isWishlisted;
//
//   EventDetailScreen(
//       {this.contentid,
//       this.objtypeId,
//       this.table2,
//       this.detailsBloc,
//       this.isWishlisted});
//
//   @override
//   _EventDetailScreenState createState() => _EventDetailScreenState();
// }
//
// class _EventDetailScreenState extends State<EventDetailScreen> {
//   AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
//
//   MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);
//
//   CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);
//   MyLearningDetailsBloc detailsBloc;
//   var strUserID = '';
//
//   String eventstartDate = '';
//   String eventendDate = '';
//
//   List<EditRating> reviewList = [];
//
//   int ratingCount = 0;
//   bool isEditRating = false;
//
//   MyLearningDetailsResponse data;
//   String availableSeat = '';
//
//   String imgUrl =
//       "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
//
//   bool menu0 = false,
//       menu1 = false,
//       isAddtomylearning = false,
//       loaderAddtomylearning = false;
//
//   Fluttertoast flutterToast;
//
//   int bottomButton1Tag = 0;
//   int bottomButton2Tag = 0;
//
//   String bottomButton1Text = '';
//   String bottomButton2Text = '';
//
//   IconData icon1;
//   IconData icon2;
//
//   bool isReportEnabled = true;
//   EvntModuleBloc evntModuleBloc;
//
//   bool enablePlay = false;
//   int availableSeats = 0;
//   int waitlistSeats = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     availableSeats = widget.table2.availableseats;
//     waitlistSeats = widget.table2.waitlistenrolls;
// //    print('availableseats ${widget.table2.availableseats}');
//     availableSeat = checkAvailableSeats(widget.table2);
//
//     evntModuleBloc = EvntModuleBloc(
//         eventModuleRepository: EventRepositoryBuilder.repository());
//
//     detailsBloc = widget.detailsBloc;
//     detailsBloc.userRatingDetails.clear();
//     detailsBloc.add(
//         GetDetailsReviewEvent(contentId: widget.contentid, skippedRows: 0));
//
//     getUserId();
//     if (isValidString(widget.table2.eventstartdatetime)) {
//       DateTime tempDate = new DateFormat("yyyy-MM-ddThh:mm:ss")
//           .parse(widget.table2.eventstartdatetime);
//
//       String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDate);
//       eventstartDate = date;
//
//       print('checkmydateva; $date');
//     }
//
//     if (isValidString(widget.table2.eventenddatetime)) {
//       DateTime tempDate = new DateFormat("yyyy-MM-ddThh:mm:ss")
//           .parse(widget.table2.eventenddatetime);
//
//       String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDate);
//       eventendDate = date;
//
//       print('checkmydateva; $date');
//     }
//
//     checkReportEnabled();
//     setTag1();
//
//     Future.delayed(Duration.zero, () {
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => CommonDetailScreen(
//                 contentid: widget.contentid,
//                 objtypeId: widget.objtypeId,
//                 detailsBloc: detailsBloc,
//                 table2: widget.table2,
//                 screenType: ScreenType.Events,
// // nativeModel:
// // widget.nativeMenuModel,
//               )));
//     });
//   }
//
//   void checkReportEnabled() async {
//     if (widget.table2.siteid.toString() ==
//             await sharePref_getString(sharedPref_siteid) &&
//         widget.table2.userid.toString() ==
//             await sharePref_getString(sharedPref_userid) &&
//         await sharePref_getBool(sharedPref_previlige)) {
//       isReportEnabled = true;
//     } else {
//       isReportEnabled = true;
//     }
//   }
//
//   bool returnEventCompleted(String eventDate) {
// //
//     if (eventDate == null) return false;
// //
//     bool isCompleted = false;
// //
//
//     DateTime fromDate;
//     var difference;
//
//     if (!isValidString(eventDate)) return false;
//
//     try {
//       fromDate = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(eventDate);
//
//       final date2 = DateTime.now();
//       difference = date2.difference(fromDate).inDays;
//     } catch (e) {
//       e.printStackTrace();
//       isCompleted = false;
//     }
//     if (fromDate == null) return false;
//
//     print('fiffenrecedays $difference');
//     if (difference != null && difference <= 0) {
//       isCompleted = false;
//     } else {
//       isCompleted = true;
//     }
//
//     return isCompleted;
//   }
//
//   bool isValidString(String val) {
// //    print('validstrinh $val');
//     if (val == null || val.isEmpty || val == 'null') {
//       return false;
//     } else {
//       return true;
//     }
//   }
//
//   void setTag1() {
//     if (widget.table2.isaddedtomylearning == 1) {
//       if ((widget.table2.bit5 != null && widget.table2.bit5) &&
//           widget.table2.relatedconentcount.toString() != "0") {
//         if (isReportEnabled && widget.table2.objecttypeid != 70) {
//           bottomButton2Text =
//               appBloc.localstr.mylearningActionsheetReportoption;
//           bottomButton2Tag = 5;
//         }
//
//         bottomButton1Text =
//             appBloc.localstr.mylearningActionsheetRelatedcontentoption;
//         bottomButton1Tag = 1;
//         icon1 = Icons.content_copy;
//       } else {
//         if (!returnEventCompleted(widget.table2.eventenddatetime)) {
//           bottomButton1Text =
//               appBloc.localstr.mylearningActionsheetAddtocalendaroption;
//           bottomButton1Tag = 4;
//           icon1 = IconDataSolid(int.parse('0xf271'));
//         }
//       }
//     } else {
//       print(
//           'viewtypevalll ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.actionwaitlist}');
//       if (widget.table2.viewtype == 1 || widget.table2.viewtype == 2) {
//         if (isValidString(widget.table2.eventstartdatetime) &&
//             !returnEventCompleted(widget.table2.eventstartdatetime)) {
//           if (isValidString(widget.table2.actionwaitlist) &&
//               widget.table2.actionwaitlist == "true") {
//             print(
//                 'view222222 ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.actionwaitlist}');
//
//             bottomButton1Text =
//                 appBloc.localstr.eventsActionsheetWaitlistoption;
//             bottomButton1Tag = 6;
//             icon1 = IconDataSolid(int.parse('0xf271'));
//           } else if (widget.table2.availableseats > 0) {
//             print(
//                 'view222222 ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.availableseats}');
//
//             bottomButton1Text = appBloc.localstr.detailsButtonEnrollbutton;
//             bottomButton1Tag = 6;
//             icon1 = IconDataSolid(int.parse('0xf271'));
//           }
//         } else if (widget.table2.eventscheduletype == 1) {
//           if (appBloc.uiSettingModel.EnableMultipleInstancesforEvent ==
//               'true') {
//             bottomButton1Text =
//                 appBloc.localstr.mylearningActionbuttonRescheduleactionbutton;
//             bottomButton1Tag = 6;
//             icon1 = IconDataSolid(int.parse('0xf333'));
//           }
//         } else {
//           if (appBloc.uiSettingModel.AllowExpiredEventsSubscription
//                   .toString() ==
//               'true') {
//             print(
//                 'view222222 expir ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.availableseats}');
//
//             bottomButton1Text = appBloc.localstr.detailsButtonEnrollbutton;
//             bottomButton1Tag = 6;
//             icon1 = IconDataSolid(int.parse('0xf271'));
//           } else {
//             print(
//                 'view222222 else ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.availableseats}');
//             if (isValidString(widget.table2.eventenddatetime) &&
//                 !returnEventCompleted(widget.table2.eventenddatetime)) {
//               bottomButton1Text = appBloc.localstr.detailsButtonEnrollbutton;
//               bottomButton1Tag = 6;
//               icon1 = IconDataSolid(int.parse('0xf271'));
//             }
//           }
//         }
//       } else if (widget.table2.viewtype == 3) {
//         if (!returnEventCompleted(widget.table2.eventenddatetime)) {
//           if (appBloc.uiSettingModel.AllowExpiredEventsSubscription
//                   .toString() ==
//               'true') {
//             bottomButton1Text = appBloc.localstr.eventsActionsheetBuynowoption;
//             bottomButton1Tag = 3;
//             icon1 = IconDataSolid(int.parse('0xf53d'));
//           }
//         }
//       }
//     }
//
//     print('viewrecordingg ${widget.table2.eventrecording}');
//
//     if (widget.table2.eventtype == 2 && widget.table2.objecttypeid == 70) {
//       bottomButton2Text = appBloc.localstr.detailsLabelSessionstitlelable;
//       bottomButton2Tag = 13;
//       icon2 = IconDataSolid(int.parse('0xf63d'));
//     } else if (widget.table2.eventtype == 1 &&
//         widget.table2.objecttypeid == 70) {
//       bottomButton1Text =
//           appBloc.localstr.mylearningActionsheetAddtocalendaroption;
//       bottomButton1Tag = 4;
//       icon2 = IconDataSolid(int.parse('0xf333'));
//     } else if ((widget.table2.eventrecording != null &&
//         widget.table2.eventrecording)) {
//       // viewrecording
//       if (widget.table2.isaddedtomylearning == 1) {
//         bottomButton2Text =
//             appBloc.localstr.learningtrackLabelEventviewrecording;
//         bottomButton2Tag = 14;
//         icon2 = IconDataSolid(int.parse('0xf0c1'));
//         enablePlay = true;
//       } else {
//         enablePlay = false;
//       }
//     }
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     flutterToast = Fluttertoast(context);
//     return SafeArea(
//       child: Scaffold(
//           bottomNavigationBar: (bottomButton1Text.isEmpty &&
//                   bottomButton2Text.isEmpty)
//               ? SizedBox(
//                   height: 1.h,
//                 )
//               : Container(
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                   child: (bottomButton1Text.isNotEmpty &&
//                           bottomButton2Text.isNotEmpty)
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             Padding(
//                               padding: bottomButton2Text.isNotEmpty
//                                   ? EdgeInsets.only(right: 5.h)
//                                   : EdgeInsets.all(0.0),
//                               child: FlatButton(
//                                 color: Color(int.parse(
//                                     "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                 onPressed: () {
//                                   onBottom1tap();
//                                 },
//                                 child: Row(
//                                   children: <Widget>[
//                                     Icon(
//                                       icon1,
//                                       color: Color(int.parse(
//                                           "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
//                                     ),
//                                     SizedBox(
//                                       width: 5.h,
//                                     ),
//                                     Text(
//                                       bottomButton1Text,
//                                       style: TextStyle(
//                                           color: Color(int.parse(
//                                               "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             (bottomButton1Text.isNotEmpty &&
//                                     bottomButton2Text.isNotEmpty)
//                                 ? Container(
//                                     width: 1.h,
//                                     height: 20.h,
//                                     color: Color(int.parse(
//                                         "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
//                                   )
//                                 : SizedBox(
//                                     height: 1.h,
//                                   ),
//                             Padding(
//                               padding: bottomButton1Text.isNotEmpty
//                                   ? EdgeInsets.only(left: 5.h)
//                                   : EdgeInsets.all(0.0),
//                               child: FlatButton(
//                                 color: Color(int.parse(
//                                     "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                 onPressed: () {
//                                   onBottom2tap();
//                                 },
//                                 child: Row(
//                                   children: <Widget>[
//                                     bottomButton2Tag == 13
//                                         ? SvgPicture.asset(
//                                             'assets/education.svg',
//                                             width: 25.h,
//                                             height: 25.h,
//                                             color: Color(int.parse(
//                                                 "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
//                                           )
//                                         : Icon(icon2),
//                                     SizedBox(
//                                       width: 5.h,
//                                     ),
//                                     Text(
//                                       bottomButton2Text,
//                                       style: TextStyle(
//                                           color: Color(int.parse(
//                                               "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ],
//                         )
//                       : bottomButton1Text.isNotEmpty
//                           ? FlatButton(
//                               color: Color(int.parse(
//                                   "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                               onPressed: () {
//                                 onBottom1tap();
//                               },
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Icon(
//                                     icon1,
//                                     color: Color(int.parse(
//                                         "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
//                                   ),
//                                   SizedBox(
//                                     width: 5.h,
//                                   ),
//                                   Text(
//                                     bottomButton1Text,
//                                     style: TextStyle(
//                                         color: Color(int.parse(
//                                             "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
//                                   ),
//                                 ],
//                               ))
//                           : FlatButton(
//                               color: Color(int.parse(
//                                   "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                               onPressed: () {
//                                 onBottom2tap();
//                               },
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Icon(
//                                     icon2,
//                                     color: Color(int.parse(
//                                         "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
//                                   ),
//                                   SizedBox(
//                                     width: 5.h,
//                                   ),
//                                   Text(
//                                     bottomButton2Text,
//                                     style: TextStyle(
//                                         color: Color(int.parse(
//                                             "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
//                                   ),
//                                 ],
//                               ),
//                             )),
//           appBar: AppBar(
//             elevation: 0,
//             title: Text(
//               'Course Details',
//               style: TextStyle(
//                   fontSize: 18,
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
//             ),
//             backgroundColor: Color(int.parse(
//                 "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
//             leading: InkWell(
//               onTap: () => Navigator.of(context).pop(),
//               child: Icon(Icons.arrow_back,
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
//             ),
//           ),
//           body: BlocConsumer(
//             bloc: catalogBloc,
//             listener: (context, state) {
//               if (state is AddToMyLearningState) {
//                 if (state.status == Status.COMPLETED) {
//                   Future.delayed(Duration(seconds: 1), () {
//                     // 5s over, navigate to a new page
//                     flutterToast.showToast(
//                       child: CommonToast(displaymsg: 'Added to my Learning'),
//                       gravity: ToastGravity.BOTTOM,
//                       toastDuration: Duration(seconds: 1),
//                     );
//                   });
//
//                   print(
//                       'availableseatsss_before ${widget.table2.availableseats}');
//                   setState(() {
//                     state.table2.isaddedtomylearning = 1;
//                     widget.table2.availableseats = availableSeats - 1;
//
//                     checkReportEnabled();
//                     setTag1();
//                     availableSeat = checkAvailableSeats(widget.table2);
//                   });
//
//                   print(
//                       'availableseatsss_after ${widget.table2.availableseats}');
//
//                   if (widget.isWishlisted != null) {
//                     Navigator.of(context).pop();
//                   }
//                 }
//               }
//             },
//             builder: (context, state) => Container(
//               color: Color(int.parse(
//                   "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//               child: Stack(
//                 children: <Widget>[
//                   BlocConsumer(
//                     bloc: evntModuleBloc,
//                     listener: (context, s) {
//                       if (s is ExpiryEventState) {
//                         if (s.status == Status.COMPLETED) {
//                           if (s.isSuccess == 'true') {
//                             Future.delayed(Duration(seconds: 5), () {
//                               // 5s over, navigate to a new page
//                               flutterToast.showToast(
//                                 child: CommonToast(
//                                     displaymsg: appBloc.localstr
//                                             .eventsAlertsubtitleThiseventitemhasbeenaddedto +
//                                         " " +
//                                         appBloc.localstr
//                                             .mylearningHeaderMylearningtitlelabel),
//                                 gravity: ToastGravity.BOTTOM,
//                                 toastDuration: Duration(seconds: 2),
//                               );
//                             });
//
//                             setState(() {
//                               s.table2.isaddedtomylearning = 1;
//                               checkReportEnabled();
//                               setTag1();
//                             });
//                           } else {
//                             flutterToast.showToast(
//                               child: CommonToast(
//                                   displaymsg: 'Something went wrong'),
//                               gravity: ToastGravity.BOTTOM,
//                               toastDuration: Duration(seconds: 2),
//                             );
//                           }
//                         } else if (s.status == Status.ERROR) {
//                           if (s.message == '401') {
//                             AppDirectory.sessionTimeOut(context);
//                           }
//                         }
//                       } else if (s is WaitingListState) {
//                         if (s.status == Status.COMPLETED) {
//                           if (s.waitingListResponse.isSuccess) {
//                             Future.delayed(Duration(seconds: 1), () {
//                               // 5s over, navigate to a new page
//                               flutterToast.showToast(
//                                 child: CommonToast(
//                                     displaymsg: s.waitingListResponse.message),
//                                 gravity: ToastGravity.BOTTOM,
//                                 toastDuration: Duration(seconds: 2),
//                               );
//                             });
//
//                             setState(() {
//                               widget.table2.waitlistenrolls = waitlistSeats + 1;
//                               availableSeat =
//                                   checkAvailableSeats(widget.table2);
//                             });
//                           } else {
//                             Future.delayed(Duration(seconds: 1), () {
//                               // 5s over, navigate to a new page
//                               flutterToast.showToast(
//                                 child: CommonToast(
//                                     displaymsg: s.waitingListResponse.message),
//                                 gravity: ToastGravity.BOTTOM,
//                                 toastDuration: Duration(seconds: 2),
//                               );
//                             });
//                           }
//                         } else if (s.status == Status.ERROR) {
//                           if (s.message == '401') {
//                             AppDirectory.sessionTimeOut(context);
//                           } else {
//                             flutterToast.showToast(
//                               child: CommonToast(
//                                   displaymsg: 'Something went wrong'),
//                               gravity: ToastGravity.BOTTOM,
//                               toastDuration: Duration(seconds: 2),
//                             );
//                           }
//                         }
//                       } else if (s is ViewRecordingState) {
//                         print('biewrecotdingg ${s.status}');
//                         if (s.status == Status.COMPLETED) {
//                           if (s.eventRecordingResponse != null) {
//                             launchViewRecordingLaunchPath(
//                                 s.eventRecordingResponse,
//                                 widget.table2,
//                                 context);
//                           }
//                         } else if (s.status == Status.ERROR) {
//                           if (s.message == '401') {
//                             AppDirectory.sessionTimeOut(context);
//                           } else {
//                             flutterToast.showToast(
//                               child: CommonToast(
//                                   displaymsg: 'Something went wrong'),
//                               gravity: ToastGravity.BOTTOM,
//                               toastDuration: Duration(seconds: 2),
//                             );
//                           }
//                         }
//                       }
//                     },
//                     builder: (context, s) => Stack(
//                       children: <Widget>[
//                         BlocConsumer(
//                             bloc: detailsBloc,
//                             listener: (context, state) {
//                               if (state.status == Status.COMPLETED) {
//                                 if (state is GetReviewsDetailstate) {
//                                   reviewList = detailsBloc.userRatingDetails;
//                                   print('reviewlistdata $reviewList');
//                                   ratingCount = state.review.recordCount;
//                                   if (state.review.editRating == null) {
//                                     isEditRating = false;
//                                   } else {
//                                     isEditRating = true;
//                                   }
//                                   getDetailsApiCall(widget.contentid);
//                                 } else if (state is GetLearningDetailsState) {
//                                   print("GetLearningDetailsState-----${state}");
//                                   if (state.status == Status.COMPLETED) {
//                                     print("bloc data-----${data.toString()}");
//
//                                     data = state.data;
//                                   }
//                                 }
//                               } else if (state is GetLearningDetailsState) {
//                                 print("GetLearningDetailsState-----${state}");
//                                 if (state.status == Status.COMPLETED) {
//                                   print("bloc data-----${data.toString()}");
//                                   data = state.data;
//                                 }
//                               } else if (state.status == Status.ERROR) {
//                                 if (state.message == '401') {
//                                   AppDirectory.sessionTimeOut(context);
//                                 } else {
//                                   print('dont do navigation');
//                                 }
//                               }
//                             },
//                             builder: (context, state) {
//                               print("data-----${data.toString()}");
//                               return Stack(
//                                 children: <Widget>[
//                                   (data != null)
//                                       ? Container(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           child: SingleChildScrollView(
//                                             child: Padding(
//                                               padding:
//                                                   EdgeInsets.only(bottom: 20.h),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     height: 190.h,
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                             .size
//                                                             .width,
//                                                     child: Stack(
//                                                       children: <Widget>[
//                                                         Container(
//                                                           height: 160.h,
//                                                           width: MediaQuery.of(
//                                                                   context)
//                                                               .size
//                                                               .width,
//                                                           child:
//                                                               CachedNetworkImage(
//                                                             placeholder:
//                                                                 (context,
//                                                                         url) =>
//                                                                     Image.asset(
//                                                               'assets/cellimage.jpg',
//                                                               width:
//                                                                   MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .width,
//                                                               fit: BoxFit.fill,
//                                                             ),
//                                                             errorWidget:
//                                                                 (context, url,
//                                                                         error) =>
//                                                                     Image.asset(
//                                                               'assets/cellimage.jpg',
//                                                               width:
//                                                                   MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .width,
//                                                               fit: BoxFit.fill,
//                                                             ),
//                                                             imageUrl: (widget
//                                                                         ?.table2
//                                                                         ?.thumbnailimagepath
//                                                                         ?.toString()
//                                                                         ?.startsWith(
//                                                                             'http') ??
//                                                                     false)
//                                                                 ? widget?.table2
//                                                                         ?.thumbnailimagepath ??
//                                                                     ''
//                                                                 : (widget?.table2
//                                                                             ?.siteurl
//                                                                             ?.trim() ??
//                                                                         '') +
//                                                                     (widget?.table2
//                                                                             ?.thumbnailimagepath
//                                                                             ?.trim() ??
//                                                                         ''),
//                                                             fit:
//                                                                 BoxFit.fitWidth,
//                                                           ),
//                                                         ),
//                                                         enablePlay
//                                                             ? Center(
//                                                                 child: InkWell(
//                                                                     onTap: () {
//                                                                       getViewRecordingUrlData(
//                                                                           widget
//                                                                               .table2);
//                                                                     },
//                                                                     child: Icon(
//                                                                       Icons
//                                                                           .play_circle_outline,
//                                                                       color: Color(
//                                                                           int.parse(
//                                                                               "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
//                                                                       size:
//                                                                           60.h,
//                                                                     )),
//                                                               )
//                                                             : Container()
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 10.0),
//                                                     child: Text(
//                                                       data.titleName,
//                                                       style: TextStyle(
//                                                           fontSize: 17.h,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5.h,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 10.0),
//                                                     child: Text(
//                                                       widget.table2
//                                                               .description ??
//                                                           "",
//                                                       style: TextStyle(
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5.h,
//                                                   ),
//
//                                                   Padding(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               horizontal: 10.0),
//                                                       child: Text(
//                                                         availableSeat,
//                                                         style: TextStyle(
//                                                           fontSize: ScreenUtil()
//                                                               .setSp(13),
//                                                           color: Color(int.parse(
//                                                                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
//                                                               .withOpacity(0.5),
//                                                         ),
//                                                       )),
//                                                   SizedBox(
//                                                     height: 8.h,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 10.0),
//                                                     child: Text(
//                                                       widget.table2.tagname ??
//                                                           "",
//                                                       style: TextStyle(
//                                                         fontSize: ScreenUtil()
//                                                             .setSp(13),
//                                                         color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
//                                                             .withOpacity(0.5),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   !isValidString(
//                                                           widget.table2.tagname)
//                                                       ? Container()
//                                                       : SizedBox(
//                                                           height: 10.h,
//                                                         ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 10.0),
//                                                     child: Row(
//                                                       children: <Widget>[
//                                                         ClipOval(
//                                                           child: Image.network(
//                                                             imgUrl,
//                                                             width: 25.h,
//                                                             height: 25.h,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 5.h,
//                                                         ),
//                                                         Text(data.authorName,
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//                                                       ],
//                                                     ),
//                                                   ),
//
//                                                   SizedBox(
//                                                     height: 10.h,
//                                                   ),
//                                                   widget.table2.objecttypeid ==
//                                                           70
//                                                       ? Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       10.0),
//                                                           child: Row(
//                                                             children: <Widget>[
//                                                               Icon(
//                                                                   Icons
//                                                                       .timelapse,
//                                                                   color: Color(
//                                                                       int.parse(
//                                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                               SizedBox(
//                                                                 width: 10.h,
//                                                               ),
//                                                               Flexible(
//                                                                 child: Text(
//                                                                   'From ${data.eventStartDateTimeWithoutConvert} to ${data.eventEndDateTimeTimeWithoutConvert}',
//                                                                   style:
//                                                                       TextStyle(
//                                                                     fontSize: ScreenUtil()
//                                                                         .setSp(
//                                                                             13),
//                                                                     color: Color(int.parse(
//                                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
//                                                                         .withOpacity(
//                                                                             0.5),
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         )
//                                                       : Container(),
//                                                   SizedBox(
//                                                     height: 10.h,
//                                                   ),
//                                                   widget.table2.objecttypeid ==
//                                                           70
//                                                       ? Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       10.0),
//                                                           child: Text(
//                                                             data.timeZone
//                                                                     .toString() ??
//                                                                 "",
//                                                             style: TextStyle(
//                                                               fontSize:
//                                                                   ScreenUtil()
//                                                                       .setSp(
//                                                                           13),
//                                                               color: Color(
//                                                                       int.parse(
//                                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
//                                                                   .withOpacity(
//                                                                       0.5),
//                                                             ),
//                                                           ))
//                                                       : Container(),
//                                                   SizedBox(
//                                                     height: 15.h,
//                                                   ),
//                                                   (widget.table2.objecttypeid ==
//                                                               70 &&
//                                                           isValidString(widget
//                                                               .table2
//                                                               .locationname) &&
//                                                           widget.table2
//                                                                   .locationname
//                                                                   .toString()
//                                                                   .length >
//                                                               2)
//                                                       ? Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       10.0),
//                                                           child: Row(
//                                                             children: <Widget>[
//                                                               Icon(
//                                                                   Icons
//                                                                       .location_on,
//                                                                   color: Color(
//                                                                       int.parse(
//                                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                               Text(
//                                                                 widget.table2
//                                                                         .locationname
//                                                                         .toString() ??
//                                                                     "",
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize:
//                                                                       ScreenUtil()
//                                                                           .setSp(
//                                                                               13),
//                                                                   color: Color(int
//                                                                           .parse(
//                                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
//                                                                       .withOpacity(
//                                                                           0.5),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ))
//                                                       : Container(),
//                                                   SizedBox(
//                                                     height: 15.h,
//                                                   ),
//                                                   widget.table2.keywords != ""
//                                                       ? Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       10.0),
//                                                           child: Text(
//                                                             'Keywords',
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                 int.parse(
//                                                                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//                                                               ),
//                                                               fontSize: 17.h,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                             ),
//                                                           ),
//                                                         )
//                                                       : Container(),
//                                                   widget.table2.keywords != ""
//                                                       ? SizedBox(
//                                                           height: 5.h,
//                                                         )
//                                                       : Container(),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 10.0),
//                                                     child: widget.table2
//                                                                 .keywords !=
//                                                             ""
//                                                         ? Text(
//                                                             widget?.table2
//                                                                     ?.keywords ??
//                                                                 '',
//                                                             style: TextStyle(
//                                                                 fontSize: 14.h,
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                           )
//                                                         : Container(),
//                                                   ),
//                                                   widget.table2.keywords != ""
//                                                       ? SizedBox(
//                                                           height: 10.h,
//                                                         )
//                                                       : Container(),
//                                                   SizedBox(
//                                                     height: 10.h,
//                                                   ),
//                                                   data.learningObjectives != ""
//                                                       ? Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       10.0),
//                                                           child: Text(
//                                                             "What you'll learn",
//                                                             style: TextStyle(
//                                                               fontSize: 17.h,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: Color(
//                                                                   int.parse(
//                                                                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                             ),
//                                                           ),
//                                                         )
//                                                       : widget.table2
//                                                                   .learningobjectives !=
//                                                               ""
//                                                           ? Padding(
//                                                               padding: EdgeInsets
//                                                                   .symmetric(
//                                                                       horizontal:
//                                                                           10.0),
//                                                               child: Text(
//                                                                 "What you'll learn",
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize:
//                                                                       17.h,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                   color: Color(
//                                                                       int.parse(
//                                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           : Container(),
//                                                   data.learningObjectives != ""
//                                                       ? SizedBox(
//                                                           height: 5.h,
//                                                         )
//                                                       : Container(),
//                                                   data.learningObjectives != ""
//                                                       ? Container(
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                                   right: 10.h,
//                                                                   left: 10.h),
//                                                           child: Html(
//                                                             data: data
//                                                                 .learningObjectives,
//                                                             style: {
//                                                               "body": Style(
//                                                                   color: Color(
//                                                                       int.parse(
//                                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                             },
//                                                           ),
//                                                         )
//                                                       : widget.table2
//                                                                   .learningobjectives !=
//                                                               ""
//                                                           ? Container(
//                                                               padding: EdgeInsets
//                                                                   .only(
//                                                                       right:
//                                                                           10.h,
//                                                                       left:
//                                                                           10.h),
//                                                               child: Html(
//                                                                 data: data
//                                                                     .learningObjectives,
//                                                                 style: {
//                                                                   "body": Style(
//                                                                       color: Color(
//                                                                           int.parse(
//                                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                                 },
//                                                               ),
//                                                             )
//                                                           : Container(),
//                                                   SizedBox(
//                                                     height: 10.h,
//                                                   ),
//                                                   (removeAllHtmlTags(data
//                                                                   .longDescription) !=
//                                                               null ||
//                                                           removeAllHtmlTags(data
//                                                                   .shortDescription) !=
//                                                               null)
//                                                       ? Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       10.0),
//                                                           child: Text(
//                                                               appBloc.localstr
//                                                                   .detailsLabelDescriptionlabel,
//                                                               style: TextStyle(
//                                                                 fontSize: 17.h,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                               )),
//                                                         )
//                                                       : Container(),
//                                                   SizedBox(
//                                                     height: 5.h,
//                                                   ),
//                                                   Container(
//                                                     padding: EdgeInsets.only(
//                                                         right: 10.h,
//                                                         left: 10.h),
//                                                     child: Html(
//                                                       shrinkWrap: true,
//                                                       data: data.longDescription !=
//                                                               null
//                                                           ? data.longDescription
//                                                           : data.shortDescription !=
//                                                                   null
//                                                               ? data
//                                                                   .shortDescription
//                                                               : '',
//                                                       style: {
//                                                         "body": Style(
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                       },
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 10.h,
//                                                   ),
//                                                   data.tableofContent != ""
//                                                       ? Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       10.0),
//                                                           child: Text(
//                                                               "Program Outline",
//                                                               style: TextStyle(
//                                                                 fontSize: 17.h,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                               )),
//                                                         )
//                                                       : Container(),
//                                                   data.tableofContent != ""
//                                                       ? SizedBox(
//                                                           height: 5.h,
//                                                         )
//                                                       : Container(),
//                                                   data.tableofContent != ""
//                                                       ? Container(
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                                   right: 10.h,
//                                                                   left: 10.h),
//                                                           child: Html(
//                                                             data: data
//                                                                 .tableofContent,
//                                                           ),
//                                                         )
//                                                       : Container(),
//
//                                                   SizedBox(
//                                                     height: 20.h,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 10.0),
//                                                     child: Text(
//                                                       'Rate and review',
//                                                       style: TextStyle(
//                                                         fontSize: 17.h,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5.h,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 10.0),
//                                                     child: Row(
//                                                       children: <Widget>[
//                                                         SmoothStarRating(
//                                                             allowHalfRating:
//                                                                 false,
//                                                             onRated: (v) {},
//                                                             starCount: 5,
//                                                             rating: widget
//                                                                     .table2
//                                                                     .ratingid ??
//                                                                 0.0,
//                                                             isReadOnly: true,
//                                                             // filledIconData: Icons.blur_off,
//                                                             // halfFilledIconData: Icons.blur_on,
//                                                             color:
//                                                                 Colors.orange,
//                                                             borderColor:
//                                                                 Colors.orange,
//                                                             spacing: 3.h),
//                                                         SizedBox(
//                                                           width: 5.h,
//                                                         ),
//                                                         Text(
//                                                             widget.table2
//                                                                     .ratingid
//                                                                     .toString() ??
//                                                                 '0.0',
//                                                             style: TextStyle(
//                                                               fontSize: 22.h,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: Color(
//                                                                 int.parse(
//                                                                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//                                                               ),
//                                                             )),
//                                                         Text('($ratingCount)',
//                                                             textAlign:
//                                                                 TextAlign.end,
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 15.h,
//                                                   ),
//
//                                                   ListView.builder(
//                                                       shrinkWrap: true,
//                                                       physics: ScrollPhysics(),
//                                                       itemCount:
//                                                           reviewList.length,
//                                                       itemBuilder:
//                                                           (context, pos) {
//                                                         return Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   vertical: 8.h,
//                                                                   horizontal:
//                                                                       10.h),
//                                                           child: Row(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: <Widget>[
//                                                               ClipOval(
//                                                                 child: Image
//                                                                     .network(
//                                                                   ApiEndpoints
//                                                                           .strSiteUrl +
//                                                                       reviewList[
//                                                                               pos]
//                                                                           .picture,
//                                                                   width: 25.h,
//                                                                   height: 25.h,
//                                                                   fit: BoxFit
//                                                                       .cover,
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 width: 10.h,
//                                                               ),
//                                                               Expanded(
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: <
//                                                                       Widget>[
//                                                                     Row(
//                                                                       children: <
//                                                                           Widget>[
//                                                                         Text(
//                                                                           reviewList[pos]
//                                                                               .userName,
//                                                                           style:
//                                                                               TextStyle(
//                                                                             fontWeight:
//                                                                                 FontWeight.bold,
//                                                                             color:
//                                                                                 Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                                           ),
//                                                                           overflow:
//                                                                               TextOverflow.ellipsis,
//                                                                           maxLines:
//                                                                               1,
//                                                                         ),
//                                                                         SizedBox(
//                                                                           width:
//                                                                               2.h,
//                                                                         ),
//                                                                         SizedBox(
//                                                                           width:
//                                                                               5.h,
//                                                                         ),
//                                                                         SmoothStarRating(
//                                                                             allowHalfRating:
//                                                                                 false,
//                                                                             onRated:
//                                                                                 (v) {},
//                                                                             starCount:
//                                                                                 5,
//                                                                             rating: reviewList[pos]
//                                                                                 .ratingId
//                                                                                 .toDouble(),
//                                                                             size: 15
//                                                                                 .h,
//                                                                             isReadOnly:
//                                                                                 true,
//                                                                             // filledIconData: Icons.blur_off,
//                                                                             // halfFilledIconData: Icons.blur_on,
//                                                                             color:
//                                                                                 Colors.orange,
//                                                                             borderColor: Colors.orange,
//                                                                             spacing: 0.0),
//                                                                       ],
//                                                                     ),
//                                                                     Row(
//                                                                       children: <
//                                                                           Widget>[
//                                                                         Expanded(
//                                                                           flex:
//                                                                               4,
//                                                                           child:
//                                                                               Text(
//                                                                             reviewList[pos].description,
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Expanded(
//                                                                             flex:
//                                                                                 1,
//                                                                             child: (reviewList[pos].ratingUserId.toString() == strUserID)
//                                                                                 ? IconButton(
//                                                                                     onPressed: () {
//                                                                                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewScreen(widget.contentid, true, widget.detailsBloc)));
//                                                                                     },
//                                                                                     iconSize: 20.h,
//                                                                                     icon: Icon(Icons.edit, color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                                                   )
//                                                                                 : Container()),
//                                                                       ],
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         );
//                                                       }),
//                                                   SizedBox(
//                                                     height: 10.h,
//                                                   ),
//                                                   ratingCount >
//                                                           reviewList.length
//                                                       ? Center(
//                                                           child: InkWell(
//                                                             onTap: () {
//                                                               setState(() {
//                                                                 detailsBloc.add(GetDetailsReviewEvent(
//                                                                     contentId:
//                                                                         widget
//                                                                             .contentid,
//                                                                     skippedRows:
//                                                                         reviewList
//                                                                             .length));
//                                                               });
//                                                             },
//                                                             child: Text(
//                                                               appBloc.localstr
//                                                                   .detailsButtonLoadmorebutton,
//                                                               style: TextStyle(
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         )
//                                                       : Container(),
//                                                   SizedBox(
//                                                     height: 20.h,
//                                                   ),
// //
//                                                   SizedBox(
//                                                     height: 20.h,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       : Container(),
//                                   (state.status == Status.LOADING)
//                                       ? Center(
//                                           child: AbsorbPointer(
//                                             child: SpinKitCircle(
//                                               color: Colors.grey,
//                                               size: 70.h,
//                                             ),
//                                           ),
//                                         )
//                                       : Container()
//                                 ],
//                               );
//                             }),
//                         (s.status == Status.LOADING)
//                             ? Center(
//                                 child: AbsorbPointer(
//                                   child: SpinKitCircle(
//                                     color: Colors.grey,
//                                     size: 70.h,
//                                   ),
//                                 ),
//                               )
//                             : Container()
//                       ],
//                     ),
//                   ),
//                   (state.status == Status.LOADING)
//                       ? Center(
//                           child: AbsorbPointer(
//                             child: SpinKitCircle(
//                               color: Colors.grey,
//                               size: 70.h,
//                             ),
//                           ),
//                         )
//                       : Container()
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
//
//   void getUserId() async {
//     strUserID = await sharePref_getString(sharedPref_userid);
//   }
//
//   void getDetailsApiCall(String contentid) {
//     MyLearningDetailsRequest detailsRequest = MyLearningDetailsRequest();
//     detailsRequest.locale = 'en-us';
//     detailsRequest.contentId = widget.contentid;
//     detailsRequest.metadata = '1';
//     detailsRequest.intUserId = strUserID;
//     detailsRequest.iCms = false;
//     detailsRequest.componentId = '';
//     detailsRequest.siteId = ApiEndpoints.siteID;
//     detailsRequest.eRitems = '';
//     detailsRequest.detailsCompId = '107';
//     detailsRequest.detailsCompInsId = '3291';
//     detailsRequest.componentDetailsProperties = '';
//     detailsRequest.hideAdd = 'false';
//     detailsRequest.objectTypeId = '-1';
//     detailsRequest.scoId = '';
//     detailsRequest.subscribeErc = false;
//
//     detailsBloc
//         .add(GetLearningDetails(myLearningDetailsRequest: detailsRequest));
//
//     print("om--------${detailsRequest.toString()}");
//   }
//
//   String removeAllHtmlTags(String htmlText) {
//     String parsedString = null;
//
//     if (htmlText != null) {
//       var document = parse(htmlText);
//
//       parsedString = parse(document.body.text).documentElement.text;
//     }
//
//     return parsedString;
//   }
//
//   void onBottom1tap() {
//     switch (bottomButton1Tag) {
//       case 0:
//         break;
//
//       case 1:
//         if (isValidString(widget.table2.viewprerequisitecontentstatus)) {
//           String alertMessage =
//               appBloc.localstr.prerequistesalerttitle6Alerttitle6;
//           alertMessage = alertMessage +
//               " \"" +
//               widget.table2.viewprerequisitecontentstatus +
//               "\" " +
//               appBloc.localstr.prerequistesalerttitle5Alerttitle7;
//
//           showDialog(
//               context: context,
//               builder: (BuildContext context) => new AlertDialog(
//                     title: Text(
//                       appBloc.localstr.detailsAlerttitleStringalert,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     content: Text(alertMessage),
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(5)),
//                     actions: <Widget>[
//                       new FlatButton(
//                         child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
//                         textColor: Colors.blue,
//                         onPressed: () async {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ));
//         } else {
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => EventTrackList(
//                     widget.table2,
//                     false,
//                     myLearningBloc.list,
//                   )));
//         }
//
//         break;
//
//       case 3:
//         break;
//
//       case 4:
//         callAddToCalendar();
//         break;
//
//       case 6:
//         addToEnroll(widget.table2);
//         break;
//
//       default:
//     }
//   }
//
//   void onBottom2tap() {
//     switch (bottomButton2Tag) {
//       case 0:
//         break;
//
//       case 5:
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) =>
//                 ProgressReport(widget.table2, detailsBloc, "", "-1")));
//         break;
//
//       case 13:
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => SessionEvent(
//                   contentId: widget.contentid,
//                 )));
//         break;
//
//       case 14:
//         getViewRecordingUrlData(widget.table2);
//
//         break;
//
//       default:
//     }
//   }
//
//   void getViewRecordingUrlData(
//       DummyMyCatelogResponseTable2 learningModel) async {
//     evntModuleBloc.add(ViewRecordingEvent(
//         strContentID: learningModel.contentid, table2: learningModel));
//   }
//
//   void launchViewRecordingLaunchPath(EventRecordingResponse recordingModel,
//       DummyMyCatelogResponseTable2 learningModel, BuildContext context) {
//     String launchPath = "";
//
//     if (isValidString(recordingModel.viewLink) ||
//         isValidString(recordingModel.eventRecordingUrl) ||
//         isValidString(recordingModel.eventRecordingContentId)) {
//       if (!isValidString(recordingModel.eventRecordingContentId)) {
//         launchPath = recordingModel.eventRecordingUrl;
//       } else {
//         String viewLink = recordingModel.viewLink.replaceAll("/", "~");
//         launchPath = ApiEndpoints.strSiteUrl +
//             "ajaxcourse/ContentName/" +
//             learningModel.name +
//             "/ScoID/" +
//             recordingModel.scoId +
//             "/ContentTypeId/" +
//             recordingModel.contentTypeId +
//             "/ContentID/" +
//             recordingModel.contentId +
//             "/AllowCourseTracking/true/trackuserid/" +
//             learningModel.userid +
//             "/ismobilecontentview/true/ContentPath/" +
//             viewLink +
//             "?nativeappURL=true" +
//             "/JWVideoParentID/" +
//             learningModel.contentid +
//             "/jwvideokey/" +
//             recordingModel.jwVideoKey;
//       }
//
//       if (isValidString(launchPath)) {
//         launchPath = launchPath.trim();
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) =>
//                 AdvancedWebCourseLaunch(launchPath, learningModel.name)));
//       }
//     } else {
//       showDialog(
//           builder: (BuildContext context) => new AlertDialog(
//                 content: Text(recordingModel.eventRecordingMessage),
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: new BorderRadius.circular(5)),
//                 actions: <Widget>[
//                   new FlatButton(
//                     child: Text(
//                         appBloc.localstr.commoncomponentAlertbut
//           context: context,
//           builder: (BuildContext context) => new AlertDialog(
//                 content: Text(recordingModel.eventRecordingMessage),
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: new BorderRadius.circular(5)),
//                 actions: <Widget>[
//                   new FlatButton(
//                     child: Text(
//                         appBloc.localstr.commoncomponentAlertbuttonOkbutton),
//                     textColor: Colors.blue,
//                     onPressed: () async {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ));
//     }
//   }
//
//   void callAddToCalendar() {
//     DateTime startDate = new DateFormat("yyyy-MM-ddTHH:mm:ss")
//         .parse(widget.table2.eventstartdatetime);
//     DateTime endDate = new DateFormat("yyyy-MM-ddTHH:mm:ss")
//         .parse(widget.table2.eventenddatetime);
//
// //            print(
// //                'event start-end time ${table2.eventstartdatetime}  ${table2.eventenddatetime}');
//     Event event = Event(
//       title: widget.table2.name,
//       description: widget.table2.shortdescription,
//       location: widget.table2.locationname,
//       startDate: startDate,
//       endDate: endDate,
//       allDay: false,
//     );
//
//     Add2Calendar.addEvent2Cal(event).then((success) {
//       flutterToast.showToast(
//         child: CommonToast(
//             displaymsg: success
//                 ? 'Event added successfully'
//                 : 'Error occured while adding event'),
//         gravity: ToastGravity.BOTTOM,
//         toastDuration: Duration(seconds: 2),
//       );
//     });
//   }
//
//   void addToEnroll(DummyMyCatelogResponseTable2 table2) {
//     if (appBloc.uiSettingModel.AllowExpiredEventsSubscription == 'true' &&
//         returnEventCompleted(table2.eventenddatetime)) {
//       try {
//         addExpiryEvets(table2, 0);
//       } catch (e) {
//         e.toString();
//       }
//     } else {
//       int avaliableSeats = 0;
//       avaliableSeats = table2.availableseats ?? 0;
//
//       if (avaliableSeats > 0) {
//         catalogBloc.add(
//             AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
//       } else if (isValidString(table2.actionwaitlist) &&
//           table2.actionwaitlist == "true") {
//         String alertMessage = appBloc
//             .localstr.eventdetailsenrollementAlertsubtitleEventenrollmentlimit;
//         showDialog(
//             context: context,
//             builder: (BuildContext context) => new AlertDialog(
//                   title: Text(
//                     appBloc.localstr.eventsActionsheetEnrolloption,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   content: Text(alertMessage),
//                   backgroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(5)),
//                   actions: <Widget>[
//                     new FlatButton(
//                       child: Text(
//                           appBloc.localstr.mylearningAlertbuttonCancelbutton),
//                       textColor: Colors.blue,
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     new FlatButton(
//                       child:
//                           Text(appBloc.localstr.myskillAlerttitleStringconfirm),
//                       textColor: Colors.blue,
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                         addToWaitList(table2);
//                       },
//                     ),
//                   ],
//                 ));
//       } else {
//         catalogBloc.add(
//             AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
//       }
//     }
//   }
//
//   void addExpiryEvets(DummyMyCatelogResponseTable2 table2, int position) {
//     evntModuleBloc
//         .add(AddExpiryEvent(table2: table2, strContentID: table2.contentid));
//   }
//
//   void addToWaitList(DummyMyCatelogResponseTable2 catalogModel) {
//     evntModuleBloc.add(WaitingListEvent(
//         strContentID: catalogModel.contentid, table2: catalogModel));
//   }
//
//   String checkAvailableSeats(DummyMyCatelogResponseTable2 table2) {
//     int avaliableSeats = 0;
//     String seatVal;
//
//     try {
//       avaliableSeats = table2.availableseats;
//     } catch (nf) {
//       avaliableSeats = 0;
//       nf.printStackTrace();
//     }
//     if (avaliableSeats > 0) {
//       seatVal = 'Available seats ${table2.availableseats}';
//     } else if (avaliableSeats <= 0) {
//       if (table2.enrollmentlimit == table2.noofusersenrolled &&
//               table2.waitlistlimit == 0 ||
//           (table2.waitlistlimit != -1 &&
//               table2.waitlistlimit == table2.waitlistenrolls)) {
//         seatVal = 'Enrollment Closed';
//       } else if (table2.waitlistlimit != -1 &&
//           table2.waitlistlimit != table2.waitlistenrolls) {
//         if (table2.waitlistlimit != null) {
//           int waitlistSeatsLeftout =
//               table2.waitlistlimit - table2.waitlistenrolls;
//           if (waitlistSeatsLeftout > 0) {
//             seatVal = 'Full | Waitlist seats $waitlistSeatsLeftout';
//           }
//         }
//       }
//     }
//
//     return seatVal;
//   }
// }
