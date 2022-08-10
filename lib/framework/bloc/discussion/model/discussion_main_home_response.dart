import 'dart:convert';

DiscussionMainHomeResponse discussionMainHomeResponseFromJson(String str) =>
    DiscussionMainHomeResponse.fromJson(json.decode(str));

dynamic discussionMainHomeResponseToJson(DiscussionMainHomeResponse data) =>
    json.encode(data.toJson());

class DiscussionMainHomeResponse {
  List<ForumList> forumList = [];
  int totalRecordCount = 0;

  DiscussionMainHomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['forumList'] != null) {
      json['forumList'].forEach((v) {
        forumList.add(new ForumList.fromJson(v));
      });
    }
    totalRecordCount = json['TotalRecordCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.forumList != dynamic) {
      data['forumList'] = this.forumList.map((v) => v.toJson()).toList();
    }
    data['TotalRecordCount'] = this.totalRecordCount;
    return data;
  }
}

class ForumList {
  int forumID = 0;
  String name = "";
  String description = "";
  int parentForumID = 0;
  int displayOrder = 0;
  int siteID = 0;
  int createdUserID = 0;
  String createdDate = "";
  bool active = false;
  bool requiresSubscription = false;
  bool createNewTopic = false;
  bool attachFile = false;
  bool likePosts = false;
  String sendEmail = "";
  bool moderation = false;
  bool isPrivate = false;
  String author = "";
  int noOfTopics = 0;
  int totalPosts = 0;
  int existing = 0;
  List<TotalLikes> totalLikes = [];
  String dFProfileImage = "";
  dynamic dFUpdateTime;
  dynamic dFChangeUpdateTime;
  String forumThumbnailPath = "";
  String descriptionWithLimit = "";
  String moderatorID = "";
  String updatedAuthor = "";
  String updatedDate = "";
  String moderatorName = "";
  bool allowShare = false;
  String descriptionWithoutLimit = "";
  dynamic categoryIDs;
  bool allowPin = false;

  ForumList.fromJson(Map<String, dynamic> json) {
    forumID = json['ForumID'] ?? 0;
    name = json['Name'] ?? "";
    description = json['Description'] ?? "";
    parentForumID = json['ParentForumID'] ?? 0;
    displayOrder = json['DisplayOrder'] ?? 0;
    siteID = json['SiteID'] ?? 0;
    createdUserID = json['CreatedUserID'] ?? 0;
    createdDate = json['CreatedDate'] ?? "";
    active = json['Active'] ?? false;
    requiresSubscription = json['RequiresSubscription'] ?? false;
    createNewTopic = json['CreateNewTopic'] ?? false;
    attachFile = json['AttachFile'] ?? false;
    likePosts = json['LikePosts'] ?? false;
    sendEmail = json['SendEmail'] ?? "";
    moderation = json['Moderation'] ?? false;
    isPrivate = json['IsPrivate'] ?? false;
    author = json['Author'] ?? "";
    noOfTopics = json['NoOfTopics'] ?? 0;
    totalPosts = json['TotalPosts'] ?? 0;
    existing = json['Existing'] ?? 0;
    (json['TotalLikes'] ?? []).forEach((v) {
      totalLikes.add(new TotalLikes.fromJson(v));
    });
    dFProfileImage = json['DFProfileImage'] ?? "";
    dFUpdateTime = json['DFUpdateTime'];
    dFChangeUpdateTime = json['DFChangeUpdateTime'];
    forumThumbnailPath = json['ForumThumbnailPath'] ?? "";
    descriptionWithLimit = json['DescriptionWithLimit'] ?? "";
    moderatorID = json['ModeratorID'] ?? "";
    updatedAuthor = json['UpdatedAuthor'] ?? "";
    updatedDate = json['UpdatedDate'] ?? "";
    moderatorName = json['ModeratorName'] ?? "";
    allowShare = json['AllowShare'] ?? false;
    descriptionWithoutLimit = json['DescriptionWithoutLimit'] ?? "";
    categoryIDs = json['CategoryIDs'];
    allowPin = json['AllowPin'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ForumID'] = this.forumID;
    data['Name'] = this.name;
    data['Description'] = this.description;
    data['ParentForumID'] = this.parentForumID;
    data['DisplayOrder'] = this.displayOrder;
    data['SiteID'] = this.siteID;
    data['CreatedUserID'] = this.createdUserID;
    data['CreatedDate'] = this.createdDate;
    data['Active'] = this.active;
    data['RequiresSubscription'] = this.requiresSubscription;
    data['CreateNewTopic'] = this.createNewTopic;
    data['AttachFile'] = this.attachFile;
    data['LikePosts'] = this.likePosts;
    data['SendEmail'] = this.sendEmail;
    data['Moderation'] = this.moderation;
    data['IsPrivate'] = this.isPrivate;
    data['Author'] = this.author;
    data['NoOfTopics'] = this.noOfTopics;
    data['TotalPosts'] = this.totalPosts;
    data['Existing'] = this.existing;
    if (this.totalLikes != dynamic) {
      data['TotalLikes'] = this.totalLikes.map((v) => v.toJson()).toList();
    }
    data['DFProfileImage'] = this.dFProfileImage;
    data['DFUpdateTime'] = this.dFUpdateTime;
    data['DFChangeUpdateTime'] = this.dFChangeUpdateTime;
    data['ForumThumbnailPath'] = this.forumThumbnailPath;
    data['DescriptionWithLimit'] = this.descriptionWithLimit;
    data['ModeratorID'] = this.moderatorID;
    data['UpdatedAuthor'] = this.updatedAuthor;
    data['UpdatedDate'] = this.updatedDate;
    data['ModeratorName'] = this.moderatorName;
    data['AllowShare'] = this.allowShare;
    data['DescriptionWithoutLimit'] = this.descriptionWithoutLimit;
    data['CategoryIDs'] = this.categoryIDs;
    data['AllowPin'] = this.allowPin;
    return data;
  }
}

class TotalLikes {
  int userID = 0;
  String objectID = "";

  TotalLikes.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    objectID = json['ObjectID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['ObjectID'] = this.objectID;
    return data;
  }
}
