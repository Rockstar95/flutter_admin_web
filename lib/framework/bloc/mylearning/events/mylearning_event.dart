import 'dart:core';

import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';

abstract class MyLearningEVent {
  const MyLearningEVent();
}

class GetListEvent extends MyLearningEVent {
  final bool isRefresh;
  final int pageNumber;
  final int pageSize;
  final String searchText;
  final String contentID;
  final String contentStatus;

  GetListEvent({
    this.isRefresh = false,
    this.pageNumber = 0,
    this.pageSize = 0,
    this.searchText = "",
    this.contentID = "",
    this.contentStatus = "",
  });

  @override
  List<Object> get props => [pageNumber, pageSize, contentID];
}

class GetMyLearnPlusLearningObjectsEvent extends MyLearningEVent {
  final int pageNumber;
  final int pageSize;
  final String searchText;
  final String contentID;
  final String contentStatus;
  final String type;
  final String objectTypeId;
  final String componentId;
  final String componentInsId;
  final int isWishlistCount;
  final bool isWait;
  final String dateFilter;

  GetMyLearnPlusLearningObjectsEvent({
    this.pageNumber = 0,
    this.pageSize = 0,
    this.searchText = "",
    this.contentID = "",
    this.contentStatus = "",
    this.type = "",
    this.objectTypeId = "",
    this.componentId = "",
    this.componentInsId = "",
    this.isWishlistCount = 0,
    this.isWait = false,
    this.dateFilter = "",
  });

  @override
  List<Object> get props => [
        pageNumber,
        pageSize,
        contentID,
        contentStatus,
        type,
        objectTypeId,
        componentId,
        componentInsId,
        isWishlistCount,
        isWait,
        dateFilter
      ];
}

class GetArchiveListEvent extends MyLearningEVent {
  final int pageNumber;
  final int pageSize;
  final String searchText;

  GetArchiveListEvent(
      {this.pageNumber = 0, this.pageSize = 0, this.searchText = ""});

  @override
  List<Object> get props => [pageNumber, pageSize, searchText];
}

class GetMenuComponentsEvent extends MyLearningEVent {
  final int menuid;
  final String menuUrl;
  final int roleId;

  GetMenuComponentsEvent({this.menuid = 0, this.menuUrl = "", this.roleId = 0});

  @override
  List<Object> get props => [menuid, menuUrl, roleId];
}

class GetWaitListEvent extends MyLearningEVent {
  final int pageNumber;
  final int pageSize;

  GetWaitListEvent({this.pageNumber = 0, this.pageSize = 0});

  @override
  List<Object> get props => [pageNumber, pageSize];
}

class GetWishListEvent extends MyLearningEVent {
  final int pageNumber;
  final int pageSize;

  GetWishListEvent({this.pageNumber = 0, this.pageSize = 0});

  @override
  List<Object> get props => [pageNumber, pageSize];
}

class GetFilterMenus extends MyLearningEVent {
  final LocalStr localStr;
  final List<NativeMenuModel> listNativeModel;
  final String moduleName;

  GetFilterMenus(
      {required this.listNativeModel,
      required this.localStr,
      this.moduleName = ""});

  @override
  List<Object> get props => [listNativeModel, localStr, moduleName];
}

class GetSortMenus extends MyLearningEVent {
  final String componentID;

  GetSortMenus(this.componentID);

  @override
  List<Object> get props => [componentID];
}

class AddToArchiveCall extends MyLearningEVent {
  final bool isArchive;
  final String strContentID;
  final DummyMyCatelogResponseTable2 table2;

  AddToArchiveCall({this.isArchive = false, this.strContentID = "", required this.table2});

  @override
  List<Object> get props => [isArchive, strContentID];
}

class RemoveToArchiveCall extends MyLearningEVent {
  final bool isArchive;
  final String strContentID;
  final DummyMyCatelogResponseTable2 table2;

  RemoveToArchiveCall({this.isArchive = false, this.strContentID = "", required this.table2});

  @override
  List<Object> get props => [isArchive, strContentID];
}

class CancelEnrollment extends MyLearningEVent {
  bool isBadCancel = false;
  String strContentID = "";
  DummyMyCatelogResponseTable2? table2;

  CancelEnrollment({this.isBadCancel = false, this.strContentID = ""});

  @override
  List<Object> get props => [isBadCancel, strContentID];
}

class GetCategoriesTreeEvent extends MyLearningEVent {
  String categoryID = "";
  String componentId = "";

  GetCategoriesTreeEvent({this.categoryID = "",this.componentId = ""});

  @override
  List<Object> get props => [categoryID];
}

class GetLearningtreeEvent extends MyLearningEVent {
  @override
  List<Object> get props => [];
}

class SelectCategoriesEvent extends MyLearningEVent {
  String seletedCategoryID = "";
  String mainCategory = "";
  String categoryDisplayName = "";

  SelectCategoriesEvent(
      {this.seletedCategoryID = "",
      this.mainCategory = "",
      this.categoryDisplayName = ""});

  @override
  List<Object> get props => [seletedCategoryID, mainCategory];
}

class GetFilterDurationEvent extends MyLearningEVent {
  GetFilterDurationEvent();

  @override
  List<Object> get props => [];
}

class GetFilterIntructorListEvent extends MyLearningEVent {
  GetFilterIntructorListEvent();

  @override
  List<Object> get props => [];
}

class RemoveFromMyLearning extends MyLearningEVent {
  String contentId = "";

  RemoveFromMyLearning({this.contentId = ""});

  @override
  List<Object> get props => [contentId];
}

class GetProgresReportEvent extends MyLearningEVent {
  String objectTypeID = "";
  String contentID = "";
  String trackID = "";
  String postion = "";

  GetProgresReportEvent(
      {this.objectTypeID = "",
      this.contentID = "",
      this.trackID = "",
      this.postion = ""});

  @override
  List<Object> get props => [objectTypeID, contentID];
}

class ResetFilterEvent extends MyLearningEVent {
  ResetFilterEvent();

  @override
  List<Object> get props => [];
}

class ApplyFilterEvent extends MyLearningEVent {
  ApplyFilterEvent();

  @override
  List<Object> get props => [];
}

class CourseTrackingEvent extends MyLearningEVent {
  String userID = "";
  String scoId = "";
  String objecttypeId = "";
  String contentID = "";
  String siteIDValue = "";
  String courseUrl = "";
  DummyMyCatelogResponseTable2 table2;

  CourseTrackingEvent(
      {required this.table2,
      this.userID = "",
      this.scoId = "",
      this.objecttypeId = "",
      this.contentID = "",
      this.siteIDValue = "",
      this.courseUrl = ""});

  @override
  List<Object> get props => [
        userID,
        scoId,
        objecttypeId,
        contentID,
        siteIDValue,
        table2,
        courseUrl,
      ];
}

class TokenFromSessionIdEvent extends MyLearningEVent {
  String courseURL = "";
  String courseName = "";
  String contentID = "";
  String objecttypeId = "";
  String learnerSCOID = "";
  String learnerSessionID = "";
  String userID = "";
  DummyMyCatelogResponseTable2 table2;

  TokenFromSessionIdEvent(
      {required this.table2,
      this.courseURL = "",
      this.courseName = "",
      this.contentID = "",
      this.objecttypeId = "",
      this.learnerSCOID = "",
      this.learnerSessionID = "",
      this.userID = ""});

  @override
  List<Object> get props => [
        table2,
        courseURL,
        courseName,
        contentID,
        objecttypeId,
        learnerSCOID,
        learnerSessionID,
        userID
      ];
}

class UpdateCompleteStatusEvent extends MyLearningEVent {
  String contentID = "";
  String userID = "";
  String scoID = "";

  UpdateCompleteStatusEvent(
      {this.contentID = "", this.userID = "", this.scoID = ""});

  @override
  List<Object> get props => [contentID, userID, scoID];
}

//sreekanth commented my learning plus

class GetUserAchievementDataPlusEvent extends MyLearningEVent {
  String userID = "";
  String siteID = "";
  String locale;
  String componentID = "";
  String componentInsID = "";
  String gameID = "";

  GetUserAchievementDataPlusEvent(
      {this.userID = "",
      this.siteID = "",
      this.locale = "",
      this.componentID = "",
      this.componentInsID = "",
      this.gameID = ""});

  @override
  List<Object> get props => [];
}

class GetLeaderboardLearnPlusEvent extends MyLearningEVent {
  String userID = "";
  String siteID = "";
  String locale = "";
  String componentID = "";
  String componentInsID = "";
  String gameID = "";

  GetLeaderboardLearnPlusEvent(
      {this.userID = "",
      this.siteID = "",
      this.locale = "",
      this.componentID = "",
      this.componentInsID = "",
      this.gameID = ""});

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class GetDynamicTabsPlusEvent extends MyLearningEVent {
  String componentid = "";
  String componentinsid = "";

  GetDynamicTabsPlusEvent({this.componentid = "", this.componentinsid = ""});

  @override
  List<Object> get props => [this.componentid, this.componentinsid];
}

class GetGamelistLearnPlusEvent extends MyLearningEVent {
  bool fromAchievement = false;
  String userID = "";
  String siteID = "";
  String locale = "";
  String componentID = "";
  String componentInsID = "";
  String leaderByGroup = "";
  String gameID = "";

  GetGamelistLearnPlusEvent(
      {this.fromAchievement = false,
      this.userID = "",
      this.siteID = "",
      this.locale = "",
      this.componentID = "",
      this.componentInsID = "",
      this.leaderByGroup = "",
      this.gameID = ""});

  @override
  List<Object> get props => [];
}

class GetEventResourceCalEvent extends MyLearningEVent {
  String componentid = "";
  String componentinsid = "";
  String objecttypes = "";
  String multiLocation = "";
  String startdate = "";
  String enddate = "";
  String eventid = "";

  GetEventResourceCalEvent(
      {this.componentid = "",
      this.componentinsid = "",
      this.objecttypes = "",
      this.multiLocation = "",
      this.startdate = "",
      this.enddate = "",
      this.eventid = ""});

  @override
  List<Object> get props => [];
}

class GetWishListPlusEvent extends MyLearningEVent {
  int pageIndex = 0;
  int categaoryID = 0;
  String type = "";
  int compid = 0;
  int compinsid = 0;
  String parameterString = "";

  GetWishListPlusEvent(
      {this.pageIndex = 0,
      this.categaoryID = 0,
      this.type = "",
      this.compid = 0,
      this.compinsid = 0,this.parameterString = ""});

  @override
  List<Object> get props => [pageIndex, categaoryID, type];
}

// class getMyLearnPlusLearningObjectsDashdayEvent extends MyLearningEVent{
  
// }

// String urlStr = appUserModel.getWebAPIUrl() + "CourseTracking/webAPIInitialiseTracking?userId=" + learningModel.getUserID() + "&scoId=" + learningModel.getScoId() + "&objectTypeID=" + learningModel.getObjecttypeId() + "&disbaleAdminViewTracking=false&contented=" + learningModel.getContentID() + "&siteid=" + appUserModel.getSiteIDValue();
