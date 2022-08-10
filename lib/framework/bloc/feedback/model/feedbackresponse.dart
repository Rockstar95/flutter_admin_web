import 'dart:convert';

List<FeedbackModel> feedbackModelFromJson(String str) =>
    List<FeedbackModel>.from(
        json.decode(str).map((x) => FeedbackModel.fromJson(x)));

String feedbackModelToJson(List<FeedbackModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedbackResponse {
  List<FeedbackModel> feedbackList = [];

  FeedbackResponse({required this.feedbackList});
}

class FeedbackModel {
  int iD = 0;
  String titlename = "";
  String desc = "";
  String imagepath = "";
  String url = "";
  dynamic userid;
  String userProfilePathdata = "";
  String userDisplayName = "";
  String date = "";
  String feedbackUploadImageName = "";
  String saveimagepath = "";
  String showimagepopup = "";

  /*FeedbackModel(
      {this.iD,
      this.titlename,
      this.desc,
      this.imagepath,
      this.url,
      this.userid,
      this.userProfilePathdata,
      this.userDisplayName,
      this.date,
      this.feedbackUploadImageName,
      this.saveimagepath,
      this.showimagepopup});*/

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    titlename = json['titlename'];
    desc = json['desc'];
    imagepath = json['imagepath'];
    url = json['url'];
    userid = json['userid'];
    userProfilePathdata = json['UserProfilePathdata'];
    userDisplayName = json['UserDisplayName'];
    date = json['date'];
    feedbackUploadImageName = json['FeedbackUploadImageName'];
    saveimagepath = json['saveimagepath'];
    showimagepopup = json['showimagepopup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['titlename'] = this.titlename;
    data['desc'] = this.desc;
    data['imagepath'] = this.imagepath;
    data['url'] = this.url;
    data['userid'] = this.userid;
    data['UserProfilePathdata'] = this.userProfilePathdata;
    data['UserDisplayName'] = this.userDisplayName;
    data['date'] = this.date;
    data['FeedbackUploadImageName'] = this.feedbackUploadImageName;
    data['saveimagepath'] = this.saveimagepath;
    data['showimagepopup'] = this.showimagepopup;
    return data;
  }
}
