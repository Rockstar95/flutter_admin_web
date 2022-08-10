// To parse this JSON data, do
//
//     ResBlockTrack ResBlockTrack = resBlockTrackFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_admin_web/framework/helpers/parsing_helper.dart';

TrackListViewModel trackListViewModelFromJson(String str) => TrackListViewModel.fromJson(json.decode(str));

String trackListViewModelToJson(TrackListViewModel data) => json.encode(data.toJson());

class TrackListViewModel {
  List<TrackListViewWorkFlowRulesModel> workflowData = [];
  List<TrackListViewTrackDataModel> tracklistData = [];
  List<TrackListViewBookMarkModel> bookMarkData = [];
  bool showHideViewResume = false;

  TrackListViewModel.fromJson(Map<String, dynamic> json) {
    workflowData = [];
    List<Map> tracklistWorkflowMapsList = ParsingHelper.parseListMethod<dynamic, Map>(json['WorkflowData']);
    tracklistWorkflowMapsList.forEach((element) {
      Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(element);
      if(map.isNotEmpty) {
        workflowData.add(TrackListViewWorkFlowRulesModel.fromMap(map));
      }
    });

    tracklistData = [];
    List<Map> tracklistDataMapsList = ParsingHelper.parseListMethod<dynamic, Map>(json['tracklistData']);
    tracklistDataMapsList.forEach((element) {
      Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(element);
      if(map.isNotEmpty) {
        tracklistData.add(TrackListViewTrackDataModel.fromMap(map));
      }
    });

    bookMarkData = [];
    List<Map> tracklistBookmarkMapsList = ParsingHelper.parseListMethod<dynamic, Map>(json['BookMarkData']);
    tracklistBookmarkMapsList.forEach((element) {
      Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(element);
      if(map.isNotEmpty) {
        bookMarkData.add(TrackListViewBookMarkModel.fromMap(map));
      }
    });

    showHideViewResume = ParsingHelper.parseBoolMethod(json['ShowHideViewResume']);
  }

  Map<String, dynamic> toJson() {
   return {
     "tracklistData" : tracklistData.map((e) => e.toMap()).toList(),
     "ShowHideViewResume" : showHideViewResume,
   };
  }
}

class TrackListViewWorkFlowRulesModel {
  String USerID = "", TrackID = "", TrackObjectID = "", result = "", wmessage = "", RuleID = "", StepID = "";

  TrackListViewWorkFlowRulesModel.fromMap(Map<String, dynamic> map) {
    USerID = ParsingHelper.parseStringMethod(map['USerID']);
    TrackID = ParsingHelper.parseStringMethod(map['TrackID']);
    TrackObjectID = ParsingHelper.parseStringMethod(map['TrackObjectID']);
    result = ParsingHelper.parseStringMethod(map['result']);
    wmessage = ParsingHelper.parseStringMethod(map['wmessage']);
    RuleID = ParsingHelper.parseStringMethod(map['RuleID']);
    StepID = ParsingHelper.parseStringMethod(map['StepID']);
  }

  Map<String, dynamic> toMap() {
    return {
    "USerID" : USerID,
    "TrackID" : TrackID,
    "TrackObjectID" : TrackObjectID,
    "result" : result,
    "wmessage" : wmessage,
    "RuleID" : RuleID,
    "StepID" : StepID,
    };
  }
}

class TrackListViewTrackDataModel {
  String blockID = "", blockname = "", timeSpentType = "";
  int courseCount = 0, timeToBeSpent = 0, timeSpent = 0, timeSpentHours = 0;
  List<TrackListModel> trackList = [];

  TrackListViewTrackDataModel.fromMap(Map<String, dynamic> map) {
    blockID = ParsingHelper.parseStringMethod(map['blockID']);
    blockname = ParsingHelper.parseStringMethod(map['blockname']);
    timeSpentType = ParsingHelper.parseStringMethod(map['TimeSpentType']);
    courseCount = ParsingHelper.parseIntMethod(map['CourseCount']);
    timeToBeSpent = ParsingHelper.parseIntMethod(map['TimeToBeSpent']);
    timeSpent = ParsingHelper.parseIntMethod(map['TimeSpent']);
    timeSpentHours = ParsingHelper.parseIntMethod(map['timeSpentHours']);

    trackList = [];
    List<Map> TrackListMapsList = ParsingHelper.parseListMethod<dynamic, Map>(map['TrackList']);
    TrackListMapsList.forEach((element) {
      Map<String, dynamic> trackmap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(element);
      if(trackmap.isNotEmpty) {
        trackList.add(TrackListModel.fromMap(trackmap));
      }
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "blockID" : blockID,
      "blockname" : blockname,
      "TimeSpentType" : timeSpentType,
      "CourseCount" : courseCount,
      "TimeToBeSpent" : timeToBeSpent,
      "TimeSpent" : timeSpent,
      "timeSpentHours" : timeSpentHours,
      "TrackList" : trackList.map((e) => e.toMap()).toList(),
    };
  }
}

class TrackListModel {
  String contentID = "", titlewithlink = "", rcaction = "", categories = "", membershipName = "", previewLink = "", approveLink = "",
      rejectLink = "", readLink = "", addLink = "", enrollNowLink = "", cancelEventLink = "", waitListLink = "", inapppurchageLink = "",
      alredyinmylearnigLink = "", recommendedLink = "", sharelink = "", editMetadataLink = "", replaceLink = "", editLink = "",
      deleteLink = "", sampleContentLink = "", titleExpired = "", practiceAssessmentsAction = "", createAssessmentAction = "",
      overallProgressReportAction = "", contentName = "", percentCompletedClass = "", contentStatus = "", contentType = "",
      shortDescription = "", title = '', authorDisplayName = "", thumbnailImagePath = "", viewLink = "", windowProperties = "",
      timezone = "", viewType = "", firstObjectViewLink = "", firstlaunchContentID = "", firstlaunchContentName = "",
      setCompleteAction = "", jWVideoKey = "", thumbnailIconPath = "", instanceEventEnroll = "", reEnrollmentHistory = "",
      instanceEventReclass = "", instanceEventReclassStatus = "", detailsLink = "", wstatus = "", wmessage = "", timeSpentType = "",
      eventStartDateTime = "", eventEndDateTime = "", presenterName = "", coreLessonStatus = "", recordingDetails = "", pAOrDAReporLink = "",
      actionViewQRcode = "", instanceEventReSchedule = "", downloadLink = "", mediaColor = "", mediaFontColor = "", relatedContentLink = "",
      expiredContentAvailableUntill = "", expiredContentExpiryDate = "", reportLink = "", prevCourseName = "";
  int eventAvailableSeats = 0, count = 0, contentScoID = 0, ratingID = 0, scoID = 0, contentTypeId = 0, firstlaunchScoID = 0,
      firstlaunchContentTypeId = 0, sequenceID	 = 0, timeToBeSpent = 0, timeSpent = 0, eventScheduleType = 0, eventType = 0,
      mediaTypeID = 0, duration = 0, timeSpentHours = 0, skinID = 0;
  double eventCompletedProgress = 0, eventContentProgress = 0, totalRatings = 0, contentProgress = 0;
  bool isSubSite = false, isContentEnrolled = false, allowedNavigation = false, isEnrollFutureInstance = false, shareContentwithUser = false,
      bit1 = false;

  TrackListModel.fromMap(Map<String, dynamic> map) {
    contentID = ParsingHelper.parseStringMethod(map['ContentID']);
    titlewithlink = ParsingHelper.parseStringMethod(map['Titlewithlink']);
    rcaction = ParsingHelper.parseStringMethod(map['rcaction']);
    categories = ParsingHelper.parseStringMethod(map['Categories']);
    membershipName = ParsingHelper.parseStringMethod(map['MembershipName']);
    previewLink = ParsingHelper.parseStringMethod(map['PreviewLink']);
    approveLink = ParsingHelper.parseStringMethod(map['ApproveLink']);
    rejectLink = ParsingHelper.parseStringMethod(map['RejectLink']);
    readLink = ParsingHelper.parseStringMethod(map['ReadLink']);
    addLink = ParsingHelper.parseStringMethod(map['AddLink']);
    enrollNowLink = ParsingHelper.parseStringMethod(map['EnrollNowLink']);
    cancelEventLink = ParsingHelper.parseStringMethod(map['CancelEventLink']);
    waitListLink = ParsingHelper.parseStringMethod(map['WaitListLink']);
    inapppurchageLink = ParsingHelper.parseStringMethod(map['InapppurchageLink']);
    alredyinmylearnigLink = ParsingHelper.parseStringMethod(map['AlredyinmylearnigLink']);
    recommendedLink = ParsingHelper.parseStringMethod(map['RecommendedLink']);
    sharelink = ParsingHelper.parseStringMethod(map['Sharelink']);
    editMetadataLink = ParsingHelper.parseStringMethod(map['EditMetadataLink']);
    replaceLink = ParsingHelper.parseStringMethod(map['ReplaceLink']);
    editLink = ParsingHelper.parseStringMethod(map['EditLink']);
    deleteLink = ParsingHelper.parseStringMethod(map['DeleteLink']);
    sampleContentLink = ParsingHelper.parseStringMethod(map['SampleContentLink']);
    titleExpired = ParsingHelper.parseStringMethod(map['TitleExpired']);
    practiceAssessmentsAction = ParsingHelper.parseStringMethod(map['PracticeAssessmentsAction']);
    createAssessmentAction = ParsingHelper.parseStringMethod(map['CreateAssessmentAction']);
    overallProgressReportAction = ParsingHelper.parseStringMethod(map['OverallProgressReportAction']);
    contentName = ParsingHelper.parseStringMethod(map['ContentName']);
    percentCompletedClass = ParsingHelper.parseStringMethod(map['PercentCompletedClass']);
    contentStatus = ParsingHelper.parseStringMethod(map['ContentStatus']);
    contentType = ParsingHelper.parseStringMethod(map['ContentType']);
    shortDescription = ParsingHelper.parseStringMethod(map['ShortDescription']);
    title = ParsingHelper.parseStringMethod(map['Title']);
    authorDisplayName = ParsingHelper.parseStringMethod(map['AuthorDisplayName']);
    thumbnailImagePath = ParsingHelper.parseStringMethod(map['ThumbnailImagePath']);
    viewLink = ParsingHelper.parseStringMethod(map['ViewLink']);
    windowProperties = ParsingHelper.parseStringMethod(map['WindowProperties']);
    timezone = ParsingHelper.parseStringMethod(map['Timezone']);
    viewType = ParsingHelper.parseStringMethod(map['ViewType']);
    firstObjectViewLink = ParsingHelper.parseStringMethod(map['firstObjectViewLink']);
    firstlaunchContentID = ParsingHelper.parseStringMethod(map['firstlaunchContentID']);
    firstlaunchContentName = ParsingHelper.parseStringMethod(map['firstlaunchContentName']);
    setCompleteAction = ParsingHelper.parseStringMethod(map['SetCompleteAction']);
    jWVideoKey = ParsingHelper.parseStringMethod(map['JWVideoKey']);
    thumbnailIconPath = ParsingHelper.parseStringMethod(map['ThumbnailIconPath']);
    instanceEventEnroll = ParsingHelper.parseStringMethod(map['InstanceEventEnroll']);
    reEnrollmentHistory = ParsingHelper.parseStringMethod(map['ReEnrollmentHistory']);
    instanceEventReclass = ParsingHelper.parseStringMethod(map['InstanceEventReclass']);
    instanceEventReclassStatus = ParsingHelper.parseStringMethod(map['InstanceEventReclassStatus']);
    detailsLink = ParsingHelper.parseStringMethod(map['DetailsLink']);
    wstatus = ParsingHelper.parseStringMethod(map['wstatus']);
    wmessage = ParsingHelper.parseStringMethod(map['wmessage']);
    timeSpentType = ParsingHelper.parseStringMethod(map['TimeSpentType']);
    eventStartDateTime = ParsingHelper.parseStringMethod(map['EventStartDateTime']);
    eventEndDateTime = ParsingHelper.parseStringMethod(map['EventEndDateTime']);
    presenterName = ParsingHelper.parseStringMethod(map['PresenterName']);
    coreLessonStatus = ParsingHelper.parseStringMethod(map['CoreLessonStatus']);
    recordingDetails = ParsingHelper.parseStringMethod(map['RecordingDetails']);
    pAOrDAReporLink = ParsingHelper.parseStringMethod(map['PAOrDAReporLink']);
    actionViewQRcode = ParsingHelper.parseStringMethod(map['ActionViewQRcode']);
    instanceEventReSchedule = ParsingHelper.parseStringMethod(map['InstanceEventReSchedule']);
    downloadLink = ParsingHelper.parseStringMethod(map['DownloadLink']);
    mediaColor = ParsingHelper.parseStringMethod(map['MediaColor']);
    mediaFontColor = ParsingHelper.parseStringMethod(map['MediaFontColor']);
    relatedContentLink = ParsingHelper.parseStringMethod(map['RelatedContentLink']);
    expiredContentAvailableUntill = ParsingHelper.parseStringMethod(map['ExpiredContentAvailableUntill']);
    expiredContentExpiryDate = ParsingHelper.parseStringMethod(map['ExpiredContentExpiryDate']);
    reportLink = ParsingHelper.parseStringMethod(map['ReportLink']);
    prevCourseName = ParsingHelper.parseStringMethod(map['prevCourseName']);
    eventAvailableSeats = ParsingHelper.parseIntMethod(map['EventAvailableSeats']);
    count = ParsingHelper.parseIntMethod(map['Count']);
    contentScoID = ParsingHelper.parseIntMethod(map['ContentScoID']);
    ratingID = ParsingHelper.parseIntMethod(map['RatingID']);
    scoID = ParsingHelper.parseIntMethod(map['ScoID']);
    contentTypeId = ParsingHelper.parseIntMethod(map['ContentTypeId']);
    firstlaunchScoID = ParsingHelper.parseIntMethod(map['firstlaunchScoID']);
    firstlaunchContentTypeId = ParsingHelper.parseIntMethod(map['firstlaunchContentTypeId']);
    sequenceID = ParsingHelper.parseIntMethod(map['SequenceID']);
    timeToBeSpent = ParsingHelper.parseIntMethod(map['TimeToBeSpent']);
    timeSpent = ParsingHelper.parseIntMethod(map['TimeSpent']);
    eventScheduleType = ParsingHelper.parseIntMethod(map['EventScheduleType']);
    eventType = ParsingHelper.parseIntMethod(map['EventType']);
    mediaTypeID = ParsingHelper.parseIntMethod(map['MediaTypeID']);
    duration = ParsingHelper.parseIntMethod(map['Duration']);
    timeSpentHours = ParsingHelper.parseIntMethod(map['timeSpentHours']);
    skinID = ParsingHelper.parseIntMethod(map['SkinID']);
    eventCompletedProgress = ParsingHelper.parseDoubleMethod(map['EventCompletedProgress']);
    eventContentProgress = ParsingHelper.parseDoubleMethod(map['EventContentProgress']);
    totalRatings = ParsingHelper.parseDoubleMethod(map['TotalRatings']);
    contentProgress = ParsingHelper.parseDoubleMethod(map['ContentProgress']);
    isSubSite = ParsingHelper.parseBoolMethod(map['IsSubSite']);
    isContentEnrolled = ParsingHelper.parseBoolMethod(map['isContentEnrolled']);
    allowedNavigation = ParsingHelper.parseBoolMethod(map['AllowedNavigation']);
    isEnrollFutureInstance = ParsingHelper.parseBoolMethod(map['isEnrollFutureInstance']);
    shareContentwithUser = ParsingHelper.parseBoolMethod(map['ShareContentwithUser']);
    bit1 = ParsingHelper.parseBoolMethod(map['bit1']);
  }

  Map<String, dynamic> toMap() {
    return {
    "ContentID" : contentID,
    "Titlewithlink" : titlewithlink,
    "rcaction" : rcaction,
    "Categories" : categories,
    "MembershipName" : membershipName,
    "PreviewLink" : previewLink,
    "ApproveLink" : approveLink,
    "RejectLink" : rejectLink,
    "ReadLink" : readLink,
    "AddLink" : addLink,
    "EnrollNowLink" : enrollNowLink,
    "CancelEventLink" : cancelEventLink,
    "WaitListLink" : waitListLink,
    "InapppurchageLink" : inapppurchageLink,
    "AlredyinmylearnigLink" : alredyinmylearnigLink,
    "RecommendedLink" : recommendedLink,
    "Sharelink" : sharelink,
    "EditMetadataLink" : editMetadataLink,
    "ReplaceLink" : replaceLink,
    "EditLink" : editLink,
    "DeleteLink" : deleteLink,
    "SampleContentLink" : sampleContentLink,
    "TitleExpired" : titleExpired,
    "PracticeAssessmentsAction" : practiceAssessmentsAction,
    "CreateAssessmentAction" : createAssessmentAction,
    "OverallProgressReportAction" : overallProgressReportAction,
    "ContentName" : contentName,
    "PercentCompletedClass" : percentCompletedClass,
    "ContentStatus" : contentStatus,
    "ContentType" : contentType,
    "ShortDescription" : shortDescription,
    "Title" : title,
    "AuthorDisplayName" : authorDisplayName,
    "ThumbnailImagePath" : thumbnailImagePath,
    "ViewLink" : viewLink,
    "WindowProperties" : windowProperties,
    "Timezone" : timezone,
    "ViewType" : viewType,
    "firstObjectViewLink" : firstObjectViewLink,
    "firstlaunchContentID" : firstlaunchContentID,
    "firstlaunchContentName" : firstlaunchContentName,
    "SetCompleteAction" : setCompleteAction,
    "JWVideoKey" : jWVideoKey,
    "ThumbnailIconPath" : thumbnailIconPath,
    "InstanceEventEnroll" : instanceEventEnroll,
    "ReEnrollmentHistory" : reEnrollmentHistory,
    "InstanceEventReclass" : instanceEventReclass,
    "InstanceEventReclassStatus" : instanceEventReclassStatus,
    "DetailsLink" : detailsLink,
    "wstatus" : wstatus,
    "wmessage" : wmessage,
    "TimeSpentType" : timeSpentType,
    "EventStartDateTime" : eventStartDateTime,
    "EventEndDateTime" : eventEndDateTime,
    "PresenterName" : presenterName,
    "CoreLessonStatus" : coreLessonStatus,
    "RecordingDetails" : recordingDetails,
    "PAOrDAReporLink" : pAOrDAReporLink,
    "ActionViewQRcode" : actionViewQRcode,
    "InstanceEventReSchedule" : instanceEventReSchedule,
    "DownloadLink" : downloadLink,
    "MediaColor" : mediaColor,
    "MediaFontColor" : mediaFontColor,
    "RelatedContentLink" : relatedContentLink,
    "ExpiredContentAvailableUntill" : expiredContentAvailableUntill,
    "ExpiredContentExpiryDate" : expiredContentExpiryDate,
    "ReportLink" : reportLink,
    "prevCourseName" : prevCourseName,
    "EventAvailableSeats" : eventAvailableSeats,
    "Count" : count,
    "ContentScoID" : contentScoID,
    "RatingID" : ratingID,
    "ScoID" : scoID,
    "ContentTypeId" : contentTypeId,
    "firstlaunchScoID" : firstlaunchScoID,
    "firstlaunchContentTypeId" : firstlaunchContentTypeId,
    "SequenceID" : sequenceID,
    "TimeToBeSpent" : timeToBeSpent,
    "TimeSpent" : timeSpent,
    "EventScheduleType" : eventScheduleType,
    "EventType" : eventType,
    "MediaTypeID" : mediaTypeID,
    "Duration" : duration,
    "timeSpentHours" : timeSpentHours,
    "SkinID" : skinID,
    "EventCompletedProgress" : eventCompletedProgress,
    "EventContentProgress" : eventContentProgress,
    "TotalRatings" : totalRatings,
    "ContentProgress" : contentProgress,
    "IsSubSite" : isSubSite,
    "isContentEnrolled" : isContentEnrolled,
    "AllowedNavigation" : allowedNavigation,
    "isEnrollFutureInstance" : isEnrollFutureInstance,
    "ShareContentwithUser" : shareContentwithUser,
    "bit1" : bit1,
    };
  }
}

class TrackListViewBookMarkModel {
  String bookMarkID = "";

  TrackListViewBookMarkModel.fromMap(Map<String, dynamic> map) {
    bookMarkID = ParsingHelper.parseStringMethod(map['BookMarkID']);
  }

  Map<String, dynamic> toMap() {
    return {
      "BookMarkID" : bookMarkID,
    };
  }
}
