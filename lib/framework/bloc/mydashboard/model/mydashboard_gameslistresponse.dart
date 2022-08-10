class GamesResponse {
  List<MydashboardGameModel> gamesList = [];

  GamesResponse({required this.gamesList});
}

class MydashboardGameModel {
  int gameID = 0;
  String gameName = "";

  MydashboardGameModel({this.gameID = 0, this.gameName = ""});

  MydashboardGameModel.fromJson(Map<String, dynamic> json) {
    gameID = json['GameID'];
    gameName = json['GameName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GameID'] = this.gameID;
    data['GameName'] = this.gameName;
    return data;
  }
}
