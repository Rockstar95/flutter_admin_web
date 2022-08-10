import 'package:flutter_admin_web/framework/repository/Discussion/createDiscussion/create_discussion_repository.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/createDiscussion/create_discussion_repository_public.dart';

class CreateDiscussionRepositoryBuilder {
  static CreateDiscussionRepositry repository() {
    return CreateDiscussionRepositryPublic();
  }
}
