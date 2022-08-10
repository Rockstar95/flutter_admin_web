import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/like_dislike_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/topic_comment_reply_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class DiscussionTopicState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  DiscussionTopicState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  DiscussionTopicState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  DiscussionTopicState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialDetailsState extends DiscussionTopicState {
  IntitialDetailsState.completed(data) : super.completed(data);
}

class GetDiscussionTopicState extends DiscussionTopicState {
  DiscussionTopicResponse? data;

  GetDiscussionTopicState.loading(data) : super.loading(data);

  GetDiscussionTopicState.completed({this.data}) : super.completed(data);

  GetDiscussionTopicState.error(data) : super.error(data);
}

class AddTopicState extends DiscussionTopicState {
  String data = "";

  AddTopicState.loading(data) : super.loading(data);

  AddTopicState.completed({this.data = ""}) : super.completed(data);

  AddTopicState.error(data) : super.error(data);
}

class UploadAttachmentState extends DiscussionTopicState {
  String data = "";

  UploadAttachmentState.loading(data) : super.loading(data);

  UploadAttachmentState.completed({this.data = ""}) : super.completed(data);

  UploadAttachmentState.error(data) : super.error(data);
}

class EditTopicState extends DiscussionTopicState {
  String data = "";

  EditTopicState.loading(data) : super.loading(data);

  EditTopicState.completed({this.data = ""}) : super.completed(data);

  EditTopicState.error(data) : super.error(data);
}

class OpenFileExplorerState extends DiscussionTopicState {
  String fileName = "";

  OpenFileExplorerState.loading(data) : super.loading(data);

  OpenFileExplorerState.completed({this.fileName = ""})
      : super.completed(fileName);

  OpenFileExplorerState.error(data) : super.error(data);
}

class DeleteForumTopicState extends DiscussionTopicState {
  String data = "";

  DeleteForumTopicState.loading(data) : super.loading(data);

  DeleteForumTopicState.completed({this.data = ""}) : super.completed(data);

  DeleteForumTopicState.error(data) : super.error(data);
}

class TopicReplyState extends DiscussionTopicState {
  TopicCommentReplyResponse? data;

  TopicReplyState.loading(data) : super.loading(data);

  TopicReplyState.completed({this.data}) : super.completed(data);

  TopicReplyState.error(data) : super.error(data);
}

class DeleteReplyState extends DiscussionTopicState {
  String data = "";

  DeleteReplyState.loading(data) : super.loading(data);

  DeleteReplyState.completed({this.data = ""}) : super.completed(data);

  DeleteReplyState.error(data) : super.error(data);
}

class PinTopicState extends DiscussionTopicState {
  String data = "";
  bool isPinned = false;

  PinTopicState.loading(data) : super.loading(data);

  PinTopicState.completed({this.data = "", this.isPinned = false}) : super.completed(data);

  PinTopicState.error(data) : super.error(data);
}

class LikeDislikeState extends DiscussionTopicState {
  List<LikeDislikeListResponse> data = [];

  LikeDislikeState.loading(data) : super.loading(data);

  LikeDislikeState.completed({required this.data}) : super.completed(data);

  LikeDislikeState.error(data) : super.error(data);
}

class LikeCountState extends DiscussionTopicState {
  List<LikeDislikeListResponse> data = [];

  LikeCountState.loading(data) : super.loading(data);

  LikeCountState.completed({required this.data}) : super.completed(data);

  LikeCountState.error(data) : super.error(data);
}
