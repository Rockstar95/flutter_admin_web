import 'package:hive/hive.dart';

part 'CMIModel.g.dart';

@HiveType(typeId: 0)
class CMIModel {
  @HiveField(0)
  int Id = 0;

  @HiveField(1)
  String siteId = "";

  @HiveField(2)
  int scoId = 0;

  @HiveField(3)
  int userId = 0;

  @HiveField(4)
  String location = "";

  @HiveField(5)
  String status = "";

  @HiveField(6)
  String suspenddata = "";

  @HiveField(7)
  String isupdate = "";

  @HiveField(8)
  String sitrurl = "";

  @HiveField(9)
  String objecttypeid = "";

  @HiveField(10)
  String datecompleted = "";

  @HiveField(11)
  int noofattempts = 0;

  @HiveField(12)
  String score = "";

  @HiveField(13)
  String seqNum = "";

  @HiveField(14)
  String startdate = "";

  @HiveField(15)
  String timespent = "";

  @HiveField(16)
  String attemptsleft = "";

  @HiveField(17)
  String coursemode = "";

  @HiveField(18)
  String scoremin = "";

  @HiveField(19)
  String scoremax = "";

  @HiveField(20)
  String submittime = "";

  @HiveField(21)
  int trackscoid = 0;

  @HiveField(22)
  String qusseq = "";

  @HiveField(23)
  String pooledqusseq = "";

  @HiveField(24)
  String textResponses = "";

  @HiveField(25)
  String percentageCompleted = "";

  @HiveField(26)
  String parentObjTypeId = "";

  @HiveField(27)
  String parentContentId = "";

  @HiveField(28)
  String parentScoId = "";

  @HiveField(29)
  String contentId = "";

  @HiveField(30)
  String showStatus = "";

  CMIModel(
      {this.percentageCompleted = "",
      this.parentObjTypeId = "",
      this.parentContentId = "",
      this.parentScoId = "",
      this.contentId = "",
      this.showStatus = "",
      this.Id = 0,
      this.siteId = "",
      this.scoId = 0,
      this.userId = 0,
      this.location = "",
      this.status = "",
      this.suspenddata = "",
      this.isupdate = "",
      this.sitrurl = "",
      this.objecttypeid = "",
      this.datecompleted = "",
      this.noofattempts = 0,
      this.score = "",
      this.seqNum = "",
      this.startdate = "",
      this.timespent = "",
      this.attemptsleft = "",
      this.coursemode = "",
      this.scoremin = "",
      this.scoremax = "",
      this.submittime = "",
      this.trackscoid = 0,
      this.qusseq = "",
      this.pooledqusseq = "",
      this.textResponses = ""});
}
