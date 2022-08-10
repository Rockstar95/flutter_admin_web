import 'dart:convert';

JobRoleResponse jobRoleResponseFromJson(String str) =>
    JobRoleResponse.fromJson(json.decode(str));

dynamic jobRoleResponseToJson(JobRoleResponse data) =>
    json.encode(data.toJson());

class JobRoleResponse {
  dynamic jobRolesList;
  List<ParentJobRolesList> parentJobRolesList = [];
  dynamic ddlJobRolesList;
  int count = 0;

  JobRoleResponse.fromJson(Map<String, dynamic> json) {
    jobRolesList = json['JobRolesList'];
    if (json['ParentJobRolesList'] != null) {
      json['ParentJobRolesList'].forEach((v) {
        parentJobRolesList.add(new ParentJobRolesList.fromJson(v));
      });
    }
    ddlJobRolesList = json['DdlJobRolesList'];
    count = json['Count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobRolesList'] = this.jobRolesList;
    if (this.parentJobRolesList != null) {
      data['ParentJobRolesList'] =
          this.parentJobRolesList.map((v) => v.toJson()).toList();
    }
    data['DdlJobRolesList'] = this.ddlJobRolesList;
    data['Count'] = this.count;
    return data;
  }
}

class ParentJobRolesList {
  String jobRoleName = "";
  int jobRoleId = 0;
  String jobRoleDescription = "";
  dynamic jobRoleViewJobRoleSkills;
  dynamic tagsObj;
  dynamic selectedTag;
  String jobRoleMultiLevelName = "";
  dynamic selectedJobRoleName;
  int jobRoleParentId = 0;

  ParentJobRolesList.fromJson(Map<String, dynamic> json) {
    jobRoleName = json['JobRoleName'] ?? "";
    jobRoleId = json['JobRoleId'] ?? 0;
    jobRoleDescription = json['JobRoleDescription'] ?? "";
    jobRoleViewJobRoleSkills = json['JobRoleViewJobRoleSkills'];
    tagsObj = json['TagsObj'];
    selectedTag = json['SelectedTag'];
    jobRoleMultiLevelName = json['JobRoleMultiLevelName'] ?? "";
    selectedJobRoleName = json['SelectedJobRoleName'];
    jobRoleParentId = json['JobRoleParentId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobRoleName'] = this.jobRoleName;
    data['JobRoleId'] = this.jobRoleId;
    data['JobRoleDescription'] = this.jobRoleDescription;
    data['JobRoleViewJobRoleSkills'] = this.jobRoleViewJobRoleSkills;
    data['TagsObj'] = this.tagsObj;
    data['SelectedTag'] = this.selectedTag;
    data['JobRoleMultiLevelName'] = this.jobRoleMultiLevelName;
    data['SelectedJobRoleName'] = this.selectedJobRoleName;
    data['JobRoleParentId'] = this.jobRoleParentId;
    return data;
  }
}
