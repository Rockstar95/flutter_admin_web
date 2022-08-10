import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';

abstract class EvntModuleEvent {
  const EvntModuleEvent();
}

class GetPeopleListingTab extends EvntModuleEvent {
  GetPeopleListingTab();

  @override
  List<Object> get props => [];
}

class GetTabContent extends EvntModuleEvent {
  String tabVal = "";
  String searchString = "";
  MyLearningBloc myLearningBloc;
  int pageIndex = 0;

  GetTabContent(
      {this.tabVal = "",
      this.searchString = "",
      required this.myLearningBloc,
      this.pageIndex = 0});

  @override
  List<Object> get props => [tabVal, searchString, myLearningBloc, pageIndex];
}

class GetEventWishlistContent extends EvntModuleEvent {
  String tabVal = "";

  GetEventWishlistContent({this.tabVal = ""});

  @override
  List<Object> get props => [tabVal];
}

class GetCalanderFilterListContent extends EvntModuleEvent {
  String startDate = "";

  GetCalanderFilterListContent({this.startDate = ""});

  @override
  List<Object> get props => [startDate];
}

class EventSession extends EvntModuleEvent {
  String contentid = "";

  EventSession({this.contentid = ""});

  @override
  List<Object> get props => [contentid];
}

class BadCancelEnrollment extends EvntModuleEvent {
  String contentid = "";
  DummyMyCatelogResponseTable2 table2;

  BadCancelEnrollment({this.contentid = "", required this.table2});

  @override
  List<Object> get props => [contentid];
}

class TrackCancelEnrollment extends EvntModuleEvent {
  String isBadCancel = "";
  String strContentID = "";
  DummyMyCatelogResponseTable2 table2;

  TrackCancelEnrollment(
      {this.isBadCancel = "", this.strContentID = "", required this.table2});

  @override
  List<Object> get props => [isBadCancel, strContentID];
}

class AddExpiryEvent extends EvntModuleEvent {
  String strContentID = "";
  DummyMyCatelogResponseTable2 table2;

  AddExpiryEvent({this.strContentID = "", required this.table2});

  @override
  List<Object> get props => [strContentID];
}

class WaitingListEvent extends EvntModuleEvent {
  String strContentID = "";
  DummyMyCatelogResponseTable2 table2;

  WaitingListEvent({this.strContentID = "", required this.table2});

  @override
  List<Object> get props => [strContentID];
}

class ViewRecordingEvent extends EvntModuleEvent {
  String strContentID = "";
  DummyMyCatelogResponseTable2 table2;

  ViewRecordingEvent({this.strContentID = "", required this.table2});

  @override
  List<Object> get props => [strContentID];
}

class DownloadCompleteEvent extends EvntModuleEvent {
  String contentId = "";
  int ScoID = 0;

  DownloadCompleteEvent({this.contentId = "", this.ScoID = 0});
}
