// To parse this JSON data, do
//
//     final contentstatusResponse = contentstatusResponseFromJson(jsonString);

import 'dart:convert';

ContentstatusResponse contentstatusResponseFromJson(String str) =>
    ContentstatusResponse.fromJson(json.decode(str));

String contentstatusResponseToJson(ContentstatusResponse data) =>
    json.encode(data.toJson());

class ContentstatusResponse {
  ContentstatusResponse({
    required this.contentstatus,
  });

  List<Contentstatus> contentstatus = [];

  factory ContentstatusResponse.fromJson(Map<String, dynamic> json) =>
      ContentstatusResponse(
        contentstatus: json["contentstatus"] == null
            ? []
            : List<Contentstatus>.from(
                json["contentstatus"].map((x) => Contentstatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contentstatus": contentstatus == null
            ? null
            : List<dynamic>.from(contentstatus.map((x) => x.toJson())),
      };
}

class Contentstatus {
  Contentstatus({
    this.contentStatus = "",
    this.status = "",
    this.name = "",
    this.progress = "",
  });

  String contentStatus = "";
  String status = "";
  String name = "";
  String progress = "";

  factory Contentstatus.fromJson(Map<String, dynamic> json) => Contentstatus(
        contentStatus: json["ContentStatus"] == null
            ? ""
            : json["ContentStatus"].toString().trim(),
        status: json["status"] == null ? "" : json["status"].toString().trim(),
        name: json["Name"] == null ? "" : json["Name"].toString().trim(),
        progress:
            json["progress"] == null ? "" : json["progress"].toString().trim(),
      );

  Map<String, dynamic> toJson() => {
        "ContentStatus": contentStatus == null ? null : contentStatus,
        "status": status == null ? null : status,
        "Name": name == null ? null : name,
        "progress": progress == null ? null : progress,
      };
}
