import 'package:flutter_admin_web/framework/bloc/discussion/model/discusiion_topic_user_list_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class CreateDiscussionState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  CreateDiscussionState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  CreateDiscussionState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  CreateDiscussionState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialDetailsState extends CreateDiscussionState {
  IntitialDetailsState.completed(data) : super.completed(data);
}

class CreateDiscussionDetailsState extends CreateDiscussionState {
  String data = "";

  CreateDiscussionDetailsState.loading(data) : super.loading(data);

  CreateDiscussionDetailsState.completed({this.data = ""})
      : super.completed(data);

  CreateDiscussionDetailsState.error(data) : super.error(data);
}

class OpenFileExplorerState extends CreateDiscussionState {
  String fileName = "";

  OpenFileExplorerState.loading(data) : super.loading(data);

  OpenFileExplorerState.completed({this.fileName = ""})
      : super.completed(fileName);

  OpenFileExplorerState.error(data) : super.error(data);
}

class GetDiscussionTopicUserListDetailsState extends CreateDiscussionState {
  List<DiscussionTopicUserListResponse> data = [];

  GetDiscussionTopicUserListDetailsState.loading(data) : super.loading(data);

  GetDiscussionTopicUserListDetailsState.completed({required this.data})
      : super.completed(data);

  GetDiscussionTopicUserListDetailsState.error(data) : super.error(data);
}
