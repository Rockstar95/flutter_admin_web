// To parse this JSON data, do
//
//     TinCanData tinCanData = tinCanDataFromJson(jsonString);

import 'dart:convert';

TinCanData tinCanDataFromJson(String str) => TinCanData.fromJson(json.decode(str));

String tinCanDataToJson(TinCanData data) => json.encode(data.toJson());

class TinCanData {
  TinCanData({
    this.istincan = "",
    this.lrsendpoint = "",
    this.lrsauthorization = "",
    this.lrsauthorizationpassword = "",
    this.enabletincansupportforco = "",
    this.enabletincansupportforao = "",
    this.enabletincansupportforlt = "",
  });

  String istincan = "";
  String lrsendpoint = "";
  String lrsauthorization = "";
  String lrsauthorizationpassword = "";
  String enabletincansupportforco = "";
  String enabletincansupportforao = "";
  String enabletincansupportforlt = "";

  factory TinCanData.fromJson(Map<String, dynamic> json) => TinCanData(
        istincan: json["istincan"] == null ? null : json["istincan"],
        lrsendpoint: json["lrsendpoint"] == null ? null : json["lrsendpoint"],
        lrsauthorization:
            json["lrsauthorization"] == null ? null : json["lrsauthorization"],
        lrsauthorizationpassword: json["lrsauthorizationpassword"] == null
            ? null
            : json["lrsauthorizationpassword"],
        enabletincansupportforco: json["enabletincansupportforco"] == null
            ? null
            : json["enabletincansupportforco"],
        enabletincansupportforao: json["enabletincansupportforao"] == null
            ? null
            : json["enabletincansupportforao"],
        enabletincansupportforlt: json["enabletincansupportforlt"] == null
            ? null
            : json["enabletincansupportforlt"],
      );

  Map<String, dynamic> toJson() => {
        "istincan": istincan == null ? null : istincan,
        "lrsendpoint": lrsendpoint == null ? null : lrsendpoint,
        "lrsauthorization": lrsauthorization == null ? null : lrsauthorization,
        "lrsauthorizationpassword":
            lrsauthorizationpassword == null ? null : lrsauthorizationpassword,
        "enabletincansupportforco":
            enabletincansupportforco == null ? null : enabletincansupportforco,
        "enabletincansupportforao":
            enabletincansupportforao == null ? null : enabletincansupportforao,
        "enabletincansupportforlt":
            enabletincansupportforlt == null ? null : enabletincansupportforlt,
      };
}
