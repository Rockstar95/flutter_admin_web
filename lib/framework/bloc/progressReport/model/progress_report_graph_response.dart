import 'dart:convert';
import 'dart:ui';
//import 'package:charts_flutter/flutter.dart' as charts;

List<ProgressReportGraphResponse> progressReportGraphResponseFromJson(String str) =>
    List<ProgressReportGraphResponse>.from(json.decode(str).map((x) => ProgressReportGraphResponse.fromJson(x)));

dynamic progressReportGraphResponseToJson(
        List<ProgressReportGraphResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProgressReportGraphResponse {
  int groupValue = 0;
  String groupText = "";
  List<ParentData> parentData = [];
  List<ContentCountData> contentCountData = [];
  List<StatusCountData> statusCountData = [];
  List<ScoreCount> scoreCount = [];
  List<ScoreMaxCount> scoreMaxCount = [];
  bool isExpanded = false;

  //List<Null> scoreCredit;

  ProgressReportGraphResponse(
      /*{this.groupValue,
        this.groupText,
        this.parentData,
        this.contentCountData,
        this.statusCountData,
        this.scoreCount,
        this.scoreMaxCount,
      this.isExpanded}*/
      );

  ProgressReportGraphResponse.fromJson(Map<String, dynamic> json) {
    groupValue = json['GroupValue'] ?? 0;
    groupText = json['GroupText'] ?? "";
    if (json['ParentData'] != null) {
      json['ParentData'].forEach((v) {
        parentData.add(new ParentData.fromJson(v));
      });
    }
    if (json['ContentCountData'] != null) {
      json['ContentCountData'].forEach((v) {
        contentCountData.add(new ContentCountData.fromJson(v));
      });
    }
    if (json['StatusCountData'] != null) {
      json['StatusCountData'].forEach((v) {
        statusCountData.add(new StatusCountData.fromJson(v));
      });
    }
    if (json['ScoreCount'] != null) {
      json['ScoreCount'].forEach((v) {
        scoreCount.add(new ScoreCount.fromJson(v));
      });
    }
    if (json['ScoreMaxCount'] != null) {
      json['ScoreMaxCount'].forEach((v) {
        scoreMaxCount.add(new ScoreMaxCount.fromJson(v));
      });
    }
    isExpanded = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupValue'] = this.groupValue;
    data['GroupText'] = this.groupText;
    if (this.parentData != null) {
      data['ParentData'] = this.parentData.map((v) => v.toJson()).toList();
    }
    if (this.contentCountData != null) {
      data['ContentCountData'] =
          this.contentCountData.map((v) => v.toJson()).toList();
    }
    if (this.statusCountData != null) {
      data['StatusCountData'] =
          this.statusCountData.map((v) => v.toJson()).toList();
    }
    if (this.scoreCount != null) {
      data['ScoreCount'] = this.scoreCount.map((v) => v.toJson()).toList();
    }
    if (this.scoreMaxCount != null) {
      data['ScoreMaxCount'] =
          this.scoreMaxCount.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class ParentData {
  int userid = 0;
  String orgname = "";
  String contenttitle = "";
  int objectTypeID = 0;
  String contenttype = "";
  String assignedOn = "";
  String targetDate = "";
  String status = "";
  String certificateAction = "";
  String datestarted = "";
  String parentID = "";
  String datecompleted = "";
  String seqid = "";
  int sCOID = 0;
  String objectID = "";
  String detailsLink = "";
  String gradedColor = "";
  String overallscore = "";
  List<ChildData> childData = [];
  String skillname = "";
  String categoryname = "";
  String jobrolename = "";
  int skillID = 0;
  int categoryID = 0;
  int jobrolID = 0;
  String credit = "";
  String maxvalue = "";
  String certificateid = "";
  int contentcount = 0;
  String content = "";
  int mediaTypeID = 0;
  String pAOrDAReportLink = "";
  String certificateTitle = "";
  bool isVisible = false;

  ParentData(
      /*{this.userid,
        this.orgname,
        this.contenttitle,
        this.objectTypeID,
        this.contenttype,
        this.assignedOn,
        this.targetDate,
        this.status,
        this.certificateAction,
        this.datestarted,
        this.parentID,
        this.datecompleted,
        this.seqid,
        this.sCOID,
        this.objectID,
        this.detailsLink,
        this.gradedColor,
        this.overallscore,
        this.childData,
        this.skillname,
        this.categoryname,
        this.jobrolename,
        this.skillID,
        this.categoryID,
        this.jobrolID,
        this.credit,
        this.maxvalue,
        this.certificateid,
        this.contentcount,
        this.content,
        this.mediaTypeID,
        this.pAOrDAReportLink,
        this.certificateTitle,
      this.isVisible}*/
      );

  ParentData.fromJson(Map<String, dynamic> json) {
    userid = json['userid'] ?? 0;
    orgname = json['orgname'] ?? "";
    contenttitle = json['contenttitle'] ?? "";
    objectTypeID = json['ObjectTypeID'] ?? 0;
    contenttype = json['contenttype'] ?? "";
    assignedOn = json['AssignedOn'] ?? "";
    targetDate = json['TargetDate'] ?? "";
    status = json['Status'] ?? "";
    certificateAction = json['CertificateAction'] ?? "";
    datestarted = json['datestarted'] ?? "";
    parentID = json['ParentID'] ?? "";
    datecompleted = json['datecompleted'] ?? "";
    seqid = json['seqid'] ?? "";
    sCOID = json['SCOID'] ?? 0;
    objectID = json['ObjectID'] ?? "";
    detailsLink = json['DetailsLink'] ?? "";
    gradedColor = json['GradedColor'] ?? "";
    overallscore = json['overallscore'] ?? "";
    if (json['ChildData'] != null) {
      json['ChildData'].forEach((v) {
        childData.add(new ChildData.fromJson(v));
      });
    }
    skillname = json['skillname'] ?? "";
    categoryname = json['categoryname'] ?? "";
    jobrolename = json['jobrolename'] ?? "";
    skillID = json['skillID'] ?? 0;
    categoryID = json['categoryID'] ?? 0;
    jobrolID = json['jobrolID'] ?? 0;
    credit = json['Credit'] ?? "";
    maxvalue = json['Maxvalue'] ?? "";
    certificateid = json['certificateid'] ?? "";
    contentcount = json['contentcount'] ?? 0;
    content = json['content'] ?? "";
    mediaTypeID = json['MediaTypeID'] ?? 0;
    pAOrDAReportLink = json['PAOrDAReportLink'] ?? "";
    certificateTitle = json['CertificateTitle'] ?? "";
    isVisible = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['orgname'] = this.orgname;
    data['contenttitle'] = this.contenttitle;
    data['ObjectTypeID'] = this.objectTypeID;
    data['contenttype'] = this.contenttype;
    data['AssignedOn'] = this.assignedOn;
    data['TargetDate'] = this.targetDate;
    data['Status'] = this.status;
    data['CertificateAction'] = this.certificateAction;
    data['datestarted'] = this.datestarted;
    data['ParentID'] = this.parentID;
    data['datecompleted'] = this.datecompleted;
    data['seqid'] = this.seqid;
    data['SCOID'] = this.sCOID;
    data['ObjectID'] = this.objectID;
    data['DetailsLink'] = this.detailsLink;
    data['GradedColor'] = this.gradedColor;
    data['overallscore'] = this.overallscore;
    if (this.childData != null) {
      data['ChildData'] = this.childData.map((v) => v.toJson()).toList();
    }
    data['skillname'] = this.skillname;
    data['categoryname'] = this.categoryname;
    data['jobrolename'] = this.jobrolename;
    data['skillID'] = this.skillID;
    data['categoryID'] = this.categoryID;
    data['jobrolID'] = this.jobrolID;
    data['Credit'] = this.credit;
    data['Maxvalue'] = this.maxvalue;
    data['certificateid'] = this.certificateid;
    data['contentcount'] = this.contentcount;
    data['content'] = this.content;
    data['MediaTypeID'] = this.mediaTypeID;
    data['PAOrDAReportLink'] = this.pAOrDAReportLink;
    data['CertificateTitle'] = this.certificateTitle;
    return data;
  }
}

class ChildData {
  int userid = 0;
  String orgname = "";
  String contenttitle = "";
  int objectTypeID = 0;
  String contenttype = "";
  String assignedOn = "";
  String targetDate = "";
  String status = "";
  String certificateAction = "";
  String datestarted = "";
  String parentID = "";
  String datecompleted = "";
  String seqid = "";
  int sCOID = 0;
  String objectID = "";
  String detailsLink = "";
  String gradedColor = "";
  String overallscore = "";
  String childData = "";
  String skillname = "";
  String categoryname = "";
  String jobrolename = "";
  int skillID = 0;
  int categoryID = 0;
  int jobrolID = 0;
  String credit = "";
  String maxvalue = "";
  String certificateid = "";
  String contentcount = "";
  String content = "";
  int mediaTypeID = 0;
  String pAOrDAReportLink = "";
  String certificateTitle = "";

  ChildData(
      /*{this.userid,
        this.orgname,
        this.contenttitle,
        this.objectTypeID,
        this.contenttype,
        this.assignedOn,
        this.targetDate,
        this.status,
        this.certificateAction,
        this.datestarted,
        this.parentID,
        this.datecompleted,
        this.seqid,
        this.sCOID,
        this.objectID,
        this.detailsLink,
        this.gradedColor,
        this.overallscore,
        this.childData,
        this.skillname,
        this.categoryname,
        this.jobrolename,
        this.skillID,
        this.categoryID,
        this.jobrolID,
        this.credit,
        this.maxvalue,
        this.certificateid,
        this.contentcount,
        this.content,
        this.mediaTypeID,
        this.pAOrDAReportLink,
        this.certificateTitle}*/
      );

  ChildData.fromJson(Map<String, dynamic> json) {
    userid = json['userid'] ?? 0;
    orgname = json['orgname'] ?? "";
    contenttitle = json['contenttitle'] ?? "";
    objectTypeID = json['ObjectTypeID'] ?? 0;
    contenttype = json['contenttype'] ?? "";
    assignedOn = json['AssignedOn'] ?? "";
    targetDate = json['TargetDate'] ?? "";
    status = json['Status'] ?? "";
    certificateAction = json['CertificateAction'] ?? "";
    datestarted = json['datestarted'] ?? "";
    parentID = json['ParentID'] ?? "";
    datecompleted = json['datecompleted'] ?? "";
    seqid = json['seqid'] ?? "";
    sCOID = json['SCOID'] ?? 0;
    objectID = json['ObjectID'] ?? "";
    detailsLink = json['DetailsLink'] ?? "";
    gradedColor = json['GradedColor'] ?? "";
    overallscore = json['overallscore'] ?? "";
    childData = json['ChildData'] ?? "";
    skillname = json['skillname'] ?? "";
    categoryname = json['categoryname'] ?? "";
    jobrolename = json['jobrolename'] ?? "";
    skillID = json['skillID'] ?? 0;
    categoryID = json['categoryID'] ?? 0;
    jobrolID = json['jobrolID'] ?? 0;
    credit = json['Credit'] ?? "";
    maxvalue = json['Maxvalue'] ?? "";
    certificateid = json['certificateid'] ?? "";
    contentcount = json['contentcount'] ?? "";
    content = json['content'] ?? "";
    mediaTypeID = json['MediaTypeID'] ?? 0;
    pAOrDAReportLink = json['PAOrDAReportLink'] ?? "";
    certificateTitle = json['CertificateTitle'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['orgname'] = this.orgname;
    data['contenttitle'] = this.contenttitle;
    data['ObjectTypeID'] = this.objectTypeID;
    data['contenttype'] = this.contenttype;
    data['AssignedOn'] = this.assignedOn;
    data['TargetDate'] = this.targetDate;
    data['Status'] = this.status;
    data['CertificateAction'] = this.certificateAction;
    data['datestarted'] = this.datestarted;
    data['ParentID'] = this.parentID;
    data['datecompleted'] = this.datecompleted;
    data['seqid'] = this.seqid;
    data['SCOID'] = this.sCOID;
    data['ObjectID'] = this.objectID;
    data['DetailsLink'] = this.detailsLink;
    data['GradedColor'] = this.gradedColor;
    data['overallscore'] = this.overallscore;
    data['ChildData'] = this.childData;
    data['skillname'] = this.skillname;
    data['categoryname'] = this.categoryname;
    data['jobrolename'] = this.jobrolename;
    data['skillID'] = this.skillID;
    data['categoryID'] = this.categoryID;
    data['jobrolID'] = this.jobrolID;
    data['Credit'] = this.credit;
    data['Maxvalue'] = this.maxvalue;
    data['certificateid'] = this.certificateid;
    data['contentcount'] = this.contentcount;
    data['content'] = this.content;
    data['MediaTypeID'] = this.mediaTypeID;
    data['PAOrDAReportLink'] = this.pAOrDAReportLink;
    data['CertificateTitle'] = this.certificateTitle;
    return data;
  }
}

class ContentCountData {
  int contentCount = 0;
  String contentType = "";
  Color? color;

  ContentCountData(
      {this.contentCount = 0, this.contentType = "", required this.color});

  ContentCountData.fromJson(Map<String, dynamic> json) {
    contentCount = json['ContentCount'] ?? 0;
    contentType = json['ContentType'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContentCount'] = this.contentCount;
    data['ContentType'] = this.contentType;
    return data;
  }
}

class StatusCountData {
  String status = "";
  int contentCount = 0;
  Color? color;

  StatusCountData({this.status = "", this.contentCount = 0, this.color});

  StatusCountData.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    contentCount = json['ContentCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['ContentCount'] = this.contentCount;
    return data;
  }
}

class ScoreCount {
  int overallscore = 0;

  ScoreCount({this.overallscore = 0});

  ScoreCount.fromJson(Map<String, dynamic> json) {
    overallscore = json['overallscore'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['overallscore'] = this.overallscore;
    return data;
  }
}

class ScoreMaxCount {
  int scoreMax = 0;

  ScoreMaxCount({this.scoreMax = 0});

  ScoreMaxCount.fromJson(Map<String, dynamic> json) {
    scoreMax = json['ScoreMax'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScoreMax'] = this.scoreMax;
    return data;
  }
}
