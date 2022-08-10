import 'dart:convert';

UserProfileSettingResponse userProfileSettingResponseFromJson(String str) =>
    UserProfileSettingResponse.fromJson(json.decode(str));

String userProfileSettingResponseToJson(UserProfileSettingResponse data) =>
    json.encode(data.toJson());

class UserProfileSettingResponse {
  UserProfileSettingResponse({
    this.timeZone = "",
    this.languageSelection = "",
    this.languageName = "",
    this.userLanguage = "",
    this.userLrsActivities = 0,
    this.workstartTime = "",
    this.workEndTime = "",
    this.isSecurityQuestionsEnable = false,
    required this.languagedata,
    required this.acSettings,
  });

  String timeZone = '';
  String languageSelection = "";
  String languageName = "";
  String userLanguage = "";
  int userLrsActivities = 0;
  String workstartTime = "";
  String workEndTime = "";
  bool isSecurityQuestionsEnable = false;
  List<LanguageData> languagedata = [];
  List<AcSetting> acSettings = [];

  factory UserProfileSettingResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileSettingResponse(
        timeZone: json["TimeZone"],
        languageSelection: json["LanguageSelection"],
        languageName: json["LanguageName"],
        userLanguage: json["UserLanguage"],
        userLrsActivities: json["UserLrsActivities"],
        workstartTime: json["WorkstartTime"],
        workEndTime: json["WorkEndTime"],
        isSecurityQuestionsEnable: json["isSecurityQuestionsEnable"],
        languagedata: List<LanguageData>.from(
            json["Languagedata"].map((x) => LanguageData.fromJson(x))),
        acSettings: List<AcSetting>.from(
            json["ACSettings"].map((x) => AcSetting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TimeZone": timeZone,
        "LanguageSelection": languageSelection,
        "LanguageName": languageName,
        "UserLanguage": userLanguage,
        "UserLrsActivities": userLrsActivities,
        "WorkstartTime": workstartTime,
        "WorkEndTime": workEndTime,
        "isSecurityQuestionsEnable": isSecurityQuestionsEnable,
        "Languagedata": List<dynamic>.from(languagedata.map((x) => x.toJson())),
        "ACSettings": List<dynamic>.from(acSettings.map((x) => x.toJson())),
      };
}

class AcSetting {
  AcSetting({
    this.displaytext = "",
    this.dataFieldName = "",
    this.visible = false,
  });

  String displaytext = "";
  String dataFieldName = "";
  bool visible = false;

  factory AcSetting.fromJson(Map<String, dynamic> json) => AcSetting(
        displaytext: json["Displaytext"],
        dataFieldName: json["DataFieldName"],
        visible: json["Visible"],
      );

  Map<String, dynamic> toJson() => {
        "Displaytext": displaytext,
        "DataFieldName": dataFieldName,
        "Visible": visible,
      };
}

class LanguageData {
  LanguageData({
    this.languagename = "",
    this.loceid = "",
    this.checked = false,
  });

  String languagename = "";
  String loceid = "";
  bool checked = false;

  factory LanguageData.fromJson(Map<String, dynamic> json) => LanguageData(
        languagename: json["languagename"],
        loceid: json["loceid"],
        checked: json["Checked"],
      );

  Map<String, dynamic> toJson() => {
        "languagename": languagename,
        "loceid": loceid,
        "Checked": checked,
      };
}
