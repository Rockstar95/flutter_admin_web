import 'dart:convert';

AcceptRequest acceptRequestFromJson(String str) =>
    AcceptRequest.fromJson(json.decode(str));

String acceptRequestToJson(AcceptRequest data) => json.encode(data.toJson());

class AcceptRequest {
  bool isSuccess = false;
  String message = "";
  dynamic autoLaunchURL;
  String selfScheduleEventID = "";
  dynamic courseObject;
  dynamic searchObject;
  dynamic detailsObject;
  String notiFyMsg = "";

  AcceptRequest(
      /*{this.isSuccess,
        this.message,
        this.autoLaunchURL,
        this.selfScheduleEventID,
        this.courseObject,
        this.searchObject,
        this.detailsObject,
        this.notiFyMsg}*/
      );

  AcceptRequest.fromJson(Map<String, dynamic> json) {
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
