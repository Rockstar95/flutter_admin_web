import 'dart:convert';

PaymentProcessResponse paymentProcessResponseFromJson(String str) =>
    PaymentProcessResponse.fromJson(json.decode(str));

String paymentProcessResponseToJson(PaymentProcessResponse data) =>
    json.encode(data.toJson());

class PaymentProcessResponse {
  PaymentProcessResponse({
    this.result = "",
    this.launchUrl = "",
    this.firstName,
    this.lastName,
    this.ecartObj,
    this.paymentDate,
    this.convertedPrice,
    this.convertedInitialPrice,
    this.contentIdList,
    this.newUserId = 0,
    this.myLearningUrl,
    this.notifyMessage = "",
    this.kbankOrderId,
    this.loginId = "",
    this.loginPwd = "",
  });

  String result = "";
  String launchUrl = "";
  dynamic firstName;
  dynamic lastName;
  dynamic ecartObj;
  dynamic paymentDate;
  dynamic convertedPrice;
  dynamic convertedInitialPrice;
  dynamic contentIdList;
  int newUserId = 0;
  dynamic myLearningUrl;
  String notifyMessage = "";
  dynamic kbankOrderId;
  String loginId = "";
  String loginPwd = "";

  factory PaymentProcessResponse.fromJson(Map<String, dynamic> json) =>
      PaymentProcessResponse(
        result: json["Result"] ?? "",
        launchUrl: json["LaunchURL"] ?? "",
        firstName: json["FirstName"],
        lastName: json["LastName"],
        ecartObj: json["EcartObj"],
        paymentDate: json["PaymentDate"],
        convertedPrice: json["ConvertedPrice"],
        convertedInitialPrice: json["ConvertedInitialPrice"],
        contentIdList: json["ContentIDList"],
        newUserId: json["NewUserID"] ?? 0,
        myLearningUrl: json["MyLearningURL"],
        notifyMessage: json["NotifyMessage"] ?? "",
        kbankOrderId: json["KbankOrderID"],
        loginId: json["loginID"] ?? "",
        loginPwd: json["loginPwd"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Result": result,
        "LaunchURL": launchUrl,
        "FirstName": firstName,
        "LastName": lastName,
        "EcartObj": ecartObj,
        "PaymentDate": paymentDate,
        "ConvertedPrice": convertedPrice,
        "ConvertedInitialPrice": convertedInitialPrice,
        "ContentIDList": contentIdList,
        "NewUserID": newUserId,
        "MyLearningURL": myLearningUrl,
        "NotifyMessage": notifyMessage,
        "KbankOrderID": kbankOrderId,
        "loginID": loginId,
        "loginPwd": loginPwd,
      };
}
