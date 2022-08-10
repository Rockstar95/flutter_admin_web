import 'dart:convert';

DeleteCommentRequest deleteCommentRequestFromJson(String str) =>
    DeleteCommentRequest.fromJson(json.decode(str));

dynamic deleteCommentRequestToJson(DeleteCommentRequest data) =>
    json.encode(data.toJson());

class DeleteCommentRequest {
  String topicID = "";
  int forumID = 0;
  String replyID = "";
  String topicName = "";
  int siteID = 0;
  int userID = 0;
  String localeID = "";
  int noofReplies = 0;
  String lastPostedDate = "";
  int createdUserID = 0;
  String attachementPath = "";

  DeleteCommentRequest(
      {this.topicID = "",
      this.forumID = 0,
      this.replyID = "",
      this.topicName = "",
      this.siteID = 0,
      this.userID = 0,
      this.localeID = "",
      this.noofReplies = 0,
      this.lastPostedDate = "",
      this.createdUserID = 0,
      this.attachementPath = ""});

  DeleteCommentRequest.fromJson(Map<String, dynamic> json) {
    topicID = json['TopicID'];
    forumID = json['ForumID'];
    replyID = json['ReplyID'];
    topicName = json['TopicName'];
    userID = json['UserID'];
    siteID = json['SiteID'];
    localeID = json['LocaleID'];
    noofReplies = json['NoofReplies'];
    lastPostedDate = json['LastPostedDate'];
    createdUserID = json['CreatedUserID'];
    attachementPath = json['AttachementPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TopicID'] = this.topicID;
    data['ForumID'] = this.forumID;
    data['ReplyID'] = this.replyID;
    data['TopicName'] = this.topicName;
    data['UserID'] = this.userID;
    data['SiteID'] = this.siteID;
    data['LocaleID'] = this.localeID;
    data['NoofReplies'] = this.noofReplies;
    data['LastPostedDate'] = this.lastPostedDate;
    data['CreatedUserID'] = this.createdUserID;
    data['AttachementPath'] = this.attachementPath;
    return data;
  }
}
