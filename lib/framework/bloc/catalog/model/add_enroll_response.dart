import 'dart:convert';

AddEnrollResponse addEnrollResponseFromJson(dynamic str) =>
    AddEnrollResponse.fromJson(json.decode(str));

dynamic addEnrollResponseToJson(AddEnrollResponse data) =>
    json.encode(data.toJson());

class AddEnrollResponse {
  bool isSuccess;
  String message;
  String autoLaunchURL;
  dynamic selfScheduleEventID;
  dynamic courseObject;
  dynamic searchObject;
  dynamic detailsObject;
  dynamic notiFyMsg;

  AddEnrollResponse(
      {this.isSuccess = false,
      this.message = "",
      this.autoLaunchURL = "",
      this.selfScheduleEventID,
      this.courseObject,
      this.searchObject,
      this.detailsObject,
      this.notiFyMsg});

  static AddEnrollResponse fromJson(Map<String, dynamic> json) {
    AddEnrollResponse addEnrollResponse = AddEnrollResponse();
    addEnrollResponse.isSuccess = json['IsSuccess'] ?? false;
    addEnrollResponse.message = json['Message'] ?? "";
    addEnrollResponse.autoLaunchURL = json['AutoLaunchURL'] ?? "";
    addEnrollResponse.selfScheduleEventID = json['SelfScheduleEventID'];
    addEnrollResponse.courseObject = json['CourseObject'];
    addEnrollResponse.searchObject = json['SearchObject'];
    addEnrollResponse.detailsObject = json['DetailsObject'];
    addEnrollResponse.notiFyMsg = json['NotiFyMsg'];
    return addEnrollResponse;
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
