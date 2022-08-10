import 'dart:convert';

DiscussionReplyRequest discussionReplyRequestFromJson(String str) =>
    DiscussionReplyRequest.fromJson(json.decode(str));

String discussionReplyRequestToJson(DiscussionReplyRequest data) =>
    json.encode(data.toJson());

class DiscussionReplyRequest {
  int strCommentID = 0;
  int userID = 0;
  int siteID = 0;
  String localeID = "";

  DiscussionReplyRequest(
      {this.strCommentID = 0,
      this.userID = 0,
      this.siteID = 0,
      this.localeID = ""});

  DiscussionReplyRequest.fromJson(Map<String, dynamic> json) {
    strCommentID = json['strCommentID'];
    userID = json['UserID'];
    siteID = json['SiteID'];
    localeID = json['LocaleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strCommentID'] = this.strCommentID;
    data['UserID'] = this.userID;
    data['SiteID'] = this.siteID;
    data['LocaleID'] = this.localeID;

    return data;
  }
}
