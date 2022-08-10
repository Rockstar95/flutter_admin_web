import 'package:http/http.dart';

abstract class DiscussionTopicCommentRepository {
  Future<Response?> getDiscussionTopicCommentData({
    String topicID,
    String topicName,
    int forumId,
    String forumTitle,
    String message,
    String strAttachFil,
    String strReplyID,
  });

  Future<Response?> getDiscussionTopicCommentListData(int intSiteID,
      String strLocale, int forumID, int siteID, int userID, String topicId);

  @override
  Future<Response?> getDiscussionTopicReplyData(
      {int strCommentID,
      String topicID,
      String topicName,
      int forumID,
      String message,
      String localeID,
      int userID,
      int siteID,
      String strReplyID,
      String forumTitle,
      String strCommentTxt});
}
