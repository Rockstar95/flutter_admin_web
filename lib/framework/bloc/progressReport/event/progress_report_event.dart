import 'package:equatable/equatable.dart';

abstract class ProgressReportEvent extends Equatable {
  const ProgressReportEvent();
}

// ignore: must_be_immutable
class ProgressReportGraphEvent extends ProgressReportEvent {
  int aintComponentID = 0;
  int aintCompInsID = 0;
  int aintSelectedGroupValue = 0;

  ProgressReportGraphEvent({
    this.aintComponentID = 0,
    this.aintCompInsID = 0,
    this.aintSelectedGroupValue = 0,
  });

  @override
  List<Object> get props =>
      [aintComponentID, aintCompInsID, aintSelectedGroupValue];
}

class CourseSummaryEvent extends ProgressReportEvent {
  final int userID;
  final String cID;
  final int objectTypeId;
  final String startDate;
  final String endDate;
  final String seqID;
  final String trackID;

  CourseSummaryEvent(
      {this.userID = 0,
      this.cID = "",
      this.objectTypeId = 0,
      this.startDate = "",
      this.endDate = "",
      this.seqID = "",
      this.trackID = ""});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userID, cID, objectTypeId, startDate, endDate, seqID, trackID];
}

// ignore: must_be_immutable
class ProgressDetailDataEvent extends ProgressReportEvent {
  int userId = 0;
  String cID = "";
  int objectTypeId = 0;
  String startDate = "";
  String endDate = "";
  String seqID = "";
  String trackID = "";

  ProgressDetailDataEvent(
      {this.userId = 0,
      this.cID = "",
      this.objectTypeId = 0,
      this.startDate = "",
      this.endDate = "",
      this.seqID = "",
      this.trackID = ""});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, cID, objectTypeId, startDate, endDate, seqID, trackID];
}
