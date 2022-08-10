import 'package:http/http.dart';

abstract class DiscussionMainHomeRepository {
  Future<Response?> getDiscussionMainHomeData(
      {int intUserID,
      int intSiteID,
      String strLocale,
      String intCompID,
      String intCompInsID,
      int pageIndex,
      int pageSize,
      String strSearchText,
      String categoryIds,
      String forumContentID});

  Future<Response?> getDiscussionForumLikeData(
    int forumID,
    int userID,
    int siteID,
    String localeID,
  );

  Future<Response?> deleteDiscussionForumData(
    int forumID,
    int userID,
    int siteID,
    String localeID,
  );

  Future<Response?> commentDiscussionForumData(
    int forumID,
    String topicID,
    int userID,
    int siteID,
    String localeID,
  );

  Future<Response?> deleteCommentData({
    String topicID,
    int forumID,
    String replyID,
    String topicName,
    int siteID,
    int userID,
    String localeID,
    int noOfReplies,
    String lastPostedDate,
    int createdUserID,
    String attachmentPath,
  });
}
