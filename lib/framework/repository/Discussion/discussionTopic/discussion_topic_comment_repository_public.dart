//import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/model/discussion_topic_comment_request.dart';

import 'discussion_topic_comment_repository.dart';
import 'model/discussion_topic_reply_request.dart';

class DiscussionTopicCommentRepositoryPublic
    extends DiscussionTopicCommentRepository {
  @override
  Future<Response?> getDiscussionTopicCommentListData(
      int intSiteID,
      String strLocale,
      int forumID,
      int siteID,
      int userID,
      String topicID) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      String data =
          "${ApiEndpoints.strBaseUrl}/MobileLMS/GetCommentList?intSiteID=$intSiteID&strLocale=$strLocale&ForumID=$forumID&intUserID=$userID&TopicID=$topicID&=";

      print("&***** : " + data);

      response = await RestClient.getPostData(data);

      print(
          "discussionForunTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print(
          "discussionForunTopicObjectData Response :- ${response.toString()}");
    } catch (e) {
      print(
          "Error in DiscussionTopicCommentRepositryPublic.getDiscussionTopicCommentListData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getDiscussionTopicReplyData(
      {int strCommentID = 0,
      String topicID = "",
      int forumID = 0,
      String involvedUserIDList = "",
      String topicName = "",
      String strAttachFile = "",
      String message = "",
      String localeID = "",
      String strReplyID = "",
      int userID = 0,
      int siteID = 0,
      String forumTitle = "",
      String strCommentTxt = ""}) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      print(
          "......discussion forum....${ApiEndpoints.apiDiscussionMainHome()}");

      DiscussionTopicReplyRequest discussionTopicReplyRequest =
          new DiscussionTopicReplyRequest();
      discussionTopicReplyRequest.strCommentID = strCommentID;
      discussionTopicReplyRequest.topicID = topicID;
      discussionTopicReplyRequest.forumID = forumID;
      discussionTopicReplyRequest.involvedUserIDList = involvedUserIDList;
      discussionTopicReplyRequest.topicName = topicName;
      discussionTopicReplyRequest.strAttachFile = strAttachFile;
      discussionTopicReplyRequest.message = message;
      discussionTopicReplyRequest.localeID = localeID;
      discussionTopicReplyRequest.strReplyID = strReplyID;
      discussionTopicReplyRequest.userID = userID;
      discussionTopicReplyRequest.siteID = siteID;
      discussionTopicReplyRequest.forumTitle = forumTitle;
      discussionTopicReplyRequest.strCommenttxt = strCommentTxt;

      String data =
          discussionTopicRelyRequestToJson(discussionTopicReplyRequest);

      response = await RestClient.postMethodData(
          ApiEndpoints.apiDiscussionTopicCommentReply(), data);

      print(
          "discussionForunStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionTopicCommentRepositryPublic.getDiscussionTopicReplyData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getDiscussionTopicCommentData(
      {String topicID = "",
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
      discussionTopicCommentRequest.topicID = topicID;
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
          "Error in DiscussionTopicCommentRepositryPublic.getDiscussionTopicCommentData():$e");
    }
    return response;
  }
}
