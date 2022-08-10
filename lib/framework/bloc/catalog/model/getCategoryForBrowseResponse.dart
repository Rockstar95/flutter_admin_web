// To parse this JSON data, do
//
//     final getCategoryForBrowseResponse = getCategoryForBrowseResponseFromJson(jsonString);

import 'dart:convert';

List<GetCategoryForBrowseResponse> getCategoryForBrowseResponseFromJson(
        String str) =>
    List<GetCategoryForBrowseResponse>.from(
        json.decode(str).map((x) => GetCategoryForBrowseResponse.fromJson(x)));

String getCategoryForBrowseResponseToJson(
        List<GetCategoryForBrowseResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCategoryForBrowseResponse {
  int parentId = 0;
  String categoryName = "";
  int categoryId = 0;
  String categoryIcon = "";
  bool hasChild = false;
  bool isChecked = false;

  GetCategoryForBrowseResponse.fromJson(Map<String, dynamic> json) {
    parentId = json["ParentID"] == null ? 0 : json["ParentID"];
    categoryName = json["CategoryName"] == null ? "" : json["CategoryName"];
    categoryId = json["CategoryID"] == null ? 0 : json["CategoryID"];
    categoryIcon = json["CategoryIcon"] == null ? "" : json["CategoryIcon"];
    hasChild = json["hasChild"] == null ? false : json["hasChild"];
    isChecked = json["isChecked"] == null ? false : json["isChecked"];
  }

  Map<String, dynamic> toJson() => {
        "ParentID": parentId,
        "CategoryName": categoryName,
        "CategoryID": categoryId,
        "CategoryIcon": categoryIcon,
        "hasChild": hasChild,
        "isChecked": isChecked,
      };
}
