import 'package:flutter_admin_web/framework/repository/SplashRepository/contract/splash_repository.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/splash_repositry_public.dart';

class SplashRepositoryBuilder {
  static SplashRepository repository() {
    return SplashRepositoryPublic();
  }
}
