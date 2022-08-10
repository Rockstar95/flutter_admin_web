import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';

abstract class EventTrackEvent {
  const EventTrackEvent();
}

class GetTrackListData extends EventTrackEvent {
  final bool isInternet;
  final bool isTraxkList;
  final DummyMyCatelogResponseTable2 myLearningModel;
  final AppBloc appBloc;

  GetTrackListData(
      {this.isInternet = false,
      this.isTraxkList = false,
      required this.myLearningModel,
      required this.appBloc});

  @override
  List<Object> get props => [isInternet, isTraxkList, myLearningModel];
}

class TrackAddtoArchiveCall extends EventTrackEvent {
  bool isArchive = false;
  String strContentID = "";

  TrackAddtoArchiveCall({this.isArchive = false, this.strContentID = ""});

  @override
  List<Object> get props => [isArchive, strContentID];
}

class TrackRemovetoArchiveCall extends EventTrackEvent {
  bool isArchive = false;
  String strContentID = "";

  TrackRemovetoArchiveCall({this.isArchive = false, this.strContentID = ""});

  @override
  List<Object> get props => [isArchive, strContentID];
}

class TrackCancelEnrollment extends EventTrackEvent {
  String isBadCancel = "";
  String strContentID = "";

  TrackCancelEnrollment({this.isBadCancel = "", this.strContentID = ""});

  @override
  List<Object> get props => [isBadCancel, strContentID];
}

class TrackRemoveFromMyLearning extends EventTrackEvent {
  String contentId = "";

  TrackRemoveFromMyLearning({this.contentId = ""});

  @override
  List<Object> get props => [contentId];
}

class TrackSetComplete extends EventTrackEvent {
  String contentId = "";
  String scoId = "";
  DummyMyCatelogResponseTable2 table2;

  TrackSetComplete(
      {this.contentId = "", this.scoId = "", required this.table2});

  @override
  List<Object> get props => [contentId];
}

class TrackListResources extends EventTrackEvent {
  String contentId = "";

  TrackListResources({this.contentId = ""});

  @override
  List<Object> get props => [contentId];
}

class TrackListGlossary extends EventTrackEvent {
  String contentId = "";

  TrackListGlossary({this.contentId = ""});

  @override
  List<Object> get props => [contentId];
}

class TrackListOverView extends EventTrackEvent {
  String contentId = "";
  int objecttypeid = 0;
  String userId = "";

  TrackListOverView(
      {this.contentId = "", this.objecttypeid = 0, this.userId = ""});

  @override
  List<Object> get props => [contentId];
}

class TrackGetContentStatus extends EventTrackEvent {
  String url = "";
  DummyMyCatelogResponseTable2 table2;

  TrackGetContentStatus({this.url = "", required this.table2});

  @override
  List<Object> get props => [url];
}

class ParentTrackGetContentStatus extends EventTrackEvent {
  String url = "";
  DummyMyCatelogResponseTable2 table2;

  ParentTrackGetContentStatus({this.url = "", required this.table2});

  @override
  List<Object> get props => [url];
}

class BadCancelEnrollment extends EventTrackEvent {
  String contentid = "";

  BadCancelEnrollment({this.contentid = ""});

  @override
  List<Object> get props => [contentid];
}

class DownloadCompleteEvent extends EventTrackEvent {
  String contentId = "";
  int scoID = 0;

  DownloadCompleteEvent({this.contentId = "", this.scoID = 0});
}
