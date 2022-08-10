import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_creditcertificateresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_leaderboardresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_userachivmentsresponse.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class MyDashboardState extends ApiState {
  final bool displayMessage;

  MyDashboardState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  MyDashboardState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  MyDashboardState.error(data, {this.displayMessage = true})
      : super.error(
          data,
        );

  List<Object> get props => [];
}

class InitialMyDashboardState extends MyDashboardState {
  InitialMyDashboardState.completed(data) : super.completed(data);
}

class GetGameslistState extends MyDashboardState {
  String message = "";

  GetGameslistState.loading(data) : super.loading(data);

  GetGameslistState.completed({this.message = ""}) : super.completed(message);

  GetGameslistState.error(data) : super.error(data);
}

class GetLeaderboardDataState extends MyDashboardState {
  LeaderBoardResponse leaderBoardResponse =
      LeaderBoardResponse(leaderBoardList: []);

  GetLeaderboardDataState.loading(data) : super.loading(data);

  GetLeaderboardDataState.completed({required this.leaderBoardResponse})
      : super.completed(leaderBoardResponse);

  GetLeaderboardDataState.error(data) : super.error(data);
}

class GetUserAchievementDataState extends MyDashboardState {
  UserAchievementResponse userAchievementResponse = UserAchievementResponse();

  GetUserAchievementDataState.loading(data) : super.loading(data);

  GetUserAchievementDataState.completed({required this.userAchievementResponse})
      : super.completed(userAchievementResponse);

  GetUserAchievementDataState.error(data) : super.error(data);
}

class GetMyCreditCertificateaState extends MyDashboardState {
  MyCreditCertificateresponse? myCreditCertificateresponse;

  GetMyCreditCertificateaState.loading(data) : super.loading(data);

  GetMyCreditCertificateaState.completed({this.myCreditCertificateresponse})
      : super.completed(myCreditCertificateresponse);

  GetMyCreditCertificateaState.error(data) : super.error(data);
}
