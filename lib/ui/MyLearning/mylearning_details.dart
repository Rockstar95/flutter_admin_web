// import 'dart:async';
// import 'dart:io';
//
// import 'package:add_2_calendar/add_2_calendar.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:html/parser.dart';
// import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning_details_response.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
// import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
// import 'package:flutter_admin_web/framework/common/constants.dart';
// import 'package:flutter_admin_web/framework/common/enums.dart';
// import 'package:flutter_admin_web/framework/common/pref_manger.dart';
// import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
// import 'package:flutter_admin_web/framework/helpers/downloader/download_course.dart';
// import 'package:flutter_admin_web/framework/helpers/utils.dart';
// import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
// import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
// import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
// import 'package:flutter_admin_web/ui/MyLearning/progress_report.dart';
// import 'package:flutter_admin_web/ui/MyLearning/qr_code_screen.dart';
// import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
// import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
// import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
// import 'package:flutter_admin_web/ui/MyLearning/view_certificate.dart';
// import 'package:flutter_admin_web/ui/common/common_toast.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
//
// import 'common_detail_screen.dart';
//
// class MyLearningDetails extends StatefulWidget {
//   final String contentid;
//   final int objtypeId;
//   final MyLearningDetailsBloc detailsBloc;
//   final DummyMyCatelogResponseTable2 table2;
//   final int pos;
//   final List<DummyMyCatelogResponseTable2> mylearninglist;
//
//   MyLearningDetails(
//       {this.contentid,
//       this.objtypeId,
//       this.detailsBloc,
//       this.table2,
//       this.pos,
//       this.mylearninglist});
//
//   @override
//   _MyLearningDetailsState createState() => _MyLearningDetailsState();
// }
//
// class _MyLearningDetailsState extends State<MyLearningDetails>
//     with SingleTickerProviderStateMixin {
//   bool isReportEnabled = true;
//
//   MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);
//
//   AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
//   MyLearningDetailsBloc detailsBloc;
//   TabController _tabController;
//   List<Tab> tabList = List();
//   List<EditRating> reviewList = [];
//   bool isFromCatalog = false, isReschdule = false;
//   String typeFrom = "";
//   int ratingCount = 0;
//   var strUserID = '';
//   bool isEditRating = false;
//   int skippedRows = 0;
//   MyLearningDetailsResponse data;
//   Fluttertoast flutterToast;
//   DownloadCourse downloadCourse;
//   GotoCourseLaunch courseLaunch;
//   int downloadedProgess = 0;
//   String downloadDestFolderPath;
//
//   StreamController<int> streamController = new StreamController();
//
//   bool download = false;
//
//   String eventstartDate = '';
//   String eventendDate = '';
//
//   String imgUrl =
//       "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
//
//   @override
//   void initState() {
//     super.initState();
//
//     detailsBloc = widget.detailsBloc;
//     detailsBloc.userRatingDetails.clear();
//     detailsBloc.add(GetDetailsReviewEvent(
//         contentId: widget.contentid, skippedRows: skippedRows));
//     print(
//         'contentidd ${widget.table2.percentcompleted}  objectypeid ${widget.objtypeId.toString()}');
//
// //    widget.table2
// //        .setobjecttypeid(widget.objtypeId.toString());
//
//     tabList.add(new Tab(
//       text: 'Sessions',
//     ));
//     tabList.add(new Tab(
//       text: 'Resource',
//     ));
//     tabList.add(new Tab(
//       text: 'Glossary',
//     ));
//     _tabController = new TabController(length: tabList.length, vsync: this);
//     getUserId();
//
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
//     downloadPath(widget.table2.contentid, widget.table2);
//     // download = displayDownload(widget.table2); commented till offline implemented
//     Future.delayed(Duration.zero, () {
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => CommonDetailScreen(
//                 contentid: widget.contentid,
//                 objtypeId: widget.objtypeId,
//                 detailsBloc: detailsBloc,
//                 table2: widget.table2,
//                 screenType: ScreenType.MyLearning,
// // nativeModel:
// // widget.nativeMenuModel,
//               )));
//     });
//   }
//
//   void downloadPath(
//       String contentid, DummyMyCatelogResponseTable2 table2) async {
//     String path = await AppDirectory.getDocumentsDirectory() +
//         "/.Mydownloads/Contentdownloads" +
//         "/" +
//         contentid;
//
//     setState(() {
//       downloadDestFolderPath = path;
//     });
//
//     checkFile(downloadDestFolderPath, table2);
//   }
//
//   void checkFile(String path, DummyMyCatelogResponseTable2 table2) async {
//     final savedDir = Directory(path);
//     if (await savedDir.exists()) {
//       setState(() {
//         table2.isdownloaded = true;
//       });
//     } else {
//       setState(() {
//         table2.isdownloaded = false;
//       });
//     }
//   }
//
//   void doSomething(int i, DummyMyCatelogResponseTable2 table2, int progress) {
//     /* ... */
//     print('dosomethingofdata $progress');
//
//     try {
//       if (i != null) {
//         if (progress == -1) {
//           setState(() {
//             table2.isdownloaded = false;
//             table2.isDownloading = false;
//           });
//
//           flutterToast.showToast(
//             child: CommonToast(displaymsg: 'Error while downloading'),
//             gravity: ToastGravity.BOTTOM,
//             toastDuration: Duration(seconds: 2),
//           );
//         }
//         if (progress == 100) {
//           setState(() {
//             table2.isdownloaded = true;
//             table2.isDownloading = false;
//           });
//         } else {
//           setState(() {
// //        myLearningBloc.list[i].isdownloaded = true;
//             downloadedProgess = progress;
//             table2.isDownloading = true;
//           });
//         }
//       }
//     } catch (e) {
//       setState(() {
//         table2.isdownloaded = false;
//         table2.isDownloading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     flutterToast = Fluttertoast(context);
//
//     basicDeviceHeightWidth(
//         MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
//
//     Color statuscolor = Color(0xff5750da);
//
//     if (widget.table2.corelessonstatus.toString().contains("Completed")) {
//       statuscolor = Color(0xff4ad963);
//     } else if (widget.table2.corelessonstatus.toString() == "Not Started") {
//       statuscolor = Color(0xfffe2c53);
//     } else if (widget.table2.corelessonstatus.toString() == "In Progress") {
//       statuscolor = Color(0xffff9503);
//     }
//
//     return BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
//       builder: (context, state) => SafeArea(
//         child: Scaffold(
//           backgroundColor: Color(
//             int.parse(
//                 "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
//           ),
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
//             actions: <Widget>[
// //
//               SizedBox(
//                 width: 10.h,
//               ),
// //              contextList.isNotEmpty ?
//               GestureDetector(
//                 onTap: () {
//                   _settingMyEventBottomSheet(context);
//                 },
//                 child: Icon(Icons.more_vert, color: Colors.grey),
//               ),
// //                  :Container(),
//               SizedBox(
//                 width: 10.h,
//               ),
//             ],
//           ),
//           body: BlocConsumer<MyLearningDetailsBloc, MyLearningDetailsState>(
//               bloc: detailsBloc,
//               listener: (context, state) {
//                 if (state.status == Status.COMPLETED) {
//                   if (state is GetReviewsDetailstate) {
//                     reviewList = detailsBloc.userRatingDetails;
//                     print('reviewlistdata $reviewList');
//                     ratingCount = state.review.recordCount;
//                     if (state.review.editRating == null) {
//                       isEditRating = false;
//                     } else {
//                       isEditRating = true;
//                     }
//                     print('getreviewdata $skippedRows');
// //                      reviewList = data;
//                     if (skippedRows == 0) {
//                       getDetailsApiCall(widget.contentid);
//                     }
//                   } else if (state is GetLearningDetailsState) {
//                     data = state.data;
//                   } else if (state is SetCompleteState) {
//                     print('hello completeddd');
//                     setState(() {
//                       widget.table2.percentcompleted = '100.00';
//                       widget.table2.progress = '100';
//                       widget.table2.corelessonstatus = 'Completed';
//                     });
//                   } else if (state is GetContentStatusState) {
//                     print(
//                         'getcontentstatusvl ${state.contentstatus.name} ${state.contentstatus.progress} ${state.contentstatus.contentStatus}');
//                     setState(() {
//                       widget.table2.actualstatus = state.contentstatus.name;
//                       widget.table2.progress =
//                           state.contentstatus.progress ?? '0';
//                       if (state.contentstatus.progress != null ||
//                           state.contentstatus.progress != '0') {
//                         widget.table2.percentcompleted =
//                             state.contentstatus.progress;
//                       }
//                       widget.table2.corelessonstatus =
//                           state.contentstatus.contentStatus;
//                     });
//                   }
//                 } else if (state.status == Status.ERROR) {
//                   if (state.message == '401') {
//                     AppDirectory.sessionTimeOut(context);
//                   } else {
//                     print('dont do navigation');
//                   }
//                 }
//               },
//               builder: (context, state) {
// //                if (state is GetLearningDetailsState &&
// //                    state.status == Status.COMPLETED) {
//                 print(
//                     'titlename ${widget.table2.siteurl}${widget.table2.qrcodeimagepath}');
//
//                 //Logger logger = Logger();
//
//                 //logger.e(".......longDescription....${ removeAllHtmlTags(data.longDescription)}");
//                 //logger.e(".......shortDescription....${ removeAllHtmlTags(data.shortDescription)}");
//
//                 return Stack(
//                   children: <Widget>[
//                     (data != null)
//                         ? Container(
//                             color: Color(int.parse(
//                                 "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                             child: SingleChildScrollView(
//                               child: Padding(
//                                 padding: EdgeInsets.only(bottom: 20.h),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Container(
//                                       height: 190.h,
//                                       width: MediaQuery.of(context).size.width,
//                                       child: Stack(
//                                         children: <Widget>[
//                                           Container(
//                                             height: 160.h,
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             child: CachedNetworkImage(
//                                               placeholder: (context, url) =>
//                                                   Image.asset(
//                                                 'assets/cellimage.jpg',
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 fit: BoxFit.fill,
//                                               ),
//                                               errorWidget:
//                                                   (context, url, error) =>
//                                                       Image.asset(
//                                                 'assets/cellimage.jpg',
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                               imageUrl: widget
//                                                       .table2.thumbnailimagepath
//                                                       .startsWith('http')
//                                                   ? widget
//                                                       .table2.thumbnailimagepath
//                                                   : widget.table2.siteurl +
//                                                       widget.table2
//                                                           .thumbnailimagepath,
//                                               fit: BoxFit.fitWidth,
//                                             ),
// //                                    Image.network(
// //                                      'https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg',
// //                                      fit: BoxFit.fitWidth,
// //                                    ),
//                                           ),
//                                           isValidString(
//                                                   widget.table2.qrcodeimagepath)
//                                               ? Positioned(
//                                                   bottom: 10.h,
//                                                   right: 60.h,
//                                                   child: Container(
//                                                     width: 40.h,
//                                                     height: 40.h,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       boxShadow: [
//                                                         BoxShadow(
//                                                           color: Colors.grey
//                                                               .withOpacity(0.5),
//                                                           spreadRadius: 1,
//                                                           blurRadius: 4,
//                                                           offset: Offset(0,
//                                                               3), // changes position of shadow
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     child: GestureDetector(
//                                                       onTap: () {
//                                                         Navigator.of(context).push(MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 QrCodeScreen(ApiEndpoints
//                                                                         .strSiteUrl +
//                                                                     widget
//                                                                         .table2
//                                                                         .qrcodeimagepath)));
//                                                       },
//                                                       child: isValidString(widget
//                                                               .table2
//                                                               .qrcodeimagepath)
//                                                           ? Image.network(
//                                                               ApiEndpoints
//                                                                       .strSiteUrl +
//                                                                   widget.table2
//                                                                       .qrcodeimagepath,
//                                                             )
//                                                           : SizedBox(
//                                                               height: 1.h,
//                                                             ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               : Container(),
//                                           Positioned(
//                                               bottom: 10.h,
//                                               right: 10.h,
//                                               child: download
//                                                   ? downloadIcon(widget.table2)
//                                                   : Container()),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 15.h),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: <Widget>[
//                                             Row(
//                                               children: <Widget>[
//                                                 Flexible(
//                                                     child: Text(
//                                                   data.titleName,
//                                                   style: TextStyle(
//                                                       color: Color(int.parse(
//                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                       fontSize: 17.h,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 )),
// //
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 5.h,
//                                             ),
//                                             Row(
//                                               children: <Widget>[
//                                                 ClipOval(
//                                                   child: Image.network(
//                                                     imgUrl,
//                                                     width: 25.h,
//                                                     height: 25.h,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 5.h,
//                                                 ),
//                                                 Text(data.authorName,
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 20.h,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               children: <Widget>[
//                                                 Flexible(
//                                                   flex: 9,
//                                                   child: Container(
//                                                     height: 7.h,
//                                                     child:
//                                                         LinearProgressIndicator(
//                                                       backgroundColor:
//                                                           Colors.grey.shade400,
//                                                       valueColor:
//                                                           AlwaysStoppedAnimation<
//                                                               Color>(
//                                                         statuscolor,
//                                                       ),
//                                                       value: isValidString(
//                                                               widget.table2
//                                                                   .progress)
//                                                           ? double.parse(widget
//                                                                   .table2
//                                                                   .progress) /
//                                                               100
//                                                           : 0.0,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Flexible(
//                                                     flex: 2,
//                                                     child: Text(
//                                                       '${widget.table2.progress.toString()} %',
//                                                       style: TextStyle(
//                                                           color: Color(
//                                                         int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//                                                       )),
//                                                     ))
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding: EdgeInsets.all(8.h),
//                                               child: Text(
//                                                 !isValidString(widget
//                                                             .table2.progress) &&
//                                                         widget.table2
//                                                                 .percentcompleted ==
//                                                             "0.0"
//                                                     ? '${data.actualStatus}'
//                                                     : '',
//                                                 style: TextStyle(
//                                                     color: Color(int.parse(
//                                                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                               ),
//                                             ),
//                                             widget.table2.keywords != ""
//                                                 ? Text(
//                                                     'Keywords',
//                                                     style: TextStyle(
//                                                         fontSize: 17.h,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   )
//                                                 : Container(),
//                                             widget.table2.keywords != ""
//                                                 ? SizedBox(
//                                                     height: 5.h,
//                                                   )
//                                                 : Container(),
//                                             widget.table2.keywords != ""
//                                                 ? Text(
//                                                     widget.table2.keywords,
//                                                     style: TextStyle(
//                                                         fontSize: 14.h,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                   )
//                                                 : Container(),
//                                             widget.table2.keywords != ""
//                                                 ? SizedBox(
//                                                     height: 10.h,
//                                                   )
//                                                 : Container(),
//                                             data.learningObjectives != ""
//                                                 ? Text(
//                                                     "What you'll learn",
//                                                     style: TextStyle(
//                                                         fontSize: 17.h,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   )
//                                                 : Container(),
//                                             data.learningObjectives != ""
//                                                 ? SizedBox(
//                                                     height: 5.h,
//                                                   )
//                                                 : Container(),
//                                             data.learningObjectives != ""
//                                                 ? Container(
//                                                     padding: EdgeInsets.only(
//                                                         right: 10.h),
//                                                     child: Html(
//                                                       data: data
//                                                           .learningObjectives,
//                                                     ),
//                                                   )
//                                                 : Container(),
//                                             widget.table2.objecttypeid != 70
//                                                 ? SizedBox(
//                                                     height: 20.h,
//                                                   )
//                                                 : Container(),
//                                             widget.table2.objecttypeid != 70
//                                                 ? (removeAllHtmlTags(data
//                                                                 .longDescription) !=
//                                                             null ||
//                                                         removeAllHtmlTags(data
//                                                                 .shortDescription) !=
//                                                             null)
//                                                     ? Text(
//                                                         appBloc.localstr
//                                                             .detailsLabelDescriptionlabel,
//                                                         style: TextStyle(
//                                                             fontSize: 17.h,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                       )
//                                                     : Container()
//                                                 : Container(),
//                                             SizedBox(
//                                               height: 5.h,
//                                             ),
//                                             widget.table2.objecttypeid != 70
//                                                 ? Container(
//                                                     padding: EdgeInsets.only(
//                                                         right: 10.h),
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
//                                                     ),
//                                                   )
//                                                 : Container(),
//                                             widget.table2.objecttypeid != 70
//                                                 ? SizedBox(
//                                                     height: 20.h,
//                                                   )
//                                                 : Container(),
//                                             data.tableofContent != ""
//                                                 ? Text(
//                                                     "Program Outline",
//                                                     style: TextStyle(
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                         fontSize: 17.h,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   )
//                                                 : Container(),
//                                             data.tableofContent != ""
//                                                 ? SizedBox(
//                                                     height: 5.h,
//                                                   )
//                                                 : Container(),
//                                             data.tableofContent != ""
//                                                 ? Container(
//                                                     padding: EdgeInsets.only(
//                                                         right: 10.h),
//                                                     child: Html(
//                                                       data: data.tableofContent,
//                                                     ),
//                                                   )
//                                                 : Container(),
//                                             widget.table2.objecttypeid == 70
//                                                 ? Row(
//                                                     children: <Widget>[
//                                                       Icon(Icons.timelapse),
//                                                       SizedBox(
//                                                         width: 10.h,
//                                                       ),
//                                                       Flexible(
//                                                         child: Text(
//                                                           'From ${data.eventStartDateTimeWithoutConvert} to ${data.eventEndDateTimeTimeWithoutConvert}',
//                                                           style: TextStyle(
//                                                               color: Color(
//                                                                   int.parse(
//                                                                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                         ),
//                                                       )
//                                                     ],
//                                                   )
//                                                 : Container(),
//                                             SizedBox(
//                                               height: 20.h,
//                                             ),
//                                             Text(
//                                               'Rate and Review',
//                                               style: TextStyle(
//                                                   fontSize: 17.h,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Color(int.parse(
//                                                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                             ),
//                                             SizedBox(
//                                               height: 5.h,
//                                             ),
//                                             Row(
//                                               children: <Widget>[
//                                                 SmoothStarRating(
//                                                     allowHalfRating: false,
//                                                     onRated: (v) {},
//                                                     starCount: 5,
//                                                     rating: widget
//                                                             .table2.ratingid ??
//                                                         0.0,
//                                                     isReadOnly: true,
//                                                     // filledIconData: Icons.blur_off,
//                                                     // halfFilledIconData: Icons.blur_on,
//                                                     color: Colors.orange,
//                                                     borderColor: Colors.orange,
//                                                     spacing: 3.h),
//                                                 SizedBox(
//                                                   width: 5.h,
//                                                 ),
//                                                 Text(
//                                                   widget.table2.ratingid
//                                                           .toString() ??
//                                                       '0.0',
//                                                   style: TextStyle(
//                                                       fontSize: 22.h,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: Color(int.parse(
//                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                 ),
//                                                 Text('($ratingCount)',
//                                                     textAlign: TextAlign.end,
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: Colors.grey))
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 15.h,
//                                             ),
//                                             (widget.table2.status ==
//                                                         'completed' ||
//                                                     widget.table2.status ==
//                                                         'Completed')
//                                                 ? InkWell(
//                                                     onTap: () {
//                                                       Navigator.of(context).push(
//                                                           MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   ReviewScreen(
//                                                                       widget
//                                                                           .contentid,
//                                                                       true,
//                                                                       widget
//                                                                           .detailsBloc)));
//                                                     },
//                                                     child: Row(
//                                                       children: <Widget>[
//                                                         Text(
//                                                           isEditRating
//                                                               ? appBloc.localstr
//                                                                   .detailsButtonEdityourreviewbutton
//                                                               : appBloc.localstr
//                                                                   .detailsButtonWriteareviewbutton,
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: Color(
//                                                                   int.parse(
//                                                                       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 5.h,
//                                                         ),
//                                                         Icon(
//                                                           Icons.edit,
//                                                           size: 15.h,
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                         ),
//                                                       ],
//                                                     ))
//                                                 : Container(),
//                                             SizedBox(
//                                               height: 15.h,
//                                             ),
//
//                                             ListView.builder(
//                                                 shrinkWrap: true,
//                                                 physics: ScrollPhysics(),
//                                                 itemCount: reviewList.length,
//                                                 itemBuilder: (context, pos) {
//                                                   return Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             vertical: 8.h),
//                                                     child: Row(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: <Widget>[
//                                                         ClipOval(
//                                                           child: Image.network(
//                                                             ApiEndpoints
//                                                                     .strSiteUrl +
//                                                                 reviewList[pos]
//                                                                     .picture,
//                                                             width: 25.h,
//                                                             height: 25.h,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 10.h,
//                                                         ),
//                                                         Expanded(
//                                                           child: Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: <Widget>[
//                                                               Row(
//                                                                 children: <
//                                                                     Widget>[
//                                                                   Text(
//                                                                     reviewList[
//                                                                             pos]
//                                                                         .userName,
//                                                                     style: TextStyle(
//                                                                         color: Color(int.parse(
//                                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                                         fontWeight:
//                                                                             FontWeight.bold),
//                                                                     overflow:
//                                                                         TextOverflow
//                                                                             .ellipsis,
//                                                                     maxLines: 1,
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 2.h,
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 5.h,
//                                                                   ),
//                                                                   SmoothStarRating(
//                                                                       allowHalfRating:
//                                                                           false,
//                                                                       onRated:
//                                                                           (v) {},
//                                                                       starCount:
//                                                                           5,
//                                                                       rating: reviewList[
//                                                                               pos]
//                                                                           .ratingId
//                                                                           .toDouble(),
//                                                                       size:
//                                                                           15.h,
//                                                                       isReadOnly:
//                                                                           true,
//                                                                       // filledIconData: Icons.blur_off,
//                                                                       // halfFilledIconData: Icons.blur_on,
//                                                                       color: Colors
//                                                                           .orange,
//                                                                       borderColor:
//                                                                           Colors
//                                                                               .orange,
//                                                                       spacing:
//                                                                           0.0),
//                                                                 ],
//                                                               ),
//                                                               Row(
//                                                                 children: <
//                                                                     Widget>[
//                                                                   Expanded(
//                                                                     flex: 4,
//                                                                     child: Text(
//                                                                       reviewList[
//                                                                               pos]
//                                                                           .description,
//                                                                       style: TextStyle(
//                                                                           color:
//                                                                               Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                                     ),
//                                                                   ),
//                                                                   Expanded(
//                                                                       flex: 1,
//                                                                       child: (reviewList[pos].ratingUserId.toString() ==
//                                                                               strUserID)
//                                                                           ? IconButton(
//                                                                               onPressed: () {
//                                                                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewScreen(widget.contentid, true, widget.detailsBloc)));
//                                                                               },
//                                                                               iconSize: 20.h,
//                                                                               icon: Icon(
//                                                                                 Icons.edit,
//                                                                                 color: Colors.black,
//                                                                               ),
//                                                                             )
//                                                                           : Container()),
//                                                                 ],
//                                                               )
//                                                             ],
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   );
//                                                 }),
//                                             SizedBox(
//                                               height: 10.h,
//                                             ),
//                                             ratingCount > reviewList.length
//                                                 ? Center(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         skippedRows =
//                                                             reviewList.length;
//                                                         setState(() {
//                                                           detailsBloc.add(
//                                                               GetDetailsReviewEvent(
//                                                                   contentId: widget
//                                                                       .contentid,
//                                                                   skippedRows:
//                                                                       reviewList
//                                                                           .length));
//                                                         });
//                                                       },
//                                                       child: Text(
//                                                         appBloc.localstr
//                                                             .detailsButtonLoadmorebutton,
//                                                         style: TextStyle(
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 : Container(),
//                                             SizedBox(
//                                               height: 20.h,
//                                             ),
//                                             buildViewButton(data),
//                                             buildPlayButton(data),
//
//                                             SizedBox(
//                                               height: 10.h,
//                                             ),
// //                                    Container(
// //                                        width:
// //                                            MediaQuery.of(context).size.width,
// //                                        height: 50.h,
// //                                        child: OutlineButton(
// //                                          onPressed: () {},
// //                                          child: Text('Mark as complete'),
// //                                          borderSide: BorderSide(
// //                                              color: Color(int.parse(
// //                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
// //                                        )),
//                                           ],
//                                         )),
//                                     SizedBox(
//                                       height: 20.h,
//                                     ),
// //
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                     (state.status == Status.LOADING)
//                         ? Container(
//                             color: Color(int.parse(
//                                 "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                             child: Center(
//                               child: AbsorbPointer(
//                                 child: SpinKitCircle(
//                                   color: Color(
//                                     int.parse(
//                                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//                                   ),
//                                   size: 70.h,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container()
//                   ],
//                 );
//               }),
//         ),
//       ),
//     );
//   }
//
//   Widget _myList(String tabName) {
//     return Stack(
//       children: <Widget>[
//         SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: ScreenUtil().setHeight(10)),
//               ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: 5,
//                   itemBuilder: (context, i) => Container(
//                         child: getTabList(tabName, i),
//                       )),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget getTabList(String tabName, int position) {
//     if (tabName == "Sessions") {
//       return widgetSessionsListItems(position);
//     }
//     if (tabName == "Resource") {
//       return widgetResourceListItems(position);
//     } else {
//       return widgetGlosaryListItems(position);
//     }
//   }
//
//   Widget widgetGlosaryListItems(int position) {
//     return new ExpansionTile(
//       title: new Text(
//         "A",
//         style: new TextStyle(
//           fontSize: 17.h,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       children: <Widget>[
//         new Column(
//           children: _buildExpandableContent(),
//         ),
//       ],
// //
// //
//     );
//   }
//
//   _buildExpandableContent() {
//     List<Widget> columnContent = [];
//
//     for (int i = 0; i < 3; i++) {
//       columnContent.add(Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: new Align(
//           alignment: Alignment.topLeft,
//           child: Text("Content"),
//         ),
//       ));
//     }
//
//     return columnContent;
//   }
//
//   Widget widgetSessionsListItems(int position) {
//     //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
//     String imgUrl =
//         "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
//     String videoUrl1 =
//         "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//     String videoUrl =
//         "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
//     String pdfUrl =
//         "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
//     String htmlUrl = "https://www.google.com/";
//     //print("table2.siteurl + table2.thumbnailimagepath : ${table2.siteurl + table2.thumbnailimagepath}");
//
//     return Padding(
//       padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => MyLearningDetails()));
//         },
//         child: Card(
//           elevation: 4,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Stack(
//                 children: <Widget>[
//                   Container(
//                     height: ScreenUtil().setHeight(100),
//                     child: CachedNetworkImage(
//                       imageUrl: imgUrl,
//                       width: MediaQuery.of(context).size.width,
//                       //placeholder: (context, url) => CircularProgressIndicator(),
//                       placeholder: (context, url) => Container(
//                           color: Colors.grey.withOpacity(0.5),
//                           child: Center(
//                               heightFactor: ScreenUtil().setWidth(20),
//                               widthFactor: ScreenUtil().setWidth(20),
//                               child: CircularProgressIndicator(
//                                 valueColor: new AlwaysStoppedAnimation<Color>(
//                                     Colors.orange),
//                               ))),
//                       errorWidget: (context, url, error) => Icon(Icons.error),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   Positioned.fill(
//                     child: Align(
//                         alignment: Alignment.center,
//                         child: Container(
//                           child: Icon(
//                             Icons.picture_as_pdf,
//                             color: Colors.white,
//                             size: ScreenUtil().setHeight(30),
//                           ),
//                         )),
//                   ),
//                   Positioned(
//                       top: 15,
//                       left: 15,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.orange,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: EdgeInsets.only(
//                             top: ScreenUtil().setWidth(5),
//                             bottom: ScreenUtil().setWidth(5),
//                             left: ScreenUtil().setWidth(10),
//                             right: ScreenUtil().setWidth(10)),
//                         child: Text(
//                           "in Progress",
//                           style: TextStyle(
//                               fontSize: ScreenUtil().setSp(10),
//                               color: Colors.white),
//                         ),
//                       )),
//                 ],
//               ),
//               LinearProgressIndicator(
//                 value: 80,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//                 backgroundColor: Colors.grey,
//               ),
//               Container(
//                 padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Expanded(
//                           flex: 1,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 "ClassRoom",
//                                 style: TextStyle(
//                                     fontSize: ScreenUtil().setSp(14),
//                                     color: Colors.black),
//                               ),
//                               SizedBox(
//                                 height: ScreenUtil().setHeight(10),
//                               ),
//                               Text(
//                                 "Office ergonomics review and observation",
//                                 style: TextStyle(
//                                     fontSize: ScreenUtil().setSp(15),
//                                     color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {},
//                           child: Icon(
//                             Icons.more_vert,
//                             color: Colors.grey,
//                           ),
//                         ),
//
//                         /*PopupMenuButton<String>(
//                           // onSelected: handleClick,
//                           itemBuilder: (BuildContext context) {
//                             return {'Progress Report', 'Delete'}
//                                 .map((String choice) {
//                               return PopupMenuItem<String>(
//                                 value: choice,
//                                 child: GestureDetector(
//                                   onTap: (){
//
//                                   },
//                                     child: Text(choice)),
//                               );
//                             }).toList();
//                           },
//                         ),*/
//                       ],
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(10),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         new Container(
//                             width: ScreenUtil().setWidth(20),
//                             height: ScreenUtil().setWidth(20),
//                             decoration: new BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: new DecorationImage(
//                                     fit: BoxFit.fill,
//                                     image: new NetworkImage(imgUrl)))),
//                         SizedBox(
//                           width: ScreenUtil().setWidth(5),
//                         ),
//                         Text(
//                           "Henk Fortuin, Tony Finny",
//                           style: TextStyle(
//                               fontSize: ScreenUtil().setSp(13),
//                               color: Colors.black.withOpacity(0.5)),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(3),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         SmoothStarRating(
//                             allowHalfRating: false,
//                             onRated: (v) {},
//                             starCount: 5,
//                             rating: 3,
//                             size: ScreenUtil().setHeight(10),
//                             isReadOnly: true,
//                             // filledIconData: Icons.blur_off,
//                             // halfFilledIconData: Icons.blur_on,
//                             color: Colors.orange,
//                             borderColor: Colors.orange,
//                             spacing: 0.0),
//                         SizedBox(
//                           width: ScreenUtil().setWidth(10),
//                         ),
//                         Expanded(
//                           child: Text(
//                             "See Reviews".toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(12),
//                                 color: Colors.blue),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(10),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: Table(
//                         columnWidths: {
//                           0: FractionColumnWidth(.2),
//                           1: FractionColumnWidth(.5)
//                         },
//                         children: [
//                           TableRow(children: [
//                             Text(
//                               "Start Date",
//                               style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(12),
//                                   color: Colors.grey),
//                             ),
//                             Text(
//                               "03 NOV 2020 12:40 Am".toUpperCase(),
//                               style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(12),
//                                   color: Colors.black),
//                             ),
//                           ]),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: Table(
//                         columnWidths: {
//                           0: FractionColumnWidth(.2),
//                           1: FractionColumnWidth(.5)
//                         },
//                         children: [
//                           TableRow(children: [
//                             Text(
//                               "End Date",
//                               style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(12),
//                                   color: Colors.grey),
//                             ),
//                             Text(
//                               "10 NOV 2020 12:40 Am".toUpperCase(),
//                               style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(12),
//                                   color: Colors.black),
//                             ),
//                           ])
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: Table(
//                         columnWidths: {
//                           0: FractionColumnWidth(.2),
//                           1: FractionColumnWidth(.5)
//                         },
//                         children: [
//                           TableRow(children: [
//                             Text(
//                               "TimeZone",
//                               style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(12),
//                                   color: Colors.grey),
//                             ),
//                             Text(
//                               "Greenwich Mean Time",
//                               style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(12),
//                                   color: Colors.black),
//                             ),
//                           ])
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: Table(
//                         columnWidths: {
//                           0: FractionColumnWidth(.2),
//                           1: FractionColumnWidth(.5)
//                         },
//                         children: [
//                           TableRow(children: [
//                             Text(
//                               "Location".toUpperCase(),
//                               style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(12),
//                                   color: Colors.grey),
//                             ),
//                             Text(
//                               "Bangkok Thailand",
//                               style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(12),
//                                   color: Colors.black),
//                             ),
//                           ])
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget widgetResourceListItems(int position) {
//     //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
//     String imgUrl =
//         "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
//     String videoUrl1 =
//         "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//     String videoUrl =
//         "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
//     String pdfUrl =
//         "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
//     String htmlUrl = "https://www.google.com/";
//     //print("table2.siteurl + table2.thumbnailimagepath : ${table2.siteurl + table2.thumbnailimagepath}");
//
//     return Padding(
//       padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => MyLearningDetails()));
//         },
//         child: Card(
//           elevation: 4,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Stack(
//                 children: <Widget>[
//                   Container(
//                     height: ScreenUtil().setHeight(100),
//                     child: CachedNetworkImage(
//                       imageUrl: imgUrl,
//                       width: MediaQuery.of(context).size.width,
//                       //placeholder: (context, url) => CircularProgressIndicator(),
//                       placeholder: (context, url) => Container(
//                           color: Colors.grey.withOpacity(0.5),
//                           child: Center(
//                               heightFactor: ScreenUtil().setWidth(20),
//                               widthFactor: ScreenUtil().setWidth(20),
//                               child: CircularProgressIndicator(
//                                 valueColor: new AlwaysStoppedAnimation<Color>(
//                                     Colors.orange),
//                               ))),
//                       errorWidget: (context, url, error) => Icon(Icons.error),
//                       fit: BoxFit.fill,
//                     ),
//
//                     /*child: Image.network(
//                       "https://qa.instancy.com"+table2.thumbnailimagepath,
//                       width: MediaQuery.of(context).size.width,
//                       fit: BoxFit.fill,
//                     ),*/
//
//                     /*decoration: new BoxDecoration(
//
//                         image: new DecorationImage(
//                           fit: BoxFit.fill,
//                           colorFilter: ColorFilter.mode(
//                               Colors.black.withOpacity(0.4), BlendMode.darken),
//                           image: AssetImage(
//                             "https://qa.instancy.com"+table2.thumbnailimagepath,
//                           ),
//                         )
//                     ),*/
//                   ),
//                   Positioned.fill(
//                     child: Align(
//                         alignment: Alignment.center,
//                         child: Container(
//                           child: Icon(
//                             Icons.picture_as_pdf,
//                             color: Colors.white,
//                             size: ScreenUtil().setHeight(30),
//                           ),
//                         )),
//                   ),
//                   Positioned(
//                       top: 15,
//                       left: 15,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.orange,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: EdgeInsets.only(
//                             top: ScreenUtil().setWidth(5),
//                             bottom: ScreenUtil().setWidth(5),
//                             left: ScreenUtil().setWidth(10),
//                             right: ScreenUtil().setWidth(10)),
//                         child: Text(
//                           "in Progress",
//                           style: TextStyle(
//                               fontSize: ScreenUtil().setSp(10),
//                               color: Colors.white),
//                         ),
//                       )),
//                 ],
//               ),
//               LinearProgressIndicator(
//                 value: 80,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//                 backgroundColor: Colors.grey,
//               ),
//               Container(
//                 padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Expanded(
//                           flex: 1,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 "ClassRoom",
//                                 style: TextStyle(
//                                     fontSize: ScreenUtil().setSp(14),
//                                     color: Colors.black),
//                               ),
//                               SizedBox(
//                                 height: ScreenUtil().setHeight(10),
//                               ),
//                               Text(
//                                 "Office ergonomics review and observation",
//                                 style: TextStyle(
//                                     fontSize: ScreenUtil().setSp(15),
//                                     color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {},
//                           child: Icon(
//                             Icons.more_vert,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(10),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         new Container(
//                             width: ScreenUtil().setWidth(20),
//                             height: ScreenUtil().setWidth(20),
//                             decoration: new BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: new DecorationImage(
//                                     fit: BoxFit.fill,
//                                     image: new NetworkImage(imgUrl)))),
//                         SizedBox(
//                           width: ScreenUtil().setWidth(5),
//                         ),
//                         Text(
//                           "Henk Fortuin, Tony Finny",
//                           style: TextStyle(
//                               fontSize: ScreenUtil().setSp(13),
//                               color: Colors.black.withOpacity(0.5)),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(3),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         SmoothStarRating(
//                             allowHalfRating: false,
//                             onRated: (v) {},
//                             starCount: 5,
//                             rating: 3,
//                             size: ScreenUtil().setHeight(10),
//                             isReadOnly: true,
//                             // filledIconData: Icons.blur_off,
//                             // halfFilledIconData: Icons.blur_on,
//                             color: Colors.orange,
//                             borderColor: Colors.orange,
//                             spacing: 0.0),
//                         SizedBox(
//                           width: ScreenUtil().setWidth(10),
//                         ),
//                         Expanded(
//                           child: Text(
//                             "See Reviews".toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(12),
//                                 color: Colors.blue),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(10),
//                     ),
//                     Text(
//                       "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                       style: TextStyle(
//                           fontSize: ScreenUtil().setSp(14),
//                           color: Colors.black.withOpacity(0.5)),
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(10),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                             child: FlatButton.icon(
//                           color: Color(int.parse(
//                               "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                           icon: Icon(
//                             Icons.cloud_download,
//                             color: Colors.white,
//                             size: 25,
//                           ),
//                           label: Text(
//                             "Download".toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(14),
//                                 color: Colors.white),
//                           ),
//                           onPressed: () {},
//                         )),
//                         SizedBox(
//                           width: ScreenUtil().setWidth(10),
//                         ),
//                         Expanded(
//                             child: FlatButton.icon(
//                           color: Color(int.parse(
//                               "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                           icon: Icon(
//                             Icons.remove_red_eye,
//                             color: Colors.white,
//                             size: 25,
//                           ),
//                           label: Text(
//                             "View".toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(14),
//                                 color: Colors.white),
//                           ),
//                           onPressed: () {},
//                         ))
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// //  menu.getItem(4).setTitle(getLocalizationValue(JsonLocalekeys.mylearning_actionbutton_rescheduleactionbutton));
//
//   _settingMyEventBottomSheet(context) {
//     showModalBottomSheet(
//         backgroundColor: Color(int.parse(
//             "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//             child: SingleChildScrollView(
//               child: new Column(
//                 children: <Widget>[
//                   displayPlay(widget.table2),
//                   displayView(widget.table2),
//                   displayReport(),
//                   displayaddToCalendar(),
//                   displaySetComplete(),
//                   displayRelatedContent(),
//                   displayReschedule(),
//                   displayCertificate(),
//                   displayQRCode(),
//                   displayEventRecording(),
//                   displayDelete(widget.table2),
//                   displayArchive(widget.table2),
//                   displayUnArachive(widget.table2),
//                   //displayRemove(table2),
//                   //displayEventRecording(table2),
//                   displayShare(widget.table2),
//                   displayShareConnection(widget.table2)
// //                  displayCancelEnrollemnt()
//                 ],
//               ),
//             ),
//           );
//         });
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
//   Widget displayPlay(DummyMyCatelogResponseTable2 table2) {
//     if (table2.objecttypeid == 11 ||
//         table2.objecttypeid == 14 ||
//         table2.objecttypeid == 36 ||
//         table2.objecttypeid == 28 ||
//         table2.objecttypeid == 20 ||
//         table2.objecttypeid == 21 ||
//         table2.objecttypeid == 52) {
//       if (table2.objecttypeid == 11 &&
//           (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
//         return new ListTile(
//             leading: Icon(
//               IconDataSolid(int.parse('0xf144')),
//               color: Colors.grey,
//             ),
//             title: new Text(
//               appBloc.localstr.mylearningActionsheetPlayoption,
//               style: TextStyle(
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//             ),
//             onTap: () {
// //              Navigator.of(context).pop();
//
//               if (isValidString(table2.viewprerequisitecontentstatus)) {
// //                print('ifdataaaaa');
//                 String alertMessage =
//                     appBloc.localstr.prerequistesalerttitle6Alerttitle6;
//                 alertMessage = alertMessage +
//                     "  \"" +
//                     appBloc.localstr.prerequisLabelContenttypelabel +
//                     "\" " +
//                     appBloc.localstr.prerequistesalerttitle5Alerttitle7;
//
//                 showDialog(
//                     context: context,
//                     builder: (BuildContext context) => new AlertDialog(
//                           title: Text(
//                             appBloc.localstr.detailsAlerttitleStringalert,
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           content: Text(alertMessage),
//                           backgroundColor: Color(int.parse(
//                               "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(5)),
//                           actions: <Widget>[
//                             new FlatButton(
//                               child: Text(
//                                   appBloc.localstr.eventsAlertbuttonOkbutton),
//                               textColor: Colors.blue,
//                               onPressed: () async {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         ));
//               } else {
//                 if (table2.objecttypeid == 102) {
//                   executeXAPICourse(table2);
//                 }
//
//                 launchCourse(table2, context);
//               }
//             });
//       }
//     }
//
//     return Container();
//   }
//
//   Future<void> launchCourse(
//       DummyMyCatelogResponseTable2 table2, BuildContext context) async {
//     /// Need Some value
//     if (table2.objecttypeid == 102) {
//       executeXAPICourse(table2);
//     }
//
//     courseLaunch = GotoCourseLaunch(
//         context, table2, false, appBloc.uiSettingModel, widget.mylearninglist);
//     String url = await courseLaunch.getCourseUrl();
//     if (url.isNotEmpty) {
//       //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(url,table2)));
//       await Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => InAppWebCourseLaunch(url, table2)));
//     }
//
//     if (table2.objecttypeid == 8 ||
//         table2.objecttypeid == 9 ||
//         table2.objecttypeid == 10 ||
//         table2.objecttypeid == 28 ||
//         table2.objecttypeid == 102 ||
//         table2.objecttypeid == 26) {
//       String paramsString = "";
//       if (table2.objecttypeid == 10 && table2.bit5) {
//         paramsString = "userID=" +
//             table2.userid.toString() +
//             "&scoid=" +
//             table2.scoid.toString() +
//             "&TrackObjectTypeID=" +
//             table2.objecttypeid.toString() +
//             "&TrackContentID=" +
//             table2.contentid +
//             "&TrackScoID=" +
//             table2.scoid.toString() +
//             "&SiteID=" +
//             table2.siteid.toString() +
//             "&OrgUnitID=" +
//             table2.siteid.toString() +
//             "&isonexist=onexit";
//       } else {
//         paramsString = "userID=" +
//             table2.userid.toString() +
//             "&scoid=" +
//             table2.scoid.toString();
//       }
//
//       String webApiUrl = await sharePref_getString(sharedPref_webApiUrl);
//
//       String url =
//           webApiUrl + "/MobileLMS/MobileGetContentStatus?" + paramsString;
//
//       print('launchCourseUrl $url');
//
//       detailsBloc.add(GetContentStatus(url: url));
//
//       /*
//                       {
//                         "contentstatus": [
//                   {
//                   "ContentStatus": "In Progress",
//                   "status": "In Progress",
//                   "Name": "incomplete                                        ",
//                   "progress": null
//                   }
//                   ]
//                 }
//               */
//     }
//   }
//
//   Widget displayView(DummyMyCatelogResponseTable2 table2) {
//     if (table2.objecttypeid == 11 ||
//         table2.objecttypeid == 14 ||
//         table2.objecttypeid == 36 ||
//         table2.objecttypeid == 28 ||
//         table2.objecttypeid == 20 ||
//         table2.objecttypeid == 21 ||
//         table2.objecttypeid == 52) {
//       if (table2.objecttypeid == 11 &&
//           (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
//         return Container();
//       } else {
//         return new ListTile(
//           leading: Icon(
//             IconDataSolid(int.parse('0xf06e')),
//             color: Colors.grey,
//           ),
//           title: new Text(appBloc.localstr.mylearningActionsheetViewoption,
//               style: TextStyle(
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//           onTap: () {
// //            Navigator.of(context).pop();
//
//             if (isValidString(table2.viewprerequisitecontentstatus)) {
// //              print('ifdataaaaa');
//               String alertMessage =
//                   appBloc.localstr.prerequistesalerttitle6Alerttitle6;
//               alertMessage = alertMessage +
//                   "  \"" +
//                   appBloc.localstr.prerequisLabelContenttypelabel +
//                   "\" " +
//                   appBloc.localstr.prerequistesalerttitle5Alerttitle7;
//
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) => new AlertDialog(
//                         title: Text(
//                           appBloc.localstr.detailsAlerttitleStringalert,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         content: Text(alertMessage),
//                         backgroundColor: Color(int.parse(
//                             "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: new BorderRadius.circular(5)),
//                         actions: <Widget>[
//                           new FlatButton(
//                             child: Text(
//                                 appBloc.localstr.eventsAlertbuttonOkbutton),
//                             textColor: Colors.blue,
//                             onPressed: () async {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       ));
//             } else {
// //              print('elsedataaaa');
//
//               if (table2.objecttypeid == 102) {
//                 executeXAPICourse(table2);
//               }
//
//               launchCourse(table2, context);
//             }
//           },
//         );
//       }
//     } else if (table2.objecttypeid == 688 || table2.objecttypeid == 70) {
//       return Container();
//     } else {
//       return new ListTile(
//         leading: Icon(
//           IconDataSolid(int.parse('0xf06e')),
//           color: Colors.grey,
//         ),
//         title: new Text(appBloc.localstr.mylearningActionsheetViewoption,
//             style: TextStyle(
//                 color: Color(int.parse(
//                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//         onTap: () {
//           Navigator.of(context).pop();
//
//           if (isValidString(table2.viewprerequisitecontentstatus)) {
// //            print('ifdataaaaa');
//             String alertMessage =
//                 appBloc.localstr.prerequistesalerttitle6Alerttitle6;
//             alertMessage = alertMessage +
//                 "  \"" +
//                 appBloc.localstr.prerequisLabelContenttypelabel +
//                 "\" " +
//                 appBloc.localstr.prerequistesalerttitle5Alerttitle7;
//
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) => new AlertDialog(
//                       title: Text(
//                         appBloc.localstr.detailsAlerttitleStringalert,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       content: Text(alertMessage),
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(5)),
//                       actions: <Widget>[
//                         new FlatButton(
//                           child:
//                               Text(appBloc.localstr.eventsAlertbuttonOkbutton),
//                           textColor: Colors.blue,
//                           onPressed: () async {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                     ));
//           } else {
// //            print('elsedataaaa');
//
//             if (table2.objecttypeid == 102) {
//               executeXAPICourse(table2);
//             }
//
//             launchCourse(table2, context);
//           }
//         },
//       );
//     }
// //    return Container();
//   }
//
//   Widget displayReport() {
//     if (widget.table2.objecttypeid == 11 ||
//         widget.table2.objecttypeid == 14 ||
//         widget.table2.objecttypeid == 36 ||
//         widget.table2.objecttypeid == 28 ||
//         widget.table2.objecttypeid == 20 ||
//         widget.table2.objecttypeid == 21 ||
//         widget.table2.objecttypeid == 52) {
//       return Container();
//     } else if (widget.table2.objecttypeid == 70) {
//       return Container();
//     } else if (widget.table2.objecttypeid == 688) {
//       return Container();
//     } else {
//       if (widget.table2.objecttypeid == 27) {
//         return Container();
//       } else {
//         if (!isReportEnabled) {
//           return Container();
//         }
//
//         return new ListTile(
//             leading: SvgPicture.asset(
//               'assets/Report.svg',
//               width: 25.h,
//               height: 25.h,
//               color: Colors.grey,
//             ),
//             title: new Text(appBloc.localstr.mylearningActionsheetReportoption,
//                 style: TextStyle(
//                     color: Color(int.parse(
//                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) =>
//                       ProgressReport(widget.table2, detailsBloc, "", "-1")));
//             });
//       }
//     }
//
//     return Container();
//   }
//
//   bool displayDownload(DummyMyCatelogResponseTable2 table2) {
//     print('obttypeid ${table2.objecttypeid}  ${table2.isdownloaded}');
//     downloadPath(table2.contentid, table2);
//
//     if ((table2.objecttypeid == 10 && table2.bit5) ||
//         table2.objecttypeid == 28 ||
//         table2.objecttypeid == 20 ||
//         table2.objecttypeid == 688 ||
//         table2.objecttypeid == 693 ||
//         table2.objecttypeid == 36 ||
//         table2.objecttypeid == 102 ||
//         table2.objecttypeid == 27 ||
//         table2.objecttypeid == 70) {
//       print('download if');
//       download = false;
//       return download;
//     } else if (table2.isdownloaded && table2.objecttypeid != 70) {
//       print('download else if');
//       download = false;
//       return download;
//     } else {
//       download = true;
//       return download;
//     }
//   }
//
//   bool isValidString(String val) {
//     print('validstrinh $val');
//     if (val == null || val.isEmpty || val == 'null') {
//       return false;
//     } else {
//       return true;
//     }
//   }
//
//   Widget displayaddToCalendar() {
//     if (!isFromCatalog) {
//       if (isValidString(widget.table2.eventenddatetime) &&
//           !returnEventCompleted(widget.table2.eventenddatetime)) {
//         return new ListTile(
//           leading: Icon(
//             IconDataSolid(int.parse('0xf271')),
//             color: Colors.grey,
//           ),
//           title: new Text(
//               appBloc.localstr.mylearningActionsheetAddtocalendaroption,
//               style: TextStyle(
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//           onTap: () {
//             DateTime startDate = new DateFormat("yyyy-MM-ddTHH:mm:ss")
//                 .parse(widget.table2.eventstartdatetime);
//             DateTime endDate = new DateFormat("yyyy-MM-ddTHH:mm:ss")
//                 .parse(widget.table2.eventenddatetime);
//
// //            print(
// //                'event start-end time ${table2.eventstartdatetime}  ${table2.eventenddatetime}');
//             Event event = Event(
//               title: widget.table2.name,
//               description: widget.table2.shortdescription,
//               location: widget.table2.locationname,
//               startDate: startDate,
//               endDate: endDate,
//               allDay: false,
//             );
//
//             Add2Calendar.addEvent2Cal(event).then((success) {
//               flutterToast.showToast(
//                 child: CommonToast(
//                     displaymsg: success
//                         ? 'Event added successfully'
//                         : 'Error occured while adding event'),
//                 gravity: ToastGravity.BOTTOM,
//                 toastDuration: Duration(seconds: 2),
//               );
//             });
//           },
//         );
//       }
//
//       if (widget.table2.eventscheduletype == 1 &&
//           appBloc.uiSettingModel.EnableMultipleInstancesforEvent == 'true') {
//         return Container();
//       }
//     }
//
//     return Container();
//   }
//
//   bool returnEventCompleted(String eventDate) {
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
// //    print('fiffenrecedays $difference');
//     if (difference != null && difference < 0) {
//       isCompleted = false;
//     } else {
//       isCompleted = true;
//     }
//
//     return isCompleted;
//   }
//
//   Widget displaySetComplete() {
//     if (isValidString(widget.table2.objecttypeid.toString()) &&
//         (widget.table2.objecttypeid == 11 ||
//             widget.table2.objecttypeid == 14 ||
//             widget.table2.objecttypeid == 36 ||
//             widget.table2.objecttypeid == 28 ||
//             widget.table2.objecttypeid == 20 ||
//             widget.table2.objecttypeid == 21 ||
//             widget.table2.objecttypeid == 52)) {
//       if (isValidString(widget.table2.actualstatus) &&
//           ((widget.table2.actualstatus != 'completed'))) {
//         return ListTile(
//             leading: SvgPicture.asset(
//               'assets/SetComplete.svg',
//               width: 25.h,
//               height: 25.h,
//               color: Colors.grey,
//             ),
//             title: new Text(
//                 appBloc.localstr.mylearningActionsheetSetcompleteoption,
//                 style: TextStyle(
//                     color: Color(int.parse(
//                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//             onTap: () {
//               Navigator.pop(context);
//               detailsBloc.add(SetCompleteEvent(
//                   contentId: widget.table2.contentid,
//                   scoId: widget.table2.scoid.toString()));
//             });
//       } else {
//         return Container();
//       }
//     } else {
//       return Container();
//     }
//   }
//
//   Widget displayRelatedContent() {
//     return Container();
//
// //    new ListTile(
// ////                  leading: new Icon(Icons.share),
// //      title: new Text(appBloc
// //          .localstr.mylearningActionsheetRelatedcontentoption),
// //      onTap: () => {
// //        Share.share(
// //          'text',
// //          subject: 'subject',
// //        )
// //      },
// //    ),
//   }
//
//   Widget displayReschedule() {
//     if (isValidString(widget.table2.reschduleparentid)) {
//       return new ListTile(
//         leading: Icon(
//           IconDataSolid(int.parse('0xf783')),
//           color: Colors.grey,
//         ),
//         title: new Text(
//             appBloc.localstr.mylearningActionbuttonRescheduleactionbutton,
//             style: TextStyle(
//                 color: Color(int.parse(
//                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//         onTap: () => {},
//       );
//     } else {
//       return Container();
//     }
//   }
//
//   Widget displayCertificate() {
//     if (isValidString(widget.table2.certificateaction)) {
//       return new ListTile(
//           leading: SvgPicture.asset(
//             'assets/Certificate.svg',
//             width: 25.h,
//             height: 25.h,
//             color: Colors.grey,
//           ),
//           title: new Text(
//               appBloc.localstr.mylearningActionsheetViewcertificateoption,
//               style: TextStyle(
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//           onTap: () {
//             if (widget.table2.certificateaction == 'notearned') {
//               Navigator.of(context).pop();
//
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) => new AlertDialog(
//                         title: Text(
//                           appBloc.localstr
//                               .mylearningActionsheetViewcertificateoption,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Color(int.parse(
//                                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                         ),
//                         content: Text(
//                           appBloc.localstr
//                               .mylearningAlertsubtitleForviewcertificate,
//                           style: TextStyle(
//                               color: Color(int.parse(
//                                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                         ),
//                         backgroundColor: Color(int.parse(
//                             "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: new BorderRadius.circular(5)),
//                         actions: <Widget>[
//                           new FlatButton(
//                             child: Text(appBloc.localstr
//                                 .mylearningClosebuttonactionClosebuttonalerttitle),
//                             textColor: Colors.blue,
//                             onPressed: () async {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       ));
//             } else {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) =>
//                       ViewCertificate(detailsBloc: detailsBloc)));
//             }
//           });
//     } else {
//       return Container();
//     }
//   }
//
//   Widget displayQRCode() {
//     if (widget.table2.objecttypeid == "70") {
//       if (isValidString(widget.table2.qrimagename) &&
//           isValidString(widget.table2.qrcodeimagepath) &&
//           !widget.table2.bit4) {
//         return new ListTile(
//           leading: Icon(
//             IconDataSolid(int.parse('0xf029')),
//             color: Colors.grey,
//           ),
//           title: new Text(appBloc.localstr.mylearningActionsheetViewqrcode,
//               style: TextStyle(
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//           onTap: () => {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => QrCodeScreen(
//                     ApiEndpoints.strSiteUrl + widget.table2.qrcodeimagepath)))
//           },
//         );
//       }
//     }
//
//     return Container();
//   }
//
//   Widget displayEventRecording() {
//     if (widget.table2.eventrecording != null && widget.table2.eventrecording) {
//       if (widget.table2.isaddedtomylearning == 1 ||
//           (typeFrom == 'event' || typeFrom == 'track')) {
//         return ListTile(
//           leading: Icon(
//             IconDataSolid(int.parse('0xf8d9')),
//             color: Colors.grey,
//           ),
//           title:
//               new Text(appBloc.localstr.learningtrackLabelEventviewrecording),
//           onTap: () => {},
//         );
//       } else {
//         return Container();
//       }
//     } else {
//       return Container();
//     }
//   }
//
//   Widget displayDelete(DummyMyCatelogResponseTable2 table2) {
//     downloadPath(table2.contentid, table2);
//
//     if (table2.isdownloaded && table2.objecttypeid != 70) {
//       return ListTile(
//           leading: Icon(
//             IconDataSolid(int.parse('0xf1f8')),
//             color: Colors.grey,
//           ),
//           title: new Text(appBloc.localstr.mylearningActionsheetDeleteoption,
//               style: TextStyle(
//                   color: Color(
//                 int.parse(
//                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//               ))),
//
//           /// TODO : Sagar sir - delete offline file
//           onTap: () async {
//             Navigator.pop(context);
//
//             bool fileDel = await deleteFile(downloadDestFolderPath);
//
//             print('filedeleted ${downloadDestFolderPath} ${table2.contentid}');
//             if (fileDel) {
//               setState(() {
//                 //isDownloaded = false;
//                 //isDownloading = false;
//                 downloadedProgess = 0;
//                 table2.isdownloaded = false;
//                 table2.isDownloading = false;
//               });
//             }
//           });
//     }
//
//     return Container();
//   }
//
//   Future<bool> deleteFile(String downloadDestFolderPath) async {
//     try {
//       final savedDir = Directory(downloadDestFolderPath);
//       if (await savedDir.exists()) {
//         await savedDir.delete(recursive: true);
//         print('dir existes');
//         return true;
//       } else {
//         print('dir does not existes');
//         return false;
//       }
//     } catch (e) {
//       return true;
//     }
//   }
//
//   Widget displayArchive(DummyMyCatelogResponseTable2 table2) {
//     if (detailsBloc.myLearningDetailsModel.isArchived != null &&
//         !detailsBloc.myLearningDetailsModel.isArchived) {
//       return ListTile(
//           leading: Icon(
//             IconDataSolid(int.parse('0xf187')),
//             color: Colors.grey,
//           ),
//           title: new Text(appBloc.localstr.mylearningActionsheetArchiveoption,
//               style: TextStyle(
//                   color: Color(
//                 int.parse(
//                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//               ))),
//           onTap: () {
//             myLearningBloc.add(AddtoArchiveCall(
//                 isArchive: true, strContentID: table2.contentid));
//             Navigator.pop(context);
//           });
//     } else {
//       return Container();
//     }
//   }
//
//   Widget displayUnArachive(DummyMyCatelogResponseTable2 table2) {
//     if (detailsBloc.myLearningDetailsModel.isArchived != null &&
//         detailsBloc.myLearningDetailsModel.isArchived) {
//       return ListTile(
//           leading: Icon(
//             IconDataSolid(int.parse('0xf187')),
//             color: Colors.grey,
//           ),
//           title: new Text(appBloc.localstr.mylearningActionsheetUnarchiveoption,
//               style: TextStyle(
//                   color: Color(
//                 int.parse(
//                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//               ))),
//           onTap: () {
//             myLearningBloc.add(RemovetoArchiveCall(
//                 isArchive: false, strContentID: table2.contentid));
//             Navigator.pop(context);
//           });
//     } else {
//       return Container();
//     }
//   }
//
//   Widget displayCancelEnrollemnt() {
//     if (!isFromCatalog) {
//       if (isValidString(widget.table2.eventstartdatetime) &&
//           !returnEventCompleted(widget.table2.eventstartdatetime)) {
// //        if (widget.table2.iscancelEventEnabled) {
// //          new ListTile(
// //            leading: new Icon(Icons.delete),
// //            title: new Text(
// //                appBloc.localstr.mylearningActionsheetCancelenrollmentoption),
// //            onTap: () => {},
// //          );
// //        }
//
//         if (widget.table2.eventscheduletype == 1 &&
//             appBloc.uiSettingModel.EnableMultipleInstancesforEvent == 'true') {
//           return Container();
//         }
//       }
//     }
//
//     return Container();
//   }
//
//   Widget displayShare(DummyMyCatelogResponseTable2 table2) {
//     if (table2.suggesttoconnlink != null ||
//         table2.suggesttoconnlink.isNotEmpty) {
//       return new ListTile(
//         leading: Icon(
//           IconDataSolid(int.parse('0xf1e0')),
//           color: Colors.grey,
//         ),
//         title: new Text('Share with Connection',
//             style: TextStyle(
//                 color: Color(
//               int.parse(
//                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//             ))),
//         onTap: () {
//           Navigator.pop(context);
//
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => ShareWithConnections(
//                   false, false, table2.name, table2.contentid)));
//         },
//       );
//     }
//
//     return Container();
//   }
//
//   Widget displayShareConnection(DummyMyCatelogResponseTable2 table2) {
//     if (table2.suggestwithfriendlink != null ||
//         table2.suggestwithfriendlink.isNotEmpty) {
//       return new ListTile(
//         leading: Icon(
//           IconDataSolid(
//             int.parse('0xf079'),
//           ),
//           color: Colors.grey,
//         ),
//         title: new Text("Share with People",
//             style: TextStyle(
//                 color: Color(
//               int.parse(
//                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//             ))),
//         onTap: () {
//           Navigator.pop(context);
//
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => ShareMainScreen(
//                   true, false, false, table2.contentid, table2.name)));
//         },
//       );
//     }
//
//     return Container();
//   }
//
//   void getUserId() async {
//     strUserID = await sharePref_getString(sharedPref_userid);
//   }
//
//   Widget buildViewButton(MyLearningDetailsResponse data) {
//     if (!isFromCatalog) {
//       if (widget.table2.objecttypeid == 11 ||
//           widget.table2.objecttypeid == 14 ||
//           widget.table2.objecttypeid == 36 ||
//           widget.table2.objecttypeid == 28 ||
//           widget.table2.objecttypeid == 20 ||
//           widget.table2.objecttypeid == 21 ||
//           widget.table2.objecttypeid == 52) {
//         if (widget.table2.objecttypeid == 11 &&
//             (widget.table2.mediatypeid == 3 ||
//                 widget.table2.mediatypeid == 4)) {
//           return Container();
//         } else {
//           return displayButton(
//               appBloc.localstr.mylearningActionsheetViewoption);
//         }
//       } else if (widget.table2.objecttypeid == 688 ||
//           widget.table2.objecttypeid == 70) {
//         return Container();
//       } else {
//         return displayButton(appBloc.localstr.mylearningActionsheetViewoption);
//       }
//     }
//   }
//
//   Widget buildPlayButton(MyLearningDetailsResponse data) {
//     if (widget.table2.objecttypeid == 11 ||
//         widget.table2.objecttypeid == 14 ||
//         widget.table2.objecttypeid == 36 ||
//         widget.table2.objecttypeid == 28 ||
//         widget.table2.objecttypeid == 20 ||
//         widget.table2.objecttypeid == 21 ||
//         widget.table2.objecttypeid == 52) {
//       if (widget.table2.objecttypeid == 11 &&
//           (widget.table2.mediatypeid == 3 || widget.table2.mediatypeid == 4)) {
//         return displayButton(appBloc.localstr.mylearningActionsheetPlayoption);
//       }
//     }
//
//     return Container();
//   }
//
//   Widget displayButton(String label) {
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         height: 50.h,
//         child: FlatButton(
//             onPressed: () {
// //              Navigator.of(context).pop();
//
//               if (isValidString(widget.table2.viewprerequisitecontentstatus)) {
// //              print('ifdataaaaa');
//                 String alertMessage =
//                     appBloc.localstr.prerequistesalerttitle6Alerttitle6;
//                 alertMessage = alertMessage +
//                     "  \"" +
//                     appBloc.localstr.prerequisLabelContenttypelabel +
//                     "\" " +
//                     appBloc.localstr.prerequistesalerttitle5Alerttitle7;
//
//                 showDialog(
//                     context: context,
//                     builder: (BuildContext context) => new AlertDialog(
//                           title: Text(
//                             appBloc.localstr.detailsAlerttitleStringalert,
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           content: Text(
//                             alertMessage,
//                             style: TextStyle(
//                                 color: Color(int.parse(
//                                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                           ),
//                           backgroundColor: Color(int.parse(
//                               "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(5)),
//                           actions: <Widget>[
//                             new FlatButton(
//                               child: Text(
//                                   appBloc.localstr.eventsAlertbuttonOkbutton),
//                               textColor: Colors.blue,
//                               onPressed: () async {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         ));
//               } else {
// //              print('elsedataaaa');
//
//                 if (widget.table2.objecttypeid == 102) {
//                   executeXAPICourse(widget.table2);
//                 }
//
//                 launchCourse(widget.table2, context);
//               }
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Icon(
//                   (label == appBloc.localstr.mylearningActionsheetViewoption)
//                       ? IconDataSolid(int.parse('0xf06e'))
//                       : IconDataSolid(int.parse('0xf144')),
//                   color: Color(int.parse(
//                       "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
//                   size: 25.h,
//                 ),
//                 SizedBox(
//                   width: 5.h,
//                 ),
//                 Text(
//                   label,
//                   style: TextStyle(
//                       color: Color(int.parse(
//                           "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
//                 ),
//               ],
//             ),
//             color: Color(int.parse(
//                 "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))));
//   }
//
//   Future<void> executeXAPICourse(
//       DummyMyCatelogResponseTable2 learningModel) async {
//     /*String paramsString = "strContentID=" + learningModel.contentid +
//         "&UserID=" + appUserModel.getUserIDValue()
//         + "&SiteID="
//         + appUserModel.getSiteIDValue()
//         + "&SCOID=" + learningModel.scoid.toString() + "&CanTrack=true";*/
//   }
//
//   Widget downloadIcon(DummyMyCatelogResponseTable2 table2) {
//     return Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         width: 40.h,
//         height: 40.h,
//         child: InkWell(
//             onTap: () async {
//               if (!widget.table2.isdownloaded) {
//                 PermissionStatus permission = await Permission.storage.status;
//
//                 if (permission != PermissionStatus.granted) {
//                   await Permission.storage.request();
//                   PermissionStatus permission = await Permission.storage.status;
//                   if (permission == PermissionStatus.granted) {
//                     /// Permission Granted
//
//                     downloadCourse = DownloadCourse(
//                         context,
//                         widget.table2,
//                         false,
//                         appBloc.uiSettingModel,
//                         widget.pos,
//                         streamController,
//                         doSomething);
//
//                     downloadCourse.downloadTheCourse();
//                   } else {
//                     /// Notify User
//                   }
//                 } else {
//                   downloadCourse = DownloadCourse(
//                       context,
//                       widget.table2,
//                       false,
//                       appBloc.uiSettingModel,
//                       widget.pos,
//                       streamController,
//                       doSomething);
//
//                   downloadCourse.downloadTheCourse();
//                 }
//               }
//             },
//             child: (widget.table2.isDownloading != null &&
//                     widget.table2.isDownloading)
//                 ? Center(
//                     child: Text(
//                     '$downloadedProgess %',
//                     style: TextStyle(
//                         color: Color(
//                       int.parse(
//                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//                     )),
//                   ))
//                 : Icon(
//                     Icons.file_download,
//                     color: (widget.table2.isdownloaded != null &&
//                             widget.table2.isdownloaded)
//                         ? Color(int.parse(
//                             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
//                         : Colors.black,
//                   )));
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
// }
