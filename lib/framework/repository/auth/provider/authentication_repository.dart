import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/forgot_password.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/social_login_request.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/social_signin_response.dart';
import 'package:flutter_admin_web/framework/repository/auth/provider/auth_repositoy_public.dart';
import 'package:uuid/uuid.dart';

class AuthenticationRepository implements AuthRepository {
  @override
  Future<bool> doLogin(String username, String password, String mobileSiteUrl, String downloadContent, String siteId, bool isFromSignup, {bool isEncrypted = false}) async {
    bool isLoggedin = false;

    try {
      Login login = Login();
      login.userName = username;
      login.password = password;
      login.mobileSiteUrl = mobileSiteUrl;
      login.downloadContent = downloadContent;
      login.siteId = siteId;
      login.isFromSignUp = isFromSignup;
      login.isEncrypted = isEncrypted;

      var data = loginToJson(login);
      print('login req $data');

      Response? response = await RestClient.postData(ApiEndpoints.apiLogin(), data);
      print('doLogin Response , status code:${response?.statusCode}, Data:${response?.body}');
      if (response?.statusCode == 200) {
        if ((response?.body ?? "{}").contains('successfulluserlogin')) {
          LoginResponse loginResponse = loginResponseFromJson(response?.body ?? "{}");

          await sharePrefSaveString(sharedPref_image, loginResponse.successFullUserLogin[0].image);
          await sharePrefSaveString(sharedPref_userid, loginResponse.successFullUserLogin[0].userid.toString());
          await sharePrefSaveString(sharedPref_bearer, loginResponse.successFullUserLogin[0].jwttoken.toString());
          await sharePrefSaveString(sharedPref_LoginUserName, loginResponse.successFullUserLogin[0].username);
          await sharePrefSaveString(sharedPref_LoginEmailId, username);
          await sharePrefSaveString(sharedPref_LoginPassword, password);
          await sharePrefSaveString(sharedPref_LoginUserID, username);
          await sharePrefSaveString(sharedPref_tempProfileImage, '${ApiEndpoints.strSiteUrl}/Content/SiteFiles/374/ProfileImages/${loginResponse.successFullUserLogin[0].image}');

          await sharePrefSaveString(sharedPref_main_siteurl, ApiEndpoints.mainSiteURL);

          await sharePrefSaveString(sharedPref_main_userid, loginResponse.successFullUserLogin[0].userid.toString());
          await sharePrefSaveString(sharedPref_main_bearer, loginResponse.successFullUserLogin[0].jwttoken.toString());
          await sharePrefSaveString(sharedPref_main_tempProfileImage, '${ApiEndpoints.strSiteUrl}/Content/SiteFiles/374/ProfileImages/${loginResponse.successFullUserLogin[0].image}');

          await sharePrefSaveString(sharedPref_sessionid, loginResponse.successFullUserLogin[0].sessionid.toString());

          print('bindedresposne $loginResponse');
          isLoggedin = true;
        } else {
          isLoggedin = false;
        }
      } else {
        isLoggedin = false;
      }
    } catch (e) {
      print("Error in AuthenticationRepository.doLogin():$e");
    }

    print('isloggedin $isLoggedin');
    return isLoggedin;
  }

  Future<Map<String,dynamic>> gettingSiteMetadata(String siteToken) async {
    Map<String,dynamic> isSuccess = {};
    Map<String,dynamic> body = {};
    Map<String,dynamic> data = {
      "intUserID": -1,
      "intFromSIteID" : -1,
      "strAuthKey":"$siteToken"
    };

    try {
      Response? response = await RestClient.postMethodWithoutToken(ApiEndpoints.apiGetGenericSiteMetaData(), data);
      print("000000000 ${response?.body}");

      if (response?.statusCode == 200) {
        print("111111");
        body = json.decode(response?.body ?? "{}");
        print("2");
        print("bodyyyyyyyy : ${body}");
        print("3");
        if (body.isNotEmpty && (body["Table"] is List && body["Table"].isNotEmpty)) {
          int? userid = body["Table"][0]["UserID"] is int ? body["Table"][0]["UserID"] : null;
          int? fromSiteId = body["Table"][0]["FromSiteID"] is int ? body["Table"][0]["FromSiteID"] : null;
          int? toSiteId = body["Table"][0]["ToSiteID"] is int ? body["Table"][0]["ToSiteID"] : null;

          if(userid != null && fromSiteId != null && toSiteId != null) {
            isSuccess = await setUserIdPassFromMetaData(userid,fromSiteId,toSiteId);
          }

          print("IsSuccess : $isSuccess");
          return isSuccess;
        }
      }
      else {
        isSuccess = {};
      }
    }
    catch (e, s){
      print("Error in AuthenticationRepository.gettingSiteMetadata():$e");
      MyPrint.printOnConsole(s);
    }

    return isSuccess;
  }

  Future<Map<String,dynamic>> setUserIdPassFromMetaData(int intUserID, int intSiteID, int intMainSiteID) async {
    Map<String,dynamic> isSuccess = {},body = {};
    Map<String,dynamic> dataToPass = {
      "intUserID":"$intUserID",
      "intSiteID":"${intSiteID}",
      "intMainSiteID":"$intMainSiteID"
    };

    try{
      Response? response = await RestClient.postMethodWithQueryParamData(ApiEndpoints.apiGetUserCredentials(), dataToPass);
      if (response?.statusCode == 200) {
        body = json.decode(response?.body ?? "{}");
        if (body.isNotEmpty) {
          isSuccess = {"email":body["Table"][0]["Email"],"pass":body["Table"][0]["Password"]};
          return isSuccess;
        }
      } else {
        isSuccess = {};
      }
    } catch (e){
      print("Error in AuthenticationRepository.setUserIdPassFromMetaData():$e");

    }


    return isSuccess;
  }

  @override
  Future<bool> gSignIn() async {
    final _firebaseAuth = FirebaseAuth.instance;
    bool isSuccess = false;
    final googleSignIn = GoogleSignIn();
    final signinaccount = await googleSignIn.signIn();
    User? user;

    try {
      if (signinaccount != null) {
        final auth = await signinaccount.authentication;
        if (auth.accessToken != null && auth.idToken != null) {
          final authresult = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: auth.idToken, accessToken: auth.accessToken));
          user = authresult.user;

          print('username ${user?.email}');

          if (user != null) {
            isSuccess = await doSocialLogin(user, kGoogle);
            print('isSucessuser $isSuccess');
          } else {
            throw PlatformException(
                code: "NO_USER", message: "Couldn't get user");
          }
        } else {
          throw PlatformException(
              code: 'MISSING_ACCESS_TOKEN',
              message: 'Missing google auth token');
        }
      } else {
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Signin aborted by user');
      }
    } catch (e) {
      print("Error in AuthenticationRepository.gSignIn():$e");
    }

    return isSuccess;
  }

  @override
  Future<bool> fbSignIn() async {
    User? user;
    bool isSuccess = false;

    //final facebookLogin = FacebookLogin();

    try {
      //await facebookLogin.logOut();

      final _firebaseAuth = FirebaseAuth.instance;

      /*facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
      final facebookLoginResult =
          await facebookLogin.logIn(['email', 'public_profile']);
      //.logInWithReadPermissions(
      //['public_profile', 'email'],);
      String fbUrl;

      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          print("Error apps " + facebookLoginResult.errorMessage);
          break;
        case FacebookLoginStatus.loggedIn:
          final token = facebookLoginResult.accessToken.token;
          fbUrl = 'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(100).height(100)&access_token=$token';
          print(fbUrl);

          var graphResponse = await http.get(Uri.parse(fbUrl));

          if (graphResponse.statusCode == 200) {
            FbUser fbuser = fbUserFromJson(graphResponse.body);
//          print('name is res.............${fbuser.name}');
//          print('email is res.............${fbuser.email}');
            print('graphrespinse ${graphResponse.body}');

            print('graphrespinse ${graphResponse.body}');

            final facebookAuthCred = FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);

            print('facebookAuthCred $facebookAuthCred');

            final authResult = await _firebaseAuth.signInWithCredential(facebookAuthCred);

            user = authResult.user;

            if(user != null) {
              isSuccess = await doSocialLogin(user, kFacebook, fbuser.email);
            }
            else {
              throw PlatformException(code: "NO_USER", message: "Couldn't get user");
            }
            print('userddataaa ${user.uid} ${user.email}');
          } else {
            print("Error");
          }
          break;
      }*/
    } catch (e) {
      print("Error in AuthenticationRepository.FBSignin():$e");
    }

    return isSuccess;
  }

  @override
  Future<Response?> doForgotPassword(String email) async {

    Response? response = await RestClient.getData(
        ApiEndpoints.getUesrStatusAPI(email, ApiEndpoints.strSiteUrl), false);
    print("Forgot Password Response Status:${response?.statusCode}, Body:${response?.body}");

    return response;
  }

  Future<bool> doResetUserdata(Userstatus userstatus) async {
    bool isSuccess = false;

    var v4 = Uuid().v4().toString();

    Response? response = await RestClient.getData(
        ApiEndpoints.resetUserDataAPI(userstatus.userid.toString(), v4), false);
    print("Reset Password Response:${response?.body}");
    if (response?.statusCode == 200) {
      if ((response?.body ?? "{}") == '"true"') {
        isSuccess = await doSendPassword(
            userstatus.siteid.toString(),
            userstatus.userid.toString(),
            userstatus.email,
            ApiEndpoints.strSiteUrl,
            v4);
      }
    } else {
      isSuccess = false;
    }

    return isSuccess;
  }

  Future<bool> doSendPassword(String siteId, String userid, String email,
      String siteURL, String v4) async {
    print("Do Send Password Called");

    bool isSuccess = false;

    Response? response = await RestClient.getData(
        ApiEndpoints.sendPwdResetAPI(siteId, userid, email, siteURL, v4),
        false);
    print("Send Data Response:${response?.body}");

    if (response?.statusCode == 200) {
      if ((response?.body ?? "{}") == '"true"') {
        isSuccess = true;
      }
    } else {
      isSuccess = false;
    }

    return isSuccess;
  }

  @override
  Future<bool> doSocialLogin(User user, String type, [String? email]) async {
    bool isSuccess = false;

    try {
      print('partsval hellooo ${user.displayName}');

      var parts = user.displayName?.split(' ') ?? [];
      print('partsval $parts');

      SocialSigninRequest signinRequest =
          SocialSigninRequest(socailNetworkData: []);
      signinRequest.type = type;
      signinRequest.siteId = int.parse(ApiEndpoints.siteID);
      signinRequest.localeId = 'en-us';

      List<SocailNetworkDatum> socialData = [];

      SocailNetworkDatum socailNetworkData = SocailNetworkDatum();
      socailNetworkData.id = user.uid;
      socailNetworkData.username = user.displayName ?? "";
      socailNetworkData.picture = user.photoURL ?? "";
      socailNetworkData.email = email ?? (user.email ?? "");
      socailNetworkData.link = "";
      socailNetworkData.firstName = parts[0].trim();
      socailNetworkData.lastName = parts[1].trim();
      socialData.add(socailNetworkData);

      signinRequest.socailNetworkData = socialData;

      print('socialsignindata $signinRequest');

      var data = socialSigninRequestToJson(signinRequest);

      print('socialsignindata $data  ${ApiEndpoints.apiSocialLogin()}');

      Response? response =
          await RestClient.postData(ApiEndpoints.apiSocialLogin(), data);

      print('socialsignindata $response');

      if (response?.statusCode == 200) {
        SocialSigninResponse socialSigninResponse =
            socialSigninResponseFromJson(response?.body ?? "{}");
        isSuccess = await doGetLoginInfo(socialSigninResponse);
      } else {
        isSuccess = false;
      }
    } catch (e) {
      print("Error in AuthenticationRepository.doSocialLogin():$e");
    }

    return isSuccess;
  }

  Future<bool> doGetLoginInfo(SocialSigninResponse socialSigninResponse) async {
    bool isSuccess = false;

    try {
      print(
          'socialurl ${ApiEndpoints.apiGetLoginDetails(socialSigninResponse.tokeyKey, socialSigninResponse.fromSiteId.toString())}');
      Response? response = await RestClient.getData(
          ApiEndpoints.apiGetLoginDetails(socialSigninResponse.tokeyKey,
              socialSigninResponse.fromSiteId.toString()),
          false);
      print('socialurlresponse $response');

      if (response?.statusCode == 200) {
        if ((response?.body ?? "{}").contains('successfulluserlogin')) {
          LoginResponse loginResponse =
              loginResponseFromJson(response?.body ?? "{}");

          print('bindedresposne $loginResponse');
          await sharePrefSaveString(
              sharedPref_image, loginResponse.successFullUserLogin[0].image);
          await sharePrefSaveString(sharedPref_userid,
              loginResponse.successFullUserLogin[0].userid.toString());
          await sharePrefSaveString(sharedPref_bearer,
              loginResponse.successFullUserLogin[0].jwttoken.toString());
          await sharePrefSaveString(sharedPref_tempProfileImage,
              '${ApiEndpoints.strSiteUrl}/Content/SiteFiles/374/ProfileImages/${loginResponse.successFullUserLogin[0].image}');

          var imag = await sharePrefGetString(sharedPref_bearer);

          print(
              'imageval ${loginResponse.successFullUserLogin[0].image}  $imag');

          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }
    } catch (e) {
      print("Error in AuthenticationRepository.doGetLoginInfo():$e");
    }

    return isSuccess;
  }

  @override
  Future<Response?> fcmRegister(
      {String deviceType = "",
      String deviceToken = "",
      String siteURL = ""}) async {
    // TODO: implement fcmRegister
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> mapData = {
        'userid': int.parse(strUserID),
        'DeviceType': deviceType,
        'DeviceToken': deviceToken,
        'SiteURL': siteURL
      };

      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.fcmRegister(), mapData);
    } catch (e) {
      print("Error in AuthenticationRepository.fcmRegister():$e");
    }
    return response;
  }

  @override
  Future<Response?> getMemberShipDetails() async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      Map<String, dynamic> mapData = {
        'UserID': '-1', //int.parse(strUserID),
        'SiteID': strSiteID,
        'Locale': strLanguage
      };

      print(
          'getMemberShipDetails --->  ${ApiEndpoints.getMemberShipDetails()}');
      print(mapData);
      response = await RestClient.postApiData(
          ApiEndpoints.getMemberShipDetails(), mapData);
    } catch (e) {
      print("Error in AuthenticationRepository.getMemberShipDetails():$e");
    }
    return response;
  }
}
