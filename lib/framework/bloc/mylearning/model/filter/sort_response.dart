// To parse this JSON data, do
//
//     final sortResponse = sortResponseFromJson(jsonString);

import 'dart:convert';

SortResponse sortResponseFromJson(String str) =>
    SortResponse.fromJson(json.decode(str));

String sortResponseToJson(SortResponse data) => json.encode(data.toJson());

class SortResponse {
  SortResponse({
    required this.table,
  });

  List<SortTable> table = [];

  factory SortResponse.fromJson(Map<String, dynamic> json) => SortResponse(
        table: List<SortTable>.from(
            (json["Table"] ?? []).map((x) => SortTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": table == null
            ? null
            : List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class SortTable {
  SortTable({
    this.id = 0,
    this.siteId = 0,
    this.componentId = 0,
    this.localId = "",
    this.optionText = "",
    this.optionValue = "",
    this.enableColumn = "",
  });

  int id = 0;
  int siteId = 0;
  int componentId = 0;
  String localId = "";
  String optionText = "";
  String optionValue = "";
  String enableColumn = "";

  factory SortTable.fromJson(Map<String, dynamic> json) => SortTable(
        id: json["ID"] ?? 0,
        siteId: json["SiteID"] ?? 0,
        componentId: json["ComponentID"] ?? 0,
        localId: json["LocalID"] ?? "",
        optionText: json["OptionText"] ?? "",
        optionValue: json["OptionValue"] ?? "",
        enableColumn: json["EnableColumn"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "SiteID": siteId == null ? null : siteId,
        "ComponentID": componentId == null ? null : componentId,
        "LocalID": localId == null ? null : localId,
        "OptionText": optionText == null ? null : optionText,
        "OptionValue": optionValue == null ? null : optionValue,
        "EnableColumn": enableColumn == null ? null : enableColumn,
      };
}
