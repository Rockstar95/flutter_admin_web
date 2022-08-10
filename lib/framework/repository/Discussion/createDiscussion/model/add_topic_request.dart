import 'dart:convert';

AddTopicRequest addTopicRequestFromJson(String str) =>
    AddTopicRequest.fromJson(json.decode(str));

String addTopicRequestToJson(AddTopicRequest data) =>
    json.encode(data.toJson());

class AddTopicRequest {
  String strAttachFile = "";
  int userID = 0;
  int orgID = 0;
  int forumID = 0;
  String strContentID = "";
  String description = "";
  String localeID = "";
  int siteID = 0;
  String title = "";
  String forumName = "";

  AddTopicRequest(
      {this.strAttachFile = "",
      this.userID = 0,
      this.orgID = 0,
      this.forumID = 0,
      this.strContentID = "",
      this.description = "",
      this.localeID = "",
      this.siteID = 0,
      this.title = "",
      this.forumName = ""});

  AddTopicRequest.fromJson(Map<String, dynamic> json) {
    strAttachFile = json['strAttachFile'];
    userID = json['UserID'];
    orgID = json['OrgID'];
    forumID = json['ForumID'];
    strContentID = json['strContentID'];
    description = json['Description'];
    localeID = json['LocaleID'];
    siteID = json['SiteID'];
    title = json['Title'];
    forumName = json['ForumName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strAttachFile'] = this.strAttachFile;
    data['UserID'] = this.userID;
    data['OrgID'] = this.orgID;
    data['ForumID'] = this.forumID;
    data['strContentID'] = this.strContentID;
    data['Description'] = this.description;
    data['LocaleID'] = this.localeID;
    data['SiteID'] = this.siteID;
    data['Title'] = this.title;
    data['ForumName'] = this.forumName;
    return data;
  }
}
