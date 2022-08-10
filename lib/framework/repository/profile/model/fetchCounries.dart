// To parse this JSON data, do
//
//     final countryResponse = countryResponseFromJson(jsonString);

import 'dart:convert';

CountryResponse countryResponseFromJson(String str) =>
    CountryResponse.fromJson(json.decode(str));

String countryResponseToJson(CountryResponse data) =>
    json.encode(data.toJson());

class CountryResponse {
  CountryResponse({
    required this.table5,
  });

  List<Table5> table5 = [];

  factory CountryResponse.fromJson(Map<String, dynamic> json) =>
      CountryResponse(
        table5: List<Table5>.from(
            (json["table5"] ?? []).map((x) => Table5.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table5": List<dynamic>.from(table5.map((x) => x.toJson())),
      };
}

class Table5 {
  Table5({
    this.choiceid = 0,
    this.attributeconfigid = 0,
    this.choicetext = "",
    this.choicevalue = "",
    this.localename = "",
    this.parenttext,
  });

  int choiceid = 0;
  int attributeconfigid = 0;
  String choicetext = "";
  String choicevalue = "";
  String localename = "";
  dynamic parenttext;

  factory Table5.fromJson(Map<String, dynamic> json) => Table5(
        choiceid: json["choiceid"] ?? 0,
        attributeconfigid: json["attributeconfigid"] ?? 0,
        choicetext: json["choicetext"] ?? "",
        choicevalue: json["choicevalue"] ?? "",
        localename: json["localename"] ?? "",
        parenttext: json["parenttext"],
      );

  Map<String, dynamic> toJson() => {
        "choiceid": choiceid,
        "attributeconfigid": attributeconfigid,
        "choicetext": choicetext,
        "choicevalue": choicevalue,
        "localename": localename,
        "parenttext": parenttext,
      };
}
