// To parse this JSON data, do
//
//     ResTrackList resTrackList = resTrackListFromJson(jsonString);

import 'dart:convert';

import '../../../helpers/parsing_helper.dart';

ResTrackList resTrackListFromJson(String str) =>
    ResTrackList.fromJson(json.decode(str));

String resTrackListToJson(ResTrackList data) => json.encode(data.toJson());

class ResTrackList {
  ResTrackList({
    required this.table5,
  });

  List<Table5> table5 = [];

  factory ResTrackList.fromJson(Map<String, dynamic> json) => ResTrackList(
        table5: json["table5"] == null
            ? []
            : List<Table5>.from(json["table5"].map((x) => Table5.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table5": List<dynamic>.from(table5.map((x) => x.toJson())),
      };
}

class Table5 {
  Table5({
    this.objectid = "",
    this.contentid = "",
    this.objecttypeid = 0,
    this.mediatypeid = 0,
    this.folderpath = "",
    this.startpage = "",
    this.name = "",
    this.iconpath = "",
    this.downloadable = false,
    this.viewtype = 0,
    this.saleprice,
    this.scoid = 0,
    this.thumbnailimagepath = "",
    this.contenttypethumbnail = "",
    this.medianame = "",
    this.version,
    this.author = "",
    this.devicetypeid = 0,
    this.listprice,
    this.currency,
    this.shortdescription = "",
    this.longdescription,
    this.createddate,
    this.eventstartdatetime,
    this.eventenddatetime,
    this.bit5 = false,
    this.participanturl,
    this.timezone,
    this.eventfulllocation,
    this.objectfolderid = "",
    this.parentid,
    this.sequencenumber = 0,
    this.jwvideokey,
    this.cloudmediaplayerkey,
    this.ratingid = 0,
    this.presentername,
    this.percentcompleted = "",
    this.corelessonstatus = "",
    this.actualstatus,
    this.jwstartpage = "",
    this.eventid,
    this.eventtype = 0,
    this.typeofevent = 0,
    this.activityid = "",
    this.progress = "",
    this.actionviewqrcode,
    this.qrimagename,
    this.allowednavigation = true,
    this.wstatus = "",
  });

  String objectid = "";
  String contentid = "";
  int objecttypeid = 0;
  int mediatypeid = 0;
  String folderpath = "";
  String startpage = "";
  String name = "";
  String iconpath = "";
  bool downloadable;
  int viewtype = 0;
  dynamic saleprice;
  int scoid = 0;
  String thumbnailimagepath = "";
  String contenttypethumbnail = "";
  String medianame = "";
  dynamic version;
  String author = "";
  int devicetypeid = 0;
  dynamic listprice;
  dynamic currency;
  String shortdescription = "";
  dynamic longdescription;
  DateTime? createddate;
  dynamic eventstartdatetime;
  dynamic eventenddatetime;
  bool bit5 = false;
  dynamic participanturl;
  dynamic timezone;
  dynamic eventfulllocation;
  String objectfolderid = "";
  dynamic parentid;
  int sequencenumber = 0;
  dynamic jwvideokey;
  dynamic cloudmediaplayerkey;
  double ratingid = 0;
  dynamic presentername;
  String percentcompleted = "";
  String corelessonstatus = "";
  dynamic actualstatus;
  String jwstartpage = "";
  dynamic eventid;
  int eventtype = 0;
  int typeofevent = 0;
  String activityid = "";
  String progress = "";
  dynamic actionviewqrcode;
  dynamic qrimagename;
  bool allowednavigation = true;
  String wstatus = "";

  factory Table5.fromJson(Map<String, dynamic> json) => Table5(
        objectid: json["objectid"] ?? "",
        contentid: json["contentid"] ?? "",
        objecttypeid: json["objecttypeid"] ?? 0,
        mediatypeid: json["mediatypeid"] ?? 0,
        folderpath: json["folderpath"] ?? "",
        startpage: json["startpage"] ?? "",
        name: json["name"] ?? "",
        iconpath: json["iconpath"] ?? "",
        downloadable:
            json["downloadable"] ?? false,
        viewtype: json["viewtype"] ?? 0,
        saleprice: json["saleprice"],
        scoid: json["scoid"] ?? 0,
        thumbnailimagepath: json["thumbnailimagepath"] ?? "",
        contenttypethumbnail: json["contenttypethumbnail"] ?? "",
        medianame: json["medianame"] ?? "",
        version: json["version"],
        author: json["author"] ?? "",
        devicetypeid: json["devicetypeid"] ?? 0,
        listprice: json["listprice"],
        currency: json["currency"],
        shortdescription: json["shortdescription"] ?? "",
        longdescription: json["longdescription"],
        createddate: json["createddate"] == null
            ? null
            : DateTime.parse(json["createddate"]),
        eventstartdatetime: json["eventstartdatetime"],
        eventenddatetime: json["eventenddatetime"],
        bit5: json["bit5"] ?? false,
        participanturl: json["participanturl"],
        timezone: json["timezone"],
        eventfulllocation: json["eventfulllocation"],
        objectfolderid: json["objectfolderid"] ?? "",
        parentid: json["parentid"],
        sequencenumber: json["sequencenumber"] ?? 0,
        jwvideokey: json["jwvideokey"],
        cloudmediaplayerkey: json["cloudmediaplayerkey"],
        ratingid: json["ratingid"] == null ? 0 : json["ratingid"].toDouble(),
        presentername: json["presentername"],
        percentcompleted: json["percentcompleted"] ?? "",
        corelessonstatus: json["corelessonstatus"] ?? "",
        actualstatus: json["actualstatus"],
        jwstartpage: json["jwstartpage"] ?? "",
        eventid: json["eventid"],
        eventtype: json["eventtype"] ?? 0,
        typeofevent: json["typeofevent"] ?? 0,
        activityid: json["activityid"] ?? "",
        progress: json["progress"] ?? "",
        actionviewqrcode: json["actionviewqrcode"],
        qrimagename: json["qrimagename"],
        allowednavigation: ParsingHelper.parseBoolMethod(json["allowednavigation"]),
        wstatus: ParsingHelper.parseStringMethod(json["wstatus"]),
      );

  Map<String, dynamic> toJson() => {
        "objectid": objectid,
        "contentid": contentid,
        "objecttypeid": objecttypeid,
        "mediatypeid": mediatypeid,
        "folderpath": folderpath,
        "startpage": startpage,
        "name": name,
        "iconpath": iconpath,
        "downloadable": downloadable,
        "viewtype": viewtype,
        "saleprice": saleprice,
        "scoid": scoid,
        "thumbnailimagepath":
            thumbnailimagepath,
        "contenttypethumbnail":
            contenttypethumbnail,
        "medianame": medianame,
        "version": version,
        "author": author,
        "devicetypeid": devicetypeid,
        "listprice": listprice,
        "currency": currency,
        "shortdescription": shortdescription,
        "longdescription": longdescription,
        "createddate":
            createddate == null ? null : createddate?.toIso8601String(),
        "eventstartdatetime": eventstartdatetime,
        "eventenddatetime": eventenddatetime,
        "bit5": bit5,
        "participanturl": participanturl,
        "timezone": timezone,
        "eventfulllocation": eventfulllocation,
        "objectfolderid": objectfolderid,
        "parentid": parentid,
        "sequencenumber": sequencenumber,
        "jwvideokey": jwvideokey,
        "cloudmediaplayerkey": cloudmediaplayerkey,
        "ratingid": ratingid,
        "presentername": presentername,
        "percentcompleted": percentcompleted,
        "corelessonstatus": corelessonstatus,
        "actualstatus": actualstatus,
        "jwstartpage": jwstartpage,
        "eventid": eventid,
        "eventtype": eventtype,
        "typeofevent": typeofevent,
        "activityid": activityid,
        "progress": progress,
        "actionviewqrcode": actionviewqrcode,
        "qrimagename": qrimagename,
        "allowednavigation": allowednavigation,
        "wstatus": wstatus,
      };
}
