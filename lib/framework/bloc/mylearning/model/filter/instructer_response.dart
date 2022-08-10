// To parse this JSON data, do
//
//     final instructerListResponse = instructerListResponseFromJson(jsonString);

import 'dart:convert';

InstructerListResponse instructerListResponseFromJson(String str) =>
    InstructerListResponse.fromJson(json.decode(str));

String instructerListResponseToJson(InstructerListResponse data) =>
    json.encode(data.toJson());

class InstructerListResponse {
  InstructerListResponse({
    required this.table,
  });

  List<User> table = [];

  factory InstructerListResponse.fromJson(Map<String, dynamic> json) =>
      InstructerListResponse(
        table: json["Table"] == null
            ? []
            : List<User>.from(json["Table"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": table == null
            ? null
            : List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class User {
  User({
    this.userId = 0,
    this.userName = "",
  });

  int userId = 0;
  String userName = "";

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"] == null ? null : json["UserID"],
        userName: json["UserName"] == null ? null : json["UserName"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId == null ? null : userId,
        "UserName": userName == null ? null : userName,
      };
}
