import 'package:flutter_admin_web/framework/repository/auth/model/payment_process_response.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/res_dynamic_signup.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/save_profile_response.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/signup_response.dart';

abstract class SignUpRepository {
  Future<ResDyanicSignUp> getSignupFields();

  Future<SignupResponse?> signUpUser(String val);

  Future<SaveProfileResponse> saveProfile(String val, int membershipDurationId);

  Future<PaymentProcessResponse> paymentProcess(
      String token,
      String tempUserId,
      String paymentGateway,
      String currency,
      String totalPrice,
      String renewType,
      String durationID,
      String transactionId);
}
