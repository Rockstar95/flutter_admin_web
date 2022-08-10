// To parse this JSON data, do
//
//     final socialSigninRequest = socialSigninRequestFromJson(jsonString);

import 'dart:convert';

SocialSigninRequest socialSigninRequestFromJson(String str) =>
    SocialSigninRequest.fromJson(json.decode(str));

String socialSigninRequestToJson(SocialSigninRequest data) =>
    json.encode(data.toJson());

class SocialSigninRequest {
  SocialSigninRequest({
    this.type = "",
    this.siteId = 0,
    this.localeId = "",
    required this.socailNetworkData,
  });

  String type = "";
  int siteId = 0;
  String localeId = "";
  List<SocailNetworkDatum> socailNetworkData = [];

  factory SocialSigninRequest.fromJson(Map<String, dynamic> json) =>
      SocialSigninRequest(
        type: json["type"],
        siteId: json["siteId"],
        localeId: json["localeId"],
        socailNetworkData: List<SocailNetworkDatum>.from(
            json["SocailNetworkData"]
                .map((x) => SocailNetworkDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "siteId": siteId,
        "localeId": localeId,
        "SocailNetworkData":
            List<dynamic>.from(socailNetworkData.map((x) => x.toJson())),
      };
}

class SocailNetworkDatum {
  SocailNetworkDatum({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.link = "",
    this.username = "",
    this.email = "",
    this.picture = "",
  });

  String id = "";
  String firstName = "";
  String lastName = "";
  String link = "";
  String username = "";
  String email = "";
  String picture = "";

  factory SocailNetworkDatum.fromJson(Map<String, dynamic> json) =>
      SocailNetworkDatum(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        link: json["link"],
        username: json["username"],
        email: json["email"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "link": link,
        "username": username,
        "email": email,
        "picture": picture,
      };
}
