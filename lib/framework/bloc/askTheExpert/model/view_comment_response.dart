import 'dart:convert';

ViewCommentResponse viewCommentResponseFromJson(String str) =>
    ViewCommentResponse.fromJson(json.decode(str));

dynamic viewCommentResponseToJson(ViewCommentResponse data) =>
    json.encode(data.toJson());

class ViewCommentResponse {
  List<CommentList> table;

  ViewCommentResponse({required this.table});

  static ViewCommentResponse fromJson(Map<String, dynamic> json) {
    ViewCommentResponse viewCommentResponse = ViewCommentResponse(table: []);
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        viewCommentResponse.table.add(CommentList.fromJson(v));
      });
    }
    return viewCommentResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentList {
  int commentID;
  String commentDescription;
  String commentImage;
  String commentDate;
  int commentUserID;
  int commentQuestionID;
  int commentResponseID;
  String picture;
  String commentedUserName;
  String commentedDate;
  bool isLiked;
  String userCommentImagePath;
  String commentAction;
  String commentImageUploadName;
  String commentUploadIconPath;

  CommentList(
      {this.commentID = 0,
      this.commentDescription = "",
      this.commentImage = "",
      this.commentDate = "",
      this.commentUserID = 0,
      this.commentQuestionID = 0,
      this.commentResponseID = 0,
      this.picture = "",
      this.commentedUserName = "",
      this.commentedDate = "",
      this.isLiked = false,
      this.userCommentImagePath = "",
      this.commentAction = "",
      this.commentImageUploadName = "",
      this.commentUploadIconPath = ""});

  static CommentList fromJson(Map<String, dynamic> json) {
    CommentList commentList = CommentList();
    commentList.commentID = json['CommentID'] ?? 0;
    commentList.commentDescription = json['CommentDescription'] ?? "";
    commentList.commentImage = json['CommentImage'] ?? "";
    commentList.commentDate = json['CommentDate'] ?? "";
    commentList.commentUserID = json['CommentUserID'] ?? 0;
    commentList.commentQuestionID = json['CommentQuestionID'] ?? 0;
    commentList.commentResponseID = json['CommentResponseID'] ?? 0;
    commentList.picture = json['Picture'] ?? "";
    commentList.commentedUserName = json['CommentedUserName'] ?? "";
    commentList.commentedDate = json['CommentedDate'] ?? "";
    commentList.isLiked = json['IsLiked'] ?? false;
    commentList.userCommentImagePath = json['UserCommentImagePath'] ?? "";
    commentList.commentAction = json['CommentAction'] ?? "";
    commentList.commentImageUploadName = json['CommentImageUploadName'] ?? "";
    commentList.commentUploadIconPath = json['CommentUploadIconPath'] ?? "";
    return commentList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CommentID'] = this.commentID;
    data['CommentDescription'] = this.commentDescription;
    data['CommentImage'] = this.commentImage;
    data['CommentDate'] = this.commentDate;
    data['CommentUserID'] = this.commentUserID;
    data['CommentQuestionID'] = this.commentQuestionID;
    data['CommentResponseID'] = this.commentResponseID;
    data['Picture'] = this.picture;
    data['CommentedUserName'] = this.commentedUserName;
    data['CommentedDate'] = this.commentedDate;
    data['IsLiked'] = this.isLiked;
    data['UserCommentImagePath'] = this.userCommentImagePath;
    data['CommentAction'] = this.commentAction;
    data['CommentImageUploadName'] = this.commentImageUploadName;
    data['CommentUploadIconPath'] = this.commentUploadIconPath;
    return data;
  }
}
