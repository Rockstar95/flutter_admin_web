// To parse this JSON data, do
//
//     final myLearningDetailsResponse = myLearningDetailsResponseFromJson(jsondynamic);

import 'dart:convert';

MyLearningDetailsResponse myLearningDetailsResponseFromJson(dynamic str) =>
    MyLearningDetailsResponse.fromJson(json.decode(str));

dynamic myLearningDetailsResponseToJson(MyLearningDetailsResponse data) =>
    json.encode(data.toJson());

class MyLearningDetailsResponse {
  MyLearningDetailsResponse({
    this.isSuccess = false,
    this.noRecord = false,
    this.strCatalogContentRemoved,
    this.presentername,
    this.presenterLink,
    this.directionUrl,
    this.longDescription,
    this.errorMesage,
    this.addLink,
    this.cancelEventlink,
    this.enrollNowLink,
    this.downloadCalender,
    this.titleExpired,
    this.addPastLink,
    this.contentStatus,
    this.eventScheduleLink,
    this.eventScheduleStatus,
    this.eventScheduleConfirmLink,
    this.eventScheduleCancelLink,
    this.eventScheduleReserveTime,
    this.eventScheduleReserveStatus,
    this.reScheduleEvent,
    this.addorremoveattendees,
    this.cancelScheduleEvent,
    this.durationEndDate,
    this.showReadMore,
    this.setCompleteAction,
    this.titleName,
    this.titleWithlink,
    this.imageWithlink,
    this.showThumbnailImagePath,
    this.certificateLink,
    this.surveyLink,
    this.notesLink,
    this.waitListLink,
    this.showParentPrerequisiteEventDate,
    this.showPrerequisiteEventDate,
    this.discussionsLink,
    this.isContentEnrolled,
    this.contentViewType,
    this.windowProperties,
    this.autolaunchViewLink,
    this.titleViewlink,
    this.notifyMessage,
    this.learningObjectives,
    this.tableofContent,
    this.thumbnailVideoPath,
    this.jwVideoKey,
    this.isArchived = false,
    this.thumbnailIconPath,
    this.showSchedule = false,
    this.subTitleTag,
    this.eventScheduleType,
    this.percentCompletedClass,
    this.percentagecompleted,
    this.islearningcontent,
    this.isViewReview = false,
    this.eventType,
    this.redirectinstanceId,
    this.isBadCancellationEnabled,
    this.duration,
    required this.recordingDetails,
    this.actionViewQRcode,
    this.enrollmentLimit,
    this.availableSeats,
    this.noofUsersEnrolled,
    this.waitListLimit,
    this.waitListEnrolls,
    this.isBookingOpened = false,
    this.downloadLink,
    this.isShowEventFullStatus = false,
    this.viewType,
    this.typeofEvent,
    this.startpage,
    this.folderPath,
    this.actualStatus,
    this.jwstartpage,
    this.qrImageName,
    this.backGroundColor,
    this.fontColor,
    this.skinId,
    this.filterId,
    this.siteId,
    this.userSiteId,
    this.siteName,
    this.contentTypeId,
    this.contentId,
    this.title,
    this.totalRatings,
    this.ratingId,
    this.shortDescription,
    this.thumbnailImagePath,
    this.instanceParentContentId,
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
    this.joinUrl,
    this.categorycolor,
    this.invitationUrl,
    this.headerLocationName,
    this.subSiteUserId,
    this.presenterDisplayName,
    this.presenterWithLink,
    this.authorName,
    this.freePrice,
    this.siteUserId,
    this.scoId,
    this.buyNowLink,
    this.bit5 = false,
    this.bit4 = false,
    this.openNewBrowserWindow = false,
    this.salepricestrikeoff,
    this.sharelink,
    this.creditScoreWithCreditTypes,
    this.creditScoreFirstPrefix,
    this.mediaTypeId,
    this.googleProductID = "",
    this.itunesProductID = "",
  });

  bool isSuccess = false;
  bool noRecord = false;
  dynamic strCatalogContentRemoved;
  dynamic presentername;
  dynamic presenterLink;
  dynamic directionUrl;
  dynamic longDescription;
  dynamic errorMesage;
  dynamic addLink;
  dynamic cancelEventlink;
  dynamic enrollNowLink;
  dynamic downloadCalender;
  dynamic titleExpired;
  dynamic addPastLink;
  dynamic contentStatus;
  dynamic eventScheduleLink;
  dynamic eventScheduleStatus;
  dynamic eventScheduleConfirmLink;
  dynamic eventScheduleCancelLink;
  dynamic eventScheduleReserveTime;
  dynamic eventScheduleReserveStatus;
  dynamic reScheduleEvent;
  dynamic addorremoveattendees;
  dynamic cancelScheduleEvent;
  dynamic durationEndDate;
  dynamic showReadMore;
  dynamic setCompleteAction;
  dynamic titleName;
  dynamic titleWithlink;
  dynamic imageWithlink;
  dynamic showThumbnailImagePath;
  dynamic certificateLink;
  dynamic surveyLink;
  dynamic notesLink;
  dynamic waitListLink;
  dynamic showParentPrerequisiteEventDate;
  dynamic showPrerequisiteEventDate;
  dynamic discussionsLink;
  dynamic isContentEnrolled;
  dynamic contentViewType;
  dynamic windowProperties;
  dynamic autolaunchViewLink;
  dynamic titleViewlink;
  dynamic notifyMessage;
  dynamic learningObjectives;
  dynamic tableofContent;
  dynamic thumbnailVideoPath;
  dynamic jwVideoKey;
  bool isArchived = false;
  dynamic thumbnailIconPath;
  bool showSchedule = false;
  dynamic subTitleTag;
  dynamic eventScheduleType;
  dynamic percentCompletedClass;
  dynamic percentagecompleted;
  dynamic islearningcontent;
  bool isViewReview = false;
  dynamic eventType;
  dynamic redirectinstanceId;
  dynamic isBadCancellationEnabled;
  dynamic duration;
  RecordingDetails recordingDetails;
  dynamic actionViewQRcode;
  dynamic enrollmentLimit;
  dynamic availableSeats;
  dynamic noofUsersEnrolled;
  dynamic waitListLimit;
  dynamic waitListEnrolls;
  bool isBookingOpened = false;
  dynamic downloadLink;
  bool isShowEventFullStatus = false;
  dynamic viewType;
  dynamic typeofEvent;
  dynamic startpage;
  dynamic folderPath;
  dynamic actualStatus;
  dynamic jwstartpage;
  dynamic qrImageName;
  dynamic backGroundColor;
  dynamic fontColor;
  dynamic skinId;
  dynamic filterId;
  dynamic siteId;
  dynamic userSiteId;
  dynamic siteName;
  dynamic contentTypeId;
  dynamic contentId;
  dynamic title;
  dynamic totalRatings;
  dynamic ratingId;
  dynamic shortDescription;
  dynamic thumbnailImagePath;
  dynamic instanceParentContentId;
  dynamic imageWithLink;
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
  dynamic locationName;
  dynamic buildingName;
  dynamic joinUrl;
  dynamic categorycolor;
  dynamic invitationUrl;
  dynamic headerLocationName;
  dynamic subSiteUserId;
  dynamic presenterDisplayName;
  dynamic presenterWithLink;
  dynamic authorName;
  dynamic freePrice;
  dynamic siteUserId;
  dynamic scoId;
  dynamic buyNowLink;
  bool bit5 = false;
  bool bit4 = false;
  bool openNewBrowserWindow = false;
  dynamic salepricestrikeoff;
  dynamic sharelink;
  dynamic creditScoreWithCreditTypes;
  dynamic creditScoreFirstPrefix;
  dynamic mediaTypeId;
  String googleProductID = "", itunesProductID = "";

  factory MyLearningDetailsResponse.fromJson(Map<dynamic, dynamic> json) =>
      MyLearningDetailsResponse(
        isSuccess: json["IsSuccess"],
        noRecord: json["NoRecord"],
        strCatalogContentRemoved: json["strCatalogContentRemoved"],
        presentername: json["Presentername"],
        presenterLink: json["PresenterLink"],
        directionUrl: json["DirectionURL"],
        longDescription: json["LongDescription"],
        errorMesage: json["ErrorMesage"],
        addLink: json["AddLink"],
        cancelEventlink: json["CancelEventlink"],
        enrollNowLink: json["EnrollNowLink"],
        downloadCalender: json["DownloadCalender"],
        titleExpired: json["titleExpired"],
        addPastLink: json["AddPastLink"],
        contentStatus: json["ContentStatus"],
        eventScheduleLink: json["EventScheduleLink"],
        eventScheduleStatus: json["EventScheduleStatus"],
        eventScheduleConfirmLink: json["EventScheduleConfirmLink"],
        eventScheduleCancelLink: json["EventScheduleCancelLink"],
        eventScheduleReserveTime: json["EventScheduleReserveTime"],
        eventScheduleReserveStatus: json["EventScheduleReserveStatus"],
        reScheduleEvent: json["ReScheduleEvent"],
        addorremoveattendees: json["Addorremoveattendees"],
        cancelScheduleEvent: json["CancelScheduleEvent"],
        durationEndDate: json["DurationEndDate"],
        showReadMore: json["ShowReadMore"],
        setCompleteAction: json["SetCompleteAction"],
        titleName: json["TitleName"],
        titleWithlink: json["TitleWithlink"],
        imageWithlink: json["ImageWithlink"],
        showThumbnailImagePath: json["ShowThumbnailImagePath"],
        certificateLink: json["CertificateLink"],
        surveyLink: json["SurveyLink"],
        notesLink: json["NotesLink"],
        waitListLink: json["WaitListLink"],
        showParentPrerequisiteEventDate:
            json["ShowParentPrerequisiteEventDate"],
        showPrerequisiteEventDate: json["ShowPrerequisiteEventDate"],
        discussionsLink: json["DiscussionsLink"],
        isContentEnrolled: json["isContentEnrolled"],
        contentViewType: json["ContentViewType"],
        windowProperties: json["WindowProperties"],
        autolaunchViewLink: json["AutolaunchViewLink"],
        titleViewlink: json["TitleViewlink"],
        notifyMessage: json["NotifyMessage"],
        learningObjectives: json["LearningObjectives"],
        tableofContent: json["TableofContent"],
        thumbnailVideoPath: json["ThumbnailVideoPath"],
        jwVideoKey: json["JWVideoKey"],
        isArchived: json["IsArchived"],
        thumbnailIconPath: json["ThumbnailIconPath"],
        showSchedule: json["showSchedule"],
        subTitleTag: json["SubTitleTag"],
        eventScheduleType: json["EventScheduleType"],
        percentCompletedClass: json["PercentCompletedClass"],
        percentagecompleted: json["percentagecompleted"],
        islearningcontent: json["islearningcontent"],
        isViewReview: json["IsViewReview"],
        eventType: json["EventType"],
        redirectinstanceId: json["RedirectinstanceID"],
        isBadCancellationEnabled: json["isBadCancellationEnabled"],
        duration: json["Duration"],
        recordingDetails: RecordingDetails.fromJson(json["RecordingDetails"]),
        actionViewQRcode: json["ActionViewQRcode"],
        enrollmentLimit: json["EnrollmentLimit"],
        availableSeats: json["AvailableSeats"],
        noofUsersEnrolled: json["NoofUsersEnrolled"],
        waitListLimit: json["WaitListLimit"],
        waitListEnrolls: json["WaitListEnrolls"],
        isBookingOpened: json["isBookingOpened"],
        downloadLink: json["DownloadLink"],
        isShowEventFullStatus: json["isShowEventFullStatus"],
        viewType: json["ViewType"],
        typeofEvent: json["TypeofEvent"],
        startpage: json["startpage"],
        folderPath: json["FolderPath"],
        actualStatus: json["ActualStatus"],
        jwstartpage: json["jwstartpage"],
        qrImageName: json["QRImageName"],
        backGroundColor: json["BackGroundColor"],
        fontColor: json["FontColor"],
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
        salePrice: json["SalePrice"],
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
        freePrice: json["FreePrice"],
        siteUserId: json["SiteUserID"],
        scoId: json["ScoID"],
        buyNowLink: json["BuyNowLink"],
        bit5: json["bit5"],
        bit4: json["bit4"],
        openNewBrowserWindow: json["OpenNewBrowserWindow"],
        salepricestrikeoff: json["salepricestrikeoff"],
        sharelink: json["Sharelink"],
        creditScoreWithCreditTypes: json["CreditScoreWithCreditTypes"],
        creditScoreFirstPrefix: json["CreditScoreFirstPrefix"],
        mediaTypeId: json["MediaTypeID"],
        googleProductID: json["GoogleProductID"]?.toString() ?? "",
        itunesProductID: json["ItunesProductID"]?.toString() ?? "",
      );

  Map<dynamic, dynamic> toJson() => {
        "IsSuccess": isSuccess,
        "NoRecord": noRecord,
        "strCatalogContentRemoved": strCatalogContentRemoved,
        "Presentername": presentername,
        "PresenterLink": presenterLink,
        "DirectionURL": directionUrl,
        "LongDescription": longDescription,
        "ErrorMesage": errorMesage,
        "AddLink": addLink,
        "CancelEventlink": cancelEventlink,
        "EnrollNowLink": enrollNowLink,
        "DownloadCalender": downloadCalender,
        "titleExpired": titleExpired,
        "AddPastLink": addPastLink,
        "ContentStatus": contentStatus,
        "EventScheduleLink": eventScheduleLink,
        "EventScheduleStatus": eventScheduleStatus,
        "EventScheduleConfirmLink": eventScheduleConfirmLink,
        "EventScheduleCancelLink": eventScheduleCancelLink,
        "EventScheduleReserveTime": eventScheduleReserveTime,
        "EventScheduleReserveStatus": eventScheduleReserveStatus,
        "ReScheduleEvent": reScheduleEvent,
        "Addorremoveattendees": addorremoveattendees,
        "CancelScheduleEvent": cancelScheduleEvent,
        "DurationEndDate": durationEndDate,
        "ShowReadMore": showReadMore,
        "SetCompleteAction": setCompleteAction,
        "TitleName": titleName,
        "TitleWithlink": titleWithlink,
        "ImageWithlink": imageWithlink,
        "ShowThumbnailImagePath": showThumbnailImagePath,
        "CertificateLink": certificateLink,
        "SurveyLink": surveyLink,
        "NotesLink": notesLink,
        "WaitListLink": waitListLink,
        "ShowParentPrerequisiteEventDate": showParentPrerequisiteEventDate,
        "ShowPrerequisiteEventDate": showPrerequisiteEventDate,
        "DiscussionsLink": discussionsLink,
        "isContentEnrolled": isContentEnrolled,
        "ContentViewType": contentViewType,
        "WindowProperties": windowProperties,
        "AutolaunchViewLink": autolaunchViewLink,
        "TitleViewlink": titleViewlink,
        "NotifyMessage": notifyMessage,
        "LearningObjectives": learningObjectives,
        "TableofContent": tableofContent,
        "ThumbnailVideoPath": thumbnailVideoPath,
        "JWVideoKey": jwVideoKey,
        "IsArchived": isArchived,
        "ThumbnailIconPath": thumbnailIconPath,
        "showSchedule": showSchedule,
        "SubTitleTag": subTitleTag,
        "EventScheduleType": eventScheduleType,
        "PercentCompletedClass": percentCompletedClass,
        "percentagecompleted": percentagecompleted,
        "islearningcontent": islearningcontent,
        "IsViewReview": isViewReview,
        "EventType": eventType,
        "RedirectinstanceID": redirectinstanceId,
        "isBadCancellationEnabled": isBadCancellationEnabled,
        "Duration": duration,
        "RecordingDetails": recordingDetails.toJson(),
        "ActionViewQRcode": actionViewQRcode,
        "EnrollmentLimit": enrollmentLimit,
        "AvailableSeats": availableSeats,
        "NoofUsersEnrolled": noofUsersEnrolled,
        "WaitListLimit": waitListLimit,
        "WaitListEnrolls": waitListEnrolls,
        "isBookingOpened": isBookingOpened,
        "DownloadLink": downloadLink,
        "isShowEventFullStatus": isShowEventFullStatus,
        "ViewType": viewType,
        "TypeofEvent": typeofEvent,
        "startpage": startpage,
        "FolderPath": folderPath,
        "ActualStatus": actualStatus,
        "jwstartpage": jwstartpage,
        "QRImageName": qrImageName,
        "BackGroundColor": backGroundColor,
        "FontColor": fontColor,
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
        "SalePrice": salePrice,
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
        "salepricestrikeoff": salepricestrikeoff,
        "Sharelink": sharelink,
        "CreditScoreWithCreditTypes": creditScoreWithCreditTypes,
        "CreditScoreFirstPrefix": creditScoreFirstPrefix,
        "MediaTypeID": mediaTypeId,
      };
}

class RecordingDetails {
  RecordingDetails({
    this.eventRecording = false,
    this.eventRecordingMessage,
    this.eventRecordingUrl,
    this.eventRecordingContentId,
    this.eventRecordStatus,
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
    this.eventScoid,
    this.contentProgress,
    this.percentCompletedClass,
    this.eventId,
    this.language,
    this.cloudMediaPlayerKey,
  });

  bool eventRecording = false;
  dynamic eventRecordingMessage;
  dynamic eventRecordingUrl;
  dynamic eventRecordingContentId;
  dynamic eventRecordStatus;
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
  dynamic eventScoid;
  dynamic contentProgress;
  dynamic percentCompletedClass;
  dynamic eventId;
  dynamic language;
  dynamic cloudMediaPlayerKey;

  factory RecordingDetails.fromJson(Map<dynamic, dynamic> json) =>
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

  Map<dynamic, dynamic> toJson() => {
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
