import 'package:flutter_admin_web/framework/bloc/catalog/model/getCategoryForBrowseResponse.dart';

class DisplayCatalogData {
  int parentId = 0;
  String categoryName = "";
  int categoryId = 0;
  String categoryIcon = "";
  bool hasChild = false;
  bool isChecked = false;

  List<GetCategoryForBrowseResponse> subcategoryList = [];
}
