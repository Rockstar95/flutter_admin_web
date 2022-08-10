// To parse this JSON data, do
//
//     final signupRequest = signupRequestFromJson(jsonString);

import 'dart:convert';

SignupRequest signupRequestFromJson(String str) =>
    SignupRequest.fromJson(json.decode(str));

String signupRequestToJson(SignupRequest data) => json.encode(data.toJson());

class SignupRequest {
  SignupRequest({
    this.userGroupIDs = "",
    this.roleIDs = "",
    this.cmd = "",
    this.cmGroupIDs = "",
  });

  String userGroupIDs = "";
  String roleIDs = "";
  String cmd = "";
  String cmGroupIDs = "";

  factory SignupRequest.fromJson(Map<String, dynamic> json) => SignupRequest(
        userGroupIDs: json["UserGroupIDs"],
        roleIDs: json["RoleIDs"],
        cmd: json["Cmd"],
        cmGroupIDs: json["CMGroupIDs"],
      );

  Map<String, dynamic> toJson() => {
        "UserGroupIDs": userGroupIDs,
        "RoleIDs": roleIDs,
        "Cmd": cmd,
        "CMGroupIDs": cmGroupIDs,
      };
}
