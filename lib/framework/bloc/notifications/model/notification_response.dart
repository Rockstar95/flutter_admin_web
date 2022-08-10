import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());

class NotificationResponse {
  List<Notification> table = [];
  List<Notification1> table1 = [];
  List<Notification2> table2 = [];
  List<Notification3> table3 = [];
  List<Notification4> table4 = [];
  List<Notification5> table5 = [];

  NotificationResponse(
      /*{this.table,
      this.table1,
      this.table2,
      this.table3,
      this.table4,
      this.table5}*/
      );

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != dynamic) {
      json['Table'].forEach((v) {
        table.add(new Notification.fromJson(v));
      });
    }
    if (json['Table1'] != dynamic) {
      json['Table1'].forEach((v) {
        table1.add(new Notification1.fromJson(v));
      });
    }
    if (json['Table2'] != dynamic) {
      json['Table2'].forEach((v) {
        table2.add(new Notification2.fromJson(v));
      });
    }
    if (json['Table3'] != dynamic) {
      json['Table3'].forEach((v) {
        table3.add(new Notification3.fromJson(v));
      });
    }
    if (json['Table4'] != dynamic) {
      json['Table4'].forEach((v) {
        table4.add(new Notification4.fromJson(v));
      });
    }
    if (json['Table5'] != dynamic) {
      json['Table5'].forEach((v) {
        table5.add(new Notification5.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != dynamic) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }
    if (this.table1 != dynamic) {
      data['Table1'] = this.table1.map((v) => v.toJson()).toList();
    }
    if (this.table2 != dynamic) {
      data['Table2'] = this.table2.map((v) => v.toJson()).toList();
    }
    if (this.table3 != dynamic) {
      data['Table3'] = this.table3.map((v) => v.toJson()).toList();
    }
    if (this.table4 != dynamic) {
      data['Table4'] = this.table4.map((v) => v.toJson()).toList();
    }
    if (this.table5 != dynamic) {
      data['Table5'] = this.table5.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  int notificationCount = 0;
  int unReadCount = 0;

  Notification({this.notificationCount = 0, this.unReadCount = 0});

  Notification.fromJson(Map<String, dynamic> json) {
    notificationCount = json['NotificationCount'] ?? 0;
    unReadCount = json['UnReadCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotificationCount'] = this.notificationCount;
    data['UnReadCount'] = this.unReadCount;
    return data;
  }
}

class Notification1 {
  String fromUserDisplayName = "";
  int userNotificationID = 0;
  int fromUserID = 0;
  dynamic fromUserName;
  dynamic fromUserEmail;
  int toUserID = 0;
  String subject = "";
  String message = "";
  String notificationStartDate = "";
  String notificationEndDate = "";
  int notificationID = 0;
  int oUNotificationID = 0;
  String contentID = "";
  bool markAsRead = false;
  String otherParams = "";
  String notificationTitle = "";
  int groupID = 0;
  int userNotificationID1 = 0;
  int notificationID1 = 0;
  String contentID1 = "";
  String otherParams1 = "";
  String dispalynotificationStartdate = "";
  String dispalynotificationEnddate = "";

  Notification1(
      /*{this.fromUserDisplayName,
      this.userNotificationID,
      this.fromUserID,
      this.fromUserName,
      this.fromUserEmail,
      this.toUserID,
      this.subject,
      this.message,
      this.notificationStartDate,
      this.notificationEndDate,
      this.notificationID,
      this.oUNotificationID,
      this.contentID,
      this.markAsRead,
      this.otherParams,
      this.notificationTitle,
      this.groupID,
      this.userNotificationID1,
      this.notificationID1,
      this.contentID1,
      this.otherParams1,
      this.dispalynotificationStartdate,
      this.dispalynotificationEnddate}*/
      );

  Notification1.fromJson(Map<String, dynamic> json) {
    fromUserDisplayName = json['FromUserDisplayName'] ?? "";
    userNotificationID = json['UserNotificationID'] ?? 0;
    fromUserID = json['FromUserID'] ?? 0;
    fromUserName = json['FromUserName'] ?? "";
    fromUserEmail = json['FromUserEmail'] ?? "";
    toUserID = json['ToUserID'] ?? 0;
    subject = json['Subject'] ?? "";
    message = json['Message'] ?? "";
    notificationStartDate = json['NotificationStartDate'] ?? "";
    notificationEndDate = json['NotificationEndDate'] ?? "";
    notificationID = json['NotificationID'] ?? 0;
    oUNotificationID = json['OUNotificationID'] ?? 0;
    contentID = json['ContentID'] ?? "";
    markAsRead = json['MarkAsRead'] ?? false;
    otherParams = json['OtherParams'] ?? "";
    notificationTitle = json['NotificationTitle'] ?? "";
    groupID = json['GroupID'] ?? 0;
    userNotificationID1 = json['UserNotificationID1'] ?? 0;
    notificationID1 = json['NotificationID1'] ?? 0;
    contentID1 = json['ContentID1'] ?? "";
    otherParams1 = json['OtherParams1'] ?? "";
    dispalynotificationStartdate = json['DispalynotificationStartdate'] ?? "";
    dispalynotificationEnddate = json['DispalynotificationEnddate'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FromUserDisplayName'] = this.fromUserDisplayName;
    data['UserNotificationID'] = this.userNotificationID;
    data['FromUserID'] = this.fromUserID;
    data['FromUserName'] = this.fromUserName;
    data['FromUserEmail'] = this.fromUserEmail;
    data['ToUserID'] = this.toUserID;
    data['Subject'] = this.subject;
    data['Message'] = this.message;
    data['NotificationStartDate'] = this.notificationStartDate;
    data['NotificationEndDate'] = this.notificationEndDate;
    data['NotificationID'] = this.notificationID;
    data['OUNotificationID'] = this.oUNotificationID;
    data['ContentID'] = this.contentID;
    data['MarkAsRead'] = this.markAsRead;
    data['OtherParams'] = this.otherParams;
    data['NotificationTitle'] = this.notificationTitle;
    data['GroupID'] = this.groupID;
    data['UserNotificationID1'] = this.userNotificationID1;
    data['NotificationID1'] = this.notificationID1;
    data['ContentID1'] = this.contentID1;
    data['OtherParams1'] = this.otherParams1;
    data['DispalynotificationStartdate'] = this.dispalynotificationStartdate;
    data['DispalynotificationEnddate'] = this.dispalynotificationEnddate;
    return data;
  }
}

class Notification2 {
  int notificationID = 0;
  int notificationMenuid = 0;

  Notification2({this.notificationID = 0, this.notificationMenuid = 0});

  Notification2.fromJson(Map<String, dynamic> json) {
    notificationID = json['NotificationID'] ?? 0;
    notificationMenuid = json['NotificationMenuid'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotificationID'] = this.notificationID;
    data['NotificationMenuid'] = this.notificationMenuid;
    return data;
  }
}

class Notification3 {
  String contentID = "";
  String name = "";
  String publishedDate = "";
  String displayPublishedDate = "";

  Notification3(
      {this.contentID = "",
      this.name = "",
      this.publishedDate = "",
      this.displayPublishedDate = ""});

  Notification3.fromJson(Map<String, dynamic> json) {
    contentID = json['ContentID'] ?? "";
    name = json['Name'] ?? "";
    publishedDate = json['PublishedDate'] ?? "";
    displayPublishedDate = json['DisplayPublishedDate'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContentID'] = this.contentID;
    data['Name'] = this.name;
    data['PublishedDate'] = this.publishedDate;
    data['DisplayPublishedDate'] = this.displayPublishedDate;
    return data;
  }
}

class Notification4 {
  String otherparams = "";
  String contentID = "";
  String name = "";
  String latestReplyBy = "";
  int noOfReplies = 0;
  int noOfViews = 0;
  int forumID = 0;
  String forumName = "";

  Notification4(
      {this.otherparams = "",
      this.contentID = "",
      this.name = "",
      this.latestReplyBy = "",
      this.noOfReplies = 0,
      this.noOfViews = 0,
      this.forumID = 0,
      this.forumName = ""});

  Notification4.fromJson(Map<String, dynamic> json) {
    otherparams = json['Otherparams'] ?? "";
    contentID = json['ContentID'] ?? "";
    name = json['Name'] ?? "";
    latestReplyBy = json['LatestReplyBy'] ?? "";
    noOfReplies = json['NoOfReplies'] ?? 0;
    noOfViews = json['NoOfViews'] ?? 0;
    forumID = json['ForumID'] ?? 0;
    forumName = json['ForumName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Otherparams'] = this.otherparams;
    data['ContentID'] = this.contentID;
    data['Name'] = this.name;
    data['LatestReplyBy'] = this.latestReplyBy;
    data['NoOfReplies'] = this.noOfReplies;
    data['NoOfViews'] = this.noOfViews;
    data['ForumID'] = this.forumID;
    data['ForumName'] = this.forumName;
    return data;
  }
}

class Notification5 {
  String name = "";
  int passwordExpiryDays = 0;

  Notification5({this.name = "", this.passwordExpiryDays = 0});

  Notification5.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? '';
    passwordExpiryDays = json['PasswordExpiryDays'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['PasswordExpiryDays'] = this.passwordExpiryDays;
    return data;
  }
}
