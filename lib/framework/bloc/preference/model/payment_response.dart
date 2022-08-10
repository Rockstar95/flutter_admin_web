import 'dart:convert';

PaymentResponse paymentResponseFromJson(String str) =>
    PaymentResponse.fromJson(json.decode(str));

String paymentResponseToJson(PaymentResponse data) =>
    json.encode(data.toJson());

class PaymentResponse {
  PaymentResponse({
    required this.table,
  });

  List<PaymentData> table = [];

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        table: List<PaymentData>.from(
            json["Table"].map((x) => PaymentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class PaymentData {
  PaymentData({
    this.itemName = "",
    this.contentId = "",
    this.userId = 0,
    this.verisignTransId,
    this.purchaseDate,
    this.price = 0,
    this.paymentType = "",
    this.rn = 0,
    this.combinedTransaction = false,
    this.purchasedDate = "",
    this.currencySign = "",
  });

  String itemName = "";
  String contentId = "";
  int userId = 0;
  dynamic verisignTransId;
  DateTime? purchaseDate;
  double price = 0;
  String paymentType = "";
  int rn = 0;
  bool combinedTransaction = false;
  String purchasedDate = "";
  String currencySign = "";

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        itemName: json["ItemName"],
        contentId: json["ContentID"],
        userId: json["UserID"],
        verisignTransId: json["VerisignTransID"],
        purchaseDate: DateTime.parse(json["PurchaseDate"]),
        price: json["Price"],
        paymentType: json["PaymentType"],
        rn: json["RN"],
        combinedTransaction: json["CombinedTransaction"],
        purchasedDate: json["PurchasedDate"],
        currencySign: json["CurrencySign"],
      );

  Map<String, dynamic> toJson() => {
        "ItemName": itemName,
        "ContentID": contentId,
        "UserID": userId,
        "VerisignTransID": verisignTransId,
        "PurchaseDate": purchaseDate?.toIso8601String(),
        "Price": price,
        "PaymentType": paymentType,
        "RN": rn,
        "CombinedTransaction": combinedTransaction,
        "PurchasedDate": purchasedDate,
        "CurrencySign": currencySign,
      };
}
