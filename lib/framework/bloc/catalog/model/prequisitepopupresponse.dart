class PrequisitePopupresponse {
  PrerequisteData prerequisteData = PrerequisteData.fromJson({});
  bool isShowPopUp = false;

  PrequisitePopupresponse.fromJson(Map<String, dynamic> json) {
    prerequisteData = PrerequisteData.fromJson(json['PrerequisteData'] ?? {});
    isShowPopUp = json['IsShowPopUp'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prerequisteData != null) {
      data['PrerequisteData'] = this.prerequisteData.toJson();
    }
    data['IsShowPopUp'] = this.isShowPopUp;
    return data;
  }
}

class PrerequisteData {
  List<Table> table = [];
  List<Table1> table1 = [];
  List<Table2> table2 = [];

  PrerequisteData.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        table.add(new Table.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      json['Table1'].forEach((v) {
        table1.add(new Table1.fromJson(v));
      });
    }
    if (json['Table2'] != null) {
      json['Table2'].forEach((v) {
        table2.add(new Table2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }
    if (this.table1 != null) {
      data['Table1'] = this.table1.map((v) => v.toJson()).toList();
    }
    if (this.table2 != null) {
      data['Table2'] = this.table2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  dynamic excludeContent;
  String contentID = "";
  String name = "";
  int prerequisites = 0;
  String prerequisiteContentID = "";
  int preRequisiteSequnceID = 0;
  int preRequisiteSequncePathID = 0;
  int nodeIndex = 0;
  String pathName = "";

  Table.fromJson(Map<String, dynamic> json) {
    excludeContent = json['ExcludeContent'];
    contentID = json['ContentID'];
    name = json['Name'];
    prerequisites = json['Prerequisites'];
    prerequisiteContentID = json['PrerequisiteContentID'];
    preRequisiteSequnceID = json['PreRequisiteSequnceID'];
    preRequisiteSequncePathID = json['PreRequisiteSequncePathID'];
    nodeIndex = json['NodeIndex'];
    pathName = json['PathName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ExcludeContent'] = this.excludeContent;
    data['ContentID'] = this.contentID;
    data['Name'] = this.name;
    data['Prerequisites'] = this.prerequisites;
    data['PrerequisiteContentID'] = this.prerequisiteContentID;
    data['PreRequisiteSequnceID'] = this.preRequisiteSequnceID;
    data['PreRequisiteSequncePathID'] = this.preRequisiteSequncePathID;
    data['NodeIndex'] = this.nodeIndex;
    data['PathName'] = this.pathName;
    return data;
  }
}

class Table1 {
  String contentID = "";
  int preRequisiteSequnceID = 0;
  int preRequisiteSequncePathID = 0;
  String pathName = "";

  Table1.fromJson(Map<String, dynamic> json) {
    contentID = json['ContentID'];
    preRequisiteSequnceID = json['PreRequisiteSequnceID'];
    preRequisiteSequncePathID = json['PreRequisiteSequncePathID'];
    pathName = json['PathName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContentID'] = this.contentID;
    data['PreRequisiteSequnceID'] = this.preRequisiteSequnceID;
    data['PreRequisiteSequncePathID'] = this.preRequisiteSequncePathID;
    data['PathName'] = this.pathName;
    return data;
  }
}

class Table2 {
  String contentID = "";
  String name = "";
  int preRequisiteSequnceID = 0;
  int preRequisiteSequncePathID = 0;
  int nodeIndex = 0;

  Table2.fromJson(Map<String, dynamic> json) {
    contentID = json['ContentID'];
    name = json['Name'];
    preRequisiteSequnceID = json['PreRequisiteSequnceID'];
    preRequisiteSequncePathID = json['PreRequisiteSequncePathID'];
    nodeIndex = json['NodeIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContentID'] = this.contentID;
    data['Name'] = this.name;
    data['PreRequisiteSequnceID'] = this.preRequisiteSequnceID;
    data['PreRequisiteSequncePathID'] = this.preRequisiteSequncePathID;
    data['NodeIndex'] = this.nodeIndex;
    return data;
  }
}
