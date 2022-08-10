import 'dart:convert';

TimeZoneResponse feedbackFromJson(String str) =>
    TimeZoneResponse.fromJson(json.decode(str));

String feedbackToJson(TimeZoneResponse data) => json.encode(data.toJson());

class TimeZoneResponse {
  TimeZoneResponse({
    required this.timezonedata,
    this.localTimeZone = "",
  });

  List<TimezoneData> timezonedata = [];
  String localTimeZone = "";

  factory TimeZoneResponse.fromJson(Map<String, dynamic> json) =>
      TimeZoneResponse(
        timezonedata: List<TimezoneData>.from(
            json["Timezonedata"].map((x) => TimezoneData.fromJson(x))),
        localTimeZone: json["LocalTimeZone"],
      );

  Map<String, dynamic> toJson() => {
        "Timezonedata": List<dynamic>.from(timezonedata.map((x) => x.toJson())),
        "LocalTimeZone": localTimeZone,
      };
}

class TimezoneData {
  TimezoneData({
    this.tid = "",
    this.displayName = "",
  });

  String tid = "";
  String displayName = "";

  factory TimezoneData.fromJson(Map<String, dynamic> json) => TimezoneData(
        tid: json["TID"],
        displayName: json["DisplayName"],
      );

  Map<String, dynamic> toJson() => {
        "TID": tid,
        "DisplayName": displayName,
      };
}
