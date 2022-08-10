// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dummy_my_catelog_response_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DummyMyCatelogResponseEntityAdapter
    extends TypeAdapter<DummyMyCatelogResponseEntity> {
  @override
  final int typeId = 0;

  @override
  DummyMyCatelogResponseEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DummyMyCatelogResponseEntity()
      ..table = (fields[0] as List).cast<DummyMyCatelogResponseTable>()
      ..table2 = (fields[1] as List).cast<DummyMyCatelogResponseTable2>();
  }

  @override
  void write(BinaryWriter writer, DummyMyCatelogResponseEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.table)
      ..writeByte(1)
      ..write(obj.table2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DummyMyCatelogResponseEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DummyMyCatelogResponseTableAdapter
    extends TypeAdapter<DummyMyCatelogResponseTable> {
  @override
  final int typeId = 1;

  @override
  DummyMyCatelogResponseTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DummyMyCatelogResponseTable()..totalrecordscount = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, DummyMyCatelogResponseTable obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.totalrecordscount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DummyMyCatelogResponseTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DummyMyCatelogResponseTable2Adapter
    extends TypeAdapter<DummyMyCatelogResponseTable2> {
  @override
  final int typeId = 0;

  @override
  DummyMyCatelogResponseTable2 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DummyMyCatelogResponseTable2()
      ..filterid = fields[0] as int
      ..siteid = fields[1] as int
      ..usersiteid = fields[2] as int
      ..sitename = fields[3] as String
      ..objectid = fields[4] as String
      ..medianame = fields[5] as String
      ..description = fields[6] as String
      ..contenttype = fields[7] as String
      ..iconpath = fields[8] as String
      ..iscontent = fields[9] as bool
      ..contenttypethumbnail = fields[10] as String
      ..contentid = fields[11] as String
      ..name = fields[12] as String
      ..objecttypeid = fields[13] as int
      ..language = fields[14] as String
      ..shortdescription = fields[15] as String
      ..version = fields[16] as dynamic
      ..startpage = fields[17] as String
      ..createduserid = fields[18] as int
      ..createddate = fields[19] as String
      ..keywords = fields[20] as String
      ..downloadable = fields[21] as bool
      ..publisheddate = fields[22] as String
      ..status = fields[23] as String
      ..cmsgroupid = fields[24] as int
      ..checkedoutto = fields[25] as dynamic
      ..longdescription = fields[26] as String
      ..mediatypeid = fields[27] as dynamic
      ..owner = fields[28] as dynamic
      ..publicationdate = fields[29] as dynamic
      ..activatedate = fields[30] as dynamic
      ..expirydate = fields[31] as dynamic
      ..thumbnailimagepath = fields[32] as String
      ..ecommbussinessrule = fields[33] as int
      ..downloadfile = fields[34] as dynamic
      ..saleprice = fields[35] as dynamic
      ..listprice = fields[36] as dynamic
      ..folderpath = fields[37] as String
      ..skinid = fields[38] as dynamic
      ..folderid = fields[39] as dynamic
      ..modifieduserid = fields[40] as int
      ..modifieddate = fields[41] as String
      ..viewtype = fields[42] as int
      ..windowproperties = fields[43] as String
      ..currency = fields[44] as dynamic
      ..certificateid = fields[45] as String
      ..launchwindowmode = fields[46] as dynamic
      ..active = fields[47] as bool
      ..hardwaretype = fields[48] as dynamic
      ..enrollmentlimit = fields[49] as dynamic
      ..presenterurl = fields[50] as dynamic
      ..participanturl = fields[51] as dynamic
      ..eventstartdatetime = fields[52] as dynamic
      ..eventenddatetime = fields[53] as dynamic
      ..presenterid = fields[54] as dynamic
      ..contentstatus = fields[55] as dynamic
      ..location = fields[56] as dynamic
      ..conferencenumbers = fields[57] as dynamic
      ..directionurl = fields[58] as dynamic
      ..eventpercentage = fields[59] as String
      ..starttime = fields[60] as dynamic
      ..duration = fields[61] as dynamic
      ..personalizediconid1 = fields[62] as dynamic
      ..personalizediconid2 = fields[63] as dynamic
      ..ciid = fields[64] as int
      ..noofusersenrolled = fields[65] as int
      ..noofuserscompleted = fields[66] as int
      ..eventkey = fields[67] as dynamic
      ..eventtype = fields[68] as int
      ..devicetypeid = fields[69] as int
      ..nvarchar2 = fields[70] as dynamic
      ..nvarchar3 = fields[71] as dynamic
      ..audience = fields[72] as dynamic
      ..backgroundcolor = fields[73] as String
      ..fontcolor = fields[74] as String
      ..searchreferencenumber = fields[75] as dynamic
      ..nvarchar4 = fields[76] as dynamic
      ..timezone = fields[77] as dynamic
      ..bit3 = fields[78] as dynamic
      ..bit4 = fields[79] as dynamic
      ..typeofevent = fields[80] as int
      ..webinartool = fields[81] as int
      ..webinarpassword = fields[82] as dynamic
      ..bit5 = fields[83] as bool
      ..bit2 = fields[84] as dynamic
      ..seotitle = fields[85] as dynamic
      ..seometadescription = fields[86] as dynamic
      ..seokeywords = fields[87] as dynamic
      ..waitlistlimit = fields[88] as dynamic
      ..totalattempts = fields[89] as int
      ..accessperiodtype = fields[90] as int
      ..itunesproductid = fields[91] as dynamic
      ..googleproductid = fields[92] as dynamic
      ..decimal2 = fields[93] as dynamic
      ..budgetprice = fields[94] as dynamic
      ..budgetcurrency = fields[95] as dynamic
      ..eventresourcedisplayoption = fields[96] as dynamic
      ..certificatepercentage = fields[97] as String
      ..activityid = fields[98] as String
      ..eventscheduletype = fields[99] as int
      ..bigint4 = fields[100] as dynamic
      ..offeringstartdate = fields[101] as dynamic
      ..offeringenddate = fields[102] as dynamic
      ..contentauthordisplayname = fields[103] as String
      ..registrationurl = fields[104] as dynamic
      ..videointroduction = fields[105] as dynamic
      ..noofmodules = fields[106] as dynamic
      ..learningobjectives = fields[107] as dynamic
      ..tableofcontent = fields[108] as dynamic
      ..tagname = fields[109] as dynamic
      ..credittypes = fields[110] as dynamic
      ..eventcategories = fields[111] as dynamic
      ..eventrecording = fields[112] as bool
      ..recordingmsg = fields[113] as dynamic
      ..recordingcontentid = fields[114] as dynamic
      ..recordingurl = fields[115] as String
      ..scoid = fields[116] as int
      ..startdate = fields[117] as String
      ..datecompleted = fields[118] as String
      ..accessednumber = fields[119] as int
      ..noofattempts = fields[120] as int
      ..totalsessiontime = fields[121] as String
      ..corechildren = fields[122] as dynamic
      ..coreentry = fields[123] as dynamic
      ..corelessonstatus = fields[124] as String
      ..corecredit = fields[125] as dynamic
      ..groupdisplayname = fields[126] as String
      ..groupdisplayorder = fields[127] as int
      ..corelessonlocation = fields[128] as String
      ..scorechildren = fields[129] as dynamic
      ..scoreraw = fields[130] as int
      ..scoremin = fields[131] as dynamic
      ..scoremax = fields[132] as dynamic
      ..launchdata = fields[133] as dynamic
      ..actualstatus = fields[134] as String
      ..userid = fields[135] as dynamic
      ..dateassigned = fields[136] as String
      ..targetdate = fields[137] as dynamic
      ..ismandatory = fields[138] as dynamic
      ..assignedby = fields[139] as int
      ..assignedbyadmin = fields[140] as bool
      ..durationenddate = fields[141] as dynamic
      ..usercontentstatus = fields[142] as dynamic
      ..attemptsleft = fields[143] as dynamic
      ..accessperiod = fields[144] as dynamic
      ..accessperiodunit = fields[145] as int
      ..isarchived = fields[146] as bool
      ..purchaseddate = fields[147] as dynamic
      ..joinurl = fields[148] as dynamic
      ..confirmationurl = fields[149] as dynamic
      ..xHide = fields[150] as int
      ..required = fields[151] as int
      ..schedulestatus = fields[152] as int
      ..schedulereserveddatetime = fields[153] as dynamic
      ..percentcompleted = fields[154] as String
      ..invitationurl = fields[155] as dynamic
      ..link = fields[156] as dynamic
      ..pareportlink = fields[157] as dynamic
      ..dareportlink = fields[158] as dynamic
      ..availableseats = fields[159] as dynamic
      ..waitlistenrolls = fields[160] as int
      ..jwvideokey = fields[161] as dynamic
      ..cloudmediaplayerkey = fields[162] as dynamic
      ..usercertificateid = fields[163] as String
      ..relatedconentcount = fields[164] as int
      ..dtfcontent = fields[165] as dynamic
      ..ratingid = fields[166] as double
      ..totalratings = fields[167] as int
      ..certificatepage = fields[168] as String
      ..locationname = fields[169] as String
      ..buildingname = fields[170] as String
      ..commentscount = fields[171] as int
      ..authordisplayname = fields[172] as String
      ..presenter = fields[173] as dynamic
      ..isdownloaded = fields[174] as bool
      ..eventrecording1 = fields[175] as bool
      ..recordingmsg1 = fields[176] as dynamic
      ..recordingcontentid1 = fields[177] as dynamic
      ..recordingurl1 = fields[178] as String
      ..eventstartdatedisplay = fields[179] as dynamic
      ..eventenddatedisplay = fields[180] as dynamic
      ..timezoneabbreviation = fields[181] as dynamic
      ..siteurl = fields[182] as String
      ..progress = fields[183] as String
      ..removelink = fields[184] as bool
      ..reschduleparentid = fields[185] as dynamic
      ..isbadcancellationenabled = fields[186] as bool
      ..jwstartpage = fields[187] as String
      ..isenrollfutureinstance = fields[188] as bool
      ..isviewreview = fields[189] as bool
      ..certificateaction = fields[190] as String
      ..qrcodeimagepath = fields[191] as dynamic
      ..qrimagename = fields[192] as dynamic
      ..viewprerequisitecontentstatus = fields[193] as dynamic
      ..headerlocationname = fields[194] as String
      ..suggesttoconnlink = fields[195] as String
      ..suggestwithfriendlink = fields[196] as String
      ..isDownloading = fields[197] as bool
      ..isaddedtomylearning = fields[198] as int
      ..imageData = fields[199] as String
      ..author = fields[200] as String
      ..parentid = fields[201] as dynamic
      ..blockName = fields[202] as String
      ..iswishlistcontent = fields[203] as dynamic
      ..actionwaitlist = fields[204] as String
      ..ShareContentwithUser = fields[205] as String;
  }

  @override
  void write(BinaryWriter writer, DummyMyCatelogResponseTable2 obj) {
    writer
      ..writeByte(206)
      ..writeByte(0)
      ..write(obj.filterid)
      ..writeByte(1)
      ..write(obj.siteid)
      ..writeByte(2)
      ..write(obj.usersiteid)
      ..writeByte(3)
      ..write(obj.sitename)
      ..writeByte(4)
      ..write(obj.objectid)
      ..writeByte(5)
      ..write(obj.medianame)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.contenttype)
      ..writeByte(8)
      ..write(obj.iconpath)
      ..writeByte(9)
      ..write(obj.iscontent)
      ..writeByte(10)
      ..write(obj.contenttypethumbnail)
      ..writeByte(11)
      ..write(obj.contentid)
      ..writeByte(12)
      ..write(obj.name)
      ..writeByte(13)
      ..write(obj.objecttypeid)
      ..writeByte(14)
      ..write(obj.language)
      ..writeByte(15)
      ..write(obj.shortdescription)
      ..writeByte(16)
      ..write(obj.version)
      ..writeByte(17)
      ..write(obj.startpage)
      ..writeByte(18)
      ..write(obj.createduserid)
      ..writeByte(19)
      ..write(obj.createddate)
      ..writeByte(20)
      ..write(obj.keywords)
      ..writeByte(21)
      ..write(obj.downloadable)
      ..writeByte(22)
      ..write(obj.publisheddate)
      ..writeByte(23)
      ..write(obj.status)
      ..writeByte(24)
      ..write(obj.cmsgroupid)
      ..writeByte(25)
      ..write(obj.checkedoutto)
      ..writeByte(26)
      ..write(obj.longdescription)
      ..writeByte(27)
      ..write(obj.mediatypeid)
      ..writeByte(28)
      ..write(obj.owner)
      ..writeByte(29)
      ..write(obj.publicationdate)
      ..writeByte(30)
      ..write(obj.activatedate)
      ..writeByte(31)
      ..write(obj.expirydate)
      ..writeByte(32)
      ..write(obj.thumbnailimagepath)
      ..writeByte(33)
      ..write(obj.ecommbussinessrule)
      ..writeByte(34)
      ..write(obj.downloadfile)
      ..writeByte(35)
      ..write(obj.saleprice)
      ..writeByte(36)
      ..write(obj.listprice)
      ..writeByte(37)
      ..write(obj.folderpath)
      ..writeByte(38)
      ..write(obj.skinid)
      ..writeByte(39)
      ..write(obj.folderid)
      ..writeByte(40)
      ..write(obj.modifieduserid)
      ..writeByte(41)
      ..write(obj.modifieddate)
      ..writeByte(42)
      ..write(obj.viewtype)
      ..writeByte(43)
      ..write(obj.windowproperties)
      ..writeByte(44)
      ..write(obj.currency)
      ..writeByte(45)
      ..write(obj.certificateid)
      ..writeByte(46)
      ..write(obj.launchwindowmode)
      ..writeByte(47)
      ..write(obj.active)
      ..writeByte(48)
      ..write(obj.hardwaretype)
      ..writeByte(49)
      ..write(obj.enrollmentlimit)
      ..writeByte(50)
      ..write(obj.presenterurl)
      ..writeByte(51)
      ..write(obj.participanturl)
      ..writeByte(52)
      ..write(obj.eventstartdatetime)
      ..writeByte(53)
      ..write(obj.eventenddatetime)
      ..writeByte(54)
      ..write(obj.presenterid)
      ..writeByte(55)
      ..write(obj.contentstatus)
      ..writeByte(56)
      ..write(obj.location)
      ..writeByte(57)
      ..write(obj.conferencenumbers)
      ..writeByte(58)
      ..write(obj.directionurl)
      ..writeByte(59)
      ..write(obj.eventpercentage)
      ..writeByte(60)
      ..write(obj.starttime)
      ..writeByte(61)
      ..write(obj.duration)
      ..writeByte(62)
      ..write(obj.personalizediconid1)
      ..writeByte(63)
      ..write(obj.personalizediconid2)
      ..writeByte(64)
      ..write(obj.ciid)
      ..writeByte(65)
      ..write(obj.noofusersenrolled)
      ..writeByte(66)
      ..write(obj.noofuserscompleted)
      ..writeByte(67)
      ..write(obj.eventkey)
      ..writeByte(68)
      ..write(obj.eventtype)
      ..writeByte(69)
      ..write(obj.devicetypeid)
      ..writeByte(70)
      ..write(obj.nvarchar2)
      ..writeByte(71)
      ..write(obj.nvarchar3)
      ..writeByte(72)
      ..write(obj.audience)
      ..writeByte(73)
      ..write(obj.backgroundcolor)
      ..writeByte(74)
      ..write(obj.fontcolor)
      ..writeByte(75)
      ..write(obj.searchreferencenumber)
      ..writeByte(76)
      ..write(obj.nvarchar4)
      ..writeByte(77)
      ..write(obj.timezone)
      ..writeByte(78)
      ..write(obj.bit3)
      ..writeByte(79)
      ..write(obj.bit4)
      ..writeByte(80)
      ..write(obj.typeofevent)
      ..writeByte(81)
      ..write(obj.webinartool)
      ..writeByte(82)
      ..write(obj.webinarpassword)
      ..writeByte(83)
      ..write(obj.bit5)
      ..writeByte(84)
      ..write(obj.bit2)
      ..writeByte(85)
      ..write(obj.seotitle)
      ..writeByte(86)
      ..write(obj.seometadescription)
      ..writeByte(87)
      ..write(obj.seokeywords)
      ..writeByte(88)
      ..write(obj.waitlistlimit)
      ..writeByte(89)
      ..write(obj.totalattempts)
      ..writeByte(90)
      ..write(obj.accessperiodtype)
      ..writeByte(91)
      ..write(obj.itunesproductid)
      ..writeByte(92)
      ..write(obj.googleproductid)
      ..writeByte(93)
      ..write(obj.decimal2)
      ..writeByte(94)
      ..write(obj.budgetprice)
      ..writeByte(95)
      ..write(obj.budgetcurrency)
      ..writeByte(96)
      ..write(obj.eventresourcedisplayoption)
      ..writeByte(97)
      ..write(obj.certificatepercentage)
      ..writeByte(98)
      ..write(obj.activityid)
      ..writeByte(99)
      ..write(obj.eventscheduletype)
      ..writeByte(100)
      ..write(obj.bigint4)
      ..writeByte(101)
      ..write(obj.offeringstartdate)
      ..writeByte(102)
      ..write(obj.offeringenddate)
      ..writeByte(103)
      ..write(obj.contentauthordisplayname)
      ..writeByte(104)
      ..write(obj.registrationurl)
      ..writeByte(105)
      ..write(obj.videointroduction)
      ..writeByte(106)
      ..write(obj.noofmodules)
      ..writeByte(107)
      ..write(obj.learningobjectives)
      ..writeByte(108)
      ..write(obj.tableofcontent)
      ..writeByte(109)
      ..write(obj.tagname)
      ..writeByte(110)
      ..write(obj.credittypes)
      ..writeByte(111)
      ..write(obj.eventcategories)
      ..writeByte(112)
      ..write(obj.eventrecording)
      ..writeByte(113)
      ..write(obj.recordingmsg)
      ..writeByte(114)
      ..write(obj.recordingcontentid)
      ..writeByte(115)
      ..write(obj.recordingurl)
      ..writeByte(116)
      ..write(obj.scoid)
      ..writeByte(117)
      ..write(obj.startdate)
      ..writeByte(118)
      ..write(obj.datecompleted)
      ..writeByte(119)
      ..write(obj.accessednumber)
      ..writeByte(120)
      ..write(obj.noofattempts)
      ..writeByte(121)
      ..write(obj.totalsessiontime)
      ..writeByte(122)
      ..write(obj.corechildren)
      ..writeByte(123)
      ..write(obj.coreentry)
      ..writeByte(124)
      ..write(obj.corelessonstatus)
      ..writeByte(125)
      ..write(obj.corecredit)
      ..writeByte(126)
      ..write(obj.groupdisplayname)
      ..writeByte(127)
      ..write(obj.groupdisplayorder)
      ..writeByte(128)
      ..write(obj.corelessonlocation)
      ..writeByte(129)
      ..write(obj.scorechildren)
      ..writeByte(130)
      ..write(obj.scoreraw)
      ..writeByte(131)
      ..write(obj.scoremin)
      ..writeByte(132)
      ..write(obj.scoremax)
      ..writeByte(133)
      ..write(obj.launchdata)
      ..writeByte(134)
      ..write(obj.actualstatus)
      ..writeByte(135)
      ..write(obj.userid)
      ..writeByte(136)
      ..write(obj.dateassigned)
      ..writeByte(137)
      ..write(obj.targetdate)
      ..writeByte(138)
      ..write(obj.ismandatory)
      ..writeByte(139)
      ..write(obj.assignedby)
      ..writeByte(140)
      ..write(obj.assignedbyadmin)
      ..writeByte(141)
      ..write(obj.durationenddate)
      ..writeByte(142)
      ..write(obj.usercontentstatus)
      ..writeByte(143)
      ..write(obj.attemptsleft)
      ..writeByte(144)
      ..write(obj.accessperiod)
      ..writeByte(145)
      ..write(obj.accessperiodunit)
      ..writeByte(146)
      ..write(obj.isarchived)
      ..writeByte(147)
      ..write(obj.purchaseddate)
      ..writeByte(148)
      ..write(obj.joinurl)
      ..writeByte(149)
      ..write(obj.confirmationurl)
      ..writeByte(150)
      ..write(obj.xHide)
      ..writeByte(151)
      ..write(obj.required)
      ..writeByte(152)
      ..write(obj.schedulestatus)
      ..writeByte(153)
      ..write(obj.schedulereserveddatetime)
      ..writeByte(154)
      ..write(obj.percentcompleted)
      ..writeByte(155)
      ..write(obj.invitationurl)
      ..writeByte(156)
      ..write(obj.link)
      ..writeByte(157)
      ..write(obj.pareportlink)
      ..writeByte(158)
      ..write(obj.dareportlink)
      ..writeByte(159)
      ..write(obj.availableseats)
      ..writeByte(160)
      ..write(obj.waitlistenrolls)
      ..writeByte(161)
      ..write(obj.jwvideokey)
      ..writeByte(162)
      ..write(obj.cloudmediaplayerkey)
      ..writeByte(163)
      ..write(obj.usercertificateid)
      ..writeByte(164)
      ..write(obj.relatedconentcount)
      ..writeByte(165)
      ..write(obj.dtfcontent)
      ..writeByte(166)
      ..write(obj.ratingid)
      ..writeByte(167)
      ..write(obj.totalratings)
      ..writeByte(168)
      ..write(obj.certificatepage)
      ..writeByte(169)
      ..write(obj.locationname)
      ..writeByte(170)
      ..write(obj.buildingname)
      ..writeByte(171)
      ..write(obj.commentscount)
      ..writeByte(172)
      ..write(obj.authordisplayname)
      ..writeByte(173)
      ..write(obj.presenter)
      ..writeByte(174)
      ..write(obj.isdownloaded)
      ..writeByte(175)
      ..write(obj.eventrecording1)
      ..writeByte(176)
      ..write(obj.recordingmsg1)
      ..writeByte(177)
      ..write(obj.recordingcontentid1)
      ..writeByte(178)
      ..write(obj.recordingurl1)
      ..writeByte(179)
      ..write(obj.eventstartdatedisplay)
      ..writeByte(180)
      ..write(obj.eventenddatedisplay)
      ..writeByte(181)
      ..write(obj.timezoneabbreviation)
      ..writeByte(182)
      ..write(obj.siteurl)
      ..writeByte(183)
      ..write(obj.progress)
      ..writeByte(184)
      ..write(obj.removelink)
      ..writeByte(185)
      ..write(obj.reschduleparentid)
      ..writeByte(186)
      ..write(obj.isbadcancellationenabled)
      ..writeByte(187)
      ..write(obj.jwstartpage)
      ..writeByte(188)
      ..write(obj.isenrollfutureinstance)
      ..writeByte(189)
      ..write(obj.isviewreview)
      ..writeByte(190)
      ..write(obj.certificateaction)
      ..writeByte(191)
      ..write(obj.qrcodeimagepath)
      ..writeByte(192)
      ..write(obj.qrimagename)
      ..writeByte(193)
      ..write(obj.viewprerequisitecontentstatus)
      ..writeByte(194)
      ..write(obj.headerlocationname)
      ..writeByte(195)
      ..write(obj.suggesttoconnlink)
      ..writeByte(196)
      ..write(obj.suggestwithfriendlink)
      ..writeByte(197)
      ..write(obj.isDownloading)
      ..writeByte(198)
      ..write(obj.isaddedtomylearning)
      ..writeByte(199)
      ..write(obj.imageData)
      ..writeByte(200)
      ..write(obj.author)
      ..writeByte(201)
      ..write(obj.parentid)
      ..writeByte(202)
      ..write(obj.blockName)
      ..writeByte(203)
      ..write(obj.iswishlistcontent)
      ..writeByte(204)
      ..write(obj.actionwaitlist)
      ..writeByte(205)
      ..write(obj.ShareContentwithUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DummyMyCatelogResponseTable2Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
