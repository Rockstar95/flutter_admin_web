// To parse this JSON data, do
//
//     final eventRecordingResponse = eventRecordingResponseFromJson(jsonString);

import 'dart:convert';

EventRecordingResponse eventRecordingResponseFromJson(String str) =>
    EventRecordingResponse.fromJson(json.decode(str));

String eventRecordingResponseToJson(EventRecordingResponse data) =>
    json.encode(data.toJson());

class EventRecordingResponse {
  EventRecordingResponse({
    this.eventRecording = false,
    this.eventRecordingMessage = "",
    this.eventRecordingUrl = "",
    this.eventRecordingContentId = "",
    this.eventRecordStatus = "",
    this.contentTypeId,
    this.contentId,
    this.viewLink = "",
    this.scoId,
    this.jwVideoKey,
    this.contentName,
    this.windowProperties,
    this.viewType,
    this.recordingType = "",
    this.wstatus,
    this.eventScoid = 0,
    this.contentProgress = 0,
    this.percentCompletedClass,
    this.eventId = "",
    this.language = "",
    this.cloudMediaPlayerKey,
  });

  bool eventRecording = false;
  String eventRecordingMessage = "";
  String eventRecordingUrl = "";
  String eventRecordingContentId = "";
  String eventRecordStatus = "";
  dynamic contentTypeId;
  dynamic contentId;
  String viewLink = "";
  dynamic scoId;
  dynamic jwVideoKey;
  dynamic contentName;
  dynamic windowProperties;
  dynamic viewType;
  String recordingType = "";
  dynamic wstatus;
  int eventScoid = 0;
  int contentProgress = 0;
  dynamic percentCompletedClass;
  String eventId = "";
  String language = "";
  dynamic cloudMediaPlayerKey;

  factory EventRecordingResponse.fromJson(Map<String, dynamic> json) =>
      EventRecordingResponse(
        eventRecording: json["EventRecording"],
        eventRecordingMessage: json["EventRecordingMessage"],
        eventRecordingUrl: json["EventRecordingURL"],
        eventRecordingContentId: json["EventRecordingContentID"],
        eventRecordStatus: json["EventRecordStatus"],
        contentTypeId: json["ContentTypeId"],
        contentId: json["ContentID"],
        viewLink: json["ViewLink"],
        scoId: json["ScoID"],
        jwVideoKey: json["JWVideoKey"],
        contentName: json["ContentName"],
        windowProperties: json["WindowProperties"],
        viewType: json["ViewType"],
        recordingType: json["RecordingType"],
        wstatus: json["wstatus"],
        eventScoid: json["EventSCOID"],
        contentProgress: json["ContentProgress"],
        percentCompletedClass: json["PercentCompletedClass"],
        eventId: json["EventID"],
        language: json["Language"],
        cloudMediaPlayerKey: json["cloudMediaPlayerKey"],
      );

  Map<String, dynamic> toJson() => {
        "EventRecording": eventRecording,
        "EventRecordingMessage": eventRecordingMessage,
        "EventRecordingURL": eventRecordingUrl,
        "EventRecordingContentID": eventRecordingContentId,
        "EventRecordStatus": eventRecordStatus,
        "ContentTypeId": contentTypeId,
        "ContentID": contentId,
        "ViewLink": viewLink,
        "ScoID": scoId,
        "JWVideoKey": jwVideoKey,
        "ContentName": contentName,
        "WindowProperties": windowProperties,
        "ViewType": viewType,
        "RecordingType": recordingType,
        "wstatus": wstatus,
        "EventSCOID": eventScoid,
        "ContentProgress": contentProgress,
        "PercentCompletedClass": percentCompletedClass,
        "EventID": eventId,
        "Language": language,
        "cloudMediaPlayerKey": cloudMediaPlayerKey,
      };
}
