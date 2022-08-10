class UserAchievementResponse {
  UserOverAllData? userOverAllData;
  List<UserPoints> userPoints = [];
  List<UserLevel> userLevel = [];
  List<UserBadges> userBadges = [];
  bool showBadgeSection = false;
  bool showPointSection = false;
  bool showLevelSection = false;

  UserAchievementResponse(
      /*{this.userOverAllData,
      this.userPoints,
      this.userLevel,
      this.userBadges,
      this.showBadgeSection,
      this.showPointSection,
      this.showLevelSection}*/
      );

  UserAchievementResponse.fromJson(Map<String, dynamic> json) {
    userOverAllData = json['UserOverAllData'] != null
        ? new UserOverAllData.fromJson(json['UserOverAllData'])
        : null;
    if (json['UserPoints'] != null) {
      json['UserPoints'].forEach((v) {
        userPoints.add(new UserPoints.fromJson(v));
      });
    }
    if (json['UserLevel'] != null) {
      json['UserLevel'].forEach((v) {
        userLevel.add(new UserLevel.fromJson(v));
      });
    }
    if (json['UserBadges'] != null) {
      json['UserBadges'].forEach((v) {
        userBadges.add(new UserBadges.fromJson(v));
      });
    }
    showBadgeSection = json['showBadgeSection'];
    showPointSection = json['showPointSection'];
    showLevelSection = json['showLevelSection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userOverAllData != null) {
      data['UserOverAllData'] = this.userOverAllData?.toJson();
    }
    if (this.userPoints != null) {
      data['UserPoints'] = this.userPoints.map((v) => v.toJson()).toList();
    }
    if (this.userLevel != null) {
      data['UserLevel'] = this.userLevel.map((v) => v.toJson()).toList();
    }
    if (this.userBadges != null) {
      data['UserBadges'] = this.userBadges.map((v) => v.toJson()).toList();
    }
    data['showBadgeSection'] = this.showBadgeSection;
    data['showPointSection'] = this.showPointSection;
    data['showLevelSection'] = this.showLevelSection;
    return data;
  }
}

class UserOverAllData {
  int overAllPoints = 0;
  int badges = 0;
  String userLevel = "";
  String userProfilePath = "";
  String userDisplayName = "";
  int neededPoints = 0;
  String neededLevel = "";
  int gameID = 0;
  int userID = 0;

  UserOverAllData(
      /*{this.overAllPoints,
      this.badges,
      this.userLevel,
      this.userProfilePath,
      this.userDisplayName,
      this.neededPoints,
      this.neededLevel,
      this.gameID,
      this.userID}*/
      );

  UserOverAllData.fromJson(Map<String, dynamic> json) {
    overAllPoints = json['OverAllPoints'];
    badges = json['Badges'];
    userLevel = json['UserLevel'];
    userProfilePath = json['UserProfilePath'];
    userDisplayName = json['UserDisplayName'];
    neededPoints = json['NeededPoints'];
    neededLevel = json['NeededLevel'];
    gameID = json['GameID'];
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OverAllPoints'] = this.overAllPoints;
    data['Badges'] = this.badges;
    data['UserLevel'] = this.userLevel;
    data['UserProfilePath'] = this.userProfilePath;
    data['UserDisplayName'] = this.userDisplayName;
    data['NeededPoints'] = this.neededPoints;
    data['NeededLevel'] = this.neededLevel;
    data['GameID'] = this.gameID;
    data['UserID'] = this.userID;
    return data;
  }
}

class UserPoints {
  int actionID = 0;
  String actionName = "";
  String description = "";
  int points = 0;
  String userReceivedDate = "";
  int gameID = 0;
  int userID = 0;

  UserPoints(
      /*{this.actionID,
      this.actionName,
      this.description,
      this.points,
      this.userReceivedDate,
      this.gameID,
      this.userID}*/
      );

  UserPoints.fromJson(Map<String, dynamic> json) {
    actionID = json['ActionID'];
    actionName = json['ActionName'];
    description = json['Description'];
    points = json['Points'];
    userReceivedDate = json['UserReceivedDate'];
    gameID = json['GameID'];
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActionID'] = this.actionID;
    data['ActionName'] = this.actionName;
    data['Description'] = this.description;
    data['Points'] = this.points;
    data['UserReceivedDate'] = this.userReceivedDate;
    data['GameID'] = this.gameID;
    data['UserID'] = this.userID;
    return data;
  }
}

class UserLevel {
  String levelName = "";
  int levelPoints = 0;
  int levelID = 0;
  String levelRecivedDate = "";
  int gameID = 0;
  int userID = 0;

  UserLevel(
      /*{this.levelName,
      this.levelPoints,
      this.levelID,
      this.levelRecivedDate,
      this.gameID,
      this.userID}*/
      );

  UserLevel.fromJson(Map<String, dynamic> json) {
    levelName = json['LevelName'] ?? "";
    levelPoints = json['LevelPoints'] ?? 0;
    levelID = json['LevelID'] ?? 0;
    levelRecivedDate = json['LevelRecivedDate'] ?? "";
    gameID = json['GameID'] ?? 0;
    userID = json['UserID'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LevelName'] = this.levelName;
    data['LevelPoints'] = this.levelPoints;
    data['LevelID'] = this.levelID;
    data['LevelRecivedDate'] = this.levelRecivedDate;
    data['GameID'] = this.gameID;
    data['UserID'] = this.userID;
    return data;
  }
}

class UserBadges {
  int badgeID = 0;
  String badgeName = "";
  String badgeDescription = "";
  String badgeImage = "";
  String badgeReceivedDate = "";
  int gameID = 0;
  int userID = 0;

  UserBadges(
      /*{this.badgeID,
      this.badgeName,
      this.badgeDescription,
      this.badgeImage,
      this.badgeReceivedDate,
      this.gameID,
      this.userID}*/
      );

  UserBadges.fromJson(Map<String, dynamic> json) {
    badgeID = json['BadgeID'];
    badgeName = json['BadgeName'];
    badgeDescription = json['BadgeDescription'];
    badgeImage = json['BadgeImage'];
    badgeReceivedDate = json['BadgeReceivedDate'];
    gameID = json['GameID'];
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BadgeID'] = this.badgeID;
    data['BadgeName'] = this.badgeName;
    data['BadgeDescription'] = this.badgeDescription;
    data['BadgeImage'] = this.badgeImage;
    data['BadgeReceivedDate'] = this.badgeReceivedDate;
    data['GameID'] = this.gameID;
    data['UserID'] = this.userID;
    return data;
  }
}
