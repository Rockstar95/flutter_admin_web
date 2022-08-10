import 'package:flutter_admin_web/framework/bloc/progressReport/model/course_summary_response.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/model/progress_detail_data_response.dart';
import 'package:flutter_admin_web/framework/bloc/progressReport/model/progress_report_graph_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class ProgressReportState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  ProgressReportState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  ProgressReportState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  ProgressReportState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialProgressReportState extends ProgressReportState {
  IntitialProgressReportState.completed(data) : super.completed(data);
}

class ProgressReportGraphState extends ProgressReportState {
  ProgressReportGraphResponse? progressReportGraphResponse;

  ProgressReportGraphState.loading(data) : super.loading(data);

  ProgressReportGraphState.completed({this.progressReportGraphResponse})
      : super.completed(progressReportGraphResponse);

  ProgressReportGraphState.error(data) : super.error(data);
}

class CourseSummaryState extends ProgressReportState {
  CourseSummaryResponse? courseSummaryResponse;

  CourseSummaryState.loading(data) : super.loading(data);

  CourseSummaryState.completed({this.courseSummaryResponse})
      : super.completed(courseSummaryResponse);

  CourseSummaryState.error(data) : super.error(data);
}

class ProgressDetailDataState extends ProgressReportState {
  ProgressDetailDataResponse? progressDetailDataResponse;

  ProgressDetailDataState.loading(data) : super.loading(data);

  ProgressDetailDataState.completed({this.progressDetailDataResponse})
      : super.completed(progressDetailDataResponse);

  ProgressDetailDataState.error(data) : super.error(data);
}
