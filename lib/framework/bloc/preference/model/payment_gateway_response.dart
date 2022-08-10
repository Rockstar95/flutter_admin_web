import 'dart:convert';

PaymentGateway paymentGatewayFromJson(String str) =>
    PaymentGateway.fromJson(json.decode(str));

String paymentGatewayToJson(PaymentGateway data) => json.encode(data.toJson());

class PaymentGateway {
  PaymentGateway({
    this.paymentGateway = "",
    this.merchantTax = "",
    this.apiPassword = "",
    this.apiUserName = "",
    this.apiSignature = "",
    this.merchantSessionId = "",
    this.paymentGatewayType = "",
    this.displayText = "",
  });

  String paymentGateway = "";
  String merchantTax = "";
  String apiPassword = "";
  String apiUserName = "";
  String apiSignature = "";
  String merchantSessionId = "";
  String paymentGatewayType = "";
  String displayText = "";

  factory PaymentGateway.fromJson(Map<String, dynamic> json) => PaymentGateway(
        paymentGateway: json["PaymentGateway"],
        merchantTax: json["MerchantTax"],
        apiPassword: json["APIPassword"],
        apiUserName: json["APIUserName"],
        apiSignature: json["APISignature"],
        merchantSessionId: json["MerchantSessionID"],
        paymentGatewayType: json["PaymentGatewayType"],
        displayText: json["DisplayText"],
      );

  Map<String, dynamic> toJson() => {
        "PaymentGateway": paymentGateway,
        "MerchantTax": merchantTax,
        "APIPassword": apiPassword,
        "APIUserName": apiUserName,
        "APISignature": apiSignature,
        "MerchantSessionID": merchantSessionId,
        "PaymentGatewayType": paymentGatewayType,
        "DisplayText": displayText,
      };
}
