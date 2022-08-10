import 'package:equatable/equatable.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/model/discussion_main_home_request.dart';

abstract class DiscussionMainHomeEvent extends Equatable {
  const DiscussionMainHomeEvent();
}

class SetDiscussionMainHomeDetails extends DiscussionMainHomeEvent {
  final DiscussionMainHomeRequest discussionMainHomeRequest;

  SetDiscussionMainHomeDetails({required this.discussionMainHomeRequest});

  @override
  List<Object> get props => [discussionMainHomeRequest];
}

class GetDiscussionMainHomeDetails extends DiscussionMainHomeEvent {
  final bool isEventTab;
  final String componentID;
  final String searchTxt;

  GetDiscussionMainHomeDetails(
      this.isEventTab, this.componentID, this.searchTxt);

  @override
  List<Object> get props => [isEventTab, componentID, searchTxt];
}

class GetDiscussionForumLikeListEvent extends DiscussionMainHomeEvent {
  final int forumId;

  GetDiscussionForumLikeListEvent({this.forumId = 0});

  @override
  List<Object> get props => [forumId];
}

class GetDiscussionForumCommentEvent extends DiscussionMainHomeEvent {
  final int forumId;
  final String topicID;

  GetDiscussionForumCommentEvent({this.forumId = 0, this.topicID = ""});

  @override
  List<Object> get props => [forumId, topicID];
}

class DeleteDiscussionForumEvent extends DiscussionMainHomeEvent {
  final int forumId;

  DeleteDiscussionForumEvent({this.forumId = 0});

  @override
  List<Object> get props => [forumId];
}

class DeleteCommentEvent extends DiscussionMainHomeEvent {
  final String topicID;
  final int forumID;
  final String replyID;
  final String topicName;
  final int noOfReplies;
  final String lastPostedDate;
  final int createdUserID;
  final String attachmentPath;

  DeleteCommentEvent({
    this.topicID = "",
    this.forumID = 0,
    this.replyID = "",
    this.topicName = "",
    this.noOfReplies = 0,
    this.lastPostedDate = "",
    this.createdUserID = 0,
    this.attachmentPath = "",
  });

  @override
  List<Object> get props => [
        topicID,
        forumID,
        replyID,
        topicName,
        noOfReplies,
        lastPostedDate,
        createdUserID,
        attachmentPath
      ];
}
