// To parse this JSON data, do
//
//     final creditResponseModel = creditResponseModelFromJson(jsonString);

import 'dart:convert';

CreditResponseModel creditResponseModelFromJson(String str) =>
    CreditResponseModel.fromJson(json.decode(str));

String creditResponseModelToJson(CreditResponseModel data) =>
    json.encode(data.toJson());

class CreditResponseModel {
  CreditResponseModel({
    required this.table1,
  });

  List<CreditModel> table1 = [];

  factory CreditResponseModel.fromJson(Map<String, dynamic> json) =>
      CreditResponseModel(
        table1: json["Table1"] == null
            ? []
            : List<CreditModel>.from(
                json["Table1"].map((x) => CreditModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table1": table1 == null
            ? null
            : List<dynamic>.from(table1.map((x) => x.toJson())),
      };
}

class CreditModel {
  CreditModel({
    this.displayvalue = "",
    this.minvalue,
    this.maxvalue,
    this.defaultvalue = "",
  });

  String displayvalue = "";
  dynamic minvalue;
  dynamic maxvalue;
  String defaultvalue = "";

  factory CreditModel.fromJson(Map<String, dynamic> json) => CreditModel(
        displayvalue:
            json["Displayvalue"] == null ? null : json["Displayvalue"],
        minvalue: json["Minvalue"] == null ? null : json["Minvalue"],
        maxvalue: json["Maxvalue"] == null ? null : json["Maxvalue"],
        defaultvalue:
            json["defaultvalue"] == null ? null : json["defaultvalue"],
      );

  Map<String, dynamic> toJson() => {
        "Displayvalue": displayvalue == null ? null : displayvalue,
        "Minvalue": minvalue == null ? null : minvalue,
        "Maxvalue": maxvalue == null ? null : maxvalue,
        "defaultvalue": defaultvalue == null ? null : defaultvalue,
      };
}
