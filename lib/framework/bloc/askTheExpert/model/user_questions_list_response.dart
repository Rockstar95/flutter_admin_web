import 'dart:convert';

UserQuestiondsListResponse userQuestiondsListResponseFromJson(String str) =>
    UserQuestiondsListResponse.fromJson(json.decode(str));

dynamic userQuestiondsListResponseToJson(UserQuestiondsListResponse data) =>
    json.encode(data.toJson());

class UserQuestiondsListResponse {
  List<QuestionList> questionList;
  int rowcount;

  UserQuestiondsListResponse({required this.questionList, this.rowcount = 0});

  static UserQuestiondsListResponse fromJson(Map<String, dynamic> json) {
    UserQuestiondsListResponse userQuestiondsListResponse =
        UserQuestiondsListResponse(questionList: []);
    if (json['QuestionList'] != null) {
      json['QuestionList'].forEach((v) {
        userQuestiondsListResponse.questionList
            .add(QuestionList.fromJson(v ?? {}));
      });
    }
    userQuestiondsListResponse.rowcount = json['rowcount'] ?? 0;
    return userQuestiondsListResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionList'] = this.questionList.map((v) => v.toJson()).toList();
    data['rowcount'] = this.rowcount;
    return data;
  }
}

class QuestionList {
  int questionID;
  int userID;
  String userName;
  String userQuestion;
  String postedDate;
  String createdDate;
  String answers;
  String questionCategories;
  String userQuestionDescription;
  String userQuestionImage;
  String lastActivatedDate;
  int views;
  int objectID;
  String titleWithLink;
  String answersWithLink;
  String userImage;
  String answerBtnWithLink;
  String deleteBtnWithLink;
  dynamic actionsLink;
  String actionSuggestConnection;
  String actionSharewithFriends;
  String userQuestionImagePath;
  String userQuestionImageUploadName;
  String userQuestionUploadIconPath;

  QuestionList({
    this.questionID = 0,
    this.userID = 0,
    this.userName = "",
    this.userQuestion = "",
    this.postedDate = "",
    this.createdDate = "",
    this.answers = "",
    this.questionCategories = "",
    this.userQuestionDescription = "",
    this.userQuestionImage = "",
    this.lastActivatedDate = "",
    this.views = 0,
    this.objectID = 0,
    this.titleWithLink = "",
    this.answersWithLink = "",
    this.userImage = "",
    this.answerBtnWithLink = "",
    this.deleteBtnWithLink = "",
    this.actionsLink,
    this.actionSuggestConnection = "",
    this.actionSharewithFriends = "",
    this.userQuestionImagePath = "",
    this.userQuestionImageUploadName = "",
    this.userQuestionUploadIconPath = "",
  });

  static QuestionList fromJson(Map<String, dynamic> json) {
    QuestionList questionList = QuestionList();
    questionList.questionID = json['QuestionID'] ?? 0;
    questionList.userID = json['UserID'] ?? 0;
    questionList.userName = json['UserName'] ?? "";
    questionList.userQuestion = json['UserQuestion'] ?? "";
    questionList.postedDate = json['PostedDate'] ?? "";
    questionList.createdDate = json['CreatedDate'] ?? "";
    questionList.answers = json['Answers'] ?? "";
    questionList.questionCategories = json['QuestionCategories'] ?? "";
    questionList.userQuestionDescription =
        json['UserQuestionDescription'] ?? "";
    questionList.userQuestionImage = json['UserQuestionImage'] ?? "";
    questionList.lastActivatedDate = json['LastActivatedDate'] ?? "";
    questionList.views = json['Views'] ?? 0;
    questionList.objectID = json['ObjectID'] ?? 0;
    questionList.titleWithLink = json['TitleWithLink'] ?? "";
    questionList.answersWithLink = json['AnswersWithLink'] ?? "";
    questionList.userImage = json['UserImage'] ?? "";
    questionList.answerBtnWithLink = json['AnswerBtnWithLink'] ?? "";
    questionList.deleteBtnWithLink = json['DeleteBtnWithLink'] ?? "";
    questionList.actionsLink = json['ActionsLink'];
    questionList.actionSuggestConnection =
        json['actionSuggestConnection'] ?? "";
    questionList.actionSharewithFriends = json['actionSharewithFriends'] ?? "";
    questionList.userQuestionImagePath = json['UserQuestionImagePath'] ?? "";
    questionList.userQuestionImageUploadName =
        json['UserQuestionImageUploadName'] ?? "";
    questionList.userQuestionUploadIconPath =
        json['UserQuestionUploadIconPath'] ?? "";
    return questionList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionID'] = this.questionID;
    data['UserID'] = this.userID;
    data['UserName'] = this.userName;
    data['UserQuestion'] = this.userQuestion;
    data['PostedDate'] = this.postedDate;
    data['CreatedDate'] = this.createdDate;
    data['Answers'] = this.answers;
    data['QuestionCategories'] = this.questionCategories;
    data['UserQuestionDescription'] = this.userQuestionDescription;
    data['UserQuestionImage'] = this.userQuestionImage;
    data['LastActivatedDate'] = this.lastActivatedDate;
    data['Views'] = this.views;
    data['ObjectID'] = this.objectID;
    data['TitleWithLink'] = this.titleWithLink;
    data['AnswersWithLink'] = this.answersWithLink;
    data['UserImage'] = this.userImage;
    data['AnswerBtnWithLink'] = this.answerBtnWithLink;
    data['DeleteBtnWithLink'] = this.deleteBtnWithLink;
    data['ActionsLink'] = this.actionsLink;
    data['actionSuggestConnection'] = this.actionSuggestConnection;
    data['actionSharewithFriends'] = this.actionSharewithFriends;
    data['UserQuestionImagePath'] = this.userQuestionImagePath;
    data['UserQuestionImageUploadName'] = this.userQuestionImageUploadName;
    data['UserQuestionUploadIconPath'] = this.userQuestionUploadIconPath;
    return data;
  }
}
