import 'dart:convert';

WikiCategoryResponse wikiCategoryResponseFromJson(String str) =>
    WikiCategoryResponse.fromJson(json.decode(str));

dynamic wikiCategoryResponseToJson(WikiCategoryResponse data) =>
    json.encode(data.toJson());

class WikiCategoryResponse {
  List<WikiCategoryModel> table = [];

  WikiCategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        table.add(new WikiCategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WikiCategoryModel {
  int parentCategoryID = 0;
  int categoryID = 0;
  String name = "";
  bool isSelected = false;

  WikiCategoryModel.fromJson(Map<String, dynamic> json) {
    parentCategoryID = json['ParentCategoryID'] ?? 0;
    categoryID = json['CategoryID'] ?? 0;
    name = json['Name'] ?? "";
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ParentCategoryID'] = this.parentCategoryID;
    data['CategoryID'] = this.categoryID;
    data['Name'] = this.name;
    return data;
  }
}
