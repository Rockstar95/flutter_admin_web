// To parse this JSON data, do
//
//     final getPeopleTabListResponse = getPeopleTabListResponseFromJson(jsonString);

import 'dart:convert';

List<GetPeopleTabListResponse> getPeopleTabListResponseFromJson(String str) =>
    List<GetPeopleTabListResponse>.from(
        json.decode(str).map((x) => GetPeopleTabListResponse.fromJson(x)));

String getPeopleTabListResponseToJson(List<GetPeopleTabListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetPeopleTabListResponse {
  GetPeopleTabListResponse({
    this.tabId = "",
    this.displayName = "",
    this.mobileDisplayName = "",
    this.displayIcon = "",
    this.componentName = "",
    this.tabComponentInstanceId = "",
    this.componentId = "",
    this.parameterString = "",
  });

  String tabId = "";
  String displayName = "";
  String mobileDisplayName = "";
  String displayIcon = "";
  String componentName = "";
  String tabComponentInstanceId = "";
  String componentId = "";
  String parameterString = "";
  bool selectedIndex = false;

  factory GetPeopleTabListResponse.fromJson(Map<String, dynamic> json) =>
      GetPeopleTabListResponse(
        tabId: json["TabID"],
        displayName: json["DisplayName"],
        mobileDisplayName: json["MobileDisplayName"],
        displayIcon: json["DisplayIcon"],
        componentName: json["ComponentName"],
        tabComponentInstanceId: json["TabComponentInstanceID"],
        componentId: json["ComponentID"],
        parameterString: json["ParameterString"],
      );

  Map<String, dynamic> toJson() => {
        "TabID": tabId,
        "DisplayName": displayName,
        "MobileDisplayName": mobileDisplayName,
        "DisplayIcon": displayIcon,
        "ComponentName": componentName,
        "TabComponentInstanceID": tabComponentInstanceId,
        "ComponentID": componentId,
        "ParameterString": parameterString,
      };
}
