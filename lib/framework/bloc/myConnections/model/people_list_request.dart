import 'dart:convert';

PeopleListRequest peopleListRequestFromJson(String str) =>
    PeopleListRequest.fromJson(json.decode(str));

dynamic peopleListRequestToJson(PeopleListRequest data) =>
    json.encode(data.toJson());

class PeopleListRequest {
  PeopleListRequest({
    this.componentId = 0,
    this.componentInstanceId = 0,
    this.userId = "",
    this.siteId = "",
    this.locale = "",
    this.sortBy = "",
    this.sortType = "",
    this.pageIndex = 0,
    this.pageSize = 0,
    this.filterType = "",
    this.tabId = "",
    this.searchText = "",
    this.contentid = "",
    this.location = "",
    this.company = "",
    this.skilllevels = "",
    this.firstname = "",
    this.lastname = "",
    this.skillcats = "",
    this.skills = "",
    this.jobroles = "",
  });

  int componentId = 0;
  int componentInstanceId = 0;
  String userId = "";
  String siteId = "";
  String locale = "";
  String sortBy = "";
  String sortType = "";
  int pageIndex = 0;
  int pageSize = 0;
  String filterType = "";
  String tabId = "";
  String searchText = "";
  String contentid = "";
  String location = "";
  String company = "";
  String skilllevels = "";
  String firstname = "";
  String lastname = "";
  String skillcats = "";
  String skills = "";
  String jobroles = "";

  factory PeopleListRequest.fromJson(Map<String, dynamic> json) =>
      PeopleListRequest(
        componentId: json["ComponentID"],
        componentInstanceId: json["ComponentInstanceID"],
        userId: json["UserID"],
        siteId: json["SiteID"],
        locale: json["Locale"],
        sortBy: json["sortBy"],
        sortType: json["sortType"],
        pageIndex: json["pageIndex"],
        pageSize: json["pageSize"],
        filterType: json["filterType"],
        tabId: json["TabID"],
        searchText: json["SearchText"],
        contentid: json["contentid"],
        location: json["location"],
        company: json["company"],
        skilllevels: json["skilllevels"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        skillcats: json["skillcats"],
        skills: json["skills"],
        jobroles: json["jobroles"],
      );

  Map<String, dynamic> toJson() => {
        "ComponentID": componentId,
        "ComponentInstanceID": componentInstanceId,
        "UserID": userId,
        "SiteID": siteId,
        "Locale": locale,
        "sortBy": sortBy,
        "sortType": sortType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "filterType": filterType,
        "TabID": tabId,
        "SearchText": searchText,
        "contentid": contentid,
        "location": location,
        "company": company,
        "skilllevels": skilllevels,
        "firstname": firstname,
        "lastname": lastname,
        "skillcats": skillcats,
        "skills": skills,
        "jobroles": jobroles,
      };
}
