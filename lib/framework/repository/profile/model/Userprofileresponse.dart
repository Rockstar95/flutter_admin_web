import 'dart:convert';

UserProfileResponse privacyProfileResponseFromJson(String str) =>
    UserProfileResponse.fromJson(json.decode(str));

String privacyProfileResponseToJson(UserProfileResponse data) =>
    json.encode(data.toJson());

class UserProfileResponse {
  bool userIsPublic = false;
  List<PrivacyProfileResponse> userProfileList = [];

  UserProfileResponse(
      {this.userIsPublic = false, this.userProfileList = const []});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileResponse(
        userIsPublic: json["UserIsPublic"] ?? false,
        userProfileList: List<PrivacyProfileResponse>.from(
            (json["UserProfileList"] ?? [])
                .map((x) => PrivacyProfileResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "UserIsPublic": userIsPublic,
        "UserProfileList":
            List<dynamic>.from(userProfileList.map((x) => x.toJson())),
      };
}

class PrivacyProfileResponse {
  int groupId = 0;
  String groupName = "";
  List<PrivacyProfileListResponse> profileList = [];

  PrivacyProfileResponse(
      {this.groupId = 0, this.groupName = "", this.profileList = const []});

  factory PrivacyProfileResponse.fromJson(Map<String, dynamic> json) =>
      PrivacyProfileResponse(
        groupId: json["groupid"] ?? 0,
        groupName: json["groupname"] ?? '',
        profileList: List<PrivacyProfileListResponse>.from(
            (json["profilelist"] ?? [])
                .map((x) => PrivacyProfileListResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "groupid": groupId,
        "groupname": groupName,
        "profilelist": List<dynamic>.from(profileList.map((x) => x.toJson())),
      };
}

class PrivacyProfileListResponse {
  String dataFieldName = "";
  int attributeConfigId = 0;
  String name = "";
  String label = "";
  int enabled = 0;
  int groupId = 0;
  String placeholder = "";

  PrivacyProfileListResponse(
      {this.dataFieldName = "",
      this.attributeConfigId = 0,
      this.name = "",
      this.label = "",
      this.enabled = 0,
      this.groupId = 0,
      this.placeholder = ""});

  factory PrivacyProfileListResponse.fromJson(Map<String, dynamic> json) =>
      PrivacyProfileListResponse(
        dataFieldName: json["datafieldname"] ?? "",
        attributeConfigId: json["attributeconfigid"] ?? 0,
        name: json["name"] ?? "",
        label: json["label"] ?? "",
        enabled: json["Enabled"] ?? 0,
        groupId: json["groupid"] ?? 0,
        placeholder: json["Placeholder"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "datafieldname": dataFieldName,
        "attributeconfigid": attributeConfigId,
        "name": name,
        "label": label,
        "Enabled": enabled,
        "groupid": groupId,
        "Placeholder": placeholder,
      };
}
