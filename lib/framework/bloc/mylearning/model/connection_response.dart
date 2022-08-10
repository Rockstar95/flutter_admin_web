// To parse this JSON data, do
//
//     final connectionResponse = connectionResponseFromJson(jsonString);

import 'dart:convert';

ConnectionResponse connectionResponseFromJson(String str) =>
    ConnectionResponse.fromJson(json.decode(str));

String connectionResponseToJson(ConnectionResponse data) =>
    json.encode(data.toJson());

class ConnectionResponse {
  ConnectionResponse({
    required this.table,
  });

  List<ConnectionElement> table;

  factory ConnectionResponse.fromJson(Map<String, dynamic> json) =>
      ConnectionResponse(
        table: json["Table"] == null
            ? []
            : List<ConnectionElement>.from(
                json["Table"].map((x) => ConnectionElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": table == null
            ? null
            : List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class ConnectionElement {
  ConnectionElement({
    this.userName = "",
    this.orgUnitId = 0,
    this.originalSiteId = 0,
    this.siteId = 0,
    this.orgName = "",
    this.firstName = "",
    this.middleName,
    this.userId = 0,
    this.lastName = "",
    this.login = "",
    this.accountType = 0,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.prefix,
    this.suffix,
    this.identification,
    this.email = "",
    this.phone,
    this.fax,
    this.mobilePhone,
    this.imAddress,
    this.addressline1,
    this.addressline2,
    this.addressCity,
    this.addressState,
    this.addressZip,
    this.addressCountry,
    this.jobTitle,
    this.socialSecurity,
    this.organization,
    this.timeZone = "",
    this.roles = "",
    this.active = false,
    this.userStatus = 0,
    this.createdDateTime,
    this.modifiedDateTime,
    this.password = "",
    this.accountExpiryDate,
    this.accountStartDate,
    this.externalId,
    this.picture = "",
    this.bigInt2 = 0,
    this.bigInt1 = 0,
    this.tableClass,
    this.subscriptionsCount = 0,
    this.customerCode,
    this.salesRepCode,
    this.typeSubType,
    this.locked = 0,
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
    this.externalEmployeeId,
    this.externalLoginId,
    this.passwordExpiryDays = 0,
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
    this.isExpert = false,
    this.paymentMode,
    this.approvalStatus,
    this.bit1 = false,
    this.bit2 = false,
    this.bit3 = false,
    this.supervisorEmployeeId,
    this.nvarchar5,
    this.securePaypalId,
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
    this.address = "",
    this.description,
    this.datetime5,
    this.socialNetworkId,
    this.socialNetworkUrl,
    this.nvarchar11,
    this.nvarchar12,
    this.nvarchar13,
    this.nvarchar14,
    this.lastVisited,
    this.isPragenter = false,
    this.companySize,
    this.evaluator1,
    this.evaluator2,
    this.dateOfJoin,
    this.facebookId,
    this.googlePlusId,
    this.linkedInId,
    this.twitterId,
    this.tumblrId,
    this.source,
    this.nvarchar15,
    this.nvarchar16,
    this.nvarchar17,
    this.nvarchar18,
    this.nvarchar19,
    this.nvarchar20,
    this.languageSelection = "",
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
    this.userLanguage = "",
    this.workingHoursStartTime = "",
    this.workingHoursEndTime = "",
    this.uid = 0,
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
    this.uniqueUserId,
    this.isClarizenUser = false,
    this.slackUserName,
    this.backgroundPicture,
    this.showLrsActivities = 0,
    this.instagramId,
    this.jobRoleId,
    this.objectId = 0,
    this.usersImage = "",
    this.usersAddressCity = "",
    this.expert,
  });

  String userName;
  int orgUnitId;
  int originalSiteId;
  int siteId;
  String orgName;
  String firstName;
  dynamic middleName;
  int userId;
  String lastName;
  String login;
  int accountType;
  dynamic subscriptionStartDate;
  dynamic subscriptionEndDate;
  dynamic prefix;
  dynamic suffix;
  dynamic identification;
  String email;
  dynamic phone;
  dynamic fax;
  dynamic mobilePhone;
  dynamic imAddress;
  dynamic addressline1;
  dynamic addressline2;
  dynamic addressCity;
  dynamic addressState;
  dynamic addressZip;
  dynamic addressCountry;
  dynamic jobTitle;
  dynamic socialSecurity;
  dynamic organization;
  String timeZone;
  String roles;
  bool active;
  int userStatus;
  DateTime? createdDateTime;
  dynamic modifiedDateTime;
  String password;
  dynamic accountExpiryDate;
  DateTime? accountStartDate;
  dynamic externalId;
  String picture;
  int bigInt2;
  int bigInt1;
  dynamic tableClass;
  int subscriptionsCount;
  dynamic customerCode;
  dynamic salesRepCode;
  dynamic typeSubType;
  int locked;
  dynamic selfRegistrationRoles;
  dynamic areaCode;
  dynamic displayName;
  dynamic divisionCode;
  dynamic plantCode;
  dynamic organizationCode;
  dynamic departmentCode;
  dynamic dateTime1;
  dynamic dateTime2;
  dynamic region;
  dynamic jobCode;
  dynamic externalEmployeeId;
  dynamic externalLoginId;
  int passwordExpiryDays;
  dynamic userSite;
  dynamic dateOfBirth;
  dynamic gender;
  dynamic highSchool;
  dynamic college;
  dynamic highestDegree;
  dynamic businessFunction;
  dynamic primaryJobFunction;
  dynamic nvarchar6;
  dynamic nvarchar7;
  dynamic nvarchar8;
  dynamic nvarchar9;
  dynamic nvarchar10;
  bool isExpert;
  dynamic paymentMode;
  dynamic approvalStatus;
  bool bit1;
  bool bit2;
  bool bit3;
  dynamic supervisorEmployeeId;
  dynamic nvarchar5;
  dynamic securePaypalId;
  dynamic payeeAccountNo;
  dynamic payeeName;
  dynamic payPalEmail;
  dynamic shipAddLine1;
  dynamic payPalAccountName;
  dynamic shipAddCity;
  dynamic shipAddState;
  dynamic shipAddZip;
  dynamic shipAddCountry;
  dynamic shipAddPhone;
  String address;
  dynamic description;
  dynamic datetime5;
  dynamic socialNetworkId;
  dynamic socialNetworkUrl;
  dynamic nvarchar11;
  dynamic nvarchar12;
  dynamic nvarchar13;
  dynamic nvarchar14;
  DateTime? lastVisited;
  bool isPragenter;
  dynamic companySize;
  dynamic evaluator1;
  dynamic evaluator2;
  dynamic dateOfJoin;
  dynamic facebookId;
  dynamic googlePlusId;
  dynamic linkedInId;
  dynamic twitterId;
  dynamic tumblrId;
  dynamic source;
  dynamic nvarchar15;
  dynamic nvarchar16;
  dynamic nvarchar17;
  dynamic nvarchar18;
  dynamic nvarchar19;
  dynamic nvarchar20;
  String languageSelection;
  dynamic age;
  dynamic licenceno;
  dynamic billingAddLine1;
  dynamic billingAddLine2;
  dynamic billingAddLine3;
  dynamic billingAddCity;
  dynamic billingAddState;
  dynamic billingAddCountry;
  dynamic billingAddZip;
  dynamic externalType;
  dynamic nvarchar4;
  dynamic nvarchar1;
  dynamic nvarchar2;
  dynamic nvarchar3;
  String userLanguage;
  String workingHoursStartTime;
  String workingHoursEndTime;
  int uid;
  dynamic nvarchar101;
  dynamic nvarchar102;
  dynamic nvarchar103;
  dynamic nvarchar104;
  dynamic nvarchar105;
  dynamic nvarchar106;
  dynamic nvarchar107;
  dynamic nvarchar108;
  dynamic nvarchar109;
  dynamic nvarchar110;
  dynamic nvarchar111;
  dynamic nvarchar112;
  dynamic nvarchar113;
  dynamic nvarchar114;
  dynamic nvarchar115;
  dynamic nvarchar116;
  dynamic nvarchar117;
  dynamic nvarchar118;
  dynamic nvarchar119;
  dynamic nvarchar120;
  dynamic nvarchar121;
  dynamic nvarchar122;
  dynamic nvarchar123;
  dynamic nvarchar124;
  dynamic nvarchar125;
  dynamic nvarchar126;
  dynamic nvarchar127;
  dynamic nvarchar128;
  dynamic nvarchar129;
  dynamic nvarchar130;
  dynamic nvarchar131;
  dynamic nvarchar132;
  dynamic nvarchar133;
  dynamic nvarchar134;
  dynamic nvarchar135;
  dynamic nvarchar136;
  dynamic nvarchar137;
  dynamic nvarchar138;
  dynamic nvarchar139;
  dynamic nvarchar140;
  dynamic nvarchar141;
  dynamic nvarchar142;
  dynamic nvarchar143;
  dynamic nvarchar144;
  dynamic nvarchar145;
  dynamic nvarchar146;
  dynamic nvarchar147;
  dynamic nvarchar148;
  dynamic nvarchar149;
  dynamic nvarchar150;
  dynamic nvarchar151;
  dynamic nvarchar152;
  dynamic nvarchar153;
  dynamic nvarchar154;
  dynamic nvarchar155;
  dynamic nvarchar156;
  dynamic nvarchar157;
  dynamic nvarchar158;
  dynamic nvarchar159;
  dynamic nvarchar160;
  dynamic nvarchar161;
  dynamic nvarchar162;
  dynamic nvarchar163;
  dynamic nvarchar164;
  dynamic nvarchar165;
  dynamic nvarchar166;
  dynamic nvarchar167;
  dynamic nvarchar168;
  dynamic nvarchar169;
  dynamic nvarchar170;
  dynamic nvarchar171;
  dynamic nvarchar172;
  dynamic nvarchar173;
  dynamic nvarchar174;
  dynamic nvarchar175;
  dynamic nvarchar176;
  dynamic nvarchar177;
  dynamic nvarchar178;
  dynamic nvarchar179;
  dynamic nvarchar180;
  dynamic nvarchar181;
  dynamic nvarchar182;
  dynamic nvarchar183;
  dynamic nvarchar184;
  dynamic nvarchar185;
  dynamic nvarchar186;
  dynamic nvarchar187;
  dynamic nvarchar188;
  dynamic nvarchar189;
  dynamic nvarchar190;
  dynamic nvarchar191;
  dynamic nvarchar192;
  dynamic nvarchar193;
  dynamic nvarchar194;
  dynamic nvarchar195;
  dynamic nvarchar196;
  dynamic nvarchar197;
  dynamic nvarchar198;
  dynamic nvarchar199;
  dynamic nvarchar200;
  dynamic nvarchar201;
  dynamic nvarchar202;
  dynamic nvarchar203;
  dynamic nvarchar204;
  dynamic nvarchar205;
  dynamic nvarchar206;
  dynamic nvarchar207;
  dynamic nvarchar208;
  dynamic nvarchar209;
  dynamic nvarchar210;
  dynamic nvarchar211;
  dynamic nvarchar212;
  dynamic nvarchar213;
  dynamic nvarchar214;
  dynamic nvarchar215;
  dynamic nvarchar216;
  dynamic nvarchar217;
  dynamic nvarchar218;
  dynamic nvarchar219;
  dynamic nvarchar220;
  dynamic nvarchar221;
  dynamic nvarchar222;
  dynamic nvarchar223;
  dynamic nvarchar224;
  dynamic nvarchar225;
  dynamic nvarchar226;
  dynamic nvarchar227;
  dynamic nvarchar228;
  dynamic nvarchar229;
  dynamic nvarchar230;
  dynamic nvarchar231;
  dynamic nvarchar232;
  dynamic nvarchar233;
  dynamic nvarchar234;
  dynamic nvarchar235;
  dynamic nvarchar236;
  dynamic nvarchar237;
  dynamic nvarchar238;
  dynamic nvarchar239;
  dynamic nvarchar240;
  dynamic nvarchar241;
  dynamic nvarchar242;
  dynamic nvarchar243;
  dynamic nvarchar244;
  dynamic nvarchar245;
  dynamic nvarchar246;
  dynamic nvarchar247;
  dynamic nvarchar248;
  dynamic nvarchar249;
  dynamic nvarchar250;
  dynamic nvarchar251;
  dynamic nvarchar252;
  dynamic nvarchar253;
  dynamic nvarchar254;
  dynamic nvarchar255;
  dynamic nvarchar256;
  dynamic nvarchar257;
  dynamic nvarchar258;
  dynamic nvarchar259;
  dynamic nvarchar260;
  dynamic nvarchar261;
  dynamic nvarchar262;
  dynamic nvarchar263;
  dynamic nvarchar264;
  dynamic nvarchar265;
  dynamic nvarchar266;
  dynamic nvarchar267;
  dynamic nvarchar268;
  dynamic nvarchar269;
  dynamic nvarchar270;
  dynamic nvarchar271;
  dynamic nvarchar272;
  dynamic nvarchar273;
  dynamic nvarchar274;
  dynamic nvarchar275;
  dynamic nvarchar276;
  dynamic nvarchar277;
  dynamic nvarchar278;
  dynamic nvarchar279;
  dynamic nvarchar280;
  dynamic nvarchar281;
  dynamic nvarchar282;
  dynamic nvarchar283;
  dynamic nvarchar284;
  dynamic nvarchar285;
  dynamic nvarchar286;
  dynamic nvarchar287;
  dynamic nvarchar288;
  dynamic nvarchar289;
  dynamic nvarchar290;
  dynamic nvarchar291;
  dynamic nvarchar292;
  dynamic nvarchar293;
  dynamic nvarchar294;
  dynamic nvarchar295;
  dynamic nvarchar296;
  dynamic nvarchar297;
  dynamic nvarchar298;
  dynamic nvarchar299;
  dynamic nvarchar300;
  dynamic nvarchar301;
  dynamic nvarchar302;
  dynamic nvarchar303;
  dynamic nvarchar304;
  dynamic nvarchar305;
  dynamic nvarchar306;
  dynamic nvarchar307;
  dynamic nvarchar308;
  dynamic nvarchar309;
  dynamic nvarchar310;
  dynamic nvarchar311;
  dynamic nvarchar312;
  dynamic nvarchar313;
  dynamic nvarchar314;
  dynamic nvarchar315;
  dynamic nvarchar316;
  dynamic nvarchar317;
  dynamic nvarchar318;
  dynamic nvarchar319;
  dynamic nvarchar320;
  dynamic nvarchar321;
  dynamic nvarchar322;
  dynamic nvarchar323;
  dynamic nvarchar324;
  dynamic nvarchar325;
  dynamic nvarchar326;
  dynamic nvarchar327;
  dynamic nvarchar328;
  dynamic nvarchar329;
  dynamic nvarchar330;
  dynamic nvarchar331;
  dynamic nvarchar332;
  dynamic nvarchar333;
  dynamic nvarchar334;
  dynamic nvarchar335;
  dynamic nvarchar336;
  dynamic nvarchar337;
  dynamic nvarchar338;
  dynamic nvarchar339;
  dynamic nvarchar340;
  dynamic nvarchar341;
  dynamic nvarchar342;
  dynamic nvarchar343;
  dynamic nvarchar344;
  dynamic nvarchar345;
  dynamic nvarchar346;
  dynamic nvarchar347;
  dynamic nvarchar348;
  dynamic nvarchar349;
  dynamic nvarchar350;
  dynamic uniqueUserId;
  bool isClarizenUser;
  dynamic slackUserName;
  dynamic backgroundPicture;
  int showLrsActivities;
  dynamic instagramId;
  dynamic jobRoleId;
  int objectId;
  String usersImage;
  String usersAddressCity;
  dynamic expert;

  factory ConnectionElement.fromJson(Map<String, dynamic> json) =>
      ConnectionElement(
        userName: json["UserName"] ?? "",
        orgUnitId: json["OrgUnitID"] ?? 0,
        originalSiteId: json["OriginalSiteID"] ?? 0,
        siteId: json["SiteID"] ?? 0,
        orgName: json["OrgName"] ?? "",
        firstName: json["FirstName"] ?? "",
        middleName: json["MiddleName"],
        userId: json["UserID"] ?? 0,
        lastName: json["LastName"] ?? "",
        login: json["Login"] ?? "",
        accountType: json["AccountType"] ?? 0,
        subscriptionStartDate: json["SubscriptionStartDate"],
        subscriptionEndDate: json["SubscriptionEndDate"],
        prefix: json["Prefix"],
        suffix: json["Suffix"],
        identification: json["Identification"],
        email: json["Email"] ?? "",
        phone: json["Phone"],
        fax: json["Fax"],
        mobilePhone: json["MobilePhone"],
        imAddress: json["IMAddress"],
        addressline1: json["Addressline1"],
        addressline2: json["Addressline2"],
        addressCity: json["AddressCity"],
        addressState: json["AddressState"],
        addressZip: json["AddressZip"],
        addressCountry: json["AddressCountry"],
        jobTitle: json["JobTitle"],
        socialSecurity: json["SocialSecurity"],
        organization: json["Organization"],
        timeZone: json["TimeZone"] ?? "",
        roles: json["Roles"] ?? "",
        active: json["Active"] ?? false,
        userStatus: json["UserStatus"] ?? 0,
        createdDateTime: json["CreatedDateTime"] == null
            ? null
            : DateTime.parse(json["CreatedDateTime"]),
        modifiedDateTime: json["ModifiedDateTime"],
        password: json["Password"] ?? "",
        accountExpiryDate: json["AccountExpiryDate"],
        accountStartDate: json["AccountStartDate"] == null
            ? null
            : DateTime.parse(json["AccountStartDate"]),
        externalId: json["ExternalID"],
        picture: json["Picture"] ?? "",
        bigInt2: json["BigInt2"] ?? 0,
        bigInt1: json["BigInt1"] ?? 0,
        tableClass: json["CLASS"],
        subscriptionsCount: json["SubscriptionsCount"] ?? 0,
        customerCode: json["CustomerCode"],
        salesRepCode: json["SalesRepCode"],
        typeSubType: json["TypeSubType"],
        locked: json["Locked"],
        selfRegistrationRoles: json["SelfRegistrationRoles"],
        areaCode: json["AreaCode"],
        displayName: json["DisplayName"],
        divisionCode: json["DivisionCode"],
        plantCode: json["PlantCode"],
        organizationCode: json["OrganizationCode"],
        departmentCode: json["DepartmentCode"],
        dateTime1: json["DateTime1"],
        dateTime2: json["DateTime2"],
        region: json["Region"],
        jobCode: json["JobCode"],
        externalEmployeeId: json["ExternalEmployeeID"],
        externalLoginId: json["ExternalLoginID"],
        passwordExpiryDays: json["PasswordExpiryDays"] ?? 0,
        userSite: json["UserSite"],
        dateOfBirth: json["DateOfBirth"],
        gender: json["Gender"],
        highSchool: json["HighSchool"],
        college: json["College"],
        highestDegree: json["HighestDegree"],
        businessFunction: json["BusinessFunction"],
        primaryJobFunction: json["PrimaryJobFunction"],
        nvarchar6: json["Nvarchar6"],
        nvarchar7: json["Nvarchar7"],
        nvarchar8: json["Nvarchar8"],
        nvarchar9: json["Nvarchar9"],
        nvarchar10: json["Nvarchar10"],
        isExpert: json["IsExpert"] ?? false,
        paymentMode: json["PaymentMode"],
        approvalStatus: json["ApprovalStatus"],
        bit1: json["Bit1"] ?? false,
        bit2: json["Bit2"] ?? false,
        bit3: json["Bit3"] ?? false,
        supervisorEmployeeId: json["SupervisorEmployeeID"],
        nvarchar5: json["Nvarchar5"],
        securePaypalId: json["SecurePaypalID"],
        payeeAccountNo: json["PayeeAccountNo"],
        payeeName: json["PayeeName"],
        payPalEmail: json["PayPalEmail"],
        shipAddLine1: json["ShipAddLine1"],
        payPalAccountName: json["PayPalAccountName"],
        shipAddCity: json["ShipAddCity"],
        shipAddState: json["ShipAddState"],
        shipAddZip: json["ShipAddZip"],
        shipAddCountry: json["ShipAddCountry"],
        shipAddPhone: json["ShipAddPhone"],
        address: json["Address"] ?? "",
        description: json["Description"],
        datetime5: json["Datetime5"],
        socialNetworkId: json["SocialNetworkID"],
        socialNetworkUrl: json["SocialNetworkURL"],
        nvarchar11: json["Nvarchar11"],
        nvarchar12: json["Nvarchar12"],
        nvarchar13: json["Nvarchar13"],
        nvarchar14: json["Nvarchar14"],
        lastVisited: json["LastVisited"] == null
            ? null
            : DateTime.parse(json["LastVisited"]),
        isPragenter: json["IsPragenter"] ?? false,
        companySize: json["CompanySize"],
        evaluator1: json["Evaluator1"],
        evaluator2: json["Evaluator2"],
        dateOfJoin: json["DateOfJoin"],
        facebookId: json["FacebookID"],
        googlePlusId: json["GooglePlusID"],
        linkedInId: json["LinkedInID"],
        twitterId: json["TwitterID"],
        tumblrId: json["TumblrID"],
        source: json["Source"],
        nvarchar15: json["Nvarchar15"],
        nvarchar16: json["Nvarchar16"],
        nvarchar17: json["Nvarchar17"],
        nvarchar18: json["Nvarchar18"],
        nvarchar19: json["Nvarchar19"],
        nvarchar20: json["Nvarchar20"],
        languageSelection: json["LanguageSelection"] ?? "",
        age: json["Age"],
        licenceno: json["Licenceno"],
        billingAddLine1: json["BillingAddLine1"],
        billingAddLine2: json["BillingAddLine2"],
        billingAddLine3: json["BillingAddLine3"],
        billingAddCity: json["BillingAddCity"],
        billingAddState: json["BillingAddState"],
        billingAddCountry: json["BillingAddCountry"],
        billingAddZip: json["BillingAddZip"],
        externalType: json["ExternalType"],
        nvarchar4: json["Nvarchar4"],
        nvarchar1: json["Nvarchar1"],
        nvarchar2: json["Nvarchar2"],
        nvarchar3: json["Nvarchar3"],
        userLanguage: json["UserLanguage"] ?? "",
        workingHoursStartTime: json["WorkingHoursStartTime"] ?? "",
        workingHoursEndTime: json["WorkingHoursEndTime"] ?? "",
        uid: json["UID"] ?? 0,
        nvarchar101: json["Nvarchar101"],
        nvarchar102: json["Nvarchar102"],
        nvarchar103: json["Nvarchar103"],
        nvarchar104: json["Nvarchar104"],
        nvarchar105: json["Nvarchar105"],
        nvarchar106: json["Nvarchar106"],
        nvarchar107: json["Nvarchar107"],
        nvarchar108: json["Nvarchar108"],
        nvarchar109: json["Nvarchar109"],
        nvarchar110: json["Nvarchar110"],
        nvarchar111: json["Nvarchar111"],
        nvarchar112: json["Nvarchar112"],
        nvarchar113: json["Nvarchar113"],
        nvarchar114: json["Nvarchar114"],
        nvarchar115: json["Nvarchar115"],
        nvarchar116: json["Nvarchar116"],
        nvarchar117: json["Nvarchar117"],
        nvarchar118: json["Nvarchar118"],
        nvarchar119: json["Nvarchar119"],
        nvarchar120: json["Nvarchar120"],
        nvarchar121: json["Nvarchar121"],
        nvarchar122: json["Nvarchar122"],
        nvarchar123: json["Nvarchar123"],
        nvarchar124: json["Nvarchar124"],
        nvarchar125: json["Nvarchar125"],
        nvarchar126: json["Nvarchar126"],
        nvarchar127: json["Nvarchar127"],
        nvarchar128: json["Nvarchar128"],
        nvarchar129: json["Nvarchar129"],
        nvarchar130: json["Nvarchar130"],
        nvarchar131: json["Nvarchar131"],
        nvarchar132: json["Nvarchar132"],
        nvarchar133: json["Nvarchar133"],
        nvarchar134: json["Nvarchar134"],
        nvarchar135: json["Nvarchar135"],
        nvarchar136: json["Nvarchar136"],
        nvarchar137: json["Nvarchar137"],
        nvarchar138: json["Nvarchar138"],
        nvarchar139: json["Nvarchar139"],
        nvarchar140: json["Nvarchar140"],
        nvarchar141: json["Nvarchar141"],
        nvarchar142: json["Nvarchar142"],
        nvarchar143: json["Nvarchar143"],
        nvarchar144: json["Nvarchar144"],
        nvarchar145: json["Nvarchar145"],
        nvarchar146: json["Nvarchar146"],
        nvarchar147: json["Nvarchar147"],
        nvarchar148: json["Nvarchar148"],
        nvarchar149: json["Nvarchar149"],
        nvarchar150: json["Nvarchar150"],
        nvarchar151: json["Nvarchar151"],
        nvarchar152: json["Nvarchar152"],
        nvarchar153: json["Nvarchar153"],
        nvarchar154: json["Nvarchar154"],
        nvarchar155: json["Nvarchar155"],
        nvarchar156: json["Nvarchar156"],
        nvarchar157: json["Nvarchar157"],
        nvarchar158: json["Nvarchar158"],
        nvarchar159: json["Nvarchar159"],
        nvarchar160: json["Nvarchar160"],
        nvarchar161: json["Nvarchar161"],
        nvarchar162: json["Nvarchar162"],
        nvarchar163: json["Nvarchar163"],
        nvarchar164: json["Nvarchar164"],
        nvarchar165: json["Nvarchar165"],
        nvarchar166: json["Nvarchar166"],
        nvarchar167: json["Nvarchar167"],
        nvarchar168: json["Nvarchar168"],
        nvarchar169: json["Nvarchar169"],
        nvarchar170: json["Nvarchar170"],
        nvarchar171: json["Nvarchar171"],
        nvarchar172: json["Nvarchar172"],
        nvarchar173: json["Nvarchar173"],
        nvarchar174: json["Nvarchar174"],
        nvarchar175: json["Nvarchar175"],
        nvarchar176: json["Nvarchar176"],
        nvarchar177: json["Nvarchar177"],
        nvarchar178: json["Nvarchar178"],
        nvarchar179: json["Nvarchar179"],
        nvarchar180: json["Nvarchar180"],
        nvarchar181: json["Nvarchar181"],
        nvarchar182: json["Nvarchar182"],
        nvarchar183: json["Nvarchar183"],
        nvarchar184: json["Nvarchar184"],
        nvarchar185: json["Nvarchar185"],
        nvarchar186: json["Nvarchar186"],
        nvarchar187: json["Nvarchar187"],
        nvarchar188: json["Nvarchar188"],
        nvarchar189: json["Nvarchar189"],
        nvarchar190: json["Nvarchar190"],
        nvarchar191: json["Nvarchar191"],
        nvarchar192: json["Nvarchar192"],
        nvarchar193: json["Nvarchar193"],
        nvarchar194: json["Nvarchar194"],
        nvarchar195: json["Nvarchar195"],
        nvarchar196: json["Nvarchar196"],
        nvarchar197: json["Nvarchar197"],
        nvarchar198: json["Nvarchar198"],
        nvarchar199: json["Nvarchar199"],
        nvarchar200: json["Nvarchar200"],
        nvarchar201: json["Nvarchar201"],
        nvarchar202: json["Nvarchar202"],
        nvarchar203: json["Nvarchar203"],
        nvarchar204: json["Nvarchar204"],
        nvarchar205: json["Nvarchar205"],
        nvarchar206: json["Nvarchar206"],
        nvarchar207: json["Nvarchar207"],
        nvarchar208: json["Nvarchar208"],
        nvarchar209: json["Nvarchar209"],
        nvarchar210: json["Nvarchar210"],
        nvarchar211: json["Nvarchar211"],
        nvarchar212: json["Nvarchar212"],
        nvarchar213: json["Nvarchar213"],
        nvarchar214: json["Nvarchar214"],
        nvarchar215: json["Nvarchar215"],
        nvarchar216: json["Nvarchar216"],
        nvarchar217: json["Nvarchar217"],
        nvarchar218: json["Nvarchar218"],
        nvarchar219: json["Nvarchar219"],
        nvarchar220: json["Nvarchar220"],
        nvarchar221: json["Nvarchar221"],
        nvarchar222: json["Nvarchar222"],
        nvarchar223: json["Nvarchar223"],
        nvarchar224: json["Nvarchar224"],
        nvarchar225: json["Nvarchar225"],
        nvarchar226: json["Nvarchar226"],
        nvarchar227: json["Nvarchar227"],
        nvarchar228: json["Nvarchar228"],
        nvarchar229: json["Nvarchar229"],
        nvarchar230: json["Nvarchar230"],
        nvarchar231: json["Nvarchar231"],
        nvarchar232: json["Nvarchar232"],
        nvarchar233: json["Nvarchar233"],
        nvarchar234: json["Nvarchar234"],
        nvarchar235: json["Nvarchar235"],
        nvarchar236: json["Nvarchar236"],
        nvarchar237: json["Nvarchar237"],
        nvarchar238: json["Nvarchar238"],
        nvarchar239: json["Nvarchar239"],
        nvarchar240: json["Nvarchar240"],
        nvarchar241: json["Nvarchar241"],
        nvarchar242: json["Nvarchar242"],
        nvarchar243: json["Nvarchar243"],
        nvarchar244: json["Nvarchar244"],
        nvarchar245: json["Nvarchar245"],
        nvarchar246: json["Nvarchar246"],
        nvarchar247: json["Nvarchar247"],
        nvarchar248: json["Nvarchar248"],
        nvarchar249: json["Nvarchar249"],
        nvarchar250: json["Nvarchar250"],
        nvarchar251: json["Nvarchar251"],
        nvarchar252: json["Nvarchar252"],
        nvarchar253: json["Nvarchar253"],
        nvarchar254: json["Nvarchar254"],
        nvarchar255: json["Nvarchar255"],
        nvarchar256: json["Nvarchar256"],
        nvarchar257: json["Nvarchar257"],
        nvarchar258: json["Nvarchar258"],
        nvarchar259: json["Nvarchar259"],
        nvarchar260: json["Nvarchar260"],
        nvarchar261: json["Nvarchar261"],
        nvarchar262: json["Nvarchar262"],
        nvarchar263: json["Nvarchar263"],
        nvarchar264: json["Nvarchar264"],
        nvarchar265: json["Nvarchar265"],
        nvarchar266: json["Nvarchar266"],
        nvarchar267: json["Nvarchar267"],
        nvarchar268: json["Nvarchar268"],
        nvarchar269: json["Nvarchar269"],
        nvarchar270: json["Nvarchar270"],
        nvarchar271: json["Nvarchar271"],
        nvarchar272: json["Nvarchar272"],
        nvarchar273: json["Nvarchar273"],
        nvarchar274: json["Nvarchar274"],
        nvarchar275: json["Nvarchar275"],
        nvarchar276: json["Nvarchar276"],
        nvarchar277: json["Nvarchar277"],
        nvarchar278: json["Nvarchar278"],
        nvarchar279: json["Nvarchar279"],
        nvarchar280: json["Nvarchar280"],
        nvarchar281: json["Nvarchar281"],
        nvarchar282: json["Nvarchar282"],
        nvarchar283: json["Nvarchar283"],
        nvarchar284: json["Nvarchar284"],
        nvarchar285: json["Nvarchar285"],
        nvarchar286: json["Nvarchar286"],
        nvarchar287: json["Nvarchar287"],
        nvarchar288: json["Nvarchar288"],
        nvarchar289: json["Nvarchar289"],
        nvarchar290: json["Nvarchar290"],
        nvarchar291: json["Nvarchar291"],
        nvarchar292: json["Nvarchar292"],
        nvarchar293: json["Nvarchar293"],
        nvarchar294: json["Nvarchar294"],
        nvarchar295: json["Nvarchar295"],
        nvarchar296: json["Nvarchar296"],
        nvarchar297: json["Nvarchar297"],
        nvarchar298: json["Nvarchar298"],
        nvarchar299: json["Nvarchar299"],
        nvarchar300: json["Nvarchar300"],
        nvarchar301: json["Nvarchar301"],
        nvarchar302: json["Nvarchar302"],
        nvarchar303: json["Nvarchar303"],
        nvarchar304: json["Nvarchar304"],
        nvarchar305: json["Nvarchar305"],
        nvarchar306: json["Nvarchar306"],
        nvarchar307: json["Nvarchar307"],
        nvarchar308: json["Nvarchar308"],
        nvarchar309: json["Nvarchar309"],
        nvarchar310: json["Nvarchar310"],
        nvarchar311: json["Nvarchar311"],
        nvarchar312: json["Nvarchar312"],
        nvarchar313: json["Nvarchar313"],
        nvarchar314: json["Nvarchar314"],
        nvarchar315: json["Nvarchar315"],
        nvarchar316: json["Nvarchar316"],
        nvarchar317: json["Nvarchar317"],
        nvarchar318: json["Nvarchar318"],
        nvarchar319: json["Nvarchar319"],
        nvarchar320: json["Nvarchar320"],
        nvarchar321: json["Nvarchar321"],
        nvarchar322: json["Nvarchar322"],
        nvarchar323: json["Nvarchar323"],
        nvarchar324: json["Nvarchar324"],
        nvarchar325: json["Nvarchar325"],
        nvarchar326: json["Nvarchar326"],
        nvarchar327: json["Nvarchar327"],
        nvarchar328: json["Nvarchar328"],
        nvarchar329: json["Nvarchar329"],
        nvarchar330: json["Nvarchar330"],
        nvarchar331: json["Nvarchar331"],
        nvarchar332: json["Nvarchar332"],
        nvarchar333: json["Nvarchar333"],
        nvarchar334: json["Nvarchar334"],
        nvarchar335: json["Nvarchar335"],
        nvarchar336: json["Nvarchar336"],
        nvarchar337: json["Nvarchar337"],
        nvarchar338: json["Nvarchar338"],
        nvarchar339: json["Nvarchar339"],
        nvarchar340: json["Nvarchar340"],
        nvarchar341: json["Nvarchar341"],
        nvarchar342: json["Nvarchar342"],
        nvarchar343: json["Nvarchar343"],
        nvarchar344: json["Nvarchar344"],
        nvarchar345: json["Nvarchar345"],
        nvarchar346: json["Nvarchar346"],
        nvarchar347: json["Nvarchar347"],
        nvarchar348: json["Nvarchar348"],
        nvarchar349: json["Nvarchar349"],
        nvarchar350: json["Nvarchar350"],
        uniqueUserId: json["UniqueUserID"],
        isClarizenUser: json["IsClarizenUser"] ?? false,
        slackUserName: json["SlackUserName"],
        backgroundPicture: json["BackgroundPicture"],
        showLrsActivities: json["ShowLRSActivities"] ?? 0,
        instagramId: json["InstagramID"],
        jobRoleId: json["JobRoleID"],
        objectId: json["ObjectID"] ?? 0,
        usersImage: json["UsersImage"] ?? "",
        usersAddressCity: json["UsersAddressCity"] ?? "",
        expert: json["Expert"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName == null ? null : userName,
        "OrgUnitID": orgUnitId == null ? null : orgUnitId,
        "OriginalSiteID": originalSiteId == null ? null : originalSiteId,
        "SiteID": siteId == null ? null : siteId,
        "OrgName": orgName == null ? null : orgName,
        "FirstName": firstName == null ? null : firstName,
        "MiddleName": middleName,
        "UserID": userId == null ? null : userId,
        "LastName": lastName == null ? null : lastName,
        "Login": login == null ? null : login,
        "AccountType": accountType == null ? null : accountType,
        "SubscriptionStartDate": subscriptionStartDate,
        "SubscriptionEndDate": subscriptionEndDate,
        "Prefix": prefix,
        "Suffix": suffix,
        "Identification": identification,
        "Email": email == null ? null : email,
        "Phone": phone,
        "Fax": fax,
        "MobilePhone": mobilePhone,
        "IMAddress": imAddress,
        "Addressline1": addressline1,
        "Addressline2": addressline2,
        "AddressCity": addressCity,
        "AddressState": addressState,
        "AddressZip": addressZip,
        "AddressCountry": addressCountry,
        "JobTitle": jobTitle,
        "SocialSecurity": socialSecurity,
        "Organization": organization,
        "TimeZone": timeZone == null ? null : timeZone,
        "Roles": roles == null ? null : roles,
        "Active": active == null ? null : active,
        "UserStatus": userStatus == null ? null : userStatus,
        "CreatedDateTime":
            createdDateTime == null ? null : createdDateTime?.toIso8601String(),
        "ModifiedDateTime": modifiedDateTime,
        "Password": password == null ? null : password,
        "AccountExpiryDate": accountExpiryDate,
        "AccountStartDate": accountStartDate == null
            ? null
            : accountStartDate?.toIso8601String(),
        "ExternalID": externalId,
        "Picture": picture == null ? null : picture,
        "BigInt2": bigInt2 == null ? null : bigInt2,
        "BigInt1": bigInt1 == null ? null : bigInt1,
        "CLASS": tableClass,
        "SubscriptionsCount":
            subscriptionsCount == null ? null : subscriptionsCount,
        "CustomerCode": customerCode,
        "SalesRepCode": salesRepCode,
        "TypeSubType": typeSubType,
        "Locked": locked == null ? null : locked,
        "SelfRegistrationRoles": selfRegistrationRoles,
        "AreaCode": areaCode,
        "DisplayName": displayName,
        "DivisionCode": divisionCode,
        "PlantCode": plantCode,
        "OrganizationCode": organizationCode,
        "DepartmentCode": departmentCode,
        "DateTime1": dateTime1,
        "DateTime2": dateTime2,
        "Region": region,
        "JobCode": jobCode,
        "ExternalEmployeeID": externalEmployeeId,
        "ExternalLoginID": externalLoginId,
        "PasswordExpiryDays":
            passwordExpiryDays == null ? null : passwordExpiryDays,
        "UserSite": userSite,
        "DateOfBirth": dateOfBirth,
        "Gender": gender,
        "HighSchool": highSchool,
        "College": college,
        "HighestDegree": highestDegree,
        "BusinessFunction": businessFunction,
        "PrimaryJobFunction": primaryJobFunction,
        "Nvarchar6": nvarchar6,
        "Nvarchar7": nvarchar7,
        "Nvarchar8": nvarchar8,
        "Nvarchar9": nvarchar9,
        "Nvarchar10": nvarchar10,
        "IsExpert": isExpert == null ? null : isExpert,
        "PaymentMode": paymentMode,
        "ApprovalStatus": approvalStatus,
        "Bit1": bit1 == null ? null : bit1,
        "Bit2": bit2 == null ? null : bit2,
        "Bit3": bit3 == null ? null : bit3,
        "SupervisorEmployeeID": supervisorEmployeeId,
        "Nvarchar5": nvarchar5,
        "SecurePaypalID": securePaypalId,
        "PayeeAccountNo": payeeAccountNo,
        "PayeeName": payeeName,
        "PayPalEmail": payPalEmail,
        "ShipAddLine1": shipAddLine1,
        "PayPalAccountName": payPalAccountName,
        "ShipAddCity": shipAddCity,
        "ShipAddState": shipAddState,
        "ShipAddZip": shipAddZip,
        "ShipAddCountry": shipAddCountry,
        "ShipAddPhone": shipAddPhone,
        "Address": address == null ? null : address,
        "Description": description,
        "Datetime5": datetime5,
        "SocialNetworkID": socialNetworkId,
        "SocialNetworkURL": socialNetworkUrl,
        "Nvarchar11": nvarchar11,
        "Nvarchar12": nvarchar12,
        "Nvarchar13": nvarchar13,
        "Nvarchar14": nvarchar14,
        "LastVisited":
            lastVisited == null ? null : lastVisited?.toIso8601String(),
        "IsPragenter": isPragenter == null ? null : isPragenter,
        "CompanySize": companySize,
        "Evaluator1": evaluator1,
        "Evaluator2": evaluator2,
        "DateOfJoin": dateOfJoin,
        "FacebookID": facebookId,
        "GooglePlusID": googlePlusId,
        "LinkedInID": linkedInId,
        "TwitterID": twitterId,
        "TumblrID": tumblrId,
        "Source": source,
        "Nvarchar15": nvarchar15,
        "Nvarchar16": nvarchar16,
        "Nvarchar17": nvarchar17,
        "Nvarchar18": nvarchar18,
        "Nvarchar19": nvarchar19,
        "Nvarchar20": nvarchar20,
        "LanguageSelection":
            languageSelection == null ? null : languageSelection,
        "Age": age,
        "Licenceno": licenceno,
        "BillingAddLine1": billingAddLine1,
        "BillingAddLine2": billingAddLine2,
        "BillingAddLine3": billingAddLine3,
        "BillingAddCity": billingAddCity,
        "BillingAddState": billingAddState,
        "BillingAddCountry": billingAddCountry,
        "BillingAddZip": billingAddZip,
        "ExternalType": externalType,
        "Nvarchar4": nvarchar4,
        "Nvarchar1": nvarchar1,
        "Nvarchar2": nvarchar2,
        "Nvarchar3": nvarchar3,
        "UserLanguage": userLanguage == null ? null : userLanguage,
        "WorkingHoursStartTime":
            workingHoursStartTime == null ? null : workingHoursStartTime,
        "WorkingHoursEndTime":
            workingHoursEndTime == null ? null : workingHoursEndTime,
        "UID": uid == null ? null : uid,
        "Nvarchar101": nvarchar101,
        "Nvarchar102": nvarchar102,
        "Nvarchar103": nvarchar103,
        "Nvarchar104": nvarchar104,
        "Nvarchar105": nvarchar105,
        "Nvarchar106": nvarchar106,
        "Nvarchar107": nvarchar107,
        "Nvarchar108": nvarchar108,
        "Nvarchar109": nvarchar109,
        "Nvarchar110": nvarchar110,
        "Nvarchar111": nvarchar111,
        "Nvarchar112": nvarchar112,
        "Nvarchar113": nvarchar113,
        "Nvarchar114": nvarchar114,
        "Nvarchar115": nvarchar115,
        "Nvarchar116": nvarchar116,
        "Nvarchar117": nvarchar117,
        "Nvarchar118": nvarchar118,
        "Nvarchar119": nvarchar119,
        "Nvarchar120": nvarchar120,
        "Nvarchar121": nvarchar121,
        "Nvarchar122": nvarchar122,
        "Nvarchar123": nvarchar123,
        "Nvarchar124": nvarchar124,
        "Nvarchar125": nvarchar125,
        "Nvarchar126": nvarchar126,
        "Nvarchar127": nvarchar127,
        "Nvarchar128": nvarchar128,
        "Nvarchar129": nvarchar129,
        "Nvarchar130": nvarchar130,
        "Nvarchar131": nvarchar131,
        "Nvarchar132": nvarchar132,
        "Nvarchar133": nvarchar133,
        "Nvarchar134": nvarchar134,
        "Nvarchar135": nvarchar135,
        "Nvarchar136": nvarchar136,
        "Nvarchar137": nvarchar137,
        "Nvarchar138": nvarchar138,
        "Nvarchar139": nvarchar139,
        "Nvarchar140": nvarchar140,
        "Nvarchar141": nvarchar141,
        "Nvarchar142": nvarchar142,
        "Nvarchar143": nvarchar143,
        "Nvarchar144": nvarchar144,
        "Nvarchar145": nvarchar145,
        "Nvarchar146": nvarchar146,
        "Nvarchar147": nvarchar147,
        "Nvarchar148": nvarchar148,
        "Nvarchar149": nvarchar149,
        "Nvarchar150": nvarchar150,
        "Nvarchar151": nvarchar151,
        "Nvarchar152": nvarchar152,
        "Nvarchar153": nvarchar153,
        "Nvarchar154": nvarchar154,
        "Nvarchar155": nvarchar155,
        "Nvarchar156": nvarchar156,
        "Nvarchar157": nvarchar157,
        "Nvarchar158": nvarchar158,
        "Nvarchar159": nvarchar159,
        "Nvarchar160": nvarchar160,
        "Nvarchar161": nvarchar161,
        "Nvarchar162": nvarchar162,
        "Nvarchar163": nvarchar163,
        "Nvarchar164": nvarchar164,
        "Nvarchar165": nvarchar165,
        "Nvarchar166": nvarchar166,
        "Nvarchar167": nvarchar167,
        "Nvarchar168": nvarchar168,
        "Nvarchar169": nvarchar169,
        "Nvarchar170": nvarchar170,
        "Nvarchar171": nvarchar171,
        "Nvarchar172": nvarchar172,
        "Nvarchar173": nvarchar173,
        "Nvarchar174": nvarchar174,
        "Nvarchar175": nvarchar175,
        "Nvarchar176": nvarchar176,
        "Nvarchar177": nvarchar177,
        "Nvarchar178": nvarchar178,
        "Nvarchar179": nvarchar179,
        "Nvarchar180": nvarchar180,
        "Nvarchar181": nvarchar181,
        "Nvarchar182": nvarchar182,
        "Nvarchar183": nvarchar183,
        "Nvarchar184": nvarchar184,
        "Nvarchar185": nvarchar185,
        "Nvarchar186": nvarchar186,
        "Nvarchar187": nvarchar187,
        "Nvarchar188": nvarchar188,
        "Nvarchar189": nvarchar189,
        "Nvarchar190": nvarchar190,
        "Nvarchar191": nvarchar191,
        "Nvarchar192": nvarchar192,
        "Nvarchar193": nvarchar193,
        "Nvarchar194": nvarchar194,
        "Nvarchar195": nvarchar195,
        "Nvarchar196": nvarchar196,
        "Nvarchar197": nvarchar197,
        "Nvarchar198": nvarchar198,
        "Nvarchar199": nvarchar199,
        "Nvarchar200": nvarchar200,
        "Nvarchar201": nvarchar201,
        "Nvarchar202": nvarchar202,
        "Nvarchar203": nvarchar203,
        "Nvarchar204": nvarchar204,
        "Nvarchar205": nvarchar205,
        "Nvarchar206": nvarchar206,
        "Nvarchar207": nvarchar207,
        "Nvarchar208": nvarchar208,
        "Nvarchar209": nvarchar209,
        "Nvarchar210": nvarchar210,
        "Nvarchar211": nvarchar211,
        "Nvarchar212": nvarchar212,
        "Nvarchar213": nvarchar213,
        "Nvarchar214": nvarchar214,
        "Nvarchar215": nvarchar215,
        "Nvarchar216": nvarchar216,
        "Nvarchar217": nvarchar217,
        "Nvarchar218": nvarchar218,
        "Nvarchar219": nvarchar219,
        "Nvarchar220": nvarchar220,
        "Nvarchar221": nvarchar221,
        "Nvarchar222": nvarchar222,
        "Nvarchar223": nvarchar223,
        "Nvarchar224": nvarchar224,
        "Nvarchar225": nvarchar225,
        "Nvarchar226": nvarchar226,
        "Nvarchar227": nvarchar227,
        "Nvarchar228": nvarchar228,
        "Nvarchar229": nvarchar229,
        "Nvarchar230": nvarchar230,
        "Nvarchar231": nvarchar231,
        "Nvarchar232": nvarchar232,
        "Nvarchar233": nvarchar233,
        "Nvarchar234": nvarchar234,
        "Nvarchar235": nvarchar235,
        "Nvarchar236": nvarchar236,
        "Nvarchar237": nvarchar237,
        "Nvarchar238": nvarchar238,
        "Nvarchar239": nvarchar239,
        "Nvarchar240": nvarchar240,
        "Nvarchar241": nvarchar241,
        "Nvarchar242": nvarchar242,
        "Nvarchar243": nvarchar243,
        "Nvarchar244": nvarchar244,
        "Nvarchar245": nvarchar245,
        "Nvarchar246": nvarchar246,
        "Nvarchar247": nvarchar247,
        "Nvarchar248": nvarchar248,
        "Nvarchar249": nvarchar249,
        "Nvarchar250": nvarchar250,
        "Nvarchar251": nvarchar251,
        "Nvarchar252": nvarchar252,
        "Nvarchar253": nvarchar253,
        "Nvarchar254": nvarchar254,
        "Nvarchar255": nvarchar255,
        "Nvarchar256": nvarchar256,
        "Nvarchar257": nvarchar257,
        "Nvarchar258": nvarchar258,
        "Nvarchar259": nvarchar259,
        "Nvarchar260": nvarchar260,
        "Nvarchar261": nvarchar261,
        "Nvarchar262": nvarchar262,
        "Nvarchar263": nvarchar263,
        "Nvarchar264": nvarchar264,
        "Nvarchar265": nvarchar265,
        "Nvarchar266": nvarchar266,
        "Nvarchar267": nvarchar267,
        "Nvarchar268": nvarchar268,
        "Nvarchar269": nvarchar269,
        "Nvarchar270": nvarchar270,
        "Nvarchar271": nvarchar271,
        "Nvarchar272": nvarchar272,
        "Nvarchar273": nvarchar273,
        "Nvarchar274": nvarchar274,
        "Nvarchar275": nvarchar275,
        "Nvarchar276": nvarchar276,
        "Nvarchar277": nvarchar277,
        "Nvarchar278": nvarchar278,
        "Nvarchar279": nvarchar279,
        "Nvarchar280": nvarchar280,
        "Nvarchar281": nvarchar281,
        "Nvarchar282": nvarchar282,
        "Nvarchar283": nvarchar283,
        "Nvarchar284": nvarchar284,
        "Nvarchar285": nvarchar285,
        "Nvarchar286": nvarchar286,
        "Nvarchar287": nvarchar287,
        "Nvarchar288": nvarchar288,
        "Nvarchar289": nvarchar289,
        "Nvarchar290": nvarchar290,
        "Nvarchar291": nvarchar291,
        "Nvarchar292": nvarchar292,
        "Nvarchar293": nvarchar293,
        "Nvarchar294": nvarchar294,
        "Nvarchar295": nvarchar295,
        "Nvarchar296": nvarchar296,
        "Nvarchar297": nvarchar297,
        "Nvarchar298": nvarchar298,
        "Nvarchar299": nvarchar299,
        "Nvarchar300": nvarchar300,
        "Nvarchar301": nvarchar301,
        "Nvarchar302": nvarchar302,
        "Nvarchar303": nvarchar303,
        "Nvarchar304": nvarchar304,
        "Nvarchar305": nvarchar305,
        "Nvarchar306": nvarchar306,
        "Nvarchar307": nvarchar307,
        "Nvarchar308": nvarchar308,
        "Nvarchar309": nvarchar309,
        "Nvarchar310": nvarchar310,
        "Nvarchar311": nvarchar311,
        "Nvarchar312": nvarchar312,
        "Nvarchar313": nvarchar313,
        "Nvarchar314": nvarchar314,
        "Nvarchar315": nvarchar315,
        "Nvarchar316": nvarchar316,
        "Nvarchar317": nvarchar317,
        "Nvarchar318": nvarchar318,
        "Nvarchar319": nvarchar319,
        "Nvarchar320": nvarchar320,
        "Nvarchar321": nvarchar321,
        "Nvarchar322": nvarchar322,
        "Nvarchar323": nvarchar323,
        "Nvarchar324": nvarchar324,
        "Nvarchar325": nvarchar325,
        "Nvarchar326": nvarchar326,
        "Nvarchar327": nvarchar327,
        "Nvarchar328": nvarchar328,
        "Nvarchar329": nvarchar329,
        "Nvarchar330": nvarchar330,
        "Nvarchar331": nvarchar331,
        "Nvarchar332": nvarchar332,
        "Nvarchar333": nvarchar333,
        "Nvarchar334": nvarchar334,
        "Nvarchar335": nvarchar335,
        "Nvarchar336": nvarchar336,
        "Nvarchar337": nvarchar337,
        "Nvarchar338": nvarchar338,
        "Nvarchar339": nvarchar339,
        "Nvarchar340": nvarchar340,
        "Nvarchar341": nvarchar341,
        "Nvarchar342": nvarchar342,
        "Nvarchar343": nvarchar343,
        "Nvarchar344": nvarchar344,
        "Nvarchar345": nvarchar345,
        "Nvarchar346": nvarchar346,
        "Nvarchar347": nvarchar347,
        "Nvarchar348": nvarchar348,
        "Nvarchar349": nvarchar349,
        "Nvarchar350": nvarchar350,
        "UniqueUserID": uniqueUserId,
        "IsClarizenUser": isClarizenUser == null ? null : isClarizenUser,
        "SlackUserName": slackUserName,
        "BackgroundPicture": backgroundPicture,
        "ShowLRSActivities":
            showLrsActivities == null ? null : showLrsActivities,
        "InstagramID": instagramId,
        "JobRoleID": jobRoleId,
        "ObjectID": objectId == null ? null : objectId,
        "UsersImage": usersImage == null ? null : usersImage,
        "UsersAddressCity": usersAddressCity == null ? null : usersAddressCity,
        "Expert": expert,
      };
}
