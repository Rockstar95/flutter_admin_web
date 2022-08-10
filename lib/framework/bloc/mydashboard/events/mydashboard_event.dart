import 'package:equatable/equatable.dart';

abstract class MyDashboardEvent extends Equatable {
  const MyDashboardEvent();
}

class GetGameListEvent extends MyDashboardEvent {
  final bool fromAchievement;
  final String userID;
  final String siteID;
  final String locale;
  final String componentID;
  final String componentInsID;
  final String leaderByGroup;
  final String gameID;

  GetGameListEvent(
      {this.fromAchievement = false,
      this.userID = "",
      this.siteID = "",
      this.locale = "",
      this.componentID = "",
      this.componentInsID = "",
      this.leaderByGroup = "",
      this.gameID = ""});

  @override
  List<Object> get props => [];
}

class GetLeaderboardDataEvent extends MyDashboardEvent {
  final String userID;
  final String siteID;
  final String locale;
  final String componentID;
  final String componentInsID;
  final String gameID;

  GetLeaderboardDataEvent(
      {this.userID = "",
      this.siteID = "",
      this.locale = "",
      this.componentID = "",
      this.componentInsID = "",
      this.gameID = ""});

  @override
  List<Object> get props => [];
}

class GetUserAchievementDataEvent extends MyDashboardEvent {
  final String userID;
  final String siteID;
  final String locale;
  final String componentID;
  final String componentInsID;
  final String gameID;

  GetUserAchievementDataEvent(
      {this.userID = "",
      this.siteID = "",
      this.locale = "",
      this.componentID = "",
      this.componentInsID = "",
      this.gameID = ""});

  @override
  List<Object> get props => [];
}

class GetMyCreditCertificateEvent extends MyDashboardEvent {
  final String userID;
  final String siteID;
  final String locale;

  GetMyCreditCertificateEvent({
    this.userID = "",
    this.siteID = "",
    this.locale = "",
  });

  @override
  List<Object> get props => [];
}
