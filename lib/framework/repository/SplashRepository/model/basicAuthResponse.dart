import 'dart:convert';

BasicAuthResponce basicAuthResponceFromJson(String str) =>
    BasicAuthResponce.fromJson(json.decode(str));

String basicAuthResponceToJson(BasicAuthResponce data) =>
    json.encode(data.toJson());

class BasicAuthResponce {
  String basicAuth;
  String uniqueId;
  String webApiUrl;
  String lmsUrl;
  String learnerUrl;

  BasicAuthResponce({
    this.basicAuth = "",
    this.uniqueId = "",
    this.webApiUrl = "",
    this.lmsUrl = "",
    this.learnerUrl = "",
  });

  factory BasicAuthResponce.fromJson(Map<String, dynamic> json) =>
      BasicAuthResponce(
        basicAuth: json["basicAuth"] == null ? "" : json["basicAuth"],
        uniqueId: json["UniqueID"] == null ? "" : json["UniqueID"],
        webApiUrl: json["WebAPIUrl"] == null ? "" : json["WebAPIUrl"],
        lmsUrl: json["LMSUrl"] == null ? "" : json["LMSUrl"],
        learnerUrl: json["LearnerURL"] == null ? "" : json["LearnerURL"],
      );

  Map<String, dynamic> toJson() => {
        "basicAuth": basicAuth == null ? null : basicAuth,
        "UniqueID": uniqueId == null ? null : uniqueId,
        "WebAPIUrl": webApiUrl == null ? null : webApiUrl,
        "LMSUrl": lmsUrl == null ? null : lmsUrl,
        "LearnerURL": learnerUrl == null ? null : learnerUrl,
      };
}
