import 'package:http/http.dart';

abstract class CreateDiscussionRepositry {
  Future<Response?> createDiscussionData(
      bool likePosts,
      String description,
      bool moderation,
      String updatedDate,
      int forumID,
      String forumThumbnailName,
      String categoryIDs,
      String sendEmail,
      int parentForumID,
      String name,
      bool createNewTopic,
      bool attachFile,
      bool requiresSubscription,
      String moderatorID,
      String createdDate,
      bool allowShare,
      bool isPrivate,
      bool allowPinTopic,
      String filePth,
      String fileName);

  Future<Response?> getDiscussionTopicUserData(
    int userID,
    int siteID,
    String localeID,
  );
}
