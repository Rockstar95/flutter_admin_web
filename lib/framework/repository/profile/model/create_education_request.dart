// To parse this JSON data, do
//
//     final createEducationRequest = createEducationRequestFromJson(jsonString);

import 'dart:convert';

CreateEducationRequest createEducationRequestFromJson(String str) =>
    CreateEducationRequest.fromJson(json.decode(str));

String createEducationRequestToJson(CreateEducationRequest data) =>
    json.encode(data.toJson());

class CreateEducationRequest {
  CreateEducationRequest({
    this.showfromdate = "",
    this.degree = "",
    this.title = "",
    this.toyear = "",
    this.titleEducation = "",
    this.userId = "",
    this.school = "",
    this.fromyear = "",
    this.discription = "",
    this.oldtitle = "",
    this.country = "",
    this.displayNo = "",
  });

  String showfromdate = "";
  String degree = "";
  String title = "";
  String toyear = "";
  String titleEducation = "";
  String userId = "";
  String school = "";
  String fromyear = "";
  String discription = "";
  String oldtitle = "";
  String country = "";
  String displayNo = "";

  factory CreateEducationRequest.fromJson(Map<String, dynamic> json) =>
      CreateEducationRequest(
        showfromdate: json["showfromdate"],
        degree: json["degree"],
        title: json["title"],
        toyear: json["toyear"],
        titleEducation: json["titleEducation"],
        userId: json["UserID"],
        school: json["school"],
        fromyear: json["fromyear"],
        discription: json["discription"],
        oldtitle: json["oldtitle"],
        country: json["Country"],
        displayNo: json["DisplayNo"],
      );

  Map<String, dynamic> toJson() => {
        "showfromdate": showfromdate,
        "degree": degree,
        "title": title,
        "toyear": toyear,
        "titleEducation": titleEducation,
        "UserID": userId,
        "school": school,
        "fromyear": fromyear,
        "discription": discription,
        "oldtitle": oldtitle,
        "Country": country,
        "DisplayNo": displayNo,
      };
}
