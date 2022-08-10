import 'dart:convert';

TopicCommentReplyResponse topicCommentReplyResponseFromJson(String str) =>
    TopicCommentReplyResponse.fromJson(json.decode(str));

dynamic topicCommentReplyResponseToJson(TopicCommentReplyResponse data) =>
    json.encode(data.toJson());

class TopicCommentReplyResponse {
  List<Table> table = [];

  //List<Table1> table1;

  /*TopicCommentReplyResponse({this.table,});*/

  TopicCommentReplyResponse.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        table.add(new Table.fromJson(v));
      });
    }

    /*if (json['Table1'] != null) {
      table1 = new List<Table1>();
      json['Table1'].forEach((v) {
        table1.add(new Table1.fromJson(v));
      });
    }*/
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
    replyID = json['ReplyID'] ?? 0;
    commentID = json['CommentID'] ?? 0;
    topicID = json['TopicID'] ?? "";
    forumID = json['ForumID'] ?? 0;
    message = json['Message'] ?? "";
    postedBy = json['PostedBy'] ?? 0;
    postedDate = json['PostedDate'] ?? "";
    replyBy = json['ReplyBy'] ?? "";
    picture = json['Picture'] ?? "";
    likeState = json['likeState'] ?? false;
    replyProfile = json['ReplyProfile'] ?? "";
    dtPostedDate = json['dtPostedDate'] ?? "";
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

/*class Table1 {
  Table1.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }*/
