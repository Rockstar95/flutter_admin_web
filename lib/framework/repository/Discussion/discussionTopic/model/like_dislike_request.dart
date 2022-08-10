import 'dart:convert';

LikeDisLikeRequest likeDisLikeRequestFromJson(String str) =>
    LikeDisLikeRequest.fromJson(json.decode(str));

String likeDisLikeRequestToJson(LikeDisLikeRequest data) =>
    json.encode(data.toJson());

class LikeDisLikeRequest {
  int intUserID = 0;
  String strObjectID = "";
  int intTypeID = 0;
  bool blnIsLiked = false;
  int intSiteID = 0;
  String strLocale = "";

  LikeDisLikeRequest(
      {this.intUserID = 0,
      this.strObjectID = "",
      this.intTypeID = 0,
      this.blnIsLiked = false,
      this.intSiteID = 0,
      this.strLocale = ""});

  LikeDisLikeRequest.fromJson(Map<String, dynamic> json) {
    intUserID = json['intUserID'];
    strObjectID = json['strObjectID'];
    intTypeID = json['intTypeID'];
    blnIsLiked = json['blnIsLiked'];
    intSiteID = json['intSiteID'];
    strLocale = json['strLocale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intUserID'] = this.intUserID;
    data['strObjectID'] = this.strObjectID;
    data['intTypeID'] = this.intTypeID;
    data['blnIsLiked'] = this.blnIsLiked;
    data['intSiteID'] = this.intSiteID;
    data['strLocale'] = this.strLocale;
    return data;
  }
}
