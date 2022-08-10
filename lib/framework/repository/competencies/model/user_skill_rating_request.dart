import 'dart:convert';

UserSkillRatingRequest userSkillRatingRequestFromJson(String str) =>
    UserSkillRatingRequest.fromJson(json.decode(str));

String userSkillRatingRequestToJson(UserSkillRatingRequest data) =>
    json.encode(data.toJson());

class UserSkillRatingRequest {
  int componentID = 0;
  int componentInsID = 0;
  int jobRoleID = 0;
  String locale = "";
  int prefCategoryID = 0;
  int siteID = 0;
  String skillSetValue = "";
  int userID = 0;

  UserSkillRatingRequest(
      {this.componentID = 0,
      this.componentInsID = 0,
      this.jobRoleID = 0,
      this.locale = "",
      this.prefCategoryID = 0,
      this.siteID = 0,
      this.skillSetValue = "",
      this.userID = 0});

  UserSkillRatingRequest.fromJson(Map<String, dynamic> json) {
    componentID = json['ComponentID'];
    componentInsID = json['ComponentInsID'];
    jobRoleID = json['JobRoleID'];
    locale = json['Locale'];
    prefCategoryID = json['PrefCategoryID'];
    siteID = json['SiteID'];
    skillSetValue = json['SkillSetValue'];
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComponentID'] = this.componentID;
    data['ComponentInsID'] = this.componentInsID;
    data['JobRoleID'] = this.jobRoleID;
    data['Locale'] = this.locale;
    data['PrefCategoryID'] = this.prefCategoryID;
    data['SiteID'] = this.siteID;
    data['SkillSetValue'] = this.skillSetValue;
    data['UserID'] = this.userID;
    return data;
  }
}
