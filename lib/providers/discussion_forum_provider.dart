import 'package:flutter/foundation.dart';

import '../framework/bloc/discussion/model/discusiion_comment_list_response.dart';
import '../framework/bloc/discussion/model/discussion_forum_like_list_response.dart';
import '../framework/bloc/discussion/model/discussion_main_home_response.dart';

class DiscussionForumProvider extends ChangeNotifier {
  List<ForumList> list = [];
  List<ForumList> myDiscussionForumList = [];
  List<DiscussionForumLikeListResponse> discussionForumLikeList = [];
  List<DiscussionCommentListResponse> discussionCommentList = [];

  //For venues Search
  int discussionsPageLimit = 10, refreshLimit = 3;
  bool hasMoreDiscussions = true, isDiscussionsLoading = false, isFirstTimeLoadingDiscussions = false;
  int discussionsPageIndex = 1;
  String dicussionsSearchString = "";
}