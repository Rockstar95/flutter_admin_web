import 'dart:convert';

List<LikeDislikeListResponse> likeDislikeListResponseFromJson(String str) =>
    List<LikeDislikeListResponse>.from(
        json.decode(str).map((x) => LikeDislikeListResponse.fromJson(x)));

dynamic likeDislikeListResponseToJson(List<LikeDislikeListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LikeDislikeListResponse {
  int userID = 0;
  String userThumb = "";
  String userName = "";
  String userDesg = "";
  String userAddress = "";
  String notifyMsg = "";
  bool check = false;

  /*LikeDislikeListResponse(
      {this.userID,
      this.userThumb,
      this.userName,
      this.userDesg,
      this.userAddress,
      this.notifyMsg,
      this.check});*/

  LikeDislikeListResponse.fromJson(Map<String, dynamic> json) {
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
