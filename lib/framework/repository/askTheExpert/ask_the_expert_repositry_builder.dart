import 'dart:typed_data';

import 'package:http/http.dart';

import 'ask_the_expert_repositry_public.dart';

class AskTheExpertRepositoryBuilder {
  static AskTheExpertRepository repository() {
    return AskTheExpertRepositoryPublic();
  }
}

abstract class AskTheExpertRepository {
  Future<Response?> userQuestionsListData(
      {int componentInsID = 0,
      int componentID = 0,
      String sortBy = "",
      int intSkillID = 0,
      int pageIndex = 0,
      int pageSize = 0,
      String searchText = ""});

  Future<Response?> addQuestion(
      {String userEmail = "",
      String userName = "",
      int questionTypeID = 0,
      String userQuestion = "",
      String userQuestionDesc = "",
      String userUploadedImageName = "",
      String fileName = "",
      Uint8List? fileBytes,
      String skills = "",
      String selectedSkillIds = "",
      int editQueID = 0,
      bool isRemoveEditImage});

  Future<Response?> viewAnswers(
      {int componentInsID = 0, int componentID = 0, int intQuestionID = 0});

  Future<Response?> upDownVote({
    String strObjectID = "",
    int intTypeID = 0,
    bool blnIsLiked = false,
  });

  Future<Response?> addAnswerComment(
      {int questionID = 0,
      int responseID = 0,
      String commentID = "",
      String comment = "",
      String userCommentImage = "",
      int commentStatus = 0,
      bool isRemoveCommentImage = false,
      Uint8List? fileBytes,
      String fileName = ""});

  Future<Response?> getSkillCategory();

  Future<Response?> getComments({int commentID = 0});

  Future<Response?> likeDisLikeData(
      {int intUserID = 0,
      String strObjectID = "",
      int intTypeID = 0,
      bool blnIsLiked = false});

  Future<Response?> deleteComment(
      {int commentId = 0, String commentedImage = ""});

  Future<Response?> deleteQuestion(
      {int questionID = 0, String userUploadImage = ""});

  Future<Response?> viewQuestion({
    int intQuestionID = 0,
  });

  Future<Response?> addAnswer(
      {String userEmail = "",
      String userName = "",
      String response1 = "",
      String userResponseImageName = "",
      int responseID = 0,
      int questionID = 0,
      bool isRemoveEditImage = false,
      Uint8List? fileBytes,
      String fileName = ""});

  Future<Response?> deleteUserResponse(
      {int responseId = 0, String userResponseImage = ""});
}
