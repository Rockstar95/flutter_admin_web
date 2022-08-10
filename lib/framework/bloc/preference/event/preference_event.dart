import 'package:equatable/equatable.dart';

abstract class PreferenceEvent extends Equatable {
  const PreferenceEvent();
}

class GetTimeZoneResponseEvent extends PreferenceEvent {
  GetTimeZoneResponseEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetProfileSettingResponseEvent extends PreferenceEvent {
  GetProfileSettingResponseEvent();

  @override
  List<Object> get props => [];
}

class PostPreferenceEvent extends PreferenceEvent {
  final String timeZone;
  final String languageSelection;
  final String userLanguage;
  final int activities;

  PostPreferenceEvent(this.timeZone, this.languageSelection, this.userLanguage,
      this.activities);

  @override
  List<Object> get props =>
      [timeZone, this.languageSelection, this.userLanguage, this.activities];
}

//PaymentHistory
class GetPaymentHistoryEvent extends PreferenceEvent {
  GetPaymentHistoryEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

//Membership
class GetActiveMembershipEvent extends PreferenceEvent {
  GetActiveMembershipEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetMembershipPlanResponseEvent extends PreferenceEvent {
  GetMembershipPlanResponseEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetPaymentGatewayResponseEvent extends PreferenceEvent {
  final String currency;

  GetPaymentGatewayResponseEvent(this.currency);

  @override
  // TODO: implement props
  List<Object> get props => [this.currency];
}

class GetPrivacyProfileEvent extends PreferenceEvent {
  GetPrivacyProfileEvent();

  @override
  List<Object> get props => [];
}

class PostPrivacyProfileEvent extends PreferenceEvent {
  final int ispublic;
  final String attributeids;

  PostPrivacyProfileEvent({
    this.ispublic = 0,
    this.attributeids = "",
  });

  @override
  List<Object> get props => [];
}
