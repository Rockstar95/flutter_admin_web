// To parse this JSON data, do
//
//     final getContentTabRequest = getContentTabRequestFromJson(jsonString);

import 'dart:convert';

GetContentTabRequest getContentTabRequestFromJson(String str) =>
    GetContentTabRequest.fromJson(json.decode(str));

String getContentTabRequestToJson(GetContentTabRequest data) =>
    json.encode(data.toJson());

class GetContentTabRequest {
  GetContentTabRequest({
    this.pageIndex = 0,
    this.pageSize = 0,
    this.searchText = "",
    this.contentId = "",
    this.sortBy = "",
    this.componentId = "",
    this.componentInsId = "",
    this.additionalParams = "",
    this.selectedTab = "",
    this.addtionalFilter = "",
    this.locationFilter = "",
    this.userId = "",
    this.siteId = "",
    this.orgUnitId = "",
    this.locale = "",
    this.groupBy = "",
    this.categories = "",
    this.objecttypes = "",
    this.skillcats = "",
    this.skills = "",
    this.jobroles = "",
    this.solutions = "",
    this.keywords = "",
    this.ratings = "",
    this.pricerange = "",
    this.eventdate = "",
    this.certification = "",
    this.filtercredits = "",
    this.duration = "",
    this.instructors = "",
    this.iswishlistcontent,
  });

  int pageIndex = 0;
  int pageSize = 0;
  String searchText = "";
  String contentId = "";
  String sortBy = "";
  String componentId = "";
  String componentInsId = "";
  String additionalParams = "";
  String selectedTab = "";
  String addtionalFilter = "";
  String locationFilter = "";
  String userId = "";
  String siteId = "";
  String orgUnitId = "";
  String locale = "";
  String groupBy = "";
  String categories = "";
  String objecttypes = "";
  String skillcats = "";
  String skills = "";
  String jobroles = "";
  String solutions = "";
  String keywords = "";
  String ratings = "";
  String pricerange = "";
  String eventdate = "";
  String certification = "";
  String filtercredits = "";
  String duration = "";
  String instructors = "";
  dynamic iswishlistcontent;

  factory GetContentTabRequest.fromJson(Map<String, dynamic> json) =>
      GetContentTabRequest(
        pageIndex: json["pageIndex"],
        pageSize: json["pageSize"],
        searchText: json["SearchText"],
        contentId: json["ContentID"],
        sortBy: json["sortBy"],
        componentId: json["ComponentID"],
        componentInsId: json["ComponentInsID"],
        additionalParams: json["AdditionalParams"],
        selectedTab: json["SelectedTab"],
        addtionalFilter: json["AddtionalFilter"],
        locationFilter: json["LocationFilter"],
        userId: json["UserID"],
        siteId: json["SiteID"],
        orgUnitId: json["OrgUnitID"],
        locale: json["Locale"],
        groupBy: json["groupBy"],
        categories: json["categories"],
        objecttypes: json["objecttypes"],
        skillcats: json["skillcats"],
        skills: json["skills"],
        jobroles: json["jobroles"],
        solutions: json["solutions"],
        keywords: json["keywords"],
        ratings: json["ratings"],
        pricerange: json["pricerange"],
        eventdate: json["eventdate"],
        certification: json["certification"],
        filtercredits: json["filtercredits"],
        duration: json["duration"],
        instructors: json["instructors"],
        iswishlistcontent: json["iswishlistcontent"],
      );

  Map<String, dynamic> toJson() => {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "SearchText": searchText,
        "ContentID": contentId,
        "sortBy": sortBy,
        "ComponentID": componentId,
        "ComponentInsID": componentInsId,
        "AdditionalParams": additionalParams,
        "SelectedTab": selectedTab,
        "AddtionalFilter": addtionalFilter,
        "LocationFilter": locationFilter,
        "UserID": userId,
        "SiteID": siteId,
        "OrgUnitID": orgUnitId,
        "Locale": locale,
        "groupBy": groupBy,
        "categories": categories,
        "objecttypes": objecttypes,
        "skillcats": skillcats,
        "skills": skills,
        "jobroles": jobroles,
        "solutions": solutions,
        "keywords": keywords,
        "ratings": ratings,
        "pricerange": pricerange,
        "eventdate": eventdate,
        "certification": certification,
        "filtercredits": filtercredits,
        "duration": duration,
        "instructors": instructors,
        "iswishlistcontent": iswishlistcontent,
      };
}
