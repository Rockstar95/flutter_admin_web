import 'dart:convert';

EventEnrollmentResponse eventEnrollmentResponseFromJson(String str) =>
    EventEnrollmentResponse.fromJson(json.decode(str));

dynamic eventEnrollmentResponseToJson(EventEnrollmentResponse data) =>
    json.encode(data.toJson());

class EventEnrollmentResponse {
  List<CourseList> courseList = [];
  int courseCount = 0;
  SelfScheduleInstancesData? selfScheduleInstancesData;

  static EventEnrollmentResponse fromJson(Map<String, dynamic> json) {
    EventEnrollmentResponse eventEnrollmentResponse = EventEnrollmentResponse();
    if (json['CourseList'] != null) {
      (json['CourseList'] ?? {}).forEach((v) {
        eventEnrollmentResponse.courseList.add(CourseList.fromJson(v));
      });
    }
    eventEnrollmentResponse.courseCount = json['CourseCount'] ?? 0;
    eventEnrollmentResponse
        .selfScheduleInstancesData = json['selfScheduleInstancesData'] !=
            null
        ? SelfScheduleInstancesData.fromJson(json['selfScheduleInstancesData'])
        : null;
    return eventEnrollmentResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.courseList != dynamic) {
      data['CourseList'] = this.courseList.map((v) => v.toJson()).toList();
    }
    data['CourseCount'] = this.courseCount;
    if (this.selfScheduleInstancesData != null) {
      data['selfScheduleInstancesData'] =
          this.selfScheduleInstancesData?.toJson();
    }
    return data;
  }
}

class CourseList {
  dynamic titlewithlink;
  dynamic rcaction;
  dynamic categories;
  dynamic isSubSite;
  dynamic membershipName;
  dynamic eventAvailableSeats;
  dynamic eventCompletedProgress;
  dynamic eventContentProgress;
  int count = 0;
  dynamic previewLink;
  dynamic approveLink;
  dynamic rejectLink;
  dynamic readLink;
  String addLink = "";
  dynamic enrollNowLink;
  dynamic cancelEventLink;
  dynamic waitListLink;
  dynamic inapppurchageLink;
  dynamic alredyinmylearnigLink;
  dynamic recommendedLink;
  dynamic sharelink;
  dynamic editMetadataLink;
  dynamic replaceLink;
  dynamic editLink;
  dynamic deleteLink;
  dynamic sampleContentLink;
  dynamic titleExpired;
  dynamic practiceAssessmentsAction;
  dynamic createAssessmentAction;
  dynamic overallProgressReportAction;
  dynamic contentName;
  dynamic contentScoID;
  String isContentEnrolled = "";
  dynamic contentViewType;
  dynamic windowProperties;
  int isWishListContent = 0;
  dynamic addtoWishList;
  dynamic removeFromWishList;
  String duration = "";
  dynamic credits;
  dynamic detailspopupTags;
  dynamic thumbnailIconPath;
  dynamic jWVideoKey;
  dynamic modules;
  dynamic salepricestrikeoff;
  dynamic isBadCancellationEnabled;
  String enrollmentLimit = "";
  String availableSeats = "";
  String noofUsersEnrolled = "";
  dynamic waitListLimit;
  String waitListEnrolls = "";
  bool isBookingOpened = false;
  dynamic eventStartDateforEnroll;
  dynamic downLoadLink;
  int eventType = 0;
  int eventScheduleType = 0;
  bool eventRecording = false;
  bool showParentPrerequisiteEventDate = false;
  bool showPrerequisiteEventDate = false;
  dynamic prerequisiteDateConflictName;
  dynamic prerequisiteDateConflictDateTime;
  dynamic skinID;
  int filterId = 0;
  int siteId = 0;
  int userSiteId = 0;
  dynamic siteName;
  int contentTypeId = 0;
  String contentID = "";
  String title = "";
  dynamic totalRatings;
  dynamic ratingID;
  String shortDescription = "";
  dynamic thumbnailImagePath;
  String instanceParentContentID = "";
  dynamic imageWithLink;
  dynamic authorWithLink;
  String eventStartDateTime = "";
  String eventEndDateTime = "";
  String eventStartDateTimeWithoutConvert = "";
  String eventEndDateTimeTimeWithoutConvert = "";
  dynamic expandiconpath;
  dynamic authorDisplayName;
  String contentType = "";
  dynamic createdOn;
  String timeZone = "";
  dynamic tags;
  dynamic salePrice;
  dynamic currency;
  dynamic viewLink;
  dynamic detailsLink;
  dynamic relatedContentLink;
  dynamic suggesttoConnLink;
  dynamic suggestwithFriendLink;
  dynamic sharetoRecommendedLink;
  dynamic isCoursePackage;
  dynamic isRelatedcontent;
  dynamic isaddtomylearninglogo;
  String locationName = "";
  dynamic buildingName;
  dynamic joinURL;
  dynamic categorycolor;
  dynamic invitationURL;
  dynamic headerLocationName;
  dynamic subSiteUserID;
  String presenterDisplayName = "";
  String presenterWithLink = "";
  dynamic authorName;
  dynamic freePrice;
  int siteUserID = 0;
  int scoID = 0;
  dynamic buyNowLink;
  bool bit5 = false;
  bool bit4 = false;
  bool openNewBrowserWindow = false;
  dynamic creditScoreWithCreditTypes;
  dynamic creditScoreFirstPrefix;
  int mediaTypeID = 0;
  dynamic isEnrollFutureInstance;
  dynamic instanceEventReclass;
  dynamic instanceEventReclassStatus;
  dynamic instanceEventReSchedule;
  dynamic instanceEventEnroll;
  dynamic reEnrollmentHistory;
  dynamic backGroundColor;
  dynamic fontColor;
  dynamic expiredContentExpiryDate;
  dynamic expiredContentAvailableUntill;
  dynamic gradient1;
  dynamic gradient2;
  dynamic gradientColor;

  /*CourseList(
      {this.titlewithlink,
        this.rcaction,
        this.categories,
        this.isSubSite,
        this.membershipName,
        this.eventAvailableSeats,
        this.eventCompletedProgress,
        this.eventContentProgress,
        this.count,
        this.previewLink,
        this.approveLink,
        this.rejectLink,
        this.readLink,
        this.addLink,
        this.enrollNowLink,
        this.cancelEventLink,
        this.waitListLink,
        this.inapppurchageLink,
        this.alredyinmylearnigLink,
        this.recommendedLink,
        this.sharelink,
        this.editMetadataLink,
        this.replaceLink,
        this.editLink,
        this.deleteLink,
        this.sampleContentLink,
        this.titleExpired,
        this.practiceAssessmentsAction,
        this.createAssessmentAction,
        this.overallProgressReportAction,
        this.contentName,
        this.contentScoID,
        this.isContentEnrolled,
        this.contentViewType,
        this.windowProperties,
        this.isWishListContent,
        this.addtoWishList,
        this.removeFromWishList,
        this.duration,
        this.credits,
        this.detailspopupTags,
        this.thumbnailIconPath,
        this.jWVideoKey,
        this.modules,
        this.salepricestrikeoff,
        this.isBadCancellationEnabled,
        this.enrollmentLimit,
        this.availableSeats,
        this.noofUsersEnrolled,
        this.waitListLimit,
        this.waitListEnrolls,
        this.isBookingOpened,
        this.eventStartDateforEnroll,
        this.downLoadLink,
        this.eventType,
        this.eventScheduleType,
        this.eventRecording,
        this.showParentPrerequisiteEventDate,
        this.showPrerequisiteEventDate,
        this.prerequisiteDateConflictName,
        this.prerequisiteDateConflictDateTime,
        this.skinID,
        this.filterId,
        this.siteId,
        this.userSiteId,
        this.siteName,
        this.contentTypeId,
        this.contentID,
        this.title,
        this.totalRatings,
        this.ratingID,
        this.shortDescription,
        this.thumbnailImagePath,
        this.instanceParentContentID,
        this.imageWithLink,
        this.authorWithLink,
        this.eventStartDateTime,
        this.eventEndDateTime,
        this.eventStartDateTimeWithoutConvert,
        this.eventEndDateTimeTimeWithoutConvert,
        this.expandiconpath,
        this.authorDisplayName,
        this.contentType,
        this.createdOn,
        this.timeZone,
        this.tags,
        this.salePrice,
        this.currency,
        this.viewLink,
        this.detailsLink,
        this.relatedContentLink,
        this.suggesttoConnLink,
        this.suggestwithFriendLink,
        this.sharetoRecommendedLink,
        this.isCoursePackage,
        this.isRelatedcontent,
        this.isaddtomylearninglogo,
        this.locationName,
        this.buildingName,
        this.joinURL,
        this.categorycolor,
        this.invitationURL,
        this.headerLocationName,
        this.subSiteUserID,
        this.presenterDisplayName,
        this.presenterWithLink,
        this.authorName,
        this.freePrice,
        this.siteUserID,
        this.scoID,
        this.buyNowLink,
        this.bit5,
        this.bit4,
        this.openNewBrowserWindow,
        this.creditScoreWithCreditTypes,
        this.creditScoreFirstPrefix,
        this.mediaTypeID,
        this.isEnrollFutureInstance,
        this.instanceEventReclass,
        this.instanceEventReclassStatus,
        this.instanceEventReSchedule,
        this.instanceEventEnroll,
        this.reEnrollmentHistory,
        this.backGroundColor,
        this.fontColor,
        this.expiredContentExpiryDate,
        this.expiredContentAvailableUntill,
        this.gradient1,
        this.gradient2,
        this.gradientColor});*/

  static CourseList fromJson(Map<String, dynamic> json) {
    CourseList courseList = CourseList();
    courseList.titlewithlink = json['Titlewithlink'];
    courseList.rcaction = json['rcaction'];
    courseList.categories = json['Categories'];
    courseList.isSubSite = json['IsSubSite'];
    courseList.membershipName = json['MembershipName'];
    courseList.eventAvailableSeats = json['EventAvailableSeats'];
    courseList.eventCompletedProgress = json['EventCompletedProgress'];
    courseList.eventContentProgress = json['EventContentProgress'];
    courseList.count = json['Count'] ?? 0;
    courseList.previewLink = json['PreviewLink'];
    courseList.approveLink = json['ApproveLink'];
    courseList.rejectLink = json['RejectLink'];
    courseList.readLink = json['ReadLink'];
    courseList.addLink = json['AddLink'] ?? "";
    courseList.enrollNowLink = json['EnrollNowLink'];
    courseList.cancelEventLink = json['CancelEventLink'];
    courseList.waitListLink = json['WaitListLink'];
    courseList.inapppurchageLink = json['InapppurchageLink'];
    courseList.alredyinmylearnigLink = json['AlredyinmylearnigLink'];
    courseList.recommendedLink = json['RecommendedLink'];
    courseList.sharelink = json['Sharelink'];
    courseList.editMetadataLink = json['EditMetadataLink'];
    courseList.replaceLink = json['ReplaceLink'];
    courseList.editLink = json['EditLink'];
    courseList.deleteLink = json['DeleteLink'];
    courseList.sampleContentLink = json['SampleContentLink'];
    courseList.titleExpired = json['TitleExpired'];
    courseList.practiceAssessmentsAction = json['PracticeAssessmentsAction'];
    courseList.createAssessmentAction = json['CreateAssessmentAction'];
    courseList.overallProgressReportAction =
        json['OverallProgressReportAction'];
    courseList.contentName = json['ContentName'];
    courseList.contentScoID = json['ContentScoID'];
    courseList.isContentEnrolled = json['isContentEnrolled'] ?? "";
    courseList.contentViewType = json['ContentViewType'];
    courseList.windowProperties = json['WindowProperties'];
    courseList.isWishListContent = json['isWishListContent'] ?? 0;
    courseList.addtoWishList = json['AddtoWishList'];
    courseList.removeFromWishList = json['RemoveFromWishList'];
    courseList.duration = json['Duration'] ?? "";
    courseList.credits = json['Credits'];
    courseList.detailspopupTags = json['DetailspopupTags'];
    courseList.thumbnailIconPath = json['ThumbnailIconPath'];
    courseList.jWVideoKey = json['JWVideoKey'];
    courseList.modules = json['Modules'];
    courseList.salepricestrikeoff = json['salepricestrikeoff'];
    courseList.isBadCancellationEnabled = json['isBadCancellationEnabled'];
    courseList.enrollmentLimit = json['EnrollmentLimit'] ?? "";
    courseList.availableSeats = json['AvailableSeats'] ?? "";
    courseList.noofUsersEnrolled = json['NoofUsersEnrolled'] ?? "";
    courseList.waitListLimit = json['WaitListLimit'];
    courseList.waitListEnrolls = json['WaitListEnrolls'] ?? "";
    courseList.isBookingOpened = json['isBookingOpened'] ?? false;
    courseList.eventStartDateforEnroll = json['EventStartDateforEnroll'];
    courseList.downLoadLink = json['DownLoadLink'];
    courseList.eventType = json['EventType'] ?? 0;
    courseList.eventScheduleType = json['EventScheduleType'] ?? 0;
    courseList.eventRecording = json['EventRecording'] ?? false;
    courseList.showParentPrerequisiteEventDate = json['ShowParentPrerequisiteEventDate'] ?? false;
    courseList.showPrerequisiteEventDate = json['ShowPrerequisiteEventDate'] ?? false;
    courseList.prerequisiteDateConflictName = json['PrerequisiteDateConflictName'];
    courseList.prerequisiteDateConflictDateTime = json['PrerequisiteDateConflictDateTime'];
    courseList.skinID = json['SkinID'];
    courseList.filterId = json['FilterId'] ?? 0;
    courseList.siteId = json['SiteId'] ?? 0;
    courseList.userSiteId = json['UserSiteId'] ?? 0;
    courseList.siteName = json['SiteName'];
    courseList.contentTypeId = json['ContentTypeId'] ?? 0;
    courseList.contentID = json['ContentID'] ?? "";
    courseList.title = json['Title'] ?? "";
    courseList.totalRatings = json['TotalRatings'];
    courseList.ratingID = json['RatingID'];
    courseList.shortDescription = json['ShortDescription'] ?? "";
    courseList.thumbnailImagePath = json['ThumbnailImagePath'];
    courseList.instanceParentContentID = json['InstanceParentContentID'] ?? "";
    courseList.imageWithLink = json['ImageWithLink'];
    courseList.authorWithLink = json['AuthorWithLink'];
    courseList.eventStartDateTime = json['EventStartDateTime'] ?? "";
    courseList.eventEndDateTime = json['EventEndDateTime'] ?? "";
    courseList.eventStartDateTimeWithoutConvert = json['EventStartDateTimeWithoutConvert'] ?? "";
    courseList.eventEndDateTimeTimeWithoutConvert = json['EventEndDateTimeTimeWithoutConvert'] ?? "";
    courseList.expandiconpath = json['expandiconpath'];
    courseList.authorDisplayName = json['AuthorDisplayName'];
    courseList.contentType = json['ContentType'] ?? "";
    courseList.createdOn = json['CreatedOn'];
    courseList.timeZone = json['TimeZone'] ?? "";
    courseList.tags = json['Tags'];
    courseList.salePrice = json['SalePrice'];
    courseList.currency = json['Currency'];
    courseList.viewLink = json['ViewLink'];
    courseList.detailsLink = json['DetailsLink'];
    courseList.relatedContentLink = json['RelatedContentLink'];
    courseList.suggesttoConnLink = json['SuggesttoConnLink'];
    courseList.suggestwithFriendLink = json['SuggestwithFriendLink'];
    courseList.sharetoRecommendedLink = json['SharetoRecommendedLink'];
    courseList.isCoursePackage = json['IsCoursePackage'];
    courseList.isRelatedcontent = json['IsRelatedcontent'];
    courseList.isaddtomylearninglogo = json['isaddtomylearninglogo'];
    courseList.locationName = json['LocationName'] ?? "";
    courseList.buildingName = json['BuildingName'];
    courseList.joinURL = json['JoinURL'];
    courseList.categorycolor = json['Categorycolor'];
    courseList.invitationURL = json['InvitationURL'];
    courseList.headerLocationName = json['HeaderLocationName'];
    courseList.subSiteUserID = json['SubSiteUserID'];
    courseList.presenterDisplayName = json['PresenterDisplayName'] ?? "";
    courseList.presenterWithLink = json['PresenterWithLink'] ?? "";
    courseList.authorName = json['AuthorName'];
    courseList.freePrice = json['FreePrice'];
    courseList.siteUserID = json['SiteUserID'] ?? 0;
    courseList.scoID = json['ScoID'] ?? 0;
    courseList.buyNowLink = json['BuyNowLink'];
    courseList.bit5 = json['bit5'] ?? false;
    courseList.bit4 = json['bit4'] ?? false;
    courseList.openNewBrowserWindow = json['OpenNewBrowserWindow'] ?? false;
    courseList.creditScoreWithCreditTypes = json['CreditScoreWithCreditTypes'];
    courseList.creditScoreFirstPrefix = json['CreditScoreFirstPrefix'];
    courseList.mediaTypeID = json['MediaTypeID'] ?? 0;
    courseList.isEnrollFutureInstance = json['isEnrollFutureInstance'];
    courseList.instanceEventReclass = json['InstanceEventReclass'];
    courseList.instanceEventReclassStatus = json['InstanceEventReclassStatus'];
    courseList.instanceEventReSchedule = json['InstanceEventReSchedule'];
    courseList.instanceEventEnroll = json['InstanceEventEnroll'];
    courseList.reEnrollmentHistory = json['ReEnrollmentHistory'];
    courseList.backGroundColor = json['BackGroundColor'];
    courseList.fontColor = json['FontColor'];
    courseList.expiredContentExpiryDate = json['ExpiredContentExpiryDate'];
    courseList.expiredContentAvailableUntill =
        json['ExpiredContentAvailableUntill'];
    courseList.gradient1 = json['Gradient1'];
    courseList.gradient2 = json['Gradient2'];
    courseList.gradientColor = json['GradientColor'];
    return courseList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Titlewithlink'] = this.titlewithlink;
    data['rcaction'] = this.rcaction;
    data['Categories'] = this.categories;
    data['IsSubSite'] = this.isSubSite;
    data['MembershipName'] = this.membershipName;
    data['EventAvailableSeats'] = this.eventAvailableSeats;
    data['EventCompletedProgress'] = this.eventCompletedProgress;
    data['EventContentProgress'] = this.eventContentProgress;
    data['Count'] = this.count;
    data['PreviewLink'] = this.previewLink;
    data['ApproveLink'] = this.approveLink;
    data['RejectLink'] = this.rejectLink;
    data['ReadLink'] = this.readLink;
    data['AddLink'] = this.addLink;
    data['EnrollNowLink'] = this.enrollNowLink;
    data['CancelEventLink'] = this.cancelEventLink;
    data['WaitListLink'] = this.waitListLink;
    data['InapppurchageLink'] = this.inapppurchageLink;
    data['AlredyinmylearnigLink'] = this.alredyinmylearnigLink;
    data['RecommendedLink'] = this.recommendedLink;
    data['Sharelink'] = this.sharelink;
    data['EditMetadataLink'] = this.editMetadataLink;
    data['ReplaceLink'] = this.replaceLink;
    data['EditLink'] = this.editLink;
    data['DeleteLink'] = this.deleteLink;
    data['SampleContentLink'] = this.sampleContentLink;
    data['TitleExpired'] = this.titleExpired;
    data['PracticeAssessmentsAction'] = this.practiceAssessmentsAction;
    data['CreateAssessmentAction'] = this.createAssessmentAction;
    data['OverallProgressReportAction'] = this.overallProgressReportAction;
    data['ContentName'] = this.contentName;
    data['ContentScoID'] = this.contentScoID;
    data['isContentEnrolled'] = this.isContentEnrolled;
    data['ContentViewType'] = this.contentViewType;
    data['WindowProperties'] = this.windowProperties;
    data['isWishListContent'] = this.isWishListContent;
    data['AddtoWishList'] = this.addtoWishList;
    data['RemoveFromWishList'] = this.removeFromWishList;
    data['Duration'] = this.duration;
    data['Credits'] = this.credits;
    data['DetailspopupTags'] = this.detailspopupTags;
    data['ThumbnailIconPath'] = this.thumbnailIconPath;
    data['JWVideoKey'] = this.jWVideoKey;
    data['Modules'] = this.modules;
    data['salepricestrikeoff'] = this.salepricestrikeoff;
    data['isBadCancellationEnabled'] = this.isBadCancellationEnabled;
    data['EnrollmentLimit'] = this.enrollmentLimit;
    data['AvailableSeats'] = this.availableSeats;
    data['NoofUsersEnrolled'] = this.noofUsersEnrolled;
    data['WaitListLimit'] = this.waitListLimit;
    data['WaitListEnrolls'] = this.waitListEnrolls;
    data['isBookingOpened'] = this.isBookingOpened;
    data['EventStartDateforEnroll'] = this.eventStartDateforEnroll;
    data['DownLoadLink'] = this.downLoadLink;
    data['EventType'] = this.eventType;
    data['EventScheduleType'] = this.eventScheduleType;
    data['EventRecording'] = this.eventRecording;
    data['ShowParentPrerequisiteEventDate'] =
        this.showParentPrerequisiteEventDate;
    data['ShowPrerequisiteEventDate'] = this.showPrerequisiteEventDate;
    data['PrerequisiteDateConflictName'] = this.prerequisiteDateConflictName;
    data['PrerequisiteDateConflictDateTime'] =
        this.prerequisiteDateConflictDateTime;
    data['SkinID'] = this.skinID;
    data['FilterId'] = this.filterId;
    data['SiteId'] = this.siteId;
    data['UserSiteId'] = this.userSiteId;
    data['SiteName'] = this.siteName;
    data['ContentTypeId'] = this.contentTypeId;
    data['ContentID'] = this.contentID;
    data['Title'] = this.title;
    data['TotalRatings'] = this.totalRatings;
    data['RatingID'] = this.ratingID;
    data['ShortDescription'] = this.shortDescription;
    data['ThumbnailImagePath'] = this.thumbnailImagePath;
    data['InstanceParentContentID'] = this.instanceParentContentID;
    data['ImageWithLink'] = this.imageWithLink;
    data['AuthorWithLink'] = this.authorWithLink;
    data['EventStartDateTime'] = this.eventStartDateTime;
    data['EventEndDateTime'] = this.eventEndDateTime;
    data['EventStartDateTimeWithoutConvert'] =
        this.eventStartDateTimeWithoutConvert;
    data['EventEndDateTimeTimeWithoutConvert'] =
        this.eventEndDateTimeTimeWithoutConvert;
    data['expandiconpath'] = this.expandiconpath;
    data['AuthorDisplayName'] = this.authorDisplayName;
    data['ContentType'] = this.contentType;
    data['CreatedOn'] = this.createdOn;
    data['TimeZone'] = this.timeZone;
    data['Tags'] = this.tags;
    data['SalePrice'] = this.salePrice;
    data['Currency'] = this.currency;
    data['ViewLink'] = this.viewLink;
    data['DetailsLink'] = this.detailsLink;
    data['RelatedContentLink'] = this.relatedContentLink;
    data['SuggesttoConnLink'] = this.suggesttoConnLink;
    data['SuggestwithFriendLink'] = this.suggestwithFriendLink;
    data['SharetoRecommendedLink'] = this.sharetoRecommendedLink;
    data['IsCoursePackage'] = this.isCoursePackage;
    data['IsRelatedcontent'] = this.isRelatedcontent;
    data['isaddtomylearninglogo'] = this.isaddtomylearninglogo;
    data['LocationName'] = this.locationName;
    data['BuildingName'] = this.buildingName;
    data['JoinURL'] = this.joinURL;
    data['Categorycolor'] = this.categorycolor;
    data['InvitationURL'] = this.invitationURL;
    data['HeaderLocationName'] = this.headerLocationName;
    data['SubSiteUserID'] = this.subSiteUserID;
    data['PresenterDisplayName'] = this.presenterDisplayName;
    data['PresenterWithLink'] = this.presenterWithLink;
    data['AuthorName'] = this.authorName;
    data['FreePrice'] = this.freePrice;
    data['SiteUserID'] = this.siteUserID;
    data['ScoID'] = this.scoID;
    data['BuyNowLink'] = this.buyNowLink;
    data['bit5'] = this.bit5;
    data['bit4'] = this.bit4;
    data['OpenNewBrowserWindow'] = this.openNewBrowserWindow;
    data['CreditScoreWithCreditTypes'] = this.creditScoreWithCreditTypes;
    data['CreditScoreFirstPrefix'] = this.creditScoreFirstPrefix;
    data['MediaTypeID'] = this.mediaTypeID;
    data['isEnrollFutureInstance'] = this.isEnrollFutureInstance;
    data['InstanceEventReclass'] = this.instanceEventReclass;
    data['InstanceEventReclassStatus'] = this.instanceEventReclassStatus;
    data['InstanceEventReSchedule'] = this.instanceEventReSchedule;
    data['InstanceEventEnroll'] = this.instanceEventEnroll;
    data['ReEnrollmentHistory'] = this.reEnrollmentHistory;
    data['BackGroundColor'] = this.backGroundColor;
    data['FontColor'] = this.fontColor;
    data['ExpiredContentExpiryDate'] = this.expiredContentExpiryDate;
    data['ExpiredContentAvailableUntill'] = this.expiredContentAvailableUntill;
    data['Gradient1'] = this.gradient1;
    data['Gradient2'] = this.gradient2;
    data['GradientColor'] = this.gradientColor;
    return data;
  }
}

class SelfScheduleInstancesData {
  List<Table> table = [];
  List<Table1> table1 = [];
  List<Table4> table4 = [];

  SelfScheduleInstancesData.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != dynamic) {
      json['Table'].forEach((v) {
        table.add(new Table.fromJson(v));
      });
    }
    if (json['Table1'] != dynamic) {
      json['Table1'].forEach((v) {
        table1.add(new Table1.fromJson(v));
      });
    }

    if (json['Table4'] != dynamic) {
      json['Table4'].forEach((v) {
        table4.add(new Table4.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != dynamic) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }
    if (this.table1 != dynamic) {
      data['Table1'] = this.table1.map((v) => v.toJson()).toList();
    }

    if (this.table4 != dynamic) {
      data['Table4'] = this.table4.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  String eventID = "";
  String contentID = "";
  String name = "";
  String duration = "";
  String eventStartDateTime = "";
  String eventEndDateTime = "";
  String location = "";
  int contentTypeId = 0;
  String timeZone = "";
  String presenterID = "";
  String email = "";
  int accountType = 0;
  String picture = "";
  String displayName = "";
  String about = "";
  bool bit4 = false;
  String authorName = "";
  int enrollmentLimit = 0;
  int availableSeats = 0;
  int eventType = 0;
  String contentType = "";
  String eventFulllocation = "";
  int totalEnrolls = 0;
  String shortDescription = "";
  int waitListEnrolls = 0;
  int waitListLimit = 0;
  String locationImage = "";
  int mediaTypeID = 0;
  String medaTypeName = "";
  int alreadyexist = 0;
  bool isDateExceed = false;

  Table.fromJson(Map<String, dynamic> json) {
    eventID = json['EventID'] ?? "";
    contentID = json['ContentID'] ?? "" ?? "";
    name = json['Name'] ?? "";
    duration = json['Duration'] ?? "";
    eventStartDateTime = json['EventStartDateTime'] ?? "";
    eventEndDateTime = json['EventEndDateTime'] ?? "";
    location = json['Location'] ?? "";
    contentTypeId = json['ContentTypeId'] ?? 0;
    timeZone = json['TimeZone'] ?? "";
    presenterID = json['PresenterID'] ?? "";
    email = json['Email'] ?? "";
    accountType = json['AccountType'] ?? 0;
    picture = json['Picture'] ?? "";
    displayName = json['DisplayName'] ?? "";
    about = json['About'] ?? "";
    bit4 = json['Bit4'] ?? false;
    authorName = json['AuthorName'] ?? "";
    enrollmentLimit = json['EnrollmentLimit'] ?? 0;
    availableSeats = json['AvailableSeats'] ?? 0;
    eventType = json['EventType'] ?? 0;
    contentType = json['ContentType'] ?? "";
    eventFulllocation = json['EventFulllocation'] ?? "";
    totalEnrolls = json['TotalEnrolls'] ?? 0;
    shortDescription = json['ShortDescription'] ?? "";
    waitListEnrolls = json['WaitListEnrolls'] ?? 0;
    waitListLimit = json['WaitListLimit'] ?? 0;
    locationImage = json['LocationImage'] ?? "";
    mediaTypeID = json['MediaTypeID'] ?? 0;
    medaTypeName = json['MedaTypeName'] ?? "";
    alreadyexist = json['alreadyexist'] ?? 0;
    isDateExceed = json['isDateExceed'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventID'] = this.eventID;
    data['ContentID'] = this.contentID;
    data['Name'] = this.name;
    data['Duration'] = this.duration;
    data['EventStartDateTime'] = this.eventStartDateTime;
    data['EventEndDateTime'] = this.eventEndDateTime;
    data['Location'] = this.location;
    data['ContentTypeId'] = this.contentTypeId;
    data['TimeZone'] = this.timeZone;
    data['PresenterID'] = this.presenterID;
    data['Email'] = this.email;
    data['AccountType'] = this.accountType;
    data['Picture'] = this.picture;
    data['DisplayName'] = this.displayName;
    data['About'] = this.about;
    data['Bit4'] = this.bit4;
    data['AuthorName'] = this.authorName;
    data['EnrollmentLimit'] = this.enrollmentLimit;
    data['AvailableSeats'] = this.availableSeats;
    data['EventType'] = this.eventType;
    data['ContentType'] = this.contentType;
    data['EventFulllocation'] = this.eventFulllocation;
    data['TotalEnrolls'] = this.totalEnrolls;
    data['ShortDescription'] = this.shortDescription;
    data['WaitListEnrolls'] = this.waitListEnrolls;
    data['WaitListLimit'] = this.waitListLimit;
    data['LocationImage'] = this.locationImage;
    data['MediaTypeID'] = this.mediaTypeID;
    data['MedaTypeName'] = this.medaTypeName;
    data['alreadyexist'] = this.alreadyexist;
    data['isDateExceed'] = this.isDateExceed;
    return data;
  }
}

class Table1 {
  String timezone = "";

  Table1.fromJson(Map<String, dynamic> json) {
    timezone = json['Timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Timezone'] = this.timezone;
    return data;
  }
}

class Table4 {
  String selfScheduledEventID = "";
  int orgUnitID = 0;

  Table4.fromJson(Map<String, dynamic> json) {
    selfScheduledEventID = json['SelfScheduledEventID'];
    orgUnitID = json['OrgUnitID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SelfScheduledEventID'] = this.selfScheduledEventID;
    data['OrgUnitID'] = this.orgUnitID;
    return data;
  }
}
