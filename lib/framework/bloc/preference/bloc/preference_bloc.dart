import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/preference/event/preference_event.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_plan_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/payment_gateway_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/payment_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/time_zone_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/user_profile_setting_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/state/preference_state.dart';
import 'package:flutter_admin_web/framework/repository/preference/preference_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/Userprofileresponse.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  bool isFirstLoading = true;
  List<TimezoneData> timezoneList = [];
  UserProfileSettingResponse userProfileSettings =
      UserProfileSettingResponse(acSettings: [], languagedata: []);
  MembershipModel membership = MembershipModel();
  UserProfileResponse userprofileresponse = UserProfileResponse();

  //PaymentHistory
  List<PaymentData> paymentList = [];

  //MembershipPlan
  MemberShipPlanResponse memberShipPlanResponse =
      MemberShipPlanResponse(memberShipPlans: [], radioData: []);
  bool manualPayment = false;

  PreferenceRepository preferenceRepository;

  PreferenceBloc({required this.preferenceRepository})
      : super(PreferenceState.completed(null)) {
    on<GetTimeZoneResponseEvent>(onEventHandler);
    on<GetProfileSettingResponseEvent>(onEventHandler);
    on<PostPreferenceEvent>(onEventHandler);
    on<GetPaymentHistoryEvent>(onEventHandler);
    on<GetActiveMembershipEvent>(onEventHandler);
    on<GetMembershipPlanResponseEvent>(onEventHandler);
    on<GetPaymentGatewayResponseEvent>(onEventHandler);
    on<GetPrivacyProfileEvent>(onEventHandler);
    on<PostPrivacyProfileEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(PreferenceEvent event, Emitter emit) async {
    print("PreferenceBloc onEventHandler called for ${event.runtimeType}");
    Stream<PreferenceState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (PreferenceState authState) {
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
  PreferenceState get initialState => InitialPreferenceState.completed('data');

  @override
  Stream<PreferenceState> mapEventToState(PreferenceEvent event) async* {
    try {
      if (event is GetTimeZoneResponseEvent) {
        yield PostPreferenceState.loading('Please wait');
        Response? apiResponse =
            await preferenceRepository.getTimeZoneResponseEvent();

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          Map valueMap = json.decode(apiResponse?.body ?? "{}");
          TimeZoneResponse response =
              TimeZoneResponse.fromJson(Map.castFrom(valueMap));

          this.timezoneList = response.timezonedata;
          yield PostPreferenceState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield PostPreferenceState.error('401');
        } else {
          yield PostPreferenceState.error('Something went wrong');
        }
      }
      else if (event is PostPrivacyProfileEvent) {
        try {
          yield PostPrivacyProfileState.loading('Please wait');
          print(
              'request data - attribute ids : ${event.attributeids} , public visibility - ${event.ispublic}');
          Response? apiResponse = await preferenceRepository.postPrivaryFields(
              event.ispublic, event.attributeids);
          print('issuccessval ${apiResponse?.body}');
          if (apiResponse?.statusCode == 200) {
            //postprivacyresponse = apiResponse.data;
            yield PostPrivacyProfileState.completed(successres: true);
          } else if (apiResponse?.statusCode == 401) {
            yield PostPrivacyProfileState.error('401');
          } else {
            yield PostPrivacyProfileState.error('Something went wrong');
          }
        } catch (e) {
          print(e);
        }
      }
      else if (event is GetPrivacyProfileEvent) {
        yield GetPrivacyProfileState.loading('Please wait');
        Response? apiResponse = await preferenceRepository.getPrivaryFields();
        print('privacy response ${apiResponse?.body}');
        if (apiResponse?.statusCode == 200) {
          userprofileresponse =
              privacyProfileResponseFromJson(apiResponse?.body ?? "{}");
          print(
              'privacy response list : ${userprofileresponse.userProfileList}');
          yield GetPrivacyProfileState.completed(
              privacyresponse: userprofileresponse);
        }
        else if (apiResponse?.statusCode == 401) {
          yield GetPrivacyProfileState.error('401');
        }
        else {
          yield GetPrivacyProfileState.error('Something went wrong');
        }
      }
      else if (event is GetProfileSettingResponseEvent) {
        yield PostPreferenceState.loading('Please wait');
        Response? apiResponse =
            await preferenceRepository.getProfileSettingResponseEvent();

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          Map valueMap = json.decode(apiResponse?.body ?? "{}");
          UserProfileSettingResponse response =
              UserProfileSettingResponse.fromJson(Map.castFrom(valueMap));
          print("responseasd " + response.toString());
          this.userProfileSettings = response;
          yield PostPreferenceState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield PostPreferenceState.error('401');
        } else {
          yield PostPreferenceState.error('Something went wrong');
        }
      }
      else if (event is PostPreferenceEvent) {
        //yield PostPreferenceState.loading('Please wait');
        Response? apiResponse = await preferenceRepository.savePreferenceEvent(
            timeZone: event.timeZone,
            languageSelection: event.languageSelection,
            userLanguage: event.userLanguage,
            activities: event.activities);
        //preferenceResponseToJson()

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield PostPreferenceState.completed(
              response: apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield PostPreferenceState.error('401');
        } else {
          yield PostPreferenceState.error('Something went wrong');
        }
      }
      //PaymentHistory
      else if (event is GetPaymentHistoryEvent) {
        yield GetPaymentHistoryResponseState.loading('Please wait');
        Response? apiResponse =
            await preferenceRepository.getPaymentHistoryResponseEvent();

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          Map valueMap = json.decode(apiResponse?.body ?? "{}");
          PaymentResponse response =
              PaymentResponse.fromJson(Map.castFrom(valueMap));
          print("paymentList " + response.toString());
          this.paymentList = response.table;

          yield GetPaymentHistoryResponseState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield GetPaymentHistoryResponseState.error('401');
        } else {
          yield GetPaymentHistoryResponseState.error('Something went wrong');
        }
      }
      //Membership
      else if (event is GetActiveMembershipEvent) {
        yield GetActiveMembershipResponseState.loading('Please wait');
        Response? apiResponse =
            await preferenceRepository.getActiveMembershipResponseEvent();

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          Map valueMap = json.decode(apiResponse?.body ?? "{}");
          MembershipResponse response =
              MembershipResponse.fromJson(Map.castFrom(valueMap));
          print("paymentList " + response.toString());
          this.membership = response.membership.first;

          yield GetActiveMembershipResponseState.completed(
              membership: response);
        } else if (apiResponse?.statusCode == 401) {
          yield GetActiveMembershipResponseState.error('401');
        } else {
          yield GetActiveMembershipResponseState.error('Something went wrong');
        }
      }
      else if (event is GetMembershipPlanResponseEvent) {
        yield GetMembershipPlanResponseState.loading('Please wait');
        Response? apiResponse =
            await preferenceRepository.getMembershipPlanResponseEvent();

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          var jsonArray =
              new List<dynamic>.from(jsonDecode(apiResponse?.body ?? "[]"));
          var memberShipPlanRes = jsonArray
              .map((e) => new MemberShipPlanResponse.fromJson(e))
              .toList();

          memberShipPlanResponse = memberShipPlanRes.first;
          yield GetMembershipPlanResponseState.completed(
              membershipPlans: memberShipPlanResponse);
        } else if (apiResponse?.statusCode == 401) {
          yield GetMembershipPlanResponseState.error('401');
        } else {
          yield GetMembershipPlanResponseState.error('Something went wrong');
        }
      }
      else if (event is GetPaymentGatewayResponseEvent) {
        yield GetPaymentGatewayResponseState.loading('Please wait');
        Response? apiResponse = await preferenceRepository
            .getPaymentGatewayResponseEvent(currency: event.currency);

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          var jsonArray = new List<dynamic>.from(
              jsonDecode(apiResponse?.body ?? "[]")["Table"]);
          var payGatewayList =
              jsonArray.map((e) => new PaymentGateway.fromJson(e)).toList();
          //print(payGatewayList.map((e) => e.paymentGateway).toString());
          manualPayment = payGatewayList.first.paymentGateway != "BrainTree";
          yield GetPaymentGatewayResponseState.completed(
              paymentGateway: payGatewayList.first);
        } else if (apiResponse?.statusCode == 401) {
          yield GetPaymentGatewayResponseState.error('401');
        } else {
          yield GetPaymentGatewayResponseState.error('Something went wrong');
        }
      }
    } catch (e) {
      print("Error in PreferenceBloc.mapEventToState():$e");
      isFirstLoading = false;
    }
  }
}
