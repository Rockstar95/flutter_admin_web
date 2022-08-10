// To parse this JSON data, do
//
//     final myCatalogResponse = myCatalogResponseFromJson(jsonString);

import 'dart:convert';

MyCatalogResponse myCatalogResponseFromJson(String str) =>
    MyCatalogResponse.fromJson(json.decode(str));

String myCatalogResponseToJson(MyCatalogResponse data) =>
    json.encode(data.toJson());

class MyCatalogResponse {
  MyCatalogResponse({
    required this.table2,
  });

  List<Table2> table2 = [];

  factory MyCatalogResponse.fromJson(Map<String, dynamic> json) =>
      MyCatalogResponse(
        table2:
            List<Table2>.from(json["table2"].map((x) => Table2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table2": List<dynamic>.from(table2.map((x) => x.toJson())),
      };
}

class Table2 {
  Table2({
    this.filterid = 0,
    this.siteid = 0,
    this.usersiteid = 0,
    this.sitename = "",
    this.objectid = "",
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
    this.status = "",
    this.cmsgroupid = 0,
    this.checkedoutto,
    this.longdescription = "",
    this.mediatypeid,
    this.owner,
    this.publicationdate,
    this.activatedate,
    this.expirydate,
    this.thumbnailimagepath = "",
    this.ecommbussinessrule = 0,
    this.downloadfile,
    this.saleprice,
    this.listprice,
    this.folderpath = "",
    this.skinid,
    this.folderid,
    this.modifieduserid = 0,
    this.modifieddate,
    this.viewtype = 0,
    this.windowproperties = "",
    this.currency,
    this.certificateid = "",
    this.launchwindowmode,
    this.active = false,
    this.hardwaretype,
    this.enrollmentlimit,
    this.presenterurl,
    this.participanturl,
    this.eventstartdatetime,
    this.eventenddatetime,
    this.presenterid,
    this.contentstatus,
    this.location,
    this.conferencenumbers,
    this.directionurl,
    this.eventpercentage = "",
    this.starttime,
    this.duration,
    this.personalizediconid1,
    this.personalizediconid2,
    this.ciid = 0,
    this.noofusersenrolled = 0,
    this.noofuserscompleted = 0,
    this.eventkey,
    this.eventtype = 0,
    this.devicetypeid = 0,
    this.nvarchar2,
    this.nvarchar3,
    this.audience,
    this.backgroundcolor = "",
    this.fontcolor = "",
    this.searchreferencenumber,
    this.nvarchar4,
    this.timezone,
    this.bit3,
    this.bit4,
    this.typeofevent = 0,
    this.webinartool = 0,
    this.webinarpassword,
    this.bit5 = false,
    this.bit2,
    this.seotitle,
    this.seometadescription,
    this.seokeywords,
    this.waitlistlimit,
    this.totalattempts = 0,
    this.accessperiodtype = 0,
    this.itunesproductid,
    this.googleproductid,
    this.decimal2,
    this.budgetprice,
    this.budgetcurrency,
    this.eventresourcedisplayoption,
    this.certificatepercentage = "",
    this.activityid = "",
    this.eventscheduletype = 0,
    this.bigint4,
    this.offeringstartdate,
    this.offeringenddate,
    this.contentauthordisplayname = "",
    this.registrationurl,
    this.videointroduction,
    this.noofmodules,
    this.learningobjectives,
    this.tableofcontent,
    this.tagname,
    this.credittypes,
    this.eventcategories,
    this.eventrecording = false,
    this.recordingmsg,
    this.recordingcontentid,
    this.recordingurl = "",
    this.scoid = 0,
    this.startdate,
    this.datecompleted,
    this.accessednumber = 0,
    this.noofattempts = 0,
    this.totalsessiontime = "",
    this.corechildren,
    this.coreentry,
    this.corelessonstatus = "",
    this.corecredit,
    this.groupdisplayname = "",
    this.groupdisplayorder = 0,
    this.corelessonlocation = "",
    this.scorechildren,
    this.scoreraw = 0,
    this.scoremin,
    this.scoremax,
    this.launchdata,
    this.actualstatus = "",
    this.userid = 0,
    this.dateassigned,
    this.targetdate,
    this.ismandatory,
    this.assignedby = 0,
    this.assignedbyadmin = false,
    this.durationenddate,
    this.usercontentstatus = false,
    this.attemptsleft,
    this.accessperiod,
    this.accessperiodunit = 0,
    this.isarchived = false,
    this.purchaseddate,
    this.joinurl,
    this.confirmationurl,
    this.hide = 0,
    this.required = 0,
    this.schedulestatus = 0,
    this.schedulereserveddatetime,
    this.percentcompleted = "",
    this.invitationurl,
    this.link,
    this.pareportlink,
    this.dareportlink,
    this.availableseats,
    this.waitlistenrolls = 0,
    this.jwvideokey,
    this.cloudmediaplayerkey,
    this.usercertificateid = "",
    this.relatedconentcount = 0,
    this.dtfcontent,
    this.ratingid = 0,
    this.totalratings = 0,
    this.certificatepage = "",
    this.locationname = "",
    this.buildingname = "",
    this.commentscount = 0,
    this.authordisplayname = "",
    this.presenter,
    this.isdownloaded = false,
    this.eventrecording1 = false,
    this.recordingmsg1,
    this.recordingcontentid1,
    this.recordingurl1 = "",
    this.eventstartdatedisplay,
    this.eventenddatedisplay,
    this.timezoneabbreviation,
    this.siteurl = "",
    this.progress = "",
    this.removelink = false,
    this.reschduleparentid,
    this.isbadcancellationenabled = false,
    this.jwstartpage = "",
    this.isenrollfutureinstance = false,
    this.isviewreview = false,
    this.certificateaction = "",
    this.qrcodeimagepath,
    this.qrimagename,
    this.viewprerequisitecontentstatus,
    this.headerlocationname = "",
  });

  int filterid = 0;
  int siteid = 0;
  int usersiteid = 0;
  String sitename = "";
  String objectid = "";
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
  String status = "";
  int cmsgroupid = 0;
  dynamic checkedoutto;
  String longdescription = "";
  dynamic mediatypeid;
  dynamic owner;
  dynamic publicationdate;
  dynamic activatedate;
  dynamic expirydate;
  String thumbnailimagepath = "";
  int ecommbussinessrule = 0;
  dynamic downloadfile;
  dynamic saleprice;
  dynamic listprice;
  String folderpath = "";
  dynamic skinid;
  dynamic folderid;
  int modifieduserid = 0;
  DateTime? modifieddate;
  int viewtype = 0;
  String windowproperties = "";
  dynamic currency;
  String certificateid = "";
  dynamic launchwindowmode;
  bool active = false;
  dynamic hardwaretype;
  dynamic enrollmentlimit;
  dynamic presenterurl;
  dynamic participanturl;
  dynamic eventstartdatetime;
  dynamic eventenddatetime;
  dynamic presenterid;
  dynamic contentstatus;
  dynamic location;
  dynamic conferencenumbers;
  dynamic directionurl;
  String eventpercentage = "";
  dynamic starttime;
  dynamic duration;
  dynamic personalizediconid1;
  dynamic personalizediconid2;
  int ciid = 0;
  int noofusersenrolled = 0;
  int noofuserscompleted = 0;
  dynamic eventkey;
  int eventtype = 0;
  int devicetypeid = 0;
  dynamic nvarchar2;
  dynamic nvarchar3;
  dynamic audience;
  String backgroundcolor = "";
  String fontcolor = "";
  dynamic searchreferencenumber;
  dynamic nvarchar4;
  dynamic timezone;
  dynamic bit3;
  dynamic bit4;
  int typeofevent = 0;
  int webinartool = 0;
  dynamic webinarpassword;
  bool bit5 = false;
  dynamic bit2;
  dynamic seotitle;
  dynamic seometadescription;
  dynamic seokeywords;
  dynamic waitlistlimit;
  int totalattempts = 0;
  int accessperiodtype = 0;
  dynamic itunesproductid;
  dynamic googleproductid;
  dynamic decimal2;
  dynamic budgetprice;
  dynamic budgetcurrency;
  dynamic eventresourcedisplayoption;
  String certificatepercentage = "";
  String activityid = "";
  int eventscheduletype = 0;
  dynamic bigint4;
  dynamic offeringstartdate;
  dynamic offeringenddate;
  String contentauthordisplayname = "";
  dynamic registrationurl;
  dynamic videointroduction;
  dynamic noofmodules;
  dynamic learningobjectives;
  dynamic tableofcontent;
  dynamic tagname;
  dynamic credittypes;
  dynamic eventcategories;
  bool eventrecording = false;
  dynamic recordingmsg;
  dynamic recordingcontentid;
  String recordingurl = "";
  int scoid = 0;
  DateTime? startdate;
  DateTime? datecompleted;
  int accessednumber = 0;
  int noofattempts = 0;
  String totalsessiontime = "";
  dynamic corechildren;
  dynamic coreentry;
  String corelessonstatus = "";
  dynamic corecredit;
  String groupdisplayname = "";
  int groupdisplayorder = 0;
  String corelessonlocation = "";
  dynamic scorechildren;
  int scoreraw = 0;
  dynamic scoremin;
  dynamic scoremax;
  dynamic launchdata;
  String actualstatus = "";
  int userid = 0;
  DateTime? dateassigned;
  dynamic targetdate;
  dynamic ismandatory;
  int assignedby = 0;
  bool assignedbyadmin = false;
  dynamic durationenddate;
  bool usercontentstatus = false;
  dynamic attemptsleft;
  dynamic accessperiod;
  int accessperiodunit = 0;
  bool isarchived = false;
  dynamic purchaseddate;
  dynamic joinurl;
  dynamic confirmationurl;
  int hide = 0;
  int required = 0;
  int schedulestatus = 0;
  dynamic schedulereserveddatetime;
  String percentcompleted = "";
  dynamic invitationurl;
  dynamic link;
  dynamic pareportlink;
  dynamic dareportlink;
  dynamic availableseats;
  int waitlistenrolls = 0;
  dynamic jwvideokey;
  dynamic cloudmediaplayerkey;
  String usercertificateid = "";
  int relatedconentcount = 0;
  dynamic dtfcontent;
  double ratingid = 0;
  int totalratings = 0;
  String certificatepage = "";
  String locationname = "";
  String buildingname = "";
  int commentscount = 0;
  String authordisplayname = "";
  dynamic presenter;
  bool isdownloaded = false;
  bool eventrecording1 = false;
  dynamic recordingmsg1;
  dynamic recordingcontentid1;
  String recordingurl1 = "";
  dynamic eventstartdatedisplay;
  dynamic eventenddatedisplay;
  dynamic timezoneabbreviation;
  String siteurl = "";
  String progress = "";
  bool removelink = false;
  dynamic reschduleparentid;
  bool isbadcancellationenabled = false;
  String jwstartpage = "";
  bool isenrollfutureinstance = false;
  bool isviewreview = false;
  String certificateaction = "";
  dynamic qrcodeimagepath;
  dynamic qrimagename;
  dynamic viewprerequisitecontentstatus;
  String headerlocationname = "";

  factory Table2.fromJson(Map<String, dynamic> json) => Table2(
        filterid: json["filterid"],
        siteid: json["siteid"],
        usersiteid: json["usersiteid"],
        sitename: json["sitename"],
        objectid: json["objectid"],
        medianame: json["medianame"],
        description: json["description"],
        contenttype: json["contenttype"],
        iconpath: json["iconpath"],
        iscontent: json["iscontent"],
        contenttypethumbnail: json["contenttypethumbnail"],
        contentid: json["contentid"],
        name: json["name"],
        objecttypeid: json["objecttypeid"],
        language: json["language"],
        shortdescription: json["shortdescription"],
        version: json["version"],
        startpage: json["startpage"],
        createduserid: json["createduserid"],
        createddate: DateTime.parse(json["createddate"]),
        keywords: json["keywords"],
        downloadable: json["downloadable"],
        publisheddate: DateTime.parse(json["publisheddate"]),
        status: json["status"],
        cmsgroupid: json["cmsgroupid"],
        checkedoutto: json["checkedoutto"],
        longdescription: json["longdescription"],
        mediatypeid: json["mediatypeid"],
        owner: json["owner"],
        publicationdate: json["publicationdate"],
        activatedate: json["activatedate"],
        expirydate: json["expirydate"],
        thumbnailimagepath: json["thumbnailimagepath"],
        ecommbussinessrule: json["ecommbussinessrule"],
        downloadfile: json["downloadfile"],
        saleprice: json["saleprice"],
        listprice: json["listprice"],
        folderpath: json["folderpath"],
        skinid: json["skinid"],
        folderid: json["folderid"],
        modifieduserid: json["modifieduserid"],
        modifieddate: DateTime.parse(json["modifieddate"]),
        viewtype: json["viewtype"],
        windowproperties: json["windowproperties"],
        currency: json["currency"],
        certificateid: json["certificateid"],
        launchwindowmode: json["launchwindowmode"],
        active: json["active"],
        hardwaretype: json["hardwaretype"],
        enrollmentlimit: json["enrollmentlimit"],
        presenterurl: json["presenterurl"],
        participanturl: json["participanturl"],
        eventstartdatetime: json["eventstartdatetime"],
        eventenddatetime: json["eventenddatetime"],
        presenterid: json["presenterid"],
        contentstatus: json["contentstatus"],
        location: json["location"],
        conferencenumbers: json["conferencenumbers"],
        directionurl: json["directionurl"],
        eventpercentage: json["eventpercentage"],
        starttime: json["starttime"],
        duration: json["duration"],
        personalizediconid1: json["personalizediconid1"],
        personalizediconid2: json["personalizediconid2"],
        ciid: json["ciid"],
        noofusersenrolled: json["noofusersenrolled"],
        noofuserscompleted: json["noofuserscompleted"],
        eventkey: json["eventkey"],
        eventtype: json["eventtype"],
        devicetypeid: json["devicetypeid"],
        nvarchar2: json["nvarchar2"],
        nvarchar3: json["nvarchar3"],
        audience: json["audience"],
        backgroundcolor: json["backgroundcolor"],
        fontcolor: json["fontcolor"],
        searchreferencenumber: json["searchreferencenumber"],
        nvarchar4: json["nvarchar4"],
        timezone: json["timezone"],
        bit3: json["bit3"],
        bit4: json["bit4"],
        typeofevent: json["typeofevent"],
        webinartool: json["webinartool"],
        webinarpassword: json["webinarpassword"],
        bit5: json["bit5"],
        bit2: json["bit2"],
        seotitle: json["seotitle"],
        seometadescription: json["seometadescription"],
        seokeywords: json["seokeywords"],
        waitlistlimit: json["waitlistlimit"],
        totalattempts: json["totalattempts"],
        accessperiodtype: json["accessperiodtype"],
        itunesproductid: json["itunesproductid"],
        googleproductid: json["googleproductid"],
        decimal2: json["decimal2"],
        budgetprice: json["budgetprice"],
        budgetcurrency: json["budgetcurrency"],
        eventresourcedisplayoption: json["eventresourcedisplayoption"],
        certificatepercentage: json["certificatepercentage"],
        activityid: json["activityid"],
        eventscheduletype: json["eventscheduletype"],
        bigint4: json["bigint4"],
        offeringstartdate: json["offeringstartdate"],
        offeringenddate: json["offeringenddate"],
        contentauthordisplayname: json["contentauthordisplayname"],
        registrationurl: json["registrationurl"],
        videointroduction: json["videointroduction"],
        noofmodules: json["noofmodules"],
        learningobjectives: json["learningobjectives"],
        tableofcontent: json["tableofcontent"],
        tagname: json["tagname"],
        credittypes: json["credittypes"],
        eventcategories: json["eventcategories"],
        eventrecording: json["eventrecording"],
        recordingmsg: json["recordingmsg"],
        recordingcontentid: json["recordingcontentid"],
        recordingurl: json["recordingurl"],
        scoid: json["scoid"],
        startdate: DateTime.parse(json["startdate"]),
        datecompleted: DateTime.parse(json["datecompleted"]),
        accessednumber: json["accessednumber"],
        noofattempts: json["noofattempts"],
        totalsessiontime: json["totalsessiontime"],
        corechildren: json["corechildren"],
        coreentry: json["coreentry"],
        corelessonstatus: json["corelessonstatus"],
        corecredit: json["corecredit"],
        groupdisplayname: json["groupdisplayname"],
        groupdisplayorder: json["groupdisplayorder"],
        corelessonlocation: json["corelessonlocation"],
        scorechildren: json["scorechildren"],
        scoreraw: json["scoreraw"],
        scoremin: json["scoremin"],
        scoremax: json["scoremax"],
        launchdata: json["launchdata"],
        actualstatus: json["actualstatus"],
        userid: json["userid"],
        dateassigned: DateTime.parse(json["dateassigned"]),
        targetdate: json["targetdate"],
        ismandatory: json["ismandatory"],
        assignedby: json["assignedby"],
        assignedbyadmin: json["assignedbyadmin"],
        durationenddate: json["durationenddate"],
        usercontentstatus: json["usercontentstatus"],
        attemptsleft: json["attemptsleft"],
        accessperiod: json["accessperiod"],
        accessperiodunit: json["accessperiodunit"],
        isarchived: json["isarchived"],
        purchaseddate: json["purchaseddate"],
        joinurl: json["joinurl"],
        confirmationurl: json["confirmationurl"],
        hide: json["hide"],
        required: json["required"],
        schedulestatus: json["schedulestatus"],
        schedulereserveddatetime: json["schedulereserveddatetime"],
        percentcompleted: json["percentcompleted"],
        invitationurl: json["invitationurl"],
        link: json["link"],
        pareportlink: json["pareportlink"],
        dareportlink: json["dareportlink"],
        availableseats: json["availableseats"],
        waitlistenrolls: json["waitlistenrolls"],
        jwvideokey: json["jwvideokey"],
        cloudmediaplayerkey: json["cloudmediaplayerkey"],
        usercertificateid: json["usercertificateid"],
        relatedconentcount: json["relatedconentcount"],
        dtfcontent: json["dtfcontent"],
        ratingid: json["ratingid"].toDouble(),
        totalratings: json["totalratings"],
        certificatepage: json["certificatepage"],
        locationname: json["locationname"],
        buildingname: json["buildingname"],
        commentscount: json["commentscount"],
        authordisplayname: json["authordisplayname"],
        presenter: json["presenter"],
        isdownloaded: json["isdownloaded"],
        eventrecording1: json["eventrecording1"],
        recordingmsg1: json["recordingmsg1"],
        recordingcontentid1: json["recordingcontentid1"],
        recordingurl1: json["recordingurl1"],
        eventstartdatedisplay: json["eventstartdatedisplay"],
        eventenddatedisplay: json["eventenddatedisplay"],
        timezoneabbreviation: json["timezoneabbreviation"],
        siteurl: json["siteurl"],
        progress: json["progress"],
        removelink: json["removelink"],
        reschduleparentid: json["reschduleparentid"],
        isbadcancellationenabled: json["isbadcancellationenabled"],
        jwstartpage: json["jwstartpage"],
        isenrollfutureinstance: json["isenrollfutureinstance"],
        isviewreview: json["isviewreview"],
        certificateaction: json["certificateaction"],
        qrcodeimagepath: json["qrcodeimagepath"],
        qrimagename: json["qrimagename"],
        viewprerequisitecontentstatus: json["viewprerequisitecontentstatus"],
        headerlocationname: json["headerlocationname"],
      );

  Map<String, dynamic> toJson() => {
        "filterid": filterid,
        "siteid": siteid,
        "usersiteid": usersiteid,
        "sitename": sitename,
        "objectid": objectid,
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
        "status": status,
        "cmsgroupid": cmsgroupid,
        "checkedoutto": checkedoutto,
        "longdescription": longdescription,
        "mediatypeid": mediatypeid,
        "owner": owner,
        "publicationdate": publicationdate,
        "activatedate": activatedate,
        "expirydate": expirydate,
        "thumbnailimagepath": thumbnailimagepath,
        "ecommbussinessrule": ecommbussinessrule,
        "downloadfile": downloadfile,
        "saleprice": saleprice,
        "listprice": listprice,
        "folderpath": folderpath,
        "skinid": skinid,
        "folderid": folderid,
        "modifieduserid": modifieduserid,
        "modifieddate": modifieddate?.toIso8601String(),
        "viewtype": viewtype,
        "windowproperties": windowproperties,
        "currency": currency,
        "certificateid": certificateid,
        "launchwindowmode": launchwindowmode,
        "active": active,
        "hardwaretype": hardwaretype,
        "enrollmentlimit": enrollmentlimit,
        "presenterurl": presenterurl,
        "participanturl": participanturl,
        "eventstartdatetime": eventstartdatetime,
        "eventenddatetime": eventenddatetime,
        "presenterid": presenterid,
        "contentstatus": contentstatus,
        "location": location,
        "conferencenumbers": conferencenumbers,
        "directionurl": directionurl,
        "eventpercentage": eventpercentage,
        "starttime": starttime,
        "duration": duration,
        "personalizediconid1": personalizediconid1,
        "personalizediconid2": personalizediconid2,
        "ciid": ciid,
        "noofusersenrolled": noofusersenrolled,
        "noofuserscompleted": noofuserscompleted,
        "eventkey": eventkey,
        "eventtype": eventtype,
        "devicetypeid": devicetypeid,
        "nvarchar2": nvarchar2,
        "nvarchar3": nvarchar3,
        "audience": audience,
        "backgroundcolor": backgroundcolor,
        "fontcolor": fontcolor,
        "searchreferencenumber": searchreferencenumber,
        "nvarchar4": nvarchar4,
        "timezone": timezone,
        "bit3": bit3,
        "bit4": bit4,
        "typeofevent": typeofevent,
        "webinartool": webinartool,
        "webinarpassword": webinarpassword,
        "bit5": bit5,
        "bit2": bit2,
        "seotitle": seotitle,
        "seometadescription": seometadescription,
        "seokeywords": seokeywords,
        "waitlistlimit": waitlistlimit,
        "totalattempts": totalattempts,
        "accessperiodtype": accessperiodtype,
        "itunesproductid": itunesproductid,
        "googleproductid": googleproductid,
        "decimal2": decimal2,
        "budgetprice": budgetprice,
        "budgetcurrency": budgetcurrency,
        "eventresourcedisplayoption": eventresourcedisplayoption,
        "certificatepercentage": certificatepercentage,
        "activityid": activityid,
        "eventscheduletype": eventscheduletype,
        "bigint4": bigint4,
        "offeringstartdate": offeringstartdate,
        "offeringenddate": offeringenddate,
        "contentauthordisplayname": contentauthordisplayname,
        "registrationurl": registrationurl,
        "videointroduction": videointroduction,
        "noofmodules": noofmodules,
        "learningobjectives": learningobjectives,
        "tableofcontent": tableofcontent,
        "tagname": tagname,
        "credittypes": credittypes,
        "eventcategories": eventcategories,
        "eventrecording": eventrecording,
        "recordingmsg": recordingmsg,
        "recordingcontentid": recordingcontentid,
        "recordingurl": recordingurl,
        "scoid": scoid,
        "startdate": startdate?.toIso8601String(),
        "datecompleted": datecompleted?.toIso8601String(),
        "accessednumber": accessednumber,
        "noofattempts": noofattempts,
        "totalsessiontime": totalsessiontime,
        "corechildren": corechildren,
        "coreentry": coreentry,
        "corelessonstatus": corelessonstatus,
        "corecredit": corecredit,
        "groupdisplayname": groupdisplayname,
        "groupdisplayorder": groupdisplayorder,
        "corelessonlocation": corelessonlocation,
        "scorechildren": scorechildren,
        "scoreraw": scoreraw,
        "scoremin": scoremin,
        "scoremax": scoremax,
        "launchdata": launchdata,
        "actualstatus": actualstatus,
        "userid": userid,
        "dateassigned": dateassigned?.toIso8601String(),
        "targetdate": targetdate,
        "ismandatory": ismandatory,
        "assignedby": assignedby,
        "assignedbyadmin": assignedbyadmin,
        "durationenddate": durationenddate,
        "usercontentstatus": usercontentstatus,
        "attemptsleft": attemptsleft,
        "accessperiod": accessperiod,
        "accessperiodunit": accessperiodunit,
        "isarchived": isarchived,
        "purchaseddate": purchaseddate,
        "joinurl": joinurl,
        "confirmationurl": confirmationurl,
        "hide": hide,
        "required": required,
        "schedulestatus": schedulestatus,
        "schedulereserveddatetime": schedulereserveddatetime,
        "percentcompleted": percentcompleted,
        "invitationurl": invitationurl,
        "link": link,
        "pareportlink": pareportlink,
        "dareportlink": dareportlink,
        "availableseats": availableseats,
        "waitlistenrolls": waitlistenrolls,
        "jwvideokey": jwvideokey,
        "cloudmediaplayerkey": cloudmediaplayerkey,
        "usercertificateid": usercertificateid,
        "relatedconentcount": relatedconentcount,
        "dtfcontent": dtfcontent,
        "ratingid": ratingid,
        "totalratings": totalratings,
        "certificatepage": certificatepage,
        "locationname": locationname,
        "buildingname": buildingname,
        "commentscount": commentscount,
        "authordisplayname": authordisplayname,
        "presenter": presenter,
        "isdownloaded": isdownloaded,
        "eventrecording1": eventrecording1,
        "recordingmsg1": recordingmsg1,
        "recordingcontentid1": recordingcontentid1,
        "recordingurl1": recordingurl1,
        "eventstartdatedisplay": eventstartdatedisplay,
        "eventenddatedisplay": eventenddatedisplay,
        "timezoneabbreviation": timezoneabbreviation,
        "siteurl": siteurl,
        "progress": progress,
        "removelink": removelink,
        "reschduleparentid": reschduleparentid,
        "isbadcancellationenabled": isbadcancellationenabled,
        "jwstartpage": jwstartpage,
        "isenrollfutureinstance": isenrollfutureinstance,
        "isviewreview": isviewreview,
        "certificateaction": certificateaction,
        "qrcodeimagepath": qrcodeimagepath,
        "qrimagename": qrimagename,
        "viewprerequisitecontentstatus": viewprerequisitecontentstatus,
        "headerlocationname": headerlocationname,
      };
}
