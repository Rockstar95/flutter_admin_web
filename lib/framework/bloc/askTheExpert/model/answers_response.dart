import 'dart:convert';

AnswersResponse answersResponseFromJson(String str) =>
    AnswersResponse.fromJson(json.decode(str));

dynamic answersResponseToJson(AnswersResponse data) =>
    json.encode(data.toJson());

class AnswersResponse {
  List<Table> table;
  List<Table1> table1;
  List<Table2> table2;

  //List<Table3> table3;
  List<UpVotesUsers> upVotesUsers;

  AnswersResponse(
      {required this.table,
      required this.table1,
      required this.table2,
      required this.upVotesUsers});

  static AnswersResponse fromJson(Map<String, dynamic> json) {
    AnswersResponse answersResponse =
        AnswersResponse(table: [], table1: [], table2: [], upVotesUsers: []);
    if (json['Table'] != null) {
      answersResponse.table = [];
      json['Table'].forEach((v) {
        answersResponse.table.add(Table.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      answersResponse.table1 = [];
      json['Table1'].forEach((v) {
        answersResponse.table1.add(Table1.fromJson(v));
      });
    }
    if (json['Table2'] != null) {
      answersResponse.table2 = [];
      json['Table2'].forEach((v) {
        answersResponse.table2.add(Table2.fromJson(v));
      });
    }

    if (json['UpVotesUsers'] != null) {
      answersResponse.upVotesUsers = [];
      json['UpVotesUsers'].forEach((v) {
        answersResponse.upVotesUsers.add(UpVotesUsers.fromJson(v));
      });
    }
    return answersResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }
    if (this.table1 != null) {
      data['Table1'] = this.table1.map((v) => v.toJson()).toList();
    }
    if (this.table2 != null) {
      data['Table2'] = this.table2.map((v) => v.toJson()).toList();
    }

    if (this.upVotesUsers != null) {
      data['UpVotesUsers'] = this.upVotesUsers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  int questionID;
  int userID;
  String userName;
  String userQuestion;
  String postedDate;
  String createdDate;
  String questionCategories;
  String userQuestionImage;
  String userQuestionDescription;
  String lastActivatedDate;
  String lastActiveDate;

  Table(
      {this.questionID = 0,
      this.userID = 0,
      this.userName = "",
      this.userQuestion = "",
      this.postedDate = "",
      this.createdDate = "",
      this.questionCategories = "",
      this.userQuestionImage = "",
      this.userQuestionDescription = "",
      this.lastActivatedDate = "",
      this.lastActiveDate = ""});

  static Table fromJson(Map<String, dynamic> json) {
    Table table = Table();
    table.questionID = json['QuestionID'] ?? 0;
    table.userID = json['UserID'] ?? 0;
    table.userName = json['UserName'] ?? "";
    table.userQuestion = json['UserQuestion'] ?? "";
    table.postedDate = json['PostedDate'] ?? "";
    table.createdDate = json['CreatedDate'] ?? "";
    table.questionCategories = json['QuestionCategories'] ?? "";
    table.userQuestionImage = json['UserQuestionImage'] ?? "";
    table.userQuestionDescription = json['UserQuestionDescription'] ?? "";
    table.lastActivatedDate = json['LastActivatedDate'] ?? "";
    table.lastActiveDate = json['LastActiveDate'] ?? "";
    return table;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionID'] = this.questionID;
    data['UserID'] = this.userID;
    data['UserName'] = this.userName;
    data['UserQuestion'] = this.userQuestion;
    data['PostedDate'] = this.postedDate;
    data['CreatedDate'] = this.createdDate;
    data['QuestionCategories'] = this.questionCategories;
    data['UserQuestionImage'] = this.userQuestionImage;
    data['UserQuestionDescription'] = this.userQuestionDescription;
    data['LastActivatedDate'] = this.lastActivatedDate;
    data['LastActiveDate'] = this.lastActiveDate;
    return data;
  }
}

class Table1 {
  int responseID;
  int questionID;
  String response;
  int respondedUserID;
  String respondedUserName;
  String respondedDate;
  String responseDate;
  String userResponseImage;
  String picture;
  int commentCount;
  int upvotesCount;
  bool isLiked;
  String userResponseImagePath;
  String days;
  String responseUpVoters;
  String actionSuggestConnection;
  String actionSharewithFriends;
  String commentAction;
  String responseImageUploadName;
  String responseUploadIconPath;

  Table1({
    this.responseID = 0,
    this.questionID = 0,
    this.response = "",
    this.respondedUserID = 0,
    this.respondedUserName = "",
    this.respondedDate = "",
    this.responseDate = "",
    this.userResponseImage = "",
    this.picture = "",
    this.commentCount = 0,
    this.upvotesCount = 0,
    this.isLiked = false,
    this.userResponseImagePath = "",
    this.days = "",
    this.responseUpVoters = "",
    this.actionSuggestConnection = "",
    this.actionSharewithFriends = "",
    this.commentAction = "",
    this.responseImageUploadName = "",
    this.responseUploadIconPath = "",
  });

  static Table1 fromJson(Map<String, dynamic> json) {
    Table1 table1 = Table1();
    table1.responseID = json['ResponseID'] ?? 0;
    table1.questionID = json['QuestionID'] ?? 0;
    table1.response = json['Response'] ?? "";
    table1.respondedUserID = json['RespondedUserID'] ?? 0;
    table1.respondedUserName = json['RespondedUserName'] ?? "";
    table1.respondedDate = json['RespondedDate'] ?? "";
    table1.responseDate = json['ResponseDate'] ?? "";
    table1.userResponseImage = json['UserResponseImage'] ?? "";
    table1.picture = json['Picture'] ?? "";
    table1.commentCount = json['CommentCount'] ?? 0;
    table1.upvotesCount = json['UpvotesCount'] ?? 0;
    table1.isLiked = json['IsLiked'] ?? false;
    table1.userResponseImagePath = json['UserResponseImagePath'] ?? "";
    table1.days = json['Days'] ?? "";
    table1.responseUpVoters = json['ResponseUpVoters'] ?? "";
    table1.actionSuggestConnection = json['actionSuggestConnection'] ?? "";
    table1.actionSharewithFriends = json['actionSharewithFriends'] ?? "";
    table1.commentAction = json['CommentAction'] ?? "";
    table1.responseImageUploadName = json['ResponseImageUploadName'] ?? "";
    table1.responseUploadIconPath = json['ResponseUploadIconPath'] ?? "";
    return table1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResponseID'] = this.responseID;
    data['QuestionID'] = this.questionID;
    data['Response'] = this.response;
    data['RespondedUserID'] = this.respondedUserID;
    data['RespondedUserName'] = this.respondedUserName;
    data['RespondedDate'] = this.respondedDate;
    data['ResponseDate'] = this.responseDate;
    data['UserResponseImage'] = this.userResponseImage;
    data['Picture'] = this.picture;
    data['CommentCount'] = this.commentCount;
    data['UpvotesCount'] = this.upvotesCount;
    data['IsLiked'] = this.isLiked;
    data['UserResponseImagePath'] = this.userResponseImagePath;
    data['Days'] = this.days;
    data['ResponseUpVoters'] = this.responseUpVoters;
    data['actionSuggestConnection'] = this.actionSuggestConnection;
    data['actionSharewithFriends'] = this.actionSharewithFriends;
    data['CommentAction'] = this.commentAction;
    data['ResponseImageUploadName'] = this.responseImageUploadName;
    data['ResponseUploadIconPath'] = this.responseUploadIconPath;
    return data;
  }
}

class Table2 {
  int questionTypeID;
  String questionType;
  String sendTo;
  String sendToConfigKey;
  bool allowAnonymousResponse;
  int emailTemplateID;

  Table2({
    this.questionTypeID = 0,
    this.questionType = "",
    this.sendTo = "",
    this.sendToConfigKey = "",
    this.allowAnonymousResponse = false,
    this.emailTemplateID = 0,
  });

  static Table2 fromJson(Map<String, dynamic> json) {
    Table2 table2 = Table2();
    table2.questionTypeID = json['QuestionTypeID'] ?? 0;
    table2.questionType = json['QuestionType'] ?? "";
    table2.sendTo = json['SendTo'] ?? "";
    table2.sendToConfigKey = json['SendToConfigKey'] ?? "";
    table2.allowAnonymousResponse = json['AllowAnonymousResponse'] ?? false;
    table2.emailTemplateID = json['EmailTemplateID'] ?? 0;
    return table2;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionTypeID'] = this.questionTypeID;
    data['QuestionType'] = this.questionType;
    data['SendTo'] = this.sendTo;
    data['SendToConfigKey'] = this.sendToConfigKey;
    data['AllowAnonymousResponse'] = this.allowAnonymousResponse;
    data['EmailTemplateID'] = this.emailTemplateID;
    return data;
  }
}

/*class Table3 {
  int orgUnitID;
  int originalSiteID;
  int siteID;
  String orgName;
  String firstName;
  String middleName;
  int userID;
  String lastName;
  String login;
  int accountType;
  String subscriptionStartDate;
  String subscriptionEndDate;
  String prefix;
  String suffix;
  String identification;
  String email;
  int phone;
  int fax;
  int mobilePhone;
  String iMAddress;
  String addressline1;
  String addressline2;
  String addressCity;
  String addressState;
  int addressZip;
  String addressCountry;
  String jobTitle;
  String socialSecurity;
  String organization;
  String timeZone;
  String roles;
  bool active;
  int userStatus;
  String createdDateTime;
  String modifiedDateTime;
  String password;
  String accountExpiryDate;
  String accountStartDate;
  int externalID;
  String picture;
  int bigInt2;
  int bigInt1;
  String cLASS;
  int subscriptionsCount;
  String customerCode;
  String salesRepCode;
  String typeSubType;
  int locked;
  String selfRegistrationRoles;
  String areaCode;
  String displayName;
  String divisionCode;
  String plantCode;
  String organizationCode;
  String departmentCode;
  String dateTime1;
  String dateTime2;
  String region;
  String jobCode;
  String externalEmployeeID;
  String externalLoginID;
  int passwordExpiryDays;
  String userSite;
  Null dateOfBirth;
  Null gender;
  Null highSchool;
  Null college;
  Null highestDegree;
  Null businessFunction;
  Null primaryJobFunction;
  String nvarchar6;
  Null nvarchar7;
  Null nvarchar8;
  Null nvarchar9;
  Null nvarchar10;
  bool isExpert;
  Null paymentMode;
  Null approvalStatus;
  bool bit1;
  bool bit2;
  bool bit3;
  String supervisorEmployeeID;
  Null nvarchar5;
  Null securePaypalID;
  Null payeeAccountNo;
  Null payeeName;
  Null payPalEmail;
  Null shipAddLine1;
  Null payPalAccountName;
  Null shipAddCity;
  Null shipAddState;
  Null shipAddZip;
  Null shipAddCountry;
  Null shipAddPhone;
  String address;
  Null description;
  Null datetime5;
  Null socialNetworkID;
  Null socialNetworkURL;
  Null nvarchar11;
  Null nvarchar12;
  Null nvarchar13;
  Null nvarchar14;
  String lastVisited;
  bool isPragenter;
  Null companySize;
  Null evaluator1;
  Null evaluator2;
  Null dateOfJoin;
  Null facebookID;
  Null googlePlusID;
  Null linkedInID;
  Null twitterID;
  Null tumblrID;
  Null source;
  Null nvarchar15;
  Null nvarchar16;
  Null nvarchar17;
  Null nvarchar18;
  Null nvarchar19;
  Null nvarchar20;
  String languageSelection;
  Null age;
  Null licenceno;
  Null billingAddLine1;
  Null billingAddLine2;
  Null billingAddLine3;
  Null billingAddCity;
  Null billingAddState;
  Null billingAddCountry;
  Null billingAddZip;
  Null externalType;
  Null nvarchar4;
  Null nvarchar1;
  Null nvarchar2;
  Null nvarchar3;
  String userLanguage;
  Null workingHoursStartTime;
  Null workingHoursEndTime;
  int uID;
  Null nvarchar101;
  Null nvarchar102;
  Null nvarchar103;
  Null nvarchar104;
  Null nvarchar105;
  Null nvarchar106;
  Null nvarchar107;
  Null nvarchar108;
  Null nvarchar109;
  Null nvarchar110;
  Null nvarchar111;
  Null nvarchar112;
  Null nvarchar113;
  Null nvarchar114;
  Null nvarchar115;
  Null nvarchar116;
  Null nvarchar117;
  Null nvarchar118;
  Null nvarchar119;
  Null nvarchar120;
  Null nvarchar121;
  Null nvarchar122;
  Null nvarchar123;
  Null nvarchar124;
  Null nvarchar125;
  Null nvarchar126;
  Null nvarchar127;
  Null nvarchar128;
  Null nvarchar129;
  Null nvarchar130;
  Null nvarchar131;
  Null nvarchar132;
  Null nvarchar133;
  Null nvarchar134;
  Null nvarchar135;
  Null nvarchar136;
  Null nvarchar137;
  Null nvarchar138;
  Null nvarchar139;
  Null nvarchar140;
  Null nvarchar141;
  Null nvarchar142;
  Null nvarchar143;
  Null nvarchar144;
  Null nvarchar145;
  Null nvarchar146;
  Null nvarchar147;
  Null nvarchar148;
  Null nvarchar149;
  Null nvarchar150;
  Null nvarchar151;
  Null nvarchar152;
  Null nvarchar153;
  Null nvarchar154;
  Null nvarchar155;
  Null nvarchar156;
  Null nvarchar157;
  Null nvarchar158;
  Null nvarchar159;
  Null nvarchar160;
  Null nvarchar161;
  Null nvarchar162;
  Null nvarchar163;
  Null nvarchar164;
  Null nvarchar165;
  Null nvarchar166;
  Null nvarchar167;
  Null nvarchar168;
  Null nvarchar169;
  Null nvarchar170;
  Null nvarchar171;
  Null nvarchar172;
  Null nvarchar173;
  Null nvarchar174;
  Null nvarchar175;
  Null nvarchar176;
  Null nvarchar177;
  Null nvarchar178;
  Null nvarchar179;
  Null nvarchar180;
  Null nvarchar181;
  Null nvarchar182;
  Null nvarchar183;
  Null nvarchar184;
  Null nvarchar185;
  Null nvarchar186;
  Null nvarchar187;
  Null nvarchar188;
  Null nvarchar189;
  Null nvarchar190;
  Null nvarchar191;
  Null nvarchar192;
  Null nvarchar193;
  Null nvarchar194;
  Null nvarchar195;
  Null nvarchar196;
  Null nvarchar197;
  Null nvarchar198;
  Null nvarchar199;
  Null nvarchar200;
  Null nvarchar201;
  Null nvarchar202;
  Null nvarchar203;
  Null nvarchar204;
  Null nvarchar205;
  Null nvarchar206;
  Null nvarchar207;
  Null nvarchar208;
  Null nvarchar209;
  Null nvarchar210;
  Null nvarchar211;
  Null nvarchar212;
  Null nvarchar213;
  Null nvarchar214;
  Null nvarchar215;
  Null nvarchar216;
  Null nvarchar217;
  Null nvarchar218;
  Null nvarchar219;
  Null nvarchar220;
  Null nvarchar221;
  Null nvarchar222;
  Null nvarchar223;
  Null nvarchar224;
  Null nvarchar225;
  Null nvarchar226;
  Null nvarchar227;
  Null nvarchar228;
  Null nvarchar229;
  Null nvarchar230;
  Null nvarchar231;
  Null nvarchar232;
  Null nvarchar233;
  Null nvarchar234;
  Null nvarchar235;
  Null nvarchar236;
  Null nvarchar237;
  Null nvarchar238;
  Null nvarchar239;
  Null nvarchar240;
  Null nvarchar241;
  Null nvarchar242;
  Null nvarchar243;
  Null nvarchar244;
  Null nvarchar245;
  Null nvarchar246;
  Null nvarchar247;
  Null nvarchar248;
  Null nvarchar249;
  Null nvarchar250;
  Null nvarchar251;
  Null nvarchar252;
  Null nvarchar253;
  Null nvarchar254;
  Null nvarchar255;
  Null nvarchar256;
  Null nvarchar257;
  Null nvarchar258;
  Null nvarchar259;
  Null nvarchar260;
  Null nvarchar261;
  Null nvarchar262;
  Null nvarchar263;
  Null nvarchar264;
  Null nvarchar265;
  Null nvarchar266;
  Null nvarchar267;
  Null nvarchar268;
  Null nvarchar269;
  Null nvarchar270;
  Null nvarchar271;
  Null nvarchar272;
  Null nvarchar273;
  Null nvarchar274;
  Null nvarchar275;
  Null nvarchar276;
  Null nvarchar277;
  Null nvarchar278;
  Null nvarchar279;
  Null nvarchar280;
  Null nvarchar281;
  Null nvarchar282;
  Null nvarchar283;
  Null nvarchar284;
  Null nvarchar285;
  Null nvarchar286;
  Null nvarchar287;
  Null nvarchar288;
  Null nvarchar289;
  Null nvarchar290;
  Null nvarchar291;
  Null nvarchar292;
  Null nvarchar293;
  Null nvarchar294;
  Null nvarchar295;
  Null nvarchar296;
  Null nvarchar297;
  Null nvarchar298;
  Null nvarchar299;
  Null nvarchar300;
  Null nvarchar301;
  Null nvarchar302;
  Null nvarchar303;
  Null nvarchar304;
  Null nvarchar305;
  Null nvarchar306;
  Null nvarchar307;
  Null nvarchar308;
  Null nvarchar309;
  Null nvarchar310;
  Null nvarchar311;
  Null nvarchar312;
  Null nvarchar313;
  Null nvarchar314;
  Null nvarchar315;
  Null nvarchar316;
  Null nvarchar317;
  Null nvarchar318;
  Null nvarchar319;
  Null nvarchar320;
  Null nvarchar321;
  Null nvarchar322;
  Null nvarchar323;
  Null nvarchar324;
  Null nvarchar325;
  Null nvarchar326;
  Null nvarchar327;
  Null nvarchar328;
  Null nvarchar329;
  Null nvarchar330;
  Null nvarchar331;
  Null nvarchar332;
  Null nvarchar333;
  Null nvarchar334;
  Null nvarchar335;
  Null nvarchar336;
  Null nvarchar337;
  Null nvarchar338;
  Null nvarchar339;
  Null nvarchar340;
  Null nvarchar341;
  Null nvarchar342;
  Null nvarchar343;
  Null nvarchar344;
  Null nvarchar345;
  Null nvarchar346;
  Null nvarchar347;
  Null nvarchar348;
  Null nvarchar349;
  Null nvarchar350;
  Null uniqueUserID;
  bool isClarizenUser;
  Null slackUserName;
  Null backgroundPicture;
  int showLRSActivities;
  Null instagramID;
  String jobRoleID;

  Table3(
      {this.orgUnitID,
        this.originalSiteID,
        this.siteID,
        this.orgName,
        this.firstName,
        this.middleName,
        this.userID,
        this.lastName,
        this.login,
        this.accountType,
        this.subscriptionStartDate,
        this.subscriptionEndDate,
        this.prefix,
        this.suffix,
        this.identification,
        this.email,
        this.phone,
        this.fax,
        this.mobilePhone,
        this.iMAddress,
        this.addressline1,
        this.addressline2,
        this.addressCity,
        this.addressState,
        this.addressZip,
        this.addressCountry,
        this.jobTitle,
        this.socialSecurity,
        this.organization,
        this.timeZone,
        this.roles,
        this.active,
        this.userStatus,
        this.createdDateTime,
        this.modifiedDateTime,
        this.password,
        this.accountExpiryDate,
        this.accountStartDate,
        this.externalID,
        this.picture,
        this.bigInt2,
        this.bigInt1,
        this.cLASS,
        this.subscriptionsCount,
        this.customerCode,
        this.salesRepCode,
        this.typeSubType,
        this.locked,
        this.selfRegistrationRoles,
        this.areaCode,
        this.displayName,
        this.divisionCode,
        this.plantCode,
        this.organizationCode,
        this.departmentCode,
        this.dateTime1,
        this.dateTime2,
        this.region,
        this.jobCode,
        this.externalEmployeeID,
        this.externalLoginID,
        this.passwordExpiryDays,
        this.userSite,
        this.dateOfBirth,
        this.gender,
        this.highSchool,
        this.college,
        this.highestDegree,
        this.businessFunction,
        this.primaryJobFunction,
        this.nvarchar6,
        this.nvarchar7,
        this.nvarchar8,
        this.nvarchar9,
        this.nvarchar10,
        this.isExpert,
        this.paymentMode,
        this.approvalStatus,
        this.bit1,
        this.bit2,
        this.bit3,
        this.supervisorEmployeeID,
        this.nvarchar5,
        this.securePaypalID,
        this.payeeAccountNo,
        this.payeeName,
        this.payPalEmail,
        this.shipAddLine1,
        this.payPalAccountName,
        this.shipAddCity,
        this.shipAddState,
        this.shipAddZip,
        this.shipAddCountry,
        this.shipAddPhone,
        this.address,
        this.description,
        this.datetime5,
        this.socialNetworkID,
        this.socialNetworkURL,
        this.nvarchar11,
        this.nvarchar12,
        this.nvarchar13,
        this.nvarchar14,
        this.lastVisited,
        this.isPragenter,
        this.companySize,
        this.evaluator1,
        this.evaluator2,
        this.dateOfJoin,
        this.facebookID,
        this.googlePlusID,
        this.linkedInID,
        this.twitterID,
        this.tumblrID,
        this.source,
        this.nvarchar15,
        this.nvarchar16,
        this.nvarchar17,
        this.nvarchar18,
        this.nvarchar19,
        this.nvarchar20,
        this.languageSelection,
        this.age,
        this.licenceno,
        this.billingAddLine1,
        this.billingAddLine2,
        this.billingAddLine3,
        this.billingAddCity,
        this.billingAddState,
        this.billingAddCountry,
        this.billingAddZip,
        this.externalType,
        this.nvarchar4,
        this.nvarchar1,
        this.nvarchar2,
        this.nvarchar3,
        this.userLanguage,
        this.workingHoursStartTime,
        this.workingHoursEndTime,
        this.uID,
        this.nvarchar101,
        this.nvarchar102,
        this.nvarchar103,
        this.nvarchar104,
        this.nvarchar105,
        this.nvarchar106,
        this.nvarchar107,
        this.nvarchar108,
        this.nvarchar109,
        this.nvarchar110,
        this.nvarchar111,
        this.nvarchar112,
        this.nvarchar113,
        this.nvarchar114,
        this.nvarchar115,
        this.nvarchar116,
        this.nvarchar117,
        this.nvarchar118,
        this.nvarchar119,
        this.nvarchar120,
        this.nvarchar121,
        this.nvarchar122,
        this.nvarchar123,
        this.nvarchar124,
        this.nvarchar125,
        this.nvarchar126,
        this.nvarchar127,
        this.nvarchar128,
        this.nvarchar129,
        this.nvarchar130,
        this.nvarchar131,
        this.nvarchar132,
        this.nvarchar133,
        this.nvarchar134,
        this.nvarchar135,
        this.nvarchar136,
        this.nvarchar137,
        this.nvarchar138,
        this.nvarchar139,
        this.nvarchar140,
        this.nvarchar141,
        this.nvarchar142,
        this.nvarchar143,
        this.nvarchar144,
        this.nvarchar145,
        this.nvarchar146,
        this.nvarchar147,
        this.nvarchar148,
        this.nvarchar149,
        this.nvarchar150,
        this.nvarchar151,
        this.nvarchar152,
        this.nvarchar153,
        this.nvarchar154,
        this.nvarchar155,
        this.nvarchar156,
        this.nvarchar157,
        this.nvarchar158,
        this.nvarchar159,
        this.nvarchar160,
        this.nvarchar161,
        this.nvarchar162,
        this.nvarchar163,
        this.nvarchar164,
        this.nvarchar165,
        this.nvarchar166,
        this.nvarchar167,
        this.nvarchar168,
        this.nvarchar169,
        this.nvarchar170,
        this.nvarchar171,
        this.nvarchar172,
        this.nvarchar173,
        this.nvarchar174,
        this.nvarchar175,
        this.nvarchar176,
        this.nvarchar177,
        this.nvarchar178,
        this.nvarchar179,
        this.nvarchar180,
        this.nvarchar181,
        this.nvarchar182,
        this.nvarchar183,
        this.nvarchar184,
        this.nvarchar185,
        this.nvarchar186,
        this.nvarchar187,
        this.nvarchar188,
        this.nvarchar189,
        this.nvarchar190,
        this.nvarchar191,
        this.nvarchar192,
        this.nvarchar193,
        this.nvarchar194,
        this.nvarchar195,
        this.nvarchar196,
        this.nvarchar197,
        this.nvarchar198,
        this.nvarchar199,
        this.nvarchar200,
        this.nvarchar201,
        this.nvarchar202,
        this.nvarchar203,
        this.nvarchar204,
        this.nvarchar205,
        this.nvarchar206,
        this.nvarchar207,
        this.nvarchar208,
        this.nvarchar209,
        this.nvarchar210,
        this.nvarchar211,
        this.nvarchar212,
        this.nvarchar213,
        this.nvarchar214,
        this.nvarchar215,
        this.nvarchar216,
        this.nvarchar217,
        this.nvarchar218,
        this.nvarchar219,
        this.nvarchar220,
        this.nvarchar221,
        this.nvarchar222,
        this.nvarchar223,
        this.nvarchar224,
        this.nvarchar225,
        this.nvarchar226,
        this.nvarchar227,
        this.nvarchar228,
        this.nvarchar229,
        this.nvarchar230,
        this.nvarchar231,
        this.nvarchar232,
        this.nvarchar233,
        this.nvarchar234,
        this.nvarchar235,
        this.nvarchar236,
        this.nvarchar237,
        this.nvarchar238,
        this.nvarchar239,
        this.nvarchar240,
        this.nvarchar241,
        this.nvarchar242,
        this.nvarchar243,
        this.nvarchar244,
        this.nvarchar245,
        this.nvarchar246,
        this.nvarchar247,
        this.nvarchar248,
        this.nvarchar249,
        this.nvarchar250,
        this.nvarchar251,
        this.nvarchar252,
        this.nvarchar253,
        this.nvarchar254,
        this.nvarchar255,
        this.nvarchar256,
        this.nvarchar257,
        this.nvarchar258,
        this.nvarchar259,
        this.nvarchar260,
        this.nvarchar261,
        this.nvarchar262,
        this.nvarchar263,
        this.nvarchar264,
        this.nvarchar265,
        this.nvarchar266,
        this.nvarchar267,
        this.nvarchar268,
        this.nvarchar269,
        this.nvarchar270,
        this.nvarchar271,
        this.nvarchar272,
        this.nvarchar273,
        this.nvarchar274,
        this.nvarchar275,
        this.nvarchar276,
        this.nvarchar277,
        this.nvarchar278,
        this.nvarchar279,
        this.nvarchar280,
        this.nvarchar281,
        this.nvarchar282,
        this.nvarchar283,
        this.nvarchar284,
        this.nvarchar285,
        this.nvarchar286,
        this.nvarchar287,
        this.nvarchar288,
        this.nvarchar289,
        this.nvarchar290,
        this.nvarchar291,
        this.nvarchar292,
        this.nvarchar293,
        this.nvarchar294,
        this.nvarchar295,
        this.nvarchar296,
        this.nvarchar297,
        this.nvarchar298,
        this.nvarchar299,
        this.nvarchar300,
        this.nvarchar301,
        this.nvarchar302,
        this.nvarchar303,
        this.nvarchar304,
        this.nvarchar305,
        this.nvarchar306,
        this.nvarchar307,
        this.nvarchar308,
        this.nvarchar309,
        this.nvarchar310,
        this.nvarchar311,
        this.nvarchar312,
        this.nvarchar313,
        this.nvarchar314,
        this.nvarchar315,
        this.nvarchar316,
        this.nvarchar317,
        this.nvarchar318,
        this.nvarchar319,
        this.nvarchar320,
        this.nvarchar321,
        this.nvarchar322,
        this.nvarchar323,
        this.nvarchar324,
        this.nvarchar325,
        this.nvarchar326,
        this.nvarchar327,
        this.nvarchar328,
        this.nvarchar329,
        this.nvarchar330,
        this.nvarchar331,
        this.nvarchar332,
        this.nvarchar333,
        this.nvarchar334,
        this.nvarchar335,
        this.nvarchar336,
        this.nvarchar337,
        this.nvarchar338,
        this.nvarchar339,
        this.nvarchar340,
        this.nvarchar341,
        this.nvarchar342,
        this.nvarchar343,
        this.nvarchar344,
        this.nvarchar345,
        this.nvarchar346,
        this.nvarchar347,
        this.nvarchar348,
        this.nvarchar349,
        this.nvarchar350,
        this.uniqueUserID,
        this.isClarizenUser,
        this.slackUserName,
        this.backgroundPicture,
        this.showLRSActivities,
        this.instagramID,
        this.jobRoleID});

  Table3.fromJson(Map<String, dynamic> json) {
    orgUnitID = json['OrgUnitID'];
    originalSiteID = json['OriginalSiteID'];
    siteID = json['SiteID'];
    orgName = json['OrgName'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    userID = json['UserID'];
    lastName = json['LastName'];
    login = json['Login'];
    accountType = json['AccountType'];
    subscriptionStartDate = json['SubscriptionStartDate'];
    subscriptionEndDate = json['SubscriptionEndDate'];
    prefix = json['Prefix'];
    suffix = json['Suffix'];
    identification = json['Identification'];
    email = json['Email'];
    phone = json['Phone'];
    fax = json['Fax'];
    mobilePhone = json['MobilePhone'];
    iMAddress = json['IMAddress'];
    addressline1 = json['Addressline1'];
    addressline2 = json['Addressline2'];
    addressCity = json['AddressCity'];
    addressState = json['AddressState'];
    addressZip = json['AddressZip'];
    addressCountry = json['AddressCountry'];
    jobTitle = json['JobTitle'];
    socialSecurity = json['SocialSecurity'];
    organization = json['Organization'];
    timeZone = json['TimeZone'];
    roles = json['Roles'];
    active = json['Active'];
    userStatus = json['UserStatus'];
    createdDateTime = json['CreatedDateTime'];
    modifiedDateTime = json['ModifiedDateTime'];
    password = json['Password'];
    accountExpiryDate = json['AccountExpiryDate'];
    accountStartDate = json['AccountStartDate'];
    externalID = json['ExternalID'];
    picture = json['Picture'];
    bigInt2 = json['BigInt2'];
    bigInt1 = json['BigInt1'];
    cLASS = json['CLASS'];
    subscriptionsCount = json['SubscriptionsCount'];
    customerCode = json['CustomerCode'];
    salesRepCode = json['SalesRepCode'];
    typeSubType = json['TypeSubType'];
    locked = json['Locked'];
    selfRegistrationRoles = json['SelfRegistrationRoles'];
    areaCode = json['AreaCode'];
    displayName = json['DisplayName'];
    divisionCode = json['DivisionCode'];
    plantCode = json['PlantCode'];
    organizationCode = json['OrganizationCode'];
    departmentCode = json['DepartmentCode'];
    dateTime1 = json['DateTime1'];
    dateTime2 = json['DateTime2'];
    region = json['Region'];
    jobCode = json['JobCode'];
    externalEmployeeID = json['ExternalEmployeeID'];
    externalLoginID = json['ExternalLoginID'];
    passwordExpiryDays = json['PasswordExpiryDays'];
    userSite = json['UserSite'];
    dateOfBirth = json['DateOfBirth'];
    gender = json['Gender'];
    highSchool = json['HighSchool'];
    college = json['College'];
    highestDegree = json['HighestDegree'];
    businessFunction = json['BusinessFunction'];
    primaryJobFunction = json['PrimaryJobFunction'];
    nvarchar6 = json['Nvarchar6'];
    nvarchar7 = json['Nvarchar7'];
    nvarchar8 = json['Nvarchar8'];
    nvarchar9 = json['Nvarchar9'];
    nvarchar10 = json['Nvarchar10'];
    isExpert = json['IsExpert'];
    paymentMode = json['PaymentMode'];
    approvalStatus = json['ApprovalStatus'];
    bit1 = json['Bit1'];
    bit2 = json['Bit2'];
    bit3 = json['Bit3'];
    supervisorEmployeeID = json['SupervisorEmployeeID'];
    nvarchar5 = json['Nvarchar5'];
    securePaypalID = json['SecurePaypalID'];
    payeeAccountNo = json['PayeeAccountNo'];
    payeeName = json['PayeeName'];
    payPalEmail = json['PayPalEmail'];
    shipAddLine1 = json['ShipAddLine1'];
    payPalAccountName = json['PayPalAccountName'];
    shipAddCity = json['ShipAddCity'];
    shipAddState = json['ShipAddState'];
    shipAddZip = json['ShipAddZip'];
    shipAddCountry = json['ShipAddCountry'];
    shipAddPhone = json['ShipAddPhone'];
    address = json['Address'];
    description = json['Description'];
    datetime5 = json['Datetime5'];
    socialNetworkID = json['SocialNetworkID'];
    socialNetworkURL = json['SocialNetworkURL'];
    nvarchar11 = json['Nvarchar11'];
    nvarchar12 = json['Nvarchar12'];
    nvarchar13 = json['Nvarchar13'];
    nvarchar14 = json['Nvarchar14'];
    lastVisited = json['LastVisited'];
    isPragenter = json['IsPragenter'];
    companySize = json['CompanySize'];
    evaluator1 = json['Evaluator1'];
    evaluator2 = json['Evaluator2'];
    dateOfJoin = json['DateOfJoin'];
    facebookID = json['FacebookID'];
    googlePlusID = json['GooglePlusID'];
    linkedInID = json['LinkedInID'];
    twitterID = json['TwitterID'];
    tumblrID = json['TumblrID'];
    source = json['Source'];
    nvarchar15 = json['Nvarchar15'];
    nvarchar16 = json['Nvarchar16'];
    nvarchar17 = json['Nvarchar17'];
    nvarchar18 = json['Nvarchar18'];
    nvarchar19 = json['Nvarchar19'];
    nvarchar20 = json['Nvarchar20'];
    languageSelection = json['LanguageSelection'];
    age = json['Age'];
    licenceno = json['Licenceno'];
    billingAddLine1 = json['BillingAddLine1'];
    billingAddLine2 = json['BillingAddLine2'];
    billingAddLine3 = json['BillingAddLine3'];
    billingAddCity = json['BillingAddCity'];
    billingAddState = json['BillingAddState'];
    billingAddCountry = json['BillingAddCountry'];
    billingAddZip = json['BillingAddZip'];
    externalType = json['ExternalType'];
    nvarchar4 = json['Nvarchar4'];
    nvarchar1 = json['Nvarchar1'];
    nvarchar2 = json['Nvarchar2'];
    nvarchar3 = json['Nvarchar3'];
    userLanguage = json['UserLanguage'];
    workingHoursStartTime = json['WorkingHoursStartTime'];
    workingHoursEndTime = json['WorkingHoursEndTime'];
    uID = json['UID'];
    nvarchar101 = json['Nvarchar101'];
    nvarchar102 = json['Nvarchar102'];
    nvarchar103 = json['Nvarchar103'];
    nvarchar104 = json['Nvarchar104'];
    nvarchar105 = json['Nvarchar105'];
    nvarchar106 = json['Nvarchar106'];
    nvarchar107 = json['Nvarchar107'];
    nvarchar108 = json['Nvarchar108'];
    nvarchar109 = json['Nvarchar109'];
    nvarchar110 = json['Nvarchar110'];
    nvarchar111 = json['Nvarchar111'];
    nvarchar112 = json['Nvarchar112'];
    nvarchar113 = json['Nvarchar113'];
    nvarchar114 = json['Nvarchar114'];
    nvarchar115 = json['Nvarchar115'];
    nvarchar116 = json['Nvarchar116'];
    nvarchar117 = json['Nvarchar117'];
    nvarchar118 = json['Nvarchar118'];
    nvarchar119 = json['Nvarchar119'];
    nvarchar120 = json['Nvarchar120'];
    nvarchar121 = json['Nvarchar121'];
    nvarchar122 = json['Nvarchar122'];
    nvarchar123 = json['Nvarchar123'];
    nvarchar124 = json['Nvarchar124'];
    nvarchar125 = json['Nvarchar125'];
    nvarchar126 = json['Nvarchar126'];
    nvarchar127 = json['Nvarchar127'];
    nvarchar128 = json['Nvarchar128'];
    nvarchar129 = json['Nvarchar129'];
    nvarchar130 = json['Nvarchar130'];
    nvarchar131 = json['Nvarchar131'];
    nvarchar132 = json['Nvarchar132'];
    nvarchar133 = json['Nvarchar133'];
    nvarchar134 = json['Nvarchar134'];
    nvarchar135 = json['Nvarchar135'];
    nvarchar136 = json['Nvarchar136'];
    nvarchar137 = json['Nvarchar137'];
    nvarchar138 = json['Nvarchar138'];
    nvarchar139 = json['Nvarchar139'];
    nvarchar140 = json['Nvarchar140'];
    nvarchar141 = json['Nvarchar141'];
    nvarchar142 = json['Nvarchar142'];
    nvarchar143 = json['Nvarchar143'];
    nvarchar144 = json['Nvarchar144'];
    nvarchar145 = json['Nvarchar145'];
    nvarchar146 = json['Nvarchar146'];
    nvarchar147 = json['Nvarchar147'];
    nvarchar148 = json['Nvarchar148'];
    nvarchar149 = json['Nvarchar149'];
    nvarchar150 = json['Nvarchar150'];
    nvarchar151 = json['Nvarchar151'];
    nvarchar152 = json['Nvarchar152'];
    nvarchar153 = json['Nvarchar153'];
    nvarchar154 = json['Nvarchar154'];
    nvarchar155 = json['Nvarchar155'];
    nvarchar156 = json['Nvarchar156'];
    nvarchar157 = json['Nvarchar157'];
    nvarchar158 = json['Nvarchar158'];
    nvarchar159 = json['Nvarchar159'];
    nvarchar160 = json['Nvarchar160'];
    nvarchar161 = json['Nvarchar161'];
    nvarchar162 = json['Nvarchar162'];
    nvarchar163 = json['Nvarchar163'];
    nvarchar164 = json['Nvarchar164'];
    nvarchar165 = json['Nvarchar165'];
    nvarchar166 = json['Nvarchar166'];
    nvarchar167 = json['Nvarchar167'];
    nvarchar168 = json['Nvarchar168'];
    nvarchar169 = json['Nvarchar169'];
    nvarchar170 = json['Nvarchar170'];
    nvarchar171 = json['Nvarchar171'];
    nvarchar172 = json['Nvarchar172'];
    nvarchar173 = json['Nvarchar173'];
    nvarchar174 = json['Nvarchar174'];
    nvarchar175 = json['Nvarchar175'];
    nvarchar176 = json['Nvarchar176'];
    nvarchar177 = json['Nvarchar177'];
    nvarchar178 = json['Nvarchar178'];
    nvarchar179 = json['Nvarchar179'];
    nvarchar180 = json['Nvarchar180'];
    nvarchar181 = json['Nvarchar181'];
    nvarchar182 = json['Nvarchar182'];
    nvarchar183 = json['Nvarchar183'];
    nvarchar184 = json['Nvarchar184'];
    nvarchar185 = json['Nvarchar185'];
    nvarchar186 = json['Nvarchar186'];
    nvarchar187 = json['Nvarchar187'];
    nvarchar188 = json['Nvarchar188'];
    nvarchar189 = json['Nvarchar189'];
    nvarchar190 = json['Nvarchar190'];
    nvarchar191 = json['Nvarchar191'];
    nvarchar192 = json['Nvarchar192'];
    nvarchar193 = json['Nvarchar193'];
    nvarchar194 = json['Nvarchar194'];
    nvarchar195 = json['Nvarchar195'];
    nvarchar196 = json['Nvarchar196'];
    nvarchar197 = json['Nvarchar197'];
    nvarchar198 = json['Nvarchar198'];
    nvarchar199 = json['Nvarchar199'];
    nvarchar200 = json['Nvarchar200'];
    nvarchar201 = json['Nvarchar201'];
    nvarchar202 = json['Nvarchar202'];
    nvarchar203 = json['Nvarchar203'];
    nvarchar204 = json['Nvarchar204'];
    nvarchar205 = json['Nvarchar205'];
    nvarchar206 = json['Nvarchar206'];
    nvarchar207 = json['Nvarchar207'];
    nvarchar208 = json['Nvarchar208'];
    nvarchar209 = json['Nvarchar209'];
    nvarchar210 = json['Nvarchar210'];
    nvarchar211 = json['Nvarchar211'];
    nvarchar212 = json['Nvarchar212'];
    nvarchar213 = json['Nvarchar213'];
    nvarchar214 = json['Nvarchar214'];
    nvarchar215 = json['Nvarchar215'];
    nvarchar216 = json['Nvarchar216'];
    nvarchar217 = json['Nvarchar217'];
    nvarchar218 = json['Nvarchar218'];
    nvarchar219 = json['Nvarchar219'];
    nvarchar220 = json['Nvarchar220'];
    nvarchar221 = json['Nvarchar221'];
    nvarchar222 = json['Nvarchar222'];
    nvarchar223 = json['Nvarchar223'];
    nvarchar224 = json['Nvarchar224'];
    nvarchar225 = json['Nvarchar225'];
    nvarchar226 = json['Nvarchar226'];
    nvarchar227 = json['Nvarchar227'];
    nvarchar228 = json['Nvarchar228'];
    nvarchar229 = json['Nvarchar229'];
    nvarchar230 = json['Nvarchar230'];
    nvarchar231 = json['Nvarchar231'];
    nvarchar232 = json['Nvarchar232'];
    nvarchar233 = json['Nvarchar233'];
    nvarchar234 = json['Nvarchar234'];
    nvarchar235 = json['Nvarchar235'];
    nvarchar236 = json['Nvarchar236'];
    nvarchar237 = json['Nvarchar237'];
    nvarchar238 = json['Nvarchar238'];
    nvarchar239 = json['Nvarchar239'];
    nvarchar240 = json['Nvarchar240'];
    nvarchar241 = json['Nvarchar241'];
    nvarchar242 = json['Nvarchar242'];
    nvarchar243 = json['Nvarchar243'];
    nvarchar244 = json['Nvarchar244'];
    nvarchar245 = json['Nvarchar245'];
    nvarchar246 = json['Nvarchar246'];
    nvarchar247 = json['Nvarchar247'];
    nvarchar248 = json['Nvarchar248'];
    nvarchar249 = json['Nvarchar249'];
    nvarchar250 = json['Nvarchar250'];
    nvarchar251 = json['Nvarchar251'];
    nvarchar252 = json['Nvarchar252'];
    nvarchar253 = json['Nvarchar253'];
    nvarchar254 = json['Nvarchar254'];
    nvarchar255 = json['Nvarchar255'];
    nvarchar256 = json['Nvarchar256'];
    nvarchar257 = json['Nvarchar257'];
    nvarchar258 = json['Nvarchar258'];
    nvarchar259 = json['Nvarchar259'];
    nvarchar260 = json['Nvarchar260'];
    nvarchar261 = json['Nvarchar261'];
    nvarchar262 = json['Nvarchar262'];
    nvarchar263 = json['Nvarchar263'];
    nvarchar264 = json['Nvarchar264'];
    nvarchar265 = json['Nvarchar265'];
    nvarchar266 = json['Nvarchar266'];
    nvarchar267 = json['Nvarchar267'];
    nvarchar268 = json['Nvarchar268'];
    nvarchar269 = json['Nvarchar269'];
    nvarchar270 = json['Nvarchar270'];
    nvarchar271 = json['Nvarchar271'];
    nvarchar272 = json['Nvarchar272'];
    nvarchar273 = json['Nvarchar273'];
    nvarchar274 = json['Nvarchar274'];
    nvarchar275 = json['Nvarchar275'];
    nvarchar276 = json['Nvarchar276'];
    nvarchar277 = json['Nvarchar277'];
    nvarchar278 = json['Nvarchar278'];
    nvarchar279 = json['Nvarchar279'];
    nvarchar280 = json['Nvarchar280'];
    nvarchar281 = json['Nvarchar281'];
    nvarchar282 = json['Nvarchar282'];
    nvarchar283 = json['Nvarchar283'];
    nvarchar284 = json['Nvarchar284'];
    nvarchar285 = json['Nvarchar285'];
    nvarchar286 = json['Nvarchar286'];
    nvarchar287 = json['Nvarchar287'];
    nvarchar288 = json['Nvarchar288'];
    nvarchar289 = json['Nvarchar289'];
    nvarchar290 = json['Nvarchar290'];
    nvarchar291 = json['Nvarchar291'];
    nvarchar292 = json['Nvarchar292'];
    nvarchar293 = json['Nvarchar293'];
    nvarchar294 = json['Nvarchar294'];
    nvarchar295 = json['Nvarchar295'];
    nvarchar296 = json['Nvarchar296'];
    nvarchar297 = json['Nvarchar297'];
    nvarchar298 = json['Nvarchar298'];
    nvarchar299 = json['Nvarchar299'];
    nvarchar300 = json['Nvarchar300'];
    nvarchar301 = json['Nvarchar301'];
    nvarchar302 = json['Nvarchar302'];
    nvarchar303 = json['Nvarchar303'];
    nvarchar304 = json['Nvarchar304'];
    nvarchar305 = json['Nvarchar305'];
    nvarchar306 = json['Nvarchar306'];
    nvarchar307 = json['Nvarchar307'];
    nvarchar308 = json['Nvarchar308'];
    nvarchar309 = json['Nvarchar309'];
    nvarchar310 = json['Nvarchar310'];
    nvarchar311 = json['Nvarchar311'];
    nvarchar312 = json['Nvarchar312'];
    nvarchar313 = json['Nvarchar313'];
    nvarchar314 = json['Nvarchar314'];
    nvarchar315 = json['Nvarchar315'];
    nvarchar316 = json['Nvarchar316'];
    nvarchar317 = json['Nvarchar317'];
    nvarchar318 = json['Nvarchar318'];
    nvarchar319 = json['Nvarchar319'];
    nvarchar320 = json['Nvarchar320'];
    nvarchar321 = json['Nvarchar321'];
    nvarchar322 = json['Nvarchar322'];
    nvarchar323 = json['Nvarchar323'];
    nvarchar324 = json['Nvarchar324'];
    nvarchar325 = json['Nvarchar325'];
    nvarchar326 = json['Nvarchar326'];
    nvarchar327 = json['Nvarchar327'];
    nvarchar328 = json['Nvarchar328'];
    nvarchar329 = json['Nvarchar329'];
    nvarchar330 = json['Nvarchar330'];
    nvarchar331 = json['Nvarchar331'];
    nvarchar332 = json['Nvarchar332'];
    nvarchar333 = json['Nvarchar333'];
    nvarchar334 = json['Nvarchar334'];
    nvarchar335 = json['Nvarchar335'];
    nvarchar336 = json['Nvarchar336'];
    nvarchar337 = json['Nvarchar337'];
    nvarchar338 = json['Nvarchar338'];
    nvarchar339 = json['Nvarchar339'];
    nvarchar340 = json['Nvarchar340'];
    nvarchar341 = json['Nvarchar341'];
    nvarchar342 = json['Nvarchar342'];
    nvarchar343 = json['Nvarchar343'];
    nvarchar344 = json['Nvarchar344'];
    nvarchar345 = json['Nvarchar345'];
    nvarchar346 = json['Nvarchar346'];
    nvarchar347 = json['Nvarchar347'];
    nvarchar348 = json['Nvarchar348'];
    nvarchar349 = json['Nvarchar349'];
    nvarchar350 = json['Nvarchar350'];
    uniqueUserID = json['UniqueUserID'];
    isClarizenUser = json['IsClarizenUser'];
    slackUserName = json['SlackUserName'];
    backgroundPicture = json['BackgroundPicture'];
    showLRSActivities = json['ShowLRSActivities'];
    instagramID = json['InstagramID'];
    jobRoleID = json['JobRoleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrgUnitID'] = this.orgUnitID;
    data['OriginalSiteID'] = this.originalSiteID;
    data['SiteID'] = this.siteID;
    data['OrgName'] = this.orgName;
    data['FirstName'] = this.firstName;
    data['MiddleName'] = this.middleName;
    data['UserID'] = this.userID;
    data['LastName'] = this.lastName;
    data['Login'] = this.login;
    data['AccountType'] = this.accountType;
    data['SubscriptionStartDate'] = this.subscriptionStartDate;
    data['SubscriptionEndDate'] = this.subscriptionEndDate;
    data['Prefix'] = this.prefix;
    data['Suffix'] = this.suffix;
    data['Identification'] = this.identification;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Fax'] = this.fax;
    data['MobilePhone'] = this.mobilePhone;
    data['IMAddress'] = this.iMAddress;
    data['Addressline1'] = this.addressline1;
    data['Addressline2'] = this.addressline2;
    data['AddressCity'] = this.addressCity;
    data['AddressState'] = this.addressState;
    data['AddressZip'] = this.addressZip;
    data['AddressCountry'] = this.addressCountry;
    data['JobTitle'] = this.jobTitle;
    data['SocialSecurity'] = this.socialSecurity;
    data['Organization'] = this.organization;
    data['TimeZone'] = this.timeZone;
    data['Roles'] = this.roles;
    data['Active'] = this.active;
    data['UserStatus'] = this.userStatus;
    data['CreatedDateTime'] = this.createdDateTime;
    data['ModifiedDateTime'] = this.modifiedDateTime;
    data['Password'] = this.password;
    data['AccountExpiryDate'] = this.accountExpiryDate;
    data['AccountStartDate'] = this.accountStartDate;
    data['ExternalID'] = this.externalID;
    data['Picture'] = this.picture;
    data['BigInt2'] = this.bigInt2;
    data['BigInt1'] = this.bigInt1;
    data['CLASS'] = this.cLASS;
    data['SubscriptionsCount'] = this.subscriptionsCount;
    data['CustomerCode'] = this.customerCode;
    data['SalesRepCode'] = this.salesRepCode;
    data['TypeSubType'] = this.typeSubType;
    data['Locked'] = this.locked;
    data['SelfRegistrationRoles'] = this.selfRegistrationRoles;
    data['AreaCode'] = this.areaCode;
    data['DisplayName'] = this.displayName;
    data['DivisionCode'] = this.divisionCode;
    data['PlantCode'] = this.plantCode;
    data['OrganizationCode'] = this.organizationCode;
    data['DepartmentCode'] = this.departmentCode;
    data['DateTime1'] = this.dateTime1;
    data['DateTime2'] = this.dateTime2;
    data['Region'] = this.region;
    data['JobCode'] = this.jobCode;
    data['ExternalEmployeeID'] = this.externalEmployeeID;
    data['ExternalLoginID'] = this.externalLoginID;
    data['PasswordExpiryDays'] = this.passwordExpiryDays;
    data['UserSite'] = this.userSite;
    data['DateOfBirth'] = this.dateOfBirth;
    data['Gender'] = this.gender;
    data['HighSchool'] = this.highSchool;
    data['College'] = this.college;
    data['HighestDegree'] = this.highestDegree;
    data['BusinessFunction'] = this.businessFunction;
    data['PrimaryJobFunction'] = this.primaryJobFunction;
    data['Nvarchar6'] = this.nvarchar6;
    data['Nvarchar7'] = this.nvarchar7;
    data['Nvarchar8'] = this.nvarchar8;
    data['Nvarchar9'] = this.nvarchar9;
    data['Nvarchar10'] = this.nvarchar10;
    data['IsExpert'] = this.isExpert;
    data['PaymentMode'] = this.paymentMode;
    data['ApprovalStatus'] = this.approvalStatus;
    data['Bit1'] = this.bit1;
    data['Bit2'] = this.bit2;
    data['Bit3'] = this.bit3;
    data['SupervisorEmployeeID'] = this.supervisorEmployeeID;
    data['Nvarchar5'] = this.nvarchar5;
    data['SecurePaypalID'] = this.securePaypalID;
    data['PayeeAccountNo'] = this.payeeAccountNo;
    data['PayeeName'] = this.payeeName;
    data['PayPalEmail'] = this.payPalEmail;
    data['ShipAddLine1'] = this.shipAddLine1;
    data['PayPalAccountName'] = this.payPalAccountName;
    data['ShipAddCity'] = this.shipAddCity;
    data['ShipAddState'] = this.shipAddState;
    data['ShipAddZip'] = this.shipAddZip;
    data['ShipAddCountry'] = this.shipAddCountry;
    data['ShipAddPhone'] = this.shipAddPhone;
    data['Address'] = this.address;
    data['Description'] = this.description;
    data['Datetime5'] = this.datetime5;
    data['SocialNetworkID'] = this.socialNetworkID;
    data['SocialNetworkURL'] = this.socialNetworkURL;
    data['Nvarchar11'] = this.nvarchar11;
    data['Nvarchar12'] = this.nvarchar12;
    data['Nvarchar13'] = this.nvarchar13;
    data['Nvarchar14'] = this.nvarchar14;
    data['LastVisited'] = this.lastVisited;
    data['IsPragenter'] = this.isPragenter;
    data['CompanySize'] = this.companySize;
    data['Evaluator1'] = this.evaluator1;
    data['Evaluator2'] = this.evaluator2;
    data['DateOfJoin'] = this.dateOfJoin;
    data['FacebookID'] = this.facebookID;
    data['GooglePlusID'] = this.googlePlusID;
    data['LinkedInID'] = this.linkedInID;
    data['TwitterID'] = this.twitterID;
    data['TumblrID'] = this.tumblrID;
    data['Source'] = this.source;
    data['Nvarchar15'] = this.nvarchar15;
    data['Nvarchar16'] = this.nvarchar16;
    data['Nvarchar17'] = this.nvarchar17;
    data['Nvarchar18'] = this.nvarchar18;
    data['Nvarchar19'] = this.nvarchar19;
    data['Nvarchar20'] = this.nvarchar20;
    data['LanguageSelection'] = this.languageSelection;
    data['Age'] = this.age;
    data['Licenceno'] = this.licenceno;
    data['BillingAddLine1'] = this.billingAddLine1;
    data['BillingAddLine2'] = this.billingAddLine2;
    data['BillingAddLine3'] = this.billingAddLine3;
    data['BillingAddCity'] = this.billingAddCity;
    data['BillingAddState'] = this.billingAddState;
    data['BillingAddCountry'] = this.billingAddCountry;
    data['BillingAddZip'] = this.billingAddZip;
    data['ExternalType'] = this.externalType;
    data['Nvarchar4'] = this.nvarchar4;
    data['Nvarchar1'] = this.nvarchar1;
    data['Nvarchar2'] = this.nvarchar2;
    data['Nvarchar3'] = this.nvarchar3;
    data['UserLanguage'] = this.userLanguage;
    data['WorkingHoursStartTime'] = this.workingHoursStartTime;
    data['WorkingHoursEndTime'] = this.workingHoursEndTime;
    data['UID'] = this.uID;
    data['Nvarchar101'] = this.nvarchar101;
    data['Nvarchar102'] = this.nvarchar102;
    data['Nvarchar103'] = this.nvarchar103;
    data['Nvarchar104'] = this.nvarchar104;
    data['Nvarchar105'] = this.nvarchar105;
    data['Nvarchar106'] = this.nvarchar106;
    data['Nvarchar107'] = this.nvarchar107;
    data['Nvarchar108'] = this.nvarchar108;
    data['Nvarchar109'] = this.nvarchar109;
    data['Nvarchar110'] = this.nvarchar110;
    data['Nvarchar111'] = this.nvarchar111;
    data['Nvarchar112'] = this.nvarchar112;
    data['Nvarchar113'] = this.nvarchar113;
    data['Nvarchar114'] = this.nvarchar114;
    data['Nvarchar115'] = this.nvarchar115;
    data['Nvarchar116'] = this.nvarchar116;
    data['Nvarchar117'] = this.nvarchar117;
    data['Nvarchar118'] = this.nvarchar118;
    data['Nvarchar119'] = this.nvarchar119;
    data['Nvarchar120'] = this.nvarchar120;
    data['Nvarchar121'] = this.nvarchar121;
    data['Nvarchar122'] = this.nvarchar122;
    data['Nvarchar123'] = this.nvarchar123;
    data['Nvarchar124'] = this.nvarchar124;
    data['Nvarchar125'] = this.nvarchar125;
    data['Nvarchar126'] = this.nvarchar126;
    data['Nvarchar127'] = this.nvarchar127;
    data['Nvarchar128'] = this.nvarchar128;
    data['Nvarchar129'] = this.nvarchar129;
    data['Nvarchar130'] = this.nvarchar130;
    data['Nvarchar131'] = this.nvarchar131;
    data['Nvarchar132'] = this.nvarchar132;
    data['Nvarchar133'] = this.nvarchar133;
    data['Nvarchar134'] = this.nvarchar134;
    data['Nvarchar135'] = this.nvarchar135;
    data['Nvarchar136'] = this.nvarchar136;
    data['Nvarchar137'] = this.nvarchar137;
    data['Nvarchar138'] = this.nvarchar138;
    data['Nvarchar139'] = this.nvarchar139;
    data['Nvarchar140'] = this.nvarchar140;
    data['Nvarchar141'] = this.nvarchar141;
    data['Nvarchar142'] = this.nvarchar142;
    data['Nvarchar143'] = this.nvarchar143;
    data['Nvarchar144'] = this.nvarchar144;
    data['Nvarchar145'] = this.nvarchar145;
    data['Nvarchar146'] = this.nvarchar146;
    data['Nvarchar147'] = this.nvarchar147;
    data['Nvarchar148'] = this.nvarchar148;
    data['Nvarchar149'] = this.nvarchar149;
    data['Nvarchar150'] = this.nvarchar150;
    data['Nvarchar151'] = this.nvarchar151;
    data['Nvarchar152'] = this.nvarchar152;
    data['Nvarchar153'] = this.nvarchar153;
    data['Nvarchar154'] = this.nvarchar154;
    data['Nvarchar155'] = this.nvarchar155;
    data['Nvarchar156'] = this.nvarchar156;
    data['Nvarchar157'] = this.nvarchar157;
    data['Nvarchar158'] = this.nvarchar158;
    data['Nvarchar159'] = this.nvarchar159;
    data['Nvarchar160'] = this.nvarchar160;
    data['Nvarchar161'] = this.nvarchar161;
    data['Nvarchar162'] = this.nvarchar162;
    data['Nvarchar163'] = this.nvarchar163;
    data['Nvarchar164'] = this.nvarchar164;
    data['Nvarchar165'] = this.nvarchar165;
    data['Nvarchar166'] = this.nvarchar166;
    data['Nvarchar167'] = this.nvarchar167;
    data['Nvarchar168'] = this.nvarchar168;
    data['Nvarchar169'] = this.nvarchar169;
    data['Nvarchar170'] = this.nvarchar170;
    data['Nvarchar171'] = this.nvarchar171;
    data['Nvarchar172'] = this.nvarchar172;
    data['Nvarchar173'] = this.nvarchar173;
    data['Nvarchar174'] = this.nvarchar174;
    data['Nvarchar175'] = this.nvarchar175;
    data['Nvarchar176'] = this.nvarchar176;
    data['Nvarchar177'] = this.nvarchar177;
    data['Nvarchar178'] = this.nvarchar178;
    data['Nvarchar179'] = this.nvarchar179;
    data['Nvarchar180'] = this.nvarchar180;
    data['Nvarchar181'] = this.nvarchar181;
    data['Nvarchar182'] = this.nvarchar182;
    data['Nvarchar183'] = this.nvarchar183;
    data['Nvarchar184'] = this.nvarchar184;
    data['Nvarchar185'] = this.nvarchar185;
    data['Nvarchar186'] = this.nvarchar186;
    data['Nvarchar187'] = this.nvarchar187;
    data['Nvarchar188'] = this.nvarchar188;
    data['Nvarchar189'] = this.nvarchar189;
    data['Nvarchar190'] = this.nvarchar190;
    data['Nvarchar191'] = this.nvarchar191;
    data['Nvarchar192'] = this.nvarchar192;
    data['Nvarchar193'] = this.nvarchar193;
    data['Nvarchar194'] = this.nvarchar194;
    data['Nvarchar195'] = this.nvarchar195;
    data['Nvarchar196'] = this.nvarchar196;
    data['Nvarchar197'] = this.nvarchar197;
    data['Nvarchar198'] = this.nvarchar198;
    data['Nvarchar199'] = this.nvarchar199;
    data['Nvarchar200'] = this.nvarchar200;
    data['Nvarchar201'] = this.nvarchar201;
    data['Nvarchar202'] = this.nvarchar202;
    data['Nvarchar203'] = this.nvarchar203;
    data['Nvarchar204'] = this.nvarchar204;
    data['Nvarchar205'] = this.nvarchar205;
    data['Nvarchar206'] = this.nvarchar206;
    data['Nvarchar207'] = this.nvarchar207;
    data['Nvarchar208'] = this.nvarchar208;
    data['Nvarchar209'] = this.nvarchar209;
    data['Nvarchar210'] = this.nvarchar210;
    data['Nvarchar211'] = this.nvarchar211;
    data['Nvarchar212'] = this.nvarchar212;
    data['Nvarchar213'] = this.nvarchar213;
    data['Nvarchar214'] = this.nvarchar214;
    data['Nvarchar215'] = this.nvarchar215;
    data['Nvarchar216'] = this.nvarchar216;
    data['Nvarchar217'] = this.nvarchar217;
    data['Nvarchar218'] = this.nvarchar218;
    data['Nvarchar219'] = this.nvarchar219;
    data['Nvarchar220'] = this.nvarchar220;
    data['Nvarchar221'] = this.nvarchar221;
    data['Nvarchar222'] = this.nvarchar222;
    data['Nvarchar223'] = this.nvarchar223;
    data['Nvarchar224'] = this.nvarchar224;
    data['Nvarchar225'] = this.nvarchar225;
    data['Nvarchar226'] = this.nvarchar226;
    data['Nvarchar227'] = this.nvarchar227;
    data['Nvarchar228'] = this.nvarchar228;
    data['Nvarchar229'] = this.nvarchar229;
    data['Nvarchar230'] = this.nvarchar230;
    data['Nvarchar231'] = this.nvarchar231;
    data['Nvarchar232'] = this.nvarchar232;
    data['Nvarchar233'] = this.nvarchar233;
    data['Nvarchar234'] = this.nvarchar234;
    data['Nvarchar235'] = this.nvarchar235;
    data['Nvarchar236'] = this.nvarchar236;
    data['Nvarchar237'] = this.nvarchar237;
    data['Nvarchar238'] = this.nvarchar238;
    data['Nvarchar239'] = this.nvarchar239;
    data['Nvarchar240'] = this.nvarchar240;
    data['Nvarchar241'] = this.nvarchar241;
    data['Nvarchar242'] = this.nvarchar242;
    data['Nvarchar243'] = this.nvarchar243;
    data['Nvarchar244'] = this.nvarchar244;
    data['Nvarchar245'] = this.nvarchar245;
    data['Nvarchar246'] = this.nvarchar246;
    data['Nvarchar247'] = this.nvarchar247;
    data['Nvarchar248'] = this.nvarchar248;
    data['Nvarchar249'] = this.nvarchar249;
    data['Nvarchar250'] = this.nvarchar250;
    data['Nvarchar251'] = this.nvarchar251;
    data['Nvarchar252'] = this.nvarchar252;
    data['Nvarchar253'] = this.nvarchar253;
    data['Nvarchar254'] = this.nvarchar254;
    data['Nvarchar255'] = this.nvarchar255;
    data['Nvarchar256'] = this.nvarchar256;
    data['Nvarchar257'] = this.nvarchar257;
    data['Nvarchar258'] = this.nvarchar258;
    data['Nvarchar259'] = this.nvarchar259;
    data['Nvarchar260'] = this.nvarchar260;
    data['Nvarchar261'] = this.nvarchar261;
    data['Nvarchar262'] = this.nvarchar262;
    data['Nvarchar263'] = this.nvarchar263;
    data['Nvarchar264'] = this.nvarchar264;
    data['Nvarchar265'] = this.nvarchar265;
    data['Nvarchar266'] = this.nvarchar266;
    data['Nvarchar267'] = this.nvarchar267;
    data['Nvarchar268'] = this.nvarchar268;
    data['Nvarchar269'] = this.nvarchar269;
    data['Nvarchar270'] = this.nvarchar270;
    data['Nvarchar271'] = this.nvarchar271;
    data['Nvarchar272'] = this.nvarchar272;
    data['Nvarchar273'] = this.nvarchar273;
    data['Nvarchar274'] = this.nvarchar274;
    data['Nvarchar275'] = this.nvarchar275;
    data['Nvarchar276'] = this.nvarchar276;
    data['Nvarchar277'] = this.nvarchar277;
    data['Nvarchar278'] = this.nvarchar278;
    data['Nvarchar279'] = this.nvarchar279;
    data['Nvarchar280'] = this.nvarchar280;
    data['Nvarchar281'] = this.nvarchar281;
    data['Nvarchar282'] = this.nvarchar282;
    data['Nvarchar283'] = this.nvarchar283;
    data['Nvarchar284'] = this.nvarchar284;
    data['Nvarchar285'] = this.nvarchar285;
    data['Nvarchar286'] = this.nvarchar286;
    data['Nvarchar287'] = this.nvarchar287;
    data['Nvarchar288'] = this.nvarchar288;
    data['Nvarchar289'] = this.nvarchar289;
    data['Nvarchar290'] = this.nvarchar290;
    data['Nvarchar291'] = this.nvarchar291;
    data['Nvarchar292'] = this.nvarchar292;
    data['Nvarchar293'] = this.nvarchar293;
    data['Nvarchar294'] = this.nvarchar294;
    data['Nvarchar295'] = this.nvarchar295;
    data['Nvarchar296'] = this.nvarchar296;
    data['Nvarchar297'] = this.nvarchar297;
    data['Nvarchar298'] = this.nvarchar298;
    data['Nvarchar299'] = this.nvarchar299;
    data['Nvarchar300'] = this.nvarchar300;
    data['Nvarchar301'] = this.nvarchar301;
    data['Nvarchar302'] = this.nvarchar302;
    data['Nvarchar303'] = this.nvarchar303;
    data['Nvarchar304'] = this.nvarchar304;
    data['Nvarchar305'] = this.nvarchar305;
    data['Nvarchar306'] = this.nvarchar306;
    data['Nvarchar307'] = this.nvarchar307;
    data['Nvarchar308'] = this.nvarchar308;
    data['Nvarchar309'] = this.nvarchar309;
    data['Nvarchar310'] = this.nvarchar310;
    data['Nvarchar311'] = this.nvarchar311;
    data['Nvarchar312'] = this.nvarchar312;
    data['Nvarchar313'] = this.nvarchar313;
    data['Nvarchar314'] = this.nvarchar314;
    data['Nvarchar315'] = this.nvarchar315;
    data['Nvarchar316'] = this.nvarchar316;
    data['Nvarchar317'] = this.nvarchar317;
    data['Nvarchar318'] = this.nvarchar318;
    data['Nvarchar319'] = this.nvarchar319;
    data['Nvarchar320'] = this.nvarchar320;
    data['Nvarchar321'] = this.nvarchar321;
    data['Nvarchar322'] = this.nvarchar322;
    data['Nvarchar323'] = this.nvarchar323;
    data['Nvarchar324'] = this.nvarchar324;
    data['Nvarchar325'] = this.nvarchar325;
    data['Nvarchar326'] = this.nvarchar326;
    data['Nvarchar327'] = this.nvarchar327;
    data['Nvarchar328'] = this.nvarchar328;
    data['Nvarchar329'] = this.nvarchar329;
    data['Nvarchar330'] = this.nvarchar330;
    data['Nvarchar331'] = this.nvarchar331;
    data['Nvarchar332'] = this.nvarchar332;
    data['Nvarchar333'] = this.nvarchar333;
    data['Nvarchar334'] = this.nvarchar334;
    data['Nvarchar335'] = this.nvarchar335;
    data['Nvarchar336'] = this.nvarchar336;
    data['Nvarchar337'] = this.nvarchar337;
    data['Nvarchar338'] = this.nvarchar338;
    data['Nvarchar339'] = this.nvarchar339;
    data['Nvarchar340'] = this.nvarchar340;
    data['Nvarchar341'] = this.nvarchar341;
    data['Nvarchar342'] = this.nvarchar342;
    data['Nvarchar343'] = this.nvarchar343;
    data['Nvarchar344'] = this.nvarchar344;
    data['Nvarchar345'] = this.nvarchar345;
    data['Nvarchar346'] = this.nvarchar346;
    data['Nvarchar347'] = this.nvarchar347;
    data['Nvarchar348'] = this.nvarchar348;
    data['Nvarchar349'] = this.nvarchar349;
    data['Nvarchar350'] = this.nvarchar350;
    data['UniqueUserID'] = this.uniqueUserID;
    data['IsClarizenUser'] = this.isClarizenUser;
    data['SlackUserName'] = this.slackUserName;
    data['BackgroundPicture'] = this.backgroundPicture;
    data['ShowLRSActivities'] = this.showLRSActivities;
    data['InstagramID'] = this.instagramID;
    data['JobRoleID'] = this.jobRoleID;
    return data;
  }
}*/

class UpVotesUsers {
  int likeID;
  bool isLiked;
  int userID;
  String objectID;
  String picture;
  String userName;
  String jobTitle;

  UpVotesUsers(
      {this.likeID = 0,
      this.isLiked = false,
      this.userID = 0,
      this.objectID = "",
      this.picture = "",
      this.userName = "",
      this.jobTitle = ""});

  static UpVotesUsers fromJson(Map<String, dynamic> json) {
    UpVotesUsers upVotesUsers = UpVotesUsers();
    upVotesUsers.likeID = json['LikeID'] ?? 0;
    upVotesUsers.isLiked = json['IsLiked'] ?? false;
    upVotesUsers.userID = json['UserID'] ?? 0;
    upVotesUsers.objectID = json['ObjectID'] ?? "";
    upVotesUsers.picture = json['Picture'] ?? "";
    upVotesUsers.userName = json['UserName'] ?? "";
    upVotesUsers.jobTitle = json['JobTitle'] ?? "";
    return upVotesUsers;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LikeID'] = this.likeID;
    data['IsLiked'] = this.isLiked;
    data['UserID'] = this.userID;
    data['ObjectID'] = this.objectID;
    data['Picture'] = this.picture;
    data['UserName'] = this.userName;
    data['JobTitle'] = this.jobTitle;
    return data;
  }
}
