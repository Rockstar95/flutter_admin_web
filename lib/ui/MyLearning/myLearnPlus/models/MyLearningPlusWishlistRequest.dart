import 'dart:convert';

MyLearningPlusWishlistRequest myLearnPlusWishRequestFromJson(String str) =>
    MyLearningPlusWishlistRequest.fromJson(json.decode(str));

String myLearnPlusWishRequestToJson(MyLearningPlusWishlistRequest data) =>
    json.encode(data.toJson());

class MyLearningPlusWishlistRequest {
  MyLearningPlusWishlistRequest(
      {this.pageIndex = 0,
      this.pageSize = 0,
      this.searchText = "",
      this.contentID = "",
      this.sortBy = "",
      this.groupBy = "",
      this.keywords = "",
      this.componentID = 0,
      this.componentInsID = 0,
      this.additionalParams = "",
      this.selectedTab = "",
      this.additionalFilter = "",
      this.locationFilter = "",
      this.userID = 0,
      this.siteID = 0,
      this.orgUnitID = "",
      this.locale = "",
      this.categories = "",
      this.objectTypes = "",
      this.skillCats = "",
      this.skills = "",
      this.jobRoles = "",
      this.solutions = "",
      this.ratings = "",
      this.priceRange = "",
      this.eventDate = "",
      this.relatedContent = "",
      this.certification = "",
      this.filterCredits = "",
      this.multiLocation = "",
      this.duration = "",
      this.instructors = "",
      this.learningPortals = "",
      this.isWishlistContent = 0,
      this.homeComponentID = ""});

  int pageIndex = 0;
  int pageSize = 0;
  String contentID = "";
  String searchText = "";
  String sortBy = "";
  String groupBy = "";
  int componentID = 0;
  int componentInsID = 0;
  String additionalParams = "";
  String selectedTab;

  int userID = 0;
  int siteID = 0;
  String orgUnitID = "";
  String locale = "";
  String additionalFilter = "";
  String locationFilter = "";
  String categories = "";
  String objectTypes = "";
  String skillCats = "";
  String skills = "";
  String jobRoles = "";
  String solutions = "";
  String ratings = "";
  String keywords = "";
  String priceRange = "";
  String filterCredits = "";
  String duration = "";
  String instructors = "";
  String multiLocation = "";
  int isWishlistContent = 0;
  String certification = "";
  String eventDate = "";
  String relatedContent = "";
  String learningPortals = "";
  bool pinnedContent = false;
  String homeComponentID = "";

  factory MyLearningPlusWishlistRequest.fromJson(Map<String, dynamic> json) =>
      MyLearningPlusWishlistRequest(
        pageIndex: json["pageIndex"],
        pageSize: json["pageSize"],
        searchText: json["SearchText"],
        contentID: json["ContentID"],
        sortBy: json["sortBy"],
        groupBy: json["groupBy"],
        keywords: json["keywords"],
        componentID: json["ComponentID"],
        componentInsID: json["ComponentInsID"],
        additionalParams: json["AdditionalParams"],
        selectedTab: json["SelectedTab"],
        additionalFilter: json["AddtionalFilter"],
        locationFilter: json["LocationFilter"],
        userID: json["UserID"],
        siteID: json["SiteID"],
        orgUnitID: json["OrgUnitID"],
        locale: json["Locale"],
        categories: json["categories"],
        objectTypes: json["objecttypes"],
        skillCats: json["skillcats"],
        skills: json["skills"],
        jobRoles: json["jobroles"],
        solutions: json["solutions"],
        ratings: json["ratings"],
        priceRange: json["pricerange"],
        eventDate: json["eventdate"],
        relatedContent: json["relatedcontent"],
        certification: json["certification"],
        filterCredits: json["filtercredits"],
        multiLocation: json["multiLocation"],
        duration: json['duration'],
        instructors: json['instructors'],
        learningPortals: json['learningprotals'],
        isWishlistContent: json['iswishlistcontent'],
        homeComponentID: json['HomecomponentID'],
      );

  Map<String, dynamic> toJson() => {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "SearchText": searchText,
        "ContentID": contentID,
        "sortBy": sortBy,
        "groupBy": groupBy,
        "keywords": keywords,
        "ComponentID": componentID,
        "ComponentInsID": componentInsID,
        "AdditionalParams": additionalParams,
        "SelectedTab": selectedTab,
        "AddtionalFilter": additionalFilter,
        "LocationFilter": locationFilter,
        "UserID": userID,
        "SiteID": siteID,
        "OrgUnitID": orgUnitID,
        "Locale": locale,
        "categories": categories,
        "objecttypes": objectTypes,
        "skillcats": skillCats,
        "skills": skills,
        "jobroles": jobRoles,
        "solutions": solutions,
        "ratings": ratings,
        "pricerange": priceRange,
        "eventdate": eventDate,
        "relatedcontent": relatedContent,
        "certification": certification,
        "filtercredits": filterCredits,
        "multiLocation": multiLocation,
        "duration": duration,
        "instructors": instructors,
        "learningprotals": learningPortals,
        "iswishlistcontent": isWishlistContent,
        "HomecomponentID": homeComponentID,
      };
}
