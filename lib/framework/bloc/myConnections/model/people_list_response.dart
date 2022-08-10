import 'dart:convert';

PeopleListResponse peopleListResponseFromJson(String str) =>
    PeopleListResponse.fromJson(json.decode(str));

String peopleListResponseToJson(PeopleListResponse data) =>
    json.encode(data.toJson());

class PeopleListResponse {
  List<PeopleModel> peopleList = [];
  int peopleCount = 0;
  int mainSiteUserId = 0;

  PeopleListResponse({
    required this.peopleList,
    this.peopleCount = 0,
    this.mainSiteUserId = 0,
  });

  factory PeopleListResponse.fromJson(Map<String, dynamic> json) =>
      PeopleListResponse(
        peopleList: List<PeopleModel>.from(
            json["PeopleList"].map((x) => PeopleModel.fromJson(x))),
        peopleCount: json["PeopleCount"],
        mainSiteUserId: json["MainSiteUserID"],
      );

  Map<String, dynamic> toJson() => {
        "PeopleList": List<dynamic>.from(peopleList.map((x) => x.toJson())),
        "PeopleCount": peopleCount,
        "MainSiteUserID": mainSiteUserId,
      };
}

class PeopleModel {
  PeopleModel({
    this.connectionUserId = 0,
    this.objectId = 0,
    this.jobTitle = "",
    this.mainOfficeAddress = "",
    this.memberProfileImage = "",
    this.noImageText = "",
    this.userDisplayname = "",
    this.connectionstate = "",
    this.connectionstateAccept = "",
    this.viewProfileAction = "",
    this.askTheQuestion = "",
    this.acceptAction = "",
    this.ignoreAction = "",
    this.viewContentAction = "",
    this.sendMessageAction = "",
    this.addToMyConnectionAction = "",
    this.removeFromMyConnectionAction = "",
    this.interestAreas = "",
    this.notaMember = 0,
    this.connectedDays = "",
    this.groupByActionName = "",
    this.groupByActionValue = "",
  });

  int connectionUserId = 0;
  int objectId = 0;
  String jobTitle = "";
  String mainOfficeAddress = "";
  String memberProfileImage = "";
  String noImageText = "";
  String userDisplayname = "";
  String connectionstate = "";
  String connectionstateAccept = "";
  String viewProfileAction = "";
  String askTheQuestion = "";
  String acceptAction = "";
  String ignoreAction = "";
  String viewContentAction = "";
  String sendMessageAction = "";
  String addToMyConnectionAction = "";
  String removeFromMyConnectionAction = "";
  String interestAreas = "";
  int notaMember = 0;
  String connectedDays = "";
  String groupByActionName = "";
  String groupByActionValue = "";

  factory PeopleModel.fromJson(Map<String, dynamic> json) => PeopleModel(
        connectionUserId: json["ConnectionUserID"],
        objectId: json["ObjectID"],
        jobTitle: json["JobTitle"],
        mainOfficeAddress: json["MainOfficeAddress"],
        memberProfileImage: json["MemberProfileImage"],
        noImageText: json["NoImageText"],
        userDisplayname: json["UserDisplayname"],
        connectionstate: json["connectionstate"],
        connectionstateAccept: json["connectionstateAccept"],
        viewProfileAction: json["ViewProfileAction"],
        askTheQuestion: json["AskTheQuestion"],
        acceptAction: json["AcceptAction"],
        ignoreAction: json["IgnoreAction"],
        viewContentAction: json["ViewContentAction"],
        sendMessageAction: json["SendMessageAction"],
        addToMyConnectionAction: json["AddToMyConnectionAction"],
        removeFromMyConnectionAction: json["RemoveFromMyConnectionAction"],
        interestAreas: json["InterestAreas"],
        notaMember: json["NotaMember"],
        connectedDays: json["ConnectedDays"],
        groupByActionName: json["GroupByActionName"],
        groupByActionValue: json["GroupByActionValue"],
      );

  Map<String, dynamic> toJson() => {
        "ConnectionUserID": connectionUserId,
        "ObjectID": objectId,
        "JobTitle": jobTitle,
        "MainOfficeAddress": mainOfficeAddress,
        "MemberProfileImage": memberProfileImage,
        "NoImageText": noImageText,
        "UserDisplayname": userDisplayname,
        "connectionstate": connectionstate,
        "connectionstateAccept": connectionstateAccept,
        "ViewProfileAction": viewProfileAction,
        "AskTheQuestion": askTheQuestion,
        "AcceptAction": acceptAction,
        "IgnoreAction": ignoreAction,
        "ViewContentAction": viewContentAction,
        "SendMessageAction": sendMessageAction,
        "AddToMyConnectionAction": addToMyConnectionAction,
        "RemoveFromMyConnectionAction": removeFromMyConnectionAction,
        "InterestAreas": interestAreas,
        "NotaMember": notaMember,
        "ConnectedDays": connectedDays,
        "GroupByActionName": groupByActionName,
        "GroupByActionValue": groupByActionValue,
      };
}
