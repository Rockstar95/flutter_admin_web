import 'discussion_topic_repository.dart';
import 'discussion_topic_repository_public.dart';

class DiscussionTopicRepositoryBuilder {
  static DiscussionTopicRepository repository() {
    return DiscussionTopicRepositryPublic();
  }
}
