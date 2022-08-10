import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/isolates/discussion_forum/discussion_forum_main_isolate.dart';

import '../../framework/bloc/discussion/model/discusiion_comment_list_response.dart';
import '../../framework/bloc/discussion/model/discussion_forum_like_list_response.dart';
import '../../framework/bloc/discussion/model/discussion_main_home_response.dart';
import '../../framework/common/constants.dart';
import '../../framework/common/pref_manger.dart';
import '../../framework/dataprovider/providers/rest_client.dart';
import '../../framework/helpers/ApiEndpoints.dart';
import '../../framework/repository/Discussion/discussionTopic/model/delete_comment_request.dart';
import '../../utils/my_print.dart';

class DiscussionForumRepositoryMain {
  Future<List<ForumList>> getDiscussionMainHomeDataUsingIsolate({int pageIndex = 1, int pageSize = 10, String searchString = "", String categoryIds = "",
    String forumContentID = "", bool isEventTab = true, String strComponentID = "", String strRepositoryId = ""}) async {

    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);

    try {
      ReceivePort receivePort = ReceivePort();
      Isolate newIsolate = await Isolate.spawn(
        getDiscussionForumsIsolateMethod,
        receivePort.sendPort,
      );

      //Second Transaction(Receiving Sendport From Isolate Method)
      dynamic value1 = await receivePort.first;

      SendPort newIsolateSendPort = value1 as SendPort;
      MyPrint.printOnConsole("NewIsolateSendPort Received");

      ReceivePort responsePort = ReceivePort();
      //Third Transaction(Sending Data on Isolate's Sendport)

      if(!isEventTab) {
        newIsolateSendPort.send([
          ApiEndpoints.apiDiscussionMainHome(),
          strUserID,
          strSiteID,
          ApiEndpoints.strSiteUrl,
          language,
          token,
          strComponentID,
          strRepositoryId,
          pageIndex,
          pageSize,
          searchString,
          categoryIds,
          forumContentID,
          responsePort.sendPort,
        ]);
      }
      else {
        newIsolateSendPort.send([
          ApiEndpoints.apiDiscussionMainHome(),
          strUserID,
          strSiteID,
          ApiEndpoints.strSiteUrl,
          language,
          token,
          "-1",
          "-1",
          pageIndex,
          pageSize,
          searchString,
          categoryIds,
          forumContentID,
          responsePort.sendPort,
        ]);
      }

      //Fourth Transaction(Receiving Data From Isolate)
      dynamic value2 = await responsePort.first;

      List<ForumList> forums = List.from(value2 is List<ForumList> ? value2 : <ForumList>[]);
      MyPrint.printOnConsole("Forums Length:${forums}");

      return forums;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in DiscussionForumControllerSecondary.getDiscussionMainHomeData():$e");
      MyPrint.printOnConsole(s);
    }

    return [];
  }

  Future<List<ForumList>> getDiscussionMainHomeDataUsingCompute({int pageIndex = 0, int pageSize = 10, String searchString = "", String categoryIds = "",
    String forumContentID = "", bool isEventTab = true, String strComponentID = "", String strRepositoryId = ""}) async {

    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);

    try {
      List<ForumList> forums = [];

      if(!isEventTab) {
        forums = await compute<List, List<ForumList>>(DiscussionForumMainIsolate.getDiscussionForumsIsolateMethod, [
          ApiEndpoints.apiDiscussionMainHome(),
          strUserID,
          strSiteID,
          ApiEndpoints.strSiteUrl,
          language,
          token,
          strComponentID,
          strRepositoryId,
          pageIndex,
          pageSize,
          searchString,
          categoryIds,
          forumContentID,
        ]).catchError((e, s) {
          MyPrint.printOnConsole("Error in Getting Forums List from Isolate:$e");
          MyPrint.printOnConsole(s);
          return <ForumList>[];
        });
      }
      else {
        forums = await compute<List, List<ForumList>>(DiscussionForumMainIsolate.getDiscussionForumsIsolateMethod, [
          ApiEndpoints.apiDiscussionMainHome(),
          strUserID,
          strSiteID,
          ApiEndpoints.strSiteUrl,
          language,
          token,
          "-1",
          "-1",
          pageIndex,
          pageSize,
          searchString,
          categoryIds,
          forumContentID,
        ]).catchError((e, s) {
          MyPrint.printOnConsole("Error in Getting Forums List from Isolate:$e");
          MyPrint.printOnConsole(s);
          return <ForumList>[];
        });
      }
      MyPrint.printOnConsole("Forums Length:${forums}");

      return forums;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in DiscussionForumControllerSecondary.getDiscussionMainHomeData():$e");
      MyPrint.printOnConsole(s);
    }

    return [];
  }

  Future<List<DiscussionForumLikeListResponse>> getDiscussionForumLikeData(int forumId) async {
    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);

    List<DiscussionForumLikeListResponse> likeList = await compute<List, List<DiscussionForumLikeListResponse>>(DiscussionForumMainIsolate.getDiscussionForumLikeDataIsolateMethod, [
      "${ApiEndpoints.strBaseUrl}/DiscussionForums/GetForumLevelLikeList?strObjectID=$forumId&intUserID=$strUserID&intSiteID=$strSiteID&strLocale=$language",
      strUserID,
      strSiteID,
      ApiEndpoints.strSiteUrl,
      language,
      token,
    ]).catchError((e, s) {
      MyPrint.printOnConsole("Error in Getting Forums List from Isolate:$e");
      MyPrint.printOnConsole(s);
      return <DiscussionForumLikeListResponse>[];
    });

    return likeList;
  }

  Future<bool> deleteDiscussionForum(String forumID) async {
    bool isDeleted = false;

    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);

    try {
      String data = "${ApiEndpoints.strBaseUrl}/DiscussionForums/DeleteForum?ForumID=$forumID&SiteID=$strSiteID&LocaleID=$language&UserID=$strUserID";
      Response? apiResponse = await RestClient.getPostData(data);
      if (apiResponse?.statusCode == 200) {
        isDeleted = true;
      }
      MyPrint.printOnConsole("deleteDiscussionForum Response Status:${apiResponse?.statusCode}");
      MyPrint.logOnConsole("deleteDiscussionForum Response Body:${apiResponse?.body}");
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in DiscussionForumRepositoryMain().deleteDiscussionForum():$e");
      MyPrint.printOnConsole(s);
    }

    return isDeleted;
  }

  Future<List<DiscussionCommentListResponse>> getDiscussionForumTopicCommentsList(int forumId, String topicId) async {
    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);
    String token = await sharePrefGetString(sharedPref_bearer);

    List<DiscussionCommentListResponse> commentsList = await compute<List, List<DiscussionCommentListResponse>>(DiscussionForumMainIsolate.getDiscussionForumTopicCommentsListIsolateMethod, [
      "${ApiEndpoints.strBaseUrl}/DiscussionForums/GetCommentList?intSiteID=$strSiteID&strLocale=$language&ForumID=$forumId&intUserID=$strUserID&TopicID=$topicId",
      strUserID,
      strSiteID,
      ApiEndpoints.strSiteUrl,
      language,
      token,
    ]).catchError((e, s) {
      MyPrint.printOnConsole("Error in Getting Forums List from Isolate:$e");
      MyPrint.printOnConsole(s);
      return <DiscussionCommentListResponse>[];
    });

    return commentsList;
  }

  Future<bool> deleteCommentForTopicAndForum(ForumList forumModel, TopicList topicModel, DiscussionCommentListResponse commentModel) async {
    bool isDeleted = false;

    String strUserID = await sharePrefGetString(sharedPref_userid);
    String strSiteID = await sharePrefGetString(sharedPref_siteid);
    String language = await sharePrefGetString(sharedPref_AppLocale);

    try {
      DeleteCommentRequest deleteCommentRequest = new DeleteCommentRequest();
      deleteCommentRequest.topicID = topicModel.contentID;
      deleteCommentRequest.forumID = forumModel.forumID;
      deleteCommentRequest.replyID = commentModel.replyID;
      deleteCommentRequest.topicName = topicModel.name;
      deleteCommentRequest.siteID = int.tryParse(strSiteID) ?? -1;
      deleteCommentRequest.userID = int.tryParse(strUserID) ?? -1;
      deleteCommentRequest.localeID = language;
      deleteCommentRequest.noofReplies = topicModel.noOfReplies - 1;
      deleteCommentRequest.lastPostedDate = commentModel.posteddate;
      deleteCommentRequest.createdUserID = commentModel.postedby;
      deleteCommentRequest.attachementPath = "";

      String data = deleteCommentRequestToJson(deleteCommentRequest);

      Response? apiResponse = await RestClient.postMethodData(ApiEndpoints.apiDeleteComment(), data);

      if (apiResponse?.statusCode == 200) {
        isDeleted = true;
      }
      MyPrint.printOnConsole("deleteDiscussionForum Response Status:${apiResponse?.statusCode}");
      MyPrint.logOnConsole("deleteDiscussionForum Response Body:${apiResponse?.body}");
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in DiscussionForumRepositoryMain().deleteDiscussionForum():$e");
      MyPrint.printOnConsole(s);
    }

    return isDeleted;
  }
}

