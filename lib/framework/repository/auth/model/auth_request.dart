// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.userName = "",
    this.password = "",
    this.mobileSiteUrl = "",
    this.downloadContent = "",
    this.siteId = "",
    this.isFromSignUp = false,
  });

  String userName = "";
  String password = "";
  String mobileSiteUrl = "";
  String downloadContent = "";
  String siteId = "";
  bool isFromSignUp = false;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        userName: json["UserName"],
        password: json["Password"],
        mobileSiteUrl: json["MobileSiteURL"],
        downloadContent: json["DownloadContent"],
        siteId: json["SiteID"],
        isFromSignUp: json["isFromSignUp"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "Password": password,
        "MobileSiteURL": mobileSiteUrl,
        "DownloadContent": downloadContent,
        "SiteID": siteId,
        "isFromSignUp": isFromSignUp,
      };
}
