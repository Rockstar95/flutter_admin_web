// To parse this JSON data, do
//
//     final expiryEventsRequest = expiryEventsRequestFromJson(jsonString);

import 'dart:convert';

ExpiryEventsRequest expiryEventsRequestFromJson(String str) =>
    ExpiryEventsRequest.fromJson(json.decode(str));

String expiryEventsRequestToJson(ExpiryEventsRequest data) =>
    json.encode(data.toJson());

class ExpiryEventsRequest {
  ExpiryEventsRequest({
    this.selectedContent = "",
    this.userId = "",
    this.siteId = "",
    this.orgUnitId = "",
    this.locale = "",
  });

  String selectedContent = "";
  String userId = "";
  String siteId = "";
  String orgUnitId = "";
  String locale = "";

  factory ExpiryEventsRequest.fromJson(Map<String, dynamic> json) =>
      ExpiryEventsRequest(
        selectedContent: json["SelectedContent"],
        userId: json["UserID"],
        siteId: json["SiteID"],
        orgUnitId: json["OrgUnitID"],
        locale: json["Locale"],
      );

  Map<String, dynamic> toJson() => {
        "SelectedContent": selectedContent,
        "UserID": userId,
        "SiteID": siteId,
        "OrgUnitID": orgUnitId,
        "Locale": locale,
      };
}
