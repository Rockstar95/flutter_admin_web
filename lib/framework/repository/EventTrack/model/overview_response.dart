// To parse this JSON data, do
//
//     final tracklistOverviewResponse = tracklistOverviewResponseFromJson(jsonString);

import 'dart:convert';

List<TracklistOverviewResponse> tracklistOverviewResponseFromJson(String str) =>
    List<TracklistOverviewResponse>.from(
        json.decode(str).map((x) => TracklistOverviewResponse.fromJson(x)));

String tracklistOverviewResponseToJson(List<TracklistOverviewResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TracklistOverviewResponse {
  TracklistOverviewResponse({
    this.description,
    this.aboutAuthor,
    this.tags,
    this.datedetails,
    this.longdescription = "",
    this.shortdescription = "",
    this.displayName = "",
    this.firtsandLastname,
    this.about = "",
    this.totalRatings = "",
    this.contentCount = "",
    required this.relatedTags,
    this.createddate = "",
    this.name,
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.timezone,
    this.orgName = "",
    this.profileImgPath = "",
    this.downloadcalendaraction,
  });

  dynamic description;
  dynamic aboutAuthor;
  dynamic tags;
  dynamic datedetails;
  String longdescription = "";
  String shortdescription = "";
  String displayName = "";
  dynamic firtsandLastname;
  String about = "";
  String totalRatings = "";
  String contentCount = "";
  List<RelatedTag> relatedTags = [];
  String createddate = "";
  dynamic name;
  dynamic eventStartDateTime;
  dynamic eventEndDateTime;
  dynamic timezone;
  String orgName = "";
  String profileImgPath = "";
  dynamic downloadcalendaraction;

  factory TracklistOverviewResponse.fromJson(Map<String, dynamic> json) =>
      TracklistOverviewResponse(
        description: json["Description"] ?? "",
        aboutAuthor: json["AboutAuthor"] ?? "",
        tags: json["Tags"] ?? "",
        datedetails: json["Datedetails"] ?? "",
        longdescription: json["longdescription"] ?? "",
        shortdescription: json["shortdescription"] ?? "",
        displayName: json["DisplayName"] ?? "",
        firtsandLastname: json["FirtsandLastname"] ?? "",
        about: json["About"] ?? "",
        totalRatings: json["totalRatings"] ?? "",
        contentCount: json["contentCount"] ?? "",
        relatedTags: json["RelatedTags"] != null
            ? List<RelatedTag>.from(
                json["RelatedTags"].map((x) => RelatedTag.fromJson(x)))
            : [],
        createddate: json["createddate"] ?? "",
        name: json["Name"] ?? "",
        eventStartDateTime: json["EventStartDateTime"] ?? "",
        eventEndDateTime: json["EventEndDateTime"] ?? "",
        timezone: json["Timezone"] ?? "",
        orgName: json["OrgName"] ?? "",
        profileImgPath: json["ProfileImgPath"] ?? "",
        downloadcalendaraction: json["downloadcalendaraction"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Description": description,
        "AboutAuthor": aboutAuthor,
        "Tags": tags,
        "Datedetails": datedetails,
        "longdescription": longdescription,
        "shortdescription": shortdescription,
        "DisplayName": displayName,
        "FirtsandLastname": firtsandLastname,
        "About": about,
        "totalRatings": totalRatings,
        "contentCount": contentCount,
        "RelatedTags": List<dynamic>.from(relatedTags.map((x) => x.toJson())),
        "createddate": createddate,
        "Name": name,
        "EventStartDateTime": eventStartDateTime,
        "EventEndDateTime": eventEndDateTime,
        "Timezone": timezone,
        "OrgName": orgName,
        "ProfileImgPath": profileImgPath,
        "downloadcalendaraction": downloadcalendaraction,
      };
}

class RelatedTag {
  RelatedTag({
    this.tag = "",
  });

  String tag = "";

  factory RelatedTag.fromJson(Map<String, dynamic> json) => RelatedTag(
        tag: json["Tag"],
      );

  Map<String, dynamic> toJson() => {
        "Tag": tag,
      };
}
