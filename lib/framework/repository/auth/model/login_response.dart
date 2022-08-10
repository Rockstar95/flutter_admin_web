import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.successFullUserLogin,
  });

  List<SuccessFulUserLogin> successFullUserLogin = [];

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        successFullUserLogin: List<SuccessFulUserLogin>.from(
            (json["successfulluserlogin"] ?? [])
                .map((x) => SuccessFulUserLogin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "successfulluserlogin":
            List<dynamic>.from(successFullUserLogin.map((x) => x.toJson())),
      };
}

class SuccessFulUserLogin {
  SuccessFulUserLogin(
      {this.userid = 0,
      this.orgunitid = 0,
      this.userstatus = "",
      this.username = "",
      this.image = "",
      this.siteid = 0,
      this.tcapiurl = "",
      this.hasscanprivilege = "",
      this.autolaunchcontent = "",
      this.jwttoken = "",
      this.sessionid = ""});

  int userid = 0;
  int orgunitid = 0;
  String userstatus;
  String username;
  String image;
  int siteid = 0;
  String tcapiurl;
  String hasscanprivilege;
  String autolaunchcontent;
  String jwttoken;
  String sessionid;

  factory SuccessFulUserLogin.fromJson(Map<String, dynamic> json) =>
      SuccessFulUserLogin(
        userid: json["userid"] ?? 0,
        orgunitid: json["orgunitid"] ?? 0,
        userstatus: json["userstatus"] ?? "",
        username: json["username"] ?? "",
        image: json["image"] ?? "",
        siteid: json["siteid"] ?? 0,
        tcapiurl: json["tcapiurl"] ?? "",
        hasscanprivilege: json["hasscanprivilege"] ?? "",
        autolaunchcontent: json["autolaunchcontent"] ?? "",
        jwttoken: json["jwttoken"] ?? "",
        sessionid: json["sessionid"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "orgunitid": orgunitid,
        "userstatus": userstatus,
        "username": username,
        "image": image,
        "siteid": siteid,
        "tcapiurl": tcapiurl,
        "hasscanprivilege": hasscanprivilege,
        "autolaunchcontent": autolaunchcontent,
        "jwttoken": jwttoken,
        "sessionid": sessionid,
      };
}
