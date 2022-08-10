import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

abstract class AuthRepository {
  Future<bool> doLogin(String username, String password, String mobileSiteUrl,
      String downloadContent, String siteId, bool isFromSignup);

  Future<bool> gSignIn();

  Future<bool> fbSignIn();

  Future<Response?> doForgotPassword(String email);

  Future<bool> doSocialLogin(User user, String type);

  Future<Response?> fcmRegister(
      {String deviceType, String deviceToken, String siteURL});

  Future<Response?> getMemberShipDetails();
}
