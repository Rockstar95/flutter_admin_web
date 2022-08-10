import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';

abstract class CatalogEVent {
  const CatalogEVent();
}

class SetCatalogSideMenuEvent extends CatalogEVent {
  List<NativeMenuModel> listNativeModel;

  SetCatalogSideMenuEvent(this.listNativeModel);

  @override
  List<Object> get props => [listNativeModel];
}

class GetCategoryForBrowseEvent extends CatalogEVent {
  GetCategoryForBrowseEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryWisecatalogEvent extends CatalogEVent {
  int pageIndex;
  int categaoryID;
  String serachString;
  String sortBy;
  MyLearningBloc myLearningBloc;

  GetCategoryWisecatalogEvent(
      {this.pageIndex = 0,
      this.categaoryID = 0,
      this.serachString = "",
      this.sortBy = "",
      required this.myLearningBloc});

  @override
  List<Object> get props =>
      [pageIndex, categaoryID, serachString, myLearningBloc, sortBy];
}

class GetWishListCatalogEvent extends CatalogEVent {
  int pageIndex;
  int categaoryID;
  String type;
  int compid;
  int compinsid;

  GetWishListCatalogEvent(
      {this.pageIndex = 0,
      this.categaoryID = 0,
      this.type = "",
      this.compid = 0,
      this.compinsid = 0});

  @override
  List<Object> get props => [pageIndex, categaoryID, type];
}

class AddToMyLearningEvent extends CatalogEVent {
  String contentId;
  DummyMyCatelogResponseTable2 table2;

  AddToMyLearningEvent({this.contentId = "", required this.table2});

  @override
  List<Object> get props => [contentId, table2];
}

class AddToWishListEvent extends CatalogEVent {
  String contentId;

  AddToWishListEvent({this.contentId = ""});

  @override
  List<Object> get props => [contentId];
}

class SaveInAppPurchaseEvent extends CatalogEVent {
  String userId;
  String siteURl;
  String contentID;
  String orderId;
  String purchaseToken;
  String productId;
  String purchaseTime;
  String deviceType;

  SaveInAppPurchaseEvent({
    this.userId = "",
    this.siteURl = "",
    this.contentID = "",
    this.orderId = "",
    this.purchaseToken = "",
    this.productId = "",
    this.purchaseTime = "",
    this.deviceType = "",
  });

  @override
  List<Object> get props => [
        userId,
        siteURl,
        contentID,
        orderId,
        purchaseToken,
        productId,
        purchaseTime,
        deviceType
      ];
}

class RemoveFromWishListEvent extends CatalogEVent {
  String contentId;

  RemoveFromWishListEvent({this.contentId = ""});

  @override
  List<Object> get props => [contentId];
}

class GetSubcategoryCatalogEvent extends CatalogEVent {
  int categaoryID;
  String categaoryName;

  GetSubcategoryCatalogEvent({this.categaoryID = 0, this.categaoryName = ""});

  @override
  List<Object> get props => [categaoryID, categaoryName];
}

class LoginSubsiteEvent extends CatalogEVent {
  DummyMyCatelogResponseTable2 table2;
  String email;
  String password;
  String subSiteId;
  String subSiteUrl;
  LocalStr localStr;

  LoginSubsiteEvent(
      {required this.table2,
      this.email = "",
      this.password = "",
      required this.localStr,
      this.subSiteId = "",
      this.subSiteUrl = ""});

  @override
  List<Object> get props =>
      [table2, email, password, localStr, subSiteId, subSiteUrl];
}

// https://flutterapi.instancy.com/api/SiteSettings/GetFileUploadControls?SiteId=374&LocaleId=en-us&compInsId=50044

class GetFileUploadControlsEvent extends CatalogEVent {
  String siteId;
  String localeId;
  String compInsId;

  GetFileUploadControlsEvent({
    this.siteId = "",
    this.localeId = "",
    this.compInsId = '',
  });

  @override
  List<Object> get props => [siteId, localeId, compInsId];
}

class GetScheduleEvent extends CatalogEVent {
  String eventID;
  String multiInstanceEventEnroll;
  String multiLocation;

  GetScheduleEvent({
    this.eventID = "",
    this.multiInstanceEventEnroll = "",
    this.multiLocation = "",
  });

  @override
  List<Object> get props => [eventID, multiInstanceEventEnroll, multiLocation];
}

class AddEnrollEvent extends CatalogEVent {
  String selectedContent;
  int componentID;
  int componentInsID;
  String additionalParams;
  String targetDate;
  String rescheduleenroll;

  AddEnrollEvent(
      {this.selectedContent = "",
      this.componentID = 0,
      this.componentInsID = 0,
      this.additionalParams = "",
      this.targetDate = "",
      this.rescheduleenroll = ""});

  @override
  List<Object> get props => [
        selectedContent,
        componentID,
        componentInsID,
        additionalParams,
        targetDate,
        rescheduleenroll
      ];
}

class GetPrequisiteDetailsEvent extends CatalogEVent {
  String contentId;
  String userID;

  GetPrequisiteDetailsEvent({this.contentId = "", this.userID = ""});

  @override
  List<Object> get props => [contentId, userID];
}

class GetAssociatedContentEvent extends CatalogEVent {
  String contentID;
  String userID;
  String componentID;
  String componentInstanceID;
  String siteID;
  String instancedata;
  String preRequisiteSequncePathID;
  String locale;
  LocalStr localStr;

  GetAssociatedContentEvent(
      {this.contentID = "",
      this.userID = "",
      this.componentID = "",
      this.componentInstanceID = "",
      this.siteID = "",
      this.instancedata = "",
      this.preRequisiteSequncePathID = "",
      this.locale = "",
      required this.localStr});

  @override
  List<Object> get props => [
        contentID,
        userID,
        componentID,
        componentInstanceID,
        siteID,
        instancedata,
        preRequisiteSequncePathID,
        locale,
        localStr
      ];
}

class GetCatalogDetails extends CatalogEVent {
  MyLearningDetailsRequest myLearningDetailsRequest;

  GetCatalogDetails({required this.myLearningDetailsRequest});

  @override
  List<Object> get props => [myLearningDetailsRequest];
}

class AssociatesAddToMyLearning extends CatalogEVent {
  String selectedContent;
  String orgUnitID;
  String componentID;
  String componentInsID;
  String additionalParams;
  String addLearnerPreRequisiteContent;
  String addMultiinstanceswithprice;
  String addWaitlistContentIDs;
  String multiInstanceEventEnroll;

  AssociatesAddToMyLearning(
      {this.selectedContent = "",
      this.orgUnitID = "",
      this.componentID = "",
      this.componentInsID = "",
      this.additionalParams = "",
      this.addLearnerPreRequisiteContent = "",
      this.addMultiinstanceswithprice = "",
      this.addWaitlistContentIDs = "",
      this.multiInstanceEventEnroll = ""});

  @override
  List<Object> get props => [
        selectedContent,
        orgUnitID,
        componentID,
        additionalParams,
        addLearnerPreRequisiteContent,
        addMultiinstanceswithprice,
        addWaitlistContentIDs,
        multiInstanceEventEnroll
      ];
}
