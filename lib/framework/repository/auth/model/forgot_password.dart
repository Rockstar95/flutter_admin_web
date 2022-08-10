// To parse this JSON data, do
//
//     final forgotPasswordResponse = forgotPasswordResponseFromJson(jsonString);

import 'dart:convert';

ForgotPasswordResponse forgotPasswordResponseFromJson(String str) =>
    ForgotPasswordResponse.fromJson(json.decode(str));

String forgotPasswordResponseToJson(ForgotPasswordResponse data) =>
    json.encode(data.toJson());

class ForgotPasswordResponse {
  ForgotPasswordResponse({
    required this.userstatus,
  });

  List<Userstatus> userstatus = [];

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
        userstatus: List<Userstatus>.from(
            json["userstatus"].map((x) => Userstatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userstatus": List<dynamic>.from(userstatus.map((x) => x.toJson())),
      };
}

class Userstatus {
  Userstatus({
    this.userid = 0,
    this.siteid = 0,
    this.active = false,
    this.userstatus = 0,
    this.email = "",
  });

  int userid = 0;
  int siteid = 0;
  bool active = false;
  int userstatus = 0;
  String email = "";

  factory Userstatus.fromJson(Map<String, dynamic> json) => Userstatus(
        userid: json["userid"],
        siteid: json["siteid"],
        active: json["active"],
        userstatus: json["userstatus"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "siteid": siteid,
        "active": active,
        "userstatus": userstatus,
        "email": email,
      };
}
