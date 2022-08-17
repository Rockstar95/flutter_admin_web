import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/wikiuploadrepo/wikiupload_repositry_public.dart';

class WikiUploadRepositoryBuilder {
  static WikiUploadRepository repository() {
    return WikiUploadRepositoryPublic();
  }
}

abstract class WikiUploadRepository {
  Future<Response?> uploadWikiFileData(
      {bool isUrl,
      dynamic fileBytes,
      int mediaTypeID,
      int objectTypeID,
      String title,
      String shortDesc,
      int userID,
      int siteID,
      String localeID,
      int componentID,
      int cMSGroupId,
      String keywords,
      int orgUnitID,
      String eventCategoryID,
      String categoryIds});

  Future<Response?> getWikiCategories(
      {int intUserID,
      int intSiteID,
      int intComponentID,
      String locale,
      String strType});
}
