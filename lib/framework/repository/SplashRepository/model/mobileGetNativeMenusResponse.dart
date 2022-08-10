// To parse this JSON data, do
//
//     final mobileGetNativeMenusResponse = mobileGetNativeMenusResponseFromJson(jsonString);

import 'dart:convert';

MobileGetNativeMenusResponse mobileGetNativeMenusResponseFromJson(String str) =>
    MobileGetNativeMenusResponse.fromJson(json.decode(str));

String mobileGetNativeMenusResponseToJson(MobileGetNativeMenusResponse data) =>
    json.encode(data.toJson());

class MobileGetNativeMenusResponse {
  MobileGetNativeMenusResponse({
    this.table = const [],
  });

  List<Table> table = [];

  factory MobileGetNativeMenusResponse.fromJson(Map<String, dynamic> json) =>
      MobileGetNativeMenusResponse(
        table: List<Table>.from(
            (json["table"] ?? []).map((x) => Table.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table": List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class Table {
  Table({
    this.displayorder = 0,
    this.displayname = "",
    this.image = "",
    this.menuid = 0,
    this.parentmenuid = 0,
    this.isofflinemenu = false,
    this.isenabled = false,
    this.displayorder1 = 0,
    this.contexttitle = "",
    this.contextmenuid = "",
    this.repositoryid = 0,
    this.landingpagetype = 0,
    this.categorystyle = 0,
    this.componentid = 0,
    this.conditions = "",
    this.parameterstrings = "",
    this.locale = "",
    this.webmenuid = 0,
  });

  int displayorder;
  String displayname;
  String image;
  int menuid;
  int parentmenuid;
  bool isofflinemenu;
  bool isenabled;
  int displayorder1;
  String contexttitle;
  String contextmenuid;
  int repositoryid;
  int landingpagetype;
  int categorystyle;
  int componentid;
  String conditions;
  String parameterstrings;
  String locale;
  int webmenuid;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        displayorder: json["displayorder"] ?? 0,
        displayname: json["displayname"] ?? "",
        image: json["image"] ?? "",
        menuid: json["menuid"] ?? 0,
        parentmenuid: json["parentmenuid"] ?? 0,
        isofflinemenu: json["isofflinemenu"] ?? false,
        isenabled: json["isenabled"] ?? false,
        displayorder1: json["displayorder1"] ?? 0,
        contexttitle: json["contexttitle"] ?? "",
        contextmenuid: json["contextmenuid"] ?? "",
        repositoryid: json["repositoryid"] ?? 0,
        landingpagetype: json["landingpagetype"] ?? 0,
        categorystyle: json["categorystyle"] ?? 0,
        componentid: json["componentid"] ?? 0,
        conditions: json["conditions"] ?? "",
        parameterstrings: json["parameterstrings"] ?? "",
        locale: json["locale"] ?? "",
        webmenuid: json["webmenuid"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "displayorder": displayorder,
        "displayname": displayname,
        "image": image,
        "menuid": menuid,
        "parentmenuid": parentmenuid,
        "isofflinemenu": isofflinemenu,
        "isenabled": isenabled,
        "displayorder1": displayorder1,
        "contexttitle": contexttitle,
        "contextmenuid": contextmenuid,
        "repositoryid": repositoryid,
        "landingpagetype": landingpagetype,
        "categorystyle": categorystyle,
        "componentid": componentid,
        "conditions": conditions,
        "parameterstrings": parameterstrings,
        "locale": locale,
        "webmenuid": webmenuid,
      };
}
