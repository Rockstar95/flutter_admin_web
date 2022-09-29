import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';

import '../../configs/constants.dart';

class ProgressReport extends StatefulWidget {
  final DummyMyCatelogResponseTable2 myLearningModel;
  final MyLearningDetailsBloc detailsBloc;
  final String trackId, postion;

  const ProgressReport(
    this.myLearningModel,
    this.detailsBloc,
    this.trackId,
    this.postion,
  );

  @override
  State<ProgressReport> createState() => _ProgressReportState();
}

class _ProgressReportState extends State<ProgressReport> with SingleTickerProviderStateMixin {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late TabController _tabController;
  List<Tab> tabList = [];
  List<EditRating> reviewList = [];
  bool isReviewLoading = true;
  String contentIconPath = '';

  @override
  void initState() {
    super.initState();
    myLearningBloc.add(GetProgresReportEvent(
        objectTypeID: widget.myLearningModel.objecttypeid.toString(),
        contentID: widget.myLearningModel.contentid,
        trackID: widget.trackId,
        postion: widget.postion));
    widget.detailsBloc.userRatingDetails.clear();

    tabList.add(new Tab(
      text: appBloc.localstr.detailsHeaderReviewtitlelabel,
    ));
    tabList.add(new Tab(
      text: appBloc.localstr.detailsTablesectionHeaderreport,
    ));
    _tabController = new TabController(length: tabList.length, vsync: this);

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
  }

  @override
  Widget build(BuildContext context) {
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    if (widget.myLearningModel.thumbnailimagepath != null) {
      imgUrl = widget.myLearningModel.thumbnailimagepath.startsWith('http')
          ? widget.myLearningModel.thumbnailimagepath.trim()
          : widget.myLearningModel.siteurl.trim() +
              widget.myLearningModel.thumbnailimagepath.trim();
    }

    //basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    print("om ${widget.myLearningModel.toString()}");
    print("om ${widget.myLearningModel.siteurl}");

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          appBloc.localstr.mylearningHeaderReporttitlelabel,
          style: TextStyle(
              fontSize: 18,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: SingleChildScrollView(
          child: BlocConsumer<MyLearningBloc, MyLearningState>(
            bloc: myLearningBloc,
            listener: (context, state) {
              if (state.status == Status.COMPLETED && state is GetProgresReportState) {
                widget.detailsBloc.add(GetDetailsReviewEvent(
                    contentId: widget.myLearningModel.contentid,
                    skippedRows: 0));
              }
            },
            builder: (context, state) {
              print("Status:${state.status}");
              if (state.status == Status.LOADING && state is GetProgresReportState) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  child: Center(
                    child: AbsorbPointer(
                      child: AppConstants().getLoaderWidget(iconSize: 70)
                    ),
                  ),
                );
              }
              else if (state.status == Status.COMPLETED && state is GetProgresReportState) {
                return BlocConsumer<MyLearningDetailsBloc, MyLearningDetailsState>(
                  bloc: widget.detailsBloc,
                  listener: (context, state) {
                    if (state.status == Status.COMPLETED) {
                      if (state is GetReviewsDetailstate) {
                        reviewList = widget.detailsBloc.userRatingDetails;
                        print('reviewlistdata $reviewList');
                        setState(() {
                          isReviewLoading = false;
                        });
                      }
                    }
                  },
                  builder: (context, state) {
                    Color statuscolor = Color(0xff5750da);

                    if (myLearningBloc.getSummaryDatalist[0].result.toString().contains("Completed")) {
                      statuscolor = Color(0xff4ad963);
                    }
                    else if (myLearningBloc.getSummaryDatalist[0].result.toString() == "Not Started") {
                      statuscolor = Color(0xfffe2c53);
                    }
                    else if (myLearningBloc.getSummaryDatalist[0].result.toString() == "In Progress") {
                      statuscolor = Color(0xffff9503);
                    }
                    String percentageCompletedStr = myLearningBloc.getSummaryDatalist[0].percentageCompleted;
                    if (percentageCompletedStr == "" || percentageCompletedStr == null) {
                      percentageCompletedStr = "0.0";
                    }
                    String scoreStr = myLearningBloc.getSummaryDatalist[0].score;

                    if (scoreStr == "" || scoreStr == null) {
                      scoreStr = "0.0";
                    }

                    print('reporturl  ${widget.myLearningModel.imageData}');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: ScreenUtil().setHeight(kCellThumbHeight),
                              child: CachedNetworkImage(
                                imageUrl: imgUrl,
                                width: width,
                                //placeholder: (context, url) => CircularProgressIndicator(),
                                placeholder: (context, url) => Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    child: Center(
                                        heightFactor: ScreenUtil().setWidth(20),
                                        widthFactor: ScreenUtil().setWidth(20),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.orange),
                                        ))),
                                errorWidget: (context, url, error) => Container(
                                  child: Center(child: Icon(Icons.error)),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                bottom: 15,
                                left: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF007BFF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(5),
                                      bottom: ScreenUtil().setWidth(5),
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10)),
                                  child: Text(
                                    myLearningBloc.getSummaryDatalist[0].result,
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
                                          )))),
                            )
                          ],
                        ),
                        LinearProgressIndicator(
                          value: double.parse(percentageCompletedStr) / 100,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(statuscolor),
                          backgroundColor: Colors.grey,
                        ),
                        Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          myLearningBloc.getSummaryDatalist[0]
                                              .contentName,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.myLearningModel.objecttypeid == 70
                                        ? (widget.myLearningModel.presenter !=
                                                null)
                                            ? widget.myLearningModel.presenter
                                            : ""
                                        : (widget.myLearningModel
                                                    .authordisplayname !=
                                                null)
                                            ? widget.myLearningModel
                                                .authordisplayname
                                            : "",
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
                              Row(
                                children: <Widget>[
                                  SmoothStarRating(
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
                                  SizedBox(
                                    width: ScreenUtil().setWidth(10),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Text(
                                widget.myLearningModel.shortdescription,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.5)),
                              ),
                              // SizedBox(
                              //   height: ScreenUtil().setHeight(10),
                              // ),
                            ],
                          ),
                        ),
                        // widget.myLearningModel.description != null
                        //     ? Padding(
                        //         padding: const EdgeInsets.all(10.0),
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             color: Colors.black,
                        //             borderRadius: BorderRadius.circular(5),
                        //           ),
                        //           padding: EdgeInsets.only(
                        //               top: ScreenUtil().setWidth(5),
                        //               bottom: ScreenUtil().setWidth(5),
                        //               left: ScreenUtil().setWidth(10),
                        //               right: ScreenUtil().setWidth(10)),
                        //           child: Text(
                        //           "  widget.myLearningModel.description",
                        //             style: TextStyle(
                        //                 fontSize: ScreenUtil().setSp(10),
                        //                 color: Colors.white),
                        //           ),
                        //         ),
                        //       )
                        //     : Container(),
                        Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Statistics",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(20),
                              ),
                              Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      SizedBox(
                                        width: ScreenUtil().setWidth(100),
                                        height: ScreenUtil().setWidth(100),
                                        child: CircularProgressIndicator(
                                          strokeWidth: ScreenUtil().setWidth(7),
                                          //value: 0.4,
                                          value: double.parse(scoreStr) / 100,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey),
                                          backgroundColor: Colors.grey,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  appBloc.localstr
                                                      .myprogressreportLabelAveragescorelabel,
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(10),
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                ),
                                                Text(
                                                  "${double.parse(percentageCompletedStr).round()}%",
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(20),
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(40),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Accessed",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(10),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            ),
                                            Text(
                                              myLearningBloc.getSummaryDatalist[0].numberofTimesAccessedinthisperiod.toString(),
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(10),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Attempts",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(10),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            ),
                                            Text(
                                              myLearningBloc.getSummaryDatalist[0].numberofattemptsinthisperiod.isNotEmpty ? myLearningBloc.getSummaryDatalist[0].numberofattemptsinthisperiod : '0',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(10),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Days",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(10),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            ),
                                            Text(
                                              myLearningBloc.getSummaryDatalist[0].numberofattemptsinthisperiod.isNotEmpty ? myLearningBloc.getSummaryDatalist[0].numberofattemptsinthisperiod : "0",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(10),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Started",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(13),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    myLearningBloc
                                        .getSummaryDatalist[0].dateStarted
                                        .split(" ")[0],
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(10),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Time Spent",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(13),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    myLearningBloc
                                        .getSummaryDatalist[0].totalTimeSpent,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(10),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Completed",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(13),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    myLearningBloc
                                        .getSummaryDatalist[0].dateCompleted
                                        .split(" ")[0],
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(10),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Container(
                          decoration: new BoxDecoration(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          ),
                          child: new TabBar(
                              controller: _tabController,
                              indicatorColor: Color(int.parse("0xFF1D293F")),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                              tabs: tabList),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height - 150,
                          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              reviewList.length != 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: reviewList.length,
                                      itemBuilder: (context, pos) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ClipOval(
                                                child: Image.network(
                                                  ApiEndpoints.strSiteUrl +
                                                      reviewList[pos].picture,
                                                  width: 25.h,
                                                  height: 25.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      SizedBox(
                                                    width: 25.h,
                                                    height: 25.h,
                                                    child: Icon(Icons.info),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.h,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          reviewList[pos]
                                                              .userName,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 2.h,
                                                        ),
                                                        SizedBox(
                                                          width: 5.h,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              SmoothStarRating(
                                                                  allowHalfRating:
                                                                      false,
                                                                  onRatingChanged:
                                                                      (v) {},
                                                                  starCount: 5,
                                                                  rating: 3,
                                                                  size: 15.h,
                                                                  // filledIconData: Icons.blur_off,
                                                                  // halfFilledIconData: Icons.blur_on,
                                                                  color: Colors
                                                                      .orange,
                                                                  borderColor:
                                                                      Colors
                                                                          .orange,
                                                                  spacing: 0.0),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      reviewList[pos]
                                                          .description,
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                  : isReviewLoading
                                      ? AbsorbPointer(
                                          child: AppConstants().getLoaderWidget(iconSize: 70)
                                        )
                                      : Container(
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
                              getReportTab(
                                  widget.myLearningModel.objecttypeid
                                      .toString(),
                                  myLearningBloc,
                                  appBloc,
                                  context,
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              }
              else {
                return Container(
                  child: Center(
                    child: Text(
                        appBloc.localstr.commoncomponentLabelNodatalabel,
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 24)),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget getReportTab(String objectId, MyLearningBloc myLearningBloc, AppBloc appBloc, BuildContext context) {
  print(" -objectId --------$objectId");
  switch (objectId) {
    case "10":
      return myLearningBloc.getLearaningProgressDataResponse.table.length ==
                  0 ||
              myLearningBloc.getLearaningProgressDataResponse.table == null
          ? Container(
              child: Center(
                child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 24)),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount:
                  myLearningBloc.getLearaningProgressDataResponse.table.length,
              itemBuilder: (context, pos) {
                return ExpansionTile(
                  title: Text(
                      myLearningBloc.getLearaningProgressDataResponse.table[pos]
                          .contentItemTitle,
                      style: TextStyle(color: InsColor(appBloc).appBtnBgColor)),
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Type :- ${myLearningBloc.getLearaningProgressDataResponse.table[pos].type}",
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                            ),
                            Text(
                                "Progress :- ${myLearningBloc.getLearaningProgressDataResponse.table[pos].progress}",
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor)),
                            Text(
                                "Status :- ${myLearningBloc.getLearaningProgressDataResponse.table[pos].status}",
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor)),
                            Text(
                                "Score :- ${myLearningBloc.getLearaningProgressDataResponse.table[pos].score}",
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor)),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              });
    case "9":
      return myLearningBloc.getAssetProgressDataResponse.table.length == 0 ||
              myLearningBloc.getAssetProgressDataResponse.table == null
          ? Container(
              child: Center(
                child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                    style: TextStyle(
                        color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}",
                        )),
                        fontSize: 24)),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount:
                  myLearningBloc.getAssetProgressDataResponse.table.length + 1,
              itemBuilder: (context, pos) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: pos == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Page/Question Title",
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Status",
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${myLearningBloc.getAssetProgressDataResponse.table[pos - 1].questionTitle}",
                                style: TextStyle(
                                  color: InsColor(appBloc).appTextColor,
                                ),
                              ),
                            ),
                            Text(
                              "${myLearningBloc.getAssetProgressDataResponse.table[pos - 1].status}",
                              style: TextStyle(
                                color: InsColor(appBloc).appTextColor,
                              ),
                            ),
                          ],
                        ),
                );
              });
    case "8":
      return myLearningBloc
                      .getLearningModuleProgressDataResponse.table.length ==
                  0 ||
              myLearningBloc.getLearningModuleProgressDataResponse.table == null
          ? Container(
              child: Center(
                child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 24)),
              ),
            )
          : ListView.builder(
              primary: false,
              itemCount: myLearningBloc
                      .getLearningModuleProgressDataResponse.table.length +
                  1,
              itemBuilder: (context, pos) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: pos == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Page/Question Title",
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Status",
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${myLearningBloc.getLearningModuleProgressDataResponse.table[pos - 1].questionTitle}",
                                style: TextStyle(
                                  color: InsColor(appBloc).appTextColor,
                                ),
                              ),
                            ),
                            Text(
                                "${myLearningBloc.getLearningModuleProgressDataResponse.table[pos - 1].status}",
                                style: TextStyle(
                                  color: InsColor(appBloc).appTextColor,
                                ))
                          ],
                        ),
                );
              });
    default:
      return Container(
        child: Center(
          child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  fontSize: 24)),
        ),
      );
  }
}
