// To parse this JSON data, do
//
//     final socialSigninResponse = socialSigninResponseFromJson(jsonString);

import 'dart:convert';

SocialSigninResponse socialSigninResponseFromJson(String str) =>
    SocialSigninResponse.fromJson(json.decode(str));

String socialSigninResponseToJson(SocialSigninResponse data) =>
    json.encode(data.toJson());

class SocialSigninResponse {
  SocialSigninResponse({
    this.userId = 0,
    this.fromSiteId = 0,
    this.toSiteId = 0,
    this.tokeyKey = "",
  });

  int userId = 0;
  int fromSiteId = 0;
  int toSiteId = 0;
  String tokeyKey = "";

  factory SocialSigninResponse.fromJson(Map<String, dynamic> json) =>
      SocialSigninResponse(
        userId: json["UserID"],
        fromSiteId: json["FromSiteID"],
        toSiteId: json["ToSiteID"],
        tokeyKey: json["tokeyKey"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FromSiteID": fromSiteId,
        "ToSiteID": toSiteId,
        "tokeyKey": tokeyKey,
      };
}
