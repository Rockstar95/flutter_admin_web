import 'dart:convert';

List<CourseSummaryResponse> courseSummaryResponseFromJson(String str) =>
    List<CourseSummaryResponse>.from(
        json.decode(str).map((x) => CourseSummaryResponse.fromJson(x)));

dynamic courseSummaryResponseToJson(List<CourseSummaryResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseSummaryResponse {
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
  int mediaTypeID = 0;
  String jwVideo = "";

  CourseSummaryResponse(
      /*{this.assignedDate,
        this.dateStarted,
        this.dateCompleted,
        this.totalTimeSpent,
        this.numberofTimesAccessedinthisperiod,
        this.numberofattemptsinthisperiod,
        this.lastAccessedInThisPeriod,
        this.status,
        this.result,
        this.percentageCompleted,
        this.score,
        this.targetDate,
        this.contentName,
        this.contentType,
        this.mediaTypeID,
        this.jwVideo}*/
      );

  CourseSummaryResponse.fromJson(Map<String, dynamic> json) {
    assignedDate = json['AssignedDate'] ?? "";
    dateStarted = json['DateStarted'] ?? "";
    dateCompleted = json['DateCompleted'] ?? "";
    totalTimeSpent = json['TotalTimeSpent'] ?? "";
    numberofTimesAccessedinthisperiod =
        json['NumberofTimesAccessedinthisperiod'] ?? "";
    numberofattemptsinthisperiod = json['Numberofattemptsinthisperiod'] ?? 0;
    lastAccessedInThisPeriod = json['LastAccessedInThisPeriod'] ?? "";
    status = json['Status'] ?? "";
    result = json['Result'] ?? "";
    percentageCompleted = json['PercentageCompleted'] ?? "";
    score = json['Score'] ?? "";
    targetDate = json['TargetDate'] ?? "";
    contentName = json['ContentName'] ?? "";
    contentType = json['ContentType'] ?? "";
    mediaTypeID = json['MediaTypeID'] ?? 0;
    jwVideo = json['JwVideo'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AssignedDate'] = this.assignedDate;
    data['DateStarted'] = this.dateStarted;
    data['DateCompleted'] = this.dateCompleted;
    data['TotalTimeSpent'] = this.totalTimeSpent;
    data['NumberofTimesAccessedinthisperiod'] =
        this.numberofTimesAccessedinthisperiod;
    data['Numberofattemptsinthisperiod'] = this.numberofattemptsinthisperiod;
    data['LastAccessedInThisPeriod'] = this.lastAccessedInThisPeriod;
    data['Status'] = this.status;
    data['Result'] = this.result;
    data['PercentageCompleted'] = this.percentageCompleted;
    data['Score'] = this.score;
    data['TargetDate'] = this.targetDate;
    data['ContentName'] = this.contentName;
    data['ContentType'] = this.contentType;
    data['MediaTypeID'] = this.mediaTypeID;
    data['JwVideo'] = this.jwVideo;
    return data;
  }
}
