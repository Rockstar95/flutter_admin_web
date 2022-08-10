// To parse this JSON data, do
//
//     final getLearaningProgressDataResponse = getLearaningProgressDataResponseFromJson(jsonString);

import 'dart:convert';

GetLearaningProgressDataResponse getLearaningProgressDataResponseFromJson(
        String str) =>
    GetLearaningProgressDataResponse.fromJson(json.decode(str));

String getLearaningProgressDataResponseToJson(
        GetLearaningProgressDataResponse data) =>
    json.encode(data.toJson());

class GetLearaningProgressDataResponse {
  GetLearaningProgressDataResponse({
    required this.table,
    required this.table1,
    required this.table2,
  });

  List<Table> table = [];
  List<Table1> table1 = [];
  List<Table2> table2 = [];

  factory GetLearaningProgressDataResponse.fromJson(
          Map<String, dynamic> json) =>
      GetLearaningProgressDataResponse(
        table: json["Table"] == null
            ? []
            : List<Table>.from(json["Table"].map((x) => Table.fromJson(x))),
        table1: json["Table1"] == null
            ? []
            : List<Table1>.from(json["Table1"].map((x) => Table1.fromJson(x))),
        table2: json["Table2"] == null
            ? []
            : List<Table2>.from(json["Table2"].map((x) => Table2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": table == null
            ? null
            : List<dynamic>.from(table.map((x) => x.toJson())),
        "Table1": table1 == null
            ? null
            : List<dynamic>.from(table1.map((x) => x.toJson())),
        "Table2": table2 == null
            ? null
            : List<dynamic>.from(table2.map((x) => x.toJson())),
      };
}

class Table {
  Table({
    this.trackId = "",
    this.scoid = 0,
    this.contentId = "",
    this.contentItemTitle = "",
    this.objectTypeId = 0,
    this.type = "",
    this.coreLessonStatus = "",
    this.scoreRaw = "",
    this.sequenceNumber = 0,
    this.accessedInThisPeriod,
    this.attemptsInThisPeriod,
    this.percentCompleted = "",
    this.progress = "",
    this.isTrackable = 0,
    this.isAdministrativelySet = false,
    this.startedOn,
    this.completedOn,
    this.lastAccessedInThisPeriod,
    this.mediaTypeId,
    this.paReportLink,
    this.daReportLink,
    this.tableContentItemTitle = "",
    this.status = "",
    this.result = "",
    this.score = "",
    this.actions,
  });

  String trackId = "";
  int scoid = 0;
  String contentId = "";
  String contentItemTitle = "";
  int objectTypeId = 0;
  String type = "";
  String coreLessonStatus = "";
  String scoreRaw = "";
  int sequenceNumber = 0;
  dynamic accessedInThisPeriod;
  dynamic attemptsInThisPeriod;
  String percentCompleted = "";
  String progress = "";
  int isTrackable = 0;
  bool isAdministrativelySet = false;
  DateTime? startedOn;
  DateTime? completedOn;
  DateTime? lastAccessedInThisPeriod;
  dynamic mediaTypeId;
  dynamic paReportLink;
  dynamic daReportLink;
  String tableContentItemTitle = "";
  String status = "";
  String result = "";
  String score = "";
  dynamic actions;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        trackId: json["TrackID"] == null ? null : json["TrackID"],
        scoid: json["SCOID"] == null ? null : json["SCOID"],
        contentId: json["ContentID"] == null ? null : json["ContentID"],
        contentItemTitle: json["Content Item Title"] == null
            ? null
            : json["Content Item Title"],
        objectTypeId:
            json["ObjectTypeID"] == null ? null : json["ObjectTypeID"],
        type: json["Type"] == null ? null : json["Type"],
        coreLessonStatus:
            json["CoreLessonStatus"] == null ? null : json["CoreLessonStatus"],
        scoreRaw: json["ScoreRaw"] == null ? null : json["ScoreRaw"],
        sequenceNumber:
            json["SequenceNumber"] == null ? null : json["SequenceNumber"],
        accessedInThisPeriod: json["# Accessed in this period"],
        attemptsInThisPeriod: json["# Attempts In This Period"],
        percentCompleted:
            json["PercentCompleted"] == null ? null : json["PercentCompleted"],
        progress: json["Progress"] == null ? null : json["Progress"],
        isTrackable: json["IsTrackable"] == null ? null : json["IsTrackable"],
        isAdministrativelySet: json["isAdministrativelySet"] == null
            ? null
            : json["isAdministrativelySet"],
        startedOn: json["Started On"] == null
            ? null
            : DateTime.parse(json["Started On"]),
        completedOn: json["Completed On"] == null
            ? null
            : DateTime.parse(json["Completed On"]),
        lastAccessedInThisPeriod: json["Last Accessed in this period"] == null
            ? null
            : DateTime.parse(json["Last Accessed in this period"]),
        mediaTypeId: json["MediaTypeID"],
        paReportLink: json["PAReportLink"],
        daReportLink: json["DAReportLink"],
        tableContentItemTitle:
            json["ContentItemTitle"] == null ? null : json["ContentItemTitle"],
        status: json["Status"] == null ? null : json["Status"],
        result: json["Result"] == null ? null : json["Result"],
        score: json["Score"] == null ? null : json["Score"],
        actions: json["Actions"],
      );

  Map<String, dynamic> toJson() => {
        "TrackID": trackId == null ? null : trackId,
        "SCOID": scoid == null ? null : scoid,
        "ContentID": contentId == null ? null : contentId,
        "Content Item Title":
            contentItemTitle == null ? null : contentItemTitle,
        "ObjectTypeID": objectTypeId == null ? null : objectTypeId,
        "Type": type == null ? null : type,
        "CoreLessonStatus": coreLessonStatus == null ? null : coreLessonStatus,
        "ScoreRaw": scoreRaw == null ? null : scoreRaw,
        "SequenceNumber": sequenceNumber == null ? null : sequenceNumber,
        "# Accessed in this period": accessedInThisPeriod,
        "# Attempts In This Period": attemptsInThisPeriod,
        "PercentCompleted": percentCompleted == null ? null : percentCompleted,
        "Progress": progress == null ? null : progress,
        "IsTrackable": isTrackable == null ? null : isTrackable,
        "isAdministrativelySet":
            isAdministrativelySet == null ? null : isAdministrativelySet,
        "Started On": startedOn == null ? null : startedOn?.toIso8601String(),
        "Completed On":
            completedOn == null ? null : completedOn?.toIso8601String(),
        "Last Accessed in this period": lastAccessedInThisPeriod == null
            ? null
            : lastAccessedInThisPeriod?.toIso8601String(),
        "MediaTypeID": mediaTypeId,
        "PAReportLink": paReportLink,
        "DAReportLink": daReportLink,
        "ContentItemTitle":
            tableContentItemTitle == null ? null : tableContentItemTitle,
        "Status": status == null ? null : status,
        "Result": result == null ? null : result,
        "Score": score == null ? null : score,
        "Actions": actions,
      };
}

class Table1 {
  Table1({
    this.userName = "",
    this.userStatus = 0,
  });

  String userName = "";
  int userStatus = 0;

  factory Table1.fromJson(Map<String, dynamic> json) => Table1(
        userName: json["UserName"] == null ? null : json["UserName"],
        userStatus: json["UserStatus"] == null ? null : json["UserStatus"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName == null ? null : userName,
        "UserStatus": userStatus == null ? null : userStatus,
      };
}

class Table2 {
  Table2({
    this.title = "",
  });

  String title = "";

  factory Table2.fromJson(Map<String, dynamic> json) => Table2(
        title: json["Title"] == null ? null : json["Title"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title == null ? null : title,
      };
}
