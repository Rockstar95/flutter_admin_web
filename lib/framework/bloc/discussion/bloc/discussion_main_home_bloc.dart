import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_main_home_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discusiion_comment_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_forum_like_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_main_home_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussion_main_home_repository.dart';
import 'package:intl/intl.dart';

class DiscussionMainHomeBloc extends Bloc<DiscussionMainHomeEvent, DiscussionMainHomeState> {
  DiscussionMainHomeRepository discussionMainHomeRepositry;

  List<ForumList> list = [];
  List<ForumList> myDiscussionForumList = [];
  List<DiscussionForumLikeListResponse> discussionForumLikeList = [];
  List<DiscussionCommentListResponse> discussionCommentList = [];

  final formatter = DateFormat('MM/dd/yyyy HH:mm:ss');
  bool isFirstLoading = true;
  bool isCreateForum = false;
  bool isEditForum = false;
  bool isDeleteForum = false;
  bool isForumSearch = false;
  String SearchForumString = "";
  bool isFilterMenu = true;
  String strUserID = "";

  DiscussionMainHomeBloc({
    required this.discussionMainHomeRepositry,
  }) : super(DiscussionMainHomeState.completed(null)) {
    on<SetDiscussionMainHomeDetails>(onEventHandler);
    on<GetDiscussionMainHomeDetails>(onEventHandler);
    on<GetDiscussionForumLikeListEvent>(onEventHandler);
    on<GetDiscussionForumCommentEvent>(onEventHandler);
    on<DeleteDiscussionForumEvent>(onEventHandler);
    on<DeleteCommentEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(DiscussionMainHomeEvent event, Emitter emit) async {
    print("DiscussionMainHomeBloc onEventHandler called for ${event.runtimeType}");
    Stream<DiscussionMainHomeState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (DiscussionMainHomeState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  DiscussionMainHomeState get initialState => IntitialDetailsState.completed("Intitalized");

  @override
  Stream<DiscussionMainHomeState> mapEventToState(DiscussionMainHomeEvent event) async* {
    strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var language = await sharePrefGetString(sharedPref_AppLocale);
    var strComponentID = await sharePrefGetString(sharedPref_ComponentID);
    var strRepositoryId = await sharePrefGetString(sharedPref_RepositoryId);

    try {
      if (event is GetDiscussionMainHomeDetails) {
        yield GetDiscussionMainHomeDetailsState.loading('Please wait');
        Response? apiResponse;

        print("isEventTab:${event.isEventTab}");
        print("Component Id:${event.componentID}");
        //print("User Id:${strUserID}");

        if (!event.isEventTab) {
          apiResponse =
              await discussionMainHomeRepositry.getDiscussionMainHomeData(
                  intUserID: int.parse(strUserID),
                  intSiteID: int.parse(strSiteID),
                  strLocale: language,
                  intCompID: strComponentID,
                  intCompInsID: strRepositoryId,
                  pageIndex: 1,
                  pageSize: 100,
                  strSearchText: event.searchTxt,
                  categoryIds: '',
              );
        }
        else {
          apiResponse =
              await discussionMainHomeRepositry.getDiscussionMainHomeData(
                  intUserID: int.parse(strUserID),
                  intSiteID: int.parse(strSiteID),
                  strLocale: language,
                  intCompID: '-1',
                  intCompInsID: '-1',
                  pageIndex: 1,
                  pageSize: 100,
                  strSearchText: '',
                  categoryIds: '',
                  forumContentID: event.componentID);
        }

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          DiscussionMainHomeResponse response = discussionMainHomeResponseFromJson(apiResponse?.body ?? "{}");

          list = response.forumList;
          myDiscussionForumList.clear();
          for (int i = 0; i < list.length; i++) {
            if (list[i].createdUserID == int.parse(strUserID)) {
              myDiscussionForumList.add(list[i]);
            }
          }
          yield GetDiscussionMainHomeDetailsState.completed(data: response);
        }
        else if (apiResponse?.statusCode == 401) {
          yield GetDiscussionMainHomeDetailsState.error('401');
        }
        else {
          yield GetDiscussionMainHomeDetailsState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is GetDiscussionForumLikeListEvent) {
        yield GetDiscussionForumLikeListState.loading('Please wait');

        Response? apiResponse = await discussionMainHomeRepositry.getDiscussionForumLikeData(
          event.forumId,
          int.parse(strUserID),
          int.parse(strSiteID),
          language,
        );
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          //Response response = await RestClient.getPostData(paramsString);

          List<DiscussionForumLikeListResponse> response = discussionForumLikeListResponseFromJson(apiResponse?.body ?? "[]");

          discussionForumLikeList = response;

          print("size : " + response.toString());
          yield GetDiscussionForumLikeListState.completed(data: response);
        }
        else if (apiResponse?.statusCode == 401) {
          yield GetDiscussionForumLikeListState.error('401');
        }
        else {
          yield GetDiscussionForumLikeListState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is DeleteDiscussionForumEvent) {
        yield DeleteDiscussionForumState.loading('Please wait');

        Response? apiResponse = await discussionMainHomeRepositry.deleteDiscussionForumData(
          event.forumId,
          int.parse(strUserID),
          int.parse(strSiteID),
          language,
        );
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          //Response response = await RestClient.getPostData(paramsString);
          yield DeleteDiscussionForumState.completed(data: apiResponse?.body ?? "{}");
        }
        else if (apiResponse?.statusCode == 401) {
          yield DeleteDiscussionForumState.error('401');
        }
        else {
          yield DeleteDiscussionForumState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is GetDiscussionForumCommentEvent) {
        yield DiscussionForumCommentState.loading('Please wait');

        Response? apiResponse =
            await discussionMainHomeRepositry.commentDiscussionForumData(
                event.forumId,
                event.topicID,
                int.parse(strUserID),
                int.parse(strSiteID),
                language);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          List<DiscussionCommentListResponse> response = discussionCommentListResponseFromJson(apiResponse?.body ?? "[]");

          discussionCommentList = response;
          //Response response = await RestClient.getPostData(paramsString);
          yield DiscussionForumCommentState.completed(data: response);
        } else if (apiResponse?.statusCode == 401) {
          yield DiscussionForumCommentState.error('401');
        } else {
          yield DiscussionForumCommentState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is DeleteCommentEvent) {
        yield DeleteCommentState.loading('Please wait');
        Response? apiResponse =
            await discussionMainHomeRepositry.deleteCommentData(
                topicID: event.topicID,
                forumID: event.forumID,
                replyID: event.replyID,
                topicName: event.topicName,
                siteID: int.parse(strSiteID),
                userID: int.parse(strUserID),
                localeID: language,
                noOfReplies: event.noOfReplies,
                lastPostedDate: event.lastPostedDate,
                createdUserID: event.createdUserID,
                attachmentPath: event.attachmentPath);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield DeleteCommentState.completed(data: apiResponse?.body ?? "");
        } else if (apiResponse?.statusCode == 401) {
          yield DeleteCommentState.error('401');
        } else {
          yield DeleteCommentState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
    }
    catch (e, s) {
      isFirstLoading = false;
      print("Error in DiscussionMainHomeBloc.mapEventToState():$e");
      print(s);

      //yield GetListState.error("Error  $e");
    }
  }
}
