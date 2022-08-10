import 'dart:convert';

DiscussionMainHomeRequest discussionMainHomeRequestFromJson(String str) =>
    DiscussionMainHomeRequest.fromJson(json.decode(str));

String discussionMainHomeRequestToJson(DiscussionMainHomeRequest data) => json.encode(data.toJson());

class DiscussionMainHomeRequest {
  int intUserID = 0;
  int intSiteID = 0;
  String strLocale = "";
  String intCompID = "";
  String intCompInsID = "";
  int pageIndex = 0;
  int pageSize = 0;
  String strSearchText = "";
  String categoryIds = "";
  String forumContentID = "";

  DiscussionMainHomeRequest(
      {this.intUserID = 0,
      this.intSiteID = 0,
      this.strLocale = "",
      this.intCompID = "",
      this.intCompInsID = "",
      this.pageIndex = 0,
      this.pageSize = 0,
      this.strSearchText = "",
      this.categoryIds = "",
      this.forumContentID = ""});

  DiscussionMainHomeRequest.fromJson(Map<String, dynamic> json) {
    intUserID = json['intUserID'];
    intSiteID = json['intSiteID'];
    strLocale = json['strLocale'];
    intCompID = json['intCompID'];
    intCompInsID = json['intCompInsID'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    strSearchText = json['strSearchText'];
    categoryIds = json['CategoryIds'];
    forumContentID = json['forumContentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intUserID'] = this.intUserID;
    data['intSiteID'] = this.intSiteID;
    data['strLocale'] = this.strLocale;
    data['intCompID'] = this.intCompID;
    data['intCompInsID'] = this.intCompInsID;
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['strSearchText'] = this.strSearchText;
    data['CategoryIds'] = this.categoryIds;
    data['forumContentID'] = this.forumContentID;
    return data;
  }
}
