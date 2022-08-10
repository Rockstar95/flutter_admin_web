import 'package:flutter_admin_web/framework/common/local_str.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class GSignIn extends AuthEvent {
  LocalStr localStr;

  GSignIn({required this.localStr});

  @override
  List<Object> get props => [localStr];
}

class FBSignin extends AuthEvent {
  LocalStr localStr;

  FBSignin({required this.localStr});

  @override
  List<Object> get props => [localStr];
}

class CustomSignIn extends AuthEvent {
  String email;
  String password;
  LocalStr localStr;

  CustomSignIn({this.email = "", this.password = "", required this.localStr});

  @override
  List<Object> get props => [email, password, localStr];
}

class ForgotPasswordEvent extends AuthEvent {
  String email;
  LocalStr localStr;

  ForgotPasswordEvent({this.email = "", required this.localStr});

  @override
  List<Object> get props => [email];
}

class FcmRegisterEvent extends AuthEvent {
  String deviceType;
  String deviceToken;
  String siteURL;

  FcmRegisterEvent(
      {this.deviceType = "", this.deviceToken = "", this.siteURL = ""});

  @override
  List<Object> get props => [deviceType, deviceToken, siteURL];
}

class GetMembershipDetailsEvent extends AuthEvent {
  GetMembershipDetailsEvent();

  List<Object> get props => [];
}
