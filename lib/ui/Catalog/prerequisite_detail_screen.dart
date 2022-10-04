import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/catalog_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/model/subsitelogin_response.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/Catalog/gotoCoursePreview.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:intl/intl.dart';

import '../../configs/constants.dart';
import '../../utils/my_utils.dart';
import '../common/bottomsheet_drager.dart';
import '../common/bottomsheet_option_tile.dart';

class PrerequisiteDetailScreen extends StatefulWidget {
  final String contentid;
  final CatalogDetailsResponse table2;
  final MyLearningDetailsBloc detailsBloc;
  final NativeMenuModel nativeModel;
  final bool isFromNotification;

  const PrerequisiteDetailScreen({
    required this.contentid,
    required this.table2,
    required this.detailsBloc,
    required this.nativeModel,
    required this.isFromNotification,
  });

  @override
  State<PrerequisiteDetailScreen> createState() =>
      _PrerequisiteDetailScreenState();
}

class _PrerequisiteDetailScreenState extends State<PrerequisiteDetailScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);
  late MyLearningDetailsBloc detailsBloc;
  var strUserID = '';

  String eventstartDate = '';
  String eventendDate = '';

  List<EditRating> reviewList = [];

  int ratingCount = 0;
  bool isEditRating = false;

  MyLearningDetailsResponse? data;

  String imgUrl =
      "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

  bool menu0 = false,
      menu1 = false,
      menu2 = false,
      isAddtomylearning = false,
      loaderAddtomylearning = false,
      loaderEnroll = false;

  late FToast flutterToast;

  GotoCourseLaunch? courseLaunch;
  GotoCourseLaunchCatalog? courseLaunchCatalog;

  GeneralRepository? generalRepository;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    detailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());
    generalRepository = GeneralRepositoryBuilder.repository();
    detailsBloc = widget.detailsBloc;
    //   detailsBloc.userRatingDetails.clear();
    //    detailsBloc.add(
    //        GetDetailsReviewEvent(contentId: widget.contentid, skippedRows: 0));
    getDetailsApiCall(widget.contentid);
    getUserId();
    if (isValidString(widget.table2.eventStartDateTime ?? "")) {
      DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(widget.table2.eventStartDateTime);

      String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDate);
      eventstartDate = date;

      print('checkmydateva; $date');
    }

    if (isValidString(widget.table2.eventStartDateTime ?? "")) {
      DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(widget.table2.eventStartDateTime);

      String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDate);
      eventendDate = date;

      print('checkmydateva; $date');
    }
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    print("Prerequisite details screen");

    if (widget.table2.isaddtomylearninglogo == 1 || isAddtomylearning) {
      menu0 = true;
      menu1 = false;

      if (widget.table2.contentTypeId == "70") {
        int relatedCount =
            int.parse(widget.table2.relatedContentLink.toString());
        if (relatedCount > 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
      }
    }
    else {
      if (widget.table2.viewType == 1) {
        if (widget.table2.isaddtomylearninglogo == 0) {
          menu0 = false;
        } else {
          menu0 = true;
        }
        menu1 = true;
      } else if (widget.table2.viewType == 2) {
        menu0 = false;
        menu1 = true;
      } else if (widget.table2.viewType == 3) {
        menu2 = true;
        menu1 = false;
      } else if (widget.table2.viewType == 5) {
        // for ditrect view
        menu0 = true;

        menu1 = false;

        if (widget.table2.isaddtomylearninglogo == 0) {
          menu1 = true;
        }
      }
    }
    return Scaffold(
      backgroundColor: Color(
        int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Course Details',
          style: TextStyle(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(true),
          child: Icon(Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        actions: <Widget>[
          SizedBox(
            width: 10.h,
          ),
//              contextList.isNotEmpty ?
          GestureDetector(
            onTap: () {
              widget.isFromNotification
                  ? _settingMyCourceBottomSheet1(context, widget.table2, 1)
                  : _settingMyCourceBottomSheet(context, data!, 1);
            },
            child: widget.table2.contentTypeId != 70 &&
                    widget.table2.eventScheduleType != 1
                ? Container()
                : Icon(
                    Icons.more_vert,
                    color: InsColor(appBloc).appIconColor,
                  ),
          ),
//                  :Container(),
          SizedBox(
            width: 10.h,
          ),
        ],
      ),
      body: BlocConsumer(
        bloc: catalogBloc,
        listener: (context, state) {
          if (state is AddToMyLearningState) {
            if (state.status == Status.COMPLETED) {
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: appBloc.localstr
                        .catalogAlertsubtitleThiscontentitemhasbeenaddedto),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
              setState(() {
                isAddtomylearning = false;
                loaderAddtomylearning = false;
                //loaderEnroll= false;
              });
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<MyLearningDetailsBloc, MyLearningDetailsState>(
              bloc: detailsBloc,
              listener: (context, state) {
                if (state.status == Status.COMPLETED) {
                  if (state is GetReviewsDetailstate) {
                    reviewList = detailsBloc.userRatingDetails;
                    print('reviewlistdata $reviewList');
                    ratingCount = state.review.recordCount;
                    if (state.review.editRating == null) {
                      isEditRating = false;
                    } else {
                      isEditRating = true;
                    }
                  } else if (state is GetLearningDetailsState) {
                    print("GetLearningDetailsState-----$state");
                    if (state.status == Status.COMPLETED) {
                      print("bloc data-----${state.data.toString()}");
                      data = state.data;
                    }
                  }
                } else if (state is GetLearningDetailsState) {
                  print("GetLearningDetailsState-----$state");
                  if (state.status == Status.COMPLETED) {
                    print("bloc data-----${data.toString()}");
                    data = state.data;
                    Future.delayed(const Duration(seconds: 4)).then((value) {
                      _scrollToEnd();
                    });
                  }
                } else if (state.status == Status.ERROR) {
                  if (state.message == '401') {
                    AppDirectory.sessionTimeOut(context);
                  } else {
                    print('dont do navigation');
                  }
                }
              },
              builder: (context, state) {
                print("data-----${data.toString()}");
                if (state.status == Status.LOADING && widget.isFromNotification
                    ? widget.table2 == null
                    : data == null) {
                  return Center(
                    child: AbsorbPointer(
                      child: AppConstants().getLoaderWidget(iconSize: 70)
                    ),
                  );
                }
                else {
                  return Stack(
                    children: <Widget>[
                      Container(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 190.h,
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 160.h,
                                        width: MediaQuery.of(context).size.width,
                                        child: !widget.isFromNotification && data != null
                                            ? CachedNetworkImage(
                                                imageUrl: MyUtils.getSecureUrl(ApiEndpoints
                                                        .strSiteUrl +
                                                    data?.thumbnailImagePath),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                //placeholder: (context, url) => CircularProgressIndicator(),
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                  'assets/cellimage.jpg',
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  'assets/cellimage.jpg',
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : widget.table2.thumbnailImagePath != null
                                                ? CachedNetworkImage(
                                                    imageUrl: MyUtils.getSecureUrl(widget.table2.thumbnailImagePath.startsWith('http')
                                                        ? widget.table2.thumbnailImagePath.trim()
                                                        : ApiEndpoints.strSiteUrl + widget.table2.thumbnailImagePath.trim()),
                                                    width: MediaQuery.of(context).size.width,
                                                    //placeholder: (context, url) => CircularProgressIndicator(),
                                                    placeholder: (context, url) => Image.asset(
                                                      'assets/cellimage.jpg',
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    errorWidget: (context, url, error) => Image.asset(
                                                      'assets/cellimage.jpg',
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/cellimage.jpg',
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover,
                                                  ),

//
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                                child: Text(
                                              widget.isFromNotification
                                                  ? widget.table2.titleName ??
                                                      ''
                                                  : data?.titleName ?? '',
                                              style: TextStyle(
                                                  color: InsColor(appBloc)
                                                      .appTextColor,
                                                  fontSize: 17.h,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            SizedBox(
                                              width: 5.h,
                                            ),
                                            Icon(
                                              Icons.live_tv,
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
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
                                            Text(
                                                widget.isFromNotification
                                                    ? widget.table2
                                                            .authorName ??
                                                        ''
                                                    : data?.authorName ?? '',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        /*  widget.table2?.keywords != ""
                                              ? Text(
                                                  'Keywords',
                                                  style: TextStyle(
                                                      fontSize: 17.h,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Container(),
                                          widget.table2?.keywords != ""
                                              ? SizedBox(
                                                  height: 5.h,
                                                )
                                              : Container(),
                                          widget.table2?.keywords != ""
                                              ? Text(
                                                  widget.table2?.keywords ??
                                                      '',
                                                  style: TextStyle(
                                                      fontSize: 14.h,
                                                      color: Colors.black),
                                                )
                                              : Container(),
                                          widget.table2?.keywords != ""
                                              ? SizedBox(
                                                  height: 10.h,
                                                )
                                              : Container(),*/
                                        data?.learningObjectives != ""
                                            ? Text(
                                                "What you'll learn",
                                                style: TextStyle(
                                                    color: InsColor(appBloc)
                                                        .appTextColor,
                                                    fontSize: 17.h,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : widget.table2
                                                        .learningObjectives !=
                                                    ""
                                                ? Text(
                                                    "What you'll learn",
                                                    style: TextStyle(
                                                        color: InsColor(appBloc)
                                                            .appTextColor,
                                                        fontSize: 17.h,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Container(),
                                        data?.learningObjectives != ""
                                            ? SizedBox(
                                                height: 5.h,
                                              )
                                            : widget.table2
                                                        .learningObjectives !=
                                                    ""
                                                ? SizedBox(
                                                    height: 5.h,
                                                  )
                                                : Container(),
                                        data?.learningObjectives != ""
                                            ? Container(
                                                padding: EdgeInsets.only(
                                                    right: 10.h),
                                                child: Html(
                                                    data: widget.isFromNotification
                                                        ? widget.table2
                                                                .learningObjectives ??
                                                            ''
                                                        : data?.learningObjectives ??
                                                            '',
                                                    style: {
                                                      "body": Style(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                    }),
                                              )
                                            : widget.table2
                                                        .learningObjectives !=
                                                    ""
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10.h),
                                                    child: Html(
                                                      data: widget
                                                              .isFromNotification
                                                          ? widget.table2
                                                                  .learningObjectives ??
                                                              ''
                                                          : data
                                                              ?.learningObjectives,
                                                    ),
                                                  )
                                                : Container(),
                                        data?.contentTypeId != 70
                                            ? SizedBox(
                                                height: 20.h,
                                              )
                                            : Container(),
                                        data?.contentTypeId != 70
                                            ? (removeAllHtmlTags(
                                                            data?.longDescription ??
                                                                "") !=
                                                        null ||
                                                    removeAllHtmlTags(widget
                                                                .isFromNotification
                                                            ? (widget.table2
                                                                    .shortDescription ??
                                                                '')
                                                            : (data?.shortDescription ??
                                                                "")) !=
                                                        null)
                                                ? Text(
                                                    appBloc.localstr
                                                        .detailsLabelDescriptionlabel,
                                                    style: TextStyle(
                                                        color: InsColor(appBloc)
                                                            .appTextColor,
                                                        fontSize: 17.h,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Container()
                                            : Container(),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        widget.table2.contentTypeId != 70
                                            ? Container(
                                                padding: EdgeInsets.only(
                                                    right: 10.h),
                                                child: Html(
                                                  shrinkWrap: true,
                                                  data: widget.table2
                                                              .longDescription !=
                                                          null
                                                      ? widget.table2
                                                              .longDescription ??
                                                          ''
                                                      : widget.table2
                                                                  .shortDescription !=
                                                              null
                                                          ? widget.table2
                                                              .shortDescription
                                                          : '',
                                                  style: {
                                                    "body": Style(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                  },
                                                ),
                                              )
                                            : Container(),
                                        widget.table2.contentTypeId != 70
                                            ? SizedBox(
                                                height: 20.h,
                                              )
                                            : Container(),
                                        data?.tableofContent != ""
                                            ? Text(
                                                "Program Outline",
                                                style: TextStyle(
                                                    color: InsColor(appBloc)
                                                        .appTextColor,
                                                    fontSize: 17.h,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : widget.table2.tableofContent != ""
                                                ? Text(
                                                    "Program Outline",
                                                    style: TextStyle(
                                                        color: InsColor(appBloc)
                                                            .appTextColor,
                                                        fontSize: 17.h,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Container(),
                                        data?.tableofContent != ""
                                            ? SizedBox(
                                                height: 5.h,
                                              )
                                            : widget.table2.tableofContent != ""
                                                ? SizedBox(
                                                    height: 5.h,
                                                  )
                                                : Container(),
                                        data?.tableofContent != ""
                                            ? Container(
                                                padding: EdgeInsets.only(
                                                    right: 10.h),
                                                child: Html(
                                                  data: widget
                                                          .isFromNotification
                                                      ? widget.table2
                                                              .tableofContent ??
                                                          ''
                                                      : data?.tableofContent ??
                                                          '',
                                                  style: {
                                                    "body": Style(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))
                                                  },
                                                ),
                                              )
                                            : widget.table2.tableofContent != ""
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10.h),
                                                    child: Html(
                                                      data: widget
                                                              .isFromNotification
                                                          ? widget.table2
                                                                  .tableofContent ??
                                                              ''
                                                          : data
                                                              ?.tableofContent,
                                                    ),
                                                  )
                                                : Container(),
                                        data?.contentTypeId == 70
                                            ? Row(
                                                children: <Widget>[
                                                  const Icon(Icons.timelapse),
                                                  SizedBox(
                                                    width: 10.h,
                                                  ),
                                                  Flexible(
                                                      child: Text(
                                                          'From ${widget.isFromNotification ? widget.table2.eventStartDateTimeWithoutConvert : data?.eventStartDateTimeWithoutConvert} to ${widget.isFromNotification ? widget.table2.eventEndDateTimeTimeWithoutConvert : data?.eventEndDateTimeTimeWithoutConvert}'))
                                                ],
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          'Rate and Review',
                                          style: TextStyle(
                                              color: InsColor(appBloc)
                                                  .appTextColor,
                                              fontSize: 17.h,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            SmoothStarRating(
                                                allowHalfRating: false,
                                                onRatingChanged: (v) {},
                                                starCount: 5,
                                                rating: double.tryParse(widget
                                                            .isFromNotification
                                                        ? widget.table2
                                                                .totalRatings ??
                                                            '0.0'
                                                        : data?.totalRatings ??
                                                            0.0) ??
                                                    0.0,
                                                // filledIconData: Icons.blur_off,
                                                // halfFilledIconData: Icons.blur_on,
                                                color: Colors.orange,
                                                borderColor: Colors.orange,
                                                spacing: 3.h),
                                            SizedBox(
                                              width: 5.h,
                                            ),
                                            Text(
                                              widget.isFromNotification
                                                  ? widget.table2.ratingId
                                                  : data?.ratingId.toString() ??
                                                      '0.0',
                                              style: TextStyle(
                                                  color: InsColor(appBloc)
                                                      .appTextColor,
                                                  fontSize: 22.h,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('($ratingCount)',
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            itemCount: reviewList.length,
                                            itemBuilder: (context, pos) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.h),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    ClipOval(
                                                      child: Image.network(
                                                        ApiEndpoints
                                                                .strSiteUrl +
                                                            reviewList[pos]
                                                                .picture,
                                                        width: 25.h,
                                                        height: 25.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.h,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                reviewList[pos]
                                                                    .userName,
                                                                style: TextStyle(
                                                                    color: InsColor(
                                                                            appBloc)
                                                                        .appTextColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              SizedBox(
                                                                width: 2.h,
                                                              ),
                                                              SizedBox(
                                                                width: 5.h,
                                                              ),
                                                              SmoothStarRating(
                                                                  allowHalfRating:
                                                                      false,
                                                                  onRatingChanged:
                                                                      (v) {},
                                                                  starCount: 5,
                                                                  rating: reviewList[
                                                                          pos]
                                                                      .ratingId
                                                                      .toDouble(),
                                                                  size: 15.h,
                                                                  // filledIconData: Icons.blur_off,
                                                                  // halfFilledIconData: Icons.blur_on,
                                                                  color: Colors
                                                                      .orange,
                                                                  borderColor:
                                                                      Colors
                                                                          .orange,
                                                                  spacing: 0.0),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  reviewList[
                                                                          pos]
                                                                      .description,
                                                                  style:
                                                                      TextStyle(
                                                                    color: InsColor(
                                                                            appBloc)
                                                                        .appTextColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: (reviewList[pos]
                                                                              .ratingUserId
                                                                              .toString() ==
                                                                          strUserID)
                                                                      ? IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewScreen(widget.contentid, true, widget.detailsBloc)));
                                                                          },
                                                                          iconSize:
                                                                              20.h,
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.edit,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        )
                                                                      : Container()),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        ratingCount > reviewList.length
                                            ? Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      detailsBloc.add(
                                                          GetDetailsReviewEvent(
                                                              contentId: widget
                                                                  .contentid,
                                                              skippedRows:
                                                                  reviewList
                                                                      .length));
                                                    });
                                                  },
                                                  child: Text(
                                                    appBloc.localstr
                                                        .detailsButtonLoadmorebutton,
                                                    style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      widget.table2.contentTypeId == 70 &&
                                                  data?.eventScheduleType ==
                                                      1 &&
                                                  appBloc.uiSettingModel
                                                          .enableMultipleInstancesForEvent ==
                                                      'true' ||
                                              widget.table2.contentTypeId ==
                                                      70 &&
                                                  data?.eventScheduleType ==
                                                      2 &&
                                                  appBloc.uiSettingModel
                                                          .enableMultipleInstancesForEvent ==
                                                      'true'
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: Text(
                                                'Teaching Schedule',
                                                style: TextStyle(
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                          : Container(),
                                      menu0
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50.h,
                                              child: MaterialButton(
                                                disabledColor: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                    .withOpacity(0.5),
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                        IconDataSolid(int.parse(
                                                            '0xf06e')),
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                                    SizedBox(
                                                      width: 5.h,
                                                    ),
                                                    Text(
                                                        appBloc.localstr
                                                            .catalogActionsheetViewoption,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  if (data?.isaddtomylearninglogo ==
                                                          1 ||
                                                      isAddtomylearning) {
                                                    // launchCourse(
                                                    //     widget.table2,
                                                    //     context);
                                                  } else {
                                                    // launchCoursePreview(
                                                    //     widget.table2,
                                                    //     context);
                                                  }
                                                },
                                              ),
                                            )
                                          : Container(),
                                      menu1
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50.h,
                                              child: MaterialButton(
                                                disabledColor: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                    .withOpacity(0.5),
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.add_circle,
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                                    SizedBox(
                                                      width: 5.h,
                                                    ),
                                                    Text(
                                                        appBloc.localstr
                                                            .catalogActionsheetAddtomylearningoption,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    loaderAddtomylearning =
                                                        false;
                                                  });
                                                  // catalogBloc.add(
                                                  //     AddToMyLearningEvent(
                                                  //         contentId: widget
                                                  //             .table2
                                                  //             .contentid));

                                                  if (data?.siteUserId !=
                                                          null &&
                                                      data?.siteUserId !=
                                                          "-1") {
                                                    // catalogBloc.add(
                                                    //     AddToMyLearningEvent(
                                                    //         contentId: widget
                                                    //             .table2
                                                    //             .contentId,
                                                    //         table2: widget
                                                    //             .table2));
                                                  } else {
                                                    flutterToast.showToast(
                                                      child: CommonToast(
                                                          displaymsg:
                                                              'Not a member of ${data?.siteName ?? ''}'),
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      toastDuration:
                                                          const Duration(seconds: 2),
                                                    );
                                                    // checkUserLogin(
                                                    //     widget.table2);
                                                  }
                                                },
                                              ),
                                            )
                                          : Container(),
                                      menu2
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50.h,
                                              child: MaterialButton(
                                                disabledColor: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                    .withOpacity(0.5),
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                        IconDataSolid(int.parse(
                                                            '0xf144')),
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                                    SizedBox(
                                                      width: 5.h,
                                                    ),
                                                    Text(
                                                        appBloc.localstr
                                                            .catalogActionsheetBuyoption,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  flutterToast.showToast(
                                                    child: CommonToast(
                                                        displaymsg:
                                                            'Work in Progress'),
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    toastDuration:
                                                        const Duration(seconds: 2),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                      widget.table2.contentTypeId == 70 &&
                                                  data?.eventScheduleType ==
                                                      1 &&
                                                  appBloc.uiSettingModel
                                                          .enableMultipleInstancesForEvent ==
                                                      'true' ||
                                              widget.table2.contentTypeId ==
                                                      70 &&
                                                  data?.eventScheduleType ==
                                                      2 &&
                                                  appBloc.uiSettingModel
                                                          .enableMultipleInstancesForEvent ==
                                                      'true'
                                          ? scheduleWidget()
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      /*(state.status == Status.LOADING || !loaderAddtomylearning || !loaderEnroll)
                      ? Center(
                          child: AbsorbPointer(
                            child: SpinKitCircle(
                              color: Colors.grey,
                              size: 70.h,
                            ),
                          ),
                        )
                      : Container()*/
                    ],
                  );
                }
              });
        },
      ),
    );
  }

  void getUserId() async {
    strUserID = await sharePrefGetString(sharedPref_userid);
  }

  bool isValidString(String val) {
    //print('validstrinh $val');
    if (val == null || val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }

  void getDetailsApiCall(String contentid) {
    MyLearningDetailsRequest detailsRequest = MyLearningDetailsRequest();
    detailsRequest.locale = 'en-us';
    detailsRequest.contentId = widget.contentid;
    detailsRequest.metadata = '1';
    detailsRequest.intUserId = strUserID;
    detailsRequest.iCms = false;
    detailsRequest.componentId = '';
    detailsRequest.siteId = ApiEndpoints.siteID;
    detailsRequest.eRitems = '';
    detailsRequest.detailsCompId = '107';
    detailsRequest.detailsCompInsId = '3291';
    detailsRequest.componentDetailsProperties = '';
    detailsRequest.hideAdd = 'false';
    detailsRequest.objectTypeId = '-1';
    detailsRequest.scoId = '';
    detailsRequest.subscribeErc = false;

    detailsBloc
        .add(GetLearningDetails(myLearningDetailsRequest: detailsRequest));

    print("om--------${detailsRequest.toString()}");
  }

  String removeAllHtmlTags(String htmlText) {
    String parsedString = "";

    if (htmlText != null) {
      var document = parse(htmlText);

      parsedString =
          parse(document.body?.text ?? "").documentElement?.text ?? "";
    }

    return parsedString;
  }

  _settingMyCourceBottomSheet(
      context, MyLearningDetailsResponse table2, int i) {
//    print('bottomsheetobjit ${table2.objecttypeid}');

    menu0 = false;
    menu1 = false;

    if (table2.isaddtomylearninglogo == 1 || isAddtomylearning) {
      menu0 = true;
      menu1 = false;

      if (table2.contentTypeId == "70") {
        int relatedCount = int.parse(table2.relatedContentLink.toString());
        if (relatedCount > 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
      }
    } else {
      if (table2.viewType == 1) {
        if (table2.isaddtomylearninglogo == 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
        menu1 = true;
      } else if (table2.viewType == 2) {
        menu0 = false;
        menu1 = true;
      } else if (table2.viewType == 3) {
        menu2 = true;
        menu1 = false;
      } else if (table2.viewType == 5) {
        // for ditrect view
        menu0 = true;
        menu1 = false;

        if (table2.isaddtomylearninglogo == 0) {
          menu1 = true;
        }
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
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetViewoption,
                          iconData: IconDataSolid(int.parse('0xf144')),
                          onTap: () {
                            if (table2.isaddtomylearninglogo == 1 ||
                                isAddtomylearning) {
                              // launchCourse(widget.table2, context);
                              //aman
                            } else {
                              //launchCoursePreview(widget.table2, context);
                              //qaman
                            }
                          },
                        )
                      : Container(),
                  menu1
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr
                              .catalogActionsheetAddtomylearningoption,
                          iconData: Icons.add_circle,
                          onTap: () {
                            setState(() {
                              loaderAddtomylearning = true;
                            });
                            if (table2.siteUserId != null &&
                                table2.siteUserId != "-1") {
                              // catalogBloc.add(AddToMyLearningEvent(
                              //     contentId: table2?.contentId,
                              //     table2: table2));
                            } else {
                              flutterToast.showToast(
                                child: CommonToast(
                                    displaymsg:
                                        'Not a member of ${table2.siteName}'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 2),
                              );
                              // checkUserLogin(table2);
                            }
                          },
                        )
                      : Container(),
                  menu2
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetBuyoption,
                          iconData: IconDataSolid(int.parse('0xf144')),
                          onTap: () {
                            flutterToast.showToast(
                              child:
                                  CommonToast(displaymsg: 'Work in Progress'),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: const Duration(seconds: 2),
                            );
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  _settingMyCourceBottomSheet1(context, CatalogDetailsResponse table2, int i) {
//    print('bottomsheetobjit ${table2.objecttypeid}');

    menu0 = false;
    menu1 = false;

    if (table2.isaddtomylearninglogo == null || isAddtomylearning) {
      menu0 = true;
      menu1 = false;

      if (table2.contentTypeId == "70") {
        int relatedCount = int.parse(table2.relatedContentLink.toString());
        if (relatedCount > 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
      } else {
        if (table2.viewType == 1) {
          if (table2.isaddtomylearninglogo == 0) {
            menu0 = true;
          } else {
            menu0 = false;
          }
          menu1 = true;
        } else if (table2.viewType == 2) {
          menu0 = false;
          menu1 = true;
        } else if (table2.viewType == 3) {
          menu2 = true;
          menu1 = false;
        } else if (table2.viewType == 5) {
          // for ditrect view
          menu0 = true;
          menu1 = false;

          if (table2.isaddtomylearninglogo == 0) {
            menu1 = true;
          }
        }
      }

      if (table2.isaddtomylearninglogo == 1 || isAddtomylearning) {
        menu0 = true;
        menu1 = false;

        if (table2.contentTypeId == "70") {
          int relatedCount = int.parse(table2.relatedContentLink.toString());
          if (relatedCount > 0) {
            menu0 = true;
          } else {
            menu0 = false;
          }
        }
      } else {
        if (table2.viewType == 1) {
          if (table2.isaddtomylearninglogo == 0) {
            menu0 = true;
          } else {
            menu0 = false;
          }
          menu1 = true;
        } else if (table2.viewType == 2) {
          menu0 = false;
          menu1 = true;
        } else if (table2.viewType == 3) {
          menu2 = true;
          menu1 = false;
        } else if (table2.viewType == 5) {
          // for ditrect view
          menu0 = true;
          menu1 = false;

          if (table2.isaddtomylearninglogo == 0) {
            menu1 = true;
          }
        } else if (table2.isaddtomylearninglogo == null &&
            table2.viewType == 2) {
          menu0 = true;
        }
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
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetViewoption,
                          iconData: IconDataSolid(int.parse('0xf144')),
                          onTap: () {
                            if (table2.isaddtomylearninglogo == 1 ||
                                isAddtomylearning) {
                              // launchCourse(widget.table2, context);
                              //aman
                            } else {
                              //launchCoursePreview(widget.table2, context);
                              //qaman
                            }
                          },
                        )
                      : Container(),
                  menu1
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetAddtomylearningoption,
                          iconData: Icons.add_circle,
                          onTap: () {
                            setState(() {
                              loaderAddtomylearning = true;
                            });
                            if (table2.siteUserId != null &&
                                table2.siteUserId != "-1") {
                              // catalogBloc.add(AddToMyLearningEvent(
                              //     contentId: table2?.contentId,
                              //     table2: table2));
                            } else {
                              flutterToast.showToast(
                                child: CommonToast(
                                    displaymsg:
                                        'Not a member of ${table2.siteName}'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 2),
                              );
                              // checkUserLogin(table2);
                            }
                          },
                        )
                      : Container(),
                  menu2
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetBuyoption,
                          iconData: IconDataSolid(int.parse('0xf144')),
                          onTap: () {
                            flutterToast.showToast(
                              child:
                                  CommonToast(displaymsg: 'Work in Progress'),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: const Duration(seconds: 2),
                            );
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  Future<void> launchCoursePreview(
      DummyMyCatelogResponseTable2 table2, BuildContext context) async {
    courseLaunchCatalog = GotoCourseLaunchCatalog(context, table2, false,
        appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
    String url = await courseLaunchCatalog!.getCourseUrl();
    if (url.isNotEmpty) {
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(url,table2)));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InAppWebCourseLaunch(url, table2)));
    }
  }

  Future<void> launchCourse(
      DummyMyCatelogResponseTable2 table2, BuildContext context) async {
    print('helllllllllloooooo');

    /// Need Some value
    if (table2.objecttypeid == 102) {
      executeXAPICourse(table2);
    }

    if (table2.objecttypeid == 10 && table2.bit5) {
      // Need to open EventTrackListTabsActivity

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventTrackList(
                table2,
                true,
                [],
              )));
    } else {
      courseLaunch = GotoCourseLaunch(context, table2, false,
          appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
      String url = await courseLaunch!.getCourseUrl();

      if (url.isNotEmpty) {
        if (table2.objecttypeid == 26) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AdvancedWebCourseLaunch(url, table2.name)));
        } else {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(url, table2)));
        }
      }
    }
  }

  Future<void> executeXAPICourse(
      DummyMyCatelogResponseTable2 learningModel) async {
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String paramsString = "strContentID=" +
        learningModel.contentid +
        "&UserID=" +
        strUserID +
        "&SiteID=" +
        strSiteID +
        "&SCOID=" +
        learningModel.scoid.toString() +
        "&CanTrack=true";

    String url = webApiUrl + "CourseTracking/TrackLRSStatement?" + paramsString;

    ApiResponse? apiResponse = await generalRepository?.executeXAPICourse(url);
  }

  checkUserLogin(DummyMyCatelogResponseTable2 table2) async {
    String userId = await sharePrefGetString(sharedPref_LoginUserID);
    String password = await sharePrefGetString(sharedPref_LoginPassword);

    catalogBloc.add(LoginSubsiteEvent(
        table2: table2,
        email: userId,
        password: password,
        localStr: appBloc.localstr,
        subSiteId: '${table2.siteid}',
        subSiteUrl: table2.siteurl));
  }

  checkSubsiteLogding(String response, DummyMyCatelogResponseTable2 table2) {
    SubsiteLoginResponse subsiteLoginResponse =
        SubsiteLoginResponse(failedUserLogin: [], successFullUserLogin: []);
    Map<String, dynamic> userloginAry = jsonDecode(response);
    try {
      String succesMessage =
          '${appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto}' +
              '${appBloc.localstr.eventsAlertsubtitleYouhavesuccessfullyjoinedcommunity}' +
              table2.sitename;

      if (userloginAry.containsKey("faileduserlogin")) {
        subsiteLoginResponse = subsiteLoginResponse =
            loginFaildeResponseFromJson(response.toString());

        subsiteLoginResponse.failedUserLogin[0].userstatus == 'Login Failed'
            ? flutterToast.showToast(
                child:
                    CommonToast(displaymsg: 'Login Failed ${table2.sitename}'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 4),
              )
            : flutterToast.showToast(
                child: CommonToast(displaymsg: 'Pending Registration'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 4),
              );
      } else if (userloginAry.containsKey("successfulluserlogin")) {
        subsiteLoginResponse = subsiteLoginResponse =
            loginSuccessResponseFromJson(response.toString());

        flutterToast.showToast(
          child: CommonToast(displaymsg: succesMessage),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 4),
        );
        table2.userid =
            '${subsiteLoginResponse.successFullUserLogin[0].userid}';
        catalogBloc.add(
            AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget scheduleWidget() {
    return BlocConsumer<CatalogBloc, CatalogState>(
      bloc: catalogBloc,
      listener: (context, state) {
        if (state is GetScheduleDataState) {
          if (state.status == Status.COMPLETED) {
            setState(() {
              loaderEnroll = false;
            });
          }
        }
      },
      builder: (context, state) {
        return Container(
            child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: catalogBloc.eventEnrollmentResponse.courseList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => {},
              child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                  child: Card(
                    elevation: 4,
                    child: Container(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(5)),
                        child: Expanded(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0),
                                        child: Text(
                                          DateFormat('EEEE, d MMM').format(
                                              DateFormat('dd/MM/yyyy HH:mm')
                                                  .parse(catalogBloc
                                                      .eventEnrollmentResponse
                                                      .courseList[index]
                                                      .eventStartDateTime)),
                                          style: TextStyle(
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 5.0),
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 5.0),
                                            child: Text(
                                              catalogBloc
                                                  .eventEnrollmentResponse
                                                  .courseList[index]
                                                  .contentType,
                                              style:
                                                  const TextStyle(fontSize: 10.0),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Text(
                                              '(' +
                                                  DateFormat('h:mm a').format(DateFormat(
                                                          'dd/MM/yyyy HH:mm')
                                                      .parse(catalogBloc
                                                          .eventEnrollmentResponse
                                                          .courseList[index]
                                                          .eventStartDateTime)) +
                                                  '-' +
                                                  DateFormat('h:mm a').format(
                                                      DateFormat(
                                                              'dd/MM/yyyy HH:mm')
                                                          .parse(catalogBloc
                                                              .eventEnrollmentResponse
                                                              .courseList[index]
                                                              .eventEndDateTime)) +
                                                  ')',
                                              style:
                                                  const TextStyle(fontSize: 10.0),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 10.0),
                                            child: Text(
                                              catalogBloc
                                                  .eventEnrollmentResponse
                                                  .courseList[index]
                                                  .title,
                                              style: TextStyle(
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 5.0),
                                            child: Text(
                                              catalogBloc
                                                  .eventEnrollmentResponse
                                                  .courseList[index]
                                                  .shortDescription,
                                              style:
                                                  const TextStyle(fontSize: 10.0),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 5.0),
                                            child: Text(
                                              catalogBloc
                                                      .eventEnrollmentResponse
                                                      .courseList[index]
                                                      .duration +
                                                  ' by ' +
                                                  catalogBloc
                                                      .eventEnrollmentResponse
                                                      .courseList[index]
                                                      .presenterDisplayName,
                                              style:
                                                  const TextStyle(fontSize: 10.0),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 5.0),
                                            child: Text(
                                              catalogBloc
                                                  .eventEnrollmentResponse
                                                  .courseList[index]
                                                  .locationName,
                                              style:
                                                  const TextStyle(fontSize: 10.0),
                                            )),
                                        Visibility(
                                            visible: catalogBloc
                                                        .eventEnrollmentResponse
                                                        .courseList[index]
                                                        .isContentEnrolled ==
                                                    '1'
                                                ? false
                                                : true,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              //height: 50.h,
                                              child: MaterialButton(
                                                disabledColor: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                    .withOpacity(0.5),
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text('Enroll',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  print('ddddd : ' +
                                                      widget.nativeModel
                                                          .componentId);
                                                  setState(() {
                                                    loaderEnroll = true;
                                                  });
                                                  catalogBloc.add(AddEnrollEvent(
                                                      selectedContent: catalogBloc
                                                          .eventEnrollmentResponse
                                                          .courseList[index]
                                                          .addLink,
                                                      componentID: int.parse(
                                                          widget.nativeModel
                                                              .componentId),
                                                      componentInsID: int.parse(
                                                          widget.nativeModel
                                                              .repositoryId),
                                                      additionalParams: '',
                                                      targetDate: ''));
                                                  refresh();
                                                },
                                              ),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                top: 5.0,
                                                bottom: 5.0),
                                            child: Text(
                                              catalogBloc
                                                      .eventEnrollmentResponse
                                                      .courseList[index]
                                                      .availableSeats +
                                                  ' Seats Remain',
                                              style: TextStyle(
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ],
                        ))),
                  )),
            );
          },
        ));
      },
    );
  }

  refresh() {
    if (widget.table2.contentTypeId == 70 &&
        widget.table2.eventScheduleType == 1 &&
        appBloc.uiSettingModel.enableMultipleInstancesForEvent == 'true') {
      catalogBloc.add(GetScheduleEvent(
          eventID: widget.contentid,
          multiInstanceEventEnroll: '',
          multiLocation: ''));
    } else if (widget.table2.contentTypeId == 70 &&
        widget.table2.eventScheduleType == 2 &&
        appBloc.uiSettingModel.enableMultipleInstancesForEvent == 'true') {
      catalogBloc.add(GetScheduleEvent(
          eventID: widget.table2.contentId,
          multiInstanceEventEnroll: '',
          multiLocation: ''));
    }
  }

  void _scrollToEnd() {
    var scrollPosition = scrollController.position;
    scrollController.jumpTo(scrollPosition.maxScrollExtent);
    if (!scrollController.hasClients) {
      return;
    }

    if (scrollPosition.maxScrollExtent > scrollPosition.minScrollExtent) {
      scrollController.animateTo(
        scrollPosition.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }
}
