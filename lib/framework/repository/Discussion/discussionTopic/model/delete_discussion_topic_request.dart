import 'dart:convert';

DeleteDiscussionTopicRequest deleteDiscussionTopicRequestFromJson(String str) =>
    DeleteDiscussionTopicRequest.fromJson(json.decode(str));

String deleteDiscussionTopicRequestToJson(DeleteDiscussionTopicRequest data) =>
    json.encode(data.toJson());

class DeleteDiscussionTopicRequest {
  String topicID = "";
  int forumID = 0;
  String forumName = "";
  int userID = 0;
  int siteID = 0;
  String localeID = "";

  DeleteDiscussionTopicRequest(
      {this.topicID = "",
      this.forumID = 0,
      this.forumName = "",
      this.userID = 0,
      this.siteID = 0,
      this.localeID = ""});

  DeleteDiscussionTopicRequest.fromJson(Map<String, dynamic> json) {
    topicID = json['TopicID'];
    forumID = json['ForumID'];
    forumName = json['ForumName'];
    userID = json['UserID'];
    localeID = json['LocaleID'];
    siteID = json['SiteID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TopicID'] = this.topicID;
    data['ForumID'] = this.forumID;
    data['ForumName'] = this.forumName;
    data['UserID'] = this.userID;
    data['LocaleID'] = this.localeID;
    data['SiteID'] = this.siteID;

    return data;
  }
}
