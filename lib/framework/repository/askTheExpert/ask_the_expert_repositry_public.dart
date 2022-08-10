import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/model/like_dislike_request.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/model/up_and_down_vote_request.dart';

import 'ask_the_expert_repositry_builder.dart';

class AskTheExpertRepositoryPublic extends AskTheExpertRepository {
  @override
  Future<Response?> userQuestionsListData(
      {int componentInsID = 0,
      int componentID = 0,
      String sortBy = "",
      int intSkillID = 0,
      int pageIndex = 0,
      int pageSize = 0,
      String searchText = ""}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      // var strComponentID = await sharePref_getString(sharedPref_ComponentID);
      // var strRepositoryId = await sharePref_getString(sharedPref_RepositoryId);

      Map<String, dynamic> userQuestionRequest = {
        'intSiteID': int.parse(strSiteID),
        'UserID': int.parse(strUserID),
        'ComponentInsID': componentInsID,
        'ComponentID': componentID,
        'SortBy': sortBy,
        'intSkillID': intSkillID,
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'SearchText': searchText
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getUserQuestionsList(), userQuestionRequest);
      // String body = json.encode(formData);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.userQuestionsListData():$e");
    }

    return response;
  }

  @override
  Future<Response?> addQuestion(
      {String userEmail = "",
      String userName = "",
      int questionTypeID = 0,
      String userQuestion = "",
      String userQuestionDesc = "",
      String userUploadedImageName = "",
      String filePath = "",
      String fileName = "",
      String skills = "",
      String selectedSkillIds = "",
      int editQueID = 0,
      bool isRemoveEditImage = false}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      print("File name:$fileName");
      print("File Path:$filePath");

      if (filePath != '') {
        //final file = await dio.MultipartFile.fromFile(filePath, filename: fileName);
        File file = File(filePath);
        List<MultipartFile> files = [
          MultipartFile("Image", file.openRead(), file.lengthSync(),
              filename: fileName)
        ];
        //MultipartFile(field, stream, length)
        //List<MultipartFile> files = [];
        //files.add(await MultipartFile.fromPath('Image', filePath, filename: fileName));

        Map<String, String> formData = {
          'SiteID': strSiteID,
          'UserID': strUserID,
          'UserEmail': userEmail,
          'UserName': userName,
          'QuestionTypeID': questionTypeID.toString(),
          'UserQuestion': userQuestion,
          'UserQuestionDesc': userQuestionDesc,
          'UseruploadedImageName': userUploadedImageName,
          'skills': skills,
          'SeletedSkillIds': selectedSkillIds,
          'EditQueID': editQueID.toString(),
          'IsRemoveEditimage': isRemoveEditImage.toString()
        };
        response = await RestClient.uploadFilesData(
            ApiEndpoints.addNewQuestion(), formData,
            files: files);
      } else {
        Map<String, String> formData = {
          'SiteID': strSiteID,
          'UserID': strUserID,
          'UserEmail': userEmail,
          'UserName': userName,
          'QuestionTypeID': questionTypeID.toString(),
          'UserQuestion': userQuestion,
          'UserQuestionDesc': userQuestionDesc,
          'UseruploadedImageName': userUploadedImageName,
          'skills': skills,
          'SeletedSkillIds': selectedSkillIds,
          'EditQueID': editQueID.toString(),
          'IsRemoveEditimage': isRemoveEditImage.toString()
        };
        response = await RestClient.uploadFilesData(
            ApiEndpoints.addNewQuestion(), formData);
      }
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.addQuestion():$e");
    }
    return response;
  }

  @override
  Future<Response?> viewAnswers(
      {int intSiteID = 0,
      int UserID = 0,
      int componentInsID = 0,
      int componentID = 0,
      int intQuestionID = 0}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> mapData = {
        'intSiteID': int.parse(strSiteID),
        'UserID': int.parse(strUserID),
        'intQuestionID': intQuestionID,
        'ComponentInsID': componentInsID,
        'ComponentID': componentID
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.viewAnswersList(), mapData);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.viewAnswers():$e");
    }
    return response;
  }

  @override
  Future<Response?> upDownVote(
      {String strObjectID = "",
      int intTypeID = 0,
      bool blnIsLiked = false}) async {
    // TODO: implement upDownVote
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      UpAndDownVoteRequest andDownVoteRequest = new UpAndDownVoteRequest();
      andDownVoteRequest.intUserID = int.parse(strUserID);
      andDownVoteRequest.intTypeID = intTypeID;
      andDownVoteRequest.strObjectID = strObjectID;
      andDownVoteRequest.blnIsLiked = blnIsLiked;
      andDownVoteRequest.intSiteID = int.parse(strSiteID);

      String data = upAndDownVoteRequestToJson(andDownVoteRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.upAndDownVote(), data);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.upDownVote():$e");
    }
    return response;
  }

  @override
  Future<Response?> addAnswerComment(
      {int userID = 0,
      int siteID = 0,
      int questionID = 0,
      int responseID = 0,
      String commentID = "",
      String comment = "",
      String userCommentImage = "",
      int commentStatus = 0,
      bool isRemoveCommentImage = false,
      String filePath = "",
      String fileName = ""}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      if (filePath.isNotEmpty) {
        //final file = await dio.MultipartFile.fromFile(filePath, filename: fileName);
        File file = File(filePath);
        List<MultipartFile> files = [
          MultipartFile("Image", file.openRead(), file.lengthSync(),
              filename: fileName)
        ];
        //List<MultipartFile> files = [MultipartFile("userCommentImage", file.openRead(), file.lengthSync())];

        Map<String, String> formData = {
          'siteID': strSiteID,
          'userID': strUserID,
          'questionID': questionID.toString(),
          'responseID': responseID.toString(),
          'commentID': commentID,
          'comment': comment,
          'userCommentImage': fileName,
          'commentStatus': commentStatus.toString(),
          'isRemoveCommentImage': isRemoveCommentImage.toString(),
        };
        //print("formdata : " + file.toString());
        response = await RestClient.uploadFilesData(
            ApiEndpoints.answerComment(), formData,
            files: files);
      } else {
        Map<String, String> formData = {
          'siteID': strSiteID,
          'userID': strUserID,
          'questionID': questionID.toString(),
          'responseID': responseID.toString(),
          'commentID': commentID,
          'comment': comment,
          'userCommentImage': userCommentImage,
          'commentStatus': commentStatus.toString(),
          'isRemoveCommentImage': isRemoveCommentImage.toString(),
        };

        response = await RestClient.uploadFilesData(
            ApiEndpoints.answerComment(), formData);
      }
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.addAnswerComment():$e");
    }
    return response;
  }

  @override
  Future<Response?> getSkillCategory() async {
    // TODO: implement getSkillCategory
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> mapData = {
        'intSiteID': int.parse(strSiteID),
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.skillCategory(), mapData);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.getSkillCategory():$e");
    }
    return response;
  }

  @override
  Future<Response?> getComments({int commentID = 0}) async {
    // TODO: implement getComments
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map<String, dynamic> mapData = {
        'intSiteID': int.parse(strSiteID),
        'UserID': int.parse(strUserID),
        'intQuestionID': commentID
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.viewComment(), mapData);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.getComments():$e");
    }
    return response;
  }

  @override
  Future<Response?> likeDisLikeData({
    int intUserID = 0,
    String strObjectID = "",
    int intTypeID = 0,
    bool blnIsLiked = false,
  }) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      print("......like dislike Topic ....${ApiEndpoints.upAndDownVote()}");

      LikeDisLikeRequest likeDisLikeRequest = new LikeDisLikeRequest();
      likeDisLikeRequest.intUserID = intUserID;
      likeDisLikeRequest.strObjectID = strObjectID;
      likeDisLikeRequest.intTypeID = intTypeID;
      likeDisLikeRequest.blnIsLiked = blnIsLiked;

      String data = likeDisLikeRequestToJson(likeDisLikeRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.upAndDownVote(), data);

      print(
          "likeDisLikeStateCode statusCode :- ${response?.statusCode.toString()}");
      print("likeDislikeObjectData Response :- ${response?.body}");
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.likeDisLikeData():$e");
    }

    return response;
  }

  @override
  Future<Response?> deleteComment(
      {int commentId = 0, String commentedImage = ""}) async {
    Response? response;
    try {
      Map<String, dynamic> mapData = {
        'commentId': commentId,
        'Commentedimage': commentedImage
      };

      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.deleteComment(), mapData);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.deleteComment():$e");
    }
    return response;
  }

  @override
  Future<Response?> deleteQuestion(
      {int questionID = 0, String userUploadImage = ""}) async {
    Response? response;
    try {
      Map<String, dynamic> mapData = {
        'QuestionID': questionID,
        'UserUploadimage': userUploadImage,
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.deleteQuestion(), mapData);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.deleteQuestion():$e");
    }
    return response;
  }

  @override
  Future<Response?> viewQuestion({int intQuestionID = 0}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> mapData = {
        'UserID': int.parse(strUserID),
        'intQuestionID': intQuestionID
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.viewQuestion(), mapData);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.viewQuestion():$e");
    }
    return response;
  }

  @override
  Future<Response?> addAnswer(
      {String userEmail = "",
      String userName = "",
      String response1 = "",
      String userResponseImageName = "",
      int responseID = 0,
      int questionID = 0,
      bool isRemoveEditImage = false,
      String filePath = "",
      String fileName = ""}) async {
    // TODO: implement addAnswer
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      //print("***** :"+UserName+": "+UserEmail+" : "+response+" : ")

      if (filePath != '') {
        //final file = await dio.MultipartFile.fromFile(filePath, filename: fileName);
        File file = File(filePath);
        List<MultipartFile> files = [
          MultipartFile("Image", file.openRead(), file.lengthSync(),
              filename: fileName)
        ];

        Map<String, String> formData = {
          'UserID': strUserID,
          'SiteID': strSiteID,
          'Locale': strLanguage,
          'UserEmail': userEmail,
          'UserName': userName,
          'Response': response1,
          'UserResponseImageName': userResponseImageName,
          'ResponseID': responseID.toString(),
          'QuestionID': questionID.toString(),
          'IsRemoveEditimage': isRemoveEditImage.toString(),
        };
        print("formdata : " + formData.toString());
        response = await RestClient.uploadFilesData(
            ApiEndpoints.addAnswerAskTheExpert(), formData,
            files: files);
      } else {
        Map<String, String> formData = {
          'UserID': strUserID,
          'SiteID': strSiteID,
          'Locale': strLanguage,
          'UserEmail': userEmail,
          'UserName': userName,
          'Response': response1,
          'UserResponseImageName': userResponseImageName,
          'ResponseID': responseID.toString(),
          'QuestionID': questionID.toString(),
          'IsRemoveEditimage': isRemoveEditImage.toString(),
        };

        print("formdata : " + formData.toString());
        response = await RestClient.uploadFilesData(
            ApiEndpoints.addAnswerAskTheExpert(), formData);
      }
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.addAnswer():$e");
    }
    return response;
  }

  @override
  Future<Response?> deleteUserResponse(
      {int responseId = 0, String userResponseImage = ""}) async {
    Response? response;
    try {
      Map<String, dynamic> mapData = {
        'ResponseID': responseId,
        'UserResponseImage': userResponseImage
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.deleteUserResponse(), mapData);
    } catch (e) {
      print("Error in AskTheExpertRepositoryPublic.deleteUserResponse():$e");
    }
    return response;
  }
}
