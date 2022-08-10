import 'package:flutter_admin_web/framework/bloc/discussion/model/discusiion_comment_list_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class DiscussionTopicCommentState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  DiscussionTopicCommentState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  DiscussionTopicCommentState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  DiscussionTopicCommentState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialDetailsState extends DiscussionTopicCommentState {
  IntitialDetailsState.completed(data) : super.completed(data);
}

class GetDiscussionTopicCommentDetailsState
    extends DiscussionTopicCommentState {
  String data = "";

  GetDiscussionTopicCommentDetailsState.loading(data) : super.loading(data);

  GetDiscussionTopicCommentDetailsState.completed({this.data = ""})
      : super.completed(data);

  GetDiscussionTopicCommentDetailsState.error(data) : super.error(data);
}

class GetDiscussionTopicCommentListDetailsState
    extends DiscussionTopicCommentState {
  List<DiscussionCommentListResponse> data = [];

  GetDiscussionTopicCommentListDetailsState.loading(data) : super.loading(data);

  GetDiscussionTopicCommentListDetailsState.completed({required this.data})
      : super.completed(data);

  GetDiscussionTopicCommentListDetailsState.error(data) : super.error(data);
}

class GetDiscussionTopicReplyDetailsState extends DiscussionTopicCommentState {
  String data = "";

  GetDiscussionTopicReplyDetailsState.loading(data) : super.loading(data);

  GetDiscussionTopicReplyDetailsState.completed({this.data = ""})
      : super.completed(data);

  GetDiscussionTopicReplyDetailsState.error(data) : super.error(data);
}

class OpenFileExplorerState extends DiscussionTopicCommentState {
  String fileName = "";

  OpenFileExplorerState.loading(data) : super.loading(data);

  OpenFileExplorerState.completed({this.fileName = ""})
      : super.completed(fileName);

  OpenFileExplorerState.error(data) : super.error(data);
}
