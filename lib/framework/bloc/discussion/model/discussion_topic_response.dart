import 'dart:convert';

DiscussionTopicResponse discussionTopicResponseFromJson(String str) =>
    DiscussionTopicResponse.fromJson(json.decode(str));

dynamic discussionTopicResponseToJson(DiscussionTopicResponse data) =>
    json.encode(data.toJson());

class DiscussionTopicResponse {
  List<TopicList> topicList = [];

  /*DiscussionTopicResponse({this.topicList});*/

  DiscussionTopicResponse.fromJson(Map<String, dynamic> json) {
    if (json['TopicList'] != null) {
      json['TopicList'].forEach((v) {
        topicList.add(new TopicList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topicList != null) {
      data['TopicList'] = this.topicList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopicList {
  String contentID = "";
  String name = "";
  String createdDate = "";
  int createdUserID = 0;
  int noOfReplies = 0;
  int noOfViews = 0;
  dynamic longDescription;
  dynamic latestReplyBy;
  dynamic author;
  dynamic uploadFileName;
  dynamic updatedTime;
  dynamic createdTime;
  dynamic modifiedUserName;
  dynamic uploadedImageName;
  dynamic topicImageUploadName;
  dynamic topicUploadIconPath;
  int likes = 0;
  dynamic likeState;
  dynamic topicUserProfile;
  dynamic isPin;
  int pinID = 0;
  dynamic comments;
  dynamic likedUserList;
  bool isLike = false;

  /*TopicList(
      {this.contentID,
        this.name,
        this.createdDate,
        this.createdUserID,
        this.noOfReplies,
        this.noOfViews,
        this.longDescription,
        this.latestReplyBy,
        this.author,
        this.uploadFileName,
        this.updatedTime,
        this.createdTime,
        this.modifiedUserName,
        this.uploadedImageName,
        this.topicImageUploadName,
        this.topicUploadIconPath,
        this.likes,
        this.likeState,
        this.topicUserProfile,
        this.isPin,
        this.pinID,
        this.comments,
        this.likedUserList,
      this.isLike});*/

  TopicList.fromJson(Map<String, dynamic> json) {
    contentID = json['ContentID'] ?? "";
    name = json['Name'] ?? "";
    createdDate = json['CreatedDate'] ?? "";
    createdUserID = json['CreatedUserID'] ?? 0;
    noOfReplies = json['NoOfReplies'] ?? 0;
    noOfViews = json['NoOfViews'] ?? 0;
    longDescription = json['LongDescription'];
    latestReplyBy = json['LatestReplyBy'];
    author = json['Author'];
    uploadFileName = json['UploadFileName'];
    updatedTime = json['UpdatedTime'];
    createdTime = json['CreatedTime'];
    modifiedUserName = json['ModifiedUserName'];
    uploadedImageName = json['UploadedImageName'];
    topicImageUploadName = json['TopicImageUploadName'];
    topicUploadIconPath = json['TopicUploadIconPath'];
    likes = json['Likes'] ?? 0;
    likeState = json['likeState'];
    topicUserProfile = json['TopicUserProfile'];
    isPin = json['IsPin'];
    pinID = json['PinID'] ?? 0;
    comments = json['Comments'];
    likedUserList = json['LikedUserList'];
    isLike = json['isLike'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContentID'] = this.contentID;
    data['Name'] = this.name;
    data['CreatedDate'] = this.createdDate;
    data['CreatedUserID'] = this.createdUserID;
    data['NoOfReplies'] = this.noOfReplies;
    data['NoOfViews'] = this.noOfViews;
    data['LongDescription'] = this.longDescription;
    data['LatestReplyBy'] = this.latestReplyBy;
    data['Author'] = this.author;
    data['UploadFileName'] = this.uploadFileName;
    data['UpdatedTime'] = this.updatedTime;
    data['CreatedTime'] = this.createdTime;
    data['ModifiedUserName'] = this.modifiedUserName;
    data['UploadedImageName'] = this.uploadedImageName;
    data['TopicImageUploadName'] = this.topicImageUploadName;
    data['TopicUploadIconPath'] = this.topicUploadIconPath;
    data['Likes'] = this.likes;
    data['likeState'] = this.likeState;
    data['TopicUserProfile'] = this.topicUserProfile;
    data['IsPin'] = this.isPin;
    data['PinID'] = this.pinID;
    data['Comments'] = this.comments;
    data['LikedUserList'] = this.likedUserList;
    data['isLike'] = this.isLike;
    return data;
  }
}
