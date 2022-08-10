import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';
import 'package:flutter_admin_web/framework/repository/general/model/content_status_response.dart';

class EventTrackState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  EventTrackState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  EventTrackState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  EventTrackState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class IntitialEventTrackStat extends EventTrackState {
  IntitialEventTrackStat.completed(data) : super.completed(data);
}

class GetTrackListState extends EventTrackState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetTrackListState.loading(data) : super.loading(data);

  GetTrackListState.completed({required this.list}) : super.completed(list);

  GetTrackListState.error(data) : super.error(data);
}

class TrackAddtoArchiveCallState extends EventTrackState {
  bool isScusses = false;

  TrackAddtoArchiveCallState.loading(data) : super.loading(data);

  TrackAddtoArchiveCallState.completed({this.isScusses = false})
      : super.completed(isScusses);

  TrackAddtoArchiveCallState.error(data) : super.error(data);
}

class TrackRemovetoArchiveCallState extends EventTrackState {
  bool isScusses = false;

  TrackRemovetoArchiveCallState.loading(data) : super.loading(data);

  TrackRemovetoArchiveCallState.completed({this.isScusses = false})
      : super.completed(isScusses);

  TrackRemovetoArchiveCallState.error(data) : super.error(data);
}

class TrackRemoveFromMyLearningState extends EventTrackState {
  bool response = false;

  TrackRemoveFromMyLearningState.loading(data) : super.loading(data);

  TrackRemoveFromMyLearningState.completed({this.response = false})
      : super.completed(response);

  TrackRemoveFromMyLearningState.error(data) : super.error(data);
}

class TrackListResourceState extends EventTrackState {
  bool response = false;

  TrackListResourceState.loading(data) : super.loading(data);

  TrackListResourceState.completed({this.response = false})
      : super.completed(response);

  TrackListResourceState.error(data) : super.error(data);
}

class TrackListGlossaryState extends EventTrackState {
  bool response = false;

  TrackListGlossaryState.loading(data) : super.loading(data);

  TrackListGlossaryState.completed({this.response = false})
      : super.completed(response);

  TrackListGlossaryState.error(data) : super.error(data);
}

class TrackSetCompleteState extends EventTrackState {
  bool isCompleted = false;
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  TrackSetCompleteState.loading(data) : super.loading(data);

  TrackSetCompleteState.completed(
      {this.isCompleted = false, required this.table2})
      : super.completed(isCompleted);

  TrackSetCompleteState.error(data) : super.error(data);
}

class TrackListOverViewState extends EventTrackState {
  bool isCompleted = false;

  TrackListOverViewState.loading(data) : super.loading(data);

  TrackListOverViewState.completed({this.isCompleted = false})
      : super.completed(isCompleted);

  TrackListOverViewState.error(data) : super.error(data);
}

class TrackGetContentStatusState extends EventTrackState {
  Contentstatus contentstatus = Contentstatus();
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  TrackGetContentStatusState.loading(data) : super.loading(data);

  TrackGetContentStatusState.completed(
      {required this.contentstatus, required this.table2})
      : super.completed(contentstatus);

  TrackGetContentStatusState.error(data) : super.error(data);
}

class ParentTrackGetContentStatusState extends EventTrackState {
  Contentstatus contentstatus = Contentstatus();
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  ParentTrackGetContentStatusState.loading(data) : super.loading(data);

  ParentTrackGetContentStatusState.completed(
      {required this.contentstatus, required this.table2})
      : super.completed(contentstatus);

  ParentTrackGetContentStatusState.error(data) : super.error(data);
}

class CancelEnrollmentState extends EventTrackState {
  String isSuccess = "";

  CancelEnrollmentState.loading(data) : super.loading(data);

  CancelEnrollmentState.completed({this.isSuccess = ""})
      : super.completed(isSuccess);

  CancelEnrollmentState.error(data) : super.error(data);
}

class BadCancelEnrollmentState extends EventTrackState {
  String isSuccess = "";

  BadCancelEnrollmentState.loading(data) : super.loading(data);

  BadCancelEnrollmentState.completed({this.isSuccess = ""})
      : super.completed(isSuccess);

  BadCancelEnrollmentState.error(data) : super.error(data);
}

class DownloadCompleteState extends EventTrackState {
  bool isSuccess = false;

  DownloadCompleteState.loading(data) : super.loading(data);

  DownloadCompleteState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  DownloadCompleteState.error(data) : super.error(data);
}
