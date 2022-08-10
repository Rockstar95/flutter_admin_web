import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';

class DashGridResponse {
  String title = '';

  List<DummyMyCatelogResponseTable2> dashcommonlist = [];

  String get titlenew => title;

  set settitle(String value) {
    title = value;
  }

  String get listnew => title;

  set setlist(List<DummyMyCatelogResponseTable2> value) {
    dashcommonlist = value;
  }
}
