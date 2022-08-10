// To parse this JSON data, do
//
//     final waitingListResponse = waitingListResponseFromJson(jsonString);

import 'dart:convert';

WaitingListResponse waitingListResponseFromJson(String str) =>
    WaitingListResponse.fromJson(json.decode(str));

String waitingListResponseToJson(WaitingListResponse data) =>
    json.encode(data.toJson());

class WaitingListResponse {
  WaitingListResponse({
    this.isSuccess = false,
    this.message = "",
    this.autoLaunchUrl,
    this.selfScheduleEventId,
    this.courseObject,
    this.searchObject,
    this.detailsObject,
    this.notiFyMsg,
  });

  bool isSuccess = false;
  String message = "";
  dynamic autoLaunchUrl;
  dynamic selfScheduleEventId;
  dynamic courseObject;
  dynamic searchObject;
  dynamic detailsObject;
  dynamic notiFyMsg;

  factory WaitingListResponse.fromJson(Map<String, dynamic> json) =>
      WaitingListResponse(
        isSuccess: json["IsSuccess"],
        message: json["Message"],
        autoLaunchUrl: json["AutoLaunchURL"],
        selfScheduleEventId: json["SelfScheduleEventID"],
        courseObject: json["CourseObject"],
        searchObject: json["SearchObject"],
        detailsObject: json["DetailsObject"],
        notiFyMsg: json["NotiFyMsg"],
      );

  Map<String, dynamic> toJson() => {
        "IsSuccess": isSuccess,
        "Message": message,
        "AutoLaunchURL": autoLaunchUrl,
        "SelfScheduleEventID": selfScheduleEventId,
        "CourseObject": courseObject,
        "SearchObject": searchObject,
        "DetailsObject": detailsObject,
        "NotiFyMsg": notiFyMsg,
      };
}
