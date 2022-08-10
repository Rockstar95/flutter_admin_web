import 'dart:convert';

FcmResponse fcmResponseFromJson(String str) =>
    FcmResponse.fromJson(json.decode(str));

dynamic fcmResponseToJson(FcmResponse data) => json.encode(data.toJson());

class FcmResponse {
  Notification? notification;
  Data? data;
  String collapseKey;
  String messageId;
  String sentTime;
  String from;
  String ttl;

  FcmResponse({
    this.notification,
    this.data,
    this.collapseKey = "",
    this.messageId = "",
    this.sentTime = "",
    this.from = "",
    this.ttl = "",
  });

  static FcmResponse fromJson(Map<String, dynamic> json) {
    FcmResponse fcmResponse = FcmResponse();
    fcmResponse.notification = json['notification'] != null
        ? Notification.fromJson(json['notification'])
        : null;
    fcmResponse.data =
        json['data'] != null ? Data.fromJson(json['data']) : null;
    fcmResponse.collapseKey = json['collapseKey'];
    fcmResponse.messageId = json['messageId'];
    fcmResponse.sentTime = json['sentTime'];
    fcmResponse.from = json['from'];
    fcmResponse.ttl = json['ttl'];
    return fcmResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['collapseKey'] = this.collapseKey;
    data['messageId'] = this.messageId;
    data['sentTime'] = this.sentTime;
    data['from'] = this.from;
    data['ttl'] = this.ttl;
    return data;
  }
}

class Notification {
  Android? android;
  String title;
  String body;

  Notification({this.android, this.title = "", this.body = ""});

  static Notification fromJson(Map<String, dynamic> json) {
    Notification notification = Notification();
    notification.android =
        json['android'] != null ? Android.fromJson(json['android']) : null;
    notification.title = json['title'];
    notification.body = json['body'];
    return notification;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.android != null) {
      data['android'] = this.android!.toJson();
    }
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

class Android {
  String sound;
  String smallIcon;

  Android({this.sound = "", this.smallIcon = ""});

  static Android fromJson(Map<String, dynamic> json) {
    Android android = Android();
    android.sound = json['sound'] ?? "";
    android.smallIcon = json['smallIcon'] ?? "";
    return android;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sound'] = this.sound;
    data['smallIcon'] = this.smallIcon;
    return data;
  }
}

class Data {
  String message;
  String contentid;
  String contextmenuid;
  String siteid;

  Data(
      {this.message = "",
      this.contentid = "",
      this.contextmenuid = "",
      this.siteid = ""});

  static Data fromJson(Map<String, dynamic> json) {
    Data data = Data();
    data.message = json['Message'] ?? "";
    data.contentid = json['contentid'] ?? "";
    data.contextmenuid = json['contextmenuid'] ?? "";
    data.siteid = json['siteid'] ?? "";
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['contentid'] = this.contentid;
    data['contextmenuid'] = this.contextmenuid;
    data['siteid'] = this.siteid;
    return data;
  }
}
