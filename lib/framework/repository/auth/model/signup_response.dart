// To parse this JSON data, do
//
//     final signupResponse = signupResponseFromJson(jsonString);

import 'dart:convert';

SignupResponse signupResponseFromJson(String str) =>
    SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

class SignupResponse {
  SignupResponse({
    required this.usersignupdetails,
  });

  List<Usersignupdetail> usersignupdetails = [];

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
        usersignupdetails: List<Usersignupdetail>.from(
            (json["usersignupdetails"] ?? [])
                .map((x) => Usersignupdetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "usersignupdetails":
            List<dynamic>.from(usersignupdetails.map((x) => x.toJson())),
      };
}

class Usersignupdetail {
  Usersignupdetail({
    this.message = "",
    this.action,
    this.login = "",
    this.pwd = "",
    this.autolaunchcontentid,
  });

  String message = "";
  dynamic action;
  String login = "";
  String pwd = "";
  dynamic autolaunchcontentid;

  factory Usersignupdetail.fromJson(Map<String, dynamic> json) =>
      Usersignupdetail(
        message: json["message"],
        action: json["action"],
        login: json["login"],
        pwd: json["pwd"],
        autolaunchcontentid: json["autolaunchcontentid"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "action": action,
        "login": login,
        "pwd": pwd,
        "autolaunchcontentid": autolaunchcontentid,
      };
}
