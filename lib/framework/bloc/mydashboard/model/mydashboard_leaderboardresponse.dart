class LeaderBoardResponse {
  List<LeaderBoardList> leaderBoardList = [];
  int totalCount = 0;
  bool showBadges = false;
  bool showPoints = false;
  bool showLevels = false;
  bool showLoggedUserTop = false;

  LeaderBoardResponse(
      {required this.leaderBoardList,
      this.totalCount = 0,
      this.showBadges = false,
      this.showPoints = false,
      this.showLevels = false,
      this.showLoggedUserTop = false});

  LeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    if (json['LeaderBoardList'] != null) {
      json['LeaderBoardList'].forEach((v) {
        leaderBoardList.add(LeaderBoardList.fromJson(v));
      });
    }
    totalCount = json['TotalCount'] ?? 0;
    showBadges = json['showBadges'] ?? false;
    showPoints = json['showPoints'] ?? false;
    showLevels = json['showLevels'] ?? false;
    showLoggedUserTop = json['showLoggedUserTop'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leaderBoardList != null) {
      data['LeaderBoardList'] =
          this.leaderBoardList.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    data['showBadges'] = this.showBadges;
    data['showPoints'] = this.showPoints;
    data['showLevels'] = this.showLevels;
    data['showLoggedUserTop'] = this.showLoggedUserTop;
    return data;
  }
}

class LeaderBoardList {
  int gameID = 0;
  String gameName = "";
  int intUserID = 0;
  int intSiteID = 0;
  String userDisplayName = "";
  String userEmail = "";
  String userPicturePath = "";
  String levelName = "";
  int proflieleaderboarduserid = 0;
  int points = 0;
  int badges = 0;
  int rank = 0;
  String profileAction = "";

  LeaderBoardList(
      /*{this.gameID,
      this.gameName,
      this.intUserID,
      this.intSiteID,
      this.userDisplayName,
      this.userEmail,
      this.userPicturePath,
      this.levelName,
      this.proflieleaderboarduserid,
      this.points,
      this.badges,
      this.rank,
      this.profileAction}*/
      );

  LeaderBoardList.fromJson(Map<String, dynamic> json) {
    gameID = json['GameID'] ?? 0;
    gameName = json['GameName'] ?? '';
    intUserID = json['intUserID'] ?? 0;
    intSiteID = json['intSiteID'] ?? 0;
    userDisplayName = json['UserDisplayName'] ?? '';
    userEmail = json['UserEmail'] ?? '';
    userPicturePath = json['UserPicturePath'] ?? '';
    levelName = json['LevelName'] ?? '';
    proflieleaderboarduserid = json['proflieleaderboarduserid'] ?? 0;
    points = json['Points'] ?? 0;
    badges = json['Badges'] ?? 0;
    rank = json['Rank'] ?? 0;
    profileAction = json['ProfileAction'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GameID'] = this.gameID;
    data['GameName'] = this.gameName;
    data['intUserID'] = this.intUserID;
    data['intSiteID'] = this.intSiteID;
    data['UserDisplayName'] = this.userDisplayName;
    data['UserEmail'] = this.userEmail;
    data['UserPicturePath'] = this.userPicturePath;
    data['LevelName'] = this.levelName;
    data['proflieleaderboarduserid'] = this.proflieleaderboarduserid;
    data['Points'] = this.points;
    data['Badges'] = this.badges;
    data['Rank'] = this.rank;
    data['ProfileAction'] = this.profileAction;
    return data;
  }
}
