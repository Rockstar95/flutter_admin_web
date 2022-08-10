import 'dart:convert';

UserSkillListResponse userSkillListResponseFromJson(String str) =>
    UserSkillListResponse.fromJson(json.decode(str));

dynamic userSkillListResponseToJson(UserSkillListResponse data) =>
    json.encode(data.toJson());

class UserSkillListResponse {
  int prefCategoryID = 0;
  String prefCategoryTitle = "";
  String prefCatViewContentLink = "";
  String loadStatus = "";
  List<SkillsList> skillsList = [];

  UserSkillListResponse.fromJson(Map<String, dynamic> json) {
    prefCategoryID = json['PrefCategoryID'] ?? 0;
    prefCategoryTitle = json['PrefCategoryTitle'] ?? "";
    prefCatViewContentLink = json['PrefCatViewContentLink'] ?? "";
    loadStatus = json['LoadStatus'] ?? "";
    if (json['SkillsList'] != null) {
      json['SkillsList'].forEach((v) {
        skillsList.add(new SkillsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PrefCategoryID'] = this.prefCategoryID;
    data['PrefCategoryTitle'] = this.prefCategoryTitle;
    data['PrefCatViewContentLink'] = this.prefCatViewContentLink;
    data['LoadStatus'] = this.loadStatus;
    if (this.skillsList != null) {
      data['SkillsList'] = this.skillsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkillsList {
  int skillID = 0;
  int jobRoleID = 0;
  String skillName = "";
  String description = "";
  int userEvaluation = 0;
  String managersEvaluation = "";
  String managersEval = "";
  int requiredProficiency = 0;
  List<int> requiredProfValues = [];
  String contentEval = "";
  String weightedAverage = "";
  String gap = "";
  String skillViewContentlink = "";
  bool isViewlinkenable = false;
  bool isExpanded = false;
  bool isSelected = false;
  List<Rating> ratings = [];

  SkillsList.fromJson(Map<String, dynamic> json) {
    skillID = json['SkillID'] ?? 0;
    jobRoleID = json['JobRoleID'] ?? 0;
    skillName = json['SkillName'] ?? "";
    description = json['Description'] ?? "";
    userEvaluation = json['UserEvaluation'] ?? 0;
    managersEvaluation = json['ManagersEvaluation'] ?? "";
    managersEval = json['ManagersEval'] ?? "";
    requiredProficiency = json['RequiredProficiency'] ?? 0;
    requiredProfValues = json['RequiredProfValues'].cast<int>();
    contentEval = json['ContentEval'] ?? "";
    weightedAverage = json['WeightedAverage'] ?? "";
    gap = json['Gap'] ?? "";
    skillViewContentlink = json['SkillViewContentlink'] ?? "";
    isViewlinkenable = json['isViewlinkenable'] ?? false;
    isExpanded = false;
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SkillID'] = this.skillID;
    data['JobRoleID'] = this.jobRoleID;
    data['SkillName'] = this.skillName;
    data['Description'] = this.description;
    data['UserEvaluation'] = this.userEvaluation;
    data['ManagersEvaluation'] = this.managersEvaluation;
    data['ManagersEval'] = this.managersEval;
    data['RequiredProficiency'] = this.requiredProficiency;
    data['RequiredProfValues'] = this.requiredProfValues;
    data['ContentEval'] = this.contentEval;
    data['WeightedAverage'] = this.weightedAverage;
    data['Gap'] = this.gap;
    data['SkillViewContentlink'] = this.skillViewContentlink;
    data['isViewlinkenable'] = this.isViewlinkenable;
    return data;
  }
}

class Rating {
  bool isCheched = false;
  int value = 0;
}
