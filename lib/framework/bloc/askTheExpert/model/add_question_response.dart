import 'dart:convert';

AddQuestionResponse addQuestionResponseFromJson(String str) =>
    AddQuestionResponse.fromJson(json.decode(str));

dynamic addQuestionResponseToJson(AddQuestionResponse data) =>
    json.encode(data.toJson());

class AddQuestionResponse {
  List<Table> table;

  AddQuestionResponse({required this.table});

  static AddQuestionResponse fromJson(Map<String, dynamic> json) {
    AddQuestionResponse addQuestionResponse = AddQuestionResponse(table: []);
    if (json['Table'] != null) {
      addQuestionResponse.table = [];
      json['Table'].forEach((v) {
        addQuestionResponse.table.add(Table.fromJson(v));
      });
    }
    return addQuestionResponse;
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
  double column1;
  String notifyMessage;

  Table({this.column1 = 0, this.notifyMessage = ""});

  static Table fromJson(Map<String, dynamic> json) {
    Table table = Table();
    table.column1 = json['Column1']?.toDouble() ?? 0;
    table.notifyMessage = json['NotifyMessage'] ?? "";
    return table;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    data['NotifyMessage'] = this.notifyMessage;
    return data;
  }
}
