// To parse this JSON data, do
//
//     final mobileGetLearningPortalInfoResponse = mobileGetLearningPortalInfoResponseFromJson(jsonString);

import 'dart:convert';

MobileGetLearningPortalInfoResponse mobileGetLearningPortalInfoResponseFromJson(
        String str) =>
    MobileGetLearningPortalInfoResponse.fromJson(json.decode(str));

String mobileGetLearningPortalInfoResponseToJson(
        MobileGetLearningPortalInfoResponse data) =>
    json.encode(data.toJson());

class MobileGetLearningPortalInfoResponse {
  MobileGetLearningPortalInfoResponse({
    this.table = const [],
    this.table1 = const [],
    this.table2 = const [],
    this.table3 = const [],
    this.table4 = const [],
    this.table5 = const [],
  });

  List<Table> table;
  List<Table1> table1;
  List<Table2> table2;
  List<Table3> table3;
  List<Table4> table4;
  List<Table5> table5;

  factory MobileGetLearningPortalInfoResponse.fromJson(
          Map<String, dynamic> json) =>
      MobileGetLearningPortalInfoResponse(
        table: List<Table>.from(
            (json["table"] ?? []).map((x) => Table.fromJson(x))),
        table1: List<Table1>.from(
            (json["table1"] ?? []).map((x) => Table1.fromJson(x))),
        table2: List<Table2>.from(
            (json["table2"] ?? []).map((x) => Table2.fromJson(x))),
        table3: List<Table3>.from(
            (json["table3"] ?? []).map((x) => Table3.fromJson(x))),
        table4: List<Table4>.from(
            (json["table4"] ?? []).map((x) => Table4.fromJson(x))),
        table5: List<Table5>.from(
            (json["table5"] ?? []).map((x) => Table5.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table": List<dynamic>.from(table.map((x) => x.toJson())),
        "table1": List<dynamic>.from(table1.map((x) => x.toJson())),
        "table2": List<dynamic>.from(table2.map((x) => x.toJson())),
        "table3": List<dynamic>.from(table3.map((x) => x.toJson())),
        "table4": List<dynamic>.from(table4.map((x) => x.toJson())),
        "table5": List<dynamic>.from(table5.map((x) => x.toJson())),
      };
}

class Table {
  Table({
    this.siteid = 0,
    this.name = "",
    this.siteurl = "",
  });

  int siteid = 0;
  String name = "";
  String siteurl = "";

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        siteid: json["siteid"],
        name: json["name"],
        siteurl: json["siteurl"],
      );

  Map<String, dynamic> toJson() => {
        "siteid": siteid,
        "name": name,
        "siteurl": siteurl,
      };
}

class Table1 {
  Table1({
    this.csseditingplaceholdertypeid = 0,
    this.siteid = 0,
    this.csseditingpalceholderdisplayname = "",
    this.csseditingpalceholdername = "",
    this.textcolor = "",
    this.bgcolor = "",
    this.localeid = Localeid.EN_US,
    this.themeid = 0,
    this.categoryid = 0,
  });

  int csseditingplaceholdertypeid = 0;
  int siteid = 0;
  String csseditingpalceholderdisplayname = "";
  String csseditingpalceholdername = "";
  String textcolor = "";
  String bgcolor;
  Localeid localeid;
  int themeid = 0;
  int categoryid = 0;

  factory Table1.fromJson(Map<String, dynamic> json) => Table1(
        csseditingplaceholdertypeid: json["csseditingplaceholdertypeid"],
        siteid: json["siteid"],
        csseditingpalceholderdisplayname:
            json["csseditingpalceholderdisplayname"],
        csseditingpalceholdername: json["csseditingpalceholdername"],
        textcolor: json["textcolor"],
        bgcolor: json["bgcolor"],
        localeid: localeidValues.map[json["localeid"]] ?? Localeid.EN_US,
        themeid: json["themeid"],
        categoryid: json["categoryid"],
      );

  Map<String, dynamic> toJson() => {
        "csseditingplaceholdertypeid": csseditingplaceholdertypeid,
        "siteid": siteid,
        "csseditingpalceholderdisplayname": csseditingpalceholderdisplayname,
        "csseditingpalceholdername": csseditingpalceholdername,
        "textcolor": textcolor,
        "bgcolor": bgcolor,
        "localeid": localeidValues.reverse[localeid],
        "themeid": themeid,
        "categoryid": categoryid,
      };
}

enum Localeid { EN_US }

final localeidValues = EnumValues({"en-us": Localeid.EN_US});

class Table2 {
  Table2({
    this.name = "",
    this.keyvalue = "",
  });

  String name = "";
  String keyvalue = "";

  factory Table2.fromJson(Map<String, dynamic> json) => Table2(
        name: json["name"],
        keyvalue: json["keyvalue"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "keyvalue": keyvalue,
      };
}

class Table3 {
  Table3({
    this.notificationid = 0,
    this.title = "",
    this.pushnotifications = false,
    this.orgunitid = 0,
  });

  int notificationid = 0;
  String title = "";
  bool pushnotifications = false;
  int orgunitid = 0;

  factory Table3.fromJson(Map<String, dynamic> json) => Table3(
        notificationid: json["notificationid"],
        title: json["title"],
        pushnotifications: json["pushnotifications"],
        orgunitid: json["orgunitid"],
      );

  Map<String, dynamic> toJson() => {
        "notificationid": notificationid,
        "title": title,
        "pushnotifications": pushnotifications,
        "orgunitid": orgunitid,
      };
}

class Table4 {
  Table4({
    this.privilegeid = 0,
    this.objecttypeid = 0,
    this.actionid = 0,
    this.description = "",
    this.componentid,
    this.parentprivilegeid,
    this.publicprivilege = false,
    this.ismobileprivilege = false,
  });

  int privilegeid = 0;
  int objecttypeid = 0;
  int actionid = 0;
  String description = "";
  dynamic componentid;
  dynamic parentprivilegeid;
  bool publicprivilege = false;
  bool ismobileprivilege = false;

  factory Table4.fromJson(Map<String, dynamic> json) => Table4(
        privilegeid: json["privilegeid"],
        objecttypeid: json["objecttypeid"],
        actionid: json["actionid"],
        description: json["description"],
        componentid: json["componentid"],
        parentprivilegeid: json["parentprivilegeid"],
        publicprivilege: json["publicprivilege"],
        ismobileprivilege: json["ismobileprivilege"],
      );

  Map<String, dynamic> toJson() => {
        "privilegeid": privilegeid,
        "objecttypeid": objecttypeid,
        "actionid": actionid,
        "description": description,
        "componentid": componentid,
        "parentprivilegeid": parentprivilegeid,
        "publicprivilege": publicprivilege,
        "ismobileprivilege": ismobileprivilege,
      };
}

class Table5 {
  Table5({
    this.languagename = "",
    this.locale = "",
    this.description = "",
    this.status = false,
    this.id = 0,
    this.countryflag = "",
    this.jsonfile = "",
  });

  String languagename = "";
  String locale = "";
  String description = "";
  bool status = false;
  int id = 0;
  String countryflag = "";
  String jsonfile = "";

  factory Table5.fromJson(Map<String, dynamic> json) => Table5(
    languagename: json["languagename"] ?? "",
    locale: json["locale"] ?? "",
    description: json["description"] ?? "",
    status: json["status"] ?? false,
    id: json["id"] ?? 0,
    countryflag: json["countryflag"] ?? "",
    jsonfile: json["jsonfile"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "languagename": languagename,
    "locale": locale,
    "description": description,
    "status": status,
    "id": id,
    "countryflag": countryflag,
    "jsonfile": jsonfile,
  };
}

class EnumValues<T> {
  Map<String, T> map = {};
  Map<T, String> reverseMap = {};

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
