// To parse this JSON data, do
//
//     final removeExperienceRequest = removeExperienceRequestFromJson(jsonString);

import 'dart:convert';

RemoveExperienceRequest removeExperienceRequestFromJson(String str) =>
    RemoveExperienceRequest.fromJson(json.decode(str));

String removeExperienceRequestToJson(RemoveExperienceRequest data) =>
    json.encode(data.toJson());

class RemoveExperienceRequest {
  RemoveExperienceRequest({
    this.userId = "",
    this.displayNo = "",
  });

  String userId = "";
  String displayNo = "";

  factory RemoveExperienceRequest.fromJson(Map<String, dynamic> json) =>
      RemoveExperienceRequest(
        userId: json["UserID"],
        displayNo: json["DisplayNo"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "DisplayNo": displayNo,
      };
}
