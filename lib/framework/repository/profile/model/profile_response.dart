// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

import 'fetchCounries.dart';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  ProfileResponse({
    this.userprofiledetails = const [],
    this.profiledatafieldname = const [],
    this.profilegroups = const [],
    this.usereducationdata = const [],
    this.userexperiencedata = const [],
    this.userprofilegroups = const [],
    this.siteusersinfo = const [],
    this.userprivileges = const [],
    this.usermembershipdetails = const [],
  });

  List<Userprofiledetail> userprofiledetails = [];
  List<ProfileDataField> profiledatafieldname = [];
  List<Usereducationdatum> usereducationdata = [];
  List<Userexperiencedatum> userexperiencedata = [];
  List<Siteusersinfo> siteusersinfo = [];
  List<Userprivilege> userprivileges = [];
  List<Usermembershipdetail> usermembershipdetails = [];
  List<Profilegroup> userprofilegroups = [];
  List<Profilegroup> profilegroups = [];

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        userprofiledetails: List<Userprofiledetail>.from(
            (json["userprofiledetails"] ?? [])
                .map((x) => Userprofiledetail.fromJson(x))),
        profiledatafieldname: List<ProfileDataField>.from(
            (json["profiledatafieldname"] ?? [])
                .map((x) => ProfileDataField.fromJson(x))),
        usereducationdata: List<Usereducationdatum>.from(
            (json["usereducationdata"] ?? [])
                .map((x) => Usereducationdatum.fromJson(x))),
        userexperiencedata: List<Userexperiencedatum>.from(
            (json["userexperiencedata"] ?? [])
                .map((x) => Userexperiencedatum.fromJson(x))),
        siteusersinfo: List<Siteusersinfo>.from((json["siteusersinfo"] ?? [])
            .map((x) => Siteusersinfo.fromJson(x))),
        userprivileges: List<Userprivilege>.from((json["userprivileges"] ?? [])
            .map((x) => Userprivilege.fromJson(x))),
        usermembershipdetails: List<Usermembershipdetail>.from(
            (json["usermembershipdetails"] ?? [])
                .map((x) => Usermembershipdetail.fromJson(x))),
        userprofilegroups: List<Profilegroup>.from(
            (json["userprofilegroups"] ?? [])
                .map((x) => Profilegroup.fromJson(x))),
        profilegroups: List<Profilegroup>.from(
            (json["profilegroups"] ?? []).map((x) => Profilegroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userprofiledetails":
            List<dynamic>.from(userprofiledetails.map((x) => x.toJson())),
        "profiledatafieldname":
            List<dynamic>.from(profiledatafieldname.map((x) => x.toJson())),
        "usereducationdata":
            List<dynamic>.from(usereducationdata.map((x) => x.toJson())),
        "userexperiencedata":
            List<dynamic>.from(userexperiencedata.map((x) => x.toJson())),
        "siteusersinfo":
            List<dynamic>.from(siteusersinfo.map((x) => x.toJson())),
        "userprivileges":
            List<dynamic>.from(userprivileges.map((x) => x.toJson())),
        "usermembershipdetails":
            List<dynamic>.from(usermembershipdetails.map((x) => x.toJson())),
        "userprofilegroups": userprofilegroups == null
            ? null
            : List<dynamic>.from(userprofilegroups.map((x) => x.toJson())),
        "profilegroups": profilegroups == null
            ? null
            : List<dynamic>.from(profilegroups.map((x) => x.toJson())),
      };
}

class Siteusersinfo {
  Siteusersinfo({
    this.picture = "",
    this.userid = 0,
    this.displayname = "",
    this.email = "",
    this.profileimagepath = "",
  });

  String picture = "";
  int userid = 0;
  String displayname = "";
  String email = "";
  String profileimagepath = "";

  factory Siteusersinfo.fromJson(Map<String, dynamic> json) => Siteusersinfo(
        picture: json["picture"] ?? "",
        userid: json["userid"] ?? 0,
        displayname: json["displayname"] ?? "",
        email: json["email"] ?? "",
        profileimagepath: json["profileimagepath"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "picture": picture == null ? null : picture,
        "userid": userid,
        "displayname": displayname,
        "email": email,
        "profileimagepath": profileimagepath,
      };
}

class Usereducationdatum {
  Usereducationdatum({
    this.userid = 0,
    this.school = "",
    this.country = "",
    this.titleid = 0,
    this.degree = "",
    this.description = "",
    this.displayno = 0,
    this.titleeducation = "",
    this.totalperiod = "",
    this.fromyear = "",
    this.toyear = "",
  });

  int userid = 0;
  String school = "";
  String country = "";
  int titleid = 0;
  String degree = "";
  String description = "";
  int displayno = 0;
  String titleeducation = "";
  String totalperiod = "";
  String fromyear = "";
  String toyear = "";

  factory Usereducationdatum.fromJson(Map<String, dynamic> json) =>
      Usereducationdatum(
        userid: json["userid"] ?? 0,
        school: json["school"] ?? "",
        country: json["country"] ?? "",
        titleid: json["titleid"] ?? 0,
        degree: json["degree"] ?? "",
        description: json["description"] ?? "",
        displayno: json["displayno"] ?? 0,
        titleeducation: json["titleeducation"] ?? "",
        totalperiod: json["totalperiod"] ?? "",
        fromyear: json["fromyear"] ?? "",
        toyear: json["toyear"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "school": school,
        "country": country,
        "titleid": titleid,
        "degree": degree,
        "description": description,
        "displayno": displayno,
        "titleeducation": titleeducation,
        "totalperiod": totalperiod,
        "fromyear": fromyear,
        "toyear": toyear,
      };
}

class Userexperiencedatum {
  Userexperiencedatum({
    this.userid = 0,
    this.title = "",
    this.location = "",
    this.companyname = "",
    this.fromdate = "",
    this.todate = "",
    this.description = "",
    this.diffrence = "",
    this.tilldate = false,
    this.displayno = 0,
  });

  int userid = 0;
  String title = "";
  String location = "";
  String companyname = "";
  String fromdate = "";
  String todate = "";
  String description = "";
  String diffrence = "";
  bool tilldate = false;
  int displayno;

  factory Userexperiencedatum.fromJson(Map<String, dynamic> json) =>
      Userexperiencedatum(
        userid: json["userid"] ?? 0,
        title: json["title"] ?? "",
        location: json["location"] ?? "",
        companyname: json["companyname"] ?? "",
        fromdate: json["fromdate"] ?? "",
        todate: json["todate"] ?? "",
        description: json["description"] ?? "",
        diffrence: json["diffrence"] ?? "",
        tilldate: json["tilldate"] ?? false,
        displayno: json["displayno"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "title": title,
        "location": location,
        "companyname": companyname,
        "fromdate": fromdate,
        "todate": todate,
        "description": description,
        "diffrence": diffrence,
        "tilldate": tilldate,
        "displayno": displayno,
      };
}

class Usermembershipdetail {
  Usermembershipdetail({
    this.usermembership = "",
    this.membershiplevel = 0,
    this.status = "",
    this.startdate,
    this.expirydate,
    this.renewaltype = "",
    this.amount,
    this.expirystatus = "",
  });

  String usermembership = "";
  int membershiplevel = 0;
  String status = "";
  DateTime? startdate;
  dynamic expirydate;
  String renewaltype = "";
  dynamic amount;
  String expirystatus = "";

  factory Usermembershipdetail.fromJson(Map<String, dynamic> json) =>
      Usermembershipdetail(
        usermembership: json["usermembership"] ?? "",
        membershiplevel: json["membershiplevel"] ?? 0,
        status: json["status"] ?? "",
        startdate: DateTime.parse(json["startdate"]),
        expirydate: json["expirydate"],
        renewaltype: json["renewaltype"] ?? "",
        amount: json["amount"],
        expirystatus: json["expirystatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "usermembership": usermembership,
        "membershiplevel": membershiplevel,
        "status": status,
        "startdate": startdate?.toIso8601String(),
        "expirydate": expirydate,
        "renewaltype": renewaltype,
        "amount": amount,
        "expirystatus": expirystatus,
      };
}

class Userprivilege {
  Userprivilege({
    this.userid = 0,
    this.privilegeid = 0,
    this.componentid,
    this.parentprivilegeid,
    this.objecttypeid = 0,
    this.roleid = 0,
  });

  int userid = 0;
  int privilegeid = 0;
  dynamic componentid;
  dynamic parentprivilegeid;
  int objecttypeid = 0;
  int roleid = 0;

  factory Userprivilege.fromJson(Map<String, dynamic> json) => Userprivilege(
        userid: json["userid"] ?? 0,
        privilegeid: json["privilegeid"] ?? 0,
        componentid: json["componentid"],
        parentprivilegeid: json["parentprivilegeid"],
        objecttypeid: json["objecttypeid"] ?? 0,
        roleid: json["roleid"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "privilegeid": privilegeid,
        "componentid": componentid,
        "parentprivilegeid": parentprivilegeid,
        "objecttypeid": objecttypeid,
        "roleid": roleid,
      };
}

class Userprofiledetail {
  Userprofiledetail(
      {this.objectid = 0,
      this.accounttype = 0,
      this.orgunitid = 0,
      this.siteid = 0,
      this.approvalstatus = 0,
      this.firstname = "",
      this.lastname = "",
      this.email = "",
      this.nvarchar6 = "",
      this.jobroleid = "",
      this.jobtitle,
      this.businessfunction,
      // this.languageselection,
      this.picture = "",
      this.userid = "",
      this.displayname = "",
      this.organization = "",
      this.usersite = "",
      this.supervisoremployeeid = "",
      this.addressline1 = "",
      this.addresscity = "",
      this.addressstate = "",
      this.addresszip = "",
      this.addresscountry = "",
      this.phone = "",
      this.mobilephone = "",
      this.imaddress = "",
      this.dateofbirth = "",
      this.gender = "",
      this.paymentmode = "",
      this.nvarchar7 = "",
      this.nvarchar8 = "",
      this.nvarchar9 = "",
      this.securepaypalid = "",
      this.nvarchar10 = "",
      this.highschool = "",
      this.college = "",
      this.highestdegree = "",
      this.primaryjobfunction = "",
      this.payeeaccountno = "",
      this.payeename = "",
      this.paypalaccountname = "",
      this.paypalemail = "",
      this.shipaddline1 = "",
      this.shipaddcity = "",
      this.shipaddstate = "",
      this.shipaddzip = "",
      this.shipaddcountry = "",
      this.shipaddphone = "",
      this.profileimagepath = "",
      this.objetId = "",
      this.isProfilexist = false,
      this.nvarchar105 = "",
      this.nvarchar103 = "",
      this.picture1 = ""});

  String nvarchar6;
  String jobroleid;
  dynamic jobtitle;
  dynamic businessfunction;

  // String languageselection;
  String picture;
  String picture1;
  String userid = "";
  int objectid = 0;
  int accounttype = 0;
  int orgunitid = 0;
  int siteid = 0;
  int approvalstatus = 0;
  String firstname;
  String lastname;
  String displayname = "";
  String organization = "";
  String email;
  String usersite = "";
  String supervisoremployeeid = "";
  String addressline1 = "";
  String addresscity = "";
  String addressstate = "";
  String addresszip = "0";
  String addresscountry = "";
  String phone = "";
  String mobilephone = "";
  String imaddress = "";
  String dateofbirth = "";
  String gender = "";
  String paymentmode = "";
  String nvarchar7 = "";
  String nvarchar8 = "";
  String nvarchar9 = "";
  String securepaypalid = "";
  String nvarchar10 = "";
  String highschool = "";
  String college = "";
  String highestdegree = "";
  String primaryjobfunction = "";
  String payeeaccountno = "";
  String payeename = "";
  String paypalaccountname = "";
  String paypalemail = "";
  String shipaddline1 = "";
  String shipaddcity = "";
  String shipaddstate = "";
  String shipaddzip = "";
  String shipaddcountry = "";
  String shipaddphone = "";
  String profileimagepath = "";
  String objetId = "";
  bool isProfilexist = false;
  String nvarchar103 = "";
  String nvarchar105 = "";

  factory Userprofiledetail.fromJson(Map<String, dynamic> json) =>
      Userprofiledetail(
          objectid: json["objectid"] ?? 0,
          accounttype: json["accounttype"] ?? 0,
          orgunitid: json["orgunitid"] ?? 0,
          siteid: json["siteid"] ?? 0,
          approvalstatus: json["approvalstatus"] ?? 0,
          firstname: json["firstname"] ?? "",
          lastname: json["lastname"] ?? "",
          email: json["email"] ?? "",
          nvarchar6: json["nvarchar6"] ?? "",
          jobroleid: json["jobroleid"] ?? "",
          jobtitle: json["jobtitle"],
          businessfunction: json["businessfunction"],
          // languageselection: json["languageselection"],
          nvarchar105: json['nvarchar105'] ?? "",
          nvarchar103: json['nvarchar103'] ?? "",
          objetId: json['objetId'] ?? "",
          profileimagepath: json['profileimagepath'] ?? "",
          shipaddphone: json['shipaddphone'] ?? "",
          shipaddcountry: json['shipaddcountry'] ?? "",
          shipaddstate: json['shipaddstate'] ?? "",
          shipaddzip: json['shipaddzip'] ?? "",
          shipaddcity: json['shipaddcity'] ?? "",
          shipaddline1: json['shipaddline1'] ?? "",
          paypalemail: json['paypalemail'] ?? "",
          payeeaccountno: json['payeeaccountno'] ?? "",
          primaryjobfunction: json['primaryjobfunction'] ?? "",
          highestdegree: json['highestdegree'] ?? "",
          college: json['college'] ?? "",
          highschool: json['highschool'] ?? "",
          nvarchar10: json['nvarchar10'] ?? "",
          securepaypalid: json['securepaypalid'] ?? "",
          nvarchar9: json['nvarchar9'] ?? "",
          nvarchar8: json['nvarchar8'] ?? "",
          nvarchar7: json['nvarchar7'] ?? "",
          paymentmode: json['paymentmode'] ?? "",
          gender: json['gender'] ?? "",
          dateofbirth: json['dateofbirth'] ?? "",
          imaddress: json['imaddress'] ?? "",
          mobilephone: json['mobilephone'] ?? "",
          phone: json['phone'] ?? "",
          addresscountry: json['addresscountry'] ?? "",
          addresszip: json['addresszip'] ?? "",
          addressstate: json['addressstate'] ?? "",
          addresscity: json['addresscity'] ?? "",
          addressline1: json['addressline1'] ?? "",
          supervisoremployeeid: json['supervisoremployeeid'] ?? "",
          usersite: json['usersite'] ?? "",
          organization: json['organization'] ?? "",
          displayname: json['displayname'] ?? "",
          userid: json['userid'] ?? "",
          picture1: json['picture1'] ?? "",
          picture: json['picture'] ?? "");

  Map<String, dynamic> toJson() => {
        "objectid": objectid,
        "accounttype": accounttype,
        "orgunitid": orgunitid,
        "siteid": siteid,
        "approvalstatus": approvalstatus,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "nvarchar6": nvarchar6,
        "jobroleid": jobroleid,
        "jobtitle": jobtitle,
        "businessfunction": businessfunction,
        // "languageselection": languageselection,
        "picture": picture,
        "userid": userid,
        "displayname": displayname,
        "organization": organization,
        "usersite": usersite,
        "supervisoremployeeid": supervisoremployeeid,
        "addressline1": addressline1,
        "addresscity": addresscity,
        "addressstate": addressstate,
        "addresszip": addresszip,
        "addresscountry": addresscountry,
        "phone": phone,
        "mobilephone": mobilephone,
        "imaddress": imaddress,
        "dateofbirth": dateofbirth,
        "gender": gender,
        "paymentmode": paymentmode,
        "nvarchar7": nvarchar7,
        "nvarchar8": nvarchar8,
        "nvarchar9": nvarchar9,
        "securepaypalid": securepaypalid,
        "nvarchar10": nvarchar10,
        "highschool": highschool,
        "college": college,
        "highestdegree": highestdegree,
        "primaryjobfunction": primaryjobfunction,
        "payeeaccountno": payeeaccountno,
        "payeename": payeename,
        "paypalaccountname": paypalaccountname,
        "paypalemail": paypalemail,
        "shipaddline1": shipaddline1,
        "shipaddcity": shipaddcity,
        "shipaddstate": shipaddstate,
        "shipaddzip": shipaddzip,
        "shipaddcountry": shipaddcountry,
        "shipaddphone": shipaddphone,
        "profileimagepath": profileimagepath,
        "objetId": objetId,
        "isProfilexist": isProfilexist,
        "nvarchar103": nvarchar103,
        "nvarchar105": nvarchar105,
        "picture1": picture1
      };
}

class ProfileDataField {
  ProfileDataField({
    this.datafieldname = "",
    this.aliasname = "",
    this.attributedisplaytext = "",
    this.groupid = 0,
    this.displayorder = 0,
    this.attributeconfigid = 0,
    this.isrequired = false,
    this.iseditable = false,
    this.enduservisibility = false,
    this.uicontroltypeid = 0,
    this.name = "",
    this.minlength = 0,
    this.maxlength = 0,
    this.valueName = "",
  });

  String datafieldname;
  String aliasname;
  String attributedisplaytext;
  int groupid;
  int displayorder;
  int attributeconfigid;
  bool isrequired;
  bool iseditable;
  bool enduservisibility;
  int uicontroltypeid;
  String name;
  int minlength;
  int maxlength;
  String valueName = '';

  factory ProfileDataField.fromJson(Map<String, dynamic> json) =>
      ProfileDataField(
        datafieldname: json["datafieldname"] ?? "",
        aliasname: json["aliasname"] ?? "",
        attributedisplaytext: json["attributedisplaytext"] ?? "",
        groupid: json["groupid"] ?? 0,
        displayorder: json["displayorder"] ?? 0,
        attributeconfigid: json["attributeconfigid"] ?? 0,
        isrequired: json["isrequired"] ?? false,
        iseditable: json["iseditable"] ?? false,
        enduservisibility: json["enduservisibility"] ?? false,
        uicontroltypeid: json["uicontroltypeid"] ?? 0,
        name: json["name"] ?? "",
        minlength: json["minlength"] ?? 0,
        maxlength: json["maxlength"] ?? 0,
        valueName: json["valueName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "datafieldname": datafieldname,
        "aliasname": aliasname,
        "attributedisplaytext": attributedisplaytext,
        "groupid": groupid,
        "displayorder": displayorder,
        "attributeconfigid": attributeconfigid,
        "isrequired": isrequired,
        "iseditable": iseditable,
        "enduservisibility": enduservisibility,
        "uicontroltypeid": uicontroltypeid,
        "name": name,
        "minlength": minlength,
        "maxlength": maxlength,
        "valueName": valueName == null ? null : valueName,
      };
}

class Profilegroup {
  Profilegroup({
    this.groupid = 0,
    this.groupname = "",
    this.objecttypeid = 0,
    this.siteid = 0,
    this.showinprofile = 0,
    this.displayorder = 0,
    this.localeid = "",
    this.datafilelist = const [],
  });

  int groupid;
  String groupname;
  int objecttypeid;
  int siteid;
  int showinprofile;
  int displayorder;
  String localeid;
  List<Datafilelist> datafilelist;

  factory Profilegroup.fromJson(Map<String, dynamic> json) => Profilegroup(
        groupid: json["groupid"] ?? 0,
        groupname: json["groupname"] ?? "",
        objecttypeid: json["objecttypeid"] ?? 0,
        siteid: json["siteid"] ?? 0,
        showinprofile: json["showinprofile"] ?? 0,
        displayorder: json["displayorder"] ?? 0,
        localeid: json["localeid"] ?? "",
        datafilelist: List<Datafilelist>.from(
            (json["datafilelist"] ?? []).map((x) => Datafilelist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "groupid": groupid == null ? null : groupid,
        "groupname": groupname == null ? null : groupname,
        "objecttypeid": objecttypeid == null ? null : objecttypeid,
        "siteid": siteid == null ? null : siteid,
        "showinprofile": showinprofile == null ? null : showinprofile,
        "displayorder": displayorder == null ? null : displayorder,
        "localeid": localeid == null ? null : localeid,
        "datafilelist": datafilelist == null
            ? null
            : List<dynamic>.from(datafilelist.map((x) => x.toJson())),
      };
}

class Datafilelist {
  Datafilelist({
    this.datafieldname = "",
    this.aliasname = "",
    this.attributedisplaytext = "",
    this.groupid = 0,
    this.displayorder = 0,
    this.attributeconfigid = 0,
    this.isrequired = false,
    this.iseditable = false,
    this.enduservisibility = false,
    this.uicontroltypeid = 0,
    this.name = "",
    this.minlength = 0,
    this.maxlength = 0,
    this.valueName = "",
  });

  String datafieldname;
  String aliasname;
  String attributedisplaytext;
  int groupid;
  int displayorder;
  int attributeconfigid;
  bool isrequired;
  bool iseditable;
  bool enduservisibility;
  int uicontroltypeid;
  String name;
  int minlength;
  int maxlength;
  String valueName = "";
  Table5? table5;

  factory Datafilelist.fromJson(Map<String, dynamic> json) => Datafilelist(
        datafieldname: json["datafieldname"] ?? "",
        aliasname: json["aliasname"] ?? "",
        attributedisplaytext: json["attributedisplaytext"] ?? "",
        groupid: json["groupid"] ?? 0,
        displayorder: json["displayorder"] ?? 0,
        attributeconfigid: json["attributeconfigid"] ?? 0,
        isrequired: json["isrequired"] ?? false,
        iseditable: json["iseditable"] ?? false,
        enduservisibility: json["enduservisibility"] ?? false,
        uicontroltypeid: json["uicontroltypeid"] ?? 0,
        name: json["name"] ?? "",
        minlength: json["minlength"] ?? 0,
        maxlength: json["maxlength"] ?? 0,
        valueName: json["valueName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "datafieldname": datafieldname == null ? null : datafieldname,
        "aliasname": aliasname == null ? null : aliasname,
        "attributedisplaytext":
            attributedisplaytext == null ? null : attributedisplaytext,
        "groupid": groupid == null ? null : groupid,
        "displayorder": displayorder == null ? null : displayorder,
        "attributeconfigid":
            attributeconfigid == null ? null : attributeconfigid,
        "isrequired": isrequired == null ? null : isrequired,
        "iseditable": iseditable == null ? null : iseditable,
        "enduservisibility":
            enduservisibility == null ? null : enduservisibility,
        "uicontroltypeid": uicontroltypeid == null ? null : uicontroltypeid,
        "name": name == null ? null : name,
        "minlength": minlength == null ? null : minlength,
        "maxlength": maxlength == null ? null : maxlength,
        "valueName": valueName == null ? "" : valueName,
      };
}

class ProfileEditList {
  ProfileEditList(
      {this.datafieldname = "",
      this.aliasname = "",
      this.attributedisplaytext = "",
      this.groupid = 0,
      this.displayorder = 0,
      this.attributeconfigid = 0,
      this.isrequired = false,
      this.iseditable = false,
      this.enduservisibility = false,
      this.uicontroltypeid = 0,
      this.name = "",
      this.minlength = 0,
      this.maxlength = 0,
      this.valueName = "",
      this.table5});

  String datafieldname;
  String aliasname;
  String attributedisplaytext;
  int groupid;
  int displayorder;
  int attributeconfigid;
  bool isrequired;
  bool iseditable;
  bool enduservisibility;
  int uicontroltypeid;
  String name;
  int minlength;
  int maxlength;
  String valueName = "";
  Table5? table5;
}

ProfileHeader profileHeaderFromJson(String str) =>
    ProfileHeader.fromJson(json.decode(str));

String profileHeaderToJson(ProfileHeader data) => json.encode(data.toJson());

class ProfileHeader {
  ProfileHeader({
    this.backgroundImgProfilepath = "",
    this.profilepath = "",
    this.userProfilePath = "",
    this.socialSection,
    this.userJobTitle = "",
    this.aboutme = "",
    this.displayname = "",
    this.nodataiamge = "",
    this.intConnStatus = 0,
    this.acceptAction,
    this.rejectAction,
    this.connectionState = "",
  });

  String backgroundImgProfilepath;
  String profilepath;
  String userProfilePath;
  dynamic socialSection;
  String userJobTitle;
  String aboutme;
  String displayname;
  String nodataiamge;
  int intConnStatus = 0;
  dynamic acceptAction;
  dynamic rejectAction;
  String connectionState;

  factory ProfileHeader.fromJson(Map<String, dynamic> json) => ProfileHeader(
        backgroundImgProfilepath: json["BackgroundImgProfilepath"],
        profilepath: json["Profilepath"],
        userProfilePath: json["UserProfilePath"],
        socialSection: json["SocialSection"],
        userJobTitle: json["UserJobTitle"],
        aboutme: json["Aboutme"],
        displayname: json["Displayname"],
        nodataiamge: json["Nodataiamge"],
        intConnStatus: json["intConnStatus"],
        acceptAction: json["AcceptAction"],
        rejectAction: json["RejectAction"],
        connectionState: json["ConnectionState"],
      );

  Map<String, dynamic> toJson() => {
        "BackgroundImgProfilepath": backgroundImgProfilepath,
        "Profilepath": profilepath,
        "UserProfilePath": userProfilePath,
        "SocialSection": socialSection,
        "UserJobTitle": userJobTitle,
        "Aboutme": aboutme,
        "Displayname": displayname,
        "Nodataiamge": nodataiamge,
        "intConnStatus": intConnStatus,
        "AcceptAction": acceptAction,
        "RejectAction": rejectAction,
        "ConnectionState": connectionState,
      };
}
