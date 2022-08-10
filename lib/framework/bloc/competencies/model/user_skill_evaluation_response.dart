import 'dart:convert';

UserSkillEvaluationResponse userSkillEvaluationResponseFromJson(String str) =>
    UserSkillEvaluationResponse.fromJson(json.decode(str));

dynamic userSkillEvaluationResponseToJson(UserSkillEvaluationResponse data) =>
    json.encode(data.toJson());

class UserSkillEvaluationResponse {
  bool isSuccess = false;
  String message = "";
  String autoLaunchURL = "";
  String selfScheduleEventID = "";
  String courseObject = "";
  String searchObject = "";
  String detailsObject = "";
  String notiFyMsg = "";

  UserSkillEvaluationResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    autoLaunchURL = json['AutoLaunchURL'];
    selfScheduleEventID = json['SelfScheduleEventID'];
    courseObject = json['CourseObject'];
    searchObject = json['SearchObject'];
    detailsObject = json['DetailsObject'];
    notiFyMsg = json['NotiFyMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['AutoLaunchURL'] = this.autoLaunchURL;
    data['SelfScheduleEventID'] = this.selfScheduleEventID;
    data['CourseObject'] = this.courseObject;
    data['SearchObject'] = this.searchObject;
    data['DetailsObject'] = this.detailsObject;
    data['NotiFyMsg'] = this.notiFyMsg;
    return data;
  }
}
