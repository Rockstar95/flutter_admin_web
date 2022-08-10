// To parse this JSON data, do
//
//     final getEducationTitleResponse = getEducationTitleResponseFromJson(jsonString);

import 'dart:convert';

GetEducationTitleResponse getEducationTitleResponseFromJson(String str) =>
    GetEducationTitleResponse.fromJson(json.decode(str));

String getEducationTitleResponseToJson(GetEducationTitleResponse data) =>
    json.encode(data.toJson());

class GetEducationTitleResponse {
  GetEducationTitleResponse({
    required this.educationTitleList,
  });

  List<EducationTitleList> educationTitleList = [];

  factory GetEducationTitleResponse.fromJson(Map<String, dynamic> json) =>
      GetEducationTitleResponse(
        educationTitleList: List<EducationTitleList>.from(
            json["educationTitleList"]
                .map((x) => EducationTitleList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "educationTitleList":
            List<dynamic>.from(educationTitleList.map((x) => x.toJson())),
      };
}

class EducationTitleList {
  EducationTitleList({
    this.id = 0,
    this.name = "",
  });

  int id = 0;
  String name = "";

  factory EducationTitleList.fromJson(Map<String, dynamic> json) =>
      EducationTitleList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
