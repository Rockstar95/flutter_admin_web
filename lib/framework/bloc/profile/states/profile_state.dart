import 'package:flutter_admin_web/framework/common/api_state.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/education_titles_response.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';

// TODO: Need to check merge API and the normal state
class ProfileState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  ProfileState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  ProfileState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  ProfileState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class GetProfileInfoState extends ProfileState {
  ProfileResponse? profileResponse;

  GetProfileInfoState.loading(data) : super.loading(data);

  GetProfileInfoState.completed({this.profileResponse})
      : super.completed(profileResponse);

  GetProfileInfoState.error(data) : super.error(data);
}

class CreateExperienceState extends ProfileState {
  bool isSuccess = false;

  CreateExperienceState.loading(data) : super.loading(data);

  CreateExperienceState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  CreateExperienceState.error(data) : super.error(data);
}

class RemoveExperienceState extends ProfileState {
  bool isSuccess = false;

  RemoveExperienceState.loading(data) : super.loading(data);

  RemoveExperienceState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  RemoveExperienceState.error(data) : super.error(data);
}

class UpdateExperienceState extends ProfileState {
  bool isSuccess = false;

  UpdateExperienceState.loading(data) : super.loading(data);

  UpdateExperienceState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  UpdateExperienceState.error(data) : super.error(data);
}

class CreateEducationState extends ProfileState {
  bool isSuccess = false;

  CreateEducationState.loading(data) : super.loading(data);

  CreateEducationState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  CreateEducationState.error(data) : super.error(data);
}

class GetEducationTitleState extends ProfileState {
  List<EducationTitleList> educationTitleList = [];

  GetEducationTitleState.loading(data) : super.loading(data);

  GetEducationTitleState.completed({required this.educationTitleList})
      : super.completed(educationTitleList);

  GetEducationTitleState.error(data) : super.error(data);
}

class RemoveEducationState extends ProfileState {
  bool isSuccess = false;

  RemoveEducationState.loading(data) : super.loading(data);

  RemoveEducationState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  RemoveEducationState.error(data) : super.error(data);
}

class UpdateEducationState extends ProfileState {
  bool isSuccess = false;

  UpdateEducationState.loading(data) : super.loading(data);

  UpdateEducationState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  UpdateEducationState.error(data) : super.error(data);
}

class UploadImageState extends ProfileState {
  bool isSuccess = false;

  UploadImageState.loading(data) : super.loading(data);

  UploadImageState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  UploadImageState.error(data) : super.error(data);
}

class UpdateProfileState extends ProfileState {
  bool isSuccess = false;

  UpdateProfileState.loading(data) : super.loading(data);

  UpdateProfileState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  UpdateProfileState.error(data) : super.error(data);
}

class FetchCountriesState extends ProfileState {
  bool isSuccess = false;

  FetchCountriesState.loading(data) : super.loading(data);

  FetchCountriesState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  FetchCountriesState.error(data) : super.error(data);
}

class InitProfileState extends ProfileState {
  InitProfileState.completed() : super.completed('');
}

class GetProfileHeaderState extends ProfileState {
  bool isSuccess = false;

  GetProfileHeaderState.loading(data) : super.loading(data);

  GetProfileHeaderState.completed({this.isSuccess = false})
      : super.completed(isSuccess);

  GetProfileHeaderState.error(data) : super.error(data);
}
