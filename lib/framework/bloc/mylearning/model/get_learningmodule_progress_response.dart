// To parse this JSON data, do
//
//     final geLearningModuleProgressDataResponse = geLearningModuleProgressDataResponseFromJson(jsonString);

import 'dart:convert';

GeLearningModuleProgressDataResponse
    geLearningModuleProgressDataResponseFromJson(String str) =>
        GeLearningModuleProgressDataResponse.fromJson(json.decode(str));

String geLearningModuleProgressDataResponseToJson(
        GeLearningModuleProgressDataResponse data) =>
    json.encode(data.toJson());

class GeLearningModuleProgressDataResponse {
  GeLearningModuleProgressDataResponse({
    required this.table,
    required this.table1,
    required this.table2,
    required this.table3,
    required this.table4,
    required this.table5,
    required this.table6,
  });

  List<Table> table = [];
  List<Table1> table1 = [];
  List<Table2> table2 = [];
  List<Table3> table3 = [];
  List<dynamic> table4 = [];
  List<dynamic> table5 = [];
  List<Table6> table6 = [];

  factory GeLearningModuleProgressDataResponse.fromJson(
          Map<String, dynamic> json) =>
      GeLearningModuleProgressDataResponse(
        table: json["Table"] == null
            ? []
            : List<Table>.from(json["Table"].map((x) => Table.fromJson(x))),
        table1: json["Table1"] == null
            ? []
            : List<Table1>.from(json["Table1"].map((x) => Table1.fromJson(x))),
        table2: json["Table2"] == null
            ? []
            : List<Table2>.from(json["Table2"].map((x) => Table2.fromJson(x))),
        table3: json["Table3"] == null
            ? []
            : List<Table3>.from(json["Table3"].map((x) => Table3.fromJson(x))),
        table4: json["Table4"] == null
            ? []
            : List<dynamic>.from(json["Table4"].map((x) => x)),
        table5: json["Table5"] == null
            ? []
            : List<dynamic>.from(json["Table5"].map((x) => x)),
        table6: json["Table6"] == null
            ? []
            : List<Table6>.from(json["Table6"].map((x) => Table6.fromJson(x))),
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
        "Table3": table3 == null
            ? null
            : List<dynamic>.from(table3.map((x) => x.toJson())),
        "Table4":
            table4 == null ? null : List<dynamic>.from(table4.map((x) => x)),
        "Table5":
            table5 == null ? null : List<dynamic>.from(table5.map((x) => x)),
        "Table6": table6 == null
            ? null
            : List<dynamic>.from(table6.map((x) => x.toJson())),
      };
}

class Table {
  Table({
    this.pageId = "",
    this.pageQuestionTitle = "",
    this.type = "",
    this.contentId,
    this.questionNo,
    this.folderPath,
    this.questionTitle = "",
    this.questionNumber = "",
    this.status = "",
    this.actions,
  });

  String pageId = "";
  String pageQuestionTitle = "";
  String type = "";
  dynamic contentId;
  dynamic questionNo;
  dynamic folderPath;
  String questionTitle = "";
  String questionNumber = "";
  String status = "";
  dynamic actions;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        pageId: json["PageID"] == null ? null : json["PageID"],
        pageQuestionTitle: json["Page/Question Title"] == null
            ? null
            : json["Page/Question Title"],
        type: json["Type"] == null ? null : json["Type"],
        contentId: json["ContentID"],
        questionNo: json["Question No."],
        folderPath: json["FolderPath"],
        questionTitle:
            json["QuestionTitle"] == null ? null : json["QuestionTitle"],
        questionNumber:
            json["QuestionNumber"] == null ? null : json["QuestionNumber"],
        status: json["Status"] == null ? null : json["Status"],
        actions: json["Actions"],
      );

  Map<String, dynamic> toJson() => {
        "PageID": pageId == null ? null : pageId,
        "Page/Question Title":
            pageQuestionTitle == null ? null : pageQuestionTitle,
        "Type": type == null ? null : type,
        "ContentID": contentId,
        "Question No.": questionNo,
        "FolderPath": folderPath,
        "QuestionTitle": questionTitle == null ? null : questionTitle,
        "QuestionNumber": questionNumber == null ? null : questionNumber,
        "Status": status == null ? null : status,
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
    this.suspendData = "",
  });

  String suspendData = "";

  factory Table2.fromJson(Map<String, dynamic> json) => Table2(
        suspendData: json["SuspendData"] == null ? null : json["SuspendData"],
      );

  Map<String, dynamic> toJson() => {
        "SuspendData": suspendData == null ? null : suspendData,
      };
}

class Table3 {
  Table3({
    this.title = "",
  });

  String title = "";

  factory Table3.fromJson(Map<String, dynamic> json) => Table3(
        title: json["Title"] == null ? null : json["Title"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title == null ? null : title,
      };
}

class Table6 {
  Table6({
    this.statustype = "",
  });

  String statustype = "";

  factory Table6.fromJson(Map<String, dynamic> json) => Table6(
        statustype: json["statustype"] == null ? null : json["statustype"],
      );

  Map<String, dynamic> toJson() => {
        "statustype": statustype == null ? null : statustype,
      };
}
