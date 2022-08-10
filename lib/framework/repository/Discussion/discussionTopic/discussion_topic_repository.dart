import 'package:http/http.dart';

abstract class DiscussionTopicRepository {
  Future<Response?> getDiscussionTopicData(
    int userID,
    int forumID,
    int siteID,
    String localeID,
  );

  Future<Response?> addTopicData({
    String strAttachFile,
    int userID,
    int orgID,
    int forumID,
    String strContentID,
    String description,
    String localeID,
    int siteID,
    String title,
    String forumName,
  });

  Future<Response?> editTopicData({
    String strAttachFile,
    int userID,
    int orgID,
    int forumID,
    String strContentID,
    String description,
    String localeID,
    int siteID,
    String title,
    String forumName,
  });

  Future<Response?> getDiscussionTopicReplyData(
      {String topicId,
      String topicName,
      int forumId,
      String forumTitle,
      String message,
      String strAttachFil,
      String strReplyID,
      String filePath,
      String fileName});

  Future<Response?> getDiscussionTopicCommentListData(
      {int intSiteID,
      String strLocale,
      int forumID,
      int siteID,
      int userID,
      String topicId});

  Future<Response?> deleteDiscussionTopicUserData({
    String topicID,
    int forumID,
    String forumName,
    int userID,
    int siteID,
    String localeID,
  });

  Future<Response?> getTopicReplyData(
      {int strCommentID, int userID, int siteID, String localeID});

  Future<Response?> deleteReplyData({int replyID});

  Future<Response?> pinTopicData(
      {int forumID, String strContentID, bool isPin, int userID});

  Future<Response?> likeDisLikeData(
      {int intUserID,
      String strObjectID,
      int intTypeID,
      bool blnIsLiked,
      int intSiteID,
      String strLocale});

  Future<Response?> likeCount({
    String strObjectID,
    int intUserID,
    int intSiteID,
    String strLocale,
    int intTypeID,
  });

  Future<Response?> uploadAttachment(
      {String topicID,
      String replyID,
      bool isTopic,
      String filePath,
      String fileName});
}
