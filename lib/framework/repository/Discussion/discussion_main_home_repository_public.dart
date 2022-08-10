import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/model/discussion_main_home_request.dart';

import 'discussionTopic/model/delete_comment_request.dart';
import 'discussion_main_home_repository.dart';

class DiscussionMainHomeRepositoryPublic extends DiscussionMainHomeRepository {
  @override
  Future<Response?> getDiscussionMainHomeData(
      {int intUserID = 0,
      int intSiteID = 0,
      String strLocale = "",
      String intCompID = "",
      String intCompInsID = "",
      int pageIndex = 0,
      int pageSize = 0,
      String strSearchText = "",
      String categoryIds = "",
      String forumContentID = ""}) async {
    Response? response;
    try {
      print(
          "......discussion forum....${ApiEndpoints.apiDiscussionMainHome()}");

      DiscussionMainHomeRequest discussionMainHomeRequest = DiscussionMainHomeRequest();
      discussionMainHomeRequest.intUserID = intUserID;
      discussionMainHomeRequest.intSiteID = intSiteID;
      discussionMainHomeRequest.strLocale = strLocale;
      discussionMainHomeRequest.intCompID = intCompID;
      discussionMainHomeRequest.intCompInsID = intCompInsID;
      discussionMainHomeRequest.pageIndex = pageIndex;
      discussionMainHomeRequest.pageSize = pageSize;
      discussionMainHomeRequest.strSearchText = strSearchText;
      discussionMainHomeRequest.categoryIds = categoryIds;
      discussionMainHomeRequest.forumContentID = forumContentID;

      String data = discussionMainHomeRequestToJson(discussionMainHomeRequest);

      response = await RestClient.postMethodData(ApiEndpoints.apiDiscussionMainHome(), data);

      print(
          "discussionForunStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionMainHomeRepositryPublic.getDiscussionMainHomeData():$e");
    }

    return response;
  }

  @override
  Future<Response?> getDiscussionForumLikeData(int forumId, int userID, int siteID, String localeID) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      String data =
          "${ApiEndpoints.strBaseUrl}/DiscussionForums/GetForumLevelLikeList?strObjectID=$forumId&intUserID=$userID&intSiteID=$siteID&strLocale=$localeID";

      print("&***** : " + data);

      response = await RestClient.getPostData(data);

      print(
          "discussionForunTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionMainHomeRepositryPublic.getDiscussionForumLikeData():$e");
    }

    return response;
  }

  @override
  Future<Response?> deleteDiscussionForumData(int forumID, int userID, int siteID, String localeID) async {
    Response? response;
    try {
      String data = "${ApiEndpoints.strBaseUrl}/DiscussionForums/DeleteForum?ForumID=$forumID&SiteID=$siteID&LocaleID=$localeID&UserID=$userID";
      response = await RestClient.getPostData(data);
      print(
          "discussionForunTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionMainHomeRepositryPublic.deleteDiscussionForumData():$e");
    }

    return response;
  }

  @override
  Future<Response?> commentDiscussionForumData(int forumID, String topicID, int userID, int siteID, String localeID) async {
    Response? response;
    try {
      String data = "${ApiEndpoints.strBaseUrl}/DiscussionForums/GetCommentList?intSiteID=$siteID&strLocale=$localeID&ForumID=$forumID&intUserID=$userID&TopicID=$topicID";
      response = await RestClient.getPostData(data);
      print(
          "discussionForunTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionMainHomeRepositryPublic.commentDiscussionForumData():$e");
    }

    return response;
  }

  @override
  Future<Response?> deleteCommentData(
      {String topicID = "",
      int forumID = 0,
      String replyID = "",
      String topicName = "",
      int siteID = 0,
      int userID = 0,
      String localeID = "",
      int noOfReplies = 0,
      String lastPostedDate = "",
      int createdUserID = 0,
      String attachmentPath = ""}) async {
    // TODO: implement discussionforumdata
    Response? response;
    try {
      print("......discussion comment....${ApiEndpoints.apiDeleteComment()}");

      DeleteCommentRequest deleteCommentRequest = new DeleteCommentRequest();
      deleteCommentRequest.topicID = topicID;
      deleteCommentRequest.forumID = forumID;
      deleteCommentRequest.replyID = replyID;
      deleteCommentRequest.topicName = topicName;
      deleteCommentRequest.siteID = siteID;
      deleteCommentRequest.userID = userID;
      deleteCommentRequest.localeID = localeID;
      deleteCommentRequest.noofReplies = noOfReplies;
      deleteCommentRequest.lastPostedDate = lastPostedDate;
      deleteCommentRequest.createdUserID = createdUserID;
      deleteCommentRequest.attachementPath = attachmentPath;

      String data = deleteCommentRequestToJson(deleteCommentRequest);

      response = await RestClient.postMethodData(
          ApiEndpoints.apiDeleteComment(), data);

      print(
          "discussionForunStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${response?.body}");
    } catch (e) {
      print(
          "Error in DiscussionMainHomeRepositryPublic.deleteCommentData():$e");
    }

    return response;
  }
}
