import 'package:flutter_admin_web/framework/bloc/competencies/model/job_role_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/job_role_skills_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/pref_category_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/user_skill_evaluation_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/user_skill_list_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class MyCompetenciesState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  MyCompetenciesState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  MyCompetenciesState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  MyCompetenciesState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialMyCompetenciesState extends MyCompetenciesState {
  IntitialMyCompetenciesState.completed(data) : super.completed(data);
}

class JobRoleSkillsState extends MyCompetenciesState {
  JobRoleSkillsResponse? jobRoleSkillsResponse;

  JobRoleSkillsState.loading(data) : super.loading(data);

  JobRoleSkillsState.completed({this.jobRoleSkillsResponse})
      : super.completed(jobRoleSkillsResponse);

  JobRoleSkillsState.error(data) : super.error(data);
}

class PrefCatListState extends MyCompetenciesState {
  PrefCategoryListResponse? prefCategoryListResponse;

  PrefCatListState.loading(data) : super.loading(data);

  PrefCatListState.completed({this.prefCategoryListResponse})
      : super.completed(prefCategoryListResponse);

  PrefCatListState.error(data) : super.error(data);
}

class UserSkillState extends MyCompetenciesState {
  UserSkillListResponse? userSkillListResponse;

  UserSkillState.loading(data) : super.loading(data);

  UserSkillState.completed({this.userSkillListResponse})
      : super.completed(userSkillListResponse);

  UserSkillState.error(data) : super.error(data);
}

class UserSkillEvaluationState extends MyCompetenciesState {
  UserSkillEvaluationResponse? userSkillEvaluationResponse;

  UserSkillEvaluationState.loading(data) : super.loading(data);

  UserSkillEvaluationState.completed({this.userSkillEvaluationResponse})
      : super.completed(userSkillEvaluationResponse);

  UserSkillEvaluationState.error(data) : super.error(data);
}

class JobRoleState extends MyCompetenciesState {
  JobRoleResponse? jobRoleResponse;

  JobRoleState.loading(data) : super.loading(data);

  JobRoleState.completed({this.jobRoleResponse})
      : super.completed(jobRoleResponse);

  JobRoleState.error(data) : super.error(data);
}

class AddJobRoleState extends MyCompetenciesState {
  String data = "";

  AddJobRoleState.loading(data) : super.loading(data);

  AddJobRoleState.completed({this.data = ""}) : super.completed(data);

  AddJobRoleState.error(data) : super.error(data);
}
