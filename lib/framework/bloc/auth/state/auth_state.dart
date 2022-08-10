import 'package:flutter_admin_web/framework/common/api_state.dart';

// TODO: Need to check merge API and the normal state
class AuthState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  AuthState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  AuthState.loading(data, {this.displayMessage = true}) : super.loading(data);

  AuthState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class GSignInState extends AuthState {
  bool user;

  GSignInState.loading(data, {this.user = false}) : super.loading(data);

  GSignInState.completed({this.user = false}) : super.completed(user);

  GSignInState.error(data, {this.user = false}) : super.error(data);
}

class FbSignInState extends AuthState {
  bool user;

  FbSignInState.completed({this.user = false}) : super.completed(user);

  FbSignInState.loading(data, {this.user = false}) : super.loading(data);

  FbSignInState.error(data, {this.user = false}) : super.error(data);
}

class CustomSignInState extends AuthState {
  bool isLoggedin;

  CustomSignInState.loading(data, {this.isLoggedin = false})
      : super.loading(data);

  CustomSignInState.completed({this.isLoggedin = false})
      : super.completed(isLoggedin);

  CustomSignInState.error(data, {this.isLoggedin = false}) : super.error(data);
}

class ForgotPasswordState extends AuthState {
  bool isSuccess, isActiveUser = false;

  ForgotPasswordState.loading(data, {this.isSuccess = false})
      : super.loading(data);

  ForgotPasswordState.completed({this.isSuccess = false, this.isActiveUser = false})
      : super.completed(isSuccess);

  ForgotPasswordState.error(data, {this.isSuccess = false}) : super.error(data);
}

class AuthInitializedState extends AuthState {
  AuthInitializedState.completed(data) : super.completed(data);
}

class FcmRegisterState extends AuthState {
  String data;

  FcmRegisterState.loading({this.data = ""}) : super.loading(data);

  FcmRegisterState.completed({this.data = ""}) : super.completed(data);

  FcmRegisterState.error({this.data = ""}) : super.error(data);
}

class GetMembershipDetailsState extends AuthState {
  String data;

  GetMembershipDetailsState.loading({this.data = ""}) : super.loading(data);

  GetMembershipDetailsState.completed({this.data = ""}) : super.completed(data);

  GetMembershipDetailsState.error({this.data = ""}) : super.error(data);
}
