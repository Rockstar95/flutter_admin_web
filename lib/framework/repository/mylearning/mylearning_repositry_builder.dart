import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_public.dart';

import 'contract/mylearning_repositry.dart';

class MyLearningRepositoryBuilder {
  static MyLearningRepository repository() {
    return MyLearningRepositoryPublic();
  }
}
