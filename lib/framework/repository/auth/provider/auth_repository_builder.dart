import 'package:flutter_admin_web/framework/repository/auth/provider/auth_repositoy_public.dart';

class AuthRepositoryBuilder {
  static AuthRepository repository() {
    return AuthenticationRepository();
  }

  static SignUpRepository signUpRepository() {
    return DynamicSignUpRepository();
  }
}
