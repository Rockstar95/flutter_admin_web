import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/res_dynamic_signup.dart';

@immutable
abstract class DynamicSignUpEVent extends Equatable {
  DynamicSignUpEVent([List props = const []]);
}

class GetDynamicFields extends DynamicSignUpEVent {
  GetDynamicFields() : super([]);

  @override
  List<Object> get props => [];
}

class UpdateListFromUiEvent extends DynamicSignUpEVent {
  final List<Profileconfigdatum> profileconfigdata;

  UpdateListFromUiEvent({required this.profileconfigdata})
      : super([profileconfigdata]);

  @override
  List<Object> get props => [];
}

class SignupEvent extends DynamicSignUpEVent {
  final String value;

  SignupEvent({this.value = ""}) : super([value]);

  List<Object> get props => [value];
}

class SaveProfileEvent extends DynamicSignUpEVent {
  final String value;
  final int membershipDurationId;

  SaveProfileEvent({this.value = "", this.membershipDurationId = 0})
      : super([value]);

  List<Object> get props => [value, membershipDurationId];
}

class PaymentProcessEvent extends DynamicSignUpEVent {
  final String token;
  final String tempUserId;
  final String paymentGateway;
  final String currency;
  final String totalPrice;
  final String renewType;
  final String membershipTempUserID;
  final String durationID;
  final String transactionId;

  PaymentProcessEvent({
    this.token = "",
    this.tempUserId = "",
    this.paymentGateway = "",
    this.currency = "",
    this.totalPrice = "",
    this.renewType = "",
    this.membershipTempUserID = "",
    this.durationID = "",
    this.transactionId = "",
  }) : super([
          token,
          tempUserId,
          paymentGateway,
          currency,
          totalPrice,
          renewType,
          membershipTempUserID,
          durationID,
          transactionId
        ]);

  List<Object> get props => [
        token,
        tempUserId,
        paymentGateway,
        currency,
        totalPrice,
        renewType,
        membershipTempUserID,
        durationID,
        transactionId
      ];
}
