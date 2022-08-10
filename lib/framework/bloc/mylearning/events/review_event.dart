import 'package:equatable/equatable.dart';

abstract class ReviewEVent extends Equatable {
  const ReviewEVent();
}

class GetCurrentUserReviewEvent extends ReviewEVent {
  final String contentId;
  final int skippedRows;

  GetCurrentUserReviewEvent({
    this.contentId = "",
    this.skippedRows = 0,
  });

  @override
  List<Object> get props => [contentId];
}

class AddUserReviewEvent extends ReviewEVent {
  final String contentId;
  final String strReview;
  final int strRating;

  AddUserReviewEvent({
    this.contentId = "",
    this.strReview = "",
    this.strRating = 0,
  });

  @override
  List<Object> get props => [contentId, strReview, strRating];
}

class DeleteReviewEvent extends ReviewEVent {
  final String contentId;

  DeleteReviewEvent({this.contentId = ""});

  @override
  List<Object> get props => [contentId];
}
