// import 'dart:convert';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:html/parser.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
// import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
// import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning_details_response.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
// import 'package:flutter_admin_web/framework/common/api_response.dart';
// import 'package:flutter_admin_web/framework/common/constants.dart';
// import 'package:flutter_admin_web/framework/common/enums.dart';
// import 'package:flutter_admin_web/framework/common/pref_manger.dart';
// import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
// import 'package:flutter_admin_web/framework/helpers/utils.dart';
// import 'package:flutter_admin_web/framework/repository/Catalog/model/subsitelogin_response.dart';
// import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
// import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
// import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
// import 'package:flutter_admin_web/ui/Catalog/gotoCoursePreview.dart';
// import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
// import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
// import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
// import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
// import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
// import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
// import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
// import 'package:flutter_admin_web/ui/common/common_toast.dart';
// import 'package:intl/intl.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
//
// import 'buyview.dart';
//
// class CatalogDetailScreen extends StatefulWidget {
//   final String contentid;
//   final int objtypeId;
//   final DummyMyCatelogResponseTable2 table2;
//   final MyLearningDetailsBloc detailsBloc;
//   NativeMenuModel nativeModel;
//
//   CatalogDetailScreen(
//       {this.contentid,
//       this.objtypeId,
//       this.table2,
//       this.detailsBloc,
//       this.nativeModel});
//
//   @override
//   _CatalogDetailScreenState createState() => _CatalogDetailScreenState();
// }
//
// class _CatalogDetailScreenState extends State<CatalogDetailScreen> {
//   AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
//
//   CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);
//
//   MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);
//
//   MyLearningDetailsBloc detailsBloc;
//   var strUserID = '';
//
//   String eventstartDate = '';
//   String eventendDate = '';
//   String contentID = '';
//
//   List<EditRating> reviewList = [];
//
//   int ratingCount = 0;
//   bool isEditRating = false;
//
//   MyLearningDetailsResponse data;
//
//   String imgUrl =
//       "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
//
//   bool menu0 = false,
//       menu1 = false,
//       menu2 = false,
//       isAddtomylearning = false,
//       loaderAddtomylearning = false,
//       loaderEnroll = false;
//
//   Fluttertoast flutterToast;
//
//   GotoCourseLaunch courseLaunch;
//   GotoCourseLaunchCatalog courseLaunchCatalog;
//
//   GeneralRepository generalRepository;
//   ScrollController scrollController;
//
//   InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
//
//   int bottomButton1Tag = 0;
//   int bottomButton2Tag = 0;
//   String bottomButton1Text = '';
//   String bottomButton2Text = '';
//   IconData icon1;
//   IconData icon2;
//   bool enablePlay = false;
//
//   bool isFromCatalog = true;
//
//   bool isReportEnabled = true;
//
//   void _buyProduct(ProductDetails prod) {
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
//     _iap.buyNonConsumable(purchaseParam: purchaseParam);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     scrollController = ScrollController();
//     generalRepository = GeneralRepositoryBuilder.repository();
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
//       // print('checkmydateva; $date');
//     }
//     if (widget.table2.objecttypeid == 70 &&
//         widget.table2.eventscheduletype == 1) {
//       refresh(widget.contentid);
//     } else if (widget.table2.objecttypeid == 70 &&
//         widget.table2.eventscheduletype == 2) {
//       refresh(widget.table2.reschduleparentid);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     flutterToast = Fluttertoast(context);
//
//     if (widget.table2.isaddedtomylearning == 1 || isAddtomylearning) {
//       menu0 = true;
//       menu1 = false;
//
//       if (widget.table2.objecttypeid == "70") {
//         int relatedCount =
//             int.parse(widget.table2.relatedconentcount.toString());
//         if (relatedCount > 0) {
//           menu0 = true;
//         } else {
//           menu0 = false;
//         }
//       }
//     } else {
//       if (widget.table2.viewtype == 1) {
//         if (widget.table2.isaddedtomylearning == 0) {
//           menu0 = false;
//         } else {
//           menu0 = true;
//         }
//         menu1 = true;
//       } else if (widget.table2.viewtype == 2) {
//         menu0 = false;
//         menu1 = true;
//       } else if (widget.table2.viewtype == 3) {
//         menu2 = true;
//         menu1 = false;
//       } else if (widget.table2.viewtype == 5) {
//         menu0 = true;
//         menu1 = false;
//         if (widget.table2.isaddedtomylearning == 0) {
//           menu1 = true;
//         }
//       }
//     }
//     return Scaffold(
//       backgroundColor: Color(
//         int.parse(
//             "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
//       ),
//       appBar: AppBar(
//         elevation: 0,
//         title: Text(
//           'Course Details',
//           style: TextStyle(
//               fontSize: 18,
//               color: Color(int.parse(
//                   "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
//         ),
//         backgroundColor: Color(int.parse(
//             "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
//         leading: InkWell(
//           onTap: () => Navigator.of(context).pop(true),
//           child: Icon(Icons.arrow_back,
//               color: Color(int.parse(
//                   "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
//         ),
//         actions: <Widget>[
//           SizedBox(
//             width: 10.h,
//           ),
// //              contextList.isNotEmpty ?
//           GestureDetector(
//             onTap: () {
//               _settingMyCourceBottomSheet(context, widget.table2, 1);
//             },
//             child: Icon(
//               Icons.more_vert,
//               color: Colors.grey,
//             ),
//           ),
// //                  :Container(),
//           SizedBox(
//             width: 10.h,
//           ),
//         ],
//       ),
//       body: BlocConsumer(
//         bloc: catalogBloc,
//         listener: (context, state) {
//           if (state is AddToMyLearningState) {
//             if (state.status == Status.COMPLETED) {
//               flutterToast.showToast(
//                 child: CommonToast(displaymsg: 'Added to my Learning'),
//                 gravity: ToastGravity.BOTTOM,
//                 toastDuration: Duration(seconds: 2),
//               );
//               setState(() {
//                 isAddtomylearning = true;
//                 loaderAddtomylearning = false;
//               });
//             }
//           }
//         },
//         builder: (context, state) {
//           return BlocConsumer<MyLearningDetailsBloc, MyLearningDetailsState>(
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
//                     getDetailsApiCall(widget.contentid);
//                   } else if (state is GetLearningDetailsState) {
//                     print("GetLearningDetailsState-----${state}");
//                     if (state.status == Status.COMPLETED) {
//                       print("bloc data-----${data.toString()}");
//                       data = state.data;
//                     }
//                   }
//                 } else if (state is GetLearningDetailsState) {
//                   print("GetLearningDetailsState-----${state}");
//                   if (state.status == Status.COMPLETED) {
//                     print("bloc data-----${data.toString()}");
//                     data = state.data;
//                     Future.delayed(Duration(seconds: 4)).then((value) {
//                       _scrollToEnd();
//                     });
//                   }
//                 } else if (state.status == Status.ERROR) {
//                   if (state.message == '401') {
//                     AppDirectory.sessionTimeOut(context);
//                   } else {
//                     print('dont do navigation');
//                   }
//                 } else if (state is AddEnrollState) {
//                   if (state.status == Status.COMPLETED) {
//                     flutterToast.showToast(
//                         child: CommonToast(
//                             displaymsg:
//                                 'The subscribed item has been added to your My Learning. Please click on My Learning, and then click on View to launch the content.'),
//                         gravity: ToastGravity.BOTTOM,
//                         toastDuration: Duration(seconds: 2));
//                   }
//                 }
//               },
//               builder: (context, state) {
//                 print("data-----${data.toString()}");
//                 return Stack(
//                   children: <Widget>[
//                     (data != null)
//                         ? Container(
//                             color: Color(int.parse(
//                                 "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                             child: SingleChildScrollView(
//                               controller: scrollController,
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
//                                                 fit: BoxFit.fill,
//                                               ),
//                                               imageUrl: widget?.table2
//                                                       .thumbnailimagepath
//                                                       .startsWith('http')
//                                                   ? widget?.table2
//                                                       ?.thumbnailimagepath
//                                                   : widget?.table2?.siteurl
//                                                           ?.trim() +
//                                                       widget?.table2
//                                                           ?.thumbnailimagepath
//                                                           ?.trim(),
//                                               // "${widget?.table2?.siteurl?.trim()}${widget?.table2?.thumbnailimagepath?.trim()}",
//                                               fit: BoxFit.cover,
//                                             ),
// //
//                                           ),
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
//                                                   data?.titleName ?? '',
//                                                   style: TextStyle(
//                                                       color: Color(int.parse(
//                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                       fontSize: 17.h,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 )),
//                                                 SizedBox(
//                                                   width: 5.h,
//                                                 ),
//                                                 Icon(
//                                                   Icons.live_tv,
//                                                   color: Color(int.parse(
//                                                       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                 )
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
//                                                 Text(data?.authorName ?? '',
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 10.h,
//                                             ),
//                                             widget.table2?.keywords != ""
//                                                 ? Text(
//                                                     'Keywords',
//                                                     style: TextStyle(
//                                                         fontSize: 17.h,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                   )
//                                                 : Container(),
//                                             widget.table2?.keywords != ""
//                                                 ? SizedBox(
//                                                     height: 5.h,
//                                                   )
//                                                 : Container(),
//                                             widget.table2?.keywords != ""
//                                                 ? Text(
//                                                     widget.table2?.keywords ??
//                                                         '',
//                                                     style: TextStyle(
//                                                         fontSize: 14.h,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                   )
//                                                 : Container(),
//                                             widget.table2?.keywords != ""
//                                                 ? SizedBox(
//                                                     height: 10.h,
//                                                   )
//                                                 : Container(),
//                                             data?.learningObjectives != ""
//                                                 ? Text(
//                                                     "What you'll learn",
//                                                     style: TextStyle(
//                                                         fontSize: 17.h,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                   )
//                                                 : Container(),
//                                             data?.learningObjectives != ""
//                                                 ? SizedBox(
//                                                     height: 5.h,
//                                                   )
//                                                 : Container(),
//                                             data?.learningObjectives != ""
//                                                 ? Container(
//                                                     padding: EdgeInsets.only(
//                                                         right: 10.h),
//                                                     child: Html(
//                                                       data: data
//                                                           .learningObjectives,
//                                                       style: {
//                                                         "body": Style(
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                       },
//                                                     ),
//                                                   )
//                                                 : Container(),
//                                             widget.table2?.objecttypeid != 70
//                                                 ? SizedBox(
//                                                     height: 20.h,
//                                                   )
//                                                 : Container(),
//                                             widget.table2?.objecttypeid != 70
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
//                                             widget.table2?.objecttypeid != 70
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
//                                                       style: {
//                                                         "body": Style(
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                       },
//                                                     ),
//                                                   )
//                                                 : Container(),
//                                             widget.table2?.objecttypeid != 70
//                                                 ? SizedBox(
//                                                     height: 20.h,
//                                                   )
//                                                 : Container(),
//                                             data.tableofContent != ""
//                                                 ? Text(
//                                                     "Program Outline",
//                                                     style: TextStyle(
//                                                         fontSize: 17.h,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
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
//                                                       style: {
//                                                         "body": Style(
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                                       },
//                                                     ),
//                                                   )
//                                                 : Container(),
//                                             widget.table2.objecttypeid == 70 &&
//                                                         widget.table2
//                                                                 .eventscheduletype ==
//                                                             1 ||
//                                                     widget.table2
//                                                                 .objecttypeid ==
//                                                             70 &&
//                                                         widget.table2
//                                                                 .eventscheduletype ==
//                                                             2
//                                                 ? Container()
//                                                 : Row(
//                                                     children: <Widget>[
//                                                       Icon(
//                                                         Icons.timelapse,
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 10.h,
//                                                       ),
//                                                       Flexible(
//                                                         child: Text(
//                                                             'From ${data.eventStartDateTimeWithoutConvert} to ${data.eventEndDateTimeTimeWithoutConvert}',
//                                                             style: TextStyle(
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
//                                                       )
//                                                     ],
//                                                   ),
//                                             SizedBox(
//                                               height: 20.h,
//                                             ),
//                                             Text(
//                                               'Rate and review',
//                                               style: TextStyle(
//                                                   color: Color(int.parse(
//                                                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                   fontSize: 17.h,
//                                                   fontWeight: FontWeight.bold),
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
//                                                             .table2?.ratingid ??
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
//                                                   widget.table2?.ratingid
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
//                                                                         fontWeight:
//                                                                             FontWeight
//                                                                                 .bold,
//                                                                         color: Color(
//                                                                             int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
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
//                                                                         reviewList[pos]
//                                                                             .description),
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
//                                           ],
//                                         )),
//                                     SizedBox(
//                                       height: 20.h,
//                                     ),
//                                     Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: widget.table2.objecttypeid ==
//                                                         70 &&
//                                                     widget.table2
//                                                             .eventscheduletype ==
//                                                         1
//                                                 /*appBloc.uiSettingModel
//                                                               .EnableMultipleInstancesforEvent ==
//                                                           'true'*/
//                                                 ||
//                                                 widget.table2.objecttypeid ==
//                                                         70 &&
//                                                     widget.table2
//                                                             .eventscheduletype ==
//                                                         2
//                                             /*&& appBloc.uiSettingModel.EnableMultipleInstancesforEvent ==
//                                                           'true'*/
//                                             ? scheduleWidget()
//                                             : Container()
//
//                                         /* menu0
//                                               ? Container(
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   height: 50.h,
//                                                   child: MaterialButton(
//                                                     disabledColor: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
//                                                         .withOpacity(0.5),
//                                                     color: Color(int.parse(
//                                                         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: <Widget>[
//                                                         Icon(
//                                                             IconDataSolid(
//                                                                 int.parse(
//                                                                     '0xf06e')),
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
//                                                         SizedBox(
//                                                           width: 5.h,
//                                                         ),
//                                                         Text(
//                                                             appBloc.localstr
//                                                                 .catalogActionsheetViewoption,
//                                                             style: TextStyle(
//                                                                 fontSize: 14,
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
//                                                       ],
//                                                     ),
//                                                     onPressed: () {
//                                                       if (widget.table2
//                                                                   .isaddedtomylearning ==
//                                                               1 ||
//                                                           isAddtomylearning) {
//                                                         launchCourse(
//                                                             widget.table2,
//                                                             context);
//                                                       } else {
//                                                         launchCoursePreview(
//                                                             widget.table2,
//                                                             context);
//                                                       }
//                                                     },
//                                                   ),
//                                                 )
//                                               : Container(),*/
//                                         /* menu1
//                                               ? Container(
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   height: 50.h,
//                                                   child: MaterialButton(
//                                                     disabledColor: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
//                                                         .withOpacity(0.5),
//                                                     color: Color(int.parse(
//                                                         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: <Widget>[
//                                                         Icon(
//                                                             Icons
//                                                                 .add,
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
//                                                         SizedBox(
//                                                           width: 5.h,
//                                                         ),
//                                                         Text(
//                                                             appBloc.localstr
//                                                                 .catalogActionsheetAddtomylearningoption,
//                                                             style: TextStyle(
//                                                                 fontSize: 14,
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
//                                                       ],
//                                                     ),
//                                                     onPressed: () {
//                                                       setState(() {
//                                                         loaderAddtomylearning =
//                                                             true;
//                                                       });
//                                                       // catalogBloc.add(
//                                                       //     AddToMyLearningEvent(
//                                                       //         contentId: widget
//                                                       //             .table2
//                                                       //             .contentid));
//
//                                                       if (widget.table2
//                                                                   .userid !=
//                                                               null &&
//                                                           widget.table2
//                                                                   .userid !=
//                                                               "-1") {
//                                                         catalogBloc.add(
//                                                             AddToMyLearningEvent(
//                                                                 contentId: widget
//                                                                     .table2
//                                                                     .contentid,
//                                                                 table2: widget
//                                                                     .table2));
//                                                       } else {
//                                                         flutterToast.showToast(
//                                                           child: CommonToast(
//                                                               displaymsg:
//                                                                   'Not a member of ${widget.table2?.sitename ?? ''}'),
//                                                           gravity: ToastGravity
//                                                               .BOTTOM,
//                                                           toastDuration:
//                                                               Duration(
//                                                                   seconds: 2),
//                                                         );
//                                                         checkUserLogin(
//                                                             widget.table2);
//                                                       }
//                                                     },
//                                                   ),
//                                                 )
//                                               : Container(),*/
//                                         /*menu2
//                                               ? Container(
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   height: 50.h,
//                                                   child: MaterialButton(
//                                                     disabledColor: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
//                                                         .withOpacity(0.5),
//                                                     color: Color(int.parse(
//                                                         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: <Widget>[
//                                                         Icon(
//                                                             IconDataSolid(
//                                                                 int.parse(
//                                                                     '0xf144')),
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
//                                                         SizedBox(
//                                                           width: 5.h,
//                                                         ),
//                                                         Text(
//                                                             appBloc.localstr
//                                                                 .catalogActionsheetBuyoption,
//                                                             style: TextStyle(
//                                                                 fontSize: 14,
//                                                                 color: Color(
//                                                                     int.parse(
//                                                                         "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
//                                                       ],
//                                                     ),
//                                                     onPressed: () {
//                                                       flutterToast.showToast(
//                                                         child: CommonToast(
//                                                             displaymsg:
//                                                                 'Work in Progress'),
//                                                         gravity:
//                                                             ToastGravity.BOTTOM,
//                                                         toastDuration: Duration(
//                                                             seconds: 2),
//                                                       );
//                                                     },
//                                                   ),
//                                                 )
//                                               : Container(),*/
//                                         )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                     (state.status == Status.LOADING ||
//                             loaderAddtomylearning ||
//                             loaderEnroll)
//                         ? Center(
//                             child: AbsorbPointer(
//                               child: SpinKitCircle(
//                                 color: Colors.grey,
//                                 size: 70.h,
//                               ),
//                             ),
//                           )
//                         : Container()
//                   ],
//                 );
//               });
//         },
//       ),
//     );
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
//     } else {
//       if (widget.table2.isaddedtomylearning == 2 ||
//           widget.table2.isaddedtomylearning == 0) {
//         return displayButton(
//             appBloc.localstr.catalogActionsheetAddtomylearningoption);
//       }
//       return Container();
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
//               } else if (widget.table2.isaddedtomylearning == 2) {
//                 catalogBloc.add(
//                   GetPrequisiteDetailsEvent(
//                       contentId: widget.table2.contentid,
//                       userID: widget.table2.userid),
//                 );
//               } else if (widget.table2.isaddedtomylearning == 0) {
//                 catalogBloc.add(AddToMyLearningEvent(
//                     contentId: widget.table2?.contentid,
//                     table2: widget.table2));
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
//   /*
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
//         //callAddToCalendar();
//         break;
//
//       case 6:
//         //addToEnroll(widget.table2);
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
//         //getViewRecordingUrlData(widget.table2);
//
//         break;
//
//       default:
//     }
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
//   */
//
//   void getUserId() async {
//     strUserID = await sharePref_getString(sharedPref_userid);
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
//   void getDetailsApiCall(String contentid) {
//     MyLearningDetailsRequest detailsRequest = MyLearningDetailsRequest();
//     detailsRequest.locale = 'en-us';
//     detailsRequest.contentId = contentid;
//     detailsRequest.metadata = '1';
//     detailsRequest.intUserId = strUserID;
//     detailsRequest.iCms = false;
//     detailsRequest.componentId = '1';
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
//   _settingMyCourceBottomSheet(
//       context, DummyMyCatelogResponseTable2 table2, int i) {
// //    print('bottomsheetobjit ${table2.objecttypeid}');
//
//     menu0 = false;
//     menu1 = false;
//
//     if (table2.isaddedtomylearning == 1 || isAddtomylearning) {
//       menu0 = true;
//       menu1 = false;
//
//       if (table2.objecttypeid == "70") {
//         int relatedCount = int.parse(table2.relatedconentcount.toString());
//         if (relatedCount > 0) {
//           menu0 = true;
//         } else {
//           menu0 = false;
//         }
//       } else if ((widget.table2.objecttypeid == 70 &&
//               widget.table2.eventscheduletype == 1) ||
//           widget.table2.objecttypeid == 70 &&
//               widget.table2.eventscheduletype == 1) {
//         menu0 = false;
//       } else {
//         menu0 = true;
//       }
//     } else {
//       if (table2.viewtype == 1) {
//         if (table2.isaddedtomylearning == 0) {
//           menu0 = true;
//         } else {
//           menu0 = false;
//         }
//         menu1 = true;
//       } else if (table2.viewtype == 2) {
//         menu0 = false;
//         menu1 = true;
//       } else if (table2.viewtype == 3) {
//         menu2 = true;
//         menu1 = false;
//       } else if (table2.viewtype == 5) {
//         // for ditrect view
//         menu0 = true;
//         menu1 = false;
//
//         if (table2.isaddedtomylearning == 0) {
//           menu1 = true;
//         }
//       }
//     }
//
//     showModalBottomSheet(
//         backgroundColor: Color(int.parse(
//             "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//         context: context,
//         builder: (BuildContext bc) {
//           // final provider = Provider.of<InAppPurchase>(context);
//           // provider.initialize();
//
//           return Container(
//             child: SingleChildScrollView(
//               child: new Column(
//                 children: <Widget>[
//                   menu0
//                       ? ListTile(
//                           title: Text(
//                             appBloc.localstr.catalogActionsheetViewoption,
//                             style: TextStyle(
//                                 color: Color(int.parse(
//                                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                           ),
//                           leading: Icon(
//                             IconDataSolid(int.parse('0xf144')),
//                             color: Colors.grey,
//                           ),
//                           onTap: () {
//                             if (table2.isaddedtomylearning == 1 ||
//                                 isAddtomylearning) {
//                               launchCourse(widget.table2, context);
//                             } else {
//                               launchCoursePreview(widget.table2, context);
//                             }
//                           },
//                         )
//                       : Container(),
//                   menu1
//                       ? ListTile(
//                           title: Text(
//                             appBloc.localstr
//                                 .catalogActionsheetAddtomylearningoption,
//                             style: TextStyle(
//                                 color: Color(int.parse(
//                                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                           ),
//                           leading: Icon(
//                             Icons.add_circle,
//                             color: Colors.grey,
//                           ),
//                           onTap: () {
//                             setState(() {
//                               loaderAddtomylearning = true;
//                             });
//                             if (table2?.userid != null &&
//                                 table2?.userid != "-1") {
//                               if (table2.isaddedtomylearning == 2) {
//                                 catalogBloc.add(
//                                   GetPrequisiteDetailsEvent(
//                                       contentId: table2.contentid,
//                                       userID: table2.userid),
//                                 );
//                               } else {
//                                 catalogBloc.add(AddToMyLearningEvent(
//                                     contentId: table2?.contentid,
//                                     table2: table2));
//                               }
//                             } else {
//                               flutterToast.showToast(
//                                 child: CommonToast(
//                                     displaymsg:
//                                         'Not a member of ${table2?.sitename}'),
//                                 gravity: ToastGravity.BOTTOM,
//                                 toastDuration: Duration(seconds: 2),
//                               );
//                               checkUserLogin(table2);
//                             }
//                           },
//                         )
//                       : Container(),
//                   menu2
//                       ? ListTile(
//                           title: Text(
//                               appBloc.localstr.catalogActionsheetBuyoption),
//                           leading: Icon(
//                             IconDataSolid(int.parse('0xf144')),
//                             color: Colors.grey,
//                           ),
//                           onTap: () {
//                             flutterToast.showToast(
//                               child:
//                                   CommonToast(displaymsg: 'Work in Progress'),
//                               gravity: ToastGravity.BOTTOM,
//                               toastDuration: Duration(seconds: 2),
//                             );
//
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => Buyoption()));
//
//                             // for (var prod in provider.products)
//                             //   if (provider.hasPurchased(prod.id) != null) {
//                             //   } else {
//                             //     _buyProduct(prod);
//                             //   }
//
//                             // if (Platform.isAndroid) {
//                             //   ProductDetails product = new ProductDetails(
//                             //       id: provider.myProductID,
//                             //       title: "Ergonomics Course Certification",
//                             //       description:
//                             //           "Ergonomics is an applied science that coordinates the design of devices, systems",
//                             //       price: "USD 25.00");
//                             //   _buyProduct(product);
//                             // }
//                           },
//                         )
//                       : Container(),
//                   displayShare(table2),
//                   displayShareConnection(table2)
//                 ],
//               ),
//             ),
//           );
//         });
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
//   Future<void> launchCoursePreview(
//       DummyMyCatelogResponseTable2 table2, BuildContext context) async {
//     courseLaunchCatalog = GotoCourseLaunchCatalog(context, table2, false,
//         appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
//     String url = await courseLaunchCatalog.getCourseUrl();
//     if (url.isNotEmpty) {
//       //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(url,table2)));
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => InAppWebCourseLaunch(url, table2)));
//     }
//   }
//
//   Future<void> launchCourse(
//       DummyMyCatelogResponseTable2 table2, BuildContext context) async {
//     print('helllllllllloooooo');
//
//     /// Need Some value
//     if (table2.objecttypeid == 102) {
//       executeXAPICourse(table2);
//     }
//
//     if (table2.objecttypeid == 10 && table2.bit5) {
//       // Need to open EventTrackListTabsActivity
//
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => EventTrackList(
//                 table2,
//                 true,
//                 null,
//               )));
//     } else {
//       courseLaunch = GotoCourseLaunch(context, table2, false,
//           appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
//       String url = await courseLaunch.getCourseUrl();
//
//       if (url.isNotEmpty) {
//         if (table2.objecttypeid == 26) {
//           await Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => AdvancedWebCourseLaunch(url, table2.name)));
//         } else {
//           await Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => InAppWebCourseLaunch(url, table2)));
//         }
//       }
//     }
//   }
//
//   Future<void> executeXAPICourse(
//       DummyMyCatelogResponseTable2 learningModel) async {
//     var strUserID = await sharePref_getString(sharedPref_userid);
//     var strSiteID = await sharePref_getString(sharedPref_siteid);
//     var webApiUrl = await sharePref_getString(sharedPref_webApiUrl);
//
//     String paramsString = "strContentID=" +
//         learningModel.contentid +
//         "&UserID=" +
//         strUserID +
//         "&SiteID=" +
//         strSiteID +
//         "&SCOID=" +
//         learningModel.scoid.toString() +
//         "&CanTrack=true";
//
//     String url = webApiUrl + "CourseTracking/TrackLRSStatement?" + paramsString;
//
//     ApiResponse apiResponse = await generalRepository.executeXAPICourse(url);
//   }
//
//   checkUserLogin(DummyMyCatelogResponseTable2 table2) async {
//     String userId = await sharePref_getString(sharedPref_LoginUserID);
//     String password = await sharePref_getString(sharedPref_LoginPassword);
//
//     catalogBloc.add(LoginSubsiteEvent(
//         table2: table2,
//         email: userId,
//         password: password,
//         localStr: appBloc.localstr,
//         subSiteId: '${table2.siteid}',
//         subSiteUrl: table2.siteurl));
//   }
//
//   checkSubsiteLogding(String response, DummyMyCatelogResponseTable2 table2) {
//     SubsiteLoginResponse subsiteLoginResponse = new SubsiteLoginResponse();
//     Map<String, dynamic> userloginAry = jsonDecode(response);
//     try {
//       String succesMessage = '${appBloc.localstr.catalogLabelAlreadyinmylearning}' +
//           '${appBloc.localstr.eventsAlertsubtitleYouhavesuccessfullyjoinedcommunity}' +
//           table2.sitename;
//
//       if (userloginAry.containsKey("faileduserlogin")) {
//         subsiteLoginResponse = subsiteLoginResponse =
//             loginFaildeResponseFromJson(response.toString());
//
//         subsiteLoginResponse.failedUserLogin[0].userstatus == 'Login Failed'
//             ? flutterToast.showToast(
//                 child:
//                     CommonToast(displaymsg: 'Login Failed ${table2.sitename}'),
//                 gravity: ToastGravity.BOTTOM,
//                 toastDuration: Duration(seconds: 4),
//               )
//             : flutterToast.showToast(
//                 child: CommonToast(displaymsg: 'Pending Registration'),
//                 gravity: ToastGravity.BOTTOM,
//                 toastDuration: Duration(seconds: 4),
//               );
//       } else if (userloginAry.containsKey("successfulluserlogin")) {
//         subsiteLoginResponse = subsiteLoginResponse =
//             loginSuccessResponseFromJson(response.toString());
//
//         flutterToast.showToast(
//           child: CommonToast(displaymsg: succesMessage),
//           gravity: ToastGravity.BOTTOM,
//           toastDuration: Duration(seconds: 4),
//         );
//         table2.userid =
//             '${subsiteLoginResponse.successFullUserLogin[0].userid}';
//         catalogBloc.add(
//             AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Widget scheduleWidget() {
//     return BlocConsumer<CatalogBloc, CatalogState>(
//       bloc: catalogBloc,
//       listener: (context, state) {
//         if (state is GetScheduleDataState) {
//           if (state.status == Status.COMPLETED) {
//             setState(() {
//               loaderEnroll = false;
//             });
//           }
//         } else if (state is AddEnrollState) {
//           if (state.status == Status.COMPLETED) {
//             loaderEnroll = false;
//             if (catalogBloc.addToMyLearningRes.isSuccess) {
//               catalogBloc.eventEnrollmentResponse.courseList.forEach((element) {
//                 getDetailsApiCall(element.contentID);
//                 refresh(element.contentID);
//               });
//               flutterToast.showToast(
//                   child: CommonToast(
//                       displaymsg:
//                           'The subscribed item has been added to your My Learning. Please click on My Learning, and then click on View to launch the content.'),
//                   gravity: ToastGravity.BOTTOM,
//                   toastDuration: Duration(seconds: 2));
//               getDetailsApiCall(contentID);
//               refresh(contentID);
//             } else {
//               flutterToast.showToast(
//                   child: CommonToast(
//                       displaymsg: catalogBloc.addToMyLearningRes.message),
//                   gravity: ToastGravity.BOTTOM,
//                   toastDuration: Duration(seconds: 2));
//             }
//           }
//         }
//       },
//       builder: (context, state) {
//         return new Container(
//             color: Color(int.parse(
//                 "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Visibility(
//                     visible:
//                         catalogBloc.eventEnrollmentResponse.courseList.length !=
//                                 0
//                             ? true
//                             : false,
//                     child: Padding(
//                         padding: EdgeInsets.only(
//                           left: 20,
//                         ),
//                         child: new Text(
//                           'Teaching Schedule',
//                           style: new TextStyle(
//                               color: Color(int.parse(
//                                   "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.bold),
//                         ))),
//                 new ListView.builder(
//                   primary: false,
//                   shrinkWrap: true,
//                   itemCount:
//                       catalogBloc.eventEnrollmentResponse.courseList.length,
//                   itemBuilder: (context, index) {
//                     return new GestureDetector(
//                       onTap: () => {},
//                       child: Padding(
//                           padding:
//                               EdgeInsets.only(top: ScreenUtil().setHeight(10)),
//                           child: Card(
//                             color: Color(int.parse(
//                                 "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                             elevation: 4,
//                             child: new Container(
//                                 padding:
//                                     EdgeInsets.all(ScreenUtil().setHeight(5)),
//                                 child: Expanded(
//                                     child: new Column(
//                                   children: [
//                                     new Row(
//                                       children: [
//                                         new Expanded(
//                                             child: new Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 10, bottom: 5.0),
//                                                 child: new Text(
//                                                   DateFormat('EEEE, d MMM')
//                                                       .format(DateFormat(
//                                                               'MM/dd/yyyy HH:mm a')
//                                                           .parse(catalogBloc
//                                                               .eventEnrollmentResponse
//                                                               .courseList[index]
//                                                               .eventStartDateTime)),
//                                                   style: new TextStyle(
//                                                       color: Color(int.parse(
//                                                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                       fontSize: 14.0,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 )),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 20, top: 5.0),
//                                                   child: Container(
//                                                     height: 14,
//                                                     width: 14,
//                                                     decoration: BoxDecoration(
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                         shape: BoxShape.circle,
//                                                         border: Border.all(
//                                                             width: 1.5,
//                                                             color: Color(int.parse(
//                                                                 "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 20, top: 5.0),
//                                                     child: new Text(
//                                                       catalogBloc
//                                                               .eventEnrollmentResponse
//                                                               .courseList[index]
//                                                               .contentType ??
//                                                           '',
//                                                       style: new TextStyle(
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                           fontSize: 14.0),
//                                                     )),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 20,
//                                                     ),
//                                                     child: new Text(
//                                                       '(' +
//                                                           DateFormat('h:mm a').format(DateFormat(
//                                                                   'dd/MM/yyyy HH:mm')
//                                                               .parse(catalogBloc
//                                                                       .eventEnrollmentResponse
//                                                                       .courseList[
//                                                                           index]
//                                                                       .eventStartDateTime ??
//                                                                   '')) +
//                                                           '-' +
//                                                           DateFormat('h:mm a').format(DateFormat(
//                                                                   'dd/MM/yyyy HH:mm')
//                                                               .parse(catalogBloc
//                                                                       .eventEnrollmentResponse
//                                                                       .courseList[
//                                                                           index]
//                                                                       .eventEndDateTime ??
//                                                                   '')) +
//                                                           ')',
//                                                       style: new TextStyle(
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                           fontSize: 14.0),
//                                                     )),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 20, top: 10.0),
//                                                     child: new Text(
//                                                       catalogBloc
//                                                               .eventEnrollmentResponse
//                                                               .courseList[index]
//                                                               .title ??
//                                                           '',
//                                                       style: new TextStyle(
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                           fontSize: 14.0,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     )),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 20, top: 5.0),
//                                                     child: new Text(
//                                                       catalogBloc
//                                                               .eventEnrollmentResponse
//                                                               .courseList[index]
//                                                               .shortDescription ??
//                                                           '',
//                                                       style: new TextStyle(
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                           fontSize: 14.0),
//                                                     )),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 20, top: 5.0),
//                                                     child: Row(
//                                                       children: [
//                                                         new Text(
//                                                           catalogBloc
//                                                                   .eventEnrollmentResponse
//                                                                   .courseList[
//                                                                       index]
//                                                                   .duration ??
//                                                               '',
//                                                           style: new TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: Color(
//                                                                   int.parse(
//                                                                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                               fontSize: 14.0),
//                                                         ),
//                                                         Padding(
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   7.0),
//                                                           child: Container(
//                                                             height: 10,
//                                                             width: 10,
//                                                             decoration: BoxDecoration(
//                                                                 color: Colors
//                                                                     .grey
//                                                                     .shade700,
//                                                                 shape: BoxShape
//                                                                     .circle,
//                                                                 border: Border.all(
//                                                                     width: 1.5,
//                                                                     color: Colors
//                                                                         .grey
//                                                                         .shade700)),
//                                                           ),
//                                                         ),
//                                                         new Text(
//                                                           ' by ' +
//                                                                   catalogBloc
//                                                                       .eventEnrollmentResponse
//                                                                       .courseList[
//                                                                           index]
//                                                                       .presenterDisplayName ??
//                                                               '',
//                                                           style: new TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: Color(
//                                                                   int.parse(
//                                                                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                               fontSize: 14.0),
//                                                         )
//                                                       ],
//                                                     )),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 20, top: 5.0),
//                                                     child: new Text(
//                                                       catalogBloc
//                                                               .eventEnrollmentResponse
//                                                               .courseList[index]
//                                                               .locationName ??
//                                                           '',
//                                                       style: new TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
//                                                           fontSize: 14.0),
//                                                     )),
//                                                 Visibility(
//                                                     visible: catalogBloc
//                                                                 .eventEnrollmentResponse
//                                                                 .courseList[
//                                                                     index]
//                                                                 .isContentEnrolled ==
//                                                             '1'
//                                                         ? false
//                                                         : true,
//                                                     child: Container(
//                                                       margin: EdgeInsets.only(
//                                                           left: 20.0,
//                                                           right: 20.0),
//                                                       width:
//                                                           MediaQuery.of(context)
//                                                               .size
//                                                               .width,
//                                                       //height: 50.h,
//                                                       child: MaterialButton(
//                                                         disabledColor: Color(
//                                                                 int.parse(
//                                                                     "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
//                                                             .withOpacity(0.5),
//                                                         color: Color(int.parse(
//                                                             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: <Widget>[
//                                                             Text('Enroll',
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         14,
//                                                                     color: Color(
//                                                                         int.parse(
//                                                                             "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
//                                                           ],
//                                                         ),
//                                                         onPressed: () {
//                                                           setState(() {
//                                                             loaderEnroll = true;
//                                                           });
//                                                           catalogBloc.add(AddEnrollEvent(
//                                                               selectedContent:
//                                                                   catalogBloc
//                                                                       .eventEnrollmentResponse
//                                                                       .courseList[
//                                                                           index]
//                                                                       .contentID,
//                                                               componentID: int
//                                                                   .parse(widget
//                                                                       .nativeModel
//                                                                       .componentId),
//                                                               componentInsID: int
//                                                                   .parse(widget
//                                                                       .nativeModel
//                                                                       .repositoryId),
//                                                               additionalParams:
//                                                                   '',
//                                                               targetDate: ''));
//
//                                                           contentID = catalogBloc
//                                                               .eventEnrollmentResponse
//                                                               .courseList[index]
//                                                               .contentID;
//                                                         },
//                                                       ),
//                                                     )),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 20,
//                                                         top: 5.0,
//                                                         bottom: 5.0),
//                                                     child: new Text(
//                                                       catalogBloc
//                                                               .eventEnrollmentResponse
//                                                               .courseList[index]
//                                                               .availableSeats +
//                                                           ' Seats Remain',
//                                                       style: new TextStyle(
//                                                           color: Color(int.parse(
//                                                               "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
//                                                           fontSize: 14.0,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     )),
//                                               ],
//                                             ),
//                                           ],
//                                         )),
//                                       ],
//                                     ),
//                                   ],
//                                 ))),
//                           )),
//                     );
//                   },
//                 )
//               ],
//             ));
//       },
//     );
//   }
//
//   refresh(String contentId) {
//     if (widget.table2.objecttypeid == 70 &&
//         widget.table2.eventscheduletype == 1) {
//       catalogBloc.add(GetScheduleEvent(
//           eventID: contentId, multiInstanceEventEnroll: '', multiLocation: ''));
//     } else if (widget.table2.objecttypeid == 70 &&
//         widget.table2.eventscheduletype == 2) {
//       catalogBloc.add(GetScheduleEvent(
//           eventID: contentId, multiInstanceEventEnroll: '', multiLocation: ''));
//     }
//   }
//
//   void _scrollToEnd() {
//     var scrollPosition = scrollController.position;
//     scrollController.jumpTo(scrollPosition.maxScrollExtent);
//     if (!scrollController.hasClients) {
//       return;
//     }
//
//     if (scrollPosition.maxScrollExtent > scrollPosition.minScrollExtent) {
//       scrollController.animateTo(
//         scrollPosition.maxScrollExtent,
//         duration: new Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
// }
