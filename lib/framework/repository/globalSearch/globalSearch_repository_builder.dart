import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/model/search_component_response.dart';

import 'globalSearch_repository_public.dart';

class GlobalSearchRepositoryBuilder {
  static GlobalSearchRepository repository() {
    return GlobalSearchRepositoryPublic();
  }
}

abstract class GlobalSearchRepository {
  Future<Response?> getSearchComponentListEvent();

  Future<Response?> getGlobalSearchResultsEvent(
      {int pageIndex,
      int pageSize,
      String searchStr,
      int source,
      int type,
      String fType,
      String fValue,
      String sortBy,
      String sortType,
      String keywords,
      String authorID,
      String groupBy,
      int userID,
      int siteID,
      int orgUnitId,
      String locale,
      int componentId,
      int componentInsId,
      String multiLocation,
      int objComponentList,
      int componentSiteID,
      SearchComponent searchComponent});
}
