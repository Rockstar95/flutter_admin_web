class MyCreditCertificateresponse {
  List<Credits> table = [];
  List<Table1> table1 = [];
  List<Table2> table2 = [];

  MyCreditCertificateresponse(
      {required this.table, required this.table1, required this.table2});

  MyCreditCertificateresponse.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        table.add(new Credits.fromJson(v));
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

class Credits {
  String contentID = "";
  String name = "";
  String decimal2 = "";
  String certificateID = "";
  String coreLessonStatus = "";
  String scoreRaw = "";
  String certificatePercentage = "";
  String userCertificateID = "";
  String certificatePage = "";
  String folderPath = "";
  String creditdecimalvalue = "";
  String certifyviewlink = "";
  String certifycountwebapilevel = "";
  String certificatePreviewPath = "";

  /*Credits(
      {this.contentID,
      this.name,
      this.decimal2,
      this.certificateID,
      this.coreLessonStatus,
      this.scoreRaw,
      this.certificatePercentage,
      this.userCertificateID,
      this.certificatePage,
      this.folderPath,
      this.creditdecimalvalue,
      this.certifyviewlink,
      this.certifycountwebapilevel,
      this.certificatePreviewPath});*/

  Credits.fromJson(Map<String, dynamic> json) {
    contentID = json['ContentID'];
    name = json['Name'];
    decimal2 = json['Decimal2'].toString();
    certificateID = json['CertificateID'];
    coreLessonStatus = json['CoreLessonStatus'];
    scoreRaw = json['ScoreRaw'];
    certificatePercentage = json['CertificatePercentage'];
    userCertificateID = json['UserCertificateID'];
    certificatePage = json['CertificatePage'];
    folderPath = json['FolderPath'];
    creditdecimalvalue = json['creditdecimalvalue'];
    certifyviewlink = json['certifyviewlink'];
    certifycountwebapilevel = json['certifycountwebapilevel'].toString();
    certificatePreviewPath = json['CertificatePreviewPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContentID'] = this.contentID;
    data['Name'] = this.name;
    data['Decimal2'] = this.decimal2;
    data['CertificateID'] = this.certificateID;
    data['CoreLessonStatus'] = this.coreLessonStatus;
    data['ScoreRaw'] = this.scoreRaw;
    data['CertificatePercentage'] = this.certificatePercentage;
    data['UserCertificateID'] = this.userCertificateID;
    data['CertificatePage'] = this.certificatePage;
    data['FolderPath'] = this.folderPath;
    data['creditdecimalvalue'] = this.creditdecimalvalue;
    data['certifyviewlink'] = this.certifyviewlink;
    data['certifycountwebapilevel'] = this.certifycountwebapilevel;
    data['CertificatePreviewPath'] = this.certificatePreviewPath;
    return data;
  }
}

class Table1 {
  String creditcount = "";
  String certificatecount = "";

  Table1({this.creditcount = "", this.certificatecount = ""});

  Table1.fromJson(Map<String, dynamic> json) {
    creditcount = json['creditcount'].toString();
    certificatecount = json['certificatecount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditcount'] = this.creditcount;
    data['certificatecount'] = this.certificatecount;
    return data;
  }
}

class Table2 {
  String creditsum = "";

  Table2({this.creditsum = ""});

  Table2.fromJson(Map<String, dynamic> json) {
    creditsum = json['creditsum'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditsum'] = this.creditsum;
    return data;
  }
}
