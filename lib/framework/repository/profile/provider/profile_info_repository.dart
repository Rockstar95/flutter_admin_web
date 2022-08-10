import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/profile/contract/profile_repository.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/create_education_request.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/create_experience_request.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/education_titles_response.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/fetchCounries.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/remove_experience_request.dart';

class ProfileInfoRepository implements ProfileRepository {
  @override
  Future<ApiResponse?> getUserInfo() async {
    ProfileResponse? profileResponse;
    ApiResponse? apiResponse;
    try {
      var userid = await sharePrefGetString(sharedPref_userid);
      var locale = await sharePrefGetString(sharedPref_AppLocale);

      Response? response = await RestClient.getPostData(
          ApiEndpoints.getUserInfo(userid, '374', locale));

      //log('responseprofile ${response?.body}');

      if (response?.statusCode == 200) {
        profileResponse = profileResponseFromJson(response?.body ?? "{}");
        print("Privilege Length:${profileResponse.userprivileges.length}");

        ProfileDataField? profileDataField =
            profileResponse.profiledatafieldname.isNotEmpty
                ? profileResponse.profiledatafieldname.first
                : null;
        print('responseprofile ${profileDataField?.valueName}');
      }

      apiResponse =
          ApiResponse(data: profileResponse, status: response?.statusCode ?? 0);
    } catch (e, s) {
      print('Error in  ProfileInfoRepository.getUserInfo():$e');
      print(s);
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> getConnectionsProfile(String userId) async {
    ProfileResponse? profileResponse;
    ApiResponse? apiResponse;
    try {
      var locale = await sharePrefGetString(sharedPref_AppLocale);

      print('getUserInfo' + ApiEndpoints.getUserInfo(userId, '374', locale));
      Response? response = await RestClient.getPostData(
          ApiEndpoints.getUserInfo(userId, '374', locale));

      print('responseprofile ${response?.body.toString()}');

      if (response?.statusCode == 200) {
        profileResponse = profileResponseFromJson(response?.body ?? "{}");

        //print(
        //    'responseprofile ${profileResponse.profiledatafieldname[0].valueName}');
      }

      apiResponse =
          ApiResponse(data: profileResponse, status: response?.statusCode ?? 0);
    } catch (e) {
      e.toString();
      print('Error in  ProfileInfoRepository.getConnectionsProfile():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> createExperience(
      CreateExperienceRequest createExperienceRequest) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;

    try {
      var data = createExperienceRequestToJson(createExperienceRequest);
      Response? response =
          await RestClient.postMethodData(ApiEndpoints.createExperience, data);
      print('MyResponse ${response?.body}');
      if (response?.statusCode == 200) {
        if ((response?.body ?? "") == 'true') {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }

      apiResponse =
          ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.createExperience():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> removeExperience(
      RemoveExperienceRequest removeExperienceRequest) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;

    try {
      var data = removeExperienceRequestToJson(removeExperienceRequest);
      Response? response =
          await RestClient.postMethodData(ApiEndpoints.removeExperience, data);
      print('MyResponse ${response?.body}');
      if (response?.statusCode == 200) {
        if (response?.body == 'true') {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }

      apiResponse =
          ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.removeExperience():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> updateExperience(
      CreateExperienceRequest updateExperienceRequest) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;

    try {
      var data = createExperienceRequestToJson(updateExperienceRequest);
      Response? response =
          await RestClient.postMethodData(ApiEndpoints.updateExperience, data);
      print('MyResponse ${response?.body}');
      if (response?.statusCode == 200) {
        if (response?.body == 'true') {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }

      apiResponse =
          ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.updateExperience():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> createEducation(
      CreateEducationRequest createEducationRequest) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;

    try {
      var data = createEducationRequestToJson(createEducationRequest);
      print('createeducation $data');
      Response? response =
          await RestClient.postMethodData(ApiEndpoints.createEducation, data);
      print('MyResponse ${response?.body}');
      if (response?.statusCode == 200) {
        if (response?.body == 'true') {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }
      apiResponse =
          ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.createEducation():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> removeEducation(
      RemoveExperienceRequest removeEducationRequest) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;
    try {
      var data = removeExperienceRequestToJson(removeEducationRequest);
      print('removeeducation $data');
      Response? response =
          await RestClient.postMethodData(ApiEndpoints.removeEducation, data);
      print('MyResponse ${response?.body}');
      if (response?.statusCode == 200) {
        if (response?.body == 'true') {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }
      apiResponse =
          ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.removeEducation():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> getEducationTitleList() async {
    List<EducationTitleList> data = [];
    ApiResponse? apiResponse;

    try {
      Response? response =
          await RestClient.getPostData(ApiEndpoints.getEducationTitles);
      if (response?.statusCode == 200) {
        GetEducationTitleResponse educationTitleResponse =
            getEducationTitleResponseFromJson(response?.body ?? "{}");
        data = educationTitleResponse.educationTitleList;
      }

      apiResponse = ApiResponse(data: data, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.getEducationTitleList():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> updateEducation(
      CreateEducationRequest updateEducationRequest) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;
    try {
      String data = createEducationRequestToJson(updateEducationRequest);
      print('createeducation $data');
      Response? response =
          await RestClient.postMethodData(ApiEndpoints.updateEducation, data);
      print('MyResponse ${response?.body}');
      if (response?.statusCode == 200) {
        if (response?.body == 'true') {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }

      apiResponse =
          ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.updateEducation():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> uploadImage(String image, String fileName) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;

    try {
      var userid = await sharePrefGetString(sharedPref_userid);
      print('imageurl ${ApiEndpoints.uploadImage(fileName, userid)}');

      String replaceDataString = image.replaceAll("\"", "\\\"");
      String addQuotes = ('"' + replaceDataString + '"');
      Map<String, dynamic> data = {"buffer": addQuotes};

      //Response? response = await RestClient.postApiData(ApiEndpoints.uploadImage(fileName, userid), addQuotes);
      Response? response = await RestClient.postMethodData(
          ApiEndpoints.uploadImage(fileName, userid), addQuotes);
      print('MyResponse ${response?.body}');
      if (response?.statusCode == 200) {
        if (response?.body == '\"true\"') {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }
      apiResponse =
          ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);
    } catch (e) {
      print("Error in ProfileInfoRepository.uploadImage():$e");
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> updateProfile(String val) async {
    bool isSuccess = false;
    ApiResponse? apiResponse;
    try {
      print('updateProfile_req $val');

      String data =
          '''\"UserGroupIDs\":\"\",\"RoleIDs\":\"\",\"Cmd\":\"$val\",\"CMGroupIDs\":\"\"''';
      String replaceDataString = data.replaceAll("\"", "\\\"");
      data = '''"{$replaceDataString}"''';
      //String data = '''"{\\\"UserGroupIDs\\\" : \\\"\\\",\\\"RoleIDs\\\" : \\\"\\\",\\\"Cmd\\\" : \\\"$val\\\",\\\"CMGroupIDs\\\" : \\\"\\\"}"''';

      /*Map<String, dynamic> data = {
        "UserGroupIDs" : "",
        "RoleIDs" : "",
        "Cmd" : val,
        "CMGroupIDs" : "",
      };*/

      print('updateProfile $data');
      var userid = await sharePrefGetString(sharedPref_userid);
      // Response? response = await RestClient.postApiData(ApiEndpoints.updateProfile(userid), data);
      Response? response = await RestClient.postMethodData(
          ApiEndpoints.updateProfile(userid), data);
      print(
          'MyResponse Status:${response?.statusCode}, Body:${response?.body} ');
      if (response?.statusCode == 200) {
        if (response?.body == "\"success\"") {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }
      apiResponse =
          ApiResponse(data: isSuccess, status: response?.statusCode ?? 0);
    } catch (e, s) {
      print('Error in  ProfileInfoRepository.updateProfile():$e');
      print(s);
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> fetchCountries() async {
    ApiResponse? apiResponse;
    bool isSuccess = false;
    CountryResponse countryResponse;

    try {
      var userid = await sharePrefGetString(sharedPref_userid);
      var siteId = await sharePrefGetString(sharedPref_siteid);
      var locale = await sharePrefGetString(sharedPref_AppLocale);

      Response? response = await RestClient.getPostData(
          ApiEndpoints.fetchCountries(userid, siteId, locale));
      print(
          'MyResponse Status:${response?.statusCode}, Body:${response?.body}');
      if (response?.statusCode == 200) {
        if (response.toString() == 'success') {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }
      countryResponse = countryResponseFromJson(response?.body ?? "{}");

      apiResponse =
          ApiResponse(data: countryResponse, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.fetchCountries():$e');
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse?> getProfileHeader(String profileUserId) async {
    ApiResponse? apiResponse;
    try {
      var userId = await sharePrefGetString(sharedPref_userid);
      var siteId = await sharePrefGetString(sharedPref_siteid);
      var locale = await sharePrefGetString(sharedPref_AppLocale);

      print("......ProfileHeader....${ApiEndpoints.getProfileHeader()}");

      Map<String, dynamic> data = {
        "intUserID": userId,
        "intSiteID": siteId,
        "strLocale": locale,
        "intProfileUserID": profileUserId,
      };

      Response? response = await RestClient.postApiData(ApiEndpoints.getProfileHeader(), data);
      print('GetProfileHeader response $response ${response?.statusCode}');
      apiResponse =
          ApiResponse(data: response?.body, status: response?.statusCode ?? 0);
    } catch (e) {
      print('Error in  ProfileInfoRepository.getProfileHeader():$e');
    }

    return apiResponse;
  }
}
