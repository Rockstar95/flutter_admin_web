import 'package:flutter_admin_web/framework/repository/auth/model/res_dynamic_signup.dart';

class DynamicSignUpState {
  @override
  List<Object> get props => [];
}

class IntitialDynamicSignUpState extends DynamicSignUpState {}

class GetDynamicFieldsState extends DynamicSignUpState {
  final bool isSuccess;
  final ResDyanicSignUp resDyanicSignUp;
  final List<Profileconfigdatum> profileconfigdata;

  //GetDynamicFieldsState({this.isSuccess,this.resDyanicSignUp,this.profileconfigdata}) : super([isSuccess,resDyanicSignUp,profileconfigdata]);
  GetDynamicFieldsState(
      {this.isSuccess = false,
      required this.resDyanicSignUp,
      required this.profileconfigdata});
}

class UpdateListFromUiState extends DynamicSignUpState {
  final List<Profileconfigdatum> profileconfigdata;

  UpdateListFromUiState({required this.profileconfigdata}) : super();

  @override
  String toString() => 'UpdateListFromUiState ';
}

class SignUpState extends DynamicSignUpState {
  final bool isSuccess;
  final String message;

  SignUpState({this.message = "", this.isSuccess = false}) : super();
}

class SaveProfileState extends DynamicSignUpState {
  final bool isSuccess, isMembership;
  final String newTempUserId, message;

  SaveProfileState({this.isSuccess = false, this.isMembership = false, this.newTempUserId = "", this.message = ""}) : super();
}

class PaymentProcessState extends DynamicSignUpState {
  final bool isSuccess;
  final String newUserId, message;

  PaymentProcessState({this.isSuccess = false, this.newUserId = "", this.message = ""}) : super();
}
