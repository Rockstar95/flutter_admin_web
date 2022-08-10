// To parse this JSON data, do
//
//     final filterByModel = filterByModelFromJson(jsonString);

import 'dart:convert';

List<FilterByModel> filterByModelFromJson(String str) =>
    List<FilterByModel>.from(
        json.decode(str).map((x) => FilterByModel.fromJson(x)));

String filterByModelToJson(List<FilterByModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FilterByModel {
  FilterByModel({
    this.categoryName = "",
    this.categoryId,
    this.parentId,
    this.hasChild = false,
  });

  String categoryName = "";
  dynamic categoryId;
  dynamic parentId;
  bool hasChild = false;

  factory FilterByModel.fromJson(Map<String, dynamic> json) => FilterByModel(
        categoryName:
            json["CategoryName"] == null ? null : json["CategoryName"],
        categoryId: json["CategoryID"] == null ? null : json["CategoryID"],
        parentId: json["ParentID"] == null ? null : json["ParentID"],
        hasChild: false,
      );

  Map<String, dynamic> toJson() => {
        "CategoryName": categoryName == null ? null : categoryName,
        "CategoryID": categoryId == null ? null : categoryId,
        "ParentID": parentId == null ? null : parentId,
        "hasChild": false,
      };
}
