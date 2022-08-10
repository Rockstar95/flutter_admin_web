import 'package:flutter_admin_web/framework/repository/Catalog/catalog_repositry_public.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/contract/catalog_repositry.dart';

class CatalogRepositoryBuilder {
  static CatalogRepository repository() {
    return CatalogRepositoryPublic();
  }
}
