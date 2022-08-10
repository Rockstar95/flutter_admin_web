import 'dart:convert';

SearchComponentResponse searchComponentResponseFromJson(String str) =>
    SearchComponentResponse.fromJson(json.decode(str));

String searchComponentResponseToJson(SearchComponentResponse data) =>
    json.encode(data.toJson());

class SearchComponentResponse {
  SearchComponentResponse({
    required this.searchComponents,
  });

  List<SearchComponent> searchComponents = [];

  factory SearchComponentResponse.fromJson(Map<String, dynamic> json) =>
      SearchComponentResponse(
        searchComponents: List<SearchComponent>.from(
            json["SearchComponents"].map((x) => SearchComponent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "SearchComponents":
            List<dynamic>.from(searchComponents.map((x) => x.toJson())),
      };
}

class SearchComponent {
  String name = "";
  String componentId = "";
  int menuId = 0;
  int siteId = 0;
  int componentInstanceId = 0;
  String contextTitle = "";
  String siteName = "";
  String displayName = "";
  String learnerSiteUrl = "";
  String nativeCompId = "";
  bool check = false;

  /*SearchComponent({
    this.name,
    this.componentId,
    this.menuId,
    this.siteId,
    this.componentInstanceId,
    this.contextTitle,
    this.siteName,
    this.displayName,
    this.learnerSiteUrl,
    this.nativeCompId,
    this.check,
  });*/

  SearchComponent.fromJson(Map<String, dynamic> json) {
    name = json["Name"];
    componentId = json["ComponentID"];
    menuId = json["MenuID"];
    siteId = json["SiteID"];
    componentInstanceId = json["ComponentInstanceID"];
    contextTitle = json["ContextTitle"];
    siteName = json["SiteName"];
    displayName = json["DisplayName"];
    learnerSiteUrl = json["LearnerSiteURL"];
    nativeCompId = json["NativeCompID"];
    check = json["Check"];
  }

  Map<String, dynamic> toJson() => {
        "Name": name,
        "ComponentID": componentId,
        "MenuID": menuId,
        "SiteID": siteId,
        "ComponentInstanceID": componentInstanceId,
        "ContextTitle": contextTitle,
        "SiteName": siteName,
        "DisplayName": displayName,
        "LearnerSiteURL": learnerSiteUrl,
        "NativeCompID": nativeCompId,
        "Check": check,
      };
}
