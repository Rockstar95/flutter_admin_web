import 'package:flutter_admin_web/framework/bloc/discussion/model/discusiion_comment_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_forum_like_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class DiscussionMainHomeState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  DiscussionMainHomeState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  DiscussionMainHomeState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  DiscussionMainHomeState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialDetailsState extends DiscussionMainHomeState {
  IntitialDetailsState.completed(data) : super.completed(data);
}

class GetDiscussionMainHomeDetailsState extends DiscussionMainHomeState {
  DiscussionMainHomeResponse? data;

  GetDiscussionMainHomeDetailsState.loading(data) : super.loading(data);

  GetDiscussionMainHomeDetailsState.completed({this.data})
      : super.completed(data);

  GetDiscussionMainHomeDetailsState.error(data) : super.error(data);
}

class GetDiscussionForumLikeListState extends DiscussionMainHomeState {
  List<DiscussionForumLikeListResponse> data = [];

  GetDiscussionForumLikeListState.loading(data) : super.loading(data);

  GetDiscussionForumLikeListState.completed({required this.data})
      : super.completed(data);

  GetDiscussionForumLikeListState.error(data) : super.error(data);
}

class DeleteDiscussionForumState extends DiscussionMainHomeState {
  String data = "";

  DeleteDiscussionForumState.loading(data) : super.loading(data);

  DeleteDiscussionForumState.completed({this.data = ""})
      : super.completed(data);

  DeleteDiscussionForumState.error(data) : super.error(data);
}

class DiscussionForumCommentState extends DiscussionMainHomeState {
  List<DiscussionCommentListResponse> data = [];

  DiscussionForumCommentState.loading(data) : super.loading(data);

  DiscussionForumCommentState.completed({required this.data})
      : super.completed(data);

  DiscussionForumCommentState.error(data) : super.error(data);
}

class DeleteCommentState extends DiscussionMainHomeState {
  String data = "";

  DeleteCommentState.loading(data) : super.loading(data);

  DeleteCommentState.completed({this.data = ""}) : super.completed(data);

  DeleteCommentState.error(data) : super.error(data);
}
