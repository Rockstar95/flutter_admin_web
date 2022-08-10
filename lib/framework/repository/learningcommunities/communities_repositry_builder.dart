import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';

import 'communities_repositry_public.dart';

class CommunitiesRepositoryBuilder {
  static CommunitiesRepository repository() {
    return CommunitiesRepositoryPublic();
  }
}

abstract class CommunitiesRepository {
  Future<Response?> getLearningCommunitiesResponseRepo(
      {NativeMenuModel nativeMenuModel});

  Future<Response?> doSubSiteLogin(String username, String password,
      String mobileSiteUrl, String downloadContent, String siteId);
}
