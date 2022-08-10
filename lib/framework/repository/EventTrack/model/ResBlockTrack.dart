// To parse this JSON data, do
//
//     ResBlockTrack ResBlockTrack = resBlockTrackFromJson(jsonString);

import 'dart:convert';

ResBlockTrack resBlockTrackFromJson(String str) => ResBlockTrack.fromJson(json.decode(str));

String resBlockTrackToJson(ResBlockTrack data) => json.encode(data.toJson());

class ResBlockTrack {
  ResBlockTrack({
    required this.table6,
  });

  List<Table6> table6 = [];

  factory ResBlockTrack.fromJson(Map<String, dynamic> json) => ResBlockTrack(
        table6: json["table6"] == null
            ? []
            : List<Table6>.from(json["table6"].map((x) => Table6.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table6": table6 == null
            ? null
            : List<dynamic>.from(table6.map((x) => x.toJson())),
      };
}

class Table6 {
  Table6({
    this.blockid = "",
    this.blockname = "",
  });

  String blockid = "";
  String blockname = "";

  factory Table6.fromJson(Map<String, dynamic> json) => Table6(
        blockid: json["blockid"] == null ? "" : json["blockid"],
        blockname: json["blockname"] == null ? "" : json["blockname"],
      );

  Map<String, dynamic> toJson() => {
        "blockid": blockid == null ? null : blockid,
        "blockname": blockname == null ? null : blockname,
      };
}
