import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class DiscussionTopicEvent extends Equatable {
  const DiscussionTopicEvent();
}

class GetDiscussionTopicDetails extends DiscussionTopicEvent {
  final int forumId;

  GetDiscussionTopicDetails({this.forumId = 0});

  @override
  List<Object> get props => [
        forumId,
      ];
}

class AddTopicEvent extends DiscussionTopicEvent {
  final String strAttachFile;
  final int userID;
  final int orgID;
  final int forumID;
  final String strContentID;
  final String description;
  final String localeID;
  final int siteID;
  final String title;
  final String forumName;

  AddTopicEvent(
      {this.strAttachFile = "",
      this.userID = 0,
      this.orgID = 0,
      this.forumID = 0,
      this.strContentID = "",
      this.description = "",
      this.localeID = "",
      this.siteID = 0,
      this.title = "",
      this.forumName = ""});

  @override
  List<Object> get props => [
        strAttachFile,
        userID,
        orgID,
        forumID,
        strContentID,
        description,
        localeID,
        siteID,
        title,
        forumName
      ];
}

class UploadAttachmentEvent extends DiscussionTopicEvent {
  final String topicID;
  final String replyID;
  final bool isTopic;
  final String fileName;
  final String filePath;

  UploadAttachmentEvent(
      {this.topicID = "",
      this.replyID = "",
      this.isTopic = false,
      this.fileName = "",
      this.filePath = ""});

  @override
  List<Object> get props => [topicID, replyID, isTopic, fileName, filePath];
}

class EditTopicEvent extends DiscussionTopicEvent {
  final String strAttachFile;
  final int userID;
  final int orgID;
  final int forumID;
  final String strContentID;
  final String description;
  final String localeID;
  final int siteID;
  final String title;
  final String forumName;

  EditTopicEvent(
      {this.strAttachFile = "",
      this.userID = 0,
      this.orgID = 0,
      this.forumID = 0,
      this.strContentID = "",
      this.description = "",
      this.localeID = "",
      this.siteID = 0,
      this.title = "",
      this.forumName = ""});

  @override
  List<Object> get props => [
        strAttachFile,
        userID,
        orgID,
        forumID,
        strContentID,
        description,
        localeID,
        siteID,
        title,
        forumName
      ];
}

class OpenFileExplorerTopicEvent extends DiscussionTopicEvent {
  final FileType pickingType;

  OpenFileExplorerTopicEvent(this.pickingType);

  @override
  List<Object> get props => [pickingType];
}

class DeleteForumTopicEvent extends DiscussionTopicEvent {
  final String topicID;
  final int forumID;
  final String forumName;

  DeleteForumTopicEvent({
    this.topicID = "",
    this.forumID = 0,
    this.forumName = "",
  });

  @override
  List<Object> get props => [topicID, forumID, forumName];
}

class TopicReplyEvent extends DiscussionTopicEvent {
  final int commentId;

  TopicReplyEvent({
    this.commentId = 0,
  });

  @override
  List<Object> get props => [commentId];
}

class DeleteReplyEvent extends DiscussionTopicEvent {
  final int replyID;

  DeleteReplyEvent({
    this.replyID = 0,
  });

  @override
  // TODO: implement props
  List<Object> get props => [replyID];
}

class PinTopicEvent extends DiscussionTopicEvent {
  final int forumID;
  final String strContentID;
  final bool isPin;

  PinTopicEvent({
    this.forumID = 0,
    this.strContentID = "",
    this.isPin = false,
  });

  @override
  List<Object> get props => [forumID, strContentID, isPin];
}

class LikeDisLikeEvent extends DiscussionTopicEvent {
  final String strObjectID;
  final int intTypeID;
  final bool blnIsLiked;

  LikeDisLikeEvent({
    this.strObjectID = "",
    this.intTypeID = 0,
    this.blnIsLiked = false,
  });

  @override
  List<Object> get props => [
        strObjectID,
        intTypeID,
        blnIsLiked,
      ];
}

class LikeCountEvent extends DiscussionTopicEvent {
  final String strObjectID;
  final int intTypeID;

  LikeCountEvent({
    this.strObjectID = "",
    this.intTypeID = 0,
  });

  @override
  List<Object> get props => [
        strObjectID,
        intTypeID,
      ];
}
