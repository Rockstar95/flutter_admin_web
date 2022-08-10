import 'dart:convert';

PreferenceResponse preferenceResponseFromJson(String str) =>
    PreferenceResponse.fromJson(json.decode(str));

String preferenceResponseToJson(PreferenceResponse data) =>
    json.encode(data.toJson());

/*
class PreferenceResponse {
  PreferenceResponse({
    this.profilesettings,
  });

  Profilesettings profilesettings;

  factory PreferenceResponse.fromJson(Map<String, dynamic> json) =>
      PreferenceResponse(
        profilesettings: Profilesettings.fromJson(json["profilesettings"]),
      );

  Map<String, dynamic> toJson() => {
        "profilesettings": profilesettings.toJson(),
      };
}

class Profilesettings {
  Profilesettings({
    this.securityQuestions,
    this.profilePreferences,
  });

  List<dynamic> securityQuestions;
  List<ProfilePreference> profilePreferences;

  factory Profilesettings.fromJson(Map<String, dynamic> json) =>
      Profilesettings(
        securityQuestions:
            List<dynamic>.from(json["securityQuestions"].map((x) => x)),
        profilePreferences: List<ProfilePreference>.from(
            json["ProfilePreferences"]
                .map((x) => ProfilePreference.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "securityQuestions":
            List<dynamic>.from(securityQuestions.map((x) => x)),
        "ProfilePreferences":
            List<dynamic>.from(profilePreferences.map((x) => x.toJson())),
      };
}

class ProfilePreference {
  ProfilePreference({
    this.usertimezone,
    this.userLanguage,
    this.langselection,
    this.startTime,
    this.endTime,
    this.userId,
    this.activites,
  });

  String usertimezone;
  String userLanguage;
  String langselection;
  String startTime;
  String endTime;
  String userId;
  String activites;

  factory ProfilePreference.fromJson(Map<String, dynamic> json) =>
      ProfilePreference(
        usertimezone: json["Usertimezone"],
        userLanguage: json["UserLanguage"],
        langselection: json["langselection"],
        startTime: json["StartTime"],
        endTime: json["EndTime"],
        userId: json["UserId"],
        activites: json["Activites"],
      );

  Map<String, dynamic> toJson() => {
        "Usertimezone": usertimezone,
        "UserLanguage": userLanguage,
        "langselection": langselection,
        "StartTime": startTime,
        "EndTime": endTime,
        "UserId": userId,
        "Activites": activites,
      };
}
*/

class PreferenceResponse {
  Profilesettings? profilesettings;

  PreferenceResponse({this.profilesettings});

  PreferenceResponse.fromJson(Map<String, dynamic> json) {
    profilesettings = json['profilesettings'] != null
        ? new Profilesettings.fromJson(json['profilesettings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profilesettings != null) {
      data['profilesettings'] = this.profilesettings!.toJson();
    }
    return data;
  }
}

class Profilesettings {
  List<SecurityQuestions> securityQuestions = [];
  List<ProfilePreference> profilePreferences = [];

  Profilesettings(
      {required this.securityQuestions, required this.profilePreferences});

  Profilesettings.fromJson(Map<String, dynamic> json) {
    if (json['securityQuestions'] != null) {
      json['securityQuestions'].forEach((v) {
        securityQuestions.add(new SecurityQuestions.fromJson(v));
      });
    }
    if (json['ProfilePreferences'] != null) {
      json['ProfilePreferences'].forEach((v) {
        profilePreferences.add(new ProfilePreference.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.securityQuestions != null) {
      data['securityQuestions'] =
          this.securityQuestions.map((v) => v.toJson()).toList();
    }
    if (this.profilePreferences != null) {
      data['ProfilePreferences'] =
          this.profilePreferences.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfilePreference {
  String usertimezone = "";
  String userLanguage = "";
  String langselection = "";
  String startTime = "";
  String endTime = "";
  String userId = "";
  String activites = "";

  ProfilePreference(
      {this.usertimezone = "",
      this.userLanguage = "",
      this.langselection = "",
      this.startTime = "",
      this.endTime = "",
      this.userId = "",
      this.activites = ""});

  ProfilePreference.fromJson(Map<String, dynamic> json) {
    usertimezone = json['Usertimezone'];
    userLanguage = json['UserLanguage'];
    langselection = json['langselection'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    userId = json['UserId'];
    activites = json['Activites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Usertimezone'] = this.usertimezone;
    data['UserLanguage'] = this.userLanguage;
    data['langselection'] = this.langselection;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['UserId'] = this.userId;
    data['Activites'] = this.activites;
    return data;
  }
}

class SecurityQuestions {
  String usertimezone = "";
  String userLanguage = "";
  String langselection = "";
  String startTime = "";
  String endTime = "";
  String userId = "";
  String activites = "";

  SecurityQuestions(
      {this.usertimezone = "",
      this.userLanguage = "",
      this.langselection = "",
      this.startTime = "",
      this.endTime = "",
      this.userId = "",
      this.activites = ""});

  SecurityQuestions.fromJson(Map<String, dynamic> json) {
    usertimezone = json['Usertimezone'];
    userLanguage = json['UserLanguage'];
    langselection = json['langselection'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    userId = json['UserId'];
    activites = json['Activites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Usertimezone'] = this.usertimezone;
    data['UserLanguage'] = this.userLanguage;
    data['langselection'] = this.langselection;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['UserId'] = this.userId;
    data['Activites'] = this.activites;
    return data;
  }
}
