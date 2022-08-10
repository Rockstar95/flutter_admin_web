// To parse this JSON data, do
//
//     final getAssetProgressDataResponse = getAssetProgressDataResponseFromJson(jsonString);

import 'dart:convert';

GetAssetProgressDataResponse getAssetProgressDataResponseFromJson(String str) =>
    GetAssetProgressDataResponse.fromJson(json.decode(str));

String getAssetProgressDataResponseToJson(GetAssetProgressDataResponse data) =>
    json.encode(data.toJson());

class GetAssetProgressDataResponse {
  List<Table> table = [];
  List<Table1> table1 = [];
  List<Table2> table2 = [];
  List<Table3> table3 = [];
  List<Table4> table4 = [];
  List<Table5> table5 = [];
  List<Table6> table6 = [];

  GetAssetProgressDataResponse({
    required this.table,
    required this.table1,
    required this.table2,
    required this.table3,
    required this.table4,
    required this.table5,
    required this.table6,
  });

  factory GetAssetProgressDataResponse.fromJson(Map<String, dynamic> json) =>
      GetAssetProgressDataResponse(
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
            : List<Table4>.from(json["Table4"].map((x) => Table4.fromJson(x))),
        table5: json["Table5"] == null
            ? []
            : List<Table5>.from(json["Table5"].map((x) => Table5.fromJson(x))),
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
        "Table4": table4 == null
            ? null
            : List<dynamic>.from(table4.map((x) => x.toJson())),
        "Table5": table5 == null
            ? null
            : List<dynamic>.from(table5.map((x) => x.toJson())),
        "Table6": table6 == null
            ? null
            : List<dynamic>.from(table6.map((x) => x.toJson())),
      };
}

class Table {
  Table({
    this.pageId = 0,
    this.pageQuestionTitle = "",
    this.type = "",
    this.contentId = "",
    this.questionNo = "",
    this.folderPath = "",
    this.questionTitle = "",
    this.questionNumber = "",
    this.status = "",
    this.optionLevelNotes = "",
    this.actions,
  });

  int pageId = 0;
  String pageQuestionTitle = "";
  String type = "";
  String contentId = "";
  String questionNo = "";
  String folderPath = "";
  String questionTitle = "";
  String questionNumber = "";
  String status = "";
  String optionLevelNotes = "";
  dynamic actions;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        pageId: json["PageID"] == null ? 0 : json["PageID"],
        pageQuestionTitle: json["Page/Question Title"] == null
            ? ""
            : json["Page/Question Title"],
        type: json["Type"] == null ? "" : json["Type"],
        contentId: json["ContentID"] == null ? "" : json["ContentID"],
        questionNo: json["Question No."] == null ? "" : json["Question No."],
        folderPath: json["FolderPath"] == null ? "" : json["FolderPath"],
        questionTitle:
            json["QuestionTitle"] == null ? "" : json["QuestionTitle"],
        questionNumber:
            json["QuestionNumber"] == null ? "" : json["QuestionNumber"],
        status: json["Status"] == null ? "" : json["Status"],
        optionLevelNotes:
            json["OptionLevelNotes"] == null ? "" : json["OptionLevelNotes"],
        actions: json["Actions"],
      );

  Map<String, dynamic> toJson() => {
        "PageID": pageId == null ? null : pageId,
        "Page/Question Title":
            pageQuestionTitle == null ? null : pageQuestionTitle,
        "Type": type == null ? null : type,
        "ContentID": contentId == null ? null : contentId,
        "Question No.": questionNo == null ? null : questionNo,
        "FolderPath": folderPath == null ? null : folderPath,
        "QuestionTitle": questionTitle == null ? null : questionTitle,
        "QuestionNumber": questionNumber == null ? null : questionNumber,
        "Status": status == null ? null : status,
        "OptionLevelNotes": optionLevelNotes == null ? null : optionLevelNotes,
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
        userName: json["UserName"] == null ? "" : json["UserName"],
        userStatus: json["UserStatus"] == null ? 0 : json["UserStatus"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName == null ? "" : userName,
        "UserStatus": userStatus == null ? 0 : userStatus,
      };
}

class Table2 {
  Table2({
    this.suspendData = "",
  });

  String suspendData = "";

  factory Table2.fromJson(Map<String, dynamic> json) => Table2(
        suspendData: json["SuspendData"] == null ? "" : json["SuspendData"],
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
        title: json["Title"] == null ? "" : json["Title"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title == null ? null : title,
      };
}

class Table4 {
  Table4({
    this.questionNo = "",
    this.questionId = "",
    this.question = "",
    this.questionAttempt = 0,
    this.studentResponses = "",
    this.correctIncorrect = "",
    this.type = "",
    this.userId = 0,
    this.contentId = "",
    this.attachment,
    this.attachmentDisplayText,
    this.answer = "",
    this.optionalNotes = "",
  });

  String questionNo = "";
  String questionId = "";
  String question = "";
  int questionAttempt;
  String studentResponses = "";
  String correctIncorrect = "";
  String type = "";
  int userId;
  String contentId = "";
  dynamic attachment;
  dynamic attachmentDisplayText;
  String answer = "";
  String optionalNotes = "";

  factory Table4.fromJson(Map<String, dynamic> json) => Table4(
        questionNo: json["Question No."] == null ? null : json["Question No."],
        questionId: json["QuestionID"] == null ? null : json["QuestionID"],
        question: json["Question"] == null ? null : json["Question"],
        questionAttempt:
            json["Question Attempt"] == null ? null : json["Question Attempt"],
        studentResponses:
            json["StudentResponses"] == null ? null : json["StudentResponses"],
        correctIncorrect: json["Correct/Incorrect"] == null
            ? null
            : json["Correct/Incorrect"],
        type: json["Type"] == null ? null : json["Type"],
        userId: json["UserID"] == null ? null : json["UserID"],
        contentId: json["ContentID"] == null ? null : json["ContentID"],
        attachment: json["Attachment"],
        attachmentDisplayText: json["AttachmentDisplayText"],
        answer: json["Answer"] == null ? null : json["Answer"],
        optionalNotes:
            json["OptionalNotes"] == null ? null : json["OptionalNotes"],
      );

  Map<String, dynamic> toJson() => {
        "Question No.": questionNo == null ? null : questionNo,
        "QuestionID": questionId == null ? null : questionId,
        "Question": question == null ? null : question,
        "Question Attempt": questionAttempt == null ? null : questionAttempt,
        "StudentResponses": studentResponses == null ? null : studentResponses,
        "Correct/Incorrect": correctIncorrect == null ? null : correctIncorrect,
        "Type": type == null ? null : type,
        "UserID": userId == null ? null : userId,
        "ContentID": contentId == null ? null : contentId,
        "Attachment": attachment,
        "AttachmentDisplayText": attachmentDisplayText,
        "Answer": answer == null ? null : answer,
        "OptionalNotes": optionalNotes == null ? null : optionalNotes,
      };
}

class Table5 {
  Table5({
    this.questionId = 0,
    this.choiceId = 0,
    this.description = "",
    this.correct = false,
  });

  int questionId = 0;
  int choiceId = 0;
  String description = "";
  bool correct = false;

  factory Table5.fromJson(Map<String, dynamic> json) => Table5(
        questionId: json["QuestionID"] == null ? null : json["QuestionID"],
        choiceId: json["ChoiceID"] == null ? null : json["ChoiceID"],
        description: json["Description"] == null ? null : json["Description"],
        correct: json["Correct"] == null ? null : json["Correct"],
      );

  Map<String, dynamic> toJson() => {
        "QuestionID": questionId == null ? null : questionId,
        "ChoiceID": choiceId == null ? null : choiceId,
        "Description": description == null ? null : description,
        "Correct": correct == null ? null : correct,
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
