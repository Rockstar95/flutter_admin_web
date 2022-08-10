import 'dart:convert';

import 'package:flutter_admin_web/ui/Setting/site_setting.dart';

List<MemberShipPlanResponse> memberShipPlanResponseFromJson(String str) =>
    List<MemberShipPlanResponse>.from(
        json.decode(str).map((x) => MemberShipPlanResponse.fromJson(x)));

String memberShipPlanResponseToJson(List<MemberShipPlanResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MemberShipPlanResponse {
  MemberShipPlanResponse(
      {this.memberShipId = 0,
      this.memberShipName = "",
      this.displayText = "",
      this.memberShipLevel = 0,
      this.memberShipShortDesc = "",
      this.memberShipDurationId = 0,
      this.expiryDate,
      this.couponType,
      this.membershipActive = "",
      this.subscriptionTypeId = 0,
      required this.memberShipPlans,
      required this.radioData});

  int memberShipId = 0;
  String memberShipName = "";
  String displayText = "";
  int memberShipLevel = 0;
  String memberShipShortDesc = "";
  int memberShipDurationId = 0;
  dynamic expiryDate;
  dynamic couponType;
  String membershipActive = "";
  int subscriptionTypeId = 0;
  List<MemberShipPlan> memberShipPlans = [];
  List<RadioModel> radioData = [];

  factory MemberShipPlanResponse.fromJson(Map<String, dynamic> json) =>
      MemberShipPlanResponse(
        memberShipId: json["MemberShipID"],
        memberShipName: json["MemberShipName"],
        displayText: json["DisplayText"],
        memberShipLevel: json["MemberShipLevel"],
        memberShipShortDesc: json["MemberShipShortDesc"],
        memberShipDurationId: json["MemberShipDurationID"],
        expiryDate: json["ExpiryDate"],
        couponType: json["CouponType"],
        membershipActive: json["MembershipActive"],
        subscriptionTypeId: json["SubscriptionTypeID"],
        memberShipPlans: List<MemberShipPlan>.from(json["MemberShipPlans"].map((x) => MemberShipPlan.fromJson(x))),
        radioData: [],
      );

  Map<String, dynamic> toJson() => {
        "MemberShipID": memberShipId,
        "MemberShipName": memberShipName,
        "DisplayText": displayText,
        "MemberShipLevel": memberShipLevel,
        "MemberShipShortDesc": memberShipShortDesc,
        "MemberShipDurationID": memberShipDurationId,
        "ExpiryDate": expiryDate,
        "CouponType": couponType,
        "MembershipActive": membershipActive,
        "SubscriptionTypeID": subscriptionTypeId,
        "MemberShipPlans":
            List<dynamic>.from(memberShipPlans.map((x) => x.toJson())),
      };
}

class MemberShipPlan {
  MemberShipPlan({
    this.memberShipDurationId = 0,
    this.memberShipId = 0,
    this.durationName = "",
    this.durationValue = "",
    this.amount = "",
    this.couponDiscountAmount,
    this.memberShipDurationLevel = 0,
    this.durationType = "",
    this.brainTreePlanId = "",
    this.isActive = "",
    this.totalAmount,
    this.membershipTaxAmount,
    this.merchantTaxPercentage,
    this.discountAmount,
    this.discountTotalAmount,
    this.discountMembershipTaxAmount,
    this.wrongCouponApplied,
    this.couponMessage,
    this.couponType,
    this.googleSubscriptionID = "",
    this.appleSubscriptionID = "",
    this.renewalDate,
    this.initialAmount,
    this.excludeVatTag = "",
    this.subscriptionType = 0,
  });

  int memberShipDurationId = 0;
  int memberShipId = 0;
  String durationName = "";
  String durationValue = "";
  String amount = "";
  dynamic couponDiscountAmount;
  int memberShipDurationLevel = 0;
  String durationType = "";
  String brainTreePlanId = "";
  String isActive = "";
  dynamic totalAmount;
  dynamic membershipTaxAmount;
  dynamic merchantTaxPercentage;
  dynamic discountAmount;
  dynamic discountTotalAmount;
  dynamic discountMembershipTaxAmount;
  dynamic wrongCouponApplied;
  dynamic couponMessage;
  dynamic couponType;
  String googleSubscriptionID;
  String appleSubscriptionID;
  dynamic renewalDate;
  dynamic initialAmount;
  String excludeVatTag = "";
  int subscriptionType = 0;

  factory MemberShipPlan.fromJson(Map<String, dynamic> json) => MemberShipPlan(
        memberShipDurationId: json["MemberShipDurationID"],
        memberShipId: json["MemberShipID"],
        durationName: json["DurationName"],
        durationValue: json["DurationValue"],
        amount: json["Amount"],
        couponDiscountAmount: json["Coupondiscountamount"],
        memberShipDurationLevel: json["MemberShipDurationLevel"],
        durationType: json["DurationType"],
        brainTreePlanId: json["BrainTreePlanID"],
        isActive: json["isActive"],
        totalAmount: json["TotalAmount"],
        membershipTaxAmount: json["MembershiptaxAmount"],
        merchantTaxPercentage: json["MerchantTaxPercentage"],
        discountAmount: json["DiscountAmount"],
        discountTotalAmount: json["DiscountTotalAmount"],
        discountMembershipTaxAmount: json["DiscountMembershiptaxAmount"],
        wrongCouponApplied: json["WrongCouponApplied"],
        couponMessage: json["CouponMessage"],
        couponType: json["CouponType"],
        googleSubscriptionID: json["GoogleSubscriptionID"]?.toString() ?? '',
        appleSubscriptionID: json["AppleSubscriptionID"]?.toString() ?? '',
        renewalDate: json["RenewalDate"],
        initialAmount: json["InitialAmount"],
        excludeVatTag: json["ExcludeVATTag"],
        subscriptionType: json["SubscriptionType"],
      );

  Map<String, dynamic> toJson() => {
        "MemberShipDurationID": memberShipDurationId,
        "MemberShipID": memberShipId,
        "DurationName": durationName,
        "DurationValue": durationValue,
        "Amount": amount,
        "Coupondiscountamount": couponDiscountAmount,
        "MemberShipDurationLevel": memberShipDurationLevel,
        "DurationType": durationType,
        "BrainTreePlanID": brainTreePlanId,
        "isActive": isActive,
        "TotalAmount": totalAmount,
        "MembershiptaxAmount": membershipTaxAmount,
        "MerchantTaxPercentage": merchantTaxPercentage,
        "DiscountAmount": discountAmount,
        "DiscountTotalAmount": discountTotalAmount,
        "DiscountMembershiptaxAmount": discountMembershipTaxAmount,
        "WrongCouponApplied": wrongCouponApplied,
        "CouponMessage": couponMessage,
        "CouponType": couponType,
        "RenewalDate": renewalDate,
        "InitialAmount": initialAmount,
        "ExcludeVATTag": excludeVatTag,
        "SubscriptionType": subscriptionType,
      };
}
