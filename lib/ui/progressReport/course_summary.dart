import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/bloc/progress_report_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/event/progress_report_event.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/state/progress_report_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/progressReport/progress_report_repositry_builder.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../../configs/constants.dart';

class CourseSummary extends StatefulWidget {
  final String title;
  final String objectId;
  final int userId;
  final int objectTypeId;
  final String dateStarted;
  final String parentId;
  final String seqId;

  const CourseSummary(
      {this.title = '',
      this.objectId = '',
      this.userId = 0,
      this.objectTypeId = 0,
      this.dateStarted = '',
      this.parentId = '',
      this.seqId = ''});

  @override
  _CourseSummaryState createState() => _CourseSummaryState();
}

class _CourseSummaryState extends State<CourseSummary> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  var _controller = TextEditingController();
  var _toController = TextEditingController();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late ProgressReportBloc progressReportBloc;
  late FToast flutterToast;

  @override
  void initState() {
    super.initState();

    progressReportBloc = ProgressReportBloc(
        progressReportRepository: ProgressReportRepositoryBuilder.repository());

    _controller.text = widget.dateStarted.isNotEmpty
        ? widget.dateStarted
        : progressReportBloc.formatter1.format(DateTime.now());
    _toController.text = progressReportBloc.formatter1.format(DateTime.now());

    refresh(_controller.text, _toController.text);
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
      backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Report',
          style: TextStyle(
              fontSize: 18,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        actions: <Widget>[
          SizedBox(
            width: 10.h,
          ),
          SizedBox(
            width: 10.h,
          ),
        ],
      ),
      body: Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: summaryWidget(context, itemWidth, itemHeight),
              ),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              detailWidget(),
            ],
          ))),
    );
  }

  Widget summaryWidget(
      BuildContext context, double itemWidth, double itemHeight) {
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
              child: AppConstants().getLoaderWidget(iconSize: 70),
            ),
          );
        }
        else if (progressReportBloc.courseSummaryList.length == 0) {
          return noDataFound(true);
        }
        else {
          return Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      )),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: TextField(
                                controller: _controller,
                                onTap: () => _selectDate(context),
                                decoration: new InputDecoration(
                                    hintText: progressReportBloc
                                        .courseSummaryList[0].dateStarted,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.calendar_today,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      ),
                                      onPressed: () {},
                                    )),
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ))),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: TextField(
                          controller: _toController,
                          onTap: () => _toSelectDate(context),
                          decoration: new InputDecoration(
                              hintText: progressReportBloc.formatter1
                                  .format(DateTime.now()),
                              suffixStyle: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                ),
                                onPressed: () {},
                              )),
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      )),
                    ],
                  ),
                  Container(
                    width: 100,
                    child: MaterialButton(
                      onPressed: () => {
                        if (DateTime.parse(progressReportBloc
                                .compareDateFormatter
                                .format(progressReportBloc.formatter
                                    .parse(_controller.text)))
                            .isAfter(DateTime.parse(progressReportBloc
                                .compareDateFormatter
                                .format(progressReportBloc.formatter
                                    .parse(_toController.text)))))
                          {
                            flutterToast.showToast(
                                child: CommonToast(
                                    displaymsg:
                                        'From Date should not be greater than today\u0027s date To Date should be greater than or to From Date'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 4))
                          }
                        else
                          {refresh(_controller.text, _toController.text)}
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      disabledColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                          .withOpacity(0.5),
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      child: Text(
                        'Apply',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      textColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 15.0, left: 5.0, right: 5.0, bottom: 5.0),
                      child: Text(
                        'Summary',
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      )),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Status:',
                                style: TextStyle(
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ))),
                      Expanded(
                          child: Visibility(
                        visible: progressReportBloc
                            .courseSummaryList[0].assignedDate.isNotEmpty,
                        child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('Assigned Date​',
                                style: TextStyle(
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0))),
                      )),
                      Expanded(
                          child: Visibility(
                        visible: progressReportBloc
                            .courseSummaryList[0].targetDate.isNotEmpty,
                        child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Target Date​',
                              style: TextStyle(
                                  color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                      .withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            )),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              padding: const EdgeInsets.all(5.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: progressReportBloc.courseSummaryList[0].result.toString().contains('Completed')
                                      ? Color(0xff4ad963)
                                      : progressReportBloc.courseSummaryList[0].result.toString().contains('In Progress')
                                      ? Color(0xffff9503)
                                      : progressReportBloc.courseSummaryList[0].result.toString().contains('Not Started')
                                      ? Color(0xfffe2c53)
                                      : Color(0xff5750da),
                                  /*border: Border.all(
                                      color: progressReportBloc
                                              .courseSummaryList[0].result
                                              .toString()
                                              .contains('Completed')
                                          ? Color(0xff4ad963)
                                          : progressReportBloc
                                                  .courseSummaryList[0].result
                                                  .toString()
                                                  .contains('In Progress')
                                              ? Color(0xffff9503)
                                              : progressReportBloc
                                                      .courseSummaryList[0]
                                                      .result
                                                      .toString()
                                                      .contains('Not Started')
                                                  ? Color(0xfffe2c53)
                                                  : Color(0xff5750da)),*/
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                      progressReportBloc.courseSummaryList[0].result.isNotEmpty
                                          ? progressReportBloc
                                              .courseSummaryList[0].result
                                          : '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                          fontSize: 12.0))))),
                      Expanded(
                          child: Visibility(
                        visible: progressReportBloc
                            .courseSummaryList[0].assignedDate.isNotEmpty,
                        child: Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            padding: const EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                )),
                            child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  progressReportBloc.courseSummaryList[0]
                                          .assignedDate.isNotEmpty
                                      ? progressReportBloc
                                          .courseSummaryList[0].assignedDate
                                      : 'Not Started',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontSize: 12.0),
                                ))),
                      )),
                      Expanded(
                        child: Visibility(
                          visible: progressReportBloc
                              .courseSummaryList[0].targetDate.isNotEmpty,
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                  progressReportBloc.courseSummaryList[0]
                                          .targetDate.isNotEmpty
                                      // ? new DateFormat("d MMM yyyy").format(
                                      //     progressReportBloc.formatter.parse(
                                      //         progressReportBloc
                                      //             .courseSummaryList[0]
                                      //             .targetDate))
                                      ? progressReportBloc
                                          .courseSummaryList[0].targetDate
                                      : 'N/A',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontSize: 12.0))),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Started:',
                                style: TextStyle(
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ))),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Total Time Spent​',
                                style: TextStyle(
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ))),
                      Expanded(child: Container())
                      /*
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              )))
                      */
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                  progressReportBloc.courseSummaryList[0]
                                          .dateStarted.isEmpty
                                      ? 'N/A'
                                      : progressReportBloc
                                          .courseSummaryList[0].dateStarted,
                                  // : new DateFormat("d MMM yyyy").format(
                                  //     progressReportBloc.formatter.parse(
                                  //         progressReportBloc
                                  //             .courseSummaryList[0]
                                  //             .dateStarted)),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontSize: 12.0)))),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                progressReportBloc.courseSummaryList[0]
                                        .totalTimeSpent.isEmpty
                                    ? 'N/A'
                                    : progressReportBloc
                                        .courseSummaryList[0].totalTimeSpent,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontSize: 12.0),
                              ))),
                      Expanded(child: Container())
                      /*
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                                progressReportBloc.courseSummaryList[0]
                                        .dateCompleted.isNotEmpty
                                    ? progressReportBloc
                                        .courseSummaryList[0].dateCompleted
                                    // ? new DateFormat("d MMM yyyy").format(
                                    //     progressReportBloc.formatter.parse(
                                    //         progressReportBloc
                                    //             .courseSummaryList[0]
                                    //             .dateCompleted))
                                    : 'N/A',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontSize: 12.0))),
                      )
                      */
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Total accessed in this period​:',
                                style: TextStyle(
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ))),
                      Padding(
                        padding: EdgeInsets.only(right: 27.0),
                        child: Text(
                          'Score',
                          style: TextStyle(
                              color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                  .withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                  /* progressReportBloc.courseSummaryList[0]
                                      .numberofTimesAccessedinthisperiod == 0
                                      ? 'N/A'*/
                                  progressReportBloc.courseSummaryList[0]
                                      .numberofTimesAccessedinthisperiod
                                      .toString(),
                                  style: TextStyle(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontSize: 12.0)))),
                      Padding(
                        padding: EdgeInsets.only(right: 27.0),
                        child: Text(
                          progressReportBloc.courseSummaryList[0].score == null
                              ? 'N/A'
                              : progressReportBloc.courseSummaryList[0].score
                                  .toString(),
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Times Attempts In This Period​:',
                      style: TextStyle(
                          color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                              .withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        progressReportBloc.courseSummaryList[0]
                                .numberofattemptsinthisperiod.isEmpty
                            ? 'N/A'
                            : progressReportBloc.courseSummaryList[0]
                                .numberofattemptsinthisperiod,
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 12.0),
                      )),
                ],
              ),
            ),
          );
        }
      },
    );
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(new Duration(days: 30)),
      lastDate: new DateTime.now().add(new Duration(days: 30)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            accentColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            colorScheme: ColorScheme.light(
              primary: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? SizedBox(),
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _controller.text = progressReportBloc.formatter1.format(pickedDate);
      });
    }
  }

  Future<void> _toSelectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(new Duration(days: 30)),
      lastDate: new DateTime.now().add(new Duration(days: 30)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            accentColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            colorScheme: ColorScheme.light(
              primary: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? SizedBox(),
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _toController.text = progressReportBloc.formatter1.format(pickedDate);
      });
    }
  }

  Widget detailWidget() {
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
          if (state.status == Status.LOADING &&
              progressReportBloc.isFirstLoading == true) {
            return Container();
          } else if (progressReportBloc
                  .progressDetailDataResponse.progressDetail.length ==
              0) {
            return noDataFound(true);
          } else {
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: new Container(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                child: ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: progressReportBloc
                                .progressDetailDataResponse.progressDetail ==
                            null
                        ? 0
                        : progressReportBloc
                            .progressDetailDataResponse.progressDetail.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              progressReportBloc.progressDetailDataResponse
                                  .progressDetail[index].pageQuestionTitle,
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0, bottom: 5.0),
                                      child: Text(
                                        progressReportBloc
                                            .progressDetailDataResponse
                                            .progressDetail[index]
                                            .status,
                                        style: TextStyle(
                                            color: progressReportBloc
                                                        .progressDetailDataResponse
                                                        .progressDetail[index]
                                                        .status ==
                                                    'Correct'
                                                ? Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                : Colors.red.shade800),
                                      ))),
                              Visibility(
                                visible: progressReportBloc
                                            .progressDetailDataResponse
                                            .progressDetail[index]
                                            .folderPath.isNotEmpty
                                    ? false
                                    : false,
                                child: Container(
                                  width: 100,
                                  child: MaterialButton(
                                    onPressed: () => {},
                                    minWidth: MediaQuery.of(context).size.width,
                                    disabledColor: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.5),
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                    child: Text(
                                      'View',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                    textColor: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
            );
          }
        });
  }

  void refresh(String fromDate, String toDate) {
    progressReportBloc.add(CourseSummaryEvent(
        userID: widget.userId,
        cID: widget.objectId,
        objectTypeId: widget.objectTypeId,
        startDate: fromDate,
        endDate: toDate,
        seqID: widget.seqId,
        trackID: widget.parentId));

    progressReportBloc.add(ProgressDetailDataEvent(
        userId: widget.userId,
        cID: widget.objectId,
        objectTypeId: widget.objectTypeId,
        startDate: fromDate,
        endDate: toDate,
        seqID: widget.seqId,
        trackID: widget.parentId));
  }
}
