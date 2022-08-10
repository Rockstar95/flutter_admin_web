import 'discussion_topic_comment_repository.dart';
import 'discussion_topic_comment_repository_public.dart';

class DiscussionTopicCommentRepositoryBuilder {
  static DiscussionTopicCommentRepository repository() {
    return DiscussionTopicCommentRepositoryPublic();
  }
}
