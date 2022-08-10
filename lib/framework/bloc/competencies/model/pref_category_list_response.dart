import 'dart:convert';

PrefCategoryListResponse prefCategoryListResponseFromJson(String str) =>
    PrefCategoryListResponse.fromJson(json.decode(str));

dynamic prefCategoryListResponseToJson(PrefCategoryListResponse data) =>
    json.encode(data.toJson());

class PrefCategoryListResponse {
  String jobRoleName = "";
  int jobRoleId = 0;
  String jobRoleViewContentLink = "";
  String loadStatus = "";
  String jobRoleDescription = "";
  String jobRoleViewJobRoleSkills = "";
  String tag = "";
  List<PrefCategoryList> prefCategoryList = [];

  PrefCategoryListResponse.fromJson(Map<String, dynamic> json) {
    jobRoleName = json['JobRoleName'] ?? "";
    jobRoleId = json['JobRoleId'] ?? 0;
    jobRoleViewContentLink = json['JobRoleViewContentLink'] ?? "";
    loadStatus = json['LoadStatus'] ?? "";
    jobRoleDescription = json['JobRoleDescription'] ?? "";
    jobRoleViewJobRoleSkills = json['JobRoleViewJobRoleSkills'] ?? "";
    tag = json['Tag'] ?? "";
    if (json['PrefCategoryList'] != null) {
      json['PrefCategoryList'].forEach((v) {
        prefCategoryList.add(new PrefCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobRoleName'] = this.jobRoleName;
    data['JobRoleId'] = this.jobRoleId;
    data['JobRoleViewContentLink'] = this.jobRoleViewContentLink;
    data['LoadStatus'] = this.loadStatus;
    data['JobRoleDescription'] = this.jobRoleDescription;
    data['JobRoleViewJobRoleSkills'] = this.jobRoleViewJobRoleSkills;
    data['Tag'] = this.tag;
    if (this.prefCategoryList != null) {
      data['PrefCategoryList'] =
          this.prefCategoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrefCategoryList {
  int prefCategoryID = 0;
  String prefCategoryTitle = "";
  String prefCatViewContentLink = "";
  String loadStatus = "";

  PrefCategoryList.fromJson(Map<String, dynamic> json) {
    prefCategoryID = json['PrefCategoryID'] ?? 0;
    prefCategoryTitle = json['PrefCategoryTitle'] ?? "";
    prefCatViewContentLink = json['PrefCatViewContentLink'] ?? "";
    loadStatus = json['LoadStatus'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PrefCategoryID'] = this.prefCategoryID;
    data['PrefCategoryTitle'] = this.prefCategoryTitle;
    data['PrefCatViewContentLink'] = this.prefCatViewContentLink;
    data['LoadStatus'] = this.loadStatus;

    return data;
  }
}
