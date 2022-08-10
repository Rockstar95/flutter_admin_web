import 'dart:convert';

FilterByModelLearning filterByModelFromLearnJson(String str) =>
    FilterByModelLearning.fromJson(json.decode(str));

String filterByModelToLearnJson(FilterByModelLearning data) =>
    json.encode(data.toJson());

class FilterByModelLearning {
  FilterByModelLearning({
    required this.Table,
  });

  List<LearnTable> Table = [];

  factory FilterByModelLearning.fromJson(Map<String, dynamic> json) =>
      FilterByModelLearning(
        Table: List<LearnTable>.from(
            (json["Table"] ?? []).map((x) => LearnTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": List<dynamic>.from(Table.map((x) => x.toJson())),
      };
}

class LearnTable {
  LearnTable({
    this.LearningProviderName = "",
    this.LearningPortalID,
    this.SiteID,
    this.hasChild = false,
  });

  String LearningProviderName = "";
  dynamic LearningPortalID;
  dynamic SiteID;
  bool hasChild = false;

  factory LearnTable.fromJson(Map<String, dynamic> json) => LearnTable(
        LearningProviderName: json["LearningProviderName"] == null
            ? ""
            : json["LearningProviderName"],
        LearningPortalID:
            json["LearningPortalID"] == null ? null : json["LearningPortalID"],
        SiteID: json["SiteID"] == null ? null : json["SiteID"],
        hasChild: false,
      );

  Map<String, dynamic> toJson() => {
        "LearningProviderName":
            LearningProviderName == null ? "" : LearningProviderName,
        "LearningPortalID": LearningPortalID == null ? null : LearningPortalID,
        "SiteID": SiteID == null ? null : SiteID,
        "hasChild": false,
      };
}
