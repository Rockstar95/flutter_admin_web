import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/preference/preference_repositry_public.dart';

class PreferenceRepositoryBuilder {
  static PreferenceRepository repository() {
    return PreferenceRepositoryPublic();
  }
}

abstract class PreferenceRepository {
  Future<Response?> getTimeZoneResponseEvent();

  Future<Response?> savePreferenceEvent(
      {String timeZone,
      String languageSelection,
      String userLanguage,
      int activities});

  Future<Response?> getProfileSettingResponseEvent();

  //PaymentHistory
  Future<Response?> getPaymentHistoryResponseEvent();

  //Membership
  Future<Response?> getActiveMembershipResponseEvent();

  Future<Response?> getMembershipPlanResponseEvent();

  Future<Response?> getPaymentGatewayResponseEvent({String currency});

  Future<Response?> getPrivaryFields();

  Future<Response?> postPrivaryFields(int isPublic, String attributeIds);
}
