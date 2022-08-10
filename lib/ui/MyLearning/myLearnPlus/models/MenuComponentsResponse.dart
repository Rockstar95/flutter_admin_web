// To parse this JSON data, do
//
//     final menuComponentsResponse = menuComponentsResponseFromJson(jsonString);

import 'dart:convert';

MenuComponentsResponse menuComponentsResponseFromJson(String str) => MenuComponentsResponse.fromJson(json.decode(str));

String menuComponentsResponseToJson(MenuComponentsResponse data) => json.encode(data.toJson());

class MenuComponentsResponse {
  MenuComponentsResponse({
     this.table = const [],
     this.table1 = const [],
     this.table2 = const [],
     this.table3 = const [],
     this.table4 = const [],
  });

  List<Table> table;
  List<Table1> table1;
  List<Table2> table2;
  List<Table3> table3;
  List<Table4> table4;

  factory MenuComponentsResponse.fromJson(Map<String, dynamic> json) => MenuComponentsResponse(
    table: List<Table>.from(json["Table"].map((x) => Table.fromJson(x))),
    table1: List<Table1>.from(json["Table1"].map((x) => Table1.fromJson(x))),
    table2: List<Table2>.from(json["Table2"].map((x) => Table2.fromJson(x))),
    table3: List<Table3>.from(json["Table3"].map((x) => Table3.fromJson(x))),
    table4: List<Table4>.from(json["Table4"].map((x) => Table4.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(table.map((x) => x.toJson())),
    "Table1": List<dynamic>.from(table1.map((x) => x.toJson())),
    "Table2": List<dynamic>.from(table2.map((x) => x.toJson())),
    "Table3": List<dynamic>.from(table3.map((x) => x.toJson())),
    "Table4": List<dynamic>.from(table4.map((x) => x.toJson())),
  };
}

class Table {
  Table({
    this.displayName = '',
    this.localeId = '',
    this.menuId = 0,
    this.parentMenuId = 0,
    this.displayOrder = 0,
    this.menuLevel = 0,
    this.groupId = 0,
    this.image = '',
    this.showMobile = '',
    this.subMenuType = 0,
    this.externalUrl = '',
    this.externalUrlParams = '',
    this.visible = false,
    this.privilegeId = 0,
    this.siteId = 0,
    this.menuType = 0,
    this.menuAlign = 0,
    this.urlTarget = 0,
    this.contextTitle = '',
    this.showInSiteAdmin = false,
    this.isExternalPage = false,
    this.isUserCreated = false,
    this.helpUrl = '',
    this.pageId = 0,
    this.pageTitle = '',
    this.externalPageInvocation = false,
    this.menuId1 = 0,
    this.siteId1 = 0,
    this.title = '',
    this.keywords = '',
    this.description = '',
  });

  String displayName;
  String localeId;
  int menuId;
  int parentMenuId;
  int displayOrder;
  int menuLevel;
  int groupId;
  String image;
  dynamic showMobile;
  int subMenuType;
  String externalUrl;
  String externalUrlParams;
  bool visible;
  int privilegeId;
  int siteId;
  int menuType;
  int menuAlign;
  int urlTarget;
  String contextTitle;
  bool showInSiteAdmin;
  bool isExternalPage;
  bool isUserCreated;
  String helpUrl;
  int pageId;
  String pageTitle;
  bool externalPageInvocation;
  int menuId1;
  int siteId1;
  dynamic title;
  dynamic keywords;
  dynamic description;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
    displayName: json["DisplayName"],
    localeId: json["LocaleID"],
    menuId: json["MenuID"],
    parentMenuId: json["ParentMenuID"],
    displayOrder: json["DisplayOrder"],
    menuLevel: json["MenuLevel"],
    groupId: json["GroupID"],
    image: json["Image"],
    showMobile: json["ShowMobile"],
    subMenuType: json["SubMenuType"],
    externalUrl: json["ExternalURL"],
    externalUrlParams: json["ExternalURLParams"],
    visible: json["Visible"],
    privilegeId: json["PrivilegeID"],
    siteId: json["SiteID"],
    menuType: json["MenuType"],
    menuAlign: json["MenuAlign"],
    urlTarget: json["UrlTarget"],
    contextTitle: json["ContextTitle"],
    showInSiteAdmin: json["ShowInSiteAdmin"],
    isExternalPage: json["IsExternalPage"],
    isUserCreated: json["IsUserCreated"],
    helpUrl: json["HelpUrl"],
    pageId: json["PageID"],
    pageTitle: json["PageTitle"],
    externalPageInvocation: json["ExternalPageInvocation"],
    menuId1: json["MenuID1"],
    siteId1: json["SiteID1"],
    title: json["Title"],
    keywords: json["Keywords"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "DisplayName": displayName,
    "LocaleID": localeId,
    "MenuID": menuId,
    "ParentMenuID": parentMenuId,
    "DisplayOrder": displayOrder,
    "MenuLevel": menuLevel,
    "GroupID": groupId,
    "Image": image,
    "ShowMobile": showMobile,
    "SubMenuType": subMenuType,
    "ExternalURL": externalUrl,
    "ExternalURLParams": externalUrlParams,
    "Visible": visible,
    "PrivilegeID": privilegeId,
    "SiteID": siteId,
    "MenuType": menuType,
    "MenuAlign": menuAlign,
    "UrlTarget": urlTarget,
    "ContextTitle": contextTitle,
    "ShowInSiteAdmin": showInSiteAdmin,
    "IsExternalPage": isExternalPage,
    "IsUserCreated": isUserCreated,
    "HelpUrl": helpUrl,
    "PageID": pageId,
    "PageTitle": pageTitle,
    "ExternalPageInvocation": externalPageInvocation,
    "MenuID1": menuId1,
    "SiteID1": siteId1,
    "Title": title,
    "Keywords": keywords,
    "Description": description,
  };
}

class Table1 {
  Table1({
    this.privilegeId = 0,
    this.componentInstanceId = 0,
    this.pageId = 0,
    this.parameterString = '',
    this.componentId = 0,
    this.componentName = "",
    this.localeId = '',
    this.messageText = '',
    this.desktopSourceFile = '',
    this.mobileSourceFile = '',
    this.componentXmlfile = '',
    this.displayOrder = 0,
    this.paneName = '',
    this.keywordFilteringEnabled = false,
    this.contentPrefType = 0,
    this.dataSource = 0,
    this.siteId = 0,
    this.sortType = 0,
    this.helpUrl = '',
    this.isSearchComponent = false,
    this.isPublicInstance = false,
    this.showHeader = false,
    this.headerStyle = '',
    this.componentPath = '',
  });

  int privilegeId;
  int componentInstanceId;
  int pageId;
  String parameterString;
  int componentId;
  String componentName;
  String localeId;
  String messageText;
  String desktopSourceFile;
  dynamic mobileSourceFile;
  String componentXmlfile;
  int displayOrder;
  String paneName;
  bool keywordFilteringEnabled;
  int contentPrefType;
  int dataSource;
  int siteId;
  int sortType;
  String helpUrl;
  bool isSearchComponent;
  bool isPublicInstance;
  bool showHeader;
  String headerStyle;
  String componentPath;

  factory Table1.fromJson(Map<String, dynamic> json) => Table1(
    privilegeId: json[" PrivilegeID"],
    componentInstanceId: json["ComponentInstanceID"],
    pageId: json["PageID"],
    parameterString: json["ParameterString"],
    componentId: json["ComponentID"],
    componentName: json["ComponentName"],
    localeId: json["LocaleID"],
    messageText: json["MessageText"],
    desktopSourceFile: json["DesktopSourceFile"],
    mobileSourceFile: json["MobileSourceFile"],
    componentXmlfile: json["ComponentXMLFILE"],
    displayOrder: json["DisplayOrder"],
    paneName: json["PaneName"],
    keywordFilteringEnabled: json["KeywordFilteringEnabled"],
    contentPrefType: json["ContentPrefType"],
    dataSource: json["DataSource"],
    siteId: json["SiteID"],
    sortType: json["SortType"],
    helpUrl: json["HelpURL"],
    isSearchComponent: json["IsSearchComponent"],
    isPublicInstance: json["IsPublicInstance"],
    showHeader: json["ShowHeader"],
    headerStyle: json["HeaderStyle"],
    componentPath: json["ComponentPath"],
  );

  Map<String, dynamic> toJson() => {
    " PrivilegeID": privilegeId,
    "ComponentInstanceID": componentInstanceId,
    "PageID": pageId,
    "ParameterString": parameterString,
    "ComponentID": componentId,
    "ComponentName": componentName,
    "LocaleID": localeId,
    "MessageText": messageText,
    "DesktopSourceFile": desktopSourceFile,
    "MobileSourceFile": mobileSourceFile,
    "ComponentXMLFILE": componentXmlfile,
    "DisplayOrder": displayOrder,
    "PaneName": paneName,
    "KeywordFilteringEnabled": keywordFilteringEnabled,
    "ContentPrefType": contentPrefType,
    "DataSource": dataSource,
    "SiteID": siteId,
    "SortType": sortType,
    "HelpURL": helpUrl,
    "IsSearchComponent": isSearchComponent,
    "IsPublicInstance": isPublicInstance,
    "ShowHeader": showHeader,
    "HeaderStyle": headerStyle,
    "ComponentPath": componentPath,
  };
}

class Table2 {
  Table2({
    this.searchCompInstanceId = 0,
    this.componentInstanceId = 0,
    this.desktopSourceFile = DesktopSourceFile.ANGULAR_JS_LATEST_CATALOG_ASCX,
    this.componentName = '',
    this.privilegeId = 0,
    this.isPublicInstance = false,
    this.siteId = 0,
  });

  int searchCompInstanceId;
  int componentInstanceId;
  DesktopSourceFile desktopSourceFile;
  String componentName;
  int privilegeId;
  bool isPublicInstance;
  int siteId;

  factory Table2.fromJson(Map<String, dynamic> json) => Table2(
    searchCompInstanceId: json["SearchCompInstanceID"] ?? 0,
    componentInstanceId: json["ComponentInstanceID"],
    desktopSourceFile: desktopSourceFileValues.map[json["DesktopSourceFile"]] ?? DesktopSourceFile.ANGULAR_JS_LATEST_CATALOG_ASCX,
    componentName: json["ComponentName"],
    privilegeId: json["PrivilegeID"],
    isPublicInstance: json["isPublicInstance"],
    siteId: json["SiteID"],
  );

  Map<String, dynamic> toJson() => {
    "SearchCompInstanceID": searchCompInstanceId,
    "ComponentInstanceID": componentInstanceId,
    "DesktopSourceFile": desktopSourceFileValues.reverse[desktopSourceFile],
    "ComponentName": componentName,
    "PrivilegeID": privilegeId,
    "isPublicInstance": isPublicInstance,
    "SiteID": siteId,
  };
}

enum DesktopSourceFile { MODULES_WEB_LIST_ASCX, MODULES_NEW_DISCUSSION_FORUM_ASCX, ANGULAR_JS_LATEST_CATALOG_ASCX, ANGULAR_JS_LATEST_MY_LEARNING_ASCX }

final desktopSourceFileValues = EnumValues({
  "~/AngularJS/LatestCatalog.ascx": DesktopSourceFile.ANGULAR_JS_LATEST_CATALOG_ASCX,
  "~/AngularJS/LatestMyLearning.ascx": DesktopSourceFile.ANGULAR_JS_LATEST_MY_LEARNING_ASCX,
  "~/Modules/NewDiscussionForum.ascx": DesktopSourceFile.MODULES_NEW_DISCUSSION_FORUM_ASCX,
  "~/Modules/WebList.ascx": DesktopSourceFile.MODULES_WEB_LIST_ASCX
});

class Table3 {
  Table3({
    this.componentId = 0,
    this.objectTypeId = 0,
    this.displayOrder = 0,
    this.contentLaunchWindowMode = false,
    this.contentLaunchWindowFeatures = '',
    this.forceObjectTypeLevelClws = false,
    this.moduleId = 0,
  });

  int componentId;
  int objectTypeId;
  int displayOrder;
  bool contentLaunchWindowMode;
  String contentLaunchWindowFeatures;
  bool forceObjectTypeLevelClws;
  int moduleId;

  factory Table3.fromJson(Map<String, dynamic> json) => Table3(
    componentId: json["ComponentID"],
    objectTypeId: json["ObjectTypeID"],
    displayOrder: json["DisplayOrder"],
    contentLaunchWindowMode: json["ContentLaunchWindowMode"],
    contentLaunchWindowFeatures: json["ContentLaunchWindowFeatures"],
    forceObjectTypeLevelClws: json["ForceObjectTypeLevelCLWS"],
    moduleId: json["ModuleID"],
  );

  Map<String, dynamic> toJson() => {
    "ComponentID": componentId,
    "ObjectTypeID": objectTypeId,
    "DisplayOrder": displayOrder,
    "ContentLaunchWindowMode": contentLaunchWindowMode,
    "ContentLaunchWindowFeatures": contentLaunchWindowFeatures,
    "ForceObjectTypeLevelCLWS": forceObjectTypeLevelClws,
    "ModuleID": moduleId,
  };
}

class Table4 {
  Table4({
    this.rowNumber = 0,
    this.colNumber = 0,
    this.paneName = '',
    this.noofColumns = 0,
  });

  int rowNumber;
  int colNumber;
  String paneName;
  int noofColumns;

  factory Table4.fromJson(Map<String, dynamic> json) => Table4(
    rowNumber: json["RowNumber"],
    colNumber: json["ColNumber"],
    paneName: json["PaneName"],
    noofColumns: json["NoofColumns"],
  );

  Map<String, dynamic> toJson() => {
    "RowNumber": rowNumber,
    "ColNumber": colNumber,
    "PaneName": paneName,
    "NoofColumns": noofColumns,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map,{this.reverseMap = const {}});

  Map<T, String> get reverse {
    // if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    // }
    return reverseMap;
  }
}
