import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class ReviewState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  ReviewState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  ReviewState.loading(data, {this.displayMessage = true}) : super.loading(data);

  ReviewState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class IntitialReviewState extends ReviewState {
  IntitialReviewState.completed(data) : super.completed(data);
}

class GetCurrentUserReviewState extends ReviewState {
  GetReviewResponse review = GetReviewResponse(userRatingDetails: []);

  GetCurrentUserReviewState.loading(data) : super.loading(data);

  GetCurrentUserReviewState.completed({required this.review})
      : super.completed(review);

  GetCurrentUserReviewState.error(data) : super.error(data);
}

class AddReviewState extends ReviewState {
  String isAdded = "";

  AddReviewState.loading(data) : super.loading(data);

  AddReviewState.completed({this.isAdded = ""}) : super.completed(isAdded);

  AddReviewState.error(data) : super.error(data);
}
