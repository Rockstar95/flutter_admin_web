import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/bloc/progress_report_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/event/progress_report_event.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/model/progress_report_graph_response.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/state/progress_report_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/fade_animation.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/progressReport/progress_report_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/MyLearning/view_certificate.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/progressReport/course_summary.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressReportGraph extends StatefulWidget {
  final NativeMenuModel nativeMenuModel;

  const ProgressReportGraph({required this.nativeMenuModel});

  @override
  _ProgressReportState createState() => _ProgressReportState();
}

class _ProgressReportState extends State<ProgressReportGraph> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List<Tab> tabList = [];

  late TabController _tabController;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late ProgressReportBloc progressReportBloc;
  late MyLearningDetailsBloc detailsBloc;
  late FToast flutterToast;
  late TooltipBehavior tooltip;
  Map<String, String> filterMenus = {};
  bool isAllowTitle = false,
      isAllowStatus = false,
      isAllowContent = false,
      isAverageScore = false,
      isContentTile = false,
      isStatus = false,
      isModule = false,
      isDateStarted = false,
      isDateCompleted = false,
      isCmeCredits = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterMenus = new Map();
    filterMenus = getConditionsValue(widget.nativeMenuModel.conditions);

    isAllowGroupBy();

    detailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());

    tooltip = TooltipBehavior(enable: true);
    tabList.add(new Tab(
      text: 'Summary',
    ));
    tabList.add(new Tab(
      text: "Content",
    ));
    _tabController = new TabController(length: tabList.length, vsync: this);

    progressReportBloc = ProgressReportBloc(
        progressReportRepository: ProgressReportRepositoryBuilder.repository());

    refresh(0);

    // print("%%%% : "+appBloc.isAllowGroupBy.toString());
  }

  @override
  void didUpdateWidget(covariant ProgressReportGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration(seconds: 0)).then((value) {
      filterMenus = new Map();
      filterMenus = getConditionsValue(widget.nativeMenuModel.conditions);
      updateGroupValue();
      isAllowGroupBy();
    });
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return Scaffold(
      //floatingActionButton: CustomFloatingAction(),
      key: _scaffoldkey,
      body: Container(
        color: AppColors.getAppBGColor(),
        child: tabWidget(context, itemWidth, itemHeight),
      ),
    );
  }

  Widget tabWidget(BuildContext context, double itemWidth, double itemHeight) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(bottom: 3),
            decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black45,blurRadius: 1)

              ]
              // Color(int.parse(
              //     "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            ),
            child: new TabBar(

                controller: _tabController,
                indicatorColor: Color(int.parse("0xFF1D293F")),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.getAppTextColor(),
                // Color(int.parse(
                //     "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                tabs: tabList),
          ),
          Expanded(
            child: Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(child: progressReportWidget()),
                  coursesWidget()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget progressReportWidget() {
    return BlocConsumer<ProgressReportBloc, ProgressReportState>(
      bloc: progressReportBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
          if (state.message == '401') {
            AppDirectory.sessionTimeOut(context);
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && progressReportBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.0,
              ),
            ),
          );
        }
        else if (progressReportBloc.progressReportGraphResponse.length == 0) {
          return noDataFound(true);
        }
        else {
          int totalContentCount = 0;
          progressReportBloc.contentCount.map((e) => e.contentCount).forEach((int count) {
            totalContentCount += count;
          });

          int totalStatusCount = 0;
          progressReportBloc.statusContentCount.map((e) => e.contentCount).forEach((int count) {
            totalStatusCount += count;
          });
          //MyPrint.printOnConsole("totalCount:${totalContentCount}");

          return new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Visibility(
                  visible: isAllowContent ? false : true,
                  child: Row(
                    children: [
                      Text(
                        'Contents ',
                        style: TextStyle(
                            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        progressReportBloc.progressReportGraphResponse[0].parentData.length.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Visibility(
                    visible: isAllowTitle ? false : true,
                    child: Text(
                      'Content Types',
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                      ),
                    )),
              ),
              Visibility(
                  visible: isAllowTitle ? false : true,
                  child: Wrap(
                    children: [
                      new Container(
                        // height: 400,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        child: SfCircularChart(
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            tooltipPosition: TooltipPosition.pointer,
                          ),
                          legend: Legend(
                            isVisible: true,
                            textStyle: TextStyle(
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              fontSize: 12.0,
                            ),
                            overflowMode: LegendItemOverflowMode.wrap,
                            height: '500',
                            position: LegendPosition.bottom,
                          ),
                          //  palette: <Color>[Color.fromARGB(255,122, 209, 207), Color.fromARGB(255, 232, 234, 179), Colors.orange, Colors.redAccent, Colors.blueAccent, Colors.teal],
                          series: <CircularSeries>[
                            // Render pie chart
                            PieSeries<ContentCountData, String>(
                              enableTooltip: true,
                              dataSource: progressReportBloc.contentCount,
                              pointColorMapper: (ContentCountData data, _) => data.color,
                              xValueMapper: (ContentCountData data, _) => data.contentType,
                              yValueMapper: (ContentCountData data, _) => data.contentCount,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                                  String text = "";
                                  if(data is ContentCountData) {
                                    ContentCountData contentCountData = data;
                                    text = "${((contentCountData.contentCount/totalContentCount) * 100).toStringAsFixed(0)} %";
                                  }

                                  return Text(
                                    "$text",
                                    style: TextStyle(
                                      fontSize: 8.h,
                                      color: Colors.black,
                                    )
                                  );
                                },
                                textStyle: TextStyle(
                                  fontSize: 8.h,
                                ),
                                alignment: ChartAlignment.center,
                                labelPosition: progressReportBloc.contentCount.length > 7 ? ChartDataLabelPosition.outside : ChartDataLabelPosition.inside,
                                showCumulativeValues: false,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
              ),
              Divider(
                height: 2,
                color: Colors.black87,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Visibility(
                    visible: isAllowStatus ? false : true,
                    child: Text(
                      'Status',
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Visibility(
                visible: isAllowStatus ? false : true,
                child: new Container(
                  width: double.infinity,
                  child: SfCircularChart(
                    tooltipBehavior: TooltipBehavior(
                        enable: true, tooltipPosition: TooltipPosition.auto),
                    legend: Legend(
                      isVisible: true,
                      textStyle: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 12.0,
                      ),
                      overflowMode: LegendItemOverflowMode.wrap,
                      height: '500',
                      position: LegendPosition.bottom,
                    ),
                    //  palette: <Color>[Color.fromARGB(255,122, 209, 207), Color.fromARGB(255, 232, 234, 179), Colors.orange, Colors.redAccent, Colors.blueAccent, Colors.teal],
                    series: <CircularSeries>[
                      // Render pie chart
                      PieSeries<StatusCountData, String>(
                        enableTooltip: true,
                        dataSource: progressReportBloc.statusContentCount,
                        pointColorMapper: (StatusCountData data, _) => data.color,
                        xValueMapper: (StatusCountData data, _) => data.status,
                        yValueMapper: (StatusCountData data, _) => data.contentCount,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                            String text = "";
                            if(data is StatusCountData) {
                              StatusCountData contentCountData = data;
                              text = "${((contentCountData.contentCount/totalStatusCount) * 100).toStringAsFixed(0)} %";
                            }

                            return Text(
                                "$text",
                                style: TextStyle(
                                  fontSize: 8.h,
                                  color: Colors.black,
                                )
                            );
                          },
                          textStyle: TextStyle(
                            fontSize: 8.h,
                          ),
                          alignment: ChartAlignment.center,
                          labelPosition: progressReportBloc.statusContentCount.length > 7 ? ChartDataLabelPosition.outside : ChartDataLabelPosition.inside,
                          showCumulativeValues: false,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isAverageScore ? false : true,
                child: Divider(
                  height: 2,
                  color: Colors.black87,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Visibility(
                  visible: isAverageScore ? false : true,
                  child: Text(
                    'Average Score',
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Visibility(
                  visible: isAverageScore ? false : true,
                  child: progressReportBloc.scoreCount.length == 0
                      ? Center(
                          child: new Container(
                              height: 200,
                              alignment: Alignment.center,
                              child: noDataFound(true)))
                      : new Container(
                          height: 200,
                          child: Stack(
                            children: <Widget>[
                              SfCircularChart(
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                        widget: Container(
                                            child: PhysicalModel(
                                                child: Container(),
                                                shape: BoxShape.circle,
                                                elevation: 10,
                                                shadowColor: Colors.transparent,
                                                // color: Colors.transparent
                                                color: AppColors.getAppBGColor()
                                                // const Color.fromRGBO(
                                                //     230, 230, 230, 1,),
                                            ),
                                        ),
                                    ),
                                  ],
                                  //legend: Legend(isVisible: true),
                                  palette: <Color>[
                                    Color.fromARGB(255, 66, 165, 245),
                                    Colors.grey.shade300
                                  ],
                                  //  palette: <Color>[Color.fromARGB(255,122, 209, 207), Color.fromARGB(255, 232, 234, 179), Colors.orange, Colors.redAccent, Colors.blueAccent, Colors.teal],
                                  series: <CircularSeries>[
                                    // Render pie chart
                                    DoughnutSeries<ScoreCount, String>(
                                      enableTooltip: true,
                                      radius: '100%',
                                      innerRadius: '85%',
                                      // endAngle: progressReportBloc.endAngle,
                                      dataSource:
                                          progressReportBloc.scoreCount,
                                      // pointColorMapper: (ScoreCount data, _) =>
                                      // data.color,
                                      xValueMapper: (ScoreCount data, _) =>
                                          '',
                                      yValueMapper: (ScoreCount data, _) =>
                                          data.overallscore,
                                    )
                                  ]),
                              Center(
                                child: new Container(
                                  height: 150,
                                  child: SfCircularChart(
                                      tooltipBehavior: TooltipBehavior(
                                          enable: true,
                                          tooltipPosition:
                                              TooltipPosition.pointer),
                                      // legend: Legend(isVisible: true),
                                      palette: <Color>[
                                        Color.fromARGB(255, 122, 209, 207),
                                        Colors.grey.shade300
                                      ],
                                      series: <CircularSeries>[
                                        // Render pie chart
                                        DoughnutSeries<ScoreMaxCount, String>(
                                          animationDuration: 0,
                                          emptyPointSettings:
                                              EmptyPointSettings(
                                                  color: Colors.black,
                                                  mode: EmptyPointMode.drop,
                                                  borderColor: Colors.black,
                                                  borderWidth: 10),
                                          enableTooltip: true,
                                          radius: '95%',
                                          innerRadius: '80%',
                                          strokeColor: Colors.grey,
                                          // endAngle: progressReportBloc.endAngle1,
                                          dataSource: progressReportBloc
                                              .scoreMaxCount,
                                          // pointColorMapper: (ScoreMaxCount data, _) =>
                                          // data.color,
                                          xValueMapper:
                                              (ScoreMaxCount data, _) => '',
                                          yValueMapper:
                                              (ScoreMaxCount data, _) =>
                                                  data.scoreMax,
                                        )
                                      ]),
                                ),
                              ),
                              Center(
                                child: Text(
                                  progressReportBloc.scoreCount.length == 0
                                      ? ''
                                      : progressReportBloc
                                              .scoreCount[0].overallscore
                                              .toString() +
                                          ' %',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )))
            ],
          );
        }
      },
    );
  }

  Widget coursesWidget() {
    return BlocConsumer<ProgressReportBloc, ProgressReportState>(
      bloc: progressReportBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
          if (state.message == '401') {
            AppDirectory.sessionTimeOut(context);
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && progressReportBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.0,
              ),
            ),
          );
        }
        else if (progressReportBloc.progressReportGraphResponse.length == 0) {
          return noDataFound(true);
        }
        else {
          return progressReportBloc.progressReportGraphResponse.isNotEmpty && progressReportBloc.progressReportGraphResponse[0].groupText == ''
              ? new Container(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(color: Colors.grey,),
                      itemCount: progressReportBloc.progressReportGraphResponse[0].parentData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (progressReportBloc
                                .progressReportGraphResponse[0]
                                .parentData[index]
                                .childData
                                .isNotEmpty) {
                              setState(() {
                                if (progressReportBloc
                                    .progressReportGraphResponse[0]
                                    .parentData[index]
                                    .isVisible) {
                                  progressReportBloc
                                      .progressReportGraphResponse[0]
                                      .parentData[index]
                                      .isVisible = false;
                                } else {
                                  progressReportBloc
                                      .progressReportGraphResponse[0]
                                      .parentData[index]
                                      .isVisible = true;
                                }
                              });
                            } else if (progressReportBloc
                                .progressReportGraphResponse[0]
                                .parentData[index]
                                .detailsLink
                                .isNotEmpty) {
                              //print("Called");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseSummary(
                                    title: progressReportBloc
                                        .progressReportGraphResponse[0]
                                        .parentData[index]
                                        .contenttitle,
                                    objectId: progressReportBloc
                                        .progressReportGraphResponse[0]
                                        .parentData[index]
                                        .objectID,
                                    userId: progressReportBloc
                                        .progressReportGraphResponse[0]
                                        .parentData[index]
                                        .userid,
                                    objectTypeId: progressReportBloc
                                        .progressReportGraphResponse[0]
                                        .parentData[index]
                                        .objectTypeID,
                                    dateStarted: progressReportBloc
                                        .progressReportGraphResponse[0]
                                        .parentData[index]
                                        .datestarted,
                                    parentId: progressReportBloc
                                        .progressReportGraphResponse[0]
                                        .parentData[index]
                                        .parentID,
                                    seqId: progressReportBloc
                                        .progressReportGraphResponse[0]
                                        .parentData[index]
                                        .seqid,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: progressReportBloc.progressReportGraphResponse[0].parentData[index].childData.isNotEmpty
                                    ? Colors.grey.shade200
                                    : InsColor(appBloc).appBGColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Visibility(
                                                  visible: isContentTile
                                                      ? true
                                                      : false,
                                                  child: Text(
                                                    progressReportBloc
                                                        .progressReportGraphResponse[
                                                            0]
                                                        .parentData[index]
                                                        .contenttitle,
                                                    style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15.0),
                                                  ),
                                                ))),
                                        progressReportBloc
                                                .progressReportGraphResponse[0]
                                                .parentData[index]
                                                .childData
                                                .isNotEmpty
                                            ? Icon(
                                                progressReportBloc
                                                        .progressReportGraphResponse[
                                                            0]
                                                        .parentData[index]
                                                        .isVisible
                                                    ? Icons
                                                        .keyboard_arrow_up_outlined
                                                    : Icons
                                                        .keyboard_arrow_down_outlined,
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                              )
                                            : Container()
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Visibility(
                                              visible:
                                                  isDateStarted ? true : false,
                                              child: Expanded(
                                                child: Text(
                                                  'Started',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                        .withOpacity(0.7),
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: isDateCompleted,
                                              child: Expanded(
                                                child: Text(
                                                  'Completed',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                        .withOpacity(0.7),
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Expanded(child: Text('Time Spend',
                                            //   style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 15.0),))
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Visibility(
                                                visible: isDateStarted
                                                    ? true
                                                    : false,
                                                child: Expanded(
                                                    child: Text(
                                                        progressReportBloc
                                                                .progressReportGraphResponse[
                                                                    0]
                                                                .parentData[
                                                                    index]
                                                                .datestarted
                                                                .isEmpty
                                                            ? 'N/A'
                                                            : progressReportBloc
                                                                .progressReportGraphResponse[
                                                                    0]
                                                                .parentData[
                                                                    index]
                                                                .datestarted,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                            fontSize: 15.0)))),
                                            Visibility(
                                                visible: isDateCompleted
                                                    ? true
                                                    : false,
                                                child: Expanded(
                                                    child: Text(
                                                        progressReportBloc
                                                                .progressReportGraphResponse[
                                                                    0]
                                                                .parentData[
                                                                    index]
                                                                .datecompleted
                                                                .isEmpty
                                                            ? 'N/A'
                                                            : progressReportBloc
                                                                .progressReportGraphResponse[
                                                                    0]
                                                                .parentData[
                                                                    index]
                                                                .datecompleted,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                            fontSize: 15.0)))),

                                            // Expanded(child: Text( progressReportBloc.progressReportGraphResponse[0].parentData[index].datestarted.isNotEmpty
                                            //     && progressReportBloc.progressReportGraphResponse[0].parentData[index].datecompleted.isNotEmpty
                                            //     ? progressReportBloc.getDifference(DateTime.parse(progressReportBloc.compareDateFormatter.format(progressReportBloc.formatter.parse(progressReportBloc.progressReportGraphResponse[0].parentData[index].datestarted))), DateTime.parse(progressReportBloc.compareDateFormatter.format(progressReportBloc.formatter.parse(progressReportBloc.progressReportGraphResponse[0].parentData[index].datecompleted)))):'N/A',
                                            //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700,fontSize: 12.0),))
                                          ],
                                        ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Visibility(
                                            visible: isStatus ? true : false,
                                            child: Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0,
                                                    bottom: 5.0,
                                                    left: 2.0,
                                                    right: 2.0),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    /*color: progressReportBloc.progressReportGraphResponse[0].parentData[index].status.toString().contains('Completed')
                                                        ? Color(0xff4ad963)
                                                        : progressReportBloc.progressReportGraphResponse[0].parentData[index].status.toString().contains('In Progress')
                                                        ? Color(0xffff9503)
                                                        : progressReportBloc.progressReportGraphResponse[0].parentData[index].status.toString().contains('Not Started')
                                                        ? Color(0xfffe2c53)
                                                        : Color(0xff5750da),*/
                                                    color: AppColors.getContentStatusTagColor(),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    )),
                                                child: Text(
                                                  progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .status,
                                                  style: TextStyle(
                                                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                      fontSize: 12.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          Visibility(
                                            visible: isModule ? true : false,
                                            child: Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  color: progressReportBloc.progressReportGraphResponse[0].parentData[index].childData.isNotEmpty
                                                      ? AppColors.getAppBGColor()
                                                      : Color(int.parse("0xFFECF1F5")) ,
                                                ),
                                                child: Text(
                                                  progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .contenttype,
                                                  style: TextStyle(
                                                    color: AppColors.getAppTextColor(),
                                                    fontSize: 12.0,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          Visibility(
                                            visible:
                                                isCmeCredits ? true : false,
                                            child: Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    top: 5.0,
                                                    bottom: 5.0,
                                                    left: 4.0,
                                                    right: 4.0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  color: Color(int.parse("0xFFECF1F5")),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0, right: 10.0),
                                                  child: Text(
                                                    progressReportBloc
                                                            .progressReportGraphResponse[
                                                                0]
                                                            .parentData[index]
                                                            .credit
                                                            .isNotEmpty
                                                        ? progressReportBloc
                                                            .progressReportGraphResponse[
                                                                0]
                                                            .parentData[index]
                                                            .credit
                                                        : 'Credit 0.0',
                                                    style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                        fontSize: 12.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: progressReportBloc
                                              .progressReportGraphResponse[0]
                                              .parentData[index]
                                              .certificateAction
                                              .isEmpty
                                          ? false
                                          : true,
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Container(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                          width: 150,
                                          child: MaterialButton(
                                            onPressed: () => {
                                              if (progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .certificateAction
                                                      .isEmpty ||
                                                  progressReportBloc
                                                          .progressReportGraphResponse[
                                                              0]
                                                          .parentData[index]
                                                          .certificateAction ==
                                                      'notearned')
                                                {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          new AlertDialog(
                                                            title: Text(
                                                              appBloc.localstr
                                                                  .mylearningActionsheetViewcertificateoption,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      int.parse(
                                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            content: Text(
                                                              appBloc.localstr
                                                                  .mylearningAlertsubtitleForviewcertificate,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    int.parse(
                                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Color(int.parse(
                                                                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                        .circular(5)),
                                                            actions: <Widget>[
                                                              new FlatButton(
                                                                child: Text(appBloc
                                                                    .localstr
                                                                    .mylearningClosebuttonactionClosebuttonalerttitle),
                                                                textColor:
                                                                    Colors.blue,
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ))
                                                }
                                              else
                                                {
                                                  detailsBloc
                                                      .myLearningDetailsModel
                                                      .setcontentID(
                                                          progressReportBloc
                                                              .progressReportGraphResponse[
                                                                  0]
                                                              .parentData[index]
                                                              .objectID),
                                                  detailsBloc
                                                      .myLearningDetailsModel
                                                      .setCertificateId(
                                                          progressReportBloc
                                                              .progressReportGraphResponse[
                                                                  0]
                                                              .parentData[index]
                                                              .certificateid),
                                                  detailsBloc
                                                      .myLearningDetailsModel
                                                      .setCertificatePage(
                                                          progressReportBloc
                                                              .progressReportGraphResponse[
                                                                  0]
                                                              .parentData[index]
                                                              .certificateAction),
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewCertificate(
                                                                  detailsBloc:
                                                                      detailsBloc)))
                                                }
                                            },
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            disabledColor: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                .withOpacity(0.5),
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Icon(Icons.workspace_premium)),
                                                Text(
                                                  'Certificate',
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                      fontSize: 15.0),
                                                )
                                              ],
                                            ),
                                            textColor: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: progressReportBloc
                                    .progressReportGraphResponse[0]
                                    .parentData[index]
                                    .childData
                                    .isNotEmpty,
                                child: Divider(
                                  height: 5.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Visibility(
                                visible: progressReportBloc.progressReportGraphResponse[0].parentData[index].isVisible,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                    color: Colors.grey,
                                  ),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: progressReportBloc.progressReportGraphResponse[0].parentData[index].childData.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      onTap: () {
                                        if (progressReportBloc.progressReportGraphResponse[0].parentData[index].childData[i].detailsLink.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CourseSummary(
                                                  title: progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .childData[i]
                                                      .contenttitle,
                                                  objectId: progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .childData[i]
                                                      .objectID,
                                                  userId: progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .childData[i]
                                                      .userid,
                                                  objectTypeId: progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .childData[i]
                                                      .objectTypeID,
                                                  dateStarted: progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .childData[i]
                                                      .datestarted,
                                                  parentId: progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .childData[i]
                                                      .parentID,
                                                  seqId: progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .childData[i]
                                                      .seqid),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        color: AppColors.getAppBGColor(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                progressReportBloc
                                                    .progressReportGraphResponse[
                                                        0]
                                                    .parentData[index]
                                                    .childData[i]
                                                    .contenttitle,
                                                style: TextStyle(
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      'Started',
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                              .withOpacity(0.5),
                                                          fontSize: 15.0),
                                                    )),
                                                    Expanded(
                                                        child: Text(
                                                      'Completed',
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                              .withOpacity(0.5),
                                                          fontSize: 15.0),
                                                    )),
                                                    // Expanded(child: Text('Time Spend',
                                                    //   style: TextStyle(color: Color(int.parse(
                                                    //       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),fontWeight: FontWeight.bold, fontSize: 15.0),))
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            progressReportBloc
                                                                    .progressReportGraphResponse[
                                                                        0]
                                                                    .parentData[
                                                                        index]
                                                                    .childData[
                                                                        i]
                                                                    .datestarted
                                                                    .isEmpty
                                                                ? 'N/A'
                                                                : progressReportBloc
                                                                    .progressReportGraphResponse[
                                                                        0]
                                                                    .parentData[
                                                                        index]
                                                                    .childData[
                                                                        i]
                                                                    .datestarted,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    int.parse(
                                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                fontSize:
                                                                    12.0))),
                                                    Expanded(
                                                        child: Text(
                                                            progressReportBloc
                                                                    .progressReportGraphResponse[
                                                                        0]
                                                                    .parentData[
                                                                        index]
                                                                    .childData[
                                                                        i]
                                                                    .datecompleted
                                                                    .isEmpty
                                                                ? 'N/A'
                                                                : progressReportBloc
                                                                    .progressReportGraphResponse[
                                                                        0]
                                                                    .parentData[
                                                                        index]
                                                                    .childData[
                                                                        i]
                                                                    .datecompleted,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    int.parse(
                                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                fontSize:
                                                                    12.0))),
                                                    // Expanded(child: Text( progressReportBloc.progressReportGraphResponse[0].parentData[index]
                                                    //     .childData[
                                                    // i].datestarted.isNotEmpty && progressReportBloc.progressReportGraphResponse[0].parentData[index]
                                                    //     .childData[
                                                    // i].datecompleted.isNotEmpty ? progressReportBloc.getDifference(DateTime.parse(progressReportBloc.compareDateFormatter.format(progressReportBloc.formatter.parse(progressReportBloc.progressReportGraphResponse[0].parentData[index]
                                                    //     .childData[
                                                    // i].datestarted))), DateTime.parse(progressReportBloc.compareDateFormatter.format(progressReportBloc.formatter.parse(progressReportBloc.progressReportGraphResponse[0].parentData[index]
                                                    //     .childData[
                                                    // i].datecompleted)))):'',
                                                    //     style: TextStyle( color: Color(int.parse(
                                                    //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),fontSize: 12.0)))
                                                  ],
                                                )),
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(5.0),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        /*color: progressReportBloc.progressReportGraphResponse[0].parentData[index].childData[i].status.toString().contains('Completed')
                                                            ? Color(0xff4ad963)
                                                            : progressReportBloc.progressReportGraphResponse[0].parentData[index].childData[i].status.toString().contains('In Progress')
                                                            ? Color(0xffff9503)
                                                            : progressReportBloc.progressReportGraphResponse[0].parentData[index].childData[i].status.toString().contains('Not Started')
                                                            ? Color(0xfffe2c53)
                                                            : Color(0xff5750da),*/
                                                        color: AppColors.getContentStatusTagColor(),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(20.0),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        progressReportBloc
                                                            .progressReportGraphResponse[
                                                                0]
                                                            .parentData[index]
                                                            .childData[i]
                                                            .status,
                                                        style: TextStyle(
                                                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                          fontSize: 12.0,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 20,),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(5.0),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Color(int.parse("0xFFECF1F5")),
                                                          borderRadius: BorderRadius.all(Radius.circular(20.0),),
                                                      ),
                                                      child: Text(
                                                        progressReportBloc
                                                            .progressReportGraphResponse[0]
                                                            .parentData[index]
                                                            .childData[i]
                                                            .contenttype,
                                                        style: TextStyle(
                                                            color: AppColors.getAppTextColor(),
                                                            fontSize: 12.0),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 20,),
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      decoration: BoxDecoration(
                                                        color: Color(int.parse("0xFFECF1F5")),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(20.0),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        progressReportBloc
                                                                .progressReportGraphResponse[
                                                                    0]
                                                                .parentData[
                                                                    index]
                                                                .childData[i]
                                                                .credit
                                                                .isNotEmpty
                                                            ? progressReportBloc
                                                                .progressReportGraphResponse[
                                                                    0]
                                                                .parentData[
                                                                    index]
                                                                .childData[i]
                                                                .credit
                                                            : 'Credit 0.0',
                                                        style: TextStyle(
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                            fontSize: 12.0),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: progressReportBloc
                                                      .progressReportGraphResponse[
                                                          0]
                                                      .parentData[index]
                                                      .childData[i]
                                                      .certificateAction
                                                      .isEmpty
                                                  ? false
                                                  : true,
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Container(
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                  width: 140,
                                                  child: MaterialButton(
                                                    onPressed: () => {
                                                      if (progressReportBloc
                                                              .progressReportGraphResponse[
                                                                  0]
                                                              .parentData[index]
                                                              .childData[i]
                                                              .certificateAction
                                                              .isEmpty ||
                                                          progressReportBloc
                                                                  .progressReportGraphResponse[
                                                                      0]
                                                                  .parentData[
                                                                      index]
                                                                  .childData[i]
                                                                  .certificateAction ==
                                                              'notearned')
                                                        {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  new AlertDialog(
                                                                    title: Text(
                                                                      appBloc
                                                                          .localstr
                                                                          .mylearningActionsheetViewcertificateoption,
                                                                      style: TextStyle(
                                                                          color: Color(int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content: Text(
                                                                        appBloc
                                                                            .localstr
                                                                            .mylearningAlertsubtitleForviewcertificate,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                            fontWeight: FontWeight.bold)),
                                                                    backgroundColor:
                                                                        Color(int.parse(
                                                                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            new BorderRadius.circular(5)),
                                                                    actions: <
                                                                        Widget>[
                                                                      new FlatButton(
                                                                        child: Text(appBloc
                                                                            .localstr
                                                                            .mylearningClosebuttonactionClosebuttonalerttitle),
                                                                        textColor:
                                                                            Colors.blue,
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ))
                                                        }
                                                      else
                                                        {
                                                          detailsBloc
                                                              .myLearningDetailsModel
                                                              .setcontentID(
                                                                  progressReportBloc
                                                                      .progressReportGraphResponse[
                                                                          0]
                                                                      .parentData[
                                                                          index]
                                                                      .childData[
                                                                          i]
                                                                      .objectID),
                                                          detailsBloc
                                                              .myLearningDetailsModel
                                                              .setCertificateId(
                                                                  progressReportBloc
                                                                      .progressReportGraphResponse[
                                                                          0]
                                                                      .parentData[
                                                                          index]
                                                                      .childData[
                                                                          i]
                                                                      .certificateid),
                                                          detailsBloc
                                                              .myLearningDetailsModel
                                                              .setCertificatePage(
                                                                  progressReportBloc
                                                                      .progressReportGraphResponse[
                                                                          0]
                                                                      .parentData[
                                                                          index]
                                                                      .childData[
                                                                          i]
                                                                      .certificateAction),
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ViewCertificate(
                                                                          detailsBloc:
                                                                              detailsBloc)))
                                                        }
                                                    },
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    disabledColor: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                        .withOpacity(0.5),
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                            padding: EdgeInsets.all(
                                                                    5.0),
                                                            child: Icon(Icons.workspace_premium)),
                                                        Text(
                                                          'Certificate',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                              fontSize: 15.0),
                                                        )
                                                      ],
                                                    ),
                                                    textColor: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                )
              : new ListView(
                  //shrinkWrap: true,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Theme(
                          data: Theme.of(context).copyWith(
                            cursorColor: InsColor(appBloc).appBGColor,
                            cardColor: InsColor(appBloc).appBGColor,
                          ),
                          child: ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                progressReportBloc
                                    .progressReportGraphResponse[index]
                                    .isExpanded = !isExpanded;
                              });
                            },
                            children: progressReportBloc
                                .progressReportGraphResponse
                                .map<ExpansionPanel>(
                                    (ProgressReportGraphResponse parentData) {
                              return ExpansionPanel(
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return FadeAnimation(
                                        0.5,
                                        GestureDetector(
                                            onTap: () => {
                                                  setState(() {
                                                    parentData.isExpanded =
                                                        !isExpanded;
                                                  })
                                                },
                                            child: new Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: new Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Text(
                                                        parentData.groupText,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                                  )),
                                                ],
                                              ),
                                            )));
                                  },
                                  body: new Container(
                                    color: InsColor(appBloc).appBGColor,
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              color: Colors.grey,
                                            ),
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: parentData.parentData.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                              onTap: () => {
                                                    if (parentData
                                                            .parentData[index]
                                                            .childData !=
                                                        null)
                                                      {
                                                        setState(() {
                                                          if (parentData
                                                              .parentData[index]
                                                              .isVisible) {
                                                            parentData
                                                                    .parentData[
                                                                        index]
                                                                    .isVisible =
                                                                false;
                                                          } else {
                                                            parentData
                                                                    .parentData[
                                                                        index]
                                                                    .isVisible =
                                                                true;
                                                          }
                                                        }),
                                                      }
                                                    else if (parentData
                                                            .parentData[index]
                                                            .detailsLink !=
                                                        null)
                                                      {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => CourseSummary(
                                                                    title: parentData
                                                                        .parentData[
                                                                            index]
                                                                        .contenttitle,
                                                                    objectId: parentData
                                                                        .parentData[
                                                                            index]
                                                                        .objectID,
                                                                    userId: parentData
                                                                        .parentData[
                                                                            index]
                                                                        .userid,
                                                                    objectTypeId: parentData
                                                                        .parentData[
                                                                            index]
                                                                        .objectTypeID,
                                                                    dateStarted: parentData
                                                                        .parentData[
                                                                            index]
                                                                        .datestarted,
                                                                    parentId: parentData
                                                                        .parentData[
                                                                            index]
                                                                        .parentID,
                                                                    seqId: parentData
                                                                        .parentData[
                                                                            index]
                                                                        .seqid)))
                                                      }
                                                  },
                                              child: Container(
                                                  child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    color: parentData.parentData[index].childData != null
                                                        ? Colors.grey.shade300
                                                        : InsColor(appBloc).appBGColor,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        Visibility(
                                                                      visible: isContentTile
                                                                          ? true
                                                                          : false,
                                                                      child:
                                                                          Text(
                                                                        parentData
                                                                            .parentData[index]
                                                                            .contenttitle,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 15.0),
                                                                      ),
                                                                    ))),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          24.0),
                                                              child: parentData
                                                                          .parentData[
                                                                              index]
                                                                          .childData !=
                                                                      null
                                                                  ? Icon(
                                                                      parentData
                                                                              .parentData[
                                                                                  index]
                                                                              .isVisible
                                                                          ? Icons
                                                                              .keyboard_arrow_up_outlined
                                                                          : Icons
                                                                              .keyboard_arrow_down_outlined,
                                                                      color: Color(int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                                          .withOpacity(
                                                                              0.6),
                                                                    )
                                                                  : Container(),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Row(
                                                              children: [
                                                                Visibility(
                                                                    visible: isDateStarted
                                                                        ? true
                                                                        : false,
                                                                    child: Expanded(
                                                                        child: Text(
                                                                      'Started',
                                                                      style: TextStyle(
                                                                          color: Color(int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              15.0),
                                                                    ))),
                                                                Visibility(
                                                                    visible: isDateCompleted
                                                                        ? true
                                                                        : false,
                                                                    child: Expanded(
                                                                        child: Text(
                                                                      'Completed',
                                                                      style: TextStyle(
                                                                          color: Color(int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              15.0),
                                                                    ))),
                                                                // Text('Time Spend',
                                                                //   style: TextStyle(color: Color(int.parse(
                                                                //       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),fontWeight: FontWeight.bold, fontSize: 15.0),)
                                                              ],
                                                            )),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Row(
                                                              children: [
                                                                Visibility(
                                                                    visible: isDateStarted
                                                                        ? true
                                                                        : false,
                                                                    child: Expanded(
                                                                        child: Text(
                                                                            parentData.parentData[index].datestarted.isEmpty
                                                                                ? 'N/A'
                                                                                : parentData.parentData[index].datestarted,
                                                                            style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontSize: 12.0)))),
                                                                Visibility(
                                                                    visible: isDateCompleted
                                                                        ? true
                                                                        : false,
                                                                    child: Expanded(
                                                                        child: Text(
                                                                            parentData.parentData.isEmpty
                                                                                ? 'N/A'
                                                                                : parentData.parentData[index].datecompleted,
                                                                            style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontSize: 12.0)))),

                                                                // Text( parentData.parentData[index].datestarted.isNotEmpty
                                                                //     && parentData.parentData[index].datecompleted.isNotEmpty
                                                                //     ? progressReportBloc.getDifference(DateTime.parse(progressReportBloc.compareDateFormatter.format(progressReportBloc.formatter.parse(parentData.parentData[index].datestarted))), DateTime.parse(progressReportBloc.compareDateFormatter.format(progressReportBloc.formatter.parse(parentData.parentData[index].datecompleted)))):'',
                                                                // style: TextStyle( color: Color(int.parse(
                                                                //     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),fontSize: 12.0),)
                                                              ],
                                                            )),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Row(
                                                              children: [
                                                                Visibility(
                                                                    visible: isStatus
                                                                        ? true
                                                                        : false,
                                                                    child: Expanded(
                                                                        child: Container(
                                                                            margin: const EdgeInsets.only(right: 10.0),
                                                                            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 2.0, right: 2.0),
                                                                            alignment: Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                              color: parentData.parentData[index].status.toString().contains('Completed')
                                                                                  ? Color(0xff4ad963)
                                                                                  : parentData.parentData[index].status.toString().contains('In Progress')
                                                                                  ? Color(0xffff9503)
                                                                                  : parentData.parentData[index].status.toString().contains('Not Started')
                                                                                  ? Color(0xfffe2c53)
                                                                                  : Color(0xff5750da),
                                                                                /*border: Border.all(
                                                                                    color: parentData.parentData[index].status.toString().contains('Completed')
                                                                                        ? Color(0xff4ad963)
                                                                                        : parentData.parentData[index].status.toString().contains('In Progress')
                                                                                            ? Color(0xffff9503)
                                                                                            : parentData.parentData[index].status.toString().contains('Not Started')
                                                                                                ? Color(0xfffe2c53)
                                                                                                : Color(0xff5750da)),*/
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(20.0),
                                                                                ),
                                                                            ),
                                                                            child: Text(parentData.parentData[index].status,
                                                                                style: TextStyle(
                                                                                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                                                    fontSize: 12.0))))),
                                                                Visibility(
                                                                    visible: isModule
                                                                        ? true
                                                                        : false,
                                                                    child: Expanded(
                                                                        child: Container(
                                                                            margin: const EdgeInsets.only(right: 20.0),
                                                                            padding: const EdgeInsets.all(5.0),
                                                                            alignment: Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.grey),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(20.0),
                                                                                )),
                                                                            child: Text(
                                                                              parentData.parentData[index].contenttype,
                                                                              style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontSize: 12.0),
                                                                            )))),
                                                                Visibility(
                                                                    visible: isCmeCredits
                                                                        ? true
                                                                        : false,
                                                                    child:
                                                                        Expanded(
                                                                      child: Container(
                                                                          alignment: Alignment.center,
                                                                          padding: const EdgeInsets.all(5.0),
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.grey),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(20.0),
                                                                              )),
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 10.0, right: 10.0),
                                                                            child:
                                                                                Text(parentData.parentData[index].credit != null ? parentData.parentData[index].credit.toString() : 'Credit 0.0', style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontSize: 12.0)),
                                                                          )),
                                                                    ))
                                                              ],
                                                            )),
                                                        Visibility(
                                                          visible: parentData
                                                                  .parentData[
                                                                      index]
                                                                  .certificateAction
                                                                  .isEmpty
                                                              ? true
                                                              : false,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Container(
                                                              color: parentData
                                                                          .parentData[
                                                                              index]
                                                                          .childData !=
                                                                      null
                                                                  ? Colors.grey
                                                                      .shade300
                                                                  : InsColor(
                                                                          appBloc)
                                                                      .appBGColor,
                                                              width: 150,
                                                              child:
                                                                  MaterialButton(
                                                                onPressed: () =>
                                                                    {
                                                                  if (parentData
                                                                          .parentData[
                                                                              index]
                                                                          .certificateAction
                                                                          .isEmpty ||
                                                                      parentData
                                                                              .parentData[index]
                                                                              .certificateAction ==
                                                                          'notearned')
                                                                    {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              new AlertDialog(
                                                                                title: Text(
                                                                                  appBloc.localstr.mylearningActionsheetViewcertificateoption,
                                                                                  style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontWeight: FontWeight.bold),
                                                                                ),
                                                                                content: Text(
                                                                                  appBloc.localstr.mylearningAlertsubtitleForviewcertificate,
                                                                                  style: TextStyle(
                                                                                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                                  ),
                                                                                ),
                                                                                backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5)),
                                                                                actions: <Widget>[
                                                                                  new FlatButton(
                                                                                    child: Text(appBloc.localstr.mylearningClosebuttonactionClosebuttonalerttitle),
                                                                                    textColor: Colors.blue,
                                                                                    onPressed: () async {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                    }
                                                                  else
                                                                    {
                                                                      detailsBloc
                                                                          .myLearningDetailsModel
                                                                          .setcontentID(parentData
                                                                              .parentData[index]
                                                                              .objectID),
                                                                      detailsBloc
                                                                          .myLearningDetailsModel
                                                                          .setCertificateId(parentData
                                                                              .parentData[index]
                                                                              .certificateid),
                                                                      detailsBloc
                                                                          .myLearningDetailsModel
                                                                          .setCertificatePage(parentData
                                                                              .parentData[index]
                                                                              .certificateAction),
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                              MaterialPageRoute(builder: (context) => ViewCertificate(detailsBloc: detailsBloc)))
                                                                    }
                                                                },
                                                                minWidth:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                disabledColor: Color(
                                                                        int.parse(
                                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                                    .withOpacity(
                                                                        0.5),
                                                                color: Color(
                                                                    int.parse(
                                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                5.0),
                                                                        child: Icon(
                                                                            Icons.workspace_premium)),
                                                                    Text(
                                                                      'Certificate',
                                                                      style: TextStyle(
                                                                          color: Color(int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                                          fontSize:
                                                                              15.0),
                                                                    )
                                                                  ],
                                                                ),
                                                                textColor: Color(
                                                                    int.parse(
                                                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                      visible: parentData.parentData[index].childData != null
                                                          ? true
                                                          : false,
                                                      child: Divider(
                                                        height: 5.0,
                                                        color: Colors.grey,
                                                      )),
                                                  Visibility(
                                                      visible: parentData
                                                          .parentData[index]
                                                          .isVisible,
                                                      child: ListView.separated(
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemCount: parentData
                                                                    .parentData[
                                                                        index]
                                                                    .childData !=
                                                                null
                                                            ? parentData
                                                                .parentData[
                                                                    index]
                                                                .childData
                                                                .length
                                                            : 0,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return InkWell(
                                                            onTap: () => {
                                                              if (parentData
                                                                      .parentData[
                                                                          index]
                                                                      .childData[
                                                                          i]
                                                                      .detailsLink !=
                                                                  null)
                                                                {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => CourseSummary(
                                                                              title: parentData.parentData[index].childData[i].contenttitle,
                                                                              objectId: parentData.parentData[index].childData[i].objectID,
                                                                              userId: parentData.parentData[index].childData[i].userid,
                                                                              objectTypeId: parentData.parentData[index].childData[i].objectTypeID,
                                                                              dateStarted: parentData.parentData[index].childData[i].datestarted,
                                                                              parentId: parentData.parentData[index].childData[i].parentID,
                                                                              seqId: parentData.parentData[index].childData[i].seqid)))
                                                                }
                                                            },
                                                            child:
                                                                new Container(
                                                                    child:
                                                                        Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        Visibility(
                                                                      visible: isContentTile
                                                                          ? true
                                                                          : false,
                                                                      child:
                                                                          Text(
                                                                        parentData
                                                                            .parentData[index]
                                                                            .childData[i]
                                                                            .contenttitle,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                      ),
                                                                    )),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Visibility(
                                                                            visible: isDateStarted
                                                                                ? true
                                                                                : false,
                                                                            child: Expanded(
                                                                                child: Text(
                                                                              'Started',
                                                                              style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                            ))),
                                                                        Visibility(
                                                                            visible: isDateCompleted
                                                                                ? true
                                                                                : false,
                                                                            child: Expanded(
                                                                                child: Text(
                                                                              'Completed',
                                                                              style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                            ))),
                                                                        // Text('Time Spend',
                                                                        // style: TextStyle(color:Color(int.parse(
                                                                        //     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),)
                                                                      ],
                                                                    )),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Visibility(
                                                                            visible: isDateStarted
                                                                                ? true
                                                                                : false,
                                                                            child: Expanded(
                                                                                child: Text(
                                                                              parentData.parentData[index].childData[i].datestarted.isEmpty ? 'N/A' : parentData.parentData[index].childData[i].datestarted,
                                                                              style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                            ))),
                                                                        Visibility(
                                                                            visible: isDateCompleted
                                                                                ? true
                                                                                : false,
                                                                            child: Expanded(
                                                                                child: Text(
                                                                              parentData.parentData[index].childData[i].datecompleted.isEmpty ? 'N/A' : parentData.parentData[index].childData[i].datecompleted,
                                                                              style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                            ))),
                                                                        // Text( parentData.parentData[index]
                                                                        //     .childData[
                                                                        // i].datestarted.isNotEmpty && parentData.parentData[index]
                                                                        //     .childData[
                                                                        // i].datecompleted.isNotEmpty ? progressReportBloc.getDifference(DateTime.parse(progressReportBloc.compareDateFormatter.format(progressReportBloc.formatter.parse(parentData.parentData[index]
                                                                        //     .childData[
                                                                        // i].datestarted))), DateTime.parse(progressReportBloc.compareDateFormatter.format(progressReportBloc.formatter.parse(parentData.parentData[index]
                                                                        //     .childData[
                                                                        // i].datecompleted,)))):'',
                                                                        // style: TextStyle(color:Color(int.parse(
                                                                        //     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),)
                                                                      ],
                                                                    )),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Visibility(
                                                                            visible: isStatus
                                                                                ? true
                                                                                : false,
                                                                            child: Expanded(
                                                                                child: Container(
                                                                                    margin: const EdgeInsets.only(right: 10.0),
                                                                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 2.0, right: 2.0),
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(
                                                                                        color: parentData.parentData[index].childData[i].status.toString().contains('Completed')
                                                                                            ? Color(0xff4ad963)
                                                                                            : parentData.parentData[index].childData[i].status.toString().contains('In Progress')
                                                                                            ? Color(0xffff9503)
                                                                                            : parentData.parentData[index].childData[i].status.toString().contains('Not Started')
                                                                                            ? Color(0xfffe2c53)
                                                                                            : Color(0xff5750da),
                                                                                        /*border: Border.all(
                                                                                            color: parentData.parentData[index].childData[i].status.toString().contains('Completed')
                                                                                                ? Color(0xff4ad963)
                                                                                                : parentData.parentData[index].childData[i].status.toString().contains('In Progress')
                                                                                                    ? Color(0xffff9503)
                                                                                                    : parentData.parentData[index].childData[i].status.toString().contains('Not Started')
                                                                                                        ? Color(0xfffe2c53)
                                                                                                        : Color(0xff5750da)),*/
                                                                                        borderRadius: BorderRadius.all(
                                                                                          Radius.circular(20.0),
                                                                                        )),
                                                                                    child: Text(parentData.parentData[index].childData[i].status,
                                                                                        style: TextStyle(
                                                                                            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                                                            fontSize: 12.0))))),
                                                                        Visibility(
                                                                            visible: isModule
                                                                                ? true
                                                                                : false,
                                                                            child: Expanded(
                                                                                child: Container(
                                                                                    margin: const EdgeInsets.only(right: 20.0),
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(
                                                                                        border: Border.all(color: Colors.grey),
                                                                                        borderRadius: BorderRadius.all(
                                                                                          Radius.circular(20.0),
                                                                                        )),
                                                                                    child: Text(
                                                                                      parentData.parentData[index].childData[i].contenttype,
                                                                                      style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontSize: 12.0),
                                                                                    )))),
                                                                        Visibility(
                                                                            visible: isCmeCredits
                                                                                ? true
                                                                                : false,
                                                                            child:
                                                                                Expanded(
                                                                              child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  padding: const EdgeInsets.all(5.0),
                                                                                  decoration: BoxDecoration(
                                                                                      border: Border.all(color: Colors.grey),
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(20.0),
                                                                                      )),
                                                                                  child: Text(parentData.parentData[index].childData[i].credit != null ? parentData.parentData[index].childData[i].credit.toString() : 'Credit 0.0', style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontSize: 12.0))),
                                                                            ))
                                                                      ],
                                                                    )),
                                                                Visibility(
                                                                  visible: parentData
                                                                          .parentData[
                                                                              index]
                                                                          .childData[
                                                                              i]
                                                                          .certificateAction
                                                                          .isEmpty
                                                                      ? false
                                                                      : true,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        Container(
                                                                      color: Color(
                                                                          int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                                      width:
                                                                          140,
                                                                      child:
                                                                          MaterialButton(
                                                                        onPressed:
                                                                            () =>
                                                                                {
                                                                          if (parentData.parentData[index].certificateAction.isEmpty ||
                                                                              parentData.parentData[index].certificateAction == 'notearned')
                                                                            {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) => new AlertDialog(
                                                                                        title: Text(
                                                                                          appBloc.localstr.mylearningActionsheetViewcertificateoption,
                                                                                          style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        content: Text(
                                                                                          appBloc.localstr.mylearningAlertsubtitleForviewcertificate,
                                                                                          style: TextStyle(
                                                                                            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                                          ),
                                                                                        ),
                                                                                        backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                                                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5)),
                                                                                        actions: <Widget>[
                                                                                          new FlatButton(
                                                                                            child: Text(appBloc.localstr.mylearningClosebuttonactionClosebuttonalerttitle),
                                                                                            textColor: Colors.blue,
                                                                                            onPressed: () async {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      ))
                                                                            }
                                                                          else
                                                                            {
                                                                              detailsBloc.myLearningDetailsModel.setcontentID(parentData.parentData[index].childData[i].objectID),
                                                                              detailsBloc.myLearningDetailsModel.setCertificateId(parentData.parentData[index].childData[i].certificateid),
                                                                              detailsBloc.myLearningDetailsModel.setCertificatePage(parentData.parentData[index].childData[i].certificateAction),
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewCertificate(detailsBloc: detailsBloc)))
                                                                            }
                                                                        },
                                                                        minWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        disabledColor:
                                                                            Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
                                                                        color: Color(
                                                                            int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                                padding: EdgeInsets.all(5.0),
                                                                                child: Icon(Icons.workspace_premium)),
                                                                            Text(
                                                                              'Certificate',
                                                                              style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")), fontSize: 15.0),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        textColor:
                                                                            Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                          );
                                                        },
                                                      )),
                                                ],
                                              )));
                                        }),
                                  ),
                                  isExpanded: parentData.isExpanded);
                            }).toList(),
                          )),
                    )
                  ],
                );
        }
      },
    );
  }

  refresh(int groupValue) {
    var repositoryId = widget.nativeMenuModel.repositoryId.isEmpty
        ? 0
        : widget.nativeMenuModel.repositoryId;
    // if (widget.nativeMenuModel.repositoryId is int &&
    //     widget.nativeMenuModel.componentId is int) {
    progressReportBloc.add(ProgressReportGraphEvent(
        aintComponentID: int.parse(widget.nativeMenuModel.componentId),
        aintCompInsID: int.parse(repositoryId.toString()),
        aintSelectedGroupValue: groupValue));
    //}
  }

  Widget noDataFound(val) {
    return val
        ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Text(
                      appBloc.localstr.commoncomponentLabelNodatalabel,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontSize: 24),
                    ),
                  ),
                ),
              )
            ],
          )
        : new Container();
  }

  void updateGroupValue() {
    if (appBloc.groupVlaue == 'Group By') {
      refresh(0);
    } else if (appBloc.groupVlaue == 'Categories') {
      refresh(3);
    } else if (appBloc.groupVlaue == 'Learning Community') {
      refresh(1);
    } else if (appBloc.groupVlaue == 'Content Type') {
      refresh(2);
    }
  }

  void isAllowGroupBy() {
    if (filterMenus != null && filterMenus.containsKey("GroupBy")) {
      String allowGroupBy = filterMenus["GroupBy"] ?? "";
      print("allowGroupBy $allowGroupBy");
      if (allowGroupBy != null || allowGroupBy == "true") {
        appBloc.isAllowGroupBy = true;
      } else {
        appBloc.isAllowGroupBy = false;
      }
    } else {
      // No such key
      appBloc.isAllowGroupBy = false;
    }

    if (filterMenus != null && filterMenus.containsKey("ContentTypes")) {
      String allowContentType = filterMenus["ContentTypes"] ?? "";
      print("AllowAddContentType $allowContentType");
      if (allowContentType != null || allowContentType == "true") {
        isAllowTitle = true;
      } else {
        isAllowTitle = false;
      }
    } else {
      // No such key
      isAllowTitle = false;
    }

    if (filterMenus != null && filterMenus.containsKey("Status")) {
      String allowStatus = filterMenus["Status"] ?? "";
      print("AllowAddContentType $allowStatus");
      if (allowStatus != null || allowStatus == "true") {
        isAllowStatus = true;
      } else {
        isAllowStatus = false;
      }
    } else {
      // No such key
      isAllowStatus = false;
    }

    if (filterMenus != null && filterMenus.containsKey("Contents")) {
      String allowContentTtile = filterMenus["Contents"] ?? "";
      print("AllowAddContentType $allowContentTtile");
      if (allowContentTtile != null || allowContentTtile == "true") {
        isAllowContent = true;
      } else {
        isAllowContent = false;
      }
    } else {
      // No such key
      isAllowContent = false;
    }

    if (filterMenus != null && filterMenus.containsKey("AverageScore")) {
      String allowAverageScore = filterMenus["AverageScore"] ?? "";
      print("AllowAddContentType $allowAverageScore");
      if (allowAverageScore != null || allowAverageScore == "true") {
        isAverageScore = true;
      } else {
        isAverageScore = false;
      }
    } else {
      // No such key
      isAverageScore = false;
    }

    //TODO: Commenting because of filter Menu getting null
    isContentTile = true;
    /*
    if (filterMenus != null && filterMenus.containsKey("DisplayColumns")) {
      String isContentTitle = filterMenus["DisplayColumns"];
      print("isContentTitle $isContentTitle");
      if (isContentTitle != null && isContentTitle.contains("contenttitle")) {
        isContentTile = true;
      } else {
        isContentTile = false;
      }
    } else {
      // No such key
      isContentTile = false;
    }
    */

    if (filterMenus != null && filterMenus.containsKey("DisplayColumns")) {
      String isStatus = filterMenus["DisplayColumns"] ?? "";
      print("isStatus $isStatus");
      if (isStatus != null && isStatus.contains("status")) {
        this.isStatus = true;
      } else {
        this.isStatus = false;
      }
    } else {
      // No such key
      //TODO: Setting true because of filter Menu getting null
      this.isStatus = true;
    }

    if (filterMenus != null && filterMenus.containsKey("DisplayColumns")) {
      String allowType = filterMenus["DisplayColumns"] ?? "";
      print("allowType $allowType");
      if (allowType != null && allowType.contains("contenttype")) {
        this.isModule = true;
      } else {
        this.isModule = false;
      }
    } else {
      // No such key
      //TODO: Setting true because of filter Menu getting null
      this.isModule = true;
    }

    if (filterMenus != null && filterMenus.containsKey("DisplayColumns")) {
      String allowDateStart = filterMenus["DisplayColumns"] ?? "";
      print("allowDateStart $allowDateStart");
      if (allowDateStart != null && allowDateStart.contains("datestarted")) {
        this.isDateStarted = true;
      } else {
        this.isDateStarted = false;
      }
    } else {
      // No such key
      //TODO: Setting true because of filter Menu getting null
      this.isDateStarted = true;
    }

    if (filterMenus != null && filterMenus.containsKey("DisplayColumns")) {
      String allowDateComplete = filterMenus["DisplayColumns"] ?? "";
      print("allowDateComplete $allowDateComplete");
      if (allowDateComplete != null &&
          allowDateComplete.contains("datecompleted")) {
        this.isDateCompleted = true;
      } else {
        this.isDateCompleted = false;
      }
    } else {
      // No such key
      //TODO: Setting true because of filter Menu getting null
      this.isDateCompleted = true;
    }

    if (filterMenus != null && filterMenus.containsKey("DisplayColumns")) {
      String allowCredit = filterMenus["DisplayColumns"] ?? "";
      print("allowCredit $allowCredit");
      if (allowCredit != null && allowCredit.contains("CmeCredits")) {
        this.isCmeCredits = true;
      } else {
        this.isCmeCredits = false;
      }
    } else {
      // No such key
      //TODO: Setting true because of filter Menu getting null
      this.isCmeCredits = true;
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget cancelButton = Container(
      width: 80,
      child: MaterialButton(
        onPressed: () => {Navigator.of(context).pop()},
        minWidth: MediaQuery.of(context).size.width,
        disabledColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
            .withOpacity(0.5),
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Close',
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  fontSize: 15.0),
            )
          ],
        ),
        textColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
      ),
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      title: Text(
        "View Certificate",
        style: TextStyle(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
      ),
      content: Text(
        "In order to view the certificate, please complete the content with the required criteria",
        style: TextStyle(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Map<String, String> getConditionsValue(String strConditions) {
    Map<String, String> filterMenus = {};

    if (strConditions != "") {
      if (strConditions.contains("#@#")) {
        var conditionsArray = strConditions.split("#@#");
        int conditionCount = conditionsArray.length;
        if (conditionCount > 0) {
          filterMenus = generateHashMap(conditionsArray);
        }
      }
    }

    return filterMenus;
  }

  Map<String, String> generateHashMap(List<String> conditionsArray) {
    Map<String, String> map = new Map();
    if (conditionsArray.length != 0) {
      for (int i = 0; i < conditionsArray.length; i++) {
        var filterArray = conditionsArray[i].split("=");
        print(" forvalue   $filterArray");
        if (filterArray.length > 1) {
          map[filterArray[0]] = filterArray[1];
        }
      }
    } else {}
    return map;
  }

  // _isVisible(bool isVisible) {
  //   setState(() {
  //     isVisible = isVisible;
  //   });
  // }
}
