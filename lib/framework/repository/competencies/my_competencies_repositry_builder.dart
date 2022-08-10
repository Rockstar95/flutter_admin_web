import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/competencies/my_competencies_repositry_public.dart';

class MyCompetenciesRepositoryBuilder {
  static MyCompetenciesRepository repository() {
    return MyCompetenciesRepositoryPublic();
  }
}

abstract class MyCompetenciesRepository {
  Future<Response?> jobRolSkills(
      {int componentID, int componentInstanceID, int jobRoleID});

  Future<Response?> prefCatList(
      {int componentID, int componentInstanceID, int jobRoleID});

  Future<Response?> userSkills(
      {int componentID, int componentInstanceID, int prefCatId, int jobRoleID});

  Future<Response?> updateUserEvaluation({
    int componentID,
    int componentInsID,
    int jobRoleID,
    int prefCategoryID,
    String skillSetValue,
  });

  Future<Response?> getJobRoleData({
    int componentID,
    int componentInstanceID,
    bool isParent,
  });

  Future<Response?> addJobRole({int jobRoleIDs, String tagName});
}
