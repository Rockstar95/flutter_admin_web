// To parse this JSON data, do
//
//     final myLearningPlusCatelogResponse = myLearningPlusCatelogResponseFromJson(jsonString);

import 'dart:convert';

MyLearningPlusCatelogResponse myLearningPlusCatelogResponseFromJson(
        String str) =>
    MyLearningPlusCatelogResponse.fromJson(json.decode(str));

dynamic myLearningPlusCatelogResponseToJson(
        MyLearningPlusCatelogResponse data) =>
    json.encode(data.toJson());

class MyLearningPlusCatelogResponse {
  MyLearningPlusCatelogResponse({
    required this.courseList,
    this.courseCount = 0,
    this.notifyMessage = "",
  });

  List<CourseList> courseList = [];
  int courseCount = 0;
  String notifyMessage = "";

  MyLearningPlusCatelogResponse.fromJson(Map<String, dynamic> json) {
    notifyMessage = json['NotifyMessage'];
    courseCount = json['CourseCount'];
    if (json['CourseList'] != null) {
      json['CourseList'].forEach((v) {
        courseList.add(new CourseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotifyMessage'] = this.notifyMessage;
    data['CourseCount'] = this.courseCount;
    if (this.courseList != null) {
      data['CourseList'] = this.courseList.map((v) => v.toJson()).toList();
    }
    return data;
  }

// factory MyLearningPlusCatelogResponse.fromJson(Map<String, dynamic> json) => MyLearningPlusCatelogResponse(
//   courseList: List<CourseList>.from(json["CourseList"].map((x) => CourseList.fromJson(x))),
//   courseCount: json["CourseCount"],
//   notifyMessage: json["NotifyMessage"],
// );
//
// Map<String, dynamic> toJson() => {
//   "CourseList": List<dynamic>.from(courseList.map((x) => x.toJson())),
//   "CourseCount": courseCount,
//   "NotifyMessage": notifyMessage,
// };
}

class CourseList {
  CourseList({
    this.expired = "",
    this.attemptsLeft = 0,
    this.contentStatus = "",
    this.reportLink = "",
    this.discussionsLink = "",
    this.certificateLink = "",
    this.notesLink = "",
    this.cancelEventLink = "",
    this.downLoadLink = "",
    this.repurchaseLink = "",
    this.setcompleteLink = "",
    this.viewRecordingLink = "",
    this.instructorCommentsLink = "",
    this.required = 0,
    this.downloadCalender = "",
    this.eventScheduleLink = "",
    this.eventScheduleStatus = "",
    this.eventScheduleConfirmLink = "",
    this.eventScheduleCancelLink = "",
    this.eventScheduleReserveTime = "",
    this.eventScheduleReserveStatus = "",
    this.reScheduleEvent = "",
    this.addorremoveattendees = "",
    this.cancelScheduleEvent = "",
    this.sharelink = "",
    this.surveyLink = "",
    this.removeLink = "",
    this.ratingLink = "",
    this.durationEndDate,
    this.practiceAssessmentsAction = "",
    this.createAssessmentAction = "",
    this.overallProgressReportAction = "",
    this.editLink = "",
    this.titleName = "",
    this.percentCompleted = 0,
    this.percentCompletedClass = "",
    this.windowProperties = "",
    this.cancelOrderData = "",
    this.combinedTransaction = false,
    this.eventScheduleType = 0,
    this.typeofEvent = 0,
    this.duration = "",
    this.isViewReview = false,
    this.jwVideoKey = "",
    this.credits = "",
    this.isArchived = false,
    this.detailspopupTags = "",
    this.thumbnailIconPath,
    this.instanceEventEnroll = "",
    this.modules = "",
    this.instanceEventReSchedule = "",
    this.instanceEventReclass = "",
    this.isEnrollFutureInstance = "",
    this.reEnrollmentHistory = "",
    this.isBadCancellationEnabled = "",
    this.mediaTypeId = 0,
    this.actionViewQRcode = "",
    this.recordingDetails,
    this.enrollmentLimit,
    this.availableSeats,
    this.noofUsersEnrolled,
    this.waitListLimit,
    this.waitListEnrolls,
    this.isBookingOpened = false,
    this.subSiteMemberShipExpiried = false,
    this.showLearnerActions = false,
    this.skinId = "",
    this.backGroundColor = "",
    this.fontColor = "",
    this.filterId = 0,
    this.siteId = 0,
    this.userSiteId = 0,
    this.siteName = "",
    this.contentTypeId = 0,
    this.contentId = "",
    this.title = "",
    this.totalRatings,
    this.ratingId = "",
    this.shortDescription = "",
    this.thumbnailImagePath = "",
    this.instanceParentContentId,
    this.imageWithLink,
    this.authorWithLink = "",
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.eventStartDateTimeWithoutConvert,
    this.eventEndDateTimeTimeWithoutConvert,
    this.expandiconpath,
    this.authorDisplayName = "",
    this.contentType = "",
    this.createdOn,
    this.timeZone,
    this.tags,
    this.salePrice,
    this.currency,
    this.viewLink = "",
    this.detailsLink = "",
    this.relatedContentLink = "",
    this.viewSessionsLink = "",
    this.suggesttoConnLink = "",
    this.suggestwithFriendLink = "",
    this.sharetoRecommendedLink = "",
    this.isCoursePackage,
    this.isRelatedcontent = "",
    this.isaddtomylearninglogo,
    this.locationName,
    this.buildingName = "",
    this.joinUrl,
    this.categorycolor = "",
    this.invitationUrl,
    this.headerLocationName = "",
    this.subSiteUserId,
    this.presenterDisplayName = "",
    this.presenterWithLink,
    this.showMembershipExpiryAlert = false,
    this.authorName = "",
    this.freePrice,
    this.siteUserId = 0,
    this.scoId = 0,
    this.buyNowLink,
    this.bit5 = false,
    this.bit4 = false,
    this.openNewBrowserWindow = false,
    this.salepricestrikeoff = "",
    this.creditScoreWithCreditTypes,
    this.creditScoreFirstPrefix,
    this.eventType = 0,
    this.instanceEventReclassStatus = "",
    this.expiredContentExpiryDate = "",
    this.expiredContentAvailableUntill = "",
    this.gradient1,
    this.gradient2,
    this.gradientColor,
    this.shareContentwithUser = "",
  });

  String expired = "";
  int attemptsLeft = 0;
  String contentStatus = "";
  String reportLink = "";
  String discussionsLink = "";
  String certificateLink = "";
  String notesLink = "";
  String cancelEventLink = "";
  String downLoadLink = "";
  String repurchaseLink = "";
  String setcompleteLink = "";
  String viewRecordingLink = "";
  String instructorCommentsLink = "";
  int required = 0;
  String downloadCalender = "";
  String eventScheduleLink = "";
  String eventScheduleStatus = "";
  String eventScheduleConfirmLink = "";
  String eventScheduleCancelLink = "";
  String eventScheduleReserveTime = "";
  String eventScheduleReserveStatus = "";
  String reScheduleEvent = "";
  String addorremoveattendees = "";
  String cancelScheduleEvent = "";
  String sharelink = "";
  String surveyLink = "";
  String removeLink = "";
  String ratingLink = "";
  dynamic durationEndDate;
  String practiceAssessmentsAction = "";
  String createAssessmentAction = "";
  String overallProgressReportAction = "";
  String editLink = "";
  String titleName = "";
  double percentCompleted = 0;
  String percentCompletedClass = "";
  String windowProperties = "";
  String cancelOrderData = "";
  bool combinedTransaction = false;
  int eventScheduleType = 0;
  int typeofEvent = 0;
  String duration = "";
  bool isViewReview = false;
  String jwVideoKey = "";
  String credits = "";
  bool isArchived = false;
  String detailspopupTags = "";
  dynamic thumbnailIconPath;
  String instanceEventEnroll = "";
  String modules = "";
  String instanceEventReSchedule = "";
  String instanceEventReclass = "";
  String isEnrollFutureInstance = "";
  String reEnrollmentHistory = "";
  String isBadCancellationEnabled = "";
  int mediaTypeId = 0;
  String actionViewQRcode = "";
  dynamic recordingDetails;
  dynamic enrollmentLimit;
  dynamic availableSeats;
  dynamic noofUsersEnrolled;
  dynamic waitListLimit;
  dynamic waitListEnrolls;
  bool isBookingOpened = false;
  bool subSiteMemberShipExpiried = false;
  bool showLearnerActions = false;
  String skinId = "";
  String backGroundColor = "";
  String fontColor = "";
  int filterId = 0;
  int siteId = 0;
  int userSiteId = 0;
  String siteName = "";
  int contentTypeId = 0;
  String contentId = "";
  String title = "";
  dynamic totalRatings;
  String ratingId = "";
  String shortDescription = "";
  String thumbnailImagePath = "";
  dynamic instanceParentContentId;
  dynamic imageWithLink;
  String authorWithLink = "";
  dynamic eventStartDateTime;
  dynamic eventEndDateTime;
  dynamic eventStartDateTimeWithoutConvert;
  dynamic eventEndDateTimeTimeWithoutConvert;
  dynamic expandiconpath;
  String authorDisplayName = "";
  String contentType = "";
  dynamic createdOn;
  dynamic timeZone;
  dynamic tags;
  dynamic salePrice;
  dynamic currency;
  String viewLink = "";
  String detailsLink = "";
  String relatedContentLink = "";
  String viewSessionsLink = "";
  String suggesttoConnLink = "";
  String suggestwithFriendLink = "";
  dynamic sharetoRecommendedLink;
  dynamic isCoursePackage;
  String isRelatedcontent = "";
  dynamic isaddtomylearninglogo;
  dynamic locationName;
  String buildingName = "";
  dynamic joinUrl;
  String categorycolor = "";
  dynamic invitationUrl;
  String headerLocationName = "";
  dynamic subSiteUserId;
  String presenterDisplayName = "";
  dynamic presenterWithLink;
  bool showMembershipExpiryAlert = false;
  String authorName = "";
  dynamic freePrice;
  int siteUserId = 0;
  int scoId = 0;
  dynamic buyNowLink;
  bool bit5 = false;
  bool bit4 = false;
  bool openNewBrowserWindow = false;
  String salepricestrikeoff = "";
  dynamic creditScoreWithCreditTypes;
  dynamic creditScoreFirstPrefix;
  int eventType = 0;
  String instanceEventReclassStatus = "";
  String expiredContentExpiryDate = "";
  String expiredContentAvailableUntill = "";
  dynamic gradient1;
  dynamic gradient2;
  dynamic gradientColor;
  String shareContentwithUser = "";

  factory CourseList.fromJson(Map<String, dynamic> json) => CourseList(
        expired: json["Expired"],
        attemptsLeft: json["AttemptsLeft"],
        contentStatus: json["ContentStatus"],
        reportLink: json["ReportLink"],
        discussionsLink: json["DiscussionsLink"],
        certificateLink: json["CertificateLink"],
        notesLink: json["NotesLink"],
        cancelEventLink: json["CancelEventLink"],
        downLoadLink: json["DownLoadLink"],
        repurchaseLink: json["RepurchaseLink"],
        setcompleteLink: json["SetcompleteLink"],
        viewRecordingLink: json["ViewRecordingLink"],
        instructorCommentsLink: json["InstructorCommentsLink"],
        required: json["Required"],
        downloadCalender: json["DownloadCalender"],
        eventScheduleLink: json["EventScheduleLink"],
        eventScheduleStatus: json["EventScheduleStatus"],
        eventScheduleConfirmLink: json["EventScheduleConfirmLink"],
        eventScheduleCancelLink: json["EventScheduleCancelLink"],
        eventScheduleReserveTime: json["EventScheduleReserveTime"],
        eventScheduleReserveStatus: json["EventScheduleReserveStatus"],
        reScheduleEvent: json["ReScheduleEvent"],
        addorremoveattendees: json["Addorremoveattendees"],
        cancelScheduleEvent: json["CancelScheduleEvent"],
        sharelink: json["Sharelink"],
        surveyLink: json["SurveyLink"],
        removeLink: json["RemoveLink"],
        ratingLink: json["RatingLink"],
        durationEndDate: json["DurationEndDate"],
        practiceAssessmentsAction: json["PracticeAssessmentsAction"],
        createAssessmentAction: json["CreateAssessmentAction"],
        overallProgressReportAction: json["OverallProgressReportAction"],
        editLink: json["EditLink"],
        titleName: json["TitleName"],
        percentCompleted: json["PercentCompleted"],
        percentCompletedClass: json["PercentCompletedClass"],
        windowProperties: json["WindowProperties"],
        cancelOrderData: json["CancelOrderData"],
        combinedTransaction: json["CombinedTransaction"],
        eventScheduleType: json["EventScheduleType"],
        typeofEvent: json["TypeofEvent"],
        duration: json["Duration"],
        isViewReview: json["IsViewReview"],
        jwVideoKey: json["JWVideoKey"],
        credits: json["Credits"],
        isArchived: json["IsArchived"],
        detailspopupTags: json["DetailspopupTags"],
        thumbnailIconPath: json["ThumbnailIconPath"],
        instanceEventEnroll: json["InstanceEventEnroll"],
        modules: json["Modules"],
        instanceEventReSchedule: json["InstanceEventReSchedule"],
        instanceEventReclass: json["InstanceEventReclass"],
        isEnrollFutureInstance: json["isEnrollFutureInstance"],
        reEnrollmentHistory: json["ReEnrollmentHistory"],
        isBadCancellationEnabled: json["isBadCancellationEnabled"],
        mediaTypeId: json["MediaTypeID"],
        actionViewQRcode: json["ActionViewQRcode"],
        recordingDetails: json["RecordingDetails"],
        enrollmentLimit: json["EnrollmentLimit"],
        availableSeats: json["AvailableSeats"],
        noofUsersEnrolled: json["NoofUsersEnrolled"],
        waitListLimit: json["WaitListLimit"],
        waitListEnrolls: json["WaitListEnrolls"],
        isBookingOpened: json["isBookingOpened"],
        subSiteMemberShipExpiried: json["SubSiteMemberShipExpiried"],
        showLearnerActions: json["ShowLearnerActions"],
        skinId: json["SkinID"],
        backGroundColor: json["BackGroundColor"],
        fontColor: json["FontColor"],
        filterId: json["FilterId"],
        siteId: json["SiteId"],
        userSiteId: json["UserSiteId"],
        siteName: json["SiteName"],
        contentTypeId: json["ContentTypeId"],
        contentId: json["ContentID"],
        title: json["Title"],
        totalRatings: json["TotalRatings"],
        ratingId: json["RatingID"],
        shortDescription: json["ShortDescription"],
        thumbnailImagePath: json["ThumbnailImagePath"],
        instanceParentContentId: json["InstanceParentContentID"],
        imageWithLink: json["ImageWithLink"],
        authorWithLink: json["AuthorWithLink"],
        eventStartDateTime: json["EventStartDateTime"],
        eventEndDateTime: json["EventEndDateTime"],
        eventStartDateTimeWithoutConvert:
            json["EventStartDateTimeWithoutConvert"],
        eventEndDateTimeTimeWithoutConvert:
            json["EventEndDateTimeTimeWithoutConvert"],
        expandiconpath: json["expandiconpath"],
        authorDisplayName: json["AuthorDisplayName"],
        contentType: json["ContentType"],
        createdOn: json["CreatedOn"],
        timeZone: json["TimeZone"],
        tags: json["Tags"],
        salePrice: json["SalePrice"],
        currency: json["Currency"],
        viewLink: json["ViewLink"],
        detailsLink: json["DetailsLink"],
        relatedContentLink: json["RelatedContentLink"],
        viewSessionsLink: json["ViewSessionsLink"],
        suggesttoConnLink: json["SuggesttoConnLink"],
        suggestwithFriendLink: json["SuggestwithFriendLink"],
        sharetoRecommendedLink: json["SharetoRecommendedLink"],
        isCoursePackage: json["IsCoursePackage"],
        isRelatedcontent: json["IsRelatedcontent"],
        isaddtomylearninglogo: json["isaddtomylearninglogo"],
        locationName: json["LocationName"],
        buildingName:
            json["BuildingName"] == null ? null : json["BuildingName"],
        joinUrl: json["JoinURL"],
        categorycolor: json["Categorycolor"],
        invitationUrl: json["InvitationURL"],
        headerLocationName: json["HeaderLocationName"],
        subSiteUserId: json["SubSiteUserID"],
        presenterDisplayName: json["PresenterDisplayName"],
        presenterWithLink: json["PresenterWithLink"],
        showMembershipExpiryAlert: json["ShowMembershipExpiryAlert"],
        authorName: json["AuthorName"],
        freePrice: json["FreePrice"],
        siteUserId: json["SiteUserID"],
        scoId: json["ScoID"],
        buyNowLink: json["BuyNowLink"],
        bit5: json["bit5"],
        bit4: json["bit4"],
        openNewBrowserWindow: json["OpenNewBrowserWindow"],
        salepricestrikeoff: json["salepricestrikeoff"],
        creditScoreWithCreditTypes: json["CreditScoreWithCreditTypes"],
        creditScoreFirstPrefix: json["CreditScoreFirstPrefix"],
        eventType: json["EventType"],
        instanceEventReclassStatus: json["InstanceEventReclassStatus"],
        expiredContentExpiryDate: json["ExpiredContentExpiryDate"],
        expiredContentAvailableUntill: json["ExpiredContentAvailableUntill"],
        gradient1: json["Gradient1"],
        gradient2: json["Gradient2"],
        gradientColor: json["GradientColor"],
        shareContentwithUser: json["ShareContentwithUser"],
      );

  Map<String, dynamic> toJson() => {
        "Expired": expired,
        "AttemptsLeft": attemptsLeft,
        "ContentStatus": contentStatus,
        "ReportLink": reportLink,
        "DiscussionsLink": discussionsLink,
        "CertificateLink": certificateLink,
        "NotesLink": notesLink,
        "CancelEventLink": cancelEventLink,
        "DownLoadLink": downLoadLink,
        "RepurchaseLink": repurchaseLink,
        "SetcompleteLink": setcompleteLink,
        "ViewRecordingLink": viewRecordingLink,
        "InstructorCommentsLink": instructorCommentsLink,
        "Required": required,
        "DownloadCalender": downloadCalender,
        "EventScheduleLink": eventScheduleLink,
        "EventScheduleStatus": eventScheduleStatus,
        "EventScheduleConfirmLink": eventScheduleConfirmLink,
        "EventScheduleCancelLink": eventScheduleCancelLink,
        "EventScheduleReserveTime": eventScheduleReserveTime,
        "EventScheduleReserveStatus": eventScheduleReserveStatus,
        "ReScheduleEvent": reScheduleEvent,
        "Addorremoveattendees": addorremoveattendees,
        "CancelScheduleEvent": cancelScheduleEvent,
        "Sharelink": sharelink,
        "SurveyLink": surveyLink,
        "RemoveLink": removeLink,
        "RatingLink": ratingLink,
        "DurationEndDate": durationEndDate,
        "PracticeAssessmentsAction": practiceAssessmentsAction,
        "CreateAssessmentAction": createAssessmentAction,
        "OverallProgressReportAction": overallProgressReportAction,
        "EditLink": editLink,
        "TitleName": titleName,
        "PercentCompleted": percentCompleted,
        "PercentCompletedClass": percentCompletedClass,
        "WindowProperties": windowProperties,
        "CancelOrderData": cancelOrderData,
        "CombinedTransaction": combinedTransaction,
        "EventScheduleType": eventScheduleType,
        "TypeofEvent": typeofEvent,
        "Duration": duration,
        "IsViewReview": isViewReview,
        "JWVideoKey": jwVideoKey,
        "Credits": credits,
        "IsArchived": isArchived,
        "DetailspopupTags": detailspopupTags,
        "ThumbnailIconPath": thumbnailIconPath,
        "InstanceEventEnroll": instanceEventEnroll,
        "Modules": modules,
        "InstanceEventReSchedule": instanceEventReSchedule,
        "InstanceEventReclass": instanceEventReclass,
        "isEnrollFutureInstance": isEnrollFutureInstance,
        "ReEnrollmentHistory": reEnrollmentHistory,
        "isBadCancellationEnabled": isBadCancellationEnabled,
        "MediaTypeID": mediaTypeId,
        "ActionViewQRcode": actionViewQRcode,
        "RecordingDetails": recordingDetails,
        "EnrollmentLimit": enrollmentLimit,
        "AvailableSeats": availableSeats,
        "NoofUsersEnrolled": noofUsersEnrolled,
        "WaitListLimit": waitListLimit,
        "WaitListEnrolls": waitListEnrolls,
        "isBookingOpened": isBookingOpened,
        "SubSiteMemberShipExpiried": subSiteMemberShipExpiried,
        "ShowLearnerActions": showLearnerActions,
        "SkinID": skinId,
        "BackGroundColor": backGroundColor,
        "FontColor": fontColor,
        "FilterId": filterId,
        "SiteId": siteId,
        "UserSiteId": userSiteId,
        "SiteName": siteName,
        "ContentTypeId": contentTypeId,
        "ContentID": contentId,
        "Title": title,
        "TotalRatings": totalRatings,
        "RatingID": ratingId,
        "ShortDescription": shortDescription,
        "ThumbnailImagePath": thumbnailImagePath,
        "InstanceParentContentID": instanceParentContentId,
        "ImageWithLink": imageWithLink,
        "AuthorWithLink": authorWithLink,
        "EventStartDateTime": eventStartDateTime,
        "EventEndDateTime": eventEndDateTime,
        "EventStartDateTimeWithoutConvert": eventStartDateTimeWithoutConvert,
        "EventEndDateTimeTimeWithoutConvert":
            eventEndDateTimeTimeWithoutConvert,
        "expandiconpath": expandiconpath,
        "AuthorDisplayName": authorDisplayName,
        "ContentType": contentType,
        "CreatedOn": createdOn,
        "TimeZone": timeZone,
        "Tags": tags,
        "SalePrice": salePrice,
        "Currency": currency,
        "ViewLink": viewLink,
        "DetailsLink": detailsLink,
        "RelatedContentLink": relatedContentLink,
        "ViewSessionsLink": viewSessionsLink,
        "SuggesttoConnLink": suggesttoConnLink,
        "SuggestwithFriendLink": suggestwithFriendLink,
        "SharetoRecommendedLink": sharetoRecommendedLink,
        "IsCoursePackage": isCoursePackage,
        "IsRelatedcontent": isRelatedcontent,
        "isaddtomylearninglogo": isaddtomylearninglogo,
        "LocationName": locationName,
        "BuildingName": buildingName == null ? null : buildingName,
        "JoinURL": joinUrl,
        "Categorycolor": categorycolor,
        "InvitationURL": invitationUrl,
        "HeaderLocationName": headerLocationName,
        "SubSiteUserID": subSiteUserId,
        "PresenterDisplayName": presenterDisplayName,
        "PresenterWithLink": presenterWithLink,
        "ShowMembershipExpiryAlert": showMembershipExpiryAlert,
        "AuthorName": authorName,
        "FreePrice": freePrice,
        "SiteUserID": siteUserId,
        "ScoID": scoId,
        "BuyNowLink": buyNowLink,
        "bit5": bit5,
        "bit4": bit4,
        "OpenNewBrowserWindow": openNewBrowserWindow,
        "salepricestrikeoff": salepricestrikeoff,
        "CreditScoreWithCreditTypes": creditScoreWithCreditTypes,
        "CreditScoreFirstPrefix": creditScoreFirstPrefix,
        "EventType": eventType,
        "InstanceEventReclassStatus": instanceEventReclassStatus,
        "ExpiredContentExpiryDate": expiredContentExpiryDate,
        "ExpiredContentAvailableUntill": expiredContentAvailableUntill,
        "Gradient1": gradient1,
        "Gradient2": gradient2,
        "GradientColor": gradientColor,
        "ShareContentwithUser": shareContentwithUser,
      };
}
