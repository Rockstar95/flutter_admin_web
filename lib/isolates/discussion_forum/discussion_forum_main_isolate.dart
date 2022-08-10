import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart';

import '../../framework/bloc/discussion/model/discusiion_comment_list_response.dart';
import '../../framework/bloc/discussion/model/discussion_forum_like_list_response.dart';
import '../../framework/bloc/discussion/model/discussion_main_home_response.dart';
import '../../framework/dataprovider/providers/rest_client.dart';
import '../../framework/helpers/ApiEndpoints.dart';
import '../../framework/repository/Discussion/model/discussion_main_home_request.dart';
import '../../main.dart';
import '../../utils/my_print.dart';

class DiscussionForumMainIsolate {
  static FutureOr<List<ForumList>> getDiscussionForumsIsolateMethod(List list) async {
    print("Received List:${list}");

    String url = list[0];
    String intUserID = list[1];
    String intSiteID = list[2];
    String siteUrl = list[3];
    String strLocale = list[4];
    String token = list[5];
    String intCompID = list[6];
    String intCompInsID = list[7];
    int pageIndex = list[8];
    int pageSize = list[9];
    String strSearchText = list[10];
    String categoryIds = list[11];
    String forumContentID = list[12];

    try {

      HttpOverrides.global = MyHttpOverrides();

      print("......discussion forum....${url}");

      DiscussionMainHomeRequest discussionMainHomeRequest = DiscussionMainHomeRequest();
      discussionMainHomeRequest.intUserID = int.tryParse(intUserID) ?? -1;
      discussionMainHomeRequest.intSiteID = int.tryParse(intSiteID) ?? -1;
      discussionMainHomeRequest.strLocale = strLocale;
      discussionMainHomeRequest.intCompID = intCompID;
      discussionMainHomeRequest.intCompInsID = intCompInsID;
      discussionMainHomeRequest.pageIndex = pageIndex;
      discussionMainHomeRequest.pageSize = pageSize;
      discussionMainHomeRequest.strSearchText = strSearchText;
      discussionMainHomeRequest.categoryIds = categoryIds;
      discussionMainHomeRequest.forumContentID = forumContentID;

      String data = discussionMainHomeRequestToJson(discussionMainHomeRequest);

      MyPrint.printOnConsole("Got Request");

      Response? apiResponse = await RestClient.postMethodData(
        url,
        data,
        isFetchDataFromSharedPreference: false,
        authtoken: token,
        userid: intUserID.toString(),
        siteId: intSiteID.toString(),
        siteUrl: siteUrl,
        language: strLocale,
      );

      print("discussionForunStateCode statusCode :- ${apiResponse?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${apiResponse?.body}");

      DiscussionMainHomeResponse response = discussionMainHomeResponseFromJson(apiResponse?.body ?? "{}");

      return response.forumList;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in DiscussionForumMainIsolate.getDiscussionForumsIsolateMethod:$e");
      MyPrint.printOnConsole(s);
      return <ForumList>[];
    }
  }

  static FutureOr<List<DiscussionForumLikeListResponse>> getDiscussionForumLikeDataIsolateMethod(List list) async {
    print("Received List:${list}");

    String url = list[0];
    String intUserID = list[1];
    String intSiteID = list[2];
    String siteUrl = list[3];
    String strLocale = list[4];
    String token = list[5];

    try {

      HttpOverrides.global = MyHttpOverrides();

      Response? response = await RestClient.getPostData(
        url,
        isFetchDataFromSharedPreference: false,
        authtoken: token,
        userid: intUserID.toString(),
        siteId: intSiteID.toString(),
        siteUrl: siteUrl,
        language: strLocale,
      );

      List<DiscussionForumLikeListResponse> likeList = discussionForumLikeListResponseFromJson(response?.body ?? "[]");

      return likeList;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in DiscussionForumMainIsolate.getDiscussionForumLikeDataIsolateMethod:$e");
      MyPrint.printOnConsole(s);
      return <DiscussionForumLikeListResponse>[];
    }
  }

  static FutureOr<List<DiscussionCommentListResponse>> getDiscussionForumTopicCommentsListIsolateMethod(List list) async {
    print("Received List:${list}");

    String url = list[0];
    String intUserID = list[1];
    String intSiteID = list[2];
    String siteUrl = list[3];
    String strLocale = list[4];
    String token = list[5];

    try {

      HttpOverrides.global = MyHttpOverrides();

      Response? response = await RestClient.getPostData(
        url,
        isFetchDataFromSharedPreference: false,
        authtoken: token,
        userid: intUserID.toString(),
        siteId: intSiteID.toString(),
        siteUrl: siteUrl,
        language: strLocale,
      );

      List<DiscussionCommentListResponse> commentsList = discussionCommentListResponseFromJson(response?.body ?? "[]");

      return commentsList;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in DiscussionForumMainIsolate.getDiscussionForumLikeDataIsolateMethod:$e");
      MyPrint.printOnConsole(s);
      return <DiscussionCommentListResponse>[];
    }
  }
}

void getDiscussionForumsIsolateMethod(SendPort mainSendPort) async {
  ReceivePort newIsolateReceivePort = ReceivePort();
  //Second Transaction of Page Method(Sending Sendport of Isolate Method)
  mainSendPort.send(newIsolateReceivePort.sendPort);

  //Third Transaction of Page Method(Receiving Data from Page Method)
  List list = await newIsolateReceivePort.first;
  print("Received List:${list}");

  String url = list[0];
  String intUserID = list[1];
  String intSiteID = list[2];
  String siteUrl = list[3];
  String strLocale = list[4];
  String token = list[5];
  String intCompID = list[6];
  String intCompInsID = list[7];
  int pageIndex = list[8];
  int pageSize = list[9];
  String strSearchText = list[10];
  String categoryIds = list[11];
  String forumContentID = list[12];
  SendPort replyPort = list[13];

  try {

    HttpOverrides.global = MyHttpOverrides();

    print("......discussion forum....${ApiEndpoints.apiDiscussionMainHome()}");

    DiscussionMainHomeRequest discussionMainHomeRequest = DiscussionMainHomeRequest();
    discussionMainHomeRequest.intUserID = int.tryParse(intUserID) ?? -1;
    discussionMainHomeRequest.intSiteID = int.tryParse(intSiteID) ?? -1;
    discussionMainHomeRequest.strLocale = strLocale;
    discussionMainHomeRequest.intCompID = intCompID;
    discussionMainHomeRequest.intCompInsID = intCompInsID;
    discussionMainHomeRequest.pageIndex = pageIndex;
    discussionMainHomeRequest.pageSize = pageSize;
    discussionMainHomeRequest.strSearchText = strSearchText;
    discussionMainHomeRequest.categoryIds = categoryIds;
    discussionMainHomeRequest.forumContentID = forumContentID;

    String data = discussionMainHomeRequestToJson(discussionMainHomeRequest);

    MyPrint.printOnConsole("Got Request");

    //Response? apiResponse = await RestClient.postMethodData(ApiEndpoints.apiDiscussionMainHome(), data);
    //Response? apiResponse = await RestClient.postMethodData(url, data);

    Response? apiResponse = await RestClient.postMethodData(
      url,
      data,
      isFetchDataFromSharedPreference: false,
      authtoken: token,
      userid: intUserID.toString(),
      siteId: intSiteID.toString(),
      siteUrl: siteUrl,
      language: strLocale,
    );

    print("discussionForunStateCode statusCode :- ${apiResponse?.statusCode.toString()}");
    print("discussionForunObjectData Response :- ${apiResponse?.body}");

    DiscussionMainHomeResponse response = discussionMainHomeResponseFromJson(apiResponse?.body ?? "{}");

    replyPort.send(response.forumList);
  }
  catch (e, s) {
    MyPrint.printOnConsole("Error in getDiscussionForumsIsolateMethod Isolate:${e}");
    MyPrint.printOnConsole(s);
    replyPort.send([]);
  }
}

