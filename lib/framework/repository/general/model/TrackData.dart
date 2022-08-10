// To parse this JSON data, do
//
//     TrackData trackData = trackDataFromJson(jsonString);

import 'dart:convert';

TrackData trackDataFromJson(String str) => TrackData.fromJson(json.decode(str));

String trackDataToJson(TrackData data) => json.encode(data.toJson());

class TrackData {
  TrackData({
    required this.table3,
    required this.table5,
  });

  List<Table3> table3 = [];
  List<Table5> table5 = [];

  factory TrackData.fromJson(Map<String, dynamic> json) => TrackData(
        table3: json["table3"] == null
            ? []
            : List<Table3>.from(json["table3"].map((x) => Table3.fromJson(x))),
        table5: json["table5"] == null
            ? []
            : List<Table5>.from(json["table5"].map((x) => Table5.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table3": table3 == null
            ? null
            : List<dynamic>.from(table3.map((x) => x.toJson())),
        "table5": table5 == null
            ? null
            : List<dynamic>.from(table5.map((x) => x.toJson())),
      };
}

class Table3 {
  Table3({
    this.trackscoid = 0,
    this.scoid = 0,
    this.sequencenumber = 0,
    this.objecttypeid = 0,
    this.name = "",
  });

  int trackscoid = 0;
  int scoid = 0;
  int sequencenumber = 0;
  int objecttypeid = 0;
  String name = "";

  factory Table3.fromJson(Map<String, dynamic> json) => Table3(
        trackscoid: json["trackscoid"] == null ? null : json["trackscoid"],
        scoid: json["scoid"] == null ? null : json["scoid"],
        sequencenumber:
            json["sequencenumber"] == null ? null : json["sequencenumber"],
        objecttypeid:
            json["objecttypeid"] == null ? null : json["objecttypeid"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "trackscoid": trackscoid == null ? null : trackscoid,
        "scoid": scoid == null ? null : scoid,
        "sequencenumber": sequencenumber == null ? null : sequencenumber,
        "objecttypeid": objecttypeid == null ? null : objecttypeid,
        "name": name == null ? null : name,
      };
}

class Table5 {
  Table5({
    this.objectid = "",
    this.contentid = "",
    this.objecttypeid = 0,
    this.mediatypeid,
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
    this.longdescription = "",
    this.createddate,
    this.eventstartdatetime,
    this.eventenddatetime,
    this.bit5,
    this.participanturl,
    this.timezone,
    this.eventfulllocation,
    this.objectfolderid = "",
    this.parentid = "",
    this.sequencenumber = 0,
    this.jwvideokey,
    this.cloudmediaplayerkey,
    this.ratingid,
    this.presentername,
    this.percentcompleted = "",
    this.corelessonstatus = "",
    this.actualstatus = "",
    this.jwstartpage = "",
    this.eventid,
    this.eventtype = 0,
    this.typeofevent = 0,
    this.activityid = "",
    this.progress = "",
    this.actionviewqrcode,
    this.qrimagename,
  });

  String objectid = "";
  String contentid = "";
  int objecttypeid = 0;
  dynamic mediatypeid;
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
  String longdescription = "";
  DateTime? createddate;
  dynamic eventstartdatetime;
  dynamic eventenddatetime;
  dynamic bit5;
  dynamic participanturl;
  dynamic timezone;
  dynamic eventfulllocation;
  String objectfolderid = "";
  String parentid = "";
  int sequencenumber = 0;
  dynamic jwvideokey;
  dynamic cloudmediaplayerkey;
  dynamic ratingid;
  dynamic presentername;
  String percentcompleted = "";
  String corelessonstatus = "";
  String actualstatus = "";
  String jwstartpage = "";
  dynamic eventid;
  int eventtype = 0;
  int typeofevent = 0;
  String activityid = "";
  String progress = "";
  dynamic actionviewqrcode;
  dynamic qrimagename;

  factory Table5.fromJson(Map<String, dynamic> json) => Table5(
        objectid: json["objectid"] == null ? null : json["objectid"],
        contentid: json["contentid"] == null ? null : json["contentid"],
        objecttypeid:
            json["objecttypeid"] == null ? null : json["objecttypeid"],
        mediatypeid: json["mediatypeid"],
        folderpath: json["folderpath"] == null ? null : json["folderpath"],
        startpage: json["startpage"] == null ? null : json["startpage"],
        name: json["name"] == null ? null : json["name"],
        iconpath: json["iconpath"] == null ? null : json["iconpath"],
        downloadable:
            json["downloadable"] == null ? null : json["downloadable"],
        viewtype: json["viewtype"] == null ? null : json["viewtype"],
        saleprice: json["saleprice"],
        scoid: json["scoid"] == null ? null : json["scoid"],
        thumbnailimagepath: json["thumbnailimagepath"] == null
            ? null
            : json["thumbnailimagepath"],
        contenttypethumbnail: json["contenttypethumbnail"] == null
            ? null
            : json["contenttypethumbnail"],
        medianame: json["medianame"] == null ? null : json["medianame"],
        version: json["version"],
        author: json["author"] == null ? null : json["author"],
        devicetypeid:
            json["devicetypeid"] == null ? null : json["devicetypeid"],
        listprice: json["listprice"],
        currency: json["currency"],
        shortdescription:
            json["shortdescription"] == null ? null : json["shortdescription"],
        longdescription:
            json["longdescription"] == null ? null : json["longdescription"],
        createddate: json["createddate"] == null
            ? null
            : DateTime.parse(json["createddate"]),
        eventstartdatetime: json["eventstartdatetime"],
        eventenddatetime: json["eventenddatetime"],
        bit5: json["bit5"],
        participanturl: json["participanturl"],
        timezone: json["timezone"],
        eventfulllocation: json["eventfulllocation"],
        objectfolderid:
            json["objectfolderid"] == null ? null : json["objectfolderid"],
        parentid: json["parentid"] == null ? null : json["parentid"],
        sequencenumber:
            json["sequencenumber"] == null ? null : json["sequencenumber"],
        jwvideokey: json["jwvideokey"],
        cloudmediaplayerkey: json["cloudmediaplayerkey"],
        ratingid: json["ratingid"] == null ? null : json["ratingid"],
        presentername: json["presentername"],
        percentcompleted:
            json["percentcompleted"] == null ? null : json["percentcompleted"],
        corelessonstatus:
            json["corelessonstatus"] == null ? null : json["corelessonstatus"],
        actualstatus:
            json["actualstatus"] == null ? null : json["actualstatus"],
        jwstartpage: json["jwstartpage"] == null ? null : json["jwstartpage"],
        eventid: json["eventid"],
        eventtype: json["eventtype"] == null ? null : json["eventtype"],
        typeofevent: json["typeofevent"] == null ? null : json["typeofevent"],
        activityid: json["activityid"] == null ? null : json["activityid"],
        progress: json["progress"] == null ? null : json["progress"],
        actionviewqrcode: json["actionviewqrcode"],
        qrimagename: json["qrimagename"],
      );

  Map<String, dynamic> toJson() => {
        "objectid": objectid == null ? null : objectid,
        "contentid": contentid == null ? null : contentid,
        "objecttypeid": objecttypeid == null ? null : objecttypeid,
        "mediatypeid": mediatypeid,
        "folderpath": folderpath == null ? null : folderpath,
        "startpage": startpage == null ? null : startpage,
        "name": name == null ? null : name,
        "iconpath": iconpath == null ? null : iconpath,
        "downloadable": downloadable == null ? null : downloadable,
        "viewtype": viewtype == null ? null : viewtype,
        "saleprice": saleprice,
        "scoid": scoid == null ? null : scoid,
        "thumbnailimagepath":
            thumbnailimagepath == null ? null : thumbnailimagepath,
        "contenttypethumbnail":
            contenttypethumbnail == null ? null : contenttypethumbnail,
        "medianame": medianame == null ? null : medianame,
        "version": version,
        "author": author == null ? null : author,
        "devicetypeid": devicetypeid == null ? null : devicetypeid,
        "listprice": listprice,
        "currency": currency,
        "shortdescription": shortdescription == null ? null : shortdescription,
        "longdescription": longdescription == null ? null : longdescription,
        "createddate":
            createddate == null ? null : createddate?.toIso8601String(),
        "eventstartdatetime": eventstartdatetime,
        "eventenddatetime": eventenddatetime,
        "bit5": bit5,
        "participanturl": participanturl,
        "timezone": timezone,
        "eventfulllocation": eventfulllocation,
        "objectfolderid": objectfolderid == null ? null : objectfolderid,
        "parentid": parentid == null ? null : parentid,
        "sequencenumber": sequencenumber == null ? null : sequencenumber,
        "jwvideokey": jwvideokey,
        "cloudmediaplayerkey": cloudmediaplayerkey,
        "ratingid": ratingid == null ? null : ratingid,
        "presentername": presentername,
        "percentcompleted": percentcompleted == null ? null : percentcompleted,
        "corelessonstatus": corelessonstatus == null ? null : corelessonstatus,
        "actualstatus": actualstatus == null ? null : actualstatus,
        "jwstartpage": jwstartpage == null ? null : jwstartpage,
        "eventid": eventid,
        "eventtype": eventtype == null ? null : eventtype,
        "typeofevent": typeofevent == null ? null : typeofevent,
        "activityid": activityid == null ? null : activityid,
        "progress": progress == null ? null : progress,
        "actionviewqrcode": actionviewqrcode,
        "qrimagename": qrimagename,
      };
}
