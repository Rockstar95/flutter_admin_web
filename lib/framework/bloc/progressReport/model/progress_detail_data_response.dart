import 'dart:convert';

ProgressDetailDataResponse progressDetailDataResponseFromJson(String str) =>
    ProgressDetailDataResponse.fromJson(json.decode(str));

dynamic peopleListRequestToJson(ProgressDetailDataResponse data) =>
    json.encode(data.toJson());

class ProgressDetailDataResponse {
  List<ProgressDetail> progressDetail = [];
  List<ProgressDetail1> table1 = [];

  // List<ProgressDetail2> table2;
  List<ProgressDetail3> table3 = [];

  List<ProgressDetail6> table6 = [];

  ProgressDetailDataResponse(
      {required this.progressDetail,
      required this.table1,
      // this.table2,
      required this.table3,
      required this.table6});

  ProgressDetailDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        progressDetail.add(new ProgressDetail.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      json['Table1'].forEach((v) {
        table1.add(new ProgressDetail1.fromJson(v));
      });
    }
    /* if (json['Table2'] != null) {
      table2 = new List<Null>();
      json['Table2'].forEach((v) {
        table2.add(new Null.fromJson(v));
      });
    }*/
    if (json['Table3'] != null) {
      json['Table3'].forEach((v) {
        table3.add(new ProgressDetail3.fromJson(v));
      });
    }
    /*  if (json['Table4'] != null) {
      table4 = new List<Null>();
      json['Table4'].forEach((v) {
        table4.add(new Null.fromJson(v));
      });
    }
    if (json['Table5'] != null) {
      table5 = new List<Null>();
      json['Table5'].forEach((v) {
        table5.add(new Null.fromJson(v));
      });
    }*/
    if (json['Table6'] != null) {
      json['Table6'].forEach((v) {
        table6.add(new ProgressDetail6.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.progressDetail != null) {
      data['Table'] = this.progressDetail.map((v) => v.toJson()).toList();
    }
    if (this.table1 != null) {
      data['Table1'] = this.table1.map((v) => v.toJson()).toList();
    }
    // if (this.table2 != null) {
    //   data['Table2'] = this.table2.map((v) => v.toJson()).toList();
    // }
    if (this.table3 != null) {
      data['Table3'] = this.table3.map((v) => v.toJson()).toList();
    }
    /*if (this.table4 != null) {
      data['Table4'] = this.table4.map((v) => v.toJson()).toList();
    }
    if (this.table5 != null) {
      data['Table5'] = this.table5.map((v) => v.toJson()).toList();
    }*/
    if (this.table6 != null) {
      data['Table6'] = this.table6.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProgressDetail {
  dynamic pageID;
  String pageQuestionTitle = "";
  String type = "";
  String contentID = "";
  String questionNo = "";
  String folderPath = "";
  String questionTitle = "";
  String questionNumber = "";
  String status = "";
  String optionLevelNotes = "";
  String actions = "";

  ProgressDetail(
      /*{this.pageID,
        this.pageQuestionTitle,
        this.type,
        this.contentID,
        this.questionNo,
        this.folderPath,
        this.questionTitle,
        this.questionNumber,
        this.status,
        this.optionLevelNotes,
        this.actions}*/
      );

  ProgressDetail.fromJson(Map<String, dynamic> json) {
    pageID = json['PageID'];
    pageQuestionTitle = json['Page/Question Title'] ?? "";
    type = json['Type'] ?? "";
    contentID = json['ContentID'] ?? "";
    questionNo = json['Question No.'] ?? "";
    folderPath = json['FolderPath'] ?? "";
    questionTitle = json['QuestionTitle'] ?? "";
    questionNumber = json['QuestionNumber'] ?? "";
    status = json['Status'] ?? "";
    optionLevelNotes = json['OptionLevelNotes'] ?? "";
    actions = json['Actions'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageID'] = this.pageID;
    data['Page/Question Title'] = this.pageQuestionTitle;
    data['Type'] = this.type;
    data['ContentID'] = this.contentID;
    data['Question No.'] = this.questionNo;
    data['FolderPath'] = this.folderPath;
    data['QuestionTitle'] = this.questionTitle;
    data['QuestionNumber'] = this.questionNumber;
    data['Status'] = this.status;
    data['OptionLevelNotes'] = this.optionLevelNotes;
    data['Actions'] = this.actions;
    return data;
  }
}

class ProgressDetail1 {
  String userName = "";
  int userStatus = 0;

  ProgressDetail1({this.userName = "", this.userStatus = 0});

  ProgressDetail1.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    userStatus = json['UserStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['UserStatus'] = this.userStatus;
    return data;
  }
}

class ProgressDetail3 {
  String title = "";

  ProgressDetail3({this.title = ""});

  ProgressDetail3.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    return data;
  }
}

class ProgressDetail6 {
  String statustype = "";

  ProgressDetail6({this.statustype = ""});

  ProgressDetail6.fromJson(Map<String, dynamic> json) {
    statustype = json['statustype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statustype'] = this.statustype;
    return data;
  }
}
