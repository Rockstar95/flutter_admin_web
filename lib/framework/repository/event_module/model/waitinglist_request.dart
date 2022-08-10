// To parse this JSON data, do
//
//     final waitingListRequest = waitingListRequestFromJson(jsonString);

import 'dart:convert';

WaitingListRequest waitingListRequestFromJson(String str) =>
    WaitingListRequest.fromJson(json.decode(str));

String waitingListRequestToJson(WaitingListRequest data) =>
    json.encode(data.toJson());

class WaitingListRequest {
  WaitingListRequest({
    this.wlContentId = "",
    this.userId = "",
    this.siteid = "",
    this.locale = "",
  });

  String wlContentId = "";
  String userId = "";
  String siteid = "";
  String locale = "";

  factory WaitingListRequest.fromJson(Map<String, dynamic> json) =>
      WaitingListRequest(
        wlContentId: json["WLContentID"],
        userId: json["UserID"],
        siteid: json["siteid"],
        locale: json["locale"],
      );

  Map<String, dynamic> toJson() => {
        "WLContentID": wlContentId,
        "UserID": userId,
        "siteid": siteid,
        "locale": locale,
      };
}
