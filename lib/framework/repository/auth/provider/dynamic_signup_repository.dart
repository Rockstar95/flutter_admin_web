import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/payment_process_response.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/res_dynamic_signup.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/save_profile_response.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/signup_response.dart';
import 'package:flutter_admin_web/framework/repository/auth/provider/auth_repositoy_public.dart';

class DynamicSignUpRepository implements SignUpRepository {
  @override
  Future<ResDyanicSignUp> getSignupFields() async {
    ResDyanicSignUp resDynamicSignUp = ResDyanicSignUp(
        profileconfigdata: [], termsofusewebpage: [], attributechoices: []);

    try {
      var language = await sharePrefGetString(sharedPref_AppLocale);
      Response? response = await RestClient.getSignupData(
          ApiEndpoints.getSignUpFieldsURL('47', '3104', language,
              ApiEndpoints.siteID, ApiEndpoints.strSiteUrl));
      if (response?.statusCode == 200) {
        resDynamicSignUp = resDyanicSignUpFromJson(response?.body ?? "{}");
      }
    } catch (e) {
      print("Error in DynamicSignUpRepository.getSignupFields():$e}");
    }

    return resDynamicSignUp;
  }

  @override
  Future<SignupResponse?> signUpUser(String val) async {
    SignupResponse? signUpResponse;
    try {
      print("Val:$val");

      /*Map<String, dynamic> data = {
        "UserGroupIDs" : "",
        "RoleIDs" : "",
        "Cmd" : val,
        "CMGroupIDs" : "",
      };
      print("Data:${jsonEncode(data)}");*/

      String data =
          '''"{\\\"UserGroupIDs\\\" : \\\"\\\",\\\"RoleIDs\\\" : \\\"\\\",\\\"Cmd\\\" : \\\"$val\\\",\\\"CMGroupIDs\\\" : \\\"\\\"}"''';
      //String replaceDataString = data.replaceAll("\"", "\\\"");
      //data = '''${replaceDataString}''';
      //data = replaceDataString;
//
      print('signupdata $data');

      Response? response = await RestClient.signUpUser(ApiEndpoints.doSignUpUser('en-us', ApiEndpoints.strSiteUrl), data);
      print('MyResponse Status Code:${response?.statusCode}, Body:${response?.body}');
      if (response?.statusCode == 200) {
        signUpResponse = signupResponseFromJson(response?.body ?? "{}");
      }
    } catch (e, s) {
      print("Error in DynamicSignUpRepository.signUpUser():$e}");
      print(s);
    }

    return signUpResponse;
  }

  @override
  Future<SaveProfileResponse> saveProfile(String val, int membershipDurationId) async {
    SaveProfileResponse saveProfileResponse = SaveProfileResponse.fromJson({});
    try {
      var data = {
        "strProfileJSON": val, //json.encode(value),
        "userId": -1,
        "localeId": "en-us",
        "siteId": 374,
        "intCompID": 47,
        "intCompInsID": 3104,
        "Type": membershipDurationId != -1 ? "membershipselfregistration" : "selfregistration",
        "MemberShipDurationID": membershipDurationId,
        "RenewType": "Manual",
        "ContentAssignOrgUnitID": 0,
        "enablegroupmembership": false,
        "enablecontenturl": false,
        "groupsignup": false
      };

      print('save Profile Apicall ${ApiEndpoints.saveProfile()}');
      print('save Profile Data $data');

      Response? response = await RestClient.postApiData(ApiEndpoints.saveProfile(), data);
      print('DynamicSignUpRepository.saveProfile() Response Status:${response?.statusCode}, Body:${response?.body}');
      if (response?.statusCode == 200) {
        saveProfileResponse = saveProfileResponseFromJson(response?.body.toString() ?? "{}");
      }
    }
    catch (e, s) {
      print("Error in DynamicSignUpRepository.saveProfile():$e}");
      print(s);
    }

    return saveProfileResponse;
  }

  @override
  Future<PaymentProcessResponse> paymentProcess(
      String token,
      String tempUserId,
      paymentGateway,
      currency,
      totalPrice,
      renewType,
      durationID,
      transactionId) async {
    PaymentProcessResponse paymentProcessResponse = PaymentProcessResponse.fromJson({});

    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var language = await sharePrefGetString(sharedPref_AppLocale);

    try {
      var data = {
        "UserID": "",
        "SiteID": strSiteID,
        "Locale": language,
        "PaymentGatway": paymentGateway,
        "CurrencySign": currency,
        "TotalPrice": totalPrice,
        "AddressAvailable": false,
        "TransType": "membership",
        "Rtype": "",
        "RenewType": renewType,
        "MembershipTempUserID": tempUserId,
        "DurationID": durationID,
        "ApplyOffer": "",
        "TuID": "",
        "MembershipUpgradeUserID": -1,
        "BuyAttempt": false,
        "BuyItemName": "",
        "BuyAttemptValue": "",
        "ContentID": "",
        "BuyScoID": 0,
        "IsPhysicalProduct": false,
        "IsNativeApp": false,
        "RenewalUser": "",
        "token": token,
        "CouponCode": "",
        "PaymentModetype": "store",
        "PaymentGatewayType": "F"
      };

      print('save processPayments Apicall ${ApiEndpoints.processPayments()}');
      print('Save processPayments Data $data');

      Response? response = await RestClient.postApiData(ApiEndpoints.processPayments(), data);
      if (response?.statusCode == 200) {
        print('DynamicSignUpRepository.paymentProcess() Response Status:${response?.statusCode}, Body:${response?.body}');

        paymentProcessResponse = paymentProcessResponseFromJson(response?.body ?? "{}");
      }
    }
    catch (e) {
      print("Error in DynamicSignUpRepository.paymentProcess():$e}");
    }

    return paymentProcessResponse;
  }
}
