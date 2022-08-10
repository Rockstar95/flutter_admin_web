import 'dart:convert';

import 'package:intl/intl.dart';

MembershipResponse membershipResponseFromJson(String str) =>
    MembershipResponse.fromJson(json.decode(str));

String membershipResponseToJson(MembershipResponse data) =>
    json.encode(data.toJson());

class MembershipResponse {
  MembershipResponse({
    required this.membership,
  });

  List<MembershipModel> membership;

  factory MembershipResponse.fromJson(Map<String, dynamic> json) =>
      MembershipResponse(
        membership: List<MembershipModel>.from(
            json["Table"].map((x) => MembershipModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": List<dynamic>.from(membership.map((x) => x.toJson())),
      };
}

class MembershipModel {
  MembershipModel({
    this.userMembership = "",
    this.membershipLevel = 0,
    this.status = "",
    this.startDate,
    this.expiryDate,
    this.durationName = "",
    this.expiryStatus = "",
    this.amount = 0,
    this.currency = "",
    this.membershipDurationId = 0,
    this.renewalType = "",
    this.membershipName = "",
    this.paymentMode = "",
    this.notes = "",
    this.membershipId = 0,
    this.duration = 0,
    this.name = "",
    this.email = "",
    this.actualStartDate,
    this.actualEndDate,
    this.durationValue = "",
    this.durationType = "",
    this.couponCode,
    this.couponTrialMessage,
    this.couponType,
    this.couponValue,
    this.isMembershipData = false,
    this.displayStartDate = "",
    this.displayEnddate = "",
    this.displayExpirydate = "",
    this.isChangePlan = false,
    this.purchasedAmount = "",
  });

  String userMembership;
  int membershipLevel;
  String status;
  DateTime? startDate;
  DateTime? expiryDate;
  String durationName;
  String expiryStatus;
  double amount;
  String currency;
  int membershipDurationId;
  String renewalType;
  String membershipName;
  String paymentMode;
  String notes;
  int membershipId;
  int duration;
  String name;
  String email;
  DateTime? actualStartDate;
  DateTime? actualEndDate;
  String durationValue;
  String durationType;
  dynamic couponCode;
  dynamic couponTrialMessage;
  dynamic couponType;
  dynamic couponValue;
  bool isMembershipData;
  String displayStartDate;
  String displayEnddate;
  String displayExpirydate;
  bool isChangePlan;
  String purchasedAmount;

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      MembershipModel(
        userMembership: json["UserMembership"],
        membershipLevel: json["MembershipLevel"],
        status: json["Status"],
        startDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(json["StartDate"]),//(json["StartDate"] != null) ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(json["StartDate"]) : '',
        expiryDate: (json["ExpiryDate"] != null) ? DateTime.parse(json["ExpiryDate"]) : null,
        durationName: json["DurationName"],
        expiryStatus: json["ExpiryStatus"],
        amount: (json["Amount"]).toDouble(),
        currency: json["Currency"],
        membershipDurationId: json["MembershipDurationID"],
        renewalType: json["RenewalType"],
        membershipName: json["MembershipName"],
        paymentMode: json["PaymentMode"],
        notes: json["Notes"],
        membershipId: json["MembershipID"],
        duration: json["duration"],
        name: json["Name"],
        email: json["Email"],
        actualStartDate: (json["ActualStartDate"] != null) ?  DateTime.parse(json["ActualStartDate"]): null,
        actualEndDate: (json["ActualEndDate"] != null) ? DateTime.parse(json["ActualEndDate"]) : null,
        durationValue: json["DurationValue"],
        durationType: json["DurationType"],
        couponCode: json["CouponCode"],
        couponTrialMessage: json["CouponTrialMessage"],
        couponType: json["CouponType"],
        couponValue: json["CouponValue"],
        isMembershipData: json["IsMembershipData"],
        displayStartDate: json["DisplayStartDate"],
        displayEnddate: json["DisplayEnddate"],
        displayExpirydate: json["DisplayExpirydate"],
        isChangePlan: json["IsChangePlan"],
        purchasedAmount: json["PurchasedAmount"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "UserMembership": userMembership,
        "MembershipLevel": membershipLevel,
        "Status": status,
        "StartDate": startDate, //.toIso8601String()
        "ExpiryDate": expiryDate,//.toIso8601String()
        "DurationName": durationName,
        "ExpiryStatus": expiryStatus,
        "Amount": amount,
        "Currency": currency,
        "MembershipDurationID": membershipDurationId,
        "RenewalType": renewalType,
        "MembershipName": membershipName,
        "PaymentMode": paymentMode,
        "Notes": notes,
        "MembershipID": membershipId,
        "duration": duration,
        "Name": name,
        "Email": email,
        "ActualStartDate": actualStartDate, //.toIso8601String(),
        "ActualEndDate": actualEndDate, //.toIso8601String(),
        "DurationValue": durationValue,
        "DurationType": durationType,
        "CouponCode": couponCode,
        "CouponTrialMessage": couponTrialMessage,
        "CouponType": couponType,
        "CouponValue": couponValue,
        "IsMembershipData": isMembershipData,
        "DisplayStartDate": displayStartDate,
        "DisplayEnddate": displayEnddate,
        "DisplayExpirydate": displayExpirydate,
        "IsChangePlan": isChangePlan,
        "PurchasedAmount": purchasedAmount,
      };
}
