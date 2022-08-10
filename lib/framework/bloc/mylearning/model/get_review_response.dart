// To parse this JSON data, do
//
//     final getReviewResponse = getReviewResponseFromJson(jsonString);

import 'dart:convert';

GetReviewResponse getReviewResponseFromJson(String str) =>
    GetReviewResponse.fromJson(json.decode(str));

String getReviewResponseToJson(GetReviewResponse data) =>
    json.encode(data.toJson());

class GetReviewResponse {
  GetReviewResponse({
    this.recordCount = 0,
    required this.userRatingDetails,
    this.editRating,
  });

  int recordCount = 0;
  List<EditRating> userRatingDetails = [];
  EditRating? editRating;

  factory GetReviewResponse.fromJson(Map<String, dynamic> json) =>
      GetReviewResponse(
        recordCount: json["RecordCount"] == null ? null : json["RecordCount"],
        userRatingDetails: json["UserRatingDetails"] == null
            ? []
            : List<EditRating>.from(
                json["UserRatingDetails"].map((x) => EditRating.fromJson(x))),
        editRating: json["EditRating"] == null
            ? null
            : EditRating.fromJson(json["EditRating"]),
      );

  Map<String, dynamic> toJson() => {
        "RecordCount": recordCount == null ? null : recordCount,
        "UserRatingDetails": userRatingDetails == null
            ? null
            : List<dynamic>.from(userRatingDetails.map((x) => x.toJson())),
        "EditRating": editRating == null ? null : editRating?.toJson(),
      };
}

class EditRating {
  EditRating({
    this.userName = "",
    this.ratingId = 0,
    this.title = "",
    this.description = "",
    this.reviewDate = "",
    this.ratingUserId = 0,
    this.picture = "",
    this.ratingSiteId = "",
    this.intApprovalStatus = 0,
    this.errorMessage = "",
  });

  String userName = "";
  int ratingId = 0;
  String title = "";
  String description = "";
  String reviewDate = "";
  int ratingUserId = 0;
  String picture = "";
  String ratingSiteId = "";
  int intApprovalStatus = 0;
  String errorMessage = "";

  factory EditRating.fromJson(Map<String, dynamic> json) => EditRating(
        userName: json["UserName"] ?? "",
        ratingId: json["RatingID"] ?? 0,
        title: json["Title"] ?? "",
        description: json["Description"],
        reviewDate: json["ReviewDate"] ?? "",
        ratingUserId: json["RatingUserID"] ?? 0,
        picture: json["picture"] ?? "",
        ratingSiteId: json["RatingSiteID"] ?? "",
        intApprovalStatus: json["intApprovalStatus"] ?? 0,
        errorMessage: json["ErrorMessage"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName == null ? null : userName,
        "RatingID": ratingId == null ? null : ratingId,
        "Title": title == null ? null : title,
        "Description": description == null ? null : description,
        "ReviewDate": reviewDate == null ? null : reviewDate,
        "RatingUserID": ratingUserId == null ? null : ratingUserId,
        "picture": picture == null ? null : picture,
        "RatingSiteID": ratingSiteId == null ? null : ratingSiteId,
        "intApprovalStatus":
            intApprovalStatus == null ? null : intApprovalStatus,
        "ErrorMessage": errorMessage == null ? null : errorMessage,
      };
}
