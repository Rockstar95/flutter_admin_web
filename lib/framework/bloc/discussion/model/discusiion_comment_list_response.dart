import 'dart:convert';

List<DiscussionCommentListResponse> discussionCommentListResponseFromJson(
        String str) =>
    List<DiscussionCommentListResponse>.from(
        json.decode(str).map((x) => DiscussionCommentListResponse.fromJson(x)));

dynamic discussionCommentListResponseToJson(
        List<DiscussionCommentListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscussionCommentListResponse {
  int commentid = 0;
  String topicid = "";
  int forumid = 0;
  String posteddate = "";
  String message = "";
  int postedby = 0;
  int siteid = 0;
  String replyID = "";
  String commentedBy = "";
  String commentedFromDays = "";
  String commentFileUploadPath = "";
  String commentFileUploadName = "";
  String commentImageUploadName = "";
  String commentUploadIconPath = "";
  bool likeState = false;
  int commentLikes = 0;
  int commentRepliesCount = 0;
  String commentUserProfile = "";
  dynamic likedUserList;

  DiscussionCommentListResponse.fromJson(Map<String, dynamic> json) {
    commentid = json['commentid'];
    topicid = json['topicid'];
    forumid = json['forumid'];
    posteddate = json['posteddate'];
    message = json['message'];
    postedby = json['postedby'];
    siteid = json['siteid'];
    replyID = json['ReplyID'];
    commentedBy = json['CommentedBy'];
    commentedFromDays = json['CommentedFromDays'];
    commentFileUploadPath = json['CommentFileUploadPath'];
    commentFileUploadName = json['CommentFileUploadName'];
    commentImageUploadName = json['CommentImageUploadName'];
    commentUploadIconPath = json['CommentUploadIconPath'];
    likeState = json['likeState'];
    commentLikes = json['CommentLikes'];
    commentRepliesCount = json['CommentRepliesCount'];
    commentUserProfile = json['CommentUserProfile'];
    likedUserList = json['LikedUserList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentid'] = this.commentid;
    data['topicid'] = this.topicid;
    data['forumid'] = this.forumid;
    data['posteddate'] = this.posteddate;
    data['message'] = this.message;
    data['postedby'] = this.postedby;
    data['siteid'] = this.siteid;
    data['ReplyID'] = this.replyID;
    data['CommentedBy'] = this.commentedBy;
    data['CommentedFromDays'] = this.commentedFromDays;
    data['CommentFileUploadPath'] = this.commentFileUploadPath;
    data['CommentFileUploadName'] = this.commentFileUploadName;
    data['CommentImageUploadName'] = this.commentImageUploadName;
    data['CommentUploadIconPath'] = this.commentUploadIconPath;
    data['likeState'] = this.likeState;
    data['CommentLikes'] = this.commentLikes;
    data['CommentRepliesCount'] = this.commentRepliesCount;
    data['CommentUserProfile'] = this.commentUserProfile;
    data['LikedUserList'] = this.likedUserList;
    return data;
  }
}
