import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/auth/event/dynamic_signup_event.dart';
import 'package:flutter_admin_web/framework/bloc/auth/state/dynamic_signup_state.dart';
import 'package:flutter_admin_web/framework/repository/auth/contract/signup_repository.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/payment_process_response.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/res_dynamic_signup.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/save_profile_response.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/signup_response.dart';

class DynamicSignUpBloc extends Bloc<DynamicSignUpEVent, DynamicSignUpState> {
  SignUpRepository signUpRepository;

  ResDyanicSignUp resDyanicSignUp;
  List<Profileconfigdatum> profileconfigdata = [];
  bool isSucees;
  List<Attributechoice> attributechoices = [];
  List<Termsofusewebpage> termsofWebPage = [];

  bool isRegistered;
  bool isLoading = false;
  int newTempUserId;

  DynamicSignUpBloc({
    required this.signUpRepository,
    required this.resDyanicSignUp,
    required this.profileconfigdata,
    this.isSucees = false,
    required this.attributechoices,
    required this.termsofWebPage,
    this.isRegistered = false,
    this.isLoading = false,
    this.newTempUserId = 0,
  })  : assert(signUpRepository != null),
        super(IntitialDynamicSignUpState()) {
    on<GetDynamicFields>(onEventHandler);
    on<UpdateListFromUiEvent>(onEventHandler);
    on<SignupEvent>(onEventHandler);
    on<SaveProfileEvent>(onEventHandler);
    on<PaymentProcessEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(DynamicSignUpEVent event, Emitter emit) async {
    print("DynamicSignUpBloc onEventHandler called for ${event.runtimeType}");
    Stream<DynamicSignUpState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (DynamicSignUpState authState) {
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

  @override
  DynamicSignUpState get initialState => IntitialDynamicSignUpState();

  @override
  Stream<DynamicSignUpState> mapEventToState(event) async* {
    try {
      if (event is GetDynamicFields) {
        isSucees = true;
        resDyanicSignUp = await signUpRepository.getSignupFields();
        profileconfigdata = resDyanicSignUp.profileconfigdata;
        attributechoices = resDyanicSignUp.attributechoices;
        termsofWebPage = resDyanicSignUp.termsofusewebpage;
        print('termsofwebpage $termsofWebPage');
        for (int i = 0; i < profileconfigdata.length; i++) {
          Profileconfigdatum item = profileconfigdata[i];

          if (item.uicontroltypeid == 3 || item.uicontroltypeid == 18) {
            print(
                "........uicontroltypeid.........${item.uicontroltypeid}...item.attributeconfigid....${item.attributeconfigid}");

            List<Attributechoice> temp =
                await getItemList(attributechoices, item.attributeconfigid);

            if (temp.isNotEmpty) {
              item.spinnerItems = temp;
              item.selectedSpinerObj = temp[0];
              item.displaySpinnerText = temp[0].choicetext;
              item.valueName = temp[0].choicevalue;
            }
            profileconfigdata[i] = item;
          }
        }

        yield GetDynamicFieldsState(
            resDyanicSignUp: resDyanicSignUp,
            isSuccess: isSucees,
            profileconfigdata: profileconfigdata);
      }
      else if (event is UpdateListFromUiEvent) {
        profileconfigdata = event.profileconfigdata;
        yield UpdateListFromUiState(profileconfigdata: profileconfigdata);
      }
      else if (event is SignupEvent) {
        isRegistered = false;
        isLoading = true;

        print("Value:${event.value}");
        /*yield SignUpState(isSuccess: isRegistered, message: "msg");
        return;*/

        String msg = '';
        SignupResponse? response = await signUpRepository.signUpUser(event.value);
        if (response != null && response.usersignupdetails[0].autolaunchcontentid != null) {
          isRegistered = true;
        }
        msg = response?.usersignupdetails[0].message ?? "";
        isLoading = false;

        yield SignUpState(isSuccess: isRegistered, message: msg);
      }
      else if (event is SaveProfileEvent) {
        isRegistered = false;
        isLoading = true;

        SaveProfileResponse response = await signUpRepository.saveProfile(event.value, event.membershipDurationId);

        isRegistered = response.profileResponse.userId > 0;
        print(response.profileResponse.userId);
        newTempUserId = response.profileResponse.userId;
        yield SaveProfileState(
          isSuccess: isRegistered,
          newTempUserId: response.profileResponse.userId.toString(),
          message: response.profileResponse.message,
          isMembership: event.membershipDurationId != -1,
        );
        isLoading = false;
      }
      else if (event is PaymentProcessEvent) {
        isLoading = true;

        if(event.token.isNotEmpty) {
          PaymentProcessResponse response = await signUpRepository.paymentProcess(
            event.token,
            event.tempUserId,
            event.paymentGateway,
            event.currency,
            event.totalPrice,
            event.renewType,
            event.durationID,
            event.transactionId,
          );
          print("Payment Result:${response.result}");
          print("Payment New User Id:${response.newUserId}");
          yield PaymentProcessState(
            isSuccess: response.result != 'failed' && response.result.length < 10,
            newUserId: response.newUserId.toString(),
            message: "Congratulations! Your membership account has been created/updated/renewed. Account login details have been sent to your email address. Now you can access your new membership account.",
          );
        }
        else {
          yield PaymentProcessState(
            isSuccess: true,
            newUserId: event.tempUserId,
            message: "Congratulations! Your membership account has been created/updated/renewed. Account login details have been sent to your email address. Now you can access your new membership account.",
          );
        }
        isLoading = false;
      }
    }
    catch (e, s) {
      print("Error in DynamicSignUpBloc.mapEventToState():$e");
      print(s);
    }
  }

  /* Future<List<String>> getItemList(List<Attributechoice> attributechoices, int attributeconfigid) async{


    List <String> spinnerItems = [];
    for(int i=0;i<attributechoices.length;i++)
      {
        Attributechoice item=attributechoices[i];
        if(item.attributeconfigid == attributeconfigid)
          {
            spinnerItems.add(item.choicetext);
          }
      }

    return  spinnerItems;


  }*/

  Future<List<Attributechoice>> getItemList(
      List<Attributechoice> attributechoices, int attributeconfigid) async {
    List<Attributechoice> spinnerItems = [];
    for (int i = 0; i < attributechoices.length; i++) {
      Attributechoice item = attributechoices[i];
      if (item.attributeconfigid == attributeconfigid) {
        spinnerItems.add(item);
      }
    }

    return spinnerItems;
  }
}
