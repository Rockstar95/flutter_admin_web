import 'package:hive/hive.dart';

part 'LearnerSessionModel.g.dart';

@HiveType(typeId: 0)
class LearnerSessionModel {
  @HiveField(0)
  String sessionID = "";

  @HiveField(1)
  String userID = "";

  @HiveField(2)
  String scoID = "";

  @HiveField(3)
  String attemptNumber = "";

  @HiveField(4)
  String sessionDateTime = "";

  @HiveField(5)
  String timeSpent = "";

  @HiveField(6)
  String siteID = "";

  LearnerSessionModel(
      {this.sessionID = "",
      this.userID = "",
      this.scoID = "",
      this.attemptNumber = "",
      this.sessionDateTime = "",
      this.timeSpent = "",
      this.siteID = ""});
}
