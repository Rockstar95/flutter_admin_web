import 'dart:convert';

NotificationCountRes notificationCountResFromJson(String str) =>
    NotificationCountRes.fromJson(json.decode(str));

dynamic notificationCountResToJson(NotificationCountRes data) =>
    json.encode(data.toJson());

class NotificationCountRes {
  List<Table> table;

  NotificationCountRes({required this.table});

  static NotificationCountRes fromJson(Map<String, dynamic> json) {
    NotificationCountRes notificationCountRes = NotificationCountRes(table: []);
    List<Map<String, dynamic>> notificationData =
        List.castFrom(json['Table'] ?? []);
    notificationCountRes.table = [];
    notificationData.forEach((v) {
      notificationCountRes.table.add(Table.fromJson(v));
    });
    return notificationCountRes;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  int notificationCount;
  int unReadCount;

  Table({this.notificationCount = 0, this.unReadCount = 0});

  static Table fromJson(Map<String, dynamic> json) {
    Table table = Table();

    table.notificationCount = json['NotificationCount'];
    table.unReadCount = json['UnReadCount'];

    return table;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotificationCount'] = this.notificationCount;
    data['UnReadCount'] = this.unReadCount;
    return data;
  }
}
