// To parse this JSON data, do
//
//     final myLearningDetailsRequest = myLearningDetailsRequestFromJson(jsonString);

import 'dart:convert';

MyLearningDetailsRequest myLearningDetailsRequestFromJson(String str) =>
    MyLearningDetailsRequest.fromJson(json.decode(str));

String myLearningDetailsRequestToJson(MyLearningDetailsRequest data) =>
    json.encode(data.toJson());

class MyLearningDetailsRequest {
  MyLearningDetailsRequest({
    this.contentId = "",
    this.metadata = "",
    this.locale = "",
    this.intUserId = "",
    this.iCms = false,
    this.componentId = "",
    this.siteId = "",
    this.eRitems = "",
    this.detailsCompId = "",
    this.detailsCompInsId = "",
    this.componentDetailsProperties = "",
    this.hideAdd = "",
    this.objectTypeId = "",
    this.scoId = "",
    this.subscribeErc = false,
  });

  String contentId;
  String metadata;
  String locale;
  String intUserId;
  bool iCms;
  String componentId;
  String siteId;
  String eRitems;
  String detailsCompId;
  String detailsCompInsId;
  String componentDetailsProperties;
  String hideAdd;
  String objectTypeId;
  String scoId;
  bool subscribeErc;

  factory MyLearningDetailsRequest.fromJson(Map<String, dynamic> json) =>
      MyLearningDetailsRequest(
        contentId: json["ContentID"],
        metadata: json["metadata"],
        locale: json["Locale"],
        intUserId: json["intUserID"],
        iCms: json["iCMS"],
        componentId: json["ComponentID"],
        siteId: json["SiteID"],
        eRitems: json["ERitems"],
        detailsCompId: json["DetailsCompID"],
        detailsCompInsId: json["DetailsCompInsID"],
        componentDetailsProperties: json["ComponentDetailsProperties"],
        hideAdd: json["HideAdd: "],
        objectTypeId: json["objectTypeID"],
        scoId: json["scoID"],
        subscribeErc: json["SubscribeERC"],
      );

  Map<String, dynamic> toJson() => {
        "ContentID": contentId,
        "metadata": metadata,
        "Locale": locale,
        "intUserID": intUserId,
        "iCMS": iCms,
        "ComponentID": componentId,
        "SiteID": siteId,
        "ERitems": eRitems,
        "DetailsCompID": detailsCompId,
        "DetailsCompInsID": detailsCompInsId,
        "ComponentDetailsProperties": componentDetailsProperties,
        "HideAdd: ": hideAdd,
        "objectTypeID": objectTypeId,
        "scoID": scoId,
        "SubscribeERC": subscribeErc,
      };
}
