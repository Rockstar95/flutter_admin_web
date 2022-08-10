import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();
}

class FeedbackSubmitEvent extends FeedbackEvent {
  final bool isUrl;
  final String feedbackTitle;
  final String imageFileName;
  final String feedbackDesc;
  final String currentUrl;
  final String image;
  final String currentUserId;
  final String date2;
  final String currentSiteId;

  FeedbackSubmitEvent({
    this.isUrl = false,
    this.feedbackTitle = "",
    this.imageFileName = "",
    this.feedbackDesc = "",
    this.currentUrl = "",
    this.image = "",
    this.currentUserId = "",
    this.date2 = "",
    this.currentSiteId = "",
  });

  @override
  List<Object> get props => [
        isUrl,
        feedbackTitle,
        imageFileName,
        feedbackDesc,
        currentUrl,
        image,
        currentUserId,
        currentSiteId,
      ];
}

class OpenFileExplorerEvent extends FeedbackEvent {
  final FileType pickingType;

  OpenFileExplorerEvent(this.pickingType);

  @override
  // TODO: implement props
  List<Object> get props => [pickingType];
}

class GetFeedbackResponseEvent extends FeedbackEvent {
  final String isAdmin;

  GetFeedbackResponseEvent(this.isAdmin);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeleteFeedbackEvent extends FeedbackEvent {
  final int id;

  DeleteFeedbackEvent({this.id = 0});

  @override
  List<Object> get props => [
        id,
      ];
}
