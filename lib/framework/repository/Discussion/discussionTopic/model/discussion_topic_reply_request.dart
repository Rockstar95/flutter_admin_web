import 'dart:convert';

DiscussionTopicReplyRequest discussionTopicReplyRequestFromJson(String str) =>
    DiscussionTopicReplyRequest.fromJson(json.decode(str));

String discussionTopicRelyRequestToJson(DiscussionTopicReplyRequest data) =>
    json.encode(data.toJson());

class DiscussionTopicReplyRequest {
  int strCommentID = 0;
  String topicID = "";
  int forumID = 0;
  String involvedUserIDList = "";
  String topicName = "";
  String strAttachFile = "";
  String message = "";
  String localeID = "";
  String strReplyID = "";
  int userID = 0;
  int siteID = 0;
  String forumTitle = "";
  String strCommenttxt = "";

  DiscussionTopicReplyRequest(
      {this.strCommentID = 0,
      this.topicID = "",
      this.forumID = 0,
      this.involvedUserIDList = "",
      this.topicName = "",
      this.strAttachFile = "",
      this.message = "",
      this.localeID = "",
      this.strReplyID = "",
      this.userID = 0,
      this.siteID = 0,
      this.forumTitle = "",
      this.strCommenttxt = ""});

  DiscussionTopicReplyRequest.fromJson(Map<String, dynamic> json) {
    strCommentID = json['strCommentID'];
    topicID = json['TopicID'];
    forumID = json['ForumID'];
    involvedUserIDList = json['InvolvedUserIDList'];
    topicName = json['TopicName'];
    strAttachFile = json['strAttachFile'];
    message = json['Message'];
    localeID = json['LocaleID'];
    strReplyID = json['strReplyID'];
    userID = json['UserID'];
    siteID = json['SiteID'];
    forumTitle = json['ForumTitle'];
    strCommenttxt = json['strCommenttxt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strCommentID'] = this.strCommentID;
    data['TopicID'] = this.topicID;
    data['ForumID'] = this.forumID;
    data['InvolvedUserIDList'] = this.involvedUserIDList;
    data['TopicName'] = this.topicName;
    data['strAttachFile'] = this.strAttachFile;
    data['Message'] = this.message;
    data['LocaleID'] = this.localeID;
    data['strReplyID'] = this.strReplyID;
    data['UserID'] = this.userID;
    data['SiteID'] = this.siteID;
    data['ForumTitle'] = this.forumTitle;
    data['strCommenttxt'] = this.strCommenttxt;
    return data;
  }
}
