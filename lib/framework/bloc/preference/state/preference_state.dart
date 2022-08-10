import 'package:flutter_admin_web/framework/bloc/feedback/model/feedbackresponse.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_plan_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/payment_gateway_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/user_profile_setting_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/Userprofileresponse.dart';

class PreferenceState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  PreferenceState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  PreferenceState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  PreferenceState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class InitialPreferenceState extends PreferenceState {
  InitialPreferenceState.completed(data) : super.completed(data);
}

class PostPreferenceState extends PreferenceState {
  String response = "";

  PostPreferenceState.loading(data) : super.loading(data);

  PostPreferenceState.completed({this.response = ""})
      : super.completed(response);

  PostPreferenceState.error(data) : super.error(data);
}

class GetPreferenceResponseState extends PreferenceState {
  List<FeedbackModel> feedbackList = [];

  GetPreferenceResponseState.loading(data) : super.loading(data);

  GetPreferenceResponseState.completed({required this.feedbackList})
      : super.completed(feedbackList);

  GetPreferenceResponseState.error(data) : super.error(data);
}

class GetProfileSettingResponseState extends PreferenceState {
  UserProfileSettingResponse? profileSettings;

  GetProfileSettingResponseState.loading(data) : super.loading(data);

  GetProfileSettingResponseState.completed({this.profileSettings})
      : super.completed(profileSettings);

  GetProfileSettingResponseState.error(data) : super.error(data);
}

//Payment History
class GetPaymentHistoryResponseState extends PreferenceState {
  UserProfileSettingResponse? profileSettings;

  GetPaymentHistoryResponseState.loading(data) : super.loading(data);

  GetPaymentHistoryResponseState.completed({this.profileSettings})
      : super.completed(profileSettings);

  GetPaymentHistoryResponseState.error(data) : super.error(data);
}

//Membership
class GetActiveMembershipResponseState extends PreferenceState {
  MembershipResponse? membership;

  GetActiveMembershipResponseState.loading(data) : super.loading(data);

  GetActiveMembershipResponseState.completed({this.membership})
      : super.completed(membership);

  GetActiveMembershipResponseState.error(data) : super.error(data);
}

class GetMembershipPlanResponseState extends PreferenceState {
  MemberShipPlanResponse? membershipPlans;

  GetMembershipPlanResponseState.loading(data) : super.loading(data);

  GetMembershipPlanResponseState.completed({this.membershipPlans})
      : super.completed(membershipPlans);

  GetMembershipPlanResponseState.error(data) : super.error(data);
}

class GetPaymentGatewayResponseState extends PreferenceState {
  PaymentGateway? paymentGateway;

  GetPaymentGatewayResponseState.loading(data) : super.loading(data);

  GetPaymentGatewayResponseState.completed({this.paymentGateway})
      : super.completed(paymentGateway);

  GetPaymentGatewayResponseState.error(data) : super.error(data);
}

class GetPrivacyProfileState extends PreferenceState {
  UserProfileResponse privacyresponse = UserProfileResponse();

  GetPrivacyProfileState.loading(data) : super.loading(data);

  GetPrivacyProfileState.completed({required this.privacyresponse})
      : super.completed(privacyresponse);

  GetPrivacyProfileState.error(data) : super.error(data);
}

class PostPrivacyProfileState extends PreferenceState {
  bool successres = false;

  PostPrivacyProfileState.loading(data) : super.loading(data);

  PostPrivacyProfileState.completed({this.successres = false})
      : super.completed(successres);

  PostPrivacyProfileState.error(data) : super.error(data);
}
