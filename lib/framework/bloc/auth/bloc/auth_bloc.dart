import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/auth/event/auth_event.dart';
import 'package:flutter_admin_web/framework/bloc/auth/state/auth_state.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_plan_response.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/auth/contract/auth_repository.dart';
import 'package:flutter_admin_web/framework/repository/auth/provider/authentication_repository.dart';
import 'package:flutter_admin_web/ui/common/log_util.dart';

import '../../../repository/auth/model/forgot_password.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthState.completed(null, displayMessage: false)) {
    on<GSignIn>(onEventHandler);
    on<FBSignin>(onEventHandler);
    on<CustomSignIn>(onEventHandler);
    on<ForgotPasswordEvent>(onEventHandler);
    on<FcmRegisterEvent>(onEventHandler);
    on<GetMembershipDetailsEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(AuthEvent event, Emitter emit) async {
    print("AuthBloc onEventHandler called for ${event.runtimeType}");
    Stream<AuthState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (AuthState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  List<MemberShipPlanResponse> memberShipPlansList = [];

  @override
  AuthState get initialState => AuthInitializedState.completed('Intitalized');

  @override
  Stream<AuthState> mapEventToState(event) async* {
    print("AuthBloc mapEventToState called for evet:${event.runtimeType}");

    try {
      if (event is GSignIn) {
        print('localstring ${event.localStr.loginAlerttitleSigninfailed}');
        yield GSignInState.loading('Loading...please wait');
        final bool isSuccess = await authRepository.gSignIn();
        if (isSuccess != null && isSuccess) {
          yield GSignInState.completed(user: isSuccess);
        } else {
          yield GSignInState.error(event.localStr.loginAlerttitleSigninfailed);
        }
      }
      else if (event is FBSignin) {
        yield FbSignInState.loading('Loading...please wait');
        final bool isSuccess = await authRepository.fbSignIn();
        if (isSuccess != null && isSuccess) {
          yield FbSignInState.completed(user: isSuccess);
        } else {
          yield FbSignInState.error(event.localStr.loginAlerttitleSigninfailed);
        }
      }
      else if (event is CustomSignIn) {
        yield CustomSignInState.loading('Loading...please wait');

        bool loggedIn = await authRepository.doLogin(event.email, event.password, ApiEndpoints.strSiteUrl, '', '374', false);
        print("LoggedIn:$loggedIn");

        if (loggedIn) {
          yield CustomSignInState.completed(isLoggedin: loggedIn);
        }
        else {
          yield CustomSignInState.error(event.localStr.loginAlerttitleSigninfailed);
        }
      }
      else if (event is ForgotPasswordEvent) {
        yield ForgotPasswordState.loading('Loading...please wait');
        Response? response = await authRepository.doForgotPassword(event.email);

        bool isSuccess = false, isActiveUser = false;
        ForgotPasswordResponse forgotPwdResponse = forgotPasswordResponseFromJson(response?.body ?? "{}");
        if (forgotPwdResponse.userstatus.isNotEmpty) {
          isActiveUser = forgotPwdResponse.userstatus[0].active;
          if (forgotPwdResponse.userstatus[0].userstatus == 1 || forgotPwdResponse.userstatus[0].active) {
            isSuccess = await AuthenticationRepository().doResetUserdata(forgotPwdResponse.userstatus[0]);
          }
        }

        yield ForgotPasswordState.completed(isSuccess: isSuccess, isActiveUser: isActiveUser);
      }
      else if (event is FcmRegisterEvent) {
        yield FcmRegisterState.loading(data: 'Please wait');

        Response? apiResponse = await authRepository.fcmRegister(
            deviceType: event.deviceType,
            deviceToken: event.deviceToken,
            siteURL: event.siteURL);
        if (apiResponse?.statusCode == 200) {
          yield FcmRegisterState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield FcmRegisterState.error(data: '401');
        } else {
          yield FcmRegisterState.error(data: 'Something went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      }
      else if (event is GetMembershipDetailsEvent) {
        yield GetMembershipDetailsState.loading(data: 'Please wait');

        Response? apiResponse = await authRepository.getMemberShipDetails();
        log("GetMembershipDetailsEvent status:${apiResponse?.statusCode}, Body:${apiResponse?.body}");

        if (apiResponse?.statusCode == 200) {
          var jsonArray = List<dynamic>.from(jsonDecode(apiResponse?.body ?? "[]"));
          memberShipPlansList = jsonArray
              .map((e) => new MemberShipPlanResponse.fromJson(e))
              .toList();

          yield GetMembershipDetailsState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield GetMembershipDetailsState.error(data: '401');
        } else {
          yield GetMembershipDetailsState.error(data: 'Something went wrong');
        }
        print('asdasda $memberShipPlansList');
      }
      else {
        yield GetMembershipDetailsState.error(data: 'Not A Valid Request');
      }
    } catch (e) {
      LogUtil().printLog(message: 'Error is ===> $e');
      print("Error in AuthBloc.mapEventToState():$e");

      yield GetMembershipDetailsState.error(data: 'Something went wrong');
    }
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }
}
