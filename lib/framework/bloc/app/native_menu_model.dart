class NativeMenuModel {
  int webMenuId = 0;
  String menuid = "";
  String displayname = "";
  int displayOrder = 0;
  String image = "";
  String isofflineMenu = "";
  String isEnabled = "";

  int get _webMenuId => webMenuId;

  void setwebMenuId(int value) {
    webMenuId = value;
  }

  String contextTitle = "";
  String contextmenuId = "";
  String repositoryId = "";
  String landingpageType = "";
  String categoryStyle = "";
  String componentId = "-1";
  String conditions = "";
  String parentMenuId = "";
  String parameterString = "";
  String siteUrl = "";
  String siteId = "";

  String get _menuid => menuid;

  void setmenuid(String value) {
    menuid = value;
  }

  String get _displayname => displayname;

  void setdisplayname(String value) {
    displayname = value;
  }

  int get _displayOrder => displayOrder;

  void setdisplayOrder(int value) {
    displayOrder = value;
  }

  String get _image => image;

  void setimage(String value) {
    image = value;
  }

  String get _isofflineMenu => isofflineMenu;

  void setisofflineMenu(String value) {
    isofflineMenu = value;
  }

  String get _isEnabled => isEnabled;

  void setisEnabled(String value) {
    isEnabled = value;
  }

  String get _contextTitle => contextTitle;

  void setcontextTitle(String value) {
    contextTitle = value;
  }

  String get _contextmenuId => contextmenuId;

  setcontextmenuId(String value) {
    contextmenuId = value;
  }

  String get _repositoryId => repositoryId;

  setrepositoryId(String value) {
    repositoryId = value;
  }

  String get _landingpageType => landingpageType;

  setlandingpageType(String value) {
    landingpageType = value;
  }

  String get _categoryStyle => categoryStyle;

  setcategoryStyle(String value) {
    categoryStyle = value;
  }

  String get _componentId => componentId;

  setcomponentId(String value) {
    componentId = value;
  }

  String get _conditions => conditions;

  setconditions(String value) {
    conditions = value;
  }

  String get _parentMenuId => parentMenuId;

  setparentMenuId(String value) {
    parentMenuId = value;
  }

  String get _parameterString => parameterString;

  setparameterString(String value) {
    parameterString = value;
  }

  String get _siteUrl => siteUrl;

  setsiteUrl(String value) {
    siteUrl = value;
  }

  String get _siteId => siteId;

  setsiteId(String value) {
    siteId = value;
  }

  NativeMenuModel({required this.webMenuId,required this.menuid, required this.displayname,
  required this.displayOrder,required this.image, required this.isofflineMenu,
  required this.isEnabled,required this.contextTitle, required this.contextmenuId,
  required this.repositoryId,required this.landingpageType, required this.categoryStyle,
  required this.componentId,required this.conditions, required this.parentMenuId,
  required this.parameterString,required this.siteUrl, required this.siteId});
}
