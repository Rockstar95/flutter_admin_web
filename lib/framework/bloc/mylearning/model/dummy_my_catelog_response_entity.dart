import 'package:hive/hive.dart';
import 'package:flutter_admin_web/generated/json/base/json_convert_content.dart';
import 'package:flutter_admin_web/generated/json/base/json_field.dart';

part 'dummy_my_catelog_response_entity.g.dart';

@HiveType(typeId: 0)
class DummyMyCatelogResponseEntity
    with JsonConvert<DummyMyCatelogResponseEntity> {
  @JSONField(name: "table")
  @HiveField(0)
  List<DummyMyCatelogResponseTable> table = [];

  @JSONField(name: "table2")
  @HiveField(1)
  List<DummyMyCatelogResponseTable2> table2 = [];
}

@HiveType(typeId: 1)
class DummyMyCatelogResponseTable
    with JsonConvert<DummyMyCatelogResponseTable> {
  @HiveField(0)
  int totalrecordscount = 0;
}

@HiveType(typeId: 0)
class DummyMyCatelogResponseTable2 extends HiveObject
    with JsonConvert<DummyMyCatelogResponseTable2> {
  @HiveField(0)
  int filterid = 0;

  @HiveField(1)
  int siteid = 0;

  @HiveField(2)
  int usersiteid = 0;

  @HiveField(3)
  String sitename = "";

  @HiveField(4)
  String objectid = "";

  @HiveField(5)
  String medianame = "";

  @HiveField(6)
  String description = "";

  @HiveField(7)
  String contenttype = "";

  @HiveField(8)
  String iconpath = "";

  @HiveField(9)
  bool iscontent = false;

  @HiveField(10)
  String contenttypethumbnail = "";

  @HiveField(11)
  String contentid = "";

  @HiveField(12)
  String name = "";

  @HiveField(13)
  int objecttypeid = 0;

  @HiveField(14)
  String language = "";

  @HiveField(15)
  String shortdescription = "";

  @HiveField(16)
  dynamic version;

  @HiveField(17)
  String startpage = "";

  @HiveField(18)
  int createduserid = 0;

  @HiveField(19)
  String createddate = "";

  @HiveField(20)
  String keywords = "";

  @HiveField(21)
  bool downloadable = false;

  @HiveField(22)
  String publisheddate = "";

  @HiveField(23)
  String status = "";

  @HiveField(24)
  int cmsgroupid = 0;

  @HiveField(25)
  dynamic checkedoutto;

  @HiveField(26)
  String longdescription = "";

  @HiveField(27)
  dynamic mediatypeid;

  @HiveField(28)
  dynamic owner;

  @HiveField(29)
  dynamic publicationdate; // 30

  @HiveField(30)
  dynamic activatedate;

  @HiveField(31)
  dynamic expirydate;

  @HiveField(32)
  String thumbnailimagepath = "";

  @HiveField(33)
  int ecommbussinessrule = 0;

  @HiveField(34)
  dynamic downloadfile;

  @HiveField(35)
  dynamic saleprice;

  @HiveField(36)
  dynamic listprice;

  @HiveField(37)
  String folderpath = "";

  @HiveField(38)
  dynamic skinid;

  @HiveField(39)
  dynamic folderid;

  @HiveField(40)
  int modifieduserid = 0;

  @HiveField(41)
  String modifieddate = "";

  @HiveField(42)
  int viewtype = 0;

  @HiveField(43)
  String windowproperties = "";

  @HiveField(44)
  dynamic currency;

  @HiveField(45)
  String certificateid = "";

  @HiveField(46)
  dynamic launchwindowmode;

  @HiveField(47)
  bool active = false;

  @HiveField(48)
  dynamic hardwaretype;

  @HiveField(49)
  dynamic enrollmentlimit;

  @HiveField(50)
  dynamic presenterurl;

  @HiveField(51)
  dynamic participanturl;

  @HiveField(52)
  dynamic eventstartdatetime;

  @HiveField(53)
  dynamic eventenddatetime;

  @HiveField(54)
  dynamic presenterid;

  @HiveField(55)
  dynamic contentstatus;

  @HiveField(56)
  dynamic location;

  @HiveField(57)
  dynamic conferencenumbers;

  @HiveField(58)
  dynamic directionurl;

  @HiveField(59)
  String eventpercentage = ""; // 60

  @HiveField(60)
  dynamic starttime;

  @HiveField(61)
  dynamic duration;

  @HiveField(62)
  dynamic personalizediconid1;

  @HiveField(63)
  dynamic personalizediconid2;

  @HiveField(64)
  int ciid = 0;

  @HiveField(65)
  int noofusersenrolled = 0;

  @HiveField(66)
  int noofuserscompleted = 0;

  @HiveField(67)
  dynamic eventkey;

  @HiveField(68)
  int eventtype = 0;

  @HiveField(69)
  int devicetypeid = 0;

  @HiveField(70)
  dynamic nvarchar2;

  @HiveField(71)
  dynamic nvarchar3;

  @HiveField(72)
  dynamic audience;

  @HiveField(73)
  String backgroundcolor = "";

  @HiveField(74)
  String fontcolor = "";

  @HiveField(75)
  dynamic searchreferencenumber;

  @HiveField(76)
  dynamic nvarchar4;

  @HiveField(77)
  dynamic timezone;

  @HiveField(78)
  dynamic bit3;

  @HiveField(79)
  dynamic bit4;

  @HiveField(80)
  int typeofevent = 0;

  @HiveField(81)
  int webinartool = 0;

  @HiveField(82)
  dynamic webinarpassword;

  @HiveField(83)
  bool bit5 = false;

  @HiveField(84)
  dynamic bit2;

  @HiveField(85)
  dynamic seotitle;

  @HiveField(86)
  dynamic seometadescription;

  @HiveField(87)
  dynamic seokeywords;

  @HiveField(88)
  dynamic waitlistlimit;

  @HiveField(89)
  int totalattempts = 0; // 90

  @HiveField(90)
  int accessperiodtype = 0;

  @HiveField(91)
  dynamic itunesproductid;

  @HiveField(92)
  dynamic googleproductid;

  @HiveField(93)
  dynamic decimal2;

  @HiveField(94)
  dynamic budgetprice;

  @HiveField(95)
  dynamic budgetcurrency;

  @HiveField(96)
  dynamic eventresourcedisplayoption;

  @HiveField(97)
  String certificatepercentage = "";

  @HiveField(98)
  String activityid = "";

  @HiveField(99)
  int eventscheduletype = 0;

  @HiveField(100)
  dynamic bigint4;

  @HiveField(101)
  dynamic offeringstartdate;

  @HiveField(102)
  dynamic offeringenddate;

  @HiveField(103)
  String contentauthordisplayname = "";

  @HiveField(104)
  dynamic registrationurl;

  @HiveField(105)
  dynamic videointroduction;

  @HiveField(106)
  dynamic noofmodules;

  @HiveField(107)
  dynamic learningobjectives;

  @HiveField(108)
  dynamic tableofcontent;

  @HiveField(109)
  dynamic tagname;

  @HiveField(110)
  dynamic credittypes;

  @HiveField(111)
  dynamic eventcategories;

  @HiveField(112)
  bool eventrecording = false;

  @HiveField(113)
  dynamic recordingmsg;

  @HiveField(114)
  dynamic recordingcontentid;

  @HiveField(115)
  String recordingurl = "";

  @HiveField(116)
  int scoid = 0;

  @HiveField(117)
  String startdate = "";

  @HiveField(118)
  String datecompleted = "";

  @HiveField(119)
  int accessednumber = 0; // 120

  @HiveField(120)
  int noofattempts = 0;

  @HiveField(121)
  String totalsessiontime = "";

  @HiveField(122)
  dynamic corechildren;

  @HiveField(123)
  dynamic coreentry;

  @HiveField(124)
  String corelessonstatus = "";

  @HiveField(125)
  dynamic corecredit;

  @HiveField(126)
  String groupdisplayname = "";

  @HiveField(127)
  int groupdisplayorder = 0;

  @HiveField(128)
  String corelessonlocation = "";

  @HiveField(129)
  dynamic scorechildren;

  @HiveField(130)
  int scoreraw = 0;

  @HiveField(131)
  dynamic scoremin;

  @HiveField(132)
  dynamic scoremax;

  @HiveField(133)
  dynamic launchdata;

  @HiveField(134)
  String actualstatus = "";

  @HiveField(135)
  dynamic userid;

  @HiveField(136)
  String dateassigned = "";

  @HiveField(137)
  dynamic targetdate;

  @HiveField(138)
  dynamic ismandatory;

  @HiveField(139)
  int assignedby = 0;

  @HiveField(140)
  bool assignedbyadmin = false;

  @HiveField(141)
  dynamic durationenddate;

  @HiveField(142)
  dynamic usercontentstatus;

  @HiveField(143)
  dynamic attemptsleft;

  @HiveField(144)
  dynamic accessperiod;

  @HiveField(145)
  int accessperiodunit = 0;

  @HiveField(146)
  bool isarchived = false;

  @HiveField(147)
  dynamic purchaseddate;

  @HiveField(148)
  dynamic joinurl;

  @HiveField(149)
  dynamic confirmationurl; // 150

  @HiveField(150)
  @JSONField(name: "hide")
  int xHide = 0;

  @HiveField(151)
  int required = 0;

  @HiveField(152)
  int schedulestatus = 0;

  @HiveField(153)
  dynamic schedulereserveddatetime;

  @HiveField(154)
  String percentcompleted = "";

  @HiveField(155)
  dynamic invitationurl;

  @HiveField(156)
  dynamic link;

  @HiveField(157)
  dynamic pareportlink;

  @HiveField(158)
  dynamic dareportlink;

  @HiveField(159)
  dynamic availableseats;

  @HiveField(160)
  int waitlistenrolls = 0;

  @HiveField(161)
  dynamic jwvideokey;

  @HiveField(162)
  dynamic cloudmediaplayerkey;

  @HiveField(163)
  String usercertificateid = "";

  @HiveField(164)
  int relatedconentcount = 0;

  @HiveField(165)
  dynamic dtfcontent;

  @HiveField(166)
  double ratingid = 0;

  @HiveField(167)
  int totalratings = 0;

  @HiveField(168)
  String certificatepage = "";

  @HiveField(169)
  String locationname = "";

  @HiveField(170)
  String buildingname = "";

  @HiveField(171)
  int commentscount = 0;

  @HiveField(172)
  String authordisplayname = "";

  @HiveField(173)
  dynamic presenter;

  @HiveField(174)
  bool isdownloaded = false;

  @HiveField(175)
  bool eventrecording1 = false;

  @HiveField(176)
  dynamic recordingmsg1;

  @HiveField(177)
  dynamic recordingcontentid1;

  @HiveField(178)
  String recordingurl1 = "";

  @HiveField(179)
  dynamic eventstartdatedisplay; // 180

  @HiveField(180)
  dynamic eventenddatedisplay;

  @HiveField(181)
  dynamic timezoneabbreviation;

  @HiveField(182)
  String siteurl = "";

  @HiveField(183)
  String progress = "";

  @HiveField(184)
  bool removelink = false;

  @HiveField(185)
  dynamic reschduleparentid;

  @HiveField(186)
  bool isbadcancellationenabled = false;

  @HiveField(187)
  String jwstartpage = "";

  @HiveField(188)
  bool isenrollfutureinstance = false;

  @HiveField(189)
  bool isviewreview = false;

  @HiveField(190)
  String certificateaction = "";

  @HiveField(191)
  dynamic qrcodeimagepath;

  @HiveField(192)
  dynamic qrimagename;

  @HiveField(193)
  dynamic viewprerequisitecontentstatus;

  @HiveField(194)
  String headerlocationname = "";

  @HiveField(195)
  String suggesttoconnlink = "";

  @HiveField(196)
  String suggestwithfriendlink = "";

  @HiveField(197)
  bool isDownloading = false;

  @HiveField(198)
  int isaddedtomylearning = 0;

  @HiveField(199)
  String imageData = "";

  @HiveField(200)
  String author = "";

  @HiveField(201)
  dynamic parentid;

  @HiveField(202)
  String blockName = "";

  @HiveField(203)
  dynamic iswishlistcontent;

  @HiveField(204)
  String actionwaitlist = "";

  @HiveField(205)
  String ShareContentwithUser = ""; //206

  @HiveField(206)
  String datefilter = "";

  String wstatus = "";
}
