import 'dart:convert';

DiscussionTopicCommentResponse discussionTopicCommentResponseFromJson(
        String str) =>
    DiscussionTopicCommentResponse.fromJson(json.decode(str));

dynamic discussionTopicCommentResponseToJson(
        DiscussionTopicCommentResponse data) =>
    json.encode(data.toJson());

class DiscussionTopicCommentResponse {
  List<Table> table = [];

  /*DiscussionTopicCommentResponse({
    this.table,
  });*/

  DiscussionTopicCommentResponse.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        table.add(new Table.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Table {
  int replyID = 0;
  int commentID = 0;
  String topicID = "";
  int forumID = 0;
  String message = "";
  int postedBy = 0;
  String postedDate = "";
  String replyBy = "";
  String picture = "";
  bool likeState = false;
  String replyProfile = "";
  String dtPostedDate = "";

  /*Table(
      {this.replyID,
      this.commentID,
      this.topicID,
      this.forumID,
      this.message,
      this.postedBy,
      this.postedDate,
      this.replyBy,
      this.picture,
      this.likeState,
      this.replyProfile,
      this.dtPostedDate});*/

  Table.fromJson(Map<String, dynamic> json) {
    replyID = json['ReplyID'];
    commentID = json['CommentID'];
    topicID = json['TopicID'];
    forumID = json['ForumID'];
    message = json['Message'];
    postedBy = json['PostedBy'];
    postedDate = json['PostedDate'];
    replyBy = json['ReplyBy'];
    picture = json['Picture'];
    likeState = json['likeState'];
    replyProfile = json['ReplyProfile'];
    dtPostedDate = json['dtPostedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReplyID'] = this.replyID;
    data['CommentID'] = this.commentID;
    data['TopicID'] = this.topicID;
    data['ForumID'] = this.forumID;
    data['Message'] = this.message;
    data['PostedBy'] = this.postedBy;
    data['PostedDate'] = this.postedDate;
    data['ReplyBy'] = this.replyBy;
    data['Picture'] = this.picture;
    data['likeState'] = this.likeState;
    data['ReplyProfile'] = this.replyProfile;
    data['dtPostedDate'] = this.dtPostedDate;
    return data;
  }
}
