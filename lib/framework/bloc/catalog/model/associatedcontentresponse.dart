class AssociatedContentResponse {
  List<PrerequisiteModel> courseList;
  Parentcontent parentcontent = Parentcontent();
  String title;
  String currencySign;
  bool enableEcommerce;
  String eventdateisnotavailablemsg;

  AssociatedContentResponse(
      {required this.courseList,
      required this.parentcontent,
      this.title = "",
      this.currencySign = "",
      this.enableEcommerce = false,
      this.eventdateisnotavailablemsg = ""});

  static AssociatedContentResponse fromJson(Map<String, dynamic> json) {
    AssociatedContentResponse associatedContentResponse =
        AssociatedContentResponse(
            courseList: [], parentcontent: Parentcontent());
    if (json['CourseList'] != dynamic) {
      (json['CourseList'] ?? []).forEach((v) {
        associatedContentResponse.courseList.add(PrerequisiteModel.fromJson(v));
      });
    }
    associatedContentResponse.parentcontent = json['Parentcontent'] != null
        ? Parentcontent.fromJson(json['Parentcontent'])
        : Parentcontent();
    associatedContentResponse.title = json['title'] ?? "";
    associatedContentResponse.currencySign = json['CurrencySign'] ?? "";
    associatedContentResponse.enableEcommerce =
        json['EnableEcommerce'] ?? false;
    associatedContentResponse.eventdateisnotavailablemsg =
        json['Eventdateisnotavailablemsg'] ?? "";
    return associatedContentResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CourseList'] = this.courseList.map((v) => v.toJson()).toList();
    if (this.parentcontent != dynamic) {
      data['Parentcontent'] = this.parentcontent.toJson();
    }
    data['title'] = this.title;
    data['CurrencySign'] = this.currencySign;
    data['EnableEcommerce'] = this.enableEcommerce;
    data['Eventdateisnotavailablemsg'] = this.eventdateisnotavailablemsg;
    return data;
  }
}

class PrerequisiteModel {
  String contentID,
      thumbnailIconPath,
      createdOn,
      authorDisplayName,
      thumbnailImagePath,
      tags,
      title,
      shortDescription;
  String currency, contentType, timeZone, salePrice;
  int contentTypeId, scoID, prerequisites;
  bool bit5,
      isLearnerContent,
      ischecked,
      noInstanceAvailable,
      isRequiredCompletionCompleted;
  dynamic usertimezone,
      eventStartDateTime,
      eventEndDateTime,
      prerequisiteEnrolledContent;
  String eventselectedinstanceID,
      eventScheduleType,
      detailsLink,
      actionName,
      prerequisitehavingPrerequisites,
      prerequisitehavingPrerequisites1,
      addLink,
      assignedContent,
      excludeContent;

  PrerequisiteModel({
    this.contentID = "",
    this.thumbnailIconPath = "",
    this.createdOn = "",
    this.authorDisplayName = "",
    this.thumbnailImagePath = "",
    this.tags = "",
    this.title = "",
    this.shortDescription = "",
    this.currency = "",
    this.contentType = "",
    this.timeZone = "",
    this.salePrice = "",
    this.contentTypeId = 0,
    this.scoID = 0,
    this.prerequisites = 0,
    this.bit5 = false,
    this.isLearnerContent = false,
    this.ischecked = false,
    this.noInstanceAvailable = false,
    this.isRequiredCompletionCompleted = false,
    this.usertimezone,
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.prerequisiteEnrolledContent,
    this.eventselectedinstanceID = "",
    this.eventScheduleType = "",
    this.detailsLink = "",
    this.actionName = "",
    this.prerequisitehavingPrerequisites = "",
    this.prerequisitehavingPrerequisites1 = "",
    this.addLink = "",
    this.assignedContent = "",
    this.excludeContent = "",
  });

  static PrerequisiteModel fromJson(Map<String, dynamic> json) {
    PrerequisiteModel prerequisiteModel = PrerequisiteModel();
    prerequisiteModel.contentID = json['ContentID'] ?? "";
    prerequisiteModel.thumbnailIconPath = json['ThumbnailIconPath'] ?? "";
    prerequisiteModel.createdOn = json['CreatedOn'] ?? "";
    prerequisiteModel.authorDisplayName = json['AuthorDisplayName'] ?? "";
    prerequisiteModel.thumbnailImagePath = json['ThumbnailImagePath'] ?? "";
    prerequisiteModel.tags = json['Tags'] ?? "";
    prerequisiteModel.title = json['Title'] ?? "";
    prerequisiteModel.shortDescription = json['ShortDescription'] ?? "";
    prerequisiteModel.currency = json['Currency'] ?? "";
    prerequisiteModel.contentType = json['ContentType'] ?? "";
    prerequisiteModel.timeZone = json['TimeZone'] ?? "";
    prerequisiteModel.salePrice = json['SalePrice'] ?? "";
    prerequisiteModel.contentTypeId = json['ContentTypeId'] ?? 0;
    prerequisiteModel.scoID = json['ScoID'] ?? 0;
    prerequisiteModel.prerequisites = json['Prerequisites'] ?? 0;
    prerequisiteModel.bit5 = json['bit5'] ?? false;
    prerequisiteModel.isLearnerContent = json['IsLearnerContent'] ?? false;
    prerequisiteModel.ischecked = json['Ischecked'] ?? false;
    prerequisiteModel.noInstanceAvailable =
        json['NoInstanceAvailable'] ?? false;
    prerequisiteModel.isRequiredCompletionCompleted =
        json['IsRequiredCompletionCompleted'] ?? false;
    prerequisiteModel.usertimezone = json['Usertimezone'];
    prerequisiteModel.eventStartDateTime = json['EventStartDateTime'];
    prerequisiteModel.eventEndDateTime = json['EventEndDateTime'];
    prerequisiteModel.prerequisiteEnrolledContent =
        json['PrerequisiteEnrolledContent'];
    prerequisiteModel.eventselectedinstanceID =
        json['EventselectedinstanceID'] ?? "";
    prerequisiteModel.eventScheduleType = json['EventScheduleType'] ?? "";
    prerequisiteModel.detailsLink = json['DetailsLink'] ?? "";
    prerequisiteModel.actionName = json['ActionName'] ?? "";
    prerequisiteModel.prerequisitehavingPrerequisites =
        json['PrerequisitehavingPrerequisites'] ?? "";
    prerequisiteModel.prerequisitehavingPrerequisites1 =
        json['PrerequisitehavingPrerequisites1'] ?? "";
    prerequisiteModel.addLink = json['AddLink'] ?? "";
    prerequisiteModel.assignedContent = json['AssignedContent'] ?? "";
    prerequisiteModel.excludeContent = json['ExcludeContent'] ?? "";
    return prerequisiteModel;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContentID'] = this.contentID;
    data['ThumbnailIconPath'] = this.thumbnailIconPath;
    data['CreatedOn'] = this.createdOn;
    data['AuthorDisplayName'] = this.authorDisplayName;
    data['ScoID'] = this.scoID;
    data['ThumbnailImagePath'] = this.thumbnailImagePath;
    data['Tags'] = this.tags;
    data['Title'] = this.title;
    data['ShortDescription'] = this.shortDescription;
    data['ContentTypeId'] = this.contentTypeId;
    data['Currency'] = this.currency;
    data['ContentType'] = this.contentType;
    data['TimeZone'] = this.timeZone;
    data['SalePrice'] = this.salePrice;
    data['bit5'] = this.bit5;
    data['Prerequisites'] = this.prerequisites;
    data['IsLearnerContent'] = this.isLearnerContent;
    data['Ischecked'] = this.ischecked;
    data['Usertimezone'] = this.usertimezone;
    data['EventselectedinstanceID'] = this.eventselectedinstanceID;
    data['EventStartDateTime'] = this.eventStartDateTime;
    data['EventEndDateTime'] = this.eventEndDateTime;
    data['IsRequiredCompletionCompleted'] = this.isRequiredCompletionCompleted;
    data['EventScheduleType'] = this.eventScheduleType;
    data['DetailsLink'] = this.detailsLink;
    data['ActionName'] = this.actionName;
    data['NoInstanceAvailable'] = this.noInstanceAvailable;
    data['PrerequisitehavingPrerequisites'] =
        this.prerequisitehavingPrerequisites;
    data['PrerequisitehavingPrerequisites1'] =
        this.prerequisitehavingPrerequisites1;
    data['AddLink'] = this.addLink;
    data['AssignedContent'] = this.assignedContent;
    data['ExcludeContent'] = this.excludeContent;
    data['PrerequisiteEnrolledContent'] = this.prerequisiteEnrolledContent;
    return data;
  }
}

class Parentcontent {
  String contentID,
      thumbnailIconPath,
      createdOn,
      authorDisplayName,
      thumbnailImagePath,
      title,
      shortDescription,
      contentType,
      salePrice,
      eventScheduleType,
      detailsLink,
      assignedContent,
      excludeContent;
  int scoID, contentTypeId, prerequisites;
  bool bit5,
      isLearnerContent,
      ischecked,
      isRequiredCompletionCompleted,
      noInstanceAvailable;
  dynamic tags,
      currency,
      timeZone,
      usertimezone,
      eventselectedinstanceID,
      eventStartDateTime,
      eventEndDateTime,
      actionName,
      prerequisitehavingPrerequisites,
      prerequisitehavingPrerequisites1,
      addLink,
      prerequisiteEnrolledContent;

  Parentcontent(
      {this.contentID = "",
      this.thumbnailIconPath = "",
      this.createdOn = "",
      this.authorDisplayName = "",
      this.thumbnailImagePath = "",
      this.title = "",
      this.shortDescription = "",
      this.contentType = "",
      this.salePrice = "",
      this.eventScheduleType = "",
      this.detailsLink = "",
      this.assignedContent = "",
      this.excludeContent = "",
      this.scoID = 0,
      this.contentTypeId = 0,
      this.prerequisites = 0,
      this.bit5 = false,
      this.isLearnerContent = false,
      this.ischecked = false,
      this.isRequiredCompletionCompleted = false,
      this.noInstanceAvailable = false,
      this.tags,
      this.currency,
      this.timeZone,
      this.usertimezone,
      this.eventselectedinstanceID,
      this.eventStartDateTime,
      this.eventEndDateTime,
      this.actionName,
      this.prerequisitehavingPrerequisites,
      this.prerequisitehavingPrerequisites1,
      this.addLink,
      this.prerequisiteEnrolledContent});

  static Parentcontent fromJson(Map<String, dynamic> json) {
    Parentcontent parentcontent = Parentcontent();
    parentcontent.contentID = json['ContentID'];
    parentcontent.thumbnailIconPath = json['ThumbnailIconPath'];
    parentcontent.createdOn = json['CreatedOn'];
    parentcontent.authorDisplayName = json['AuthorDisplayName'];
    parentcontent.thumbnailImagePath = json['ThumbnailImagePath'];
    parentcontent.title = json['Title'];
    parentcontent.shortDescription = json['ShortDescription'];
    parentcontent.contentType = json['ContentType'];
    parentcontent.salePrice = json['SalePrice'];
    parentcontent.eventScheduleType = json['EventScheduleType'];
    parentcontent.detailsLink = json['DetailsLink'];
    parentcontent.assignedContent = json['AssignedContent'];
    parentcontent.excludeContent = json['ExcludeContent'];
    parentcontent.scoID = json['ScoID'];
    parentcontent.contentTypeId = json['ContentTypeId'];
    parentcontent.prerequisites = json['Prerequisites'];
    parentcontent.bit5 = json['bit5'];
    parentcontent.isLearnerContent = json['IsLearnerContent'];
    parentcontent.ischecked = json['Ischecked'];
    parentcontent.isRequiredCompletionCompleted =
        json['IsRequiredCompletionCompleted'];
    parentcontent.noInstanceAvailable = json['NoInstanceAvailable'];
    parentcontent.tags = json['Tags'];
    parentcontent.currency = json['Currency'];
    parentcontent.timeZone = json['TimeZone'];
    parentcontent.usertimezone = json['Usertimezone'];
    parentcontent.eventselectedinstanceID = json['EventselectedinstanceID'];
    parentcontent.eventStartDateTime = json['EventStartDateTime'];
    parentcontent.eventEndDateTime = json['EventEndDateTime'];
    parentcontent.actionName = json['ActionName'];
    parentcontent.prerequisitehavingPrerequisites =
        json['PrerequisitehavingPrerequisites'];
    parentcontent.prerequisitehavingPrerequisites1 =
        json['PrerequisitehavingPrerequisites1'];
    parentcontent.addLink = json['AddLink'];
    parentcontent.prerequisiteEnrolledContent =
        json['PrerequisiteEnrolledContent'];
    return parentcontent;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContentID'] = this.contentID;
    data['ThumbnailIconPath'] = this.thumbnailIconPath;
    data['CreatedOn'] = this.createdOn;
    data['AuthorDisplayName'] = this.authorDisplayName;
    data['ScoID'] = this.scoID;
    data['ThumbnailImagePath'] = this.thumbnailImagePath;
    data['Tags'] = this.tags;
    data['Title'] = this.title;
    data['ShortDescription'] = this.shortDescription;
    data['ContentTypeId'] = this.contentTypeId;
    data['Currency'] = this.currency;
    data['ContentType'] = this.contentType;
    data['TimeZone'] = this.timeZone;
    data['SalePrice'] = this.salePrice;
    data['bit5'] = this.bit5;
    data['Prerequisites'] = this.prerequisites;
    data['IsLearnerContent'] = this.isLearnerContent;
    data['Ischecked'] = this.ischecked;
    data['Usertimezone'] = this.usertimezone;
    data['EventselectedinstanceID'] = this.eventselectedinstanceID;
    data['EventStartDateTime'] = this.eventStartDateTime;
    data['EventEndDateTime'] = this.eventEndDateTime;
    data['IsRequiredCompletionCompleted'] = this.isRequiredCompletionCompleted;
    data['EventScheduleType'] = this.eventScheduleType;
    data['DetailsLink'] = this.detailsLink;
    data['ActionName'] = this.actionName;
    data['NoInstanceAvailable'] = this.noInstanceAvailable;
    data['PrerequisitehavingPrerequisites'] =
        this.prerequisitehavingPrerequisites;
    data['PrerequisitehavingPrerequisites1'] =
        this.prerequisitehavingPrerequisites1;
    data['AddLink'] = this.addLink;
    data['AssignedContent'] = this.assignedContent;
    data['ExcludeContent'] = this.excludeContent;
    data['PrerequisiteEnrolledContent'] = this.prerequisiteEnrolledContent;
    return data;
  }
}
