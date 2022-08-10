// To parse this JSON data, do
//
//     final fbUser = fbUserFromJson(jsonString);

import 'dart:convert';

FbUser fbUserFromJson(String str) => FbUser.fromJson(json.decode(str));

String fbUserToJson(FbUser data) => json.encode(data.toJson());

class FbUser {
  FbUser({
    this.name = "",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    required this.picture,
    this.id = "",
  });

  String name = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  Picture picture;
  String id = "";

  factory FbUser.fromJson(Map<String, dynamic> json) => FbUser(
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        picture: Picture.fromJson(json["picture"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "picture": picture.toJson(),
        "id": id,
      };
}

class Picture {
  Picture({
    required this.data,
  });

  Data data;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.height = 0,
    this.isSilhouette = false,
    this.url = "",
    this.width = 0,
  });

  int height = 0;
  bool isSilhouette = false;
  String url = "";
  int width = 0;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        height: json["height"],
        isSilhouette: json["is_silhouette"],
        url: json["url"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "is_silhouette": isSilhouette,
        "url": url,
        "width": width,
      };
}
