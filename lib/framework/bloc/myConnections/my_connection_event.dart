part of 'my_connection_bloc.dart';

abstract class MyConnectionEvent extends Equatable {
  const MyConnectionEvent();
}

class GetDynamicTabsEvent extends MyConnectionEvent {
  final int selectedObjectID;
  final String selectAction;
  final String userName;
  final int mainSiteUserID;

  GetDynamicTabsEvent(
      {this.selectedObjectID = 0,
      this.selectAction = " = 0",
      this.userName = " = 0",
      this.mainSiteUserID = 0});

  @override
  List<Object> get props => [
        this.selectedObjectID,
        this.selectAction,
        this.userName,
        this.mainSiteUserID,
      ];
}

class GetPeopleListEvent extends MyConnectionEvent {
  final int componentID;
  final int componentInstanceID;
  final int userID;
  final int siteID;
  final String locale;
  final String sortBy;
  final String sortType;
  final int pageIndex;
  final int pageSize;
  final String filterType;
  final String tabID;
  final String searchText;
  final String contentid;
  final String location;
  final String company;
  final String skilllevels;
  final String firstname;
  final String lastname;
  final String skillcats;
  final String skills;
  final String jobroles;
  final bool isRefresh;

  GetPeopleListEvent(
      {this.componentID = 0,
      this.componentInstanceID = 0,
      this.userID = 0,
      this.siteID = 0,
      this.locale = "",
      this.sortBy = "",
      this.sortType = "",
      this.pageIndex = 0,
      this.pageSize = 0,
      this.filterType = "",
      this.tabID = "",
      this.searchText = "",
      this.contentid = "",
      this.location = "",
      this.company = "",
      this.skilllevels = "",
      this.firstname = "",
      this.lastname = "",
      this.skillcats = "",
      this.skills = "",
      this.jobroles = "",
      this.isRefresh = false,
      });

  @override
  List<Object> get props => [
        this.componentID,
        this.componentInstanceID,
        this.userID,
        this.siteID,
        this.locale,
        this.sortBy,
        this.sortType,
        this.pageIndex,
        this.pageSize,
        this.filterType,
        this.tabID,
        this.searchText,
        this.contentid,
        this.location,
        this.company,
        this.skilllevels,
        this.firstname,
        this.lastname,
        this.skillcats,
        this.skills,
        this.jobroles,
      ];
}

class AddConnectionEvent extends MyConnectionEvent {
  final int selectedObjectID;
  final String selectAction;
  final String userName;
  final int mainSiteUserID;

  AddConnectionEvent(
      {this.selectedObjectID = 0,
      this.selectAction = "",
      this.userName = "",
      this.mainSiteUserID = 0});

  @override
  List<Object> get props => [
        this.selectedObjectID,
        this.selectAction,
        this.userName,
        this.mainSiteUserID,
      ];
}

class RemoveConnectionEvent extends MyConnectionEvent {
  final int selectedObjectID;
  final String selectAction;
  final String userName;
  final int mainSiteUserID;

  RemoveConnectionEvent(
      {this.selectedObjectID = 0,
      this.selectAction = "",
      this.userName = "",
      this.mainSiteUserID = 0});

  @override
  List<Object> get props => [
        this.selectedObjectID,
        this.selectAction,
        this.userName,
        this.mainSiteUserID,
      ];
}
