import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/event_recording_resonse.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/waiting_list_response.dart';

class EvntModuleState extends ApiState {
  final bool displayMessage;
  bool isSuccess = false;

  /// Pass data to the base API class
  EvntModuleState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  EvntModuleState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  EvntModuleState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class InitialEventState extends EvntModuleState {
  bool isSucces = false;

  InitialEventState.loading(data) : super.loading(data);

  InitialEventState.completed(data) : super.completed(data);

  InitialEventState.error(data) : super.error(data);
}

class GetPeopleListingTabState extends EvntModuleState {
  bool isSucces = false;

  GetPeopleListingTabState.loading(data) : super.loading(data);

  GetPeopleListingTabState.completed({this.isSucces = false})
      : super.completed(isSucces);

  GetPeopleListingTabState.error(data) : super.error(data);
}

class GetTabContentState extends EvntModuleState {
  bool isSucces = false;

  GetTabContentState.loading(data) : super.loading(data);

  GetTabContentState.completed({this.isSucces = false})
      : super.completed(isSucces);

  GetTabContentState.error(data) : super.error(data);
}

class GetSessionEventState extends EvntModuleState {
  bool isSucces = false;

  GetSessionEventState.loading(data) : super.loading(data);

  GetSessionEventState.completed({this.isSucces = false})
      : super.completed(isSucces);

  GetSessionEventState.error(data) : super.error(data);
}

class CancelEnrollmentState extends EvntModuleState {
  String isSucces = "";
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  CancelEnrollmentState.loading(data) : super.loading(data);

  CancelEnrollmentState.completed({this.isSucces = "", required this.table2})
      : super.completed(isSucces);

  CancelEnrollmentState.error(data) : super.error(data);
}

class BadCancelEnrollmentState extends EvntModuleState {
  String isSucces = "";
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  BadCancelEnrollmentState.loading(data) : super.loading(data);

  BadCancelEnrollmentState.completed({this.isSucces = "", required this.table2})
      : super.completed(isSucces);

  BadCancelEnrollmentState.error(data) : super.error(data);
}

class ExpiryEventState extends EvntModuleState {
  String isSucces = "";
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  ExpiryEventState.loading(data) : super.loading(data);

  ExpiryEventState.completed({this.isSucces = "", required this.table2})
      : super.completed(isSucces);

  ExpiryEventState.error(data) : super.error(data);
}

class WaitingListState extends EvntModuleState {
  String isSucces = "";
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
  WaitingListResponse waitingListResponse = WaitingListResponse();

  WaitingListState.loading(data) : super.loading(data);

  WaitingListState.completed(
      {this.isSucces = "",
      required this.table2,
      required this.waitingListResponse})
      : super.completed(isSucces);

  WaitingListState.error(data) : super.error(data);
}

class ViewRecordingState extends EvntModuleState {
  bool isSucces = false;
  EventRecordingResponse eventRecordingResponse = EventRecordingResponse();

  ViewRecordingState.loading(data) : super.loading(data);

  ViewRecordingState.completed(
      {this.isSucces = false, required this.eventRecordingResponse})
      : super.completed(isSucces);

  ViewRecordingState.error(data) : super.error(data);
}

class DownloadCompleteState extends EvntModuleState {
  bool isSucces = false;

  DownloadCompleteState.loading(data) : super.loading(data);

  DownloadCompleteState.completed({this.isSucces = false})
      : super.completed(isSucces);

  DownloadCompleteState.error(data) : super.error(data);
}
