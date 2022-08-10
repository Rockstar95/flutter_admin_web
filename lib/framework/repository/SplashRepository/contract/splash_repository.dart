import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/model/basicAuthResponse.dart';

abstract class SplashRepository {
  /// Fetch news data
  Future<BasicAuthResponce?> getBasicAuth();

  Future<Response?> getMobileGetLearningPortalInfo();

  Future<Response?> getMobileGetNativeMenus();

  Future<Response?> getMobileTinCanConfigurations();

  Future<Response?> getLanguageJsonFile(String lanCode);

  Future<Response?> notificationCount();

  Future<Response?> wishlistcount();
}
