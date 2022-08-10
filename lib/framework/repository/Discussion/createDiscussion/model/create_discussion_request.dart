import 'dart:convert';

CreateDiscussionRequest discussionMainHomeRequestFromJson(String str) =>
    CreateDiscussionRequest.fromJson(json.decode(str));

String createDiscussionRequestToJson(CreateDiscussionRequest data) =>
    json.encode(data.toJson());

class CreateDiscussionRequest {
  String strAttachFile = "";
  int userID = 0;
  int orgID = 0;
  int forumID = 0;
  int strContentID = 0;
  String description = "";
  String localeID = "";
  bool isPin = false;
  int siteID = 0;
  String title = "";
  String forumName = "";
  String involvedUsers = "";

  CreateDiscussionRequest(
      {this.strAttachFile = "",
      this.userID = 0,
      this.orgID = 0,
      this.forumID = 0,
      this.strContentID = 0,
      this.description = "",
      this.localeID = "",
      this.isPin = false,
      this.siteID = 0,
      this.title = "",
      this.forumName = "",
      this.involvedUsers = ""});

  CreateDiscussionRequest.fromJson(Map<String, dynamic> json) {
    strAttachFile = json['strAttachFile'];
    userID = json['UserID'];
    orgID = json['OrgID'];
    forumID = json['ForumID'];
    strContentID = json['strContentID'];
    description = json['Description'];
    localeID = json['LocaleID'];
    isPin = json['IsPin'];
    siteID = json['SiteID'];
    title = json['Title'];
    forumName = json['ForumName'];
    involvedUsers = json['InvolvedUsers'];
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
    data['IsPin'] = this.isPin;
    data['SiteID'] = this.siteID;
    data['Title'] = this.title;
    data['ForumName'] = this.forumName;
    data['InvolvedUsers'] = this.involvedUsers;
    return data;
  }
}
