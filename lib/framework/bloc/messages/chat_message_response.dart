import 'dart:convert';

import 'package:flutter_admin_web/framework/common/enums.dart';

ChatMessageResponse chatMessageResponseFromJson(String str) =>
    ChatMessageResponse.fromJson(json.decode(str));

String chatMessageResponseToJson(ChatMessageResponse data) =>
    json.encode(data.toJson());

class ChatMessageResponse {
  ChatMessageResponse({
    required this.table,
    required this.table1,
  });

  List<Table> table;
  List<Message> table1;

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      ChatMessageResponse(
        table: List<Table>.from(json["Table"].map((x) => Table.fromJson(x))),
        table1:
            List<Message>.from(json["Table1"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": List<dynamic>.from(table.map((x) => x.toJson())),
        "Table1": List<dynamic>.from(table1.map((x) => x.toJson())),
      };
}

class Table {
  Table({
    this.sentDate,
  });

  DateTime? sentDate;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        sentDate: DateTime.parse(json["SentDate"]),
      );

  Map<String, dynamic> toJson() => {
        "SentDate": sentDate?.toIso8601String() ?? "",
      };
}

class Message {
  Message(
      {this.chatId = 0,
      this.fromUserId = "",
      this.toUserId = "",
      this.message = "",
      this.attachment,
      //this.sendDateTime,
      this.markAsRead = false,
      this.fromStatus,
      this.toStatus,
      this.fromUserName = "",
      this.toUserName = "",
      this.profPic = "",
      //this.sentDate,
      this.date,
      this.fileUrl = "",
      this.msgType = MessageType.Text});

  int chatId = 0;
  String fromUserId = "";
  String toUserId = "";
  String message = "";
  dynamic attachment;

  //DateTime sendDateTime;
  bool markAsRead = false;
  dynamic fromStatus;
  dynamic toStatus;
  String fromUserName = "";
  String toUserName = "";
  String profPic = "";

  //DateTime sentDate;
  DateTime? date;
  String fileUrl = "";
  MessageType msgType;

  MessageType getMsgType(String typeStr) {
    switch (typeStr) {
      case 'Text':
        return MessageType.Text;
      case 'Image':
        return MessageType.Image;
      case 'Audio':
        return MessageType.Audio;
      case 'Video':
        return MessageType.Video;
      case 'Doc':
        return MessageType.Doc;
      default:
        return MessageType.Text;
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      chatId: json["chatId"] ?? 0,
      fromUserId: json["fromUserId"] ?? "",
      toUserId: json["toUserId"] ?? "",
      message: json["text"] ?? "",
      attachment: json["Attachment"],
      //sendDateTime: DateTime.parse(json["SendDateTime"]),
      markAsRead: json["MarkAsRead"] ?? false,
      fromStatus: json["FromStatus"],
      toStatus: json["ToStatus"],
      fromUserName: json["FromUserName"] ?? "",
      toUserName: json["ToUserName"] ?? "",
      profPic: json["ProfPic"] ?? "",
      //sentDate: DateTime.parse(json["SentDate"]),
      date: DateTime.parse(json["date"]),
      fileUrl: json["fileUrl"] ?? "",
      msgType: Message().getMsgType(json["msgType"]));

  Map<String, dynamic> toJson() => {
        "ChatID": chatId,
        "FromUserID": fromUserId,
        "ToUserID": toUserId,
        "Message": message,
        "Attachment": attachment,
        //"SendDateTime": sendDateTime.toIso8601String(),
        "MarkAsRead": markAsRead,
        "FromStatus": fromStatus,
        "ToStatus": toStatus,
        "FromUserName": fromUserName,
        "ToUserName": toUserName,
        "ProfPic": profPic,
        //"SentDate": sentDate.toIso8601String(),
        "date": date,
        "fileUrl": fileUrl,
        "msgType": msgType.toString().split('.').last
      };
}

// class Message {
//   Message({
//     this.chatId,
//     this.fromUserId,
//     this.toUserId,
//     this.message,
//     this.attachment,
//     this.sendDateTime,
//     this.markAsRead,
//     this.fromStatus,
//     this.toStatus,
//     this.fromUserName,
//     this.toUserName,
//     this.profPic,
//     this.sentDate,
//   });
//
//   int chatId;
//   int fromUserId;
//   int toUserId;
//   String message;
//   dynamic attachment;
//   DateTime sendDateTime;
//   bool markAsRead;
//   dynamic fromStatus;
//   dynamic toStatus;
//   String fromUserName;
//   String toUserName;
//   String profPic;
//   DateTime sentDate;
//
//   factory Message.fromJson(Map<String, dynamic> json) => Message(
//         chatId: json["ChatID"],
//         fromUserId: json["FromUserID"],
//         toUserId: json["ToUserID"],
//         message: json["Message"],
//         attachment: json["Attachment"],
//         sendDateTime: DateTime.parse(json["SendDateTime"]),
//         markAsRead: json["MarkAsRead"],
//         fromStatus: json["FromStatus"],
//         toStatus: json["ToStatus"],
//         fromUserName: json["FromUserName"],
//         toUserName: json["ToUserName"],
//         profPic: json["ProfPic"],
//         sentDate: DateTime.parse(json["SentDate"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "ChatID": chatId,
//         "FromUserID": fromUserId,
//         "ToUserID": toUserId,
//         "Message": message,
//         "Attachment": attachment,
//         "SendDateTime": sendDateTime.toIso8601String(),
//         "MarkAsRead": markAsRead,
//         "FromStatus": fromStatus,
//         "ToStatus": toStatus,
//         "FromUserName": fromUserName,
//         "ToUserName": toUserName,
//         "ProfPic": profPic,
//         "SentDate": sentDate.toIso8601String(),
//       };
// }
