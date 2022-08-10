import 'package:flutter_admin_web/framework/repository/auth/provider/auth_repositoy_public.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repositoy_public.dart';

class ProfileRepositoryBuilder {
  static ProfileRepository repository() {
    return ProfileInfoRepository();
  }

  static SignUpRepository signUpRepository() {
    return DynamicSignUpRepository();
  }
}
