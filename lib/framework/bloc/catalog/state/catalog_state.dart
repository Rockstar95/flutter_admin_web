import 'package:flutter_admin_web/framework/bloc/catalog/model/add_enroll_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/associatedcontentresponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/catalog_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/display_catlog_list.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/event_enrollment_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/file_upload_controls.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/getCategoryForBrowseResponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/prequisitepopupresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class CatalogState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  CatalogState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  CatalogState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  CatalogState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class IntitialCatalogStateState extends CatalogState {
  IntitialCatalogStateState.completed(data) : super.completed(data);
}

class GetCategoryForBrowseState extends CatalogState {
  List<DisplayCatalogData> list = [];

  GetCategoryForBrowseState.loading(data) : super.loading(data);

  GetCategoryForBrowseState.completed({required this.list})
      : super.completed(list);

  GetCategoryForBrowseState.error(data) : super.error(data);
}

class GetCategoryWisecatalogState extends CatalogState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetCategoryWisecatalogState.loading(data) : super.loading(data);

  GetCategoryWisecatalogState.completed({required this.list})
      : super.completed(list);

  GetCategoryWisecatalogState.error(data) : super.error(data);
}

class GetWishListCatalogState extends CatalogState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetWishListCatalogState.loading(data) : super.loading(data);

  GetWishListCatalogState.completed({required this.list})
      : super.completed(list);

  GetWishListCatalogState.error(data) : super.error(data);
}

class AddToMyLearningState extends CatalogState {
  bool isScusses = false;
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  AddToMyLearningState.loading(data) : super.loading(data);

  AddToMyLearningState.completed({this.isScusses = false, required this.table2})
      : super.completed(isScusses);

  AddToMyLearningState.error(data) : super.error(data);
}

class AddToWishListState extends CatalogState {
  bool isScusses = false;
  String contentId = "";

  AddToWishListState.loading(data) : super.loading(data);

  AddToWishListState.completed({this.isScusses = false, this.contentId = ""})
      : super.completed(isScusses);

  AddToWishListState.error(data) : super.error(data);
}

class SaveInAppPurchaseState extends CatalogState {
  String response = "";

  SaveInAppPurchaseState.loading(data) : super.loading(data);

  SaveInAppPurchaseState.completed({this.response = ""})
      : super.completed(response);

  SaveInAppPurchaseState.error(data) : super.error(data);
}

class RemoveFromWishListState extends CatalogState {
  bool isScusses = false;

  RemoveFromWishListState.loading(data) : super.loading(data);

  RemoveFromWishListState.completed({this.isScusses = false})
      : super.completed(isScusses);

  RemoveFromWishListState.error(data) : super.error(data);
}

class GetSubcategoryCatalogState extends CatalogState {
  List<GetCategoryForBrowseResponse> subCategoryCatalogList = [];

  GetSubcategoryCatalogState.loading(data) : super.loading(data);

  GetSubcategoryCatalogState.completed({required this.subCategoryCatalogList})
      : super.completed(subCategoryCatalogList);

  GetSubcategoryCatalogState.error(data) : super.error(data);
}

class SubSignInState extends CatalogState {
  String response = "";
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  SubSignInState.loading(data) : super.loading(data);

  SubSignInState.completed({this.response = "", required this.table2})
      : super.completed(response);

  SubSignInState.error(data) : super.error(data);
}

class GetFileUploadControlsState extends CatalogState {
  List<FileUploadControls> fileUploadControlslist = [];

  GetFileUploadControlsState.loading(data) : super.loading(data);

  GetFileUploadControlsState.completed({required this.fileUploadControlslist})
      : super.completed(fileUploadControlslist);

  GetFileUploadControlsState.error(data) : super.error(data);
}

class GetScheduleDataState extends CatalogState {
  EventEnrollmentResponse eventEnrollmentResponse = EventEnrollmentResponse();

  GetScheduleDataState.loading(data) : super.loading(data);

  GetScheduleDataState.completed({required this.eventEnrollmentResponse})
      : super.completed(eventEnrollmentResponse);

  GetScheduleDataState.error(data) : super.error(data);
}

class AddEnrollState extends CatalogState {
  AddEnrollResponse? addEnrollResponse;

  AddEnrollState.loading(data) : super.loading(data);

  AddEnrollState.completed({this.addEnrollResponse})
      : super.completed(addEnrollResponse);

  AddEnrollState.error(data) : super.error(data);
}

class GetPrequisiteDetailsState extends CatalogState {
  bool isSuccess = false;
  String contentId = "";
  PrequisitePopupresponse prequisitePopupresponse =
      PrequisitePopupresponse.fromJson({});

  GetPrequisiteDetailsState.loading(data) : super.loading(data);

  GetPrequisiteDetailsState.completed(
      {this.isSuccess = false, required this.prequisitePopupresponse, this.contentId = ""})
      : super.completed(prequisitePopupresponse);

  GetPrequisiteDetailsState.error(data) : super.error(data);
}

class GetAssociatedContentState extends CatalogState {
  bool isSuccess = false;
  AssociatedContentResponse? associatedContentResponse;

  GetAssociatedContentState.loading(data) : super.loading(data);

  GetAssociatedContentState.completed(
      {this.isSuccess = false, this.associatedContentResponse})
      : super.completed(associatedContentResponse);

  GetAssociatedContentState.error(data) : super.error(data);
}

class GetCatalogDetailsState extends CatalogState {
  CatalogDetailsResponse data =
      CatalogDetailsResponse(recordingDetails: RecordingDetails());

  GetCatalogDetailsState.loading(data) : super.loading(data);

  GetCatalogDetailsState.completed({required this.data})
      : super.completed(data);

  GetCatalogDetailsState.error(data) : super.error(data);
}

class AssociatedAddToMyLearning extends CatalogState {
  String data = "";

  AssociatedAddToMyLearning.loading(data) : super.loading(data);

  AssociatedAddToMyLearning.completed({this.data = ""}) : super.completed(data);

  AssociatedAddToMyLearning.error(data) : super.error(data);
}
