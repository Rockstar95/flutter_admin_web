import 'package:flutter_admin_web/framework/bloc/feedback/model/feedbackresponse.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class FeedbackState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  FeedbackState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  FeedbackState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  FeedbackState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class IntitialFeedbackUploadState extends FeedbackState {
  IntitialFeedbackUploadState.completed(data) : super.completed(data);
}

class PostFeedbackState extends FeedbackState {
  String uploadRespose = "";

  PostFeedbackState.loading(data) : super.loading(data);

  PostFeedbackState.completed({this.uploadRespose = ""})
      : super.completed(uploadRespose);

  PostFeedbackState.error(data) : super.error(data);
}

class OpenFileExplorerState extends FeedbackState {
  String fileName = "";

  OpenFileExplorerState.loading(data) : super.loading(data);

  OpenFileExplorerState.completed({this.fileName = ""})
      : super.completed(fileName);

  OpenFileExplorerState.error(data) : super.error(data);
}

class GetFeedbackResponseState extends FeedbackState {
  List<FeedbackModel> feedbackList = [];

  GetFeedbackResponseState.loading(data) : super.loading(data);

  GetFeedbackResponseState.completed({required this.feedbackList})
      : super.completed(feedbackList);

  GetFeedbackResponseState.error(data) : super.error(data);
}

class DeleteFeedbackState extends FeedbackState {
  String response = '';

  DeleteFeedbackState.loading(data) : super.loading(data);

  DeleteFeedbackState.completed({this.response = ""})
      : super.completed(response);

  DeleteFeedbackState.error(data) : super.error(data);
}
