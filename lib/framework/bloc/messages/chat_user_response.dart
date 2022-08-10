import 'dart:convert';

ChatUserResponse chatUserResponseFromJson(String str) =>
    ChatUserResponse.fromJson(json.decode(str));

String chatUserResponseToJson(ChatUserResponse data) =>
    json.encode(data.toJson());

class ChatUserResponse {
  List<ChatUser> table;

  ChatUserResponse({
    required this.table,
  });

  factory ChatUserResponse.fromJson(Map<String, dynamic> json) =>
      ChatUserResponse(
        table:
            List<ChatUser>.from(json["Table"].map((x) => ChatUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class ChatUser {
  ChatUser({
    this.userId = "",
    this.fullName = "",
    this.unReadCount = 0,
    this.profPic = "",
    this.sendDateTime,
    this.country = "",
    this.myconid = 0,
    this.connectionStatus = 0,
    this.roleId = 0,
    this.siteId = 0,
    this.userStatus = 0,
    this.role = "",
    this.rankNo = 0,
    this.archivedUserId = 0,
    this.latestMessage = "",
    this.jobTitle = "",
  });

  String userId = "";
  String fullName = "";
  int unReadCount = 0;
  String profPic = "";
  DateTime? sendDateTime;
  String country = "";
  int myconid = 0;
  int connectionStatus = 0;
  int roleId = 0;
  int siteId = 0;
  int userStatus = 0;
  String role = "";
  int rankNo = 0;
  int archivedUserId = 0;
  String latestMessage = "";
  String jobTitle = "";

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        userId: "${json['UserID'] ?? 0}",
        fullName: json["FullName"],
        unReadCount: json["UnReadCount"],
        profPic: json["ProfPic"],
        sendDateTime: DateTime.parse(json["SendDateTime"]),
        country: json["Country"],
        myconid: json["Myconid"],
        connectionStatus: json["ConnectionStatus"],
        roleId: json["RoleID"],
        siteId: json["SiteID"],
        userStatus: json["UserStatus"],
        role: json["Role"],
        rankNo: json["RankNo"],
        archivedUserId: json["ArchivedUserID"],
        latestMessage: json["LatestMessage"],
        jobTitle: json["JobTitle"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FullName": fullName,
        "UnReadCount": unReadCount,
        "ProfPic": profPic,
        "SendDateTime": sendDateTime?.toIso8601String() ?? "",
        "Country": country,
        "Myconid": myconid,
        "ConnectionStatus": connectionStatus,
        "RoleID": roleId,
        "SiteID": siteId,
        "UserStatus": userStatus,
        "Role": role,
        "RankNo": rankNo,
        "ArchivedUserID": archivedUserId,
        "LatestMessage": latestMessage,
        "JobTitle": jobTitle,
      };
}
