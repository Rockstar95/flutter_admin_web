// To parse this JSON data, do
//
//     final resDyanicSignUp = resDyanicSignUpFromJson(jsonString);

import 'dart:convert';

ResDyanicSignUp resDyanicSignUpFromJson(String str) =>
    ResDyanicSignUp.fromJson(json.decode(str));

String resDyanicSignUpToJson(ResDyanicSignUp data) =>
    json.encode(data.toJson());

class ResDyanicSignUp {
  List<Profileconfigdatum> profileconfigdata;
  List<Termsofusewebpage> termsofusewebpage;
  List<Attributechoice> attributechoices;

  ResDyanicSignUp({
    required this.profileconfigdata,
    required this.termsofusewebpage,
    required this.attributechoices,
  });

  static ResDyanicSignUp fromJson(Map<String, dynamic> json) => ResDyanicSignUp(
        profileconfigdata: json["profileconfigdata"] == null
            ? []
            : List<Profileconfigdatum>.from(json["profileconfigdata"]
                .map((x) => Profileconfigdatum.fromJson(x))),
        termsofusewebpage: json["termsofusewebpage"] == null
            ? []
            : List<Termsofusewebpage>.from(json["termsofusewebpage"]
                .map((x) => Termsofusewebpage.fromJson(x))),
        attributechoices: json["attributechoices"] == null
            ? []
            : List<Attributechoice>.from(json["attributechoices"]
                .map((x) => Attributechoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "profileconfigdata": profileconfigdata == null
            ? null
            : List<dynamic>.from(profileconfigdata.map((x) => x.toJson())),
        "termsofusewebpage": termsofusewebpage == null
            ? null
            : List<dynamic>.from(termsofusewebpage.map((x) => x.toJson())),
        "attributechoices": attributechoices == null
            ? null
            : List<dynamic>.from(attributechoices.map((x) => x.toJson())),
      };
}

class Attributechoice {
  int attributeconfigid;
  String choicetext;
  String choicevalue;

  Attributechoice({
    this.attributeconfigid = 0,
    this.choicetext = "",
    this.choicevalue = "",
  });

  factory Attributechoice.fromJson(Map<String, dynamic> json) =>
      Attributechoice(
        attributeconfigid:
            json["attributeconfigid"] == null ? 0 : json["attributeconfigid"],
        choicetext: json["choicetext"] == null ? "" : json["choicetext"],
        choicevalue: json["choicevalue"] == null ? "" : json["choicevalue"],
      );

  Map<String, dynamic> toJson() => {
        "attributeconfigid": attributeconfigid,
        "choicetext": choicetext,
        "choicevalue": choicevalue,
      };
}

class Profileconfigdatum {
  int attributeconfigid;
  String datafieldname;
  String aliasname;
  bool isrequired;
  bool enduservisibility;
  int maxlength;
  int uicontroltypeid;
  int displayorder;
  bool iseditable;
  int groupid;
  String displaytext;
  String valueName;
  String displaySpinnerText;
  Attributechoice selectedSpinerObj;

  //List <String> spinnerItems;
  List<Attributechoice> spinnerItems;

  Profileconfigdatum({
    this.attributeconfigid = 0,
    this.datafieldname = "",
    this.aliasname = "",
    this.isrequired = false,
    this.enduservisibility = false,
    this.maxlength = 0,
    this.uicontroltypeid = 0,
    this.displayorder = 0,
    this.iseditable = false,
    this.groupid = 0,
    this.displaytext = "",
    this.valueName = "",
    this.displaySpinnerText = "",
    required this.selectedSpinerObj,
    required this.spinnerItems,
  });

  static Profileconfigdatum fromJson(Map<String, dynamic> json) =>
      Profileconfigdatum(
        attributeconfigid:
            json["attributeconfigid"] == null ? 0 : json["attributeconfigid"],
        datafieldname:
            json["datafieldname"] == null ? "" : json["datafieldname"],
        aliasname: json["aliasname"] == null ? "" : json["aliasname"],
        isrequired: json["isrequired"] == null ? false : json["isrequired"],
        enduservisibility: json["enduservisibility"] == null
            ? false
            : json["enduservisibility"],
        maxlength: json["maxlength"] == null ? 0 : json["maxlength"],
        uicontroltypeid:
            json["uicontroltypeid"] == null ? 0 : json["uicontroltypeid"],
        displayorder: json["displayorder"] == null ? 0 : json["displayorder"],
        iseditable: json["iseditable"] == null ? false : json["iseditable"],
        groupid: json["groupid"] == null ? 0 : json["groupid"],
        displaytext: json["displaytext"] == null ? "" : json["displaytext"],
        valueName: json["valueName"] == null ? "" : json["valueName"],
        displaySpinnerText: json["displaySpinnerText"] == null
            ? ""
            : json["displaySpinnerText"],
        selectedSpinerObj: Attributechoice(),
        spinnerItems: [],
      );

  Map<String, dynamic> toJson() => {
        "attributeconfigid": attributeconfigid,
        "datafieldname": datafieldname,
        "aliasname": aliasname,
        "isrequired": isrequired,
        "enduservisibility": enduservisibility,
        "maxlength": maxlength,
        "uicontroltypeid": uicontroltypeid,
        "displayorder": displayorder,
        "iseditable": iseditable,
        "groupid": groupid,
        "displaytext": displaytext,
        "valueName": valueName,
      };
}

class Termsofusewebpage {
  String termsofusewebpage;

  Termsofusewebpage({
    this.termsofusewebpage = "",
  });

  factory Termsofusewebpage.fromJson(Map<String, dynamic> json) =>
      Termsofusewebpage(
        termsofusewebpage:
            json["termsofusewebpage"] == null ? "" : json["termsofusewebpage"],
      );

  Map<String, dynamic> toJson() => {
        "termsofusewebpage":
            termsofusewebpage == null ? null : termsofusewebpage,
      };
}
