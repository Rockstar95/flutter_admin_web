import 'dart:convert';

SubsiteLoginResponse loginSuccessResponseFromJson(String str) =>
    SubsiteLoginResponse.successFromJson(json.decode(str));

String loginResponseToJson(SubsiteLoginResponse data) =>
    json.encode(data.successToJson());

SubsiteLoginResponse loginFaildeResponseFromJson(String str) =>
    SubsiteLoginResponse.failedFromJson(json.decode(str));

class SubsiteLoginResponse {
  SubsiteLoginResponse({
    required this.successFullUserLogin,
    required this.failedUserLogin,
  });

  List<SuccessFulUserLogin> successFullUserLogin;

  List<FailedUserLogin> failedUserLogin;

  factory SubsiteLoginResponse.successFromJson(Map<String, dynamic> json) =>
      SubsiteLoginResponse(
        successFullUserLogin: List<SuccessFulUserLogin>.from(
            json["successfulluserlogin"]
                .map((x) => SuccessFulUserLogin.fromJson(x))),
        failedUserLogin: [],
      );

  Map<String, dynamic> successToJson() => {
        "successfulluserlogin":
            List<dynamic>.from(successFullUserLogin.map((x) => x.toJson())),
      };

  Map<String, dynamic> faildeToJson() => {
        "faileduserlogin":
            List<dynamic>.from(failedUserLogin.map((x) => x.toJson())),
      };

  factory SubsiteLoginResponse.failedFromJson(Map<String, dynamic> json) {
    return SubsiteLoginResponse(
      successFullUserLogin: [],
      failedUserLogin: List<FailedUserLogin>.from(
          json["faileduserlogin"].map((x) => FailedUserLogin.fromJson(x))),
    );
  }
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
      this.jwttoken = ""});

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

  factory SuccessFulUserLogin.fromJson(Map<String, dynamic> json) =>
      SuccessFulUserLogin(
        userid: json["userid"],
        orgunitid: json["orgunitid"],
        userstatus: json["userstatus"],
        username: json["username"],
        image: json["image"],
        siteid: json["siteid"],
        tcapiurl: json["tcapiurl"],
        hasscanprivilege: json["hasscanprivilege"],
        autolaunchcontent: json["autolaunchcontent"],
        jwttoken: json["jwttoken"],
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
        "jwttoken": jwttoken
      };
}

class FailedUserLogin {
  // {"faileduserlogin":[{"userid":-1,"siteid":-1,"userstatus":"Login Failed","hasscanprivilege":null}]}

  FailedUserLogin({
    this.userid = 0,
    this.userstatus = "",
    this.siteid = 0,
    this.hasscanprivilege = "",
  });

  int userid = 0;
  String userstatus = "";
  int siteid = 0;
  String hasscanprivilege = "";

  factory FailedUserLogin.fromJson(Map<String, dynamic> json) =>
      FailedUserLogin(
        userid: json["userid"],
        userstatus: json["userstatus"],
        siteid: json["siteid"],
        hasscanprivilege: json["hasscanprivilege"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "userstatus": userstatus,
        "siteid": siteid,
        "hasscanprivilege": hasscanprivilege,
      };
}
