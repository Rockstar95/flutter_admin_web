import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/connection_dynamic_tab_response.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_leaderboardresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_userachivmentsresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/credit_response_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/filterby_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/filterby_model_learning.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/instructer_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/sort_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/getsummarydata_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/models/EventResourcePlusResponse.dart';

import '../../../../ui/MyLearning/myLearnPlus/models/MenuComponentsResponse.dart';

class MyLearningState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  MyLearningState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  MyLearningState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  MyLearningState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class IntitialSampleStateState extends MyLearningState {
  IntitialSampleStateState.completed(data) : super.completed(data);
}

class GetListState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetListState.loading(data) : super.loading(data);

  GetListState.completed({required this.list}) : super.completed(list);

  GetListState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsState.loading(data) : super.loading(data);

  GetMyLearnPlusLearningObjectsState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsCompleteState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsCompleteState.loading(data)
      : super.loading(data);

  GetMyLearnPlusLearningObjectsCompleteState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsCompleteState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsNotStartedState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsNotStartedState.loading(data)
      : super.loading(data);

  GetMyLearnPlusLearningObjectsNotStartedState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsNotStartedState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsAttendState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsAttendState.loading(data) : super.loading(data);

  GetMyLearnPlusLearningObjectsAttendState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsAttendState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsWaitState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsWaitState.loading(data) : super.loading(data);

  GetMyLearnPlusLearningObjectsWaitState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsWaitState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsDashdayState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsDashdayState.loading(data) : super.loading(data);

  GetMyLearnPlusLearningObjectsDashdayState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsDashdayState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsDashWeekState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsDashWeekState.loading(data)
      : super.loading(data);

  GetMyLearnPlusLearningObjectsDashWeekState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsDashWeekState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsDashMonthState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsDashMonthState.loading(data)
      : super.loading(data);

  GetMyLearnPlusLearningObjectsDashMonthState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsDashMonthState.error(data) : super.error(data);
}

class GetMyLearnPlusLearningObjectsDashFutureState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetMyLearnPlusLearningObjectsDashFutureState.loading(data)
      : super.loading(data);

  GetMyLearnPlusLearningObjectsDashFutureState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusLearningObjectsDashFutureState.error(data) : super.error(data);
}

class GetMyLearnPlusEventResourceState extends MyLearningState {
  List<EventResourcePlusResponse> list = [];

  GetMyLearnPlusEventResourceState.loading(data) : super.loading(data);

  GetMyLearnPlusEventResourceState.completed({required this.list})
      : super.completed(list);

  GetMyLearnPlusEventResourceState.error(data) : super.error(data);
}

class GetWishListPlusState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetWishListPlusState.loading(data) : super.loading(data);

  GetWishListPlusState.completed({required this.list}) : super.completed(list);

  GetWishListPlusState.error(data) : super.error(data);
}

class GetArchiveListState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetArchiveListState.loading(data) : super.loading(data);

  GetArchiveListState.completed({required this.list}) : super.completed(list);

  GetArchiveListState.error(data) : super.error(data);
}

class GetMenuComponentsState extends MyLearningState {
  MenuComponentsResponse menuresponse = MenuComponentsResponse();

  GetMenuComponentsState.loading(data) : super.loading(data);

  GetMenuComponentsState.completed({required this.menuresponse}) : super.completed(menuresponse);

  GetMenuComponentsState.error(data) : super.error(data);
}

class GetWaitListState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetWaitListState.loading(data) : super.loading(data);

  GetWaitListState.completed({required this.list}) : super.completed(list);

  GetWaitListState.error(data) : super.error(data);
}

class GetWishListState extends MyLearningState {
  List<DummyMyCatelogResponseTable2> list = [];

  GetWishListState.loading(data) : super.loading(data);

  GetWishListState.completed({required this.list}) : super.completed(list);

  GetWishListState.error(data) : super.error(data);
}

class GetFilterMenusState extends MyLearningState {
  Map<String, String> filterMenus = {};

  GetFilterMenusState.loading(data) : super.loading(data);

  GetFilterMenusState.completed({required this.filterMenus})
      : super.completed(filterMenus);

  GetFilterMenusState.error(data) : super.error(data);
}

class AddtoArchiveCallState extends MyLearningState {
  bool isScusses = false;

  AddtoArchiveCallState.loading(data) : super.loading(data);

  AddtoArchiveCallState.completed({this.isScusses = false})
      : super.completed(isScusses);

  AddtoArchiveCallState.error(data) : super.error(data);
}

class RemovetoArchiveCallState extends MyLearningState {
  bool isScusses = false;

  RemovetoArchiveCallState.loading(data) : super.loading(data);

  RemovetoArchiveCallState.completed({this.isScusses = false})
      : super.completed(isScusses);

  RemovetoArchiveCallState.error(data) : super.error(data);
}

class GetSortMenusState extends MyLearningState {
  List<SortModel> sortList = [];

  GetSortMenusState.loading(data) : super.loading(data);

  GetSortMenusState.completed({required this.sortList})
      : super.completed(sortList);

  GetSortMenusState.error(data) : super.error(data);
}

//class CancelEnrollmentState extends MyLearningState  {
//  List<SortTable> sortMenuList;
//  CancelEnrollmentState.loading(data) : super.loading(data);
//  CancelEnrollmentState.completed({this.sortMenuList}) : super.completed(sortMenuList);
//  CancelEnrollmentState.error(data) : super.error(data);
//
//}

class GetLearningTreeState extends MyLearningState {
  FilterByModelLearning? filterByList;

  GetLearningTreeState.loading(data) : super.loading(data);

  GetLearningTreeState.completed({this.filterByList})
      : super.completed(filterByList);

  GetLearningTreeState.error(data) : super.error(data);
}

class GetCategoriesTreeState extends MyLearningState {
  List<FilterByModel> filterByList = [];

  GetCategoriesTreeState.loading(data) : super.loading(data);

  GetCategoriesTreeState.completed({required this.filterByList})
      : super.completed(filterByList);

  GetCategoriesTreeState.error(data) : super.error(data);
}

class SelectCategoriesState extends MyLearningState {
  List<Map<String, dynamic>> list = [];

  SelectCategoriesState.loading(data) : super.loading(data);

  SelectCategoriesState.completed({required this.list}) : super.completed(list);

  SelectCategoriesState.error(data) : super.error(data);
}

class GetFilterDurationState extends MyLearningState {
  List<CreditModel> list = [];

  GetFilterDurationState.loading(data) : super.loading(data);

  GetFilterDurationState.completed({required this.list})
      : super.completed(list);

  GetFilterDurationState.error(data) : super.error(data);
}

class GetProgresReportState extends MyLearningState {
  List<GetSummaryDataResponse> list = [];

  GetProgresReportState.loading(data) : super.loading(data);

  GetProgresReportState.completed({required this.list}) : super.completed(list);

  GetProgresReportState.error(data) : super.error(data);
}

class RemoveFromMyLearningState extends MyLearningState {
  bool response = false;

  RemoveFromMyLearningState.loading(data) : super.loading(data);

  RemoveFromMyLearningState.completed({this.response = false})
      : super.completed(response);

  RemoveFromMyLearningState.error(data) : super.error(data);
}

class ResetFilterState extends MyLearningState {
  bool response = false;

  ResetFilterState.loading(data) : super.loading(data);

  ResetFilterState.completed({this.response = false})
      : super.completed(response);

  ResetFilterState.error(data) : super.error(data);
}

class InstructerListState extends MyLearningState {
  InstructerListResponse response = InstructerListResponse(table: []);

  InstructerListState.loading(data) : super.loading(data);

  InstructerListState.completed({required this.response})
      : super.completed(response);

  InstructerListState.error(data) : super.error(data);
}

class CourseTrackingState extends MyLearningState {
  String response = "";
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
  String courseUrl = "";

  CourseTrackingState.loading(data) : super.loading(data);

  CourseTrackingState.completed(
      {required this.table2, this.response = "", this.courseUrl = ""})
      : super.completed(response);

  CourseTrackingState.error(data) : super.error(data);
}

class TokenFromSessionIdState extends MyLearningState {
  String response = "";
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  TokenFromSessionIdState.loading(data) : super.loading(data);

  TokenFromSessionIdState.completed({this.response = "", required this.table2})
      : super.completed(response);

  TokenFromSessionIdState.error(data) : super.error(data);
}

class UpdateCompleteStatusState extends MyLearningState {
  String response = "";

  UpdateCompleteStatusState.loading(data) : super.loading(data);

  UpdateCompleteStatusState.completed({this.response = ""})
      : super.completed(response);

  UpdateCompleteStatusState.error(data) : super.error(data);
}

class GetUserAchievementDataPlusState extends MyLearningState {
  UserAchievementResponse userAchievementResponse = UserAchievementResponse();

  GetUserAchievementDataPlusState.loading(data) : super.loading(data);

  GetUserAchievementDataPlusState.completed(
      {required this.userAchievementResponse})
      : super.completed(userAchievementResponse);

  GetUserAchievementDataPlusState.error(data) : super.error(data);
}

class GetLeaderboardLearnPlusState extends MyLearningState {
  LeaderBoardResponse leaderBoardResponse =
      LeaderBoardResponse(leaderBoardList: []);

  GetLeaderboardLearnPlusState.loading(data) : super.loading(data);

  GetLeaderboardLearnPlusState.completed({required this.leaderBoardResponse})
      : super.completed(leaderBoardResponse);

  GetLeaderboardLearnPlusState.error(data) : super.error(data);
}

class GetDynamicTabsPlusState extends MyLearningState {
  List<ConnectionDynamicTab> dynamicTabList = [];
  List<Tab> tabList = [];

  GetDynamicTabsPlusState.loading(data) : super.loading(data);

  GetDynamicTabsPlusState.completed({required this.dynamicTabList,required this.tabList})
      : super.completed(dynamicTabList);

  GetDynamicTabsPlusState.error(data) : super.error(data);
}

class GetGameslistLearnPlusState extends MyLearningState {
  String message = "";

  GetGameslistLearnPlusState.loading(data) : super.loading(data);

  GetGameslistLearnPlusState.completed({this.message = ""})
      : super.completed(message);

  GetGameslistLearnPlusState.error(data) : super.error(data);
}
