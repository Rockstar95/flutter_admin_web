import 'dart:convert';

SearchResultResponse searchResultResponseFromJson(String str) =>
    SearchResultResponse.fromJson(json.decode(str));

String searchResultResponseToJson(SearchResultResponse data) =>
    json.encode(data.toJson());

class SearchResultResponse {
  List<CourseList> courseList = [];
  int courseCount = 0;

  /*SearchResultResponse({
    this.courseList,
    this.courseCount = 0,
  });*/

  SearchResultResponse.fromJson(Map<String, dynamic> json) {
    courseList = List<CourseList>.from(
        json["CourseList"].map((x) => CourseList.fromJson(x)));
    courseCount = json["CourseCount"];
  }

  Map<String, dynamic> toJson() => {
        "CourseList": List<dynamic>.from(courseList.map((x) => x.toJson())),
        "CourseCount": courseCount,
      };
}

class CourseList {
  CourseList({
    this.namePreFix = "",
    this.eventAvailableSeats = "",
    this.eventContentProgress,
    this.salePrice = "",
    this.destinationLink = "",
    this.addLink = "",
    this.cancelEventLink = "",
    this.enrollLink = "",
    this.waitListLink = "",
    this.recommendedLink = "",
    this.sharelink = "",
    this.longDescription,
    this.startPage = "",
    this.scoid,
    this.participantUrl,
    this.viewType = 0,
    this.mediaTypeId,
    this.publishedDate,
    this.itunesProductId,
    this.listView = false,
    this.siteUrl,
    this.membershipName = "",
    this.titleExpired = "",
    this.viewProfileLink,
    this.noImageText = "",
    this.isContentEnrolled = "",
    this.contentViewType = "",
    this.windowProperties = "",
    this.jwVideoKey = "",
    this.isBadCancellationEnabled = "",
    this.downLoadLink = "",
    this.isBookingOpened = false,
    this.enrollmentLimit = "",
    this.availableSeats = "",
    this.noofUsersEnrolled = "",
    this.waitListLimit = "",
    this.waitListEnrolls = "",
    this.eventRecording = false,
    this.skinId = "",
    this.filterId = 0,
    this.siteId = 0,
    this.userSiteId = 0,
    this.siteName,
    this.contentTypeId = 0,
    this.contentId = "",
    this.title,
    this.totalRatings = "",
    this.ratingId = "",
    this.shortDescription,
    this.thumbnailImagePath = "",
    this.instanceParentContentId = "",
    this.imageWithLink = "",
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
    this.currency = "",
    this.viewLink = "",
    this.detailsLink = "",
    this.relatedContentLink = "",
    this.suggesttoConnLink = "",
    this.suggestwithFriendLink = "",
    this.sharetoRecommendedLink = "",
    this.isCoursePackage,
    this.isRelatedcontent = "",
    this.isaddtomylearninglogo = "",
    this.locationName,
    this.buildingName,
    this.joinUrl,
    this.categorycolor = "",
    this.invitationUrl,
    this.headerLocationName = "",
    this.subSiteUserId = "",
    this.presenterDisplayName = "",
    this.presenterWithLink,
    this.authorName = "",
    this.freePrice = "",
    this.siteUserId = 0,
    this.scoId = 0,
    this.buyNowLink = "",
    this.bit5 = false,
    this.bit4 = false,
    this.openNewBrowserWindow = false,
    this.thumbnailIconPath,
    this.salepricestrikeoff = "",
    this.creditScoreWithCreditTypes,
    this.creditScoreFirstPrefix,
    this.eventType = 0,
    this.eventScheduleType = 0,
    this.isEnrollFutureInstance = "",
    this.instanceEventReclass = "",
    this.instanceEventReclassStatus = "",
    this.instanceEventReSchedule = "",
    this.instanceEventEnroll = "",
    this.reEnrollmentHistory = "",
    this.backGroundColor = "",
    this.fontColor = "",
    this.expiredContentExpiryDate = "",
    this.expiredContentAvailableUntill = "",
    this.gradient1 = "",
    this.gradient2 = "",
    this.gradientColor = "",
  });

  String namePreFix = "";
  String eventAvailableSeats = "";
  dynamic eventContentProgress;
  String salePrice = "";
  String destinationLink = "";
  String addLink = "";
  String cancelEventLink = "";
  String enrollLink = "";
  String waitListLink = "";
  String recommendedLink = "";
  String sharelink = "";
  dynamic longDescription;
  String startPage = "";
  dynamic scoid;
  dynamic participantUrl;
  int viewType = 0;
  dynamic mediaTypeId;
  dynamic publishedDate;
  dynamic itunesProductId;
  bool listView = false;
  dynamic siteUrl;
  String membershipName = "";
  String titleExpired = "";
  dynamic viewProfileLink;
  String noImageText = "";
  String isContentEnrolled = "";
  String contentViewType = "";
  String windowProperties = "";
  String jwVideoKey = "";
  String isBadCancellationEnabled = "";
  String downLoadLink = "";
  bool isBookingOpened = false;
  String enrollmentLimit = "";
  String availableSeats = "";
  String noofUsersEnrolled = "";
  String waitListLimit = "";
  String waitListEnrolls = "";
  bool eventRecording = false;
  String skinId = "";
  int filterId = 0;
  int siteId = 0;
  int userSiteId = 0;
  dynamic siteName;
  int contentTypeId = 0;
  String contentId = "";
  dynamic title;
  String totalRatings = "";
  String ratingId = "";
  dynamic shortDescription;
  String thumbnailImagePath = "";
  String instanceParentContentId = "";
  String imageWithLink = "";
  dynamic authorWithLink;
  dynamic eventStartDateTime;
  dynamic eventEndDateTime;
  dynamic eventStartDateTimeWithoutConvert;
  dynamic eventEndDateTimeTimeWithoutConvert;
  dynamic expandiconpath;
  dynamic authorDisplayName;
  dynamic contentType;
  dynamic createdOn;
  dynamic timeZone;
  dynamic tags;
  String currency = "";
  String viewLink = "";
  String detailsLink = "";
  String relatedContentLink = "";
  String suggesttoConnLink = "";
  String suggestwithFriendLink = "";
  String sharetoRecommendedLink = "";
  dynamic isCoursePackage;
  String isRelatedcontent = "";
  String isaddtomylearninglogo = "";
  dynamic locationName;
  dynamic buildingName;
  dynamic joinUrl;
  String categorycolor = "";
  dynamic invitationUrl;
  String headerLocationName = "";
  String subSiteUserId = "";
  String presenterDisplayName = "";
  dynamic presenterWithLink;
  String authorName = "";
  String freePrice = "";
  int siteUserId = 0;
  int scoId = 0;
  String buyNowLink = "";
  bool bit5 = false;
  bool bit4 = false;
  bool openNewBrowserWindow = false;
  dynamic thumbnailIconPath;
  String salepricestrikeoff = "";
  dynamic creditScoreWithCreditTypes;
  dynamic creditScoreFirstPrefix;
  int eventType = 0;
  int eventScheduleType = 0;
  String isEnrollFutureInstance = "";
  String instanceEventReclass = "";
  String instanceEventReclassStatus = "";
  String instanceEventReSchedule = "";
  String instanceEventEnroll = "";
  String reEnrollmentHistory = "";
  String backGroundColor = "";
  String fontColor = "";
  String expiredContentExpiryDate = "";
  String expiredContentAvailableUntill = "";
  String gradient1 = "";
  String gradient2 = "";
  String gradientColor = "";

  factory CourseList.fromJson(Map<String, dynamic> json) => CourseList(
        namePreFix: json["NamePreFix"],
        eventAvailableSeats: json["EventAvailableSeats"],
        eventContentProgress: json["EventContentProgress"],
        salePrice: json["SalePrice"],
        destinationLink: json["DestinationLink"],
        addLink: json["AddLink"],
        cancelEventLink: json["CancelEventLink"],
        enrollLink: json["EnrollLink"],
        waitListLink: json["WaitListLink"],
        recommendedLink: json["RecommendedLink"],
        sharelink: json["Sharelink"],
        longDescription: json["LongDescription"],
        startPage: json["StartPage"],
        scoid: json["SCOID"],
        participantUrl: json["ParticipantURL"],
        viewType: json["ViewType"],
        mediaTypeId: json["MediaTypeID"],
        publishedDate: json["PublishedDate"],
        itunesProductId: json["ItunesProductID"],
        listView: json["ListView"],
        siteUrl: json["SiteURL"],
        membershipName: json["MembershipName"],
        titleExpired: json["TitleExpired"],
        viewProfileLink: json["ViewProfileLink"],
        noImageText: json["NoImageText"],
        isContentEnrolled: json["isContentEnrolled"],
        contentViewType: json["ContentViewType"],
        windowProperties: json["WindowProperties"],
        jwVideoKey: json["JWVideoKey"],
        isBadCancellationEnabled: json["isBadCancellationEnabled"],
        downLoadLink: json["DownLoadLink"],
        isBookingOpened: json["isBookingOpened"],
        enrollmentLimit: json["EnrollmentLimit"],
        availableSeats: json["AvailableSeats"],
        noofUsersEnrolled: json["NoofUsersEnrolled"],
        waitListLimit: json["WaitListLimit"],
        waitListEnrolls: json["WaitListEnrolls"],
        eventRecording: json["EventRecording"],
        skinId: json["SkinID"],
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
        currency: json["Currency"],
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
        freePrice: json["FreePrice"] ?? "",
        siteUserId: json["SiteUserID"],
        scoId: json["ScoID"],
        buyNowLink: json["BuyNowLink"],
        bit5: json["bit5"],
        bit4: json["bit4"],
        openNewBrowserWindow: json["OpenNewBrowserWindow"],
        thumbnailIconPath: json["ThumbnailIconPath"],
        salepricestrikeoff: json["salepricestrikeoff"],
        creditScoreWithCreditTypes: json["CreditScoreWithCreditTypes"],
        creditScoreFirstPrefix: json["CreditScoreFirstPrefix"],
        eventType: json["EventType"],
        eventScheduleType: json["EventScheduleType"],
        isEnrollFutureInstance: json["isEnrollFutureInstance"],
        instanceEventReclass: json["InstanceEventReclass"],
        instanceEventReclassStatus: json["InstanceEventReclassStatus"],
        instanceEventReSchedule: json["InstanceEventReSchedule"],
        instanceEventEnroll: json["InstanceEventEnroll"],
        reEnrollmentHistory: json["ReEnrollmentHistory"],
        backGroundColor: json["BackGroundColor"],
        fontColor: json["FontColor"],
        expiredContentExpiryDate: json["ExpiredContentExpiryDate"],
        expiredContentAvailableUntill: json["ExpiredContentAvailableUntill"],
        gradient1: json["Gradient1"],
        gradient2: json["Gradient2"],
        gradientColor: json["GradientColor"],
      );

  Map<String, dynamic> toJson() => {
        "NamePreFix": namePreFix,
        "EventAvailableSeats": eventAvailableSeats,
        "EventContentProgress": eventContentProgress,
        "SalePrice": salePrice,
        "DestinationLink": destinationLink,
        "AddLink": addLink,
        "CancelEventLink": cancelEventLink,
        "EnrollLink": enrollLink,
        "WaitListLink": waitListLink,
        "RecommendedLink": recommendedLink,
        "Sharelink": sharelink,
        "LongDescription": longDescription,
        "StartPage": startPage,
        "SCOID": scoid,
        "ParticipantURL": participantUrl,
        "ViewType": viewType,
        "MediaTypeID": mediaTypeId,
        "PublishedDate": publishedDate,
        "ItunesProductID": itunesProductId,
        "ListView": listView,
        "SiteURL": siteUrl,
        "MembershipName": membershipName,
        "TitleExpired": titleExpired,
        "ViewProfileLink": viewProfileLink,
        "NoImageText": noImageText,
        "isContentEnrolled": isContentEnrolled,
        "ContentViewType": contentViewType,
        "WindowProperties": windowProperties,
        "JWVideoKey": jwVideoKey,
        "isBadCancellationEnabled": isBadCancellationEnabled,
        "DownLoadLink": downLoadLink,
        "isBookingOpened": isBookingOpened,
        "EnrollmentLimit": enrollmentLimit,
        "AvailableSeats": availableSeats,
        "NoofUsersEnrolled": noofUsersEnrolled,
        "WaitListLimit": waitListLimit,
        "WaitListEnrolls": waitListEnrolls,
        "EventRecording": eventRecording,
        "SkinID": skinId,
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
        "Currency": currency,
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
        "ScoID": scoId,
        "BuyNowLink": buyNowLink,
        "bit5": bit5,
        "bit4": bit4,
        "OpenNewBrowserWindow": openNewBrowserWindow,
        "ThumbnailIconPath": thumbnailIconPath,
        "salepricestrikeoff": salepricestrikeoff,
        "CreditScoreWithCreditTypes": creditScoreWithCreditTypes,
        "CreditScoreFirstPrefix": creditScoreFirstPrefix,
        "EventType": eventType,
        "EventScheduleType": eventScheduleType,
        "isEnrollFutureInstance": isEnrollFutureInstance,
        "InstanceEventReclass": instanceEventReclass,
        "InstanceEventReclassStatus": instanceEventReclassStatus,
        "InstanceEventReSchedule": instanceEventReSchedule,
        "InstanceEventEnroll": instanceEventEnroll,
        "ReEnrollmentHistory": reEnrollmentHistory,
        "BackGroundColor": backGroundColor,
        "FontColor": fontColor,
        "ExpiredContentExpiryDate": expiredContentExpiryDate,
        "ExpiredContentAvailableUntill": expiredContentAvailableUntill,
        "Gradient1": gradient1,
        "Gradient2": gradient2,
        "GradientColor": gradientColor,
      };
}
