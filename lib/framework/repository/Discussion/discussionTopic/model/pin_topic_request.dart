import 'dart:convert';

PinTopicRequest pinTopicRequestFromJson(String str) =>
    PinTopicRequest.fromJson(json.decode(str));

String pinTopicRequestToJson(PinTopicRequest data) =>
    json.encode(data.toJson());

class PinTopicRequest {
  int forumID = 0;
  String strContentID = "";
  bool isPin = false;
  int userID = 0;

  PinTopicRequest(
      {this.forumID = 0,
      this.strContentID = "",
      this.isPin = false,
      this.userID = 0});

  PinTopicRequest.fromJson(Map<String, dynamic> json) {
    forumID = json['ForumID'];
    strContentID = json['strContentID'];
    isPin = json['IsPin'];
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ForumID'] = this.forumID;
    data['strContentID'] = this.strContentID;
    data['IsPin'] = this.isPin;
    data['UserID'] = this.userID;
    return data;
  }
}
