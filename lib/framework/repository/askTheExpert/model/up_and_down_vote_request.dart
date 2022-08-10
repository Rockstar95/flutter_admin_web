import 'dart:convert';

UpAndDownVoteRequest upAndDownVoteRequestFromJson(String str) =>
    UpAndDownVoteRequest.fromJson(json.decode(str));

String upAndDownVoteRequestToJson(UpAndDownVoteRequest data) =>
    json.encode(data.toJson());

class UpAndDownVoteRequest {
  int intUserID = 0;
  String strObjectID = "";
  int intTypeID = 0;
  bool blnIsLiked = false;
  int intSiteID = 0;

  UpAndDownVoteRequest(
      {this.intUserID = 0,
      this.strObjectID = "",
      this.intTypeID = 0,
      this.blnIsLiked = false,
      this.intSiteID = 0});

  UpAndDownVoteRequest.fromJson(Map<String, dynamic> json) {
    intUserID = json['intUserID'];
    strObjectID = json['strObjectID'];
    intTypeID = json['intTypeID'];
    blnIsLiked = json['blnIsLiked'];
    intSiteID = json['intSiteID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intUserID'] = this.intUserID;
    data['strObjectID'] = this.strObjectID;
    data['intTypeID'] = this.intTypeID;
    data['blnIsLiked'] = this.blnIsLiked;
    data['intSiteID'] = this.intSiteID;
    return data;
  }
}
