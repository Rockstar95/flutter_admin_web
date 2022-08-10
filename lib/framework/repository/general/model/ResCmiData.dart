// To parse this JSON data, do
//
//     ResCmiData resCmiData = resCmiDataFromJson(jsonString);

import 'dart:convert';

ResCmiData resCmiDataFromJson(String str) =>
    ResCmiData.fromJson(json.decode(str));

String resCmiDataToJson(ResCmiData data) => json.encode(data.toJson());

class ResCmiData {
  ResCmiData({
    required this.cmi,
    required this.learnersession,
    required this.studentresponse,
  });

  List<Cmi> cmi = [];
  List<Learnersession> learnersession = [];
  List<Studentresponse> studentresponse = [];

  factory ResCmiData.fromJson(Map<String, dynamic> json) => ResCmiData(
        cmi: json["cmi"] == null
            ? []
            : List<Cmi>.from(json["cmi"].map((x) => Cmi.fromJson(x))),
        learnersession: json["learnersession"] == null
            ? []
            : List<Learnersession>.from(
                json["learnersession"].map((x) => Learnersession.fromJson(x))),
        studentresponse: json["studentresponse"] == null
            ? []
            : List<Studentresponse>.from(json["studentresponse"]
                .map((x) => Studentresponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cmi":
            cmi == null ? null : List<dynamic>.from(cmi.map((x) => x.toJson())),
        "learnersession": learnersession == null
            ? null
            : List<dynamic>.from(learnersession.map((x) => x.toJson())),
        "studentresponse": studentresponse == null
            ? null
            : List<dynamic>.from(studentresponse.map((x) => x.toJson())),
      };
}

class Cmi {
  Cmi({
    this.id = 0,
    this.userid = 0,
    this.scoid = 0,
    this.corechildren,
    this.coreentry,
    this.corecredit,
    this.corelessonstatus = "",
    this.corelessonlocation = "",
    this.scorechildren,
    this.scoreraw,
    this.scoremin,
    this.scoremax,
    this.launchdata,
    this.suspenddata = "",
    this.corelessonmode,
    this.updatedattempt,
    this.randomquestionnos,
    this.scorm2004Nextnav,
    this.textresponses,
    this.pooledquestionnos,
    this.trackprogress,
    this.entry = "",
    this.statusdisplayname = "",
    this.sequencenumber,
    this.totalsessiontime = "",
    this.datecompleted,
    this.noofattempts,
  });

  int id = 0;
  int userid = 0;
  int scoid = 0;
  dynamic corechildren;
  dynamic coreentry;
  dynamic corecredit;
  String corelessonstatus = "";
  String corelessonlocation = "";
  dynamic scorechildren;
  dynamic scoreraw;
  dynamic scoremin;
  dynamic scoremax;
  dynamic launchdata;
  String suspenddata = "";
  dynamic corelessonmode;
  dynamic updatedattempt;
  dynamic randomquestionnos;
  dynamic scorm2004Nextnav;
  dynamic textresponses;
  dynamic pooledquestionnos;
  dynamic trackprogress;
  String entry = "";
  String statusdisplayname;
  dynamic sequencenumber;
  String totalsessiontime = "";
  dynamic datecompleted;
  dynamic noofattempts;

  factory Cmi.fromJson(Map<String, dynamic> json) => Cmi(
        id: json["id"] ?? 0,
        userid: json["userid"] ?? 0,
        scoid: json["scoid"] ?? 0,
        corechildren: json["corechildren"],
        coreentry: json["coreentry"],
        corecredit: json["corecredit"],
        corelessonstatus: json["corelessonstatus"] ?? "",
        corelessonlocation: json["corelessonlocation"] ?? "",
        scorechildren: json["scorechildren"],
        scoreraw: json["scoreraw"],
        scoremin: json["scoremin"],
        scoremax: json["scoremax"],
        launchdata: json["launchdata"],
        suspenddata: json["suspenddata"] ?? "",
        corelessonmode: json["corelessonmode"],
        updatedattempt: json["updatedattempt"],
        randomquestionnos: json["randomquestionnos"],
        scorm2004Nextnav: json["scorm2004nextnav"],
        textresponses: json["textresponses"],
        pooledquestionnos: json["pooledquestionnos"],
        trackprogress: json["trackprogress"],
        entry: json["entry"] ?? "",
        statusdisplayname: json["statusdisplayname"] ?? "",
        sequencenumber: json["sequencenumber"],
        totalsessiontime: json["totalsessiontime"] ?? "",
        datecompleted: json["datecompleted"],
        noofattempts: json["noofattempts"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "userid": userid == null ? null : userid,
        "scoid": scoid == null ? null : scoid,
        "corechildren": corechildren,
        "coreentry": coreentry,
        "corecredit": corecredit,
        "corelessonstatus": corelessonstatus == null ? null : corelessonstatus,
        "corelessonlocation":
            corelessonlocation == null ? null : corelessonlocation,
        "scorechildren": scorechildren,
        "scoreraw": scoreraw,
        "scoremin": scoremin,
        "scoremax": scoremax,
        "launchdata": launchdata,
        "suspenddata": suspenddata == null ? null : suspenddata,
        "corelessonmode": corelessonmode,
        "updatedattempt": updatedattempt,
        "randomquestionnos": randomquestionnos,
        "scorm2004nextnav": scorm2004Nextnav,
        "textresponses": textresponses,
        "pooledquestionnos": pooledquestionnos,
        "trackprogress": trackprogress,
        "entry": entry == null ? null : entry,
        "statusdisplayname":
            statusdisplayname == null ? null : statusdisplayname,
        "sequencenumber": sequencenumber,
        "totalsessiontime": totalsessiontime == null ? null : totalsessiontime,
        "datecompleted": datecompleted,
        "noofattempts": noofattempts,
      };
}

class Learnersession {
  Learnersession({
    this.sessionid = 0,
    this.userid = 0,
    this.scoid = 0,
    this.attemptnumber = 0,
    this.sessiondatetime,
    this.timespent = "",
  });

  int sessionid = 0;
  int userid = 0;
  int scoid = 0;
  int attemptnumber = 0;
  DateTime? sessiondatetime;
  String timespent = "";

  factory Learnersession.fromJson(Map<String, dynamic> json) => Learnersession(
        sessionid: json["sessionid"] ?? 0,
        userid: json["userid"] ?? 0,
        scoid: json["scoid"] ?? 0,
        attemptnumber: json["attemptnumber"] ?? 0,
        sessiondatetime: json["sessiondatetime"] == null
            ? null
            : DateTime.parse(json["sessiondatetime"]),
        timespent: json["timespent"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "sessionid": sessionid == null ? null : sessionid,
        "userid": userid == null ? null : userid,
        "scoid": scoid == null ? null : scoid,
        "attemptnumber": attemptnumber == null ? null : attemptnumber,
        "sessiondatetime":
            sessiondatetime == null ? null : sessiondatetime?.toIso8601String(),
        "timespent": timespent == null ? null : timespent,
      };
}

class Studentresponse {
  Studentresponse({
    this.responseid = 0,
    this.userid = 0,
    this.scoid = 0,
    this.questionid = "",
    this.assessmentattempt = 0,
    this.questionattempt = 0,
    this.attemptdate,
    this.studentresponses = "",
    this.result = "",
    this.index = 0,
    this.isflaged,
    this.attachfilename,
    this.attachfileid,
    this.optionalnotes,
    this.capturedvidfilename,
    this.capturedvidid,
    this.capturedimgfilename,
    this.capturedimgid,
    this.starredquestions,
  });

  int responseid = 0;
  int userid = 0;
  int scoid = 0;
  String questionid = "";
  int assessmentattempt = 0;
  int questionattempt = 0;
  DateTime? attemptdate;
  String studentresponses = "";
  String result = "";
  int index = 0;
  dynamic isflaged;
  dynamic attachfilename;
  dynamic attachfileid;
  dynamic optionalnotes;
  dynamic capturedvidfilename;
  dynamic capturedvidid;
  dynamic capturedimgfilename;
  dynamic capturedimgid;
  dynamic starredquestions;

  factory Studentresponse.fromJson(Map<String, dynamic> json) =>
      Studentresponse(
        responseid: json["responseid"] ?? 0,
        userid: json["userid"] ?? 0,
        scoid: json["scoid"] ?? 0,
        questionid: json["questionid"] ?? "",
        assessmentattempt: json["assessmentattempt"] ?? 0,
        questionattempt: json["questionattempt"] ?? 0,
        attemptdate: json["attemptdate"] == null
            ? null
            : DateTime.parse(json["attemptdate"]),
        studentresponses: json["studentresponses"] ?? "",
        result: json["result"] ?? "",
        index: json["index"] ?? 0,
        isflaged: json["isflaged"],
        attachfilename: json["attachfilename"],
        attachfileid: json["attachfileid"],
        optionalnotes: json["optionalnotes"],
        capturedvidfilename: json["capturedvidfilename"],
        capturedvidid: json["capturedvidid"],
        capturedimgfilename: json["capturedimgfilename"],
        capturedimgid: json["capturedimgid"],
        starredquestions: json["starredquestions"],
      );

  Map<String, dynamic> toJson() => {
        "responseid": responseid == null ? null : responseid,
        "userid": userid == null ? null : userid,
        "scoid": scoid == null ? null : scoid,
        "questionid": questionid == null ? null : questionid,
        "assessmentattempt":
            assessmentattempt == null ? null : assessmentattempt,
        "questionattempt": questionattempt == null ? null : questionattempt,
        "attemptdate":
            attemptdate == null ? null : attemptdate?.toIso8601String(),
        "studentresponses": studentresponses == null ? null : studentresponses,
        "result": result == null ? null : result,
        "index": index == null ? null : index,
        "isflaged": isflaged,
        "attachfilename": attachfilename,
        "attachfileid": attachfileid,
        "optionalnotes": optionalnotes,
        "capturedvidfilename": capturedvidfilename,
        "capturedvidid": capturedvidid,
        "capturedimgfilename": capturedimgfilename,
        "capturedimgid": capturedimgid,
        "starredquestions": starredquestions,
      };
}
