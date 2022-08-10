// To parse this JSON data, do
//
//     final eventResourcePlusResponse = eventResourcePlusResponseFromJson(jsonString);

import 'dart:convert';

List<EventResourcePlusResponse> eventResourcePlusResponseFromJson(String str) =>
    List<EventResourcePlusResponse>.from(
        json.decode(str).map((x) => EventResourcePlusResponse.fromJson(x)));

String eventResourcePlusResponseToJson(List<EventResourcePlusResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventResourcePlusResponse {
  EventResourcePlusResponse({
    this.title = "",
    this.start = "",
    this.end = "",
    this.detailsurl = "",
    this.color = "",
    this.textColor = "",
    this.mediaTypeId = "",
    this.enrollmentLimit,
    this.availableSeats,
    this.noofUsersEnrolled,
    this.waitListLimit,
    this.waitListEnrolls,
    this.isContentEnrolled = "",
    this.objectTypeId = 0,
    this.eventType = 0,
    this.eventScheduleType = 0,
  });

  String title = "";
  String start = "";
  String end = "";
  String detailsurl = "";
  String color = "";
  String textColor = "";
  String mediaTypeId = "";
  dynamic enrollmentLimit;
  dynamic availableSeats;
  dynamic noofUsersEnrolled;
  dynamic waitListLimit;
  dynamic waitListEnrolls;
  String isContentEnrolled = "";
  int objectTypeId = 0;
  int eventType = 0;
  int eventScheduleType = 0;

  factory EventResourcePlusResponse.fromJson(Map<String, dynamic> json) =>
      EventResourcePlusResponse(
        title: json["title"] ?? "",
        start: json["start"] ?? "",
        end: json["end"] ?? "",
        detailsurl: json["detailsurl"] ?? "",
        color: json["color"] ?? "",
        textColor: json["textColor"] ?? "",
        mediaTypeId: json["MediaTypeID"] ?? "",
        enrollmentLimit: json["EnrollmentLimit"],
        availableSeats: json["AvailableSeats"],
        noofUsersEnrolled: json["NoofUsersEnrolled"],
        waitListLimit: json["WaitListLimit"],
        waitListEnrolls: json["WaitListEnrolls"],
        isContentEnrolled: json["isContentEnrolled"] ?? "",
        objectTypeId: json["ObjectTypeId"],
        eventType: json["EventType"],
        eventScheduleType: json["EventScheduleType"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "start": start,
        "end": end,
        "detailsurl": detailsurl,
        "color": color == null ? null : color,
        "textColor": textColor == null ? null : textColor,
        "MediaTypeID": mediaTypeId,
        "EnrollmentLimit": enrollmentLimit,
        "AvailableSeats": availableSeats,
        "NoofUsersEnrolled": noofUsersEnrolled,
        "WaitListLimit": waitListLimit,
        "WaitListEnrolls": waitListEnrolls,
        "isContentEnrolled": isContentEnrolled,
        "ObjectTypeId": objectTypeId,
        "EventType": eventType,
        "EventScheduleType": eventScheduleType,
      };
}
