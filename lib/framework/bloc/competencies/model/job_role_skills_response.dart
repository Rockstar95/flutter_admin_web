import 'dart:convert';

JobRoleSkillsResponse jobRoleSkillsResponseFromJson(String str) =>
    JobRoleSkillsResponse.fromJson(json.decode(str));

dynamic jobRoleSkillsResponseToJson(JobRoleSkillsResponse data) =>
    json.encode(data.toJson());

class JobRoleSkillsResponse {
  List<CompetencyList> competencyList = [];
  int count = 0;

  JobRoleSkillsResponse.fromJson(Map<String, dynamic> json) {
    if (json['CompetencyList'] != null) {
      json['CompetencyList'].forEach((v) {
        competencyList.add(new CompetencyList.fromJson(v));
      });
    }
    count = json['Count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.competencyList != null) {
      data['CompetencyList'] =
          this.competencyList.map((v) => v.toJson()).toList();
    }
    data['Count'] = this.count;
    return data;
  }
}

class CompetencyList {
  String jobRoleName = "";
  int jobRoleId = 0;
  String jobRoleViewContentLink = "";
  String loadStatus = "";
  String jobRoleDescription = "";
  String jobRoleViewJobRoleSkills = "";
  String tag = "";

  CompetencyList.fromJson(Map<String, dynamic> json) {
    jobRoleName = json['JobRoleName'] ?? "";
    jobRoleId = json['JobRoleId'] ?? 0;
    jobRoleViewContentLink = json['JobRoleViewContentLink'] ?? "";
    loadStatus = json['LoadStatus'] ?? "";
    jobRoleDescription = json['JobRoleDescription'] ?? "";
    jobRoleViewJobRoleSkills = json['JobRoleViewJobRoleSkills'] ?? "";
    tag = json['Tag'] ?? "";
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

    return data;
  }
}
