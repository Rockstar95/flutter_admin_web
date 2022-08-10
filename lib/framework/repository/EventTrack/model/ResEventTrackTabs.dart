// To parse this JSON data, do
//
//     List<ResEventTrackTabs> resEventTrackTabs = resEventTrackTabsFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'ResEventTrackTabs.g.dart';

List<ResEventTrackTabs> resEventTrackTabsFromJson(String str) =>
    List<ResEventTrackTabs>.from(
        json.decode(str).map((x) => ResEventTrackTabs.fromJson(x)));

String resEventTrackTabsToJson(List<ResEventTrackTabs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class ResEventTrackTabsList {
  @HiveField(0)
  List<ResEventTrackTabs> tabList = [];

  ResEventTrackTabsList(this.tabList);

  factory ResEventTrackTabsList.fromJson(Map<String, dynamic> json) {
    List<String> keys = json.keys.toList();
    List<ResEventTrackTabs> tabs = [];
    for (String key in keys) {
      var data = Map.castFrom<dynamic, dynamic, String, dynamic>(json[key]);
      ResEventTrackTabs tab = ResEventTrackTabs.fromJson(data);
      tabs.add(tab);
    }
    return ResEventTrackTabsList(tabs);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> tabMap = {};
    for (ResEventTrackTabs tab in tabList) {
      tabMap['${tab.tabId}'] = tab.toJson();
    }
    return tabMap;
  }
}

@HiveType(typeId: 1)
class ResEventTrackTabs {
  ResEventTrackTabs({
    this.tabName = "",
    this.tabId = 0,
    this.tabidName = "",
    this.glossaryhtml = "",
  });

  @HiveField(0)
  String tabName = "";

  @HiveField(1)
  int tabId = 0;

  @HiveField(2)
  String tabidName = "";

  @HiveField(3)
  String glossaryhtml = "";

  factory ResEventTrackTabs.fromJson(Map<String, dynamic> json) =>
      ResEventTrackTabs(
        tabName: json["tabName"] == null ? "" : json["tabName"],
        tabId: json["tabID"] == null ? 0 : json["tabID"],
        tabidName: json["tabidName"] == null ? "" : json["tabidName"],
        glossaryhtml: json["Glossaryhtml"] == null ? "" : json["Glossaryhtml"],
      );

  Map<String, dynamic> toJson() => {
        "tabName": tabName == null ? null : tabName,
        "tabID": tabId == null ? null : tabId,
        "tabidName": tabidName == null ? null : tabidName,
        "Glossaryhtml": glossaryhtml == null ? null : glossaryhtml,
      };
}
