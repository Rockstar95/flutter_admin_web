// To parse this JSON data, do
//
//     final myCatalogRequest = myCatalogRequestFromJson(jsonString);

import 'dart:convert';

MyCatalogRequest myCatalogRequestFromJson(String str) =>
    MyCatalogRequest.fromJson(json.decode(str));

String myCatalogRequestToJson(MyCatalogRequest data) =>
    json.encode(data.toJson());

class MyCatalogRequest {
  MyCatalogRequest({
    this.pageIndex = 0,
    this.pageSize = 0,
    this.searchText = "",
    this.source = 0,
    this.type = 0,
    this.sortBy = "",
    this.componentId = "",
    this.componentInsId = "",
    this.hideComplete = "",
    this.userId = "",
    this.siteId = "",
    this.orgUnitId = "",
    this.locale = "",
    this.groupBy = "",
    this.categories = "",
    this.objectTypes = "",
    this.skillCats = "",
    this.skills = "",
    this.jobRoles = "",
    this.solutions = "",
    this.ratings = "",
    this.keywords = "",
    this.priceRange = "",
    this.duration = "",
    this.instructors = "",
    this.isArchived = 0,
    this.isWaitList = 0,
    this.isWishListContent = 0,
    this.filterCredits = "",
    this.multiLocation = "",
    this.contentID = "",
    this.contentStatus = "",
  });

  int pageIndex;
  int pageSize;
  String searchText;
  int source;
  int type;
  String sortBy;
  String componentId;
  String componentInsId;
  String hideComplete;
  String userId;
  String siteId;
  String orgUnitId;
  String locale;
  String groupBy;
  String categories;
  String objectTypes;
  String skillCats;
  String skills;
  String jobRoles;
  String solutions;
  String ratings;
  String keywords;
  String priceRange;
  String duration;
  String instructors;
  int isArchived;
  int isWaitList;
  int isWishListContent;
  String filterCredits;
  String multiLocation;
  String contentID;
  String contentStatus;

  factory MyCatalogRequest.fromJson(Map<String, dynamic> json) =>
      MyCatalogRequest(
        pageIndex: json["pageIndex"],
        pageSize: json["pageSize"],
        searchText: json["SearchText"],
        source: json["source"],
        type: json["type"],
        sortBy: json["sortBy"],
        componentId: json["ComponentID"],
        componentInsId: json["ComponentInsID"],
        hideComplete: json["HideComplete"],
        userId: json["UserID"],
        siteId: json["SiteID"],
        orgUnitId: json["OrgUnitID"],
        locale: json["Locale"],
        groupBy: json["groupBy"],
        categories: json["categories"],
        objectTypes: json["objecttypes"],
        skillCats: json["skillcats"],
        skills: json["skills"],
        jobRoles: json["jobroles"],
        solutions: json["solutions"],
        ratings: json["ratings"],
        keywords: json["keywords"],
        priceRange: json["pricerange"],
        duration: json["duration"],
        instructors: json["instructors"],
        isArchived: json["IsArchived"],
        isWaitList: json["IsWaitlist"],
        isWishListContent: json["iswishlistcontent"],
        filterCredits: json["filtercredits"],
        multiLocation: json["multiLocation"],
        contentID: json['ContentID'],
        contentStatus: json['ContentStatus'],
      );

  Map<String, dynamic> toJson() => {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "SearchText": searchText,
        "source": source,
        "type": type,
        "sortBy": sortBy,
        "ComponentID": componentId,
        "ComponentInsID": componentInsId,
        "HideComplete": hideComplete,
        "UserID": userId,
        "SiteID": siteId,
        "OrgUnitID": orgUnitId,
        "Locale": locale,
        "groupBy": groupBy,
        "categories": categories,
        "objecttypes": objectTypes,
        "skillcats": skillCats,
        "skills": skills,
        "jobroles": jobRoles,
        "solutions": solutions,
        "ratings": ratings,
        "keywords": keywords,
        "pricerange": priceRange,
        "duration": duration,
        "instructors": instructors,
        "IsArchived": isArchived,
        "IsWaitlist": isWaitList,
        "iswishlistcontent": isWishListContent,
        "filtercredits": filterCredits,
        "multiLocation": multiLocation,
        "ContentID": contentID,
        "ContentStatus": contentStatus,
      };
}
