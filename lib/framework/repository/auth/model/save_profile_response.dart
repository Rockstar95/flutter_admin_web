import 'dart:convert';

SaveProfileResponse saveProfileResponseFromJson(String str) =>
    SaveProfileResponse.fromJson(json.decode(str));

String saveProfileResponseToJson(SaveProfileResponse data) =>
    json.encode(data.toJson());

class SaveProfileResponse {
  SaveProfileResponse({
    required this.profileResponse,
  });

  ProfileResponse profileResponse;

  factory SaveProfileResponse.fromJson(Map<String, dynamic> json) =>
      SaveProfileResponse(
        profileResponse: ProfileResponse.fromJson(json["Response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "Response": profileResponse.toJson(),
      };
}

class ProfileResponse {
  ProfileResponse({
    this.message = "",
    this.userId = 0,
    this.fromSiteId = 0,
    this.toSiteId = 0,
    this.adminapproval,
    this.verifyEmail,
    this.generatePassword,
    this.notifyMessage,
    this.loginId,
    this.loginPwd,
  });

  String message = "";
  int userId = 0;
  int fromSiteId = 0;
  int toSiteId = 0;
  dynamic adminapproval;
  dynamic verifyEmail;
  dynamic generatePassword;
  dynamic notifyMessage;
  dynamic loginId;
  dynamic loginPwd;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        message: json["Message"] ?? "",
        userId: json["UserID"] ?? 0,
        fromSiteId: json["FromSiteID"] ?? 0,
        toSiteId: json["ToSiteID"] ?? 0,
        adminapproval: json["adminapproval"],
        verifyEmail: json["VerifyEmail"],
        generatePassword: json["generatePassword"],
        notifyMessage: json["NotifyMessage"],
        loginId: json["loginID"],
        loginPwd: json["loginPwd"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "UserID": userId,
        "FromSiteID": fromSiteId,
        "ToSiteID": toSiteId,
        "adminapproval": adminapproval,
        "VerifyEmail": verifyEmail,
        "generatePassword": generatePassword,
        "NotifyMessage": notifyMessage,
        "loginID": loginId,
        "loginPwd": loginPwd,
      };
}
