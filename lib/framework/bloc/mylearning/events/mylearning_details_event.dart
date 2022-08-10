import 'package:equatable/equatable.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';

abstract class MyLearningDetailsEvent extends Equatable {
  const MyLearningDetailsEvent();
}

class GetLearningDetails extends MyLearningDetailsEvent {
  final MyLearningDetailsRequest myLearningDetailsRequest;

  GetLearningDetails({required this.myLearningDetailsRequest});

  @override
  List<Object> get props => [myLearningDetailsRequest];
}

class GetDetailsReviewEvent extends MyLearningDetailsEvent {
  final String contentId;
  final int skippedRows;

  GetDetailsReviewEvent({this.contentId = "", this.skippedRows = 0});

  @override
  List<Object> get props => [contentId, skippedRows];
}

class SetCompleteEvent extends MyLearningDetailsEvent {
  final DummyMyCatelogResponseTable2 table2;
  final DummyMyCatelogResponseTable2? eventTrackModel;
  final bool isTrackListItem;

  SetCompleteEvent({
    required this.table2,
    this.eventTrackModel,
    this.isTrackListItem = false,
  });

  @override
  List<Object> get props => [table2];
}

class GetCerificateEvent extends MyLearningDetailsEvent {
  final String contentId;
  final String scoId;
  final String certificateId;
  final String certificatePage;
  final String siteId;
  final String siteUrl;

  GetCerificateEvent(
      {this.contentId = "",
      this.scoId = "",
      this.certificateId = "",
      this.certificatePage = "",
      this.siteId = "",
      this.siteUrl = ""});

  @override
  List<Object> get props =>
      [contentId, scoId, certificatePage, certificateId, siteId, siteUrl];
}

class GetContentStatus extends MyLearningDetailsEvent {
  final String url;
  final DummyMyCatelogResponseTable2? table2;

  GetContentStatus({this.url = "", this.table2});

  @override
  List<Object> get props => [url];
}
