import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/model/discussion_main_home_request.dart';

abstract class CreateDiscussionEvent extends Equatable {
  const CreateDiscussionEvent();
}

class SetDiscussionMainHomeDetails extends CreateDiscussionEvent {
  final DiscussionMainHomeRequest discussionMainHomeRequest;

  SetDiscussionMainHomeDetails({required this.discussionMainHomeRequest});

  @override
  List<Object> get props => [discussionMainHomeRequest];
}

class OpenFileExplorerEvent extends CreateDiscussionEvent {
  final FileType pickingType;

  OpenFileExplorerEvent(this.pickingType);

  @override
  List<Object> get props => [pickingType];
}

class CreateDiscussionForumEvent extends CreateDiscussionEvent {
  final bool likePosts;
  final String description;
  final bool moderation;
  final String updatedDate;
  final int forumID;
  final String forumThumbnailName;
  final String categoryIDs;
  final String sendEmail;
  final int parentForumID;
  final String name;
  final bool createNewTopic;
  final bool attachFile;
  final bool requiresSubscription;
  final String moderatorID;
  final String createdDate;
  final bool allowShare;
  final bool isPrivate;
  final bool allowPinTopic;
  final Uint8List? fileBytes;
  final String fileName;

  CreateDiscussionForumEvent(
      {this.likePosts = false,
      this.description = "",
      this.moderation = false,
      this.updatedDate = "",
      this.forumID = 0,
      this.forumThumbnailName = "",
      this.categoryIDs = "",
      this.sendEmail = "",
      this.parentForumID = 0,
      this.name = "",
      this.createNewTopic = false,
      this.attachFile = false,
      this.requiresSubscription = false,
      this.moderatorID = "",
      this.createdDate = "",
      this.allowShare = false,
      this.isPrivate = false,
      this.allowPinTopic = false,
      this.fileBytes,
      this.fileName = ""});

  @override
  List<Object> get props => [
        likePosts,
        description,
        moderation,
        updatedDate,
        forumID,
        forumThumbnailName,
        categoryIDs,
        sendEmail,
        parentForumID,
        name,
        createNewTopic,
        attachFile,
        requiresSubscription,
        moderatorID,
        createdDate,
        allowShare,
        isPrivate,
        allowPinTopic,
        fileName
      ];
}

class GetDiscussionTopicUserListDetails extends CreateDiscussionEvent {
  GetDiscussionTopicUserListDetails();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddTopicEvent extends CreateDiscussionEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
