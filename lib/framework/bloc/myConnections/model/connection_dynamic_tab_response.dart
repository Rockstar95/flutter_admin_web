import 'dart:convert';

List<ConnectionDynamicTab> connectionDynamicTabFromJson(String str) =>
    List<ConnectionDynamicTab>.from(
        json.decode(str).map((x) => ConnectionDynamicTab.fromJson(x)));

String connectionDynamicTabToJson(List<ConnectionDynamicTab> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConnectionDynamicTab {
  String tabId = "";
  String displayName = "";
  String mobileDisplayName = "";
  String displayIcon = "";
  String componentName = "";
  String tabComponentInstanceId = "";
  String componentId = "";
  String parameterString = "";

  ConnectionDynamicTab(
      {this.tabId = "",
      this.displayName = "",
      this.mobileDisplayName = "",
      this.displayIcon = "",
      this.componentName = "",
      this.tabComponentInstanceId = "",
      this.componentId = "",
      this.parameterString = ""});

  factory ConnectionDynamicTab.fromJson(Map<String, dynamic> json) =>
      ConnectionDynamicTab(
          tabId: json["TabID"],
          displayName: json["DisplayName"],
          mobileDisplayName: json["MobileDisplayName"],
          displayIcon: json["DisplayIcon"],
          componentName: json["ComponentName"],
          tabComponentInstanceId: json["TabComponentInstanceID"],
          componentId: json["ComponentID"],
          parameterString: json["ParameterString"]);

  Map<String, dynamic> toJson() => {
        "TabID": tabId,
        "DisplayName": displayName,
        "MobileDisplayName": mobileDisplayName,
        "DisplayIcon": displayIcon,
        "ComponentName": componentName,
        "TabComponentInstanceID": tabComponentInstanceId,
        "ComponentID": componentId,
        "ParameterString": parameterString
      };
}
