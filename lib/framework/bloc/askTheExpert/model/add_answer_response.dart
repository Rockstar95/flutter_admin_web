class AddAnswerResponse {
  List<AddAnswer> table;

  AddAnswerResponse({required this.table});

  static AddAnswerResponse fromJson(Map<String, dynamic> json) {
    AddAnswerResponse addAnswerResponse = AddAnswerResponse(table: []);

    if (json['Table'] != null) {
      addAnswerResponse.table = [];
      json['Table'].forEach((v) {
        addAnswerResponse.table.add(AddAnswer.fromJson(v));
      });
    }

    return addAnswerResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Table'] = this.table.map((v) => v.toJson()).toList();
    return data;
  }
}

class AddAnswer {
  int questionID;
  int userID;
  String userName;
  String userQuestion;
  String userEmail;
  String createdDate;
  int respondedUserID;
  int responseID;
  String responseDate;
  String response;
  String respondedUserName;
  String respondedDate;
  String userResponseImage;
  String notifyMessage;

  AddAnswer(
      {this.questionID = 0,
      this.userID = 0,
      this.userName = "",
      this.userQuestion = "",
      this.userEmail = "",
      this.createdDate = "",
      this.respondedUserID = 0,
      this.responseID = 0,
      this.responseDate = "",
      this.response = "",
      this.respondedUserName = "",
      this.respondedDate = "",
      this.userResponseImage = "",
      this.notifyMessage = ""});

  static AddAnswer fromJson(Map<String, dynamic> json) {
    AddAnswer addAnswer = AddAnswer();
    addAnswer.questionID = json['QuestionID'] ?? 0;
    addAnswer.userID = json['UserID'] ?? 0;
    addAnswer.userName = json['UserName'] ?? "";
    addAnswer.userQuestion = json['UserQuestion'] ?? "";
    addAnswer.userEmail = json['UserEmail'] ?? "";
    addAnswer.createdDate = json['CreatedDate'] ?? "";
    addAnswer.respondedUserID = json['RespondedUserID'] ?? 0;
    addAnswer.responseID = json['ResponseID'] ?? 0;
    addAnswer.responseDate = json['ResponseDate'] ?? "";
    addAnswer.response = json['Response'] ?? "";
    addAnswer.respondedUserName = json['RespondedUserName'] ?? "";
    addAnswer.respondedDate = json['RespondedDate'] ?? "";
    addAnswer.userResponseImage = json['UserResponseImage'] ?? "";
    addAnswer.notifyMessage = json['NotifyMessage'] ?? "";
    return addAnswer;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionID'] = this.questionID;
    data['UserID'] = this.userID;
    data['UserName'] = this.userName;
    data['UserQuestion'] = this.userQuestion;
    data['UserEmail'] = this.userEmail;
    data['CreatedDate'] = this.createdDate;
    data['RespondedUserID'] = this.respondedUserID;
    data['ResponseID'] = this.responseID;
    data['ResponseDate'] = this.responseDate;
    data['Response'] = this.response;
    data['RespondedUserName'] = this.respondedUserName;
    data['RespondedDate'] = this.respondedDate;
    data['UserResponseImage'] = this.userResponseImage;
    data['NotifyMessage'] = this.notifyMessage;
    return data;
  }
}
