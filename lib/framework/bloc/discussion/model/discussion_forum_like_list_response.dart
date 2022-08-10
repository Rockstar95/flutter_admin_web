import 'dart:convert';

List<DiscussionForumLikeListResponse> discussionForumLikeListResponseFromJson(
        String str) =>
    List<DiscussionForumLikeListResponse>.from(json
        .decode(str)
        .map((x) => DiscussionForumLikeListResponse.fromJson(x)));

dynamic discussionForumLikeListResponseToJson(
        List<DiscussionForumLikeListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscussionForumLikeListResponse {
  int userID = 0;
  String userThumb = "";
  String userName = "";
  String userDesg = "";
  String userAddress = "";
  String notifyMsg = "";
  bool check = false;

  DiscussionForumLikeListResponse.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    userThumb = json['UserThumb'];
    userName = json['UserName'];
    userDesg = json['UserDesg'];
    userAddress = json['UserAddress'];
    notifyMsg = json['NotifyMsg'];
    check = json['check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['UserThumb'] = this.userThumb;
    data['UserName'] = this.userName;
    data['UserDesg'] = this.userDesg;
    data['UserAddress'] = this.userAddress;
    data['NotifyMsg'] = this.notifyMsg;
    data['check'] = this.check;
    return data;
  }
}
