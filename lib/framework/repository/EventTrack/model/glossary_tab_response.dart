import 'dart:convert';

List<TrackListGlossaryTab> trackListGlossaryTabFromJson(String str) =>
    List<TrackListGlossaryTab>.from(json.decode(str).map((x) => TrackListGlossaryTab.fromJson(x)));

String trackListGlossaryTabToJson(List<TrackListGlossaryTab> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrackListGlossaryTab {
  TrackListGlossaryTab({
    this.type = "",
    this.id = "",
    this.meaning = "",
    this.text = "",
  });

  String type = "";
  String id = "";
  String meaning = "";
  String text = "";

  factory TrackListGlossaryTab.fromJson(Map<String, dynamic> json) =>
      TrackListGlossaryTab(
        type: json["Type"],
        id: json["id"],
        meaning: json["Meaning"],
        text: json["Text"],
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
        "id": id,
        "Meaning": meaning,
        "Text": text,
      };
}
