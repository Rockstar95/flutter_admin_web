import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/events/mydashboard_event.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_creditcertificateresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_gameslistresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_leaderboardresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_userachivmentsresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/states/mydashboard_state.dart';
import 'package:flutter_admin_web/framework/repository/mydashboard/mydashboard_repositry_builder.dart';

class MyDashBoardBloc extends Bloc<MyDashboardEvent, MyDashboardState> {
  MyDashboardRepository myDashboardRepository;

  List<MydashboardGameModel> gameslist = [];

  LeaderBoardResponse leaderBoardResponse =
      LeaderBoardResponse(leaderBoardList: []);

  UserAchievementResponse userAchievementResponse =
      new UserAchievementResponse();

  MyCreditCertificateresponse myCreditCertificateresponse =
      MyCreditCertificateresponse(table1: [], table: [], table2: []);

  bool fabButtonVisible = false;

  MyDashBoardBloc({required this.myDashboardRepository})
      : super(MyDashboardState.completed(null)) {
    on<GetGameListEvent>(onEventHandler);
    on<GetLeaderboardDataEvent>(onEventHandler);
    on<GetUserAchievementDataEvent>(onEventHandler);
    on<GetMyCreditCertificateEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(MyDashboardEvent event, Emitter emit) async {
    print("MyDashBoardBloc onEventHandler called for ${event.runtimeType}");
    Stream<MyDashboardState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (MyDashboardState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  MyDashboardState get initialState => MyDashboardState.completed("data");

  @override
  Stream<MyDashboardState> mapEventToState(MyDashboardEvent event) async* {
    // TODO: implement mapEventToState
    try {
      if (event is GetGameListEvent) {
        yield GetGameslistState.loading('Please wait');
        Response? apiResponse = await myDashboardRepository.getGameList(
            componentID: event.componentID,
            componentInsID: event.componentInsID,
            fromAchievement: event.fromAchievement,
            gameID: event.gameID,
            leaderByGroup: event.leaderByGroup,
            locale: event.locale,
            siteID: event.siteID,
            userID: event.userID);
        if (apiResponse?.statusCode == 200) {
          var jsonArray =
              new List<dynamic>.from(jsonDecode(apiResponse?.body ?? "[]"));
          yield GetGameslistState.completed(
              message: apiResponse?.body.toString() ?? "[]");
          gameslist = jsonArray
              .map((e) => new MydashboardGameModel.fromJson(e))
              .toList();
          print("REsponse ${gameslist.length}");
        } else if (apiResponse?.statusCode == 401) {
          yield GetGameslistState.error('401');
        } else {
          yield GetGameslistState.error('Something went wrong');
        }
      }

      if (event is GetLeaderboardDataEvent) {
        yield GetLeaderboardDataState.loading('Please wait');
        Response? apiResponse = await myDashboardRepository.getLeaderboardData(
            userID: event.userID,
            siteID: event.siteID,
            locale: event.locale,
            componentID: event.componentID,
            componentInsID: event.componentInsID,
            gameID: event.gameID); //event.jobroles);
        if (apiResponse?.statusCode == 200) {
          Map valueMap = json.decode(apiResponse?.body ?? "{}");

          leaderBoardResponse =
              LeaderBoardResponse.fromJson(Map.castFrom(valueMap));

          print(leaderBoardResponse.leaderBoardList);

          yield GetLeaderboardDataState.completed(
              leaderBoardResponse: leaderBoardResponse);
        } else if (apiResponse?.statusCode == 401) {
          yield GetLeaderboardDataState.error('401');
        } else {
          yield GetLeaderboardDataState.error('Something went wrong');
        }
      }

      if (event is GetUserAchievementDataEvent) {
        Response? apiResponse =
            await myDashboardRepository.getUserAchievementData(
                userID: event.userID,
                siteID: event.siteID,
                locale: event.locale,
                gameID: event.gameID,
                componentInsID: event.componentInsID,
                componentID: event.componentID);
        if (apiResponse?.statusCode == 200) {
          Map valueMap = json.decode(apiResponse?.body ?? "{}");

          userAchievementResponse =
              UserAchievementResponse.fromJson(Map.castFrom(valueMap));

          yield GetUserAchievementDataState.completed(
              userAchievementResponse: userAchievementResponse);
        } else if (apiResponse?.statusCode == 401) {
          yield GetUserAchievementDataState.error('401');
        } else {
          yield GetUserAchievementDataState.error('Something went wrong');
        }
      }

      if (event is GetMyCreditCertificateEvent) {
        Response? apiResponse =
            await myDashboardRepository.getMyCreditCertificate(
                userID: event.userID,
                siteID: event.siteID,
                localeID: event.locale);
        if (apiResponse?.statusCode == 200) {
          Map valueMap = json.decode(apiResponse?.body ?? "{}");

          myCreditCertificateresponse =
              MyCreditCertificateresponse.fromJson(Map.castFrom(valueMap));

          yield GetMyCreditCertificateaState.completed(
              myCreditCertificateresponse: myCreditCertificateresponse);
        } else if (apiResponse?.statusCode == 401) {
          yield GetMyCreditCertificateaState.error('401');
        } else {
          yield GetMyCreditCertificateaState.error('Something went wrong');
        }
      }
    } catch (e) {
      print("Error in MyDashBoardBloc.mapEventToState():$e");
    }
  }
}
