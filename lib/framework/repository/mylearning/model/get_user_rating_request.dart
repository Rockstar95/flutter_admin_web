// To parse this JSON data, do
//
//     final getReviewRequest = getReviewRequestFromJson(jsonString);

import 'dart:convert';

GetReviewRequest getReviewRequestFromJson(String str) =>
    GetReviewRequest.fromJson(json.decode(str));

String getReviewRequestToJson(GetReviewRequest data) =>
    json.encode(data.toJson());

class GetReviewRequest {
  GetReviewRequest({
    this.contentId = "",
    this.locale = "",
    this.metadata = "",
    this.intUserId = "",
    this.cartId = "",
    this.iCms = "",
    this.componentId = "",
    this.siteId = "",
    this.detailsCompId = "",
    this.detailsCompInsId = "",
    this.eRitems = "",
    this.skippedRows = 0,
    this.noofRows = 0,
  });

  String contentId;
  String locale;
  String metadata;
  String intUserId;
  String cartId;
  String iCms;
  String componentId;
  String siteId;
  String detailsCompId;
  String detailsCompInsId;
  String eRitems;
  int skippedRows;
  int noofRows;

  factory GetReviewRequest.fromJson(Map<String, dynamic> json) =>
      GetReviewRequest(
        contentId: json["ContentID"] == null ? null : json["ContentID"],
        locale: json["Locale"] == null ? null : json["Locale"],
        metadata: json["metadata"] == null ? null : json["metadata"],
        intUserId: json["intUserID"] == null ? null : json["intUserID"],
        cartId: json["CartID"] == null ? null : json["CartID"],
        iCms: json["iCMS"] == null ? null : json["iCMS"],
        componentId: json["ComponentID"] == null ? null : json["ComponentID"],
        siteId: json["SiteID"] == null ? null : json["SiteID"],
        detailsCompId:
            json["DetailsCompID"] == null ? null : json["DetailsCompID"],
        detailsCompInsId:
            json["DetailsCompInsID"] == null ? null : json["DetailsCompInsID"],
        eRitems: json["ERitems"] == null ? null : json["ERitems"],
        skippedRows: json["SkippedRows"] == null ? null : json["SkippedRows"],
        noofRows: json["NoofRows"] == null ? null : json["NoofRows"],
      );

  Map<String, dynamic> toJson() => {
        "ContentID": contentId == null ? null : contentId,
        "Locale": locale == null ? null : locale,
        "metadata": metadata == null ? null : metadata,
        "intUserID": intUserId == null ? null : intUserId,
        "CartID": cartId == null ? null : cartId,
        "iCMS": iCms == null ? null : iCms,
        "ComponentID": componentId == null ? null : componentId,
        "SiteID": siteId == null ? null : siteId,
        "DetailsCompID": detailsCompId == null ? null : detailsCompId,
        "DetailsCompInsID": detailsCompInsId == null ? null : detailsCompInsId,
        "ERitems": eRitems == null ? null : eRitems,
        "SkippedRows": skippedRows == null ? null : skippedRows,
        "NoofRows": noofRows == null ? null : noofRows,
      };
}
