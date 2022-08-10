// To parse this JSON data, do
//
//     final getSummaryDataResponse = getSummaryDataResponseFromJson(jsonString);

import 'dart:convert';

List<GetSummaryDataResponse> getSummaryDataResponseFromJson(String str) =>
    List<GetSummaryDataResponse>.from(
        json.decode(str).map((x) => GetSummaryDataResponse.fromJson(x)));

String getSummaryDataResponseToJson(List<GetSummaryDataResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSummaryDataResponse {
  GetSummaryDataResponse({
    this.assignedDate = "",
    this.dateStarted = "",
    this.dateCompleted = "",
    this.totalTimeSpent = "",
    this.numberofTimesAccessedinthisperiod = 0,
    this.numberofattemptsinthisperiod = "",
    this.lastAccessedInThisPeriod = "",
    this.status = "",
    this.result = "",
    this.percentageCompleted = "",
    this.score = "",
    this.targetDate = "",
    this.contentName = "",
    this.contentType = "",
    this.mediaTypeId = 0,
    this.jwVideo = "",
  });

  String assignedDate = "";
  String dateStarted = "";
  String dateCompleted = "";
  String totalTimeSpent = "";
  int numberofTimesAccessedinthisperiod = 0;
  String numberofattemptsinthisperiod = "";
  String lastAccessedInThisPeriod = "";
  String status = "";
  String result = "";
  String percentageCompleted = "";
  String score = "";
  String targetDate = "";
  String contentName = "";
  String contentType = "";
  int mediaTypeId = 0;
  String jwVideo = "";

  factory GetSummaryDataResponse.fromJson(Map<String, dynamic> json) =>
      GetSummaryDataResponse(
        assignedDate: json["AssignedDate"] ?? "",
        dateStarted: json["DateStarted"] ?? "",
        dateCompleted: json["DateCompleted"] ?? "",
        totalTimeSpent: json["TotalTimeSpent"] ?? "",
        numberofTimesAccessedinthisperiod:
            json["NumberofTimesAccessedinthisperiod"] ?? 0,
        numberofattemptsinthisperiod:
            json["Numberofattemptsinthisperiod"] ?? "",
        lastAccessedInThisPeriod: json["LastAccessedInThisPeriod"] ?? "",
        status: json["Status"] ?? "",
        result: json["Result"] ?? "",
        percentageCompleted: json["PercentageCompleted"] ?? "",
        score: json["Score"] ?? "",
        targetDate: json["TargetDate"] ?? "",
        contentName: json["ContentName"] ?? "",
        contentType: json["ContentType"] ?? "",
        mediaTypeId: json["MediaTypeID"] ?? 0,
        jwVideo: json["JwVideo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "AssignedDate": assignedDate == null ? null : assignedDate,
        "DateStarted": dateStarted == null ? null : dateStarted,
        "DateCompleted": dateCompleted == null ? null : dateCompleted,
        "TotalTimeSpent": totalTimeSpent == null ? null : totalTimeSpent,
        "NumberofTimesAccessedinthisperiod":
            numberofTimesAccessedinthisperiod == null
                ? null
                : numberofTimesAccessedinthisperiod,
        "Numberofattemptsinthisperiod": numberofattemptsinthisperiod == null
            ? null
            : numberofattemptsinthisperiod,
        "LastAccessedInThisPeriod":
            lastAccessedInThisPeriod == null ? null : lastAccessedInThisPeriod,
        "Status": status == null ? null : status,
        "Result": result == null ? null : result,
        "PercentageCompleted":
            percentageCompleted == null ? null : percentageCompleted,
        "Score": score == null ? null : score,
        "TargetDate": targetDate == null ? null : targetDate,
        "ContentName": contentName == null ? null : contentName,
        "ContentType": contentType == null ? null : contentType,
        "MediaTypeID": mediaTypeId == null ? null : mediaTypeId,
        "JwVideo": jwVideo == null ? null : jwVideo,
      };
}
