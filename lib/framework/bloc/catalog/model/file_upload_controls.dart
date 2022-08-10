class FileUploadControls {
  int objectTypeID = 0;
  int mediaTypeID = 0;
  String mediaTypeIdisplayName = "";
  String displayIcon = "";
  bool status = false;

  FileUploadControls.fromJson(Map<String, dynamic> json) {
    objectTypeID = json['ObjectTypeID'];
    mediaTypeID = json['MediaTypeID'];
    mediaTypeIdisplayName = json['MediaTypeIdisplayName'];
    displayIcon = json['DisplayIcon'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ObjectTypeID'] = this.objectTypeID;
    data['MediaTypeID'] = this.mediaTypeID;
    data['MediaTypeIdisplayName'] = this.mediaTypeIdisplayName;
    data['DisplayIcon'] = this.displayIcon;
    data['Status'] = this.status;
    return data;
  }
}
