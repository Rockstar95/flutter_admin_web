import 'package:flutter_admin_web/framework/repository/Discussion/discussion_main_home_repository.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussion_main_home_repository_public.dart';

class DiscussionMainHomeRepositoryBuilder {
  static DiscussionMainHomeRepository repository() {
    return DiscussionMainHomeRepositoryPublic();
  }
}
