// To parse this JSON data, do
//
//     final jwvideo = jwvideoFromJson(jsonString);

import 'dart:convert';

Jwvideo jwvideoFromJson(String str) => Jwvideo.fromJson(json.decode(str));

String jwvideoToJson(Jwvideo data) => json.encode(data.toJson());

class Jwvideo {
  Jwvideo({
    this.jwvideos,
  });

  Jwvideos? jwvideos;

  factory Jwvideo.fromJson(Map<String, dynamic> json) => Jwvideo(
        jwvideos: json["jwvideos"] == null
            ? null
            : Jwvideos.fromJson(json["jwvideos"]),
      );

  Map<String, dynamic> toJson() => {
        "jwvideos": jwvideos == null ? null : jwvideos?.toJson(),
      };
}

class Jwvideos {
  Jwvideos({
    required this.jwvideo,
  });

  List<JwvideoElement> jwvideo = [];

  factory Jwvideos.fromJson(Map<String, dynamic> json) => Jwvideos(
        jwvideo: json["jwvideo"] == null
            ? []
            : List<JwvideoElement>.from(
                json["jwvideo"].map((x) => JwvideoElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jwvideo": jwvideo == null
            ? null
            : List<dynamic>.from(jwvideo.map((x) => x.toJson())),
      };
}

class JwvideoElement {
  JwvideoElement({
    this.empty = "",
  });

  String empty = "";

  factory JwvideoElement.fromJson(Map<String, dynamic> json) => JwvideoElement(
        empty: json["\u0024"] == null ? null : json["\u0024"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024": empty == null ? null : empty,
      };
}
