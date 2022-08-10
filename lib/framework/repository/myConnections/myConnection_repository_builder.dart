import 'package:http/http.dart';

import 'myConnection_repository_public.dart';

class MyConnectionRepositoryBuilder {
  static MyConnectionRepository repository() {
    return MyConnectionRepositoryPublic();
  }
}

abstract class MyConnectionRepository {
  Future<Response?> getDynamicTabEvent();

  Future<Response?> getPeopleListResponseEvent(
      {int componentID,
      int componentInstanceID,
      int userID,
      int siteID,
      String locale,
      String sortBy,
      String sortType,
      int pageIndex,
      int pageSize,
      String filterType,
      String tabID,
      String searchText,
      String contentId,
      String location,
      String company,
      String skillLevels,
      String firstname,
      String lastname,
      String skillCats,
      String skills,
      String jobRoles});

  Future<Response?> addConnectionResponseEvent(
      {int selectedObjectID,
      String selectAction,
      String userName,
      int mainSiteUserID});
}
