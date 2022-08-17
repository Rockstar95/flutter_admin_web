import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/createDiscussion/model/add_topic_request.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repository.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/model/delete_reply_request.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/model/discussion_reply_request.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/model/like_dislike_request.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/model/pin_topic_request.dart';

import 'model/delete_discussion_topic_request.dart';
import 'model/discussion_topic_comment_request.dart';

class DiscussionTopicRepositryPublic extends DiscussionTopicRepository {
  @override
  Future<Response?> getDiscussionTopicData(
      int userID, int forumID, int siteID, String localeID) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      String data =
          "${ApiEndpoints.strBaseUrl}DiscussionForums/GetForumTopics?ForumID=$forumID&intUserID=$userID&intSiteID=$siteID&strLocale=$localeID";

      print("&***** : " + data);

      response = await RestClient.getPostData(data);

      print(
          "discussionForunTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionTopicRepositryPublic.getDiscussionTopicData():$e");
    }

    return response;
  }

  @override
  Future<Response?> addTopicData(
      {String strAttachFile = "",
      int userID = 0,
      int orgID = 0,
      int forumID = 0,
      String strContentID = "",
      String description = "",
      String localeID = "",
      int siteID = 0,
      String title = "",
      String forumName = "",
      String involvedUsers = ""}) async {
    // TODO: implement addTopicData
    Response? response;
    try {
      print(
          "......discussion forum....${ApiEndpoints.apiDiscussionMainHome()}");

      AddTopicRequest addTopicRequest = new AddTopicRequest();
      addTopicRequest.strAttachFile = strAttachFile;
      addTopicRequest.userID = userID;
      addTopicRequest.orgID = orgID;
      addTopicRequest.forumID = forumID;
      addTopicRequest.strContentID = strContentID;
      addTopicRequest.description = description;
      addTopicRequest.localeID = localeID;
      addTopicRequest.siteID = siteID;
      addTopicRequest.title = title;
      addTopicRequest.forumName = forumName;

      String data = addTopicRequestToJson(addTopicRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.apiAddTopic(), data);

      print(
          "discussionTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print("Error in DiscussionTopicRepositryPublic.addTopicData():$e");
    }

    return response;
  }

  @override
  Future<Response?> editTopicData(
      {String strAttachFile = "",
      int userID = 0,
      int orgID = 0,
      int forumID = 0,
      String strContentID = "",
      String description = "",
      String localeID = "",
      int siteID = 0,
      String title = "",
      String forumName = ""}) async {
    // TODO: implement addTopicData
    Response? response;
    try {
      print(
          "......discussion forum....${ApiEndpoints.apiDiscussionMainHome()}");

      AddTopicRequest addTopicRequest = new AddTopicRequest();
      addTopicRequest.strAttachFile = strAttachFile;
      addTopicRequest.userID = userID;
      addTopicRequest.orgID = orgID;
      addTopicRequest.forumID = forumID;
      addTopicRequest.strContentID = strContentID;
      addTopicRequest.description = description;
      addTopicRequest.localeID = localeID;
      addTopicRequest.siteID = siteID;
      addTopicRequest.title = title;
      addTopicRequest.forumName = forumName;

      String data = addTopicRequestToJson(addTopicRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.apiEditTopic(), data);

      print(
          "discussionTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print("Error in DiscussionTopicRepositryPublic.editTopicData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getDiscussionTopicReplyData(
      {String topicId = "",
      String topicName = "",
      int forumId = 0,
      String forumTitle = "",
      String message = "",
      String strAttachFil = "",
      String strReplyID = "",
      String filePath = "",
      String fileName = ""}) async {
    // TODO: implement getDiscussionTopicCommentData
    Response? response;

    try {
      print(
          "......add comment ....${ApiEndpoints.apiDiscussionTopicComment()}");

      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);
      DiscussionTopicCommentRequest discussionTopicCommentRequest =
          new DiscussionTopicCommentRequest();
      discussionTopicCommentRequest.topicID = topicId;
      discussionTopicCommentRequest.topicName = topicName;
      discussionTopicCommentRequest.forumID = forumId;
      discussionTopicCommentRequest.forumTitle = forumTitle;
      discussionTopicCommentRequest.message = message;
      discussionTopicCommentRequest.userID = int.parse(strUserID);
      discussionTopicCommentRequest.siteID = int.parse(strSiteID);
      discussionTopicCommentRequest.localeID = language;
      discussionTopicCommentRequest.strAttachFile = strAttachFil;
      discussionTopicCommentRequest.strReplyID = strReplyID;

      String data =
          discussionTopicCommentRequestToJson(discussionTopicCommentRequest);

      response = await RestClient.postMethodData(
          ApiEndpoints.apiDiscussionTopicComment(), data);
      print(
          "discussionForunStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionTopicRepositryPublic.getDiscussionTopicReplyData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getDiscussionTopicCommentListData(
      {int intSiteID = 0,
      String strLocale = "",
      int forumID = 0,
      int siteID = 0,
      int userID = 0,
      String topicId = ""}) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      String data =
          "${ApiEndpoints.strBaseUrl}/MobileLMS/GetCommentList?intSiteID=$intSiteID&strLocale=$strLocale&ForumID=$forumID&intUserID=$userID&TopicID=$topicId&=";

      print("&***** : " + data);

      response = await RestClient.getPostData(data);

      print(
          "discussionForunTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionTopicRepositryPublic.getDiscussionTopicCommentListData():$e");
    }

    return response;
  }

  @override
  Future<Response?> deleteDiscussionTopicUserData(
      {String topicID = "",
      int forumID = 0,
      String forumName = "",
      int userID = 0,
      int siteID = 0,
      String localeID = ""}) async {
    // TODO: implement addTopicData
    Response? response;
    try {
      print(
          "......discussion forum....${ApiEndpoints.apiDiscussionMainHome()}");

      DeleteDiscussionTopicRequest deleteDiscussionTopicRequest =
          new DeleteDiscussionTopicRequest();
      deleteDiscussionTopicRequest.topicID = topicID;
      deleteDiscussionTopicRequest.forumID = forumID;
      deleteDiscussionTopicRequest.forumName = forumName;
      deleteDiscussionTopicRequest.userID = userID;
      deleteDiscussionTopicRequest.siteID = siteID;
      deleteDiscussionTopicRequest.localeID = localeID;

      String data =
          deleteDiscussionTopicRequestToJson(deleteDiscussionTopicRequest);

      response = await RestClient.postMethodData(
          ApiEndpoints.apiDeleteForumTopic(), data);

      print(
          "discussionForunStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionTopicRepositryPublic.deleteDiscussionTopicUserData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getTopicReplyData(
      {int strCommentID = 0,
      int userID = 0,
      int siteID = 0,
      String localeID = ""}) async {
    // TODO: implement addTopicData
    Response? response;
    try {
      print(
          "......discussion forum....${ApiEndpoints.apiDiscussionMainHome()}");

      DiscussionReplyRequest discussionReplyRequest =
          new DiscussionReplyRequest();
      discussionReplyRequest.strCommentID = strCommentID;
      discussionReplyRequest.userID = userID;
      discussionReplyRequest.siteID = siteID;
      discussionReplyRequest.localeID = localeID;

      String data = discussionReplyRequestToJson(discussionReplyRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.apiReplyTopic(), data);

      print(
          "discussionForunStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${response?.body}");
    } catch (e) {
      print("Error in DiscussionTopicRepositryPublic.getTopicReplyData():$e");
    }

    return response;
  }

  @override
  Future<Response?> deleteReplyData({int replyID = 0}) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      print(
          "......discussion forum....${ApiEndpoints.apiDiscussionMainHome()}");

      DeleteReplyRequest deleteReplyRequest = new DeleteReplyRequest();
      deleteReplyRequest.replyId = replyID;

      String data = deleteReplyRequestToJson(deleteReplyRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.apiDeleteReply(), data);

      print(
          "discussionForunStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${response?.body}");
    } catch (e) {
      print("Error in DiscussionTopicRepositryPublic.deleteReplyData():$e");
    }

    return response;
  }

  @override
  Future<Response?> pinTopicData(
      {int forumID = 0,
      String strContentID = "",
      bool isPin = false,
      int userID = 0}) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      print("......pin Topic ....${ApiEndpoints.apiPinTopic()}");

      PinTopicRequest pinTopicRequest = new PinTopicRequest();
      pinTopicRequest.forumID = forumID;
      pinTopicRequest.strContentID = strContentID;
      pinTopicRequest.isPin = isPin;
      pinTopicRequest.userID = userID;

      String data = pinTopicRequestToJson(pinTopicRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.apiPinTopic(), data);

      print(
          "pinTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("pinTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print("Error in DiscussionTopicRepositryPublic.pinTopicData():$e");
    }

    return response;
  }

  @override
  Future<Response?> likeDisLikeData(
      {int intUserID = 0,
      String strObjectID = "",
      int intTypeID = 0,
      bool blnIsLiked = false,
      int intSiteID = 0,
      String strLocale = ""}) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      print("......like dislike Topic ....${ApiEndpoints.apiLikeUnLike()}");

      LikeDisLikeRequest likeDisLikeRequest = new LikeDisLikeRequest();
      likeDisLikeRequest.intUserID = intUserID;
      likeDisLikeRequest.strObjectID = strObjectID;
      likeDisLikeRequest.intTypeID = intTypeID;
      likeDisLikeRequest.blnIsLiked = blnIsLiked;
      likeDisLikeRequest.intSiteID = intSiteID;
      likeDisLikeRequest.strLocale = strLocale;

      String data = likeDisLikeRequestToJson(likeDisLikeRequest);

      response =
          await RestClient.postMethodData(ApiEndpoints.apiLikeUnLike(), data);

      print(
          "likeDisLikeStateCode statusCode :- ${response?.statusCode.toString()}");
      print("likeDislikeObjectData Response :- ${response?.body}");
    } catch (e) {
      print("Error in DiscussionTopicRepositryPublic.likeDisLikeData():$e");
    }

    return response;
  }

  @override
  Future<Response?> likeCount(
      {String strObjectID = "",
      int intUserID = 0,
      int intSiteID = 0,
      String strLocale = "",
      int intTypeID = 0}) async {
    // TODO: implement likeCount
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map<String, dynamic> mapData = {
        'strObjectID': strObjectID,
        'intUserID': int.parse(strUserID),
        'intSiteID': int.parse(strSiteID),
        'strLocale': strLocale,
        'intTypeID': intTypeID
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.apiLikeCount(), mapData);
    } catch (e) {
      print("Error in DiscussionTopicRepositryPublic.likeCount():$e");
    }
    return response;
  }

  @override
  Future<Response?> uploadAttachment(
      {String topicID = "",
      String replyID = "",
      bool isTopic = false,
      Uint8List? fileBytes,
      String fileName = ""}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      if (fileBytes != null) {
        List<MultipartFile> files = [
          MultipartFile.fromBytes("Image", fileBytes),
        ];
        //final file = await dio.MultipartFile.fromFile(filePath, filename: fileName);
        // File file = File(fileBytes);
        // List<MultipartFile> files = [
        //   MultipartFile("Image", file.openRead(), file.lengthSync(),
        //       filename: fileName)
        // ];

        Map<String, String> formData = {
          'TopicID': topicID,
          'ReplyID': replyID,
          'isTopic': isTopic.toString(),
          'intUserID': strUserID,
          'intSiteID': strSiteID,
          'strLocale': strLanguage,
        };
        response = await RestClient.uploadFilesData(
            ApiEndpoints.uploadAttachment(), formData,
            files: files);
      }
      /*else {
        final formData = FormData.fromMap({
          'TopicID': topicID,
          'ReplyID': '',
          'isTopic': isTopic,
          'intUserID': int.parse(strUserID),
          'intSiteID': int.parse(strSiteID),
          'strLocale': strLanguage,
          'Image': '',
        });
        response = await RestClient.uploadFilesData(
            ApiEndpoints.uploadAttachment(), formData);
      }*/
    } catch (e) {
      print("Error in DiscussionTopicRepositryPublic.uploadAttachment():$e");
    }
    return response;
  }
}
