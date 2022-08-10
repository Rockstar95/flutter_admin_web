import 'dart:convert';

TracklistTabResource tracklistResourceFromJson(String str) =>
    TracklistTabResource.fromJson(json.decode(str));

String tracklistResourceToJson(TracklistTabResource data) =>
    json.encode(data.toJson());

class TracklistTabResource {
  TracklistTabResource({
    required this.references,
  });

  References references;

  factory TracklistTabResource.fromJson(Map<String, dynamic> json) =>
      TracklistTabResource(
        references: References.fromJson(json["references"]),
      );

  Map<String, dynamic> toJson() => {
        "references": references.toJson(),
      };
}

class References {
  References({
    this.title = "",
    required this.referenceItem,
  });

  String title = "";
  List<ReferenceItem> referenceItem = [];

  factory References.fromJson(Map<String, dynamic> json) => References(
        title: json["title"],
        referenceItem: List<ReferenceItem>.from(
            json["referenceItem"].map((x) => ReferenceItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "referenceItem":
            List<dynamic>.from(referenceItem.map((x) => x.toJson())),
      };
}

class ReferenceItem {
  ReferenceItem(
      {this.id = "",
      this.type = "",
      this.title = "",
      this.path = "",
      this.description = "",
      this.cid = "",
      this.isDownloading = false,
      this.isDownloaded = false});

  String id;
  String type = "";
  String title = "";
  String path = "";
  String description = "";
  String cid = "";
  bool isDownloaded = false;
  bool isDownloading = false;

  factory ReferenceItem.fromJson(Map<String, dynamic> json) => ReferenceItem(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        path: json["path"],
        description: json["description"],
        cid: json["cid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "path": path,
        "description": description,
        "cid": cid,
      };
}
