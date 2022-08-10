// To parse this JSON data, do
//
//     final sessionEventResponse = sessionEventResponseFromJson(jsonString);

import 'dart:convert';

SessionEventResponse sessionEventResponseFromJson(String str) =>
    SessionEventResponse.fromJson(json.decode(str));

String sessionEventResponseToJson(SessionEventResponse data) =>
    json.encode(data.toJson());

class SessionEventResponse {
  SessionEventResponse({
    required this.courseList,
    this.eventdatetimeformat = "",
  });

  List<CourseList> courseList = [];
  String eventdatetimeformat = "";

  factory SessionEventResponse.fromJson(Map<String, dynamic> json) =>
      SessionEventResponse(
        courseList: List<CourseList>.from(
            json["CourseList"].map((x) => CourseList.fromJson(x))),
        eventdatetimeformat: json["eventdatetimeformat"],
      );

  Map<String, dynamic> toJson() => {
        "CourseList": List<dynamic>.from(courseList.map((x) => x.toJson())),
        "eventdatetimeformat": eventdatetimeformat,
      };
}

class CourseList {
  CourseList({
    this.contentId = "",
    this.thumbnailIconPath = "",
    this.createdOn,
    this.authorDisplayName = "",
    this.scoId = 0,
    this.thumbnailImagePath = "",
    this.tags,
    this.title = "",
    this.shortDescription,
    this.contentTypeId = 0,
    this.currency,
    this.contentType = "",
    this.timeZone = "",
    this.presenterId = 0,
    this.contentstatus = "",
    this.salePrice,
    this.bit5 = false,
    this.prerequisites = 0,
    this.isLearnerContent = false,
    this.eventStartDateTime = "",
    this.eventEndDateTime = "",
    this.percentCompletedClass,
    this.location,
    this.recordingDetails,
    this.titlewithlink,
    this.rcaction,
    this.categories,
    this.isSubSite,
    this.membershipName,
    this.eventAvailableSeats,
    this.eventCompletedProgress,
    this.eventContentProgress,
    this.count = 0,
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
    this.contentScoId,
    this.isContentEnrolled,
    this.contentViewType,
    this.windowProperties,
    this.isWishListContent = 0,
    this.addtoWishList,
    this.removeFromWishList,
    this.duration = "",
    this.credits,
    this.detailspopupTags,
    this.jwVideoKey,
    this.modules,
    this.salepricestrikeoff,
    this.isBadCancellationEnabled,
    this.enrollmentLimit,
    this.availableSeats,
    this.noofUsersEnrolled,
    this.waitListLimit,
    this.waitListEnrolls,
    this.isBookingOpened = false,
    this.eventStartDateforEnroll,
    this.downLoadLink,
    this.eventType = 0,
    this.eventScheduleType = 0,
    this.eventRecording = false,
    this.showParentPrerequisiteEventDate = false,
    this.showPrerequisiteEventDate = false,
    this.prerequisiteDateConflictName,
    this.prerequisiteDateConflictDateTime,
    this.skinId,
    this.filterId = 0,
    this.siteId = 0,
    this.userSiteId = 0,
    this.siteName,
    this.totalRatings,
    this.ratingId,
    this.instanceParentContentId,
    this.imageWithLink,
    this.authorWithLink,
    this.eventStartDateTimeWithoutConvert = "",
    this.eventEndDateTimeTimeWithoutConvert = "",
    this.expandiconpath,
    this.viewLink,
    this.detailsLink,
    this.relatedContentLink,
    this.suggesttoConnLink,
    this.suggestwithFriendLink,
    this.sharetoRecommendedLink,
    this.isCoursePackage,
    this.isRelatedcontent,
    this.isaddtomylearninglogo,
    this.locationName = "",
    this.buildingName,
    this.joinUrl,
    this.categorycolor,
    this.invitationUrl,
    this.headerLocationName,
    this.subSiteUserId,
    this.presenterDisplayName = "",
    this.presenterWithLink = "",
    this.authorName,
    this.freePrice,
    this.siteUserId = 0,
    this.buyNowLink,
    this.bit4 = false,
    this.openNewBrowserWindow = false,
    this.creditScoreWithCreditTypes,
    this.creditScoreFirstPrefix,
    this.mediaTypeId = 0,
  });

  String contentId = "";
  String thumbnailIconPath = "";
  dynamic createdOn;
  String authorDisplayName = "";
  int scoId = 0;
  String thumbnailImagePath = "";
  dynamic tags;
  String title = "";
  dynamic shortDescription;
  int contentTypeId = 0;
  dynamic currency;
  String contentType = "";
  String timeZone = "";
  int presenterId = 0;
  String contentstatus = "";
  dynamic salePrice;
  bool bit5 = false;
  int prerequisites = 0;
  bool isLearnerContent = false;
  String eventStartDateTime = "";
  String eventEndDateTime = "";
  dynamic percentCompletedClass;
  dynamic location;
  RecordingDetails? recordingDetails;
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
  dynamic addLink;
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
  dynamic contentScoId;
  dynamic isContentEnrolled;
  dynamic contentViewType;
  dynamic windowProperties;
  int isWishListContent = 0;
  dynamic addtoWishList;
  dynamic removeFromWishList;
  String duration = "";
  dynamic credits;
  dynamic detailspopupTags;
  dynamic jwVideoKey;
  dynamic modules;
  dynamic salepricestrikeoff;
  dynamic isBadCancellationEnabled;
  dynamic enrollmentLimit;
  dynamic availableSeats;
  dynamic noofUsersEnrolled;
  dynamic waitListLimit;
  dynamic waitListEnrolls;
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
  dynamic skinId;
  int filterId = 0;
  int siteId = 0;
  int userSiteId = 0;
  dynamic siteName;
  dynamic totalRatings;
  dynamic ratingId;
  dynamic instanceParentContentId;
  dynamic imageWithLink;
  dynamic authorWithLink;
  String eventStartDateTimeWithoutConvert = "";
  String eventEndDateTimeTimeWithoutConvert = "";
  dynamic expandiconpath;
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
  dynamic joinUrl;
  dynamic categorycolor;
  dynamic invitationUrl;
  dynamic headerLocationName;
  dynamic subSiteUserId;
  String presenterDisplayName = "";
  String presenterWithLink = "";
  dynamic authorName;
  dynamic freePrice;
  int siteUserId = 0;
  dynamic buyNowLink;
  bool bit4 = false;
  bool openNewBrowserWindow = false;
  dynamic creditScoreWithCreditTypes;
  dynamic creditScoreFirstPrefix;
  int mediaTypeId = 0;

  factory CourseList.fromJson(Map<String, dynamic> json) => CourseList(
        contentId: json["ContentID"],
        thumbnailIconPath: json["ThumbnailIconPath"],
        createdOn: json["CreatedOn"],
        authorDisplayName: json["AuthorDisplayName"],
        scoId: json["ScoID"],
        thumbnailImagePath: json["ThumbnailImagePath"],
        tags: json["Tags"],
        title: json["Title"],
        shortDescription: json["ShortDescription"],
        contentTypeId: json["ContentTypeId"],
        currency: json["Currency"],
        contentType: json["ContentType"],
        timeZone: json["TimeZone"],
        presenterId: json["PresenterID"],
        contentstatus: json["Contentstatus"],
        salePrice: json["SalePrice"],
        bit5: json["bit5"],
        prerequisites: json["Prerequisites"],
        isLearnerContent: json["IsLearnerContent"],
        eventStartDateTime: json["EventStartDateTime"],
        eventEndDateTime: json["EventEndDateTime"],
        percentCompletedClass: json["PercentCompletedClass"],
        location: json["Location"],
        recordingDetails: RecordingDetails.fromJson(json["RecordingDetails"]),
        titlewithlink: json["Titlewithlink"],
        rcaction: json["rcaction"],
        categories: json["Categories"],
        isSubSite: json["IsSubSite"],
        membershipName: json["MembershipName"],
        eventAvailableSeats: json["EventAvailableSeats"],
        eventCompletedProgress: json["EventCompletedProgress"],
        eventContentProgress: json["EventContentProgress"],
        count: json["Count"],
        previewLink: json["PreviewLink"],
        approveLink: json["ApproveLink"],
        rejectLink: json["RejectLink"],
        readLink: json["ReadLink"],
        addLink: json["AddLink"],
        enrollNowLink: json["EnrollNowLink"],
        cancelEventLink: json["CancelEventLink"],
        waitListLink: json["WaitListLink"],
        inapppurchageLink: json["InapppurchageLink"],
        alredyinmylearnigLink: json["AlredyinmylearnigLink"],
        recommendedLink: json["RecommendedLink"],
        sharelink: json["Sharelink"],
        editMetadataLink: json["EditMetadataLink"],
        replaceLink: json["ReplaceLink"],
        editLink: json["EditLink"],
        deleteLink: json["DeleteLink"],
        sampleContentLink: json["SampleContentLink"],
        titleExpired: json["TitleExpired"],
        practiceAssessmentsAction: json["PracticeAssessmentsAction"],
        createAssessmentAction: json["CreateAssessmentAction"],
        overallProgressReportAction: json["OverallProgressReportAction"],
        contentName: json["ContentName"],
        contentScoId: json["ContentScoID"],
        isContentEnrolled: json["isContentEnrolled"],
        contentViewType: json["ContentViewType"],
        windowProperties: json["WindowProperties"],
        isWishListContent: json["isWishListContent"],
        addtoWishList: json["AddtoWishList"],
        removeFromWishList: json["RemoveFromWishList"],
        duration: json["Duration"],
        credits: json["Credits"],
        detailspopupTags: json["DetailspopupTags"],
        jwVideoKey: json["JWVideoKey"],
        modules: json["Modules"],
        salepricestrikeoff: json["salepricestrikeoff"],
        isBadCancellationEnabled: json["isBadCancellationEnabled"],
        enrollmentLimit: json["EnrollmentLimit"],
        availableSeats: json["AvailableSeats"],
        noofUsersEnrolled: json["NoofUsersEnrolled"],
        waitListLimit: json["WaitListLimit"],
        waitListEnrolls: json["WaitListEnrolls"],
        isBookingOpened: json["isBookingOpened"],
        eventStartDateforEnroll: json["EventStartDateforEnroll"],
        downLoadLink: json["DownLoadLink"],
        eventType: json["EventType"],
        eventScheduleType: json["EventScheduleType"],
        eventRecording: json["EventRecording"],
        showParentPrerequisiteEventDate:
            json["ShowParentPrerequisiteEventDate"],
        showPrerequisiteEventDate: json["ShowPrerequisiteEventDate"],
        prerequisiteDateConflictName: json["PrerequisiteDateConflictName"],
        prerequisiteDateConflictDateTime:
            json["PrerequisiteDateConflictDateTime"],
        skinId: json["SkinID"],
        filterId: json["FilterId"],
        siteId: json["SiteId"],
        userSiteId: json["UserSiteId"],
        siteName: json["SiteName"],
        totalRatings: json["TotalRatings"],
        ratingId: json["RatingID"],
        instanceParentContentId: json["InstanceParentContentID"],
        imageWithLink: json["ImageWithLink"],
        authorWithLink: json["AuthorWithLink"],
        eventStartDateTimeWithoutConvert:
            json["EventStartDateTimeWithoutConvert"],
        eventEndDateTimeTimeWithoutConvert:
            json["EventEndDateTimeTimeWithoutConvert"],
        expandiconpath: json["expandiconpath"],
        viewLink: json["ViewLink"],
        detailsLink: json["DetailsLink"],
        relatedContentLink: json["RelatedContentLink"],
        suggesttoConnLink: json["SuggesttoConnLink"],
        suggestwithFriendLink: json["SuggestwithFriendLink"],
        sharetoRecommendedLink: json["SharetoRecommendedLink"],
        isCoursePackage: json["IsCoursePackage"],
        isRelatedcontent: json["IsRelatedcontent"],
        isaddtomylearninglogo: json["isaddtomylearninglogo"],
        locationName: json["LocationName"],
        buildingName: json["BuildingName"],
        joinUrl: json["JoinURL"],
        categorycolor: json["Categorycolor"],
        invitationUrl: json["InvitationURL"],
        headerLocationName: json["HeaderLocationName"],
        subSiteUserId: json["SubSiteUserID"],
        presenterDisplayName: json["PresenterDisplayName"],
        presenterWithLink: json["PresenterWithLink"],
        authorName: json["AuthorName"],
        freePrice: json["FreePrice"],
        siteUserId: json["SiteUserID"],
        buyNowLink: json["BuyNowLink"],
        bit4: json["bit4"],
        openNewBrowserWindow: json["OpenNewBrowserWindow"],
        creditScoreWithCreditTypes: json["CreditScoreWithCreditTypes"],
        creditScoreFirstPrefix: json["CreditScoreFirstPrefix"],
        mediaTypeId: json["MediaTypeID"],
      );

  Map<String, dynamic> toJson() => {
        "ContentID": contentId,
        "ThumbnailIconPath": thumbnailIconPath,
        "CreatedOn": createdOn,
        "AuthorDisplayName": authorDisplayName,
        "ScoID": scoId,
        "ThumbnailImagePath": thumbnailImagePath,
        "Tags": tags,
        "Title": title,
        "ShortDescription": shortDescription,
        "ContentTypeId": contentTypeId,
        "Currency": currency,
        "ContentType": contentType,
        "TimeZone": timeZone,
        "PresenterID": presenterId,
        "Contentstatus": contentstatus,
        "SalePrice": salePrice,
        "bit5": bit5,
        "Prerequisites": prerequisites,
        "IsLearnerContent": isLearnerContent,
        "EventStartDateTime": eventStartDateTime,
        "EventEndDateTime": eventEndDateTime,
        "PercentCompletedClass": percentCompletedClass,
        "Location": location,
        "RecordingDetails": recordingDetails?.toJson(),
        "Titlewithlink": titlewithlink,
        "rcaction": rcaction,
        "Categories": categories,
        "IsSubSite": isSubSite,
        "MembershipName": membershipName,
        "EventAvailableSeats": eventAvailableSeats,
        "EventCompletedProgress": eventCompletedProgress,
        "EventContentProgress": eventContentProgress,
        "Count": count,
        "PreviewLink": previewLink,
        "ApproveLink": approveLink,
        "RejectLink": rejectLink,
        "ReadLink": readLink,
        "AddLink": addLink,
        "EnrollNowLink": enrollNowLink,
        "CancelEventLink": cancelEventLink,
        "WaitListLink": waitListLink,
        "InapppurchageLink": inapppurchageLink,
        "AlredyinmylearnigLink": alredyinmylearnigLink,
        "RecommendedLink": recommendedLink,
        "Sharelink": sharelink,
        "EditMetadataLink": editMetadataLink,
        "ReplaceLink": replaceLink,
        "EditLink": editLink,
        "DeleteLink": deleteLink,
        "SampleContentLink": sampleContentLink,
        "TitleExpired": titleExpired,
        "PracticeAssessmentsAction": practiceAssessmentsAction,
        "CreateAssessmentAction": createAssessmentAction,
        "OverallProgressReportAction": overallProgressReportAction,
        "ContentName": contentName,
        "ContentScoID": contentScoId,
        "isContentEnrolled": isContentEnrolled,
        "ContentViewType": contentViewType,
        "WindowProperties": windowProperties,
        "isWishListContent": isWishListContent,
        "AddtoWishList": addtoWishList,
        "RemoveFromWishList": removeFromWishList,
        "Duration": duration,
        "Credits": credits,
        "DetailspopupTags": detailspopupTags,
        "JWVideoKey": jwVideoKey,
        "Modules": modules,
        "salepricestrikeoff": salepricestrikeoff,
        "isBadCancellationEnabled": isBadCancellationEnabled,
        "EnrollmentLimit": enrollmentLimit,
        "AvailableSeats": availableSeats,
        "NoofUsersEnrolled": noofUsersEnrolled,
        "WaitListLimit": waitListLimit,
        "WaitListEnrolls": waitListEnrolls,
        "isBookingOpened": isBookingOpened,
        "EventStartDateforEnroll": eventStartDateforEnroll,
        "DownLoadLink": downLoadLink,
        "EventType": eventType,
        "EventScheduleType": eventScheduleType,
        "EventRecording": eventRecording,
        "ShowParentPrerequisiteEventDate": showParentPrerequisiteEventDate,
        "ShowPrerequisiteEventDate": showPrerequisiteEventDate,
        "PrerequisiteDateConflictName": prerequisiteDateConflictName,
        "PrerequisiteDateConflictDateTime": prerequisiteDateConflictDateTime,
        "SkinID": skinId,
        "FilterId": filterId,
        "SiteId": siteId,
        "UserSiteId": userSiteId,
        "SiteName": siteName,
        "TotalRatings": totalRatings,
        "RatingID": ratingId,
        "InstanceParentContentID": instanceParentContentId,
        "ImageWithLink": imageWithLink,
        "AuthorWithLink": authorWithLink,
        "EventStartDateTimeWithoutConvert": eventStartDateTimeWithoutConvert,
        "EventEndDateTimeTimeWithoutConvert":
            eventEndDateTimeTimeWithoutConvert,
        "expandiconpath": expandiconpath,
        "ViewLink": viewLink,
        "DetailsLink": detailsLink,
        "RelatedContentLink": relatedContentLink,
        "SuggesttoConnLink": suggesttoConnLink,
        "SuggestwithFriendLink": suggestwithFriendLink,
        "SharetoRecommendedLink": sharetoRecommendedLink,
        "IsCoursePackage": isCoursePackage,
        "IsRelatedcontent": isRelatedcontent,
        "isaddtomylearninglogo": isaddtomylearninglogo,
        "LocationName": locationName,
        "BuildingName": buildingName,
        "JoinURL": joinUrl,
        "Categorycolor": categorycolor,
        "InvitationURL": invitationUrl,
        "HeaderLocationName": headerLocationName,
        "SubSiteUserID": subSiteUserId,
        "PresenterDisplayName": presenterDisplayName,
        "PresenterWithLink": presenterWithLink,
        "AuthorName": authorName,
        "FreePrice": freePrice,
        "SiteUserID": siteUserId,
        "BuyNowLink": buyNowLink,
        "bit4": bit4,
        "OpenNewBrowserWindow": openNewBrowserWindow,
        "CreditScoreWithCreditTypes": creditScoreWithCreditTypes,
        "CreditScoreFirstPrefix": creditScoreFirstPrefix,
        "MediaTypeID": mediaTypeId,
      };
}

class RecordingDetails {
  RecordingDetails({
    this.eventRecording = false,
    this.eventRecordingMessage = "",
    this.eventRecordingUrl = "",
    this.eventRecordingContentId = "",
    this.eventRecordStatus = "",
    this.contentTypeId,
    this.contentId,
    this.viewLink,
    this.scoId,
    this.jwVideoKey,
    this.contentName,
    this.windowProperties,
    this.viewType,
    this.recordingType,
    this.wstatus,
    this.eventScoid = 0,
    this.contentProgress = 0,
    this.percentCompletedClass,
    this.eventId = "",
    this.language,
    this.cloudMediaPlayerKey,
  });

  bool eventRecording = false;
  String eventRecordingMessage = "";
  String eventRecordingUrl = "";
  String eventRecordingContentId = "";
  String eventRecordStatus = "";
  dynamic contentTypeId;
  dynamic contentId;
  dynamic viewLink;
  dynamic scoId;
  dynamic jwVideoKey;
  dynamic contentName;
  dynamic windowProperties;
  dynamic viewType;
  dynamic recordingType;
  dynamic wstatus;
  int eventScoid = 0;
  int contentProgress = 0;
  dynamic percentCompletedClass;
  String eventId = "";
  dynamic language;
  dynamic cloudMediaPlayerKey;

  factory RecordingDetails.fromJson(Map<String, dynamic> json) =>
      RecordingDetails(
        eventRecording: json["EventRecording"],
        eventRecordingMessage: json["EventRecordingMessage"],
        eventRecordingUrl: json["EventRecordingURL"],
        eventRecordingContentId: json["EventRecordingContentID"],
        eventRecordStatus: json["EventRecordStatus"],
        contentTypeId: json["ContentTypeId"],
        contentId: json["ContentID"],
        viewLink: json["ViewLink"],
        scoId: json["ScoID"],
        jwVideoKey: json["JWVideoKey"],
        contentName: json["ContentName"],
        windowProperties: json["WindowProperties"],
        viewType: json["ViewType"],
        recordingType: json["RecordingType"],
        wstatus: json["wstatus"],
        eventScoid: json["EventSCOID"],
        contentProgress: json["ContentProgress"],
        percentCompletedClass: json["PercentCompletedClass"],
        eventId: json["EventID"],
        language: json["Language"],
        cloudMediaPlayerKey: json["cloudMediaPlayerKey"],
      );

  Map<String, dynamic> toJson() => {
        "EventRecording": eventRecording,
        "EventRecordingMessage": eventRecordingMessage,
        "EventRecordingURL": eventRecordingUrl,
        "EventRecordingContentID": eventRecordingContentId,
        "EventRecordStatus": eventRecordStatus,
        "ContentTypeId": contentTypeId,
        "ContentID": contentId,
        "ViewLink": viewLink,
        "ScoID": scoId,
        "JWVideoKey": jwVideoKey,
        "ContentName": contentName,
        "WindowProperties": windowProperties,
        "ViewType": viewType,
        "RecordingType": recordingType,
        "wstatus": wstatus,
        "EventSCOID": eventScoid,
        "ContentProgress": contentProgress,
        "PercentCompletedClass": percentCompletedClass,
        "EventID": eventId,
        "Language": language,
        "cloudMediaPlayerKey": cloudMediaPlayerKey,
      };
}
