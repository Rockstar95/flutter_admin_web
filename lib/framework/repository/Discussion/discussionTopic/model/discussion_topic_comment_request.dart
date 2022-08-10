import 'dart:convert';

DiscussionTopicCommentRequest discussionTopicCommentRequestFromJson(
        String str) =>
    DiscussionTopicCommentRequest.fromJson(json.decode(str));

String discussionTopicCommentRequestToJson(DiscussionTopicCommentRequest data) =>
    json.encode(data.toJson());

class DiscussionTopicCommentRequest {
  String topicID = "";
  String topicName = "";
  int forumID = 0;
  String forumTitle = "";
  String message = "";
  int userID = 0;
  int siteID = 0;
  String localeID = "";
  String strAttachFile = "";
  String strReplyID = "";

  DiscussionTopicCommentRequest(
      {this.topicID = "",
      this.topicName = "",
      this.forumID = 0,
      this.forumTitle = "",
      this.message = "",
      this.userID = 0,
      this.siteID = 0,
      this.localeID = "",
      this.strAttachFile = "",
      this.strReplyID = ""});

  DiscussionTopicCommentRequest.fromJson(Map<String, dynamic> json) {
    topicID = json['TopicID'];
    topicName = json['TopicName'];
    forumID = json['ForumID'];
    forumTitle = json['ForumTitle'];
    message = json['Message'];
    userID = json['UserID'];
    siteID = json['SiteID'];
    localeID = json['LocaleID'];
    strAttachFile = json['strAttachFile'];
    strReplyID = json['strReplyID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['TopicID'] = this.topicID;
    data['TopicName'] = this.topicName;
    data['ForumID'] = this.forumID;
    data['ForumTitle'] = this.forumTitle;
    data['Message'] = this.message;
    data['UserID'] = this.userID;
    data['SiteID'] = this.siteID;
    data['LocaleID'] = this.localeID;
    data['strAttachFile'] = this.strAttachFile;
    data['strReplyID'] = this.strReplyID;
    return data;
  }
}
