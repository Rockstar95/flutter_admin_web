import 'package:hive/hive.dart';

part 'StudentResponseModel.g.dart';

@HiveType(typeId: 0)
class StudentResponseModel {
  @HiveField(0)
  String siteId;

  @HiveField(1)
  int scoId = 0;

  @HiveField(2)
  int userId = 0;

  @HiveField(3)
  int questionid = 0;

  @HiveField(4)
  int assessmentattempt = 0;

  @HiveField(5)
  int questionattempt = 0;

  @HiveField(6)
  String attemptdate = "";

  @HiveField(7)
  String studentresponses = "";

  @HiveField(8)
  String attachfilename = "";

  @HiveField(9)
  String attachfileid = "";

  @HiveField(10)
  String attachedfilepath = "";

  @HiveField(11)
  String optionalNotes = "";

  @HiveField(12)
  String result = "";

  @HiveField(13)
  int rindex = 0;

  @HiveField(14)
  String capturedVidFileName = "";

  @HiveField(15)
  String capturedVidId = "";

  @HiveField(16)
  String capturedVidFilepath = "";

  @HiveField(17)
  String capturedImgFileName = "";

  @HiveField(18)
  String capturedImgId = "";

  @HiveField(19)
  String capturedImgFilepath = "";

  StudentResponseModel(
      {this.siteId = "",
      this.scoId = 0,
      this.userId = 0,
      this.questionid = 0,
      this.assessmentattempt = 0,
      this.questionattempt = 0,
      this.attemptdate = "",
      this.studentresponses = "",
      this.attachfilename = "",
      this.attachfileid = "",
      this.attachedfilepath = "",
      this.optionalNotes = "",
      this.result = "",
      this.rindex = 0,
      this.capturedVidFileName = "",
      this.capturedVidId = "",
      this.capturedVidFilepath = "",
      this.capturedImgFileName = "",
      this.capturedImgId = "",
      this.capturedImgFilepath = ""});
}
