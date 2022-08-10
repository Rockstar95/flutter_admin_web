import 'package:http/http.dart';

import 'mydashboard_repositry_public.dart';

class MyDashboardRepositoryBuilder {
  static MyDashboardRepository repository() {
    return MyDashboardRepositoryPublic();
  }
}

abstract class MyDashboardRepository {
  Future<Response?> getGameList({
    bool fromAchievement,
    String userID,
    String siteID,
    String locale,
    String componentID,
    String componentInsID,
    String leaderByGroup,
    String gameID,
  });

  Future<Response?> getUserAchievementData({
    String userID,
    String siteID,
    String locale,
    String gameID,
    String componentID,
    String componentInsID,
  });

  Future<Response?> getLeaderboardData({
    String userID,
    String siteID,
    String locale,
    String componentID,
    String componentInsID,
    String gameID,
  });

  Future<Response?> getMyCreditCertificate({
    String userID,
    String siteID,
    String localeID,
  });
}
