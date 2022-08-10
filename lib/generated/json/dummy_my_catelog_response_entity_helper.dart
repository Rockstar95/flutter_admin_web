import 'package:flutter_admin_web/framework/bloc/mylearning/model/DummyMyLearnPlusCatelgoResponse.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';

dummyMyCatelogResponseEntityFromJson(DummyMyCatelogResponseEntity data, Map<String, dynamic> json) {
  if (json['table'] != null) {
    data.table = [];
    (json['table'] as List).forEach((v) {
      data.table.add(new DummyMyCatelogResponseTable().fromJson(Map.castFrom<dynamic, dynamic, String, dynamic>(v ?? {})));
    });
  }
  if (json['table2'] != null) {
    data.table2 = [];
    (json['table2'] as List).forEach((v) {
      data.table2.add(new DummyMyCatelogResponseTable2().fromJson(Map.castFrom<dynamic, dynamic, String, dynamic>(v ?? {})));
    });
  }
  return data;
}

dummyMyLearningplusResponseEntityFromJson(
    DummyMyLearnPlusResponseEntity data, Map<String, dynamic> json) {
  // if (json['CourseCount'] != null) {
  //   data.CourseList2 = new List<DummyMyLearnPlusResponseTable>();
  //   (json['CourseCount'] as List).forEach((v) {
  //     data.CourseList2.add(new DummyMyLearnPlusResponseTable().fromJson(v));
  //   });
  // }

  if (json['CourseList'] != null) {
    data.CourseList = [];
    (json['CourseList'] as List).forEach((v) {
      //DummyMyLearnPlusCatelgoResponse ds = v;
      data.CourseList.add(new DummyMyLearnPlusCatelgoResponse().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> dummyMyCatelogResponseEntityToJson(
    DummyMyCatelogResponseEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.table != null) {
    data['Table'] = entity.table.map((v) => v.toJson()).toList();
  }
  if (entity.table2 != null) {
    data['Table2'] = entity.table2.map((v) => v.toJson()).toList();
  }
  return data;
}

dummyMyCatelogResponseTableFromJson(
    DummyMyCatelogResponseTable data, Map<String, dynamic> json) {
  if (json['totalrecordscount'] != null) {
    data.totalrecordscount = json['totalrecordscount']?.toInt();
  }
  return data;
}

Map<String, dynamic> dummyMyCatelogResponseTableToJson(
    DummyMyCatelogResponseTable entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['totalrecordscount'] = entity.totalrecordscount;
  return data;
}

dummyMyCatelogResponseTable2FromJson(
    DummyMyCatelogResponseTable2 data, Map<String, dynamic> json) {
  if (json['filterid'] != null) {
    data.filterid = json['filterid']?.toInt();
  }
  if (json['siteid'] != null) {
    data.siteid = json['siteid']?.toInt();
  }
  if (json['usersiteid'] != null) {
    data.usersiteid = json['usersiteid']?.toInt();
  }
  if (json['sitename'] != null) {
    data.sitename = json['sitename']?.toString() ?? "";
  }
  if (json['objectid'] != null) {
    data.objectid = json['objectid']?.toString() ?? "";
  }
  if (json['medianame'] != null) {
    data.medianame = json['medianame']?.toString() ?? "";
  }
  if (json['description'] != null) {
    data.description = json['description']?.toString() ?? "";
  }
  if (json['contenttype'] != null) {
    data.contenttype = json['contenttype']?.toString() ?? "";
  }
  if (json['iconpath'] != null) {
    data.iconpath = "Content/SiteFiles/ContentTypeIcons/" +
        (json['iconpath']?.toString() ?? "");
  } else {
    data.iconpath = "";
  }
  if (json['iscontent'] != null) {
    data.iscontent = json['iscontent'];
  }
  if (json['contenttypethumbnail'] != null) {
    data.contenttypethumbnail = "Content/SiteFiles/ContentTypeIcons/" +
        (json['contenttypethumbnail']?.toString() ?? "");
  } else {
    data.iconpath = "";
  }
  if (json['contentid'] != null) {
    data.contentid = json['contentid']?.toString() ?? "";
  }
  if (json['name'] != null) {
    data.name = json['name']?.toString() ?? "";
  }
  if (json['objecttypeid'] != null) {
    data.objecttypeid = json['objecttypeid']?.toInt();
  }
  if (json['language'] != null) {
    data.language = json['language']?.toString() ?? "";
  }
  if (json['shortdescription'] != null) {
    data.shortdescription = json['shortdescription']?.toString() ?? "";
  }
  if (json['version'] != null) {
    data.version = json['version'];
  }
  if (json['startpage'] != null) {
    data.startpage = json['startpage']?.toString() ?? "";
  }
  if (json['createduserid'] != null) {
    data.createduserid = json['createduserid']?.toInt() ?? 0;
  }
  if (json['createddate'] != null) {
    data.createddate = json['createddate']?.toString() ?? "";
  }
  if (json['keywords'] != null) {
    data.keywords = json['keywords']?.toString() ?? "";
  }
  if (json['downloadable'] != null) {
    data.downloadable = json['downloadable'];
  }
  if (json['publisheddate'] != null) {
    data.publisheddate = json['publisheddate']?.toString() ?? "";
  }
  if (json['status'] != null) {
    data.status = json['status']?.toString() ?? "";
  }
  if (json['cmsgroupid'] != null) {
    data.cmsgroupid = json['cmsgroupid']?.toInt() ?? 0;
  }
  if (json['checkedoutto'] != null) {
    data.checkedoutto = json['checkedoutto'];
  }
  if (json['longdescription'] != null) {
    data.longdescription = json['longdescription']?.toString() ?? "";
  }
  if (json['mediatypeid'] != null) {
    data.mediatypeid = json['mediatypeid'];
  }
  if (json['owner'] != null) {
    data.owner = json['owner'];
  }
  if (json['publicationdate'] != null) {
    data.publicationdate = json['publicationdate'];
  }
  if (json['activatedate'] != null) {
    data.activatedate = json['activatedate'];
  }
  if (json['expirydate'] != null) {
    data.expirydate = json['expirydate'];
  }
  if (json['thumbnailimagepath'] != null) {
    data.thumbnailimagepath = json['thumbnailimagepath']?.toString() ?? "";
  }
  if (json['ecommbussinessrule'] != null) {
    data.ecommbussinessrule = json['ecommbussinessrule']?.toInt() ?? 0;
  }
  if (json['downloadfile'] != null) {
    data.downloadfile = json['downloadfile'];
  }
  if (json['saleprice'] != null) {
    data.saleprice = json['saleprice'];
  }
  if (json['listprice'] != null) {
    data.listprice = json['listprice'];
  }
  if (json['folderpath'] != null) {
    data.folderpath = json['folderpath']?.toString() ?? "";
  }
  if (json['skinid'] != null) {
    data.skinid = json['skinid'];
  }
  if (json['folderid'] != null) {
    data.folderid = json['folderid'];
  }
  if (json['modifieduserid'] != null) {
    data.modifieduserid = json['modifieduserid']?.toInt() ?? 0;
  }
  if (json['modifieddate'] != null) {
    data.modifieddate = json['modifieddate']?.toString() ?? "";
  }
  if (json['viewtype'] != null) {
    data.viewtype = json['viewtype']?.toInt();
  }
  if (json['windowproperties'] != null) {
    data.windowproperties = json['windowproperties']?.toString() ?? "";
  }
  if (json['currency'] != null) {
    data.currency = json['currency'];
  }
  if (json['certificateid'] != null) {
    data.certificateid = json['certificateid']?.toString() ?? "";
  }
  if (json['launchwindowmode'] != null) {
    data.launchwindowmode = json['launchwindowmode'];
  }
  if (json['active'] != null) {
    data.active = json['active'];
  }
  if (json['hardwaretype'] != null) {
    data.hardwaretype = json['hardwaretype'];
  }
  if (json['enrollmentlimit'] != null) {
    data.enrollmentlimit = json['enrollmentlimit'];
  }
  if (json['presenterurl'] != null) {
    data.presenterurl = json['presenterurl'];
  }
  if (json['participanturl'] != null) {
    data.participanturl = json['participanturl'];
  }
  if (json['eventstartdatetime'] != null) {
    data.eventstartdatetime = json['eventstartdatetime'];
  }
  if (json['eventenddatetime'] != null) {
    data.eventenddatetime = json['eventenddatetime'];
  }
  if (json['presenterid'] != null) {
    data.presenterid = json['presenterid'];
  }
  if (json['contentstatus'] != null) {
    data.contentstatus = json['contentstatus'];
  }
  if (json['location'] != null) {
    data.location = json['location'];
  }
  if (json['conferencenumbers'] != null) {
    data.conferencenumbers = json['conferencenumbers'];
  }
  if (json['directionurl'] != null) {
    data.directionurl = json['directionurl'];
  }
  if (json['eventpercentage'] != null) {
    data.eventpercentage = json['eventpercentage']?.toString() ?? "";
  }
  if (json['starttime'] != null) {
    data.starttime = json['starttime'];
  }
  if (json['duration'] != null) {
    data.duration = json['duration'];
  }
  if (json['personalizediconid1'] != null) {
    data.personalizediconid1 = json['personalizediconid1'];
  }
  if (json['personalizediconid2'] != null) {
    data.personalizediconid2 = json['personalizediconid2'];
  }
  if (json['ciid'] != null) {
    data.ciid = json['ciid']?.toInt();
  }
  if (json['noofusersenrolled'] != null) {
    data.noofusersenrolled = json['noofusersenrolled']?.toInt();
  }
  if (json['noofuserscompleted'] != null) {
    data.noofuserscompleted = json['noofuserscompleted']?.toInt();
  }
  if (json['eventkey'] != null) {
    data.eventkey = json['eventkey'];
  }
  if (json['eventtype'] != null) {
    data.eventtype = json['eventtype']?.toInt();
  }
  if (json['devicetypeid'] != null) {
    data.devicetypeid = json['devicetypeid']?.toInt();
  }
  if (json['nvarchar2'] != null) {
    data.nvarchar2 = json['nvarchar2'];
  }
  if (json['nvarchar3'] != null) {
    data.nvarchar3 = json['nvarchar3'];
  }
  if (json['audience'] != null) {
    data.audience = json['audience'];
  }
  if (json['backgroundcolor'] != null) {
    data.backgroundcolor = json['backgroundcolor']?.toString() ?? "";
  }
  if (json['fontcolor'] != null) {
    data.fontcolor = json['fontcolor']?.toString() ?? "";
  }
  if (json['searchreferencenumber'] != null) {
    data.searchreferencenumber = json['searchreferencenumber'];
  }
  if (json['nvarchar4'] != null) {
    data.nvarchar4 = json['nvarchar4'];
  }
  if (json['timezone'] != null) {
    data.timezone = json['timezone'];
  }
  if (json['bit3'] != null) {
    data.bit3 = json['bit3'];
  } else {
    data.bit3 = false;
  }

  if (json['bit4'] != null) {
    data.bit4 = json['bit4'];
  } else {
    data.bit4 = false;
  }

  if (json['typeofevent'] != null) {
    data.typeofevent = json['typeofevent']?.toInt();
  }
  if (json['webinartool'] != null) {
    data.webinartool = json['webinartool']?.toInt();
  }
  if (json['webinarpassword'] != null) {
    data.webinarpassword = json['webinarpassword'];
  }
  if (json['bit5'] != null) {
    data.bit5 = json['bit5'];
  } else {
    data.bit5 = false;
  }
  if (json['bit2'] != null) {
    data.bit2 = json['bit2'];
  } else {
    data.bit2 = false;
  }

  if (json['seotitle'] != null) {
    data.seotitle = json['seotitle'];
  }
  if (json['seometadescription'] != null) {
    data.seometadescription = json['seometadescription'];
  }
  if (json['seokeywords'] != null) {
    data.seokeywords = json['seokeywords'];
  }
  if (json['waitlistlimit'] != null) {
    data.waitlistlimit = json['waitlistlimit'];
  }
  if (json['totalattempts'] != null) {
    data.totalattempts = json['totalattempts']?.toInt();
  }
  if (json['accessperiodtype'] != null) {
    data.accessperiodtype = json['accessperiodtype']?.toInt();
  }
  if (json['itunesproductid'] != null) {
    data.itunesproductid = json['itunesproductid'];
  }
  if (json['googleproductid'] != null) {
    data.googleproductid = json['googleproductid'];
  }
  if (json['decimal2'] != null) {
    data.decimal2 = json['decimal2'];
  }
  if (json['budgetprice'] != null) {
    data.budgetprice = json['budgetprice'];
  }
  if (json['budgetcurrency'] != null) {
    data.budgetcurrency = json['budgetcurrency'];
  }
  if (json['eventresourcedisplayoption'] != null) {
    data.eventresourcedisplayoption = json['eventresourcedisplayoption'];
  }
  if (json['certificatepercentage'] != null) {
    data.certificatepercentage =
        json['certificatepercentage']?.toString() ?? "";
  }
  if (json['activityid'] != null) {
    data.activityid = json['activityid']?.toString() ?? "";
  }
  if (json['eventscheduletype'] != null) {
    data.eventscheduletype = json['eventscheduletype']?.toInt();
  }
  if (json['bigint4'] != null) {
    data.bigint4 = json['bigint4'];
  }
  if (json['offeringstartdate'] != null) {
    data.offeringstartdate = json['offeringstartdate'];
  }
  if (json['offeringenddate'] != null) {
    data.offeringenddate = json['offeringenddate'];
  }
  if (json['contentauthordisplayname'] != null) {
    data.contentauthordisplayname =
        json['contentauthordisplayname']?.toString() ?? "";
  }
  if (json['registrationurl'] != null) {
    data.registrationurl = json['registrationurl'];
  }
  if (json['videointroduction'] != null) {
    data.videointroduction = json['videointroduction'];
  }
  if (json['noofmodules'] != null) {
    data.noofmodules = json['noofmodules'];
  }
  if (json['learningobjectives'] != null) {
    data.learningobjectives = json['learningobjectives'];
  }
  if (json['tableofcontent'] != null) {
    data.tableofcontent = json['tableofcontent'];
  }
  if (json['tagname'] != null) {
    data.tagname = json['tagname'];
  }
  if (json['credittypes'] != null) {
    data.credittypes = json['credittypes'];
  }
  if (json['eventcategories'] != null) {
    data.eventcategories = json['eventcategories'];
  }
  if (json['eventrecording'] != null) {
    data.eventrecording = json['eventrecording'];
  }
  if (json['recordingmsg'] != null) {
    data.recordingmsg = json['recordingmsg'];
  }
  if (json['recordingcontentid'] != null) {
    data.recordingcontentid = json['recordingcontentid'];
  }
  if (json['recordingurl'] != null) {
    data.recordingurl = json['recordingurl']?.toString() ?? "";
  }
  if (json['scoid'] != null) {
    data.scoid = json['scoid']?.toInt();
  }
  if (json['startdate'] != null) {
    data.startdate = json['startdate']?.toString() ?? "";
  }
  if (json['datecompleted'] != null) {
    data.datecompleted = json['datecompleted']?.toString() ?? "";
  }
  if (json['accessednumber'] != null) {
    data.accessednumber = json['accessednumber']?.toInt();
  }
  if (json['noofattempts'] != null) {
    data.noofattempts = json['noofattempts']?.toInt();
  }
  if (json['totalsessiontime'] != null) {
    data.totalsessiontime = json['totalsessiontime']?.toString() ?? "";
  }
  if (json['corechildren'] != null) {
    data.corechildren = json['corechildren'];
  }
  if (json['coreentry'] != null) {
    data.coreentry = json['coreentry'];
  }
  if (json['corelessonstatus'] != null) {
    data.corelessonstatus = json['corelessonstatus']?.toString() ?? "";
  }
  if (json['corecredit'] != null) {
    data.corecredit = json['corecredit'];
  }
  if (json['groupdisplayname'] != null) {
    data.groupdisplayname = json['groupdisplayname']?.toString() ?? "";
  }
  if (json['groupdisplayorder'] != null) {
    data.groupdisplayorder = json['groupdisplayorder']?.toInt();
  }
  if (json['corelessonlocation'] != null) {
    data.corelessonlocation = json['corelessonlocation']?.toString() ?? "";
  }
  if (json['scorechildren'] != null) {
    data.scorechildren = json['scorechildren'];
  }
  if (json['scoreraw'] != null) {
    data.scoreraw = json['scoreraw']?.toInt();
  }
  if (json['scoremin'] != null) {
    data.scoremin = json['scoremin'];
  }
  if (json['scoremax'] != null) {
    data.scoremax = json['scoremax'];
  }
  if (json['launchdata'] != null) {
    data.launchdata = json['launchdata'];
  }
  if (json['actualstatus'] != null) {
    data.actualstatus = json['actualstatus']?.toString() ?? "";
  }
  if (json['userid'] != null) {
    data.userid = json['userid'];
  }
  if (json['dateassigned'] != null) {
    data.dateassigned = json['dateassigned']?.toString() ?? "";
  }
  if (json['targetdate'] != null) {
    data.targetdate = json['targetdate'];
  }
  if (json['ismandatory'] != null) {
    data.ismandatory = json['ismandatory'];
  }
  if (json['assignedby'] != null) {
    data.assignedby = json['assignedby']?.toInt();
  }
  if (json['assignedbyadmin'] != null) {
    data.assignedbyadmin = json['assignedbyadmin'];
  }
  if (json['durationenddate'] != null) {
    data.durationenddate = json['durationenddate'];
  }
  if (json['usercontentstatus'] != null) {
    data.usercontentstatus = json['usercontentstatus'];
  }
  if (json['attemptsleft'] != null) {
    data.attemptsleft = json['attemptsleft'];
  }
  if (json['accessperiod'] != null) {
    data.accessperiod = json['accessperiod'];
  }
  if (json['accessperiodunit'] != null) {
    data.accessperiodunit = json['accessperiodunit']?.toInt();
  }
  if (json['isarchived'] != null) {
    data.isarchived = json['isarchived'];
  }
  if (json['purchaseddate'] != null) {
    data.purchaseddate = json['purchaseddate'];
  }
  if (json['joinurl'] != null) {
    data.joinurl = json['joinurl'];
  }
  if (json['confirmationurl'] != null) {
    data.confirmationurl = json['confirmationurl'];
  }
  if (json['hide'] != null) {
    data.xHide = json['hide']?.toInt();
  }
  if (json['required'] != null) {
    data.required = json['required']?.toInt();
  }
  if (json['schedulestatus'] != null) {
    data.schedulestatus = json['schedulestatus']?.toInt();
  }
  if (json['schedulereserveddatetime'] != null) {
    data.schedulereserveddatetime = json['schedulereserveddatetime'];
  }
  if (json['percentcompleted'] != null) {
    data.percentcompleted = json['percentcompleted']?.toString() ?? "";
  }
  if (json['invitationurl'] != null) {
    data.invitationurl = json['invitationurl'];
  }
  if (json['link'] != null) {
    data.link = json['link'];
  }
  if (json['pareportlink'] != null) {
    data.pareportlink = json['pareportlink'];
  }
  if (json['dareportlink'] != null) {
    data.dareportlink = json['dareportlink'];
  }
  if (json['availableseats'] != null) {
    data.availableseats = json['availableseats'];
  }
  if (json['waitlistenrolls'] != null) {
    data.waitlistenrolls = json['waitlistenrolls']?.toInt();
  }
  if (json['jwvideokey'] != null) {
    data.jwvideokey = json['jwvideokey'];
  }
  if (json['cloudmediaplayerkey'] != null) {
    data.cloudmediaplayerkey = json['cloudmediaplayerkey'];
  }
  if (json['usercertificateid'] != null) {
    data.usercertificateid = json['usercertificateid']?.toString() ?? "";
  }
  if (json['relatedconentcount'] != null) {
    data.relatedconentcount = json['relatedconentcount']?.toInt();
  }
  if (json['dtfcontent'] != null) {
    data.dtfcontent = json['dtfcontent'];
  }
  if (json['ratingid'] != null) {
    data.ratingid = json['ratingid']?.toDouble();
  }
  if (json['totalratings'] != null) {
    data.totalratings = json['totalratings']?.toInt();
  }
  if (json['certificatepage'] != null) {
    data.certificatepage = json['certificatepage']?.toString() ?? "";
  }
  if (json['locationname'] != null) {
    data.locationname = json['locationname']?.toString() ?? "";
  }
  if (json['buildingname'] != null) {
    data.buildingname = json['buildingname']?.toString() ?? "";
  }
  if (json['commentscount'] != null) {
    data.commentscount = json['commentscount']?.toInt();
  }
  if (json['authordisplayname'] != null) {
    data.authordisplayname = json['authordisplayname']?.toString() ?? "";
  }
  if (json['presenter'] != null) {
    data.presenter = json['presenter'];
  }
  if (json['isdownloaded'] != null) {
    data.isdownloaded = json['isdownloaded'];
  } else {
    data.isdownloaded = false;
  }
  if (json['eventrecording1'] != null) {
    data.eventrecording1 = json['eventrecording1'];
  }
  if (json['recordingmsg1'] != null) {
    data.recordingmsg1 = json['recordingmsg1'];
  }
  if (json['recordingcontentid1'] != null) {
    data.recordingcontentid1 = json['recordingcontentid1'];
  }
  if (json['recordingurl1'] != null) {
    data.recordingurl1 = json['recordingurl1']?.toString() ?? "";
  }
  if (json['eventstartdatedisplay'] != null) {
    data.eventstartdatedisplay = json['eventstartdatedisplay'];
  }
  if (json['eventenddatedisplay'] != null) {
    data.eventenddatedisplay = json['eventenddatedisplay'];
  }
  if (json['timezoneabbreviation'] != null) {
    data.timezoneabbreviation = json['timezoneabbreviation'];
  }
  if (json['siteurl'] != null) {
    data.siteurl = json['siteurl']?.toString() ?? "";
  }
  if (json['progress'] != null) {
    data.progress = json['progress']?.toString() ?? "";
  }
  if (json['removelink'] != null) {
    data.removelink = json['removelink'];
  }
  if (json['reschduleparentid'] != null) {
    data.reschduleparentid = json['reschduleparentid'];
  }
  if (json['isbadcancellationenabled'] != null) {
    data.isbadcancellationenabled = json['isbadcancellationenabled'];
  }
  if (json['jwstartpage'] != null) {
    data.jwstartpage = json['jwstartpage']?.toString() ?? "";
  }
  if (json['isenrollfutureinstance'] != null) {
    data.isenrollfutureinstance = json['isenrollfutureinstance'];
  }
  if (json['isviewreview'] != null) {
    data.isviewreview = json['isviewreview'];
  }
  if (json['certificateaction'] != null) {
    data.certificateaction = json['certificateaction']?.toString() ?? "";
  }
  if (json['qrcodeimagepath'] != null) {
    data.qrcodeimagepath = json['qrcodeimagepath'];
  }
  if (json['qrimagename'] != null) {
    data.qrimagename = json['qrimagename'];
  }
  if (json['viewprerequisitecontentstatus'] != null) {
    data.viewprerequisitecontentstatus = json['viewprerequisitecontentstatus'];
  }
  if (json['headerlocationname'] != null) {
    data.headerlocationname = json['headerlocationname']?.toString() ?? "";
  }
  if (json['suggesttoconnlink'] != null) {
    data.suggesttoconnlink = json['suggesttoconnlink']?.toString() ?? "";
  }
  if (json['suggestwithfriendlink'] != null) {
    data.suggestwithfriendlink =
        json['suggestwithfriendlink']?.toString() ?? "";
  }
  if (json['isDownloading'] != null) {
    data.isDownloading = json['isDownloading'];
  }
  if (json['isaddedtomylearning'] != null) {
    data.isaddedtomylearning = json['isaddedtomylearning']?.toInt();
  }
  if (json['imageData'] != null) {
    data.imageData = json['imageData']?.toString() ?? "";
  }
  if (json['author'] != null) {
    data.author = json['author']?.toString() ?? "";
  }
  if (json['parentid'] != null) {
    data.parentid = json['parentid'];
  }
  if (json['blockName'] != null) {
    data.blockName = json['blockName']?.toString() ?? "";
  }
  if (json['parentid'] != null) {
    data.parentid = json['parentid'];
  }
  if (json['iswishlistcontent'] != null) {
    data.iswishlistcontent = json['iswishlistcontent'];
  }
  if (json['actionwaitlist'] != null) {
    data.actionwaitlist = json['actionwaitlist'];
  }
  if (json['ShareContentwithUser'] != null) {
    data.actionwaitlist = json['ShareContentwithUser'];
  }
  if (json['datefilter'] != null) {
    data.datefilter = json['datefilter'];
  }
  return data;
}

Map<String, dynamic> dummyMyCatelogResponseTable2ToJson(
    DummyMyCatelogResponseTable2 entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['filterid'] = entity.filterid;
  data['siteid'] = entity.siteid;
  data['usersiteid'] = entity.usersiteid;
  data['sitename'] = entity.sitename;
  data['objectid'] = entity.objectid;
  data['medianame'] = entity.medianame;
  data['description'] = entity.description;
  data['contenttype'] = entity.contenttype;
  data['iconpath'] = entity.iconpath;
  data['iscontent'] = entity.iscontent;
  data['contenttypethumbnail'] = entity.contenttypethumbnail;
  data['contentid'] = entity.contentid;
  data['name'] = entity.name;
  data['objecttypeid'] = entity.objecttypeid;
  data['language'] = entity.language;
  data['shortdescription'] = entity.shortdescription;
  data['version'] = entity.version;
  data['startpage'] = entity.startpage;
  data['createduserid'] = entity.createduserid;
  data['createddate'] = entity.createddate;
  data['keywords'] = entity.keywords;
  data['downloadable'] = entity.downloadable;
  data['publisheddate'] = entity.publisheddate;
  data['status'] = entity.status;
  data['cmsgroupid'] = entity.cmsgroupid;
  data['checkedoutto'] = entity.checkedoutto;
  data['longdescription'] = entity.longdescription;
  data['mediatypeid'] = entity.mediatypeid;
  data['owner'] = entity.owner;
  data['publicationdate'] = entity.publicationdate;
  data['activatedate'] = entity.activatedate;
  data['expirydate'] = entity.expirydate;
  data['thumbnailimagepath'] = entity.thumbnailimagepath;
  data['ecommbussinessrule'] = entity.ecommbussinessrule;
  data['downloadfile'] = entity.downloadfile;
  data['saleprice'] = entity.saleprice;
  data['listprice'] = entity.listprice;
  data['folderpath'] = entity.folderpath;
  data['skinid'] = entity.skinid;
  data['folderid'] = entity.folderid;
  data['modifieduserid'] = entity.modifieduserid;
  data['modifieddate'] = entity.modifieddate;
  data['viewtype'] = entity.viewtype;
  data['windowproperties'] = entity.windowproperties;
  data['currency'] = entity.currency;
  data['certificateid'] = entity.certificateid;
  data['launchwindowmode'] = entity.launchwindowmode;
  data['active'] = entity.active;
  data['hardwaretype'] = entity.hardwaretype;
  data['enrollmentlimit'] = entity.enrollmentlimit;
  data['presenterurl'] = entity.presenterurl;
  data['participanturl'] = entity.participanturl;
  data['eventstartdatetime'] = entity.eventstartdatetime;
  data['eventenddatetime'] = entity.eventenddatetime;
  data['presenterid'] = entity.presenterid;
  data['contentstatus'] = entity.contentstatus;
  data['location'] = entity.location;
  data['conferencenumbers'] = entity.conferencenumbers;
  data['directionurl'] = entity.directionurl;
  data['eventpercentage'] = entity.eventpercentage;
  data['starttime'] = entity.starttime;
  data['duration'] = entity.duration;
  data['personalizediconid1'] = entity.personalizediconid1;
  data['personalizediconid2'] = entity.personalizediconid2;
  data['ciid'] = entity.ciid;
  data['noofusersenrolled'] = entity.noofusersenrolled;
  data['noofuserscompleted'] = entity.noofuserscompleted;
  data['eventkey'] = entity.eventkey;
  data['eventtype'] = entity.eventtype;
  data['devicetypeid'] = entity.devicetypeid;
  data['nvarchar2'] = entity.nvarchar2;
  data['nvarchar3'] = entity.nvarchar3;
  data['audience'] = entity.audience;
  data['backgroundcolor'] = entity.backgroundcolor;
  data['fontcolor'] = entity.fontcolor;
  data['searchreferencenumber'] = entity.searchreferencenumber;
  data['nvarchar4'] = entity.nvarchar4;
  data['timezone'] = entity.timezone;
  data['bit3'] = entity.bit3;
  data['bit4'] = entity.bit4;
  data['typeofevent'] = entity.typeofevent;
  data['webinartool'] = entity.webinartool;
  data['webinarpassword'] = entity.webinarpassword;
  data['bit5'] = entity.bit5;
  data['bit2'] = entity.bit2;
  data['seotitle'] = entity.seotitle;
  data['seometadescription'] = entity.seometadescription;
  data['seokeywords'] = entity.seokeywords;
  data['waitlistlimit'] = entity.waitlistlimit;
  data['totalattempts'] = entity.totalattempts;
  data['accessperiodtype'] = entity.accessperiodtype;
  data['itunesproductid'] = entity.itunesproductid;
  data['googleproductid'] = entity.googleproductid;
  data['decimal2'] = entity.decimal2;
  data['budgetprice'] = entity.budgetprice;
  data['budgetcurrency'] = entity.budgetcurrency;
  data['eventresourcedisplayoption'] = entity.eventresourcedisplayoption;
  data['certificatepercentage'] = entity.certificatepercentage;
  data['activityid'] = entity.activityid;
  data['eventscheduletype'] = entity.eventscheduletype;
  data['bigint4'] = entity.bigint4;
  data['offeringstartdate'] = entity.offeringstartdate;
  data['offeringenddate'] = entity.offeringenddate;
  data['contentauthordisplayname'] = entity.contentauthordisplayname;
  data['registrationurl'] = entity.registrationurl;
  data['videointroduction'] = entity.videointroduction;
  data['noofmodules'] = entity.noofmodules;
  data['learningobjectives'] = entity.learningobjectives;
  data['tableofcontent'] = entity.tableofcontent;
  data['tagname'] = entity.tagname;
  data['credittypes'] = entity.credittypes;
  data['eventcategories'] = entity.eventcategories;
  data['eventrecording'] = entity.eventrecording;
  data['recordingmsg'] = entity.recordingmsg;
  data['recordingcontentid'] = entity.recordingcontentid;
  data['recordingurl'] = entity.recordingurl;
  data['scoid'] = entity.scoid;
  data['startdate'] = entity.startdate;
  data['datecompleted'] = entity.datecompleted;
  data['accessednumber'] = entity.accessednumber;
  data['noofattempts'] = entity.noofattempts;
  data['totalsessiontime'] = entity.totalsessiontime;
  data['corechildren'] = entity.corechildren;
  data['coreentry'] = entity.coreentry;
  data['corelessonstatus'] = entity.corelessonstatus;
  data['corecredit'] = entity.corecredit;
  data['groupdisplayname'] = entity.groupdisplayname;
  data['groupdisplayorder'] = entity.groupdisplayorder;
  data['corelessonlocation'] = entity.corelessonlocation;
  data['scorechildren'] = entity.scorechildren;
  data['scoreraw'] = entity.scoreraw;
  data['scoremin'] = entity.scoremin;
  data['scoremax'] = entity.scoremax;
  data['launchdata'] = entity.launchdata;
  data['actualstatus'] = entity.actualstatus;
  data['userid'] = entity.userid;
  data['dateassigned'] = entity.dateassigned;
  data['targetdate'] = entity.targetdate;
  data['ismandatory'] = entity.ismandatory;
  data['assignedby'] = entity.assignedby;
  data['assignedbyadmin'] = entity.assignedbyadmin;
  data['durationenddate'] = entity.durationenddate;
  data['usercontentstatus'] = entity.usercontentstatus;
  data['attemptsleft'] = entity.attemptsleft;
  data['accessperiod'] = entity.accessperiod;
  data['accessperiodunit'] = entity.accessperiodunit;
  data['isarchived'] = entity.isarchived;
  data['purchaseddate'] = entity.purchaseddate;
  data['joinurl'] = entity.joinurl;
  data['confirmationurl'] = entity.confirmationurl;
  data['hide'] = entity.xHide;
  data['required'] = entity.required;
  data['schedulestatus'] = entity.schedulestatus;
  data['schedulereserveddatetime'] = entity.schedulereserveddatetime;
  data['percentcompleted'] = entity.percentcompleted;
  data['invitationurl'] = entity.invitationurl;
  data['link'] = entity.link;
  data['pareportlink'] = entity.pareportlink;
  data['dareportlink'] = entity.dareportlink;
  data['availableseats'] = entity.availableseats;
  data['waitlistenrolls'] = entity.waitlistenrolls;
  data['jwvideokey'] = entity.jwvideokey;
  data['cloudmediaplayerkey'] = entity.cloudmediaplayerkey;
  data['usercertificateid'] = entity.usercertificateid;
  data['relatedconentcount'] = entity.relatedconentcount;
  data['dtfcontent'] = entity.dtfcontent;
  data['ratingid'] = entity.ratingid;
  data['totalratings'] = entity.totalratings;
  data['certificatepage'] = entity.certificatepage;
  data['locationname'] = entity.locationname;
  data['buildingname'] = entity.buildingname;
  data['commentscount'] = entity.commentscount;
  data['authordisplayname'] = entity.authordisplayname;
  data['presenter'] = entity.presenter;
  data['isdownloaded'] = entity.isdownloaded;
  data['eventrecording1'] = entity.eventrecording1;
  data['recordingmsg1'] = entity.recordingmsg1;
  data['recordingcontentid1'] = entity.recordingcontentid1;
  data['recordingurl1'] = entity.recordingurl1;
  data['eventstartdatedisplay'] = entity.eventstartdatedisplay;
  data['eventenddatedisplay'] = entity.eventenddatedisplay;
  data['timezoneabbreviation'] = entity.timezoneabbreviation;
  data['siteurl'] = entity.siteurl;
  data['progress'] = entity.progress;
  data['removelink'] = entity.removelink;
  data['reschduleparentid'] = entity.reschduleparentid;
  data['isbadcancellationenabled'] = entity.isbadcancellationenabled;
  data['jwstartpage'] = entity.jwstartpage;
  data['isenrollfutureinstance'] = entity.isenrollfutureinstance;
  data['isviewreview'] = entity.isviewreview;
  data['certificateaction'] = entity.certificateaction;
  data['qrcodeimagepath'] = entity.qrcodeimagepath;
  data['qrimagename'] = entity.qrimagename;
  data['viewprerequisitecontentstatus'] = entity.viewprerequisitecontentstatus;
  data['headerlocationname'] = entity.headerlocationname;
  data['suggesttoconnlink'] = entity.suggesttoconnlink;
  data['suggestwithfriendlink'] = entity.suggestwithfriendlink;
  data['isDownloading'] = entity.isDownloading;
  data['isaddedtomylearning'] = entity.isaddedtomylearning;
  data['imageData'] = entity.imageData;
  data['author'] = entity.author;
  data['parentid'] = entity.parentid;
  data['blockName'] = entity.blockName;
  data['iswishlistcontent'] = entity.iswishlistcontent;
  data['actionwaitlist'] = entity.actionwaitlist;
  data['ShareContentwithUser'] = entity.ShareContentwithUser;
  data['datefilter'] = entity.datefilter;
  return data;
}
