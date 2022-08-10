import 'package:equatable/equatable.dart';

import 'model/search_component_response.dart';

abstract class GlobalSearchEvent extends Equatable {
  const GlobalSearchEvent();
}

class GetSearchComponentListEvent extends GlobalSearchEvent {
  GetSearchComponentListEvent();

  @override
  List<Object> get props => [];
}

class GetGlobalSearchResultsEvent extends GlobalSearchEvent {
  final int pageIndex;
  final int pageSize;
  final String searchStr;
  final int source;
  final int type;
  final String fType;
  final String fValue;
  final String sortBy;
  final String sortType;
  final String keywords;
  final String authorID;
  final String groupBy;
  final int userID;
  final int siteID;
  final int orgUnitID;
  final String locale;
  final int componentID;
  final int componentInsID;
  final String multiLocation;
  final int objComponentList;
  final int componentSiteID;
  final SearchComponent searchComponent;

  GetGlobalSearchResultsEvent(
      {this.pageIndex = 0,
      this.pageSize = 0,
      this.searchStr = "",
      this.source = 0,
      this.type = 0,
      this.fType = "",
      this.fValue = "",
      this.sortBy = "",
      this.sortType = "",
      this.keywords = "",
      this.authorID = "",
      this.groupBy = "",
      this.userID = 0,
      this.siteID = 0,
      this.orgUnitID = 0,
      this.locale = "",
      this.componentID = 0,
      this.componentInsID = 0,
      this.multiLocation = "",
      this.objComponentList = 0,
      this.componentSiteID = 0,
      required this.searchComponent});

  @override
  List<Object> get props => [
        this.pageIndex,
        this.pageSize,
        this.searchStr,
        this.source,
        this.type,
        this.fType,
        this.fValue,
        this.sortBy,
        this.sortType,
        this.keywords,
        this.authorID,
        this.groupBy,
        this.userID,
        this.siteID,
        this.orgUnitID,
        this.locale,
        this.componentID,
        this.componentInsID,
        this.multiLocation,
        this.objComponentList,
        this.componentSiteID,
        this.searchComponent
      ];
}
