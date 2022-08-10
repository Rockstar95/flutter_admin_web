// To parse this JSON data, do
//
//     final deleteReviewRequest = deleteReviewRequestFromJson(jsonString);

import 'dart:convert';

DeleteReviewRequest deleteReviewRequestFromJson(String str) =>
    DeleteReviewRequest.fromJson(json.decode(str));

String deleteReviewRequestToJson(DeleteReviewRequest data) =>
    json.encode(data.toJson());

class DeleteReviewRequest {
  DeleteReviewRequest({
    this.contentId = "",
    this.userId = "",
    this.title = "",
    this.description = "",
    this.reviewDate = "",
    this.rating = 0,
  });

  String contentId = "";
  String userId = "";
  String title = "";
  String description = "";
  String reviewDate = "";
  int rating = 0;

  factory DeleteReviewRequest.fromJson(Map<String, dynamic> json) =>
      DeleteReviewRequest(
        contentId: json["ContentID"] == null ? null : json["ContentID"],
        userId: json["UserID"] == null ? null : json["UserID"],
        title: json["Title"] == null ? null : json["Title"],
        description: json["Description"] == null ? null : json["Description"],
        reviewDate: json["ReviewDate"] == null ? null : json["ReviewDate"],
        rating: json["Rating"] == null ? null : json["Rating"],
      );

  Map<String, dynamic> toJson() => {
        "ContentID": contentId == null ? null : contentId,
        "UserID": userId == null ? null : userId,
        "Title": title == null ? null : title,
        "Description": description == null ? null : description,
        "ReviewDate": reviewDate == null ? null : reviewDate,
        "Rating": rating == null ? null : rating,
      };
}
