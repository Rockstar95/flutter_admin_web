// To parse this JSON data, do
//
//     final createExperienceRequest = createExperienceRequestFromJson(jsonString);

import 'dart:convert';

CreateExperienceRequest createExperienceRequestFromJson(String str) =>
    CreateExperienceRequest.fromJson(json.decode(str));

String createExperienceRequestToJson(CreateExperienceRequest data) =>
    json.encode(data.toJson());

class CreateExperienceRequest {
  CreateExperienceRequest({
    this.showftoate = "",
    this.todate = "",
    this.discription = "",
    this.location = "",
    this.showfromdate = "",
    this.company = "",
    this.fromdate = "",
    this.displayNo = "",
    this.tilldate = 0,
    this.userId = "",
    this.title = "",
    this.oldtitle = "",
  });

  String showftoate = "";
  String todate = "";
  String discription = "";
  String location = "";
  String showfromdate = "";
  String company = "";
  String fromdate = "";
  String displayNo = "";
  int tilldate = 0;
  String userId = "";
  String title = "";
  String oldtitle = "";

  factory CreateExperienceRequest.fromJson(Map<String, dynamic> json) =>
      CreateExperienceRequest(
        showftoate: json["showftoate"],
        todate: json["todate"],
        discription: json["discription"],
        location: json["location"],
        showfromdate: json["showfromdate"],
        company: json["Company"],
        fromdate: json["fromdate"],
        displayNo: json["DisplayNo"],
        tilldate: json["Tilldate"],
        userId: json["UserID"],
        title: json["title"],
        oldtitle: json["oldtitle"],
      );

  Map<String, dynamic> toJson() => {
        "showftoate": showftoate,
        "todate": todate,
        "discription": discription,
        "location": location,
        "showfromdate": showfromdate,
        "Company": company,
        "fromdate": fromdate,
        "DisplayNo": displayNo,
        "Tilldate": tilldate,
        "UserID": userId,
        "title": title,
        "oldtitle": oldtitle,
      };
}
