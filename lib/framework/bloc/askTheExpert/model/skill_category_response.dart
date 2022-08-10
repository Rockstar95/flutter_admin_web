import 'dart:convert';

SkillCategoryResponse skillCategoryResponseFromJson(String str) =>
    SkillCategoryResponse.fromJson(json.decode(str));

dynamic skillCategoryResponseToJson(SkillCategoryResponse data) =>
    json.encode(data.toJson());

class SkillCategoryResponse {
  List<SkillCateModel> table;
  List<Table1> table1;

  SkillCategoryResponse({required this.table, required this.table1});

  static SkillCategoryResponse fromJson(Map<String, dynamic> json) {
    SkillCategoryResponse skillCategoryResponse =
        SkillCategoryResponse(table1: [], table: []);
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        skillCategoryResponse.table.add(SkillCateModel.fromJson(v ?? {}));
      });
    }
    if (json['Table1'] != null) {
      json['Table1'].forEach((v) {
        skillCategoryResponse.table1.add(Table1.fromJson(v ?? {}));
      });
    }
    return skillCategoryResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Table'] = this.table.map((v) => v.toJson()).toList();
    data['Table1'] = this.table1.map((v) => v.toJson()).toList();
    return data;
  }
}

class SkillCateModel {
  String skillID;
  String preferrenceTitle;
  bool isSelected;

  SkillCateModel(
      {this.skillID = "", this.preferrenceTitle = "", this.isSelected = false});

  static SkillCateModel fromJson(Map<String, dynamic> json) {
    SkillCateModel skillCateModel = SkillCateModel();
    skillCateModel.skillID = json['SkillID'] ?? "";
    skillCateModel.preferrenceTitle = json['PreferrenceTitle'] ?? "";
    skillCateModel.isSelected = false;
    return skillCateModel;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SkillID'] = this.skillID;
    data['PreferrenceTitle'] = this.preferrenceTitle;
    return data;
  }
}

class Table1 {
  int questionID;
  String skillID;

  Table1({this.questionID = 0, this.skillID = ""});

  static Table1 fromJson(Map<String, dynamic> json) {
    Table1 table1 = Table1();
    table1.questionID = json['QuestionID'] ?? 0;
    table1.skillID = json['SkillID'] ?? "";
    return table1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionID'] = this.questionID;
    data['SkillID'] = this.skillID;
    return data;
  }
}
