import 'dart:convert';

WishlistResponse wishlistCountResFromJson(String str) =>
    WishlistResponse.fromJson(json.decode(str));

dynamic wishlistCountResToJson(WishlistResponse data) =>
    json.encode(data.toJson());

class WishlistResponse {
  List<WishListTable> wishListDetails;
  int wishlistCount;

  WishlistResponse({required this.wishListDetails, this.wishlistCount = 0});

  static WishlistResponse fromJson(Map<String, dynamic> json) {
    WishlistResponse wishlistResponse = WishlistResponse(wishListDetails: []);

    wishlistResponse.wishlistCount = json['WishlistCount'] ?? 0;
    if (json['WishListDetails'] != null) {
      wishlistResponse.wishListDetails = [];
      json['WishListDetails']?.forEach((v) {
        wishlistResponse.wishListDetails.add(WishListTable.fromJson(v));
      });
    }

    return wishlistResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WishlistCount'] = this.wishlistCount;
    if (this.wishListDetails.isNotEmpty) {
      data['WishListDetails'] =
          this.wishListDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WishListTable {
  int componentid;

  WishListTable(
      {this.componentid = 0,
      this.componentinstanceid = 0,
      this.parameterstring = "",
      this.componentname = "",
      this.iswishlistFromList = 0,
      this.headerStyle = ""});

  int componentinstanceid;
  String parameterstring;
  String componentname;
  int iswishlistFromList;
  String headerStyle;

  static WishListTable fromJson(Map<String, dynamic> json) {
    WishListTable wishListTable = WishListTable();
    wishListTable.componentid = json['componentid'] ?? 0;
    wishListTable.componentinstanceid = json['componentinstanceid'] ?? 0;
    wishListTable.parameterstring = json['parameterstring'] ?? "";
    wishListTable.componentname = json['componentname'] ?? "";
    wishListTable.iswishlistFromList = json['iswishlistFromList'] ?? 0;
    wishListTable.headerStyle = json['HeaderStyle'] ?? "";
    return wishListTable;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['componentid'] = this.componentid;
    data['componentinstanceid'] = this.componentinstanceid;
    data['parameterstring'] = this.parameterstring;
    data['componentname'] = this.componentname;
    data['iswishlistFromList'] = this.iswishlistFromList;
    data['HeaderStyle'] = this.headerStyle;
    return data;
  }
}
