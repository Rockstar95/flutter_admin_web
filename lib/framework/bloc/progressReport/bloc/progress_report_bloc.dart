import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_admin_web/framework/bloc/progressReport/event/progress_report_event.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/model/course_summary_response.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/model/progress_detail_data_response.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/model/progress_report_graph_response.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/state/progress_report_state.dart';
import 'package:flutter_admin_web/framework/repository/progressReport/progress_report_repositry_builder.dart';
import 'package:intl/intl.dart';

class ProgressReportBloc
    extends Bloc<ProgressReportEvent, ProgressReportState> {
  bool isFirstLoading = false;
  final formatter = DateFormat('dd/MM/yyyy');
  final formatter1 = DateFormat('MM/dd/yyyy');
  var compareDateFormatter = DateFormat('yyyy-MM-dd');
  List<ProgressReportGraphResponse> progressReportGraphResponse = [];
  List<ContentCountData> contentCount = [];
  List<StatusCountData> statusContentCount = [];
  List<ScoreCount> scoreCount = [];
  List<ScoreMaxCount> scoreMaxCount = [];
  final bool animate;
  int endAngle = 0;
  int endAngle1 = 0;
  List<CourseSummaryResponse> courseSummaryList = [];
  ProgressDetailDataResponse progressDetailDataResponse =
      ProgressDetailDataResponse(
          progressDetail: [], table1: [], table3: [], table6: []);
  ProgressReportRepository progressReportRepository;

  ProgressReportBloc(
      {required this.progressReportRepository, this.animate = false})
      : super(ProgressReportState.completed(null)) {
    on<ProgressReportGraphEvent>(onEventHandler);
    on<CourseSummaryEvent>(onEventHandler);
    on<ProgressDetailDataEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(ProgressReportEvent event, Emitter emit) async {
    print("ProgressReportBloc onEventHandler called for ${event.runtimeType}");
    Stream<ProgressReportState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (ProgressReportState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  ProgressReportState get initialState => ProgressReportState.completed('data');

  @override
  Stream<ProgressReportState> mapEventToState(
      ProgressReportEvent event) async* {
    // TODO: implement mapEventToState
    try {
      if (event is ProgressReportGraphEvent) {
        isFirstLoading = true;
        yield ProgressReportGraphState.loading('Please wait');
        Response? apiResponse =
            await progressReportRepository.getConsolidatePRT(
                aintComponentID: event.aintComponentID,
                aintCompInsID: event.aintCompInsID,
                aintSelectedGroupValue: event.aintSelectedGroupValue);
        if (apiResponse?.statusCode == 200) {
          progressReportGraphResponse = progressReportGraphResponseFromJson(apiResponse?.body ?? "[]");

          contentCount.clear();
          statusContentCount.clear();
          scoreCount.clear();
          scoreMaxCount.clear();
          for (int i = 0; i < progressReportGraphResponse.length; i++) {
            contentCount.addAll(progressReportGraphResponse[i].contentCountData);
            statusContentCount.addAll(progressReportGraphResponse[i].statusCountData);
            if (progressReportGraphResponse[i].scoreCount.length != 0) {
              scoreCount.add(progressReportGraphResponse[i].scoreCount[0]);
              scoreCount.add(ScoreCount(overallscore: 100 - progressReportGraphResponse[i].scoreCount[0].overallscore));

              // endAngle = 360 -
              //     progressReportGraphResponse[i].scoreCount[0].overallscore;
            }
            if (progressReportGraphResponse[i].scoreMaxCount.length != 0) {
              scoreMaxCount.add(progressReportGraphResponse[i].scoreMaxCount[0]);
              scoreMaxCount.add(ScoreMaxCount(scoreMax: 100 - progressReportGraphResponse[i].scoreMaxCount[0].scoreMax));

              // endAngle1 = 360 -
              //     progressReportGraphResponse[i].scoreMaxCount[0].scoreMax;
            }
          }
          yield ProgressReportGraphState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield ProgressReportGraphState.error('401');
        } else {
          yield ProgressReportGraphState.error('Something went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      } else if (event is CourseSummaryEvent) {
        print('skjdfsd : ' + event.userID.toString());
        isFirstLoading = true;
        yield CourseSummaryState.loading('Please  wait');
        Response? apiResponse = await progressReportRepository.getCourseSummary(
            userID: event.userID,
            cID: event.cID,
            objectTypeId: event.objectTypeId,
            startDate: event.startDate,
            endDate: event.endDate,
            seqID: event.seqID,
            trackID: event.trackID);
        if (apiResponse?.statusCode == 200) {
          List<CourseSummaryResponse> response =
              courseSummaryResponseFromJson(apiResponse?.body ?? "[]");
          courseSummaryList = response;
          yield CourseSummaryState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield CourseSummaryState.error('401');
        } else {
          yield CourseSummaryState.error('Something went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      } else if (event is ProgressDetailDataEvent) {
        yield ProgressDetailDataState.loading('Please wait');
        Response? apiResponse =
            await progressReportRepository.getProgressDetailData(
                userID: event.userId,
                cID: event.cID,
                objectTypeId: event.objectTypeId,
                startDate: event.startDate,
                endDate: event.endDate,
                seqID: event.seqID,
                trackID: event.trackID);
        if (apiResponse?.statusCode == 200) {
          progressDetailDataResponse =
              progressDetailDataResponseFromJson(apiResponse?.body ?? "{}");
          yield ProgressDetailDataState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield ProgressDetailDataState.error('401');
        } else {
          yield ProgressDetailDataState.error('Something went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      }
    } catch (e, s) {
      print("Error in ProgressReportBloc.mapEventToState():$e");
      print(s);
    }
  }

  String getDifference(DateTime d1, DateTime d2) {
    String result = '';

    /** in milliseconds */
    var diff = d2.difference(d1);

    var day = diff.inDays;
    var hour = diff.inHours;
    var minutes = diff.inMinutes;
    var sec = diff.inSeconds;

    print("####### :" +
        day.toString() +
        " " +
        hour.toString() +
        " " +
        hour.toString() +
        " " +
        minutes.toString() +
        " " +
        sec.toString());

    result = day.toString() + "d ";
    result += hour.toString() + "h ";
    result += minutes.toString() + "m ";
    result += sec.toString() + "s ";

    return result;
  }
}
