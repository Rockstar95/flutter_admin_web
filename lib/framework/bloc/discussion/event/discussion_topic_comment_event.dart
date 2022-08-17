import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/model/discussion_topic_comment_request.dart';

abstract class DiscussionTopicCommentEvent extends Equatable {
  const DiscussionTopicCommentEvent();
}

class SetDiscussionTopicCommentDetails extends DiscussionTopicCommentEvent {
  final DiscussionTopicCommentRequest discussionTopicCommentRequest;

  SetDiscussionTopicCommentDetails(
      {required this.discussionTopicCommentRequest});

  @override
  List<Object> get props => [discussionTopicCommentRequest];
}

class GetDiscussionTopicCommentDetails extends DiscussionTopicCommentEvent {
  final String topicID;
  final String topicName;
  final int forumID;
  final String forumTitle;
  final String message;
  final String strAttachFil;
  final String strReplyID;
  final Uint8List? fileBytes;
  final String fileName;

  GetDiscussionTopicCommentDetails(
      {this.topicID = "",
      this.topicName = "",
      this.forumID = 0,
      this.forumTitle = "",
      this.message = "",
      this.strAttachFil = "",
      this.strReplyID = "",
      this.fileBytes,
      this.fileName = ""});

  @override
  List<Object> get props => [
        topicID,
        topicName,
        forumID,
        forumTitle,
        message,
        strAttachFil,
        strReplyID,
        fileName
      ];
}

class GetDiscussionTopicCommentListDetails extends DiscussionTopicCommentEvent {
  final int forumID;
  final String topicID;

  GetDiscussionTopicCommentListDetails({
    this.forumID = 0,
    this.topicID = ""});

  @override
  List<Object> get props => [forumID, topicID];
}

class GetDiscussionTopicCommentReplyEvent extends DiscussionTopicCommentEvent {
  final int strCommentID;
  final String topicID;
  final int forumID;
  final String involvedUserIDList;
  final String topicName;
  final String strAttachFile;
  final String message;
  final String strReplyID;
  final String forumTitle;
  final String strCommentTxt;

  GetDiscussionTopicCommentReplyEvent(
      {this.strCommentID = 0,
      this.topicID = "",
      this.forumID = 0,
      this.involvedUserIDList = "",
      this.topicName = "",
      this.strAttachFile = "",
      this.message = "",
      this.strReplyID = "",
      this.forumTitle = "",
      this.strCommentTxt = ""});

  @override
  List<Object> get props => [
        strCommentID,
        topicID,
        forumID,
        involvedUserIDList,
        topicName,
        strAttachFile,
        message,
        strReplyID,
        forumTitle,
        strCommentTxt
      ];
}

class OpenFileExplorerEvent extends DiscussionTopicCommentEvent {
  final FileType pickingType;

  OpenFileExplorerEvent(this.pickingType);

  @override
  List<Object> get props => [pickingType];
}
