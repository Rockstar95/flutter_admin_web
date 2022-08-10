import 'package:flutter_admin_web/framework/bloc/feedback/model/feedbackresponse.dart';
import 'package:flutter_admin_web/framework/bloc/learningcommunities/model/learningcommunitiesresponse.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class CommunitiesState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  CommunitiesState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  CommunitiesState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  CommunitiesState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialCommunitiesState extends CommunitiesState {
  IntitialCommunitiesState.completed(data) : super.completed(data);
}

class GetCommunitiesResponseState extends CommunitiesState {
  LearningCommunitiesResponse? learningCommunitiesresponse;

  GetCommunitiesResponseState.loading(data) : super.loading(data);

  GetCommunitiesResponseState.completed({this.learningCommunitiesresponse})
      : super.completed(learningCommunitiesresponse);

  GetCommunitiesResponseState.error(data) : super.error(data);
}

class GetFeedbackResponseState extends CommunitiesState {
  List<FeedbackModel> feedbackList = [];

  GetFeedbackResponseState.loading(data) : super.loading(data);

  GetFeedbackResponseState.completed({required this.feedbackList})
      : super.completed(feedbackList);

  GetFeedbackResponseState.error(data) : super.error(data);
}

class LoginorGotoSubsiteState extends CommunitiesState {
  String response = "";
  PortalListing? portalListing;

  LoginorGotoSubsiteState.loading(data) : super.loading(data);

  LoginorGotoSubsiteState.completed({this.response = "", required this.portalListing}) : super.completed(response);

  LoginorGotoSubsiteState.error(data) : super.error(data);
}
