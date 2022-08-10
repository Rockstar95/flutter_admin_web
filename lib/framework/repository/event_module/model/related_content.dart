// To parse this JSON data, do
//
//     final relatedContentEventResponse = relatedContentEventResponseFromJson(jsonString);

import 'dart:convert';

RelatedContentEventResponse relatedContentEventResponseFromJson(String str) =>
    RelatedContentEventResponse.fromJson(json.decode(str));

String relatedContentEventResponseToJson(RelatedContentEventResponse data) =>
    json.encode(data.toJson());

class RelatedContentEventResponse {
  RelatedContentEventResponse({
    required this.eventrelatedcontentdata,
  });

  List<Eventrelatedcontentdatum> eventrelatedcontentdata = [];

  factory RelatedContentEventResponse.fromJson(Map<String, dynamic> json) =>
      RelatedContentEventResponse(
        eventrelatedcontentdata: List<Eventrelatedcontentdatum>.from(
            (json["eventrelatedcontentdata"] ?? []).map((x) => Eventrelatedcontentdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "eventrelatedcontentdata":
            List<dynamic>.from(eventrelatedcontentdata.map((x) => x.toJson())),
      };
}

class Eventrelatedcontentdatum {
  Eventrelatedcontentdatum({
    this.userid = 0,
    this.eventid = "",
    this.medianame = "",
    this.description = "",
    this.contenttype = "",
    this.iconpath = "",
    this.iscontent = false,
    this.contenttypethumbnail = "",
    this.contentid = "",
    this.name = "",
    this.objecttypeid = 0,
    this.language = "",
    this.shortdescription = "",
    this.version,
    this.startpage = "",
    this.createduserid = 0,
    this.createddate,
    this.keywords = "",
    this.downloadable = false,
    this.publisheddate,
    this.certificatepage = "",
    this.certificateid = "",
    this.status = "",
    this.cmsgroupid = 0,
    this.longdescription = "",
    this.mediatypeid = 0,
    this.publicationdate,
    this.activatedate,
    this.expirydate,
    this.thumbnailimagepath = "",
    this.folderpath = "",
    this.folderid,
    this.modifieduserid = 0,
    this.modifieddate,
    this.author = "",
    this.viewtype = 0,
    this.windowproperties = "",
    this.launchwindowmode,
    this.active = false,
    this.contentstatus,
    this.outputtype = "",
    this.devicetypeid = 0,
    this.ratingid = 0,
    this.totalratings = 0,
    this.bit3,
    this.bit5,
    this.bit4,
    this.totalattempts = 0,
    this.authordisplayname = "",
    this.accessperiodtype = 0,
    this.assignedby = 0,
    this.actualstatus = "",
    this.displayorder = 0,
    this.scoid = 0,
    this.grading = 0,
    this.corelessonstatus = "",
    this.isdeleted = false,
    this.isprivate = 0,
    this.percentcompleted = "",
    this.objectid = "",
    this.attemptsleft,
    this.usercontentstatus = false,
    this.wresult,
    this.wmessage,
    this.jwvideokey,
    this.cloudmediaplayerkey,
    this.activityid = "",
    this.invitationurl,
    this.link,
    this.pareportlink,
    this.dareportlink,
  });

  int userid = 0;
  String eventid = "";
  String medianame = "";
  String description = "";
  String contenttype = "";
  String iconpath = "";
  bool iscontent = false;
  String contenttypethumbnail = "";
  String contentid = "";
  String name = "";
  int objecttypeid = 0;
  String language = "";
  String shortdescription = "";
  dynamic version;
  String startpage = "";
  int createduserid = 0;
  DateTime? createddate;
  String keywords = "";
  bool downloadable = false;
  DateTime? publisheddate;
  String certificatepage = "";
  String certificateid = "";
  String status = "";
  int cmsgroupid = 0;
  String longdescription = "";
  int mediatypeid;
  dynamic publicationdate;
  dynamic activatedate;
  dynamic expirydate;
  String thumbnailimagepath = "";
  String folderpath = "";
  dynamic folderid;
  int modifieduserid = 0;
  DateTime? modifieddate;
  String author = "";
  int viewtype;
  String windowproperties = "";
  dynamic launchwindowmode;
  bool active = false;
  dynamic contentstatus;
  String outputtype = "";
  int devicetypeid = 0;
  double ratingid;
  int totalratings = 0;
  dynamic bit3;
  dynamic bit5;
  dynamic bit4;
  int totalattempts = 0;
  String authordisplayname = "";
  int accessperiodtype = 0;
  int assignedby = 0;
  String actualstatus = "";
  int displayorder = 0;
  int scoid = 0;
  int grading = 0;
  String corelessonstatus = "";
  bool isdeleted = false;
  int isprivate = 0;
  String percentcompleted = "";
  String objectid = "";
  dynamic attemptsleft;
  bool usercontentstatus = false;
  dynamic wresult;
  dynamic wmessage;
  dynamic jwvideokey;
  dynamic cloudmediaplayerkey;
  String activityid = "";
  dynamic invitationurl;
  dynamic link;
  dynamic pareportlink;
  dynamic dareportlink;

  factory Eventrelatedcontentdatum.fromJson(Map<String, dynamic> json) =>
      Eventrelatedcontentdatum(
        userid: json["userid"] ?? 0,
        eventid: json["eventid"] ?? "",
        medianame: json["medianame"] ?? "",
        description: json["description"] ?? "",
        contenttype: json["contenttype"] ?? "",
        iconpath: json["iconpath"] ?? "",
        iscontent: json["iscontent"],
        contenttypethumbnail: json["contenttypethumbnail"] ?? "",
        contentid: json["contentid"] ?? "",
        name: json["name"] ?? "",
        objecttypeid: json["objecttypeid"] ?? 0,
        language: json["language"] ?? "",
        shortdescription: json["shortdescription"] ?? "",
        version: json["version"],
        startpage: json["startpage"] ?? "",
        createduserid: json["createduserid"] ?? 0,
        createddate: DateTime.parse(json["createddate"]),
        keywords: json["keywords"] ?? "",
        downloadable: json["downloadable"],
        certificatepage: json["certificatepage"] ?? "",
        certificateid: json["certificateid"] ?? "",
        publisheddate: DateTime.parse(json["publisheddate"]),
        status: json["status"] ?? "",
        cmsgroupid: json["cmsgroupid"] ?? 0,
        longdescription: json["longdescription"] ?? "",
        mediatypeid: json["mediatypeid"] == null ? 0 : json["mediatypeid"],
        publicationdate: json["publicationdate"],
        activatedate: json["activatedate"],
        expirydate: json["expirydate"],
        thumbnailimagepath: json["thumbnailimagepath"] ?? "",
        folderpath: json["folderpath"] ?? "",
        folderid: json["folderid"],
        modifieduserid: json["modifieduserid"] ?? 0,
        modifieddate: DateTime.parse(json["modifieddate"]),
        author: json["author"] ?? "",
        viewtype: json["viewtype"] ?? 0,
        windowproperties: json["windowproperties"] ?? "",
        launchwindowmode: json["launchwindowmode"],
        active: json["active"],
        contentstatus: json["contentstatus"],
        outputtype: json["outputtype"] ?? "",
        devicetypeid: json["devicetypeid"] ?? 0,
        ratingid: json["ratingid"].toDouble(),
        totalratings: json["totalratings"] ?? 0,
        bit3: json["bit3"],
        bit5: json["bit5"],
        bit4: json["bit4"],
        totalattempts: json["totalattempts"] ?? 0,
        authordisplayname: json["authordisplayname"] ?? "",
        accessperiodtype: json["accessperiodtype"] ?? 0,
        assignedby: json["assignedby"] ?? 0,
        actualstatus: json["actualstatus"] ?? "",
        displayorder: json["displayorder"] ?? 0,
        scoid: json["scoid"] ?? 0,
        grading: json["grading"] ?? 0,
        corelessonstatus: json["corelessonstatus"] ?? "",
        isdeleted: json["isdeleted"],
        isprivate: json["isprivate"] ?? 0,
        percentcompleted: json["percentcompleted"] ?? "",
        objectid: json["objectid"] ?? "",
        attemptsleft: json["attemptsleft"],
        usercontentstatus: json["usercontentstatus"],
        wresult: json["wresult"],
        wmessage: json["wmessage"],
        jwvideokey: json["jwvideokey"],
        cloudmediaplayerkey: json["cloudmediaplayerkey"],
        activityid: json["activityid"] ?? "",
        invitationurl: json["invitationurl"],
        link: json["link"],
        pareportlink: json["pareportlink"],
        dareportlink: json["dareportlink"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "eventid": eventid,
        "medianame": medianame,
        "description": description,
        "contenttype": contenttype,
        "iconpath": iconpath,
        "iscontent": iscontent,
        "contenttypethumbnail": contenttypethumbnail,
        "contentid": contentid,
        "name": name,
        "objecttypeid": objecttypeid,
        "language": language,
        "shortdescription": shortdescription,
        "version": version,
        "startpage": startpage,
        "createduserid": createduserid,
        "createddate": createddate?.toIso8601String(),
        "keywords": keywords,
        "downloadable": downloadable,
        "publisheddate": publisheddate?.toIso8601String(),
        "certificatepage": certificatepage,
        "certificateid": certificateid,
        "status": status,
        "cmsgroupid": cmsgroupid,
        "longdescription": longdescription,
        "mediatypeid": mediatypeid == null ? null : mediatypeid,
        "publicationdate": publicationdate,
        "activatedate": activatedate,
        "expirydate": expirydate,
        "thumbnailimagepath": thumbnailimagepath,
        "folderpath": folderpath,
        "folderid": folderid,
        "modifieduserid": modifieduserid,
        "modifieddate": modifieddate?.toIso8601String(),
        "author": author,
        "viewtype": viewtype,
        "windowproperties": windowproperties,
        "launchwindowmode": launchwindowmode,
        "active": active,
        "contentstatus": contentstatus,
        "outputtype": outputtype == null ? null : outputtype,
        "devicetypeid": devicetypeid == null ? null : devicetypeid,
        "ratingid": ratingid,
        "totalratings": totalratings,
        "bit3": bit3,
        "bit5": bit5,
        "bit4": bit4,
        "totalattempts": totalattempts,
        "authordisplayname": authordisplayname,
        "accessperiodtype": accessperiodtype,
        "assignedby": assignedby,
        "actualstatus": actualstatus,
        "displayorder": displayorder,
        "scoid": scoid,
        "grading": grading,
        "corelessonstatus": corelessonstatus,
        "isdeleted": isdeleted,
        "isprivate": isprivate,
        "percentcompleted": percentcompleted,
        "objectid": objectid,
        "attemptsleft": attemptsleft,
        "usercontentstatus": usercontentstatus,
        "wresult": wresult,
        "wmessage": wmessage,
        "jwvideokey": jwvideokey,
        "cloudmediaplayerkey": cloudmediaplayerkey,
        "activityid": activityid,
        "invitationurl": invitationurl,
        "link": link,
        "pareportlink": pareportlink,
        "dareportlink": dareportlink,
      };
}
