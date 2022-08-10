import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/auth_request.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/login_response.dart';

import 'communities_repositry_builder.dart';

class CommunitiesRepositoryPublic extends CommunitiesRepository {
  @override
  Future<Response?> getLearningCommunitiesResponseRepo(
      {NativeMenuModel? nativeMenuModel}) async {
    // TODO: implement getWikiCategories
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      // var strComponentID = await sharePref_getString(sharedPref_ComponentID);
      // var strLanguage = await sharePref_getString(sharedPref_AppLocale);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      print(
          "......catalog....${ApiEndpoints.getportalListing('25', nativeMenuModel?.componentId ?? "", strUserID, strSiteID, nativeMenuModel?.repositoryId ?? "")}");
      response = await RestClient.getPostData(ApiEndpoints.getportalListing(
          '25',
          nativeMenuModel?.componentId ?? "",
          strUserID,
          strSiteID,
          nativeMenuModel?.repositoryId ?? ""));
      print("Add to wish response ${response?.body.toString()}");
    } catch (e) {
      print(
          "Error in CommunitiesRepositoryPublic.GetLearningCommunitiesResponserepo():$e");
    }
    return response;
  }

  @override
  Future<Response?> doSubSiteLogin(String username, String password,
      String mobileSiteUrl, String downloadContent, String siteId) async {
    // TODO: implement doSubSiteLogin
    try {
      Login login = Login();
      login.userName = username;
      login.password = password;
      login.mobileSiteUrl = mobileSiteUrl;
      login.downloadContent = downloadContent;
      login.siteId = siteId;
      login.isFromSignUp = false;

      var data = loginToJson(login);
      //print('login req $data');

      Response? response =
          await RestClient.postData(ApiEndpoints.apiLogin(), data);
      print('MyResponse ${response?.body}');
      if (response?.statusCode == 200) {
        if ((response?.body ?? "{}").contains('successfulluserlogin')) {
          var loginResponse = loginResponseFromJson(response?.body ?? "{}");
          await sharePrefSaveString(sharedPrefIsSubSiteEntered, 'true');
          await sharePrefSaveString(
              sharedPrefSubSiteSiteUrl, login.mobileSiteUrl);

          await sharePrefSaveString(sharedPrefSubSiteSiteId, login.siteId);

          // await sharePref_saveString(
          //     sharedPref_image, loginResponse.successFullUserLogin[0].image);
          // await sharePref_saveString(sharedPref_userid,
          //     loginResponse.successFullUserLogin[0].userid.toString());
          // await sharePref_saveString(sharedPref_bearer,
          //     loginResponse.successFullUserLogin[0].jwttoken.toString());
          // await sharePref_saveString(sharedPref_LoginUserName,
          //     loginResponse.successFullUserLogin[0].username);
          // await sharePref_saveString(sharedPref_LoginPassword, password);
          // await sharePref_saveString(sharedPref_LoginUserID, username);
          // await sharePref_saveString(sharedPref_tempProfileImage,
          //     '${ApiEndpoints.strSiteUrl}/Content/SiteFiles/374/ProfileImages/${loginResponse.successFullUserLogin[0].image}');

// subsite login response
          await sharePrefSaveString(sharedPrefSubSiteUserProfileImage,
              loginResponse.successFullUserLogin[0].image);
          await sharePrefSaveString(sharedPrefSubSiteUserId,
              loginResponse.successFullUserLogin[0].userid.toString());
          await sharePrefSaveString(sharedPrefSubSiteAuthentication,
              loginResponse.successFullUserLogin[0].jwttoken.toString());
          await sharePrefSaveString(sharedPrefSubSiteUserName,
              loginResponse.successFullUserLogin[0].username);
          await sharePrefSaveString(sharedPrefSubSiteUserPassword, password);
          await sharePrefSaveString(sharedPrefSubSiteUserLoginId, username);

          // overrided mainsite login data
          await sharePrefSaveString(sharedPref_userid,
              loginResponse.successFullUserLogin[0].userid.toString());
          await sharePrefSaveString(sharedPref_bearer,
              loginResponse.successFullUserLogin[0].jwttoken.toString());
          await sharePrefSaveString(sharedPref_tempProfileImage,
              '${ApiEndpoints.strSiteUrl}/Content/SiteFiles/374/ProfileImages/${loginResponse.successFullUserLogin[0].image}');

          ApiEndpoints.mainSiteURL = login.mobileSiteUrl;

          // await sharePref_saveString(
          //     sharedPref_main_siteurl, ApiEndpoints.mainSiteURL);

          print(mobileSiteUrl);
        } else {}
      } else {}

      return response;
    } catch (e) {
      print("Error in CommunitiesRepositoryPublic.doSubSiteLogin():$e");
      return null;
    }
  }
}
