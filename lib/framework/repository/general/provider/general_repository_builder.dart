import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_api_repository.dart';

class GeneralRepositoryBuilder {
  static GeneralRepository repository() {
    return GeneralApiRepository();
  }
}
