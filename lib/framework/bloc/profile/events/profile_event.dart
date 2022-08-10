import 'package:flutter_admin_web/framework/repository/profile/model/create_education_request.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/create_experience_request.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/remove_experience_request.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class GetProfileInfo extends ProfileEvent {
  GetProfileInfo();

  @override
  List<Object> get props => [];
}

class GetConnectionsProfile extends ProfileEvent {
  String userId = "";

  GetConnectionsProfile({this.userId = ""});

  @override
  List<Object> get props => [this.userId];
}

class CreateExperience extends ProfileEvent {
  CreateExperienceRequest createExperienceRequest;

  CreateExperience({required this.createExperienceRequest});

  @override
  List<Object> get props => [createExperienceRequest];
}

class RemoveExperience extends ProfileEvent {
  RemoveExperienceRequest removeExperienceRequest;

  RemoveExperience({required this.removeExperienceRequest});

  @override
  List<Object> get props => [removeExperienceRequest];
}

class UpdateExperience extends ProfileEvent {
  CreateExperienceRequest updateExperienceRequest;

  UpdateExperience({required this.updateExperienceRequest});

  @override
  List<Object> get props => [updateExperienceRequest];
}

class CreateEducation extends ProfileEvent {
  CreateEducationRequest createEducationRequest;

  CreateEducation({required this.createEducationRequest});

  @override
  List<Object> get props => [createEducationRequest];
}

class GetEducationTitle extends ProfileEvent {
  GetEducationTitle();

  @override
  List<Object> get props => [];
}

class RemoveEducation extends ProfileEvent {
  RemoveExperienceRequest removeEducationRequest;

  RemoveEducation({required this.removeEducationRequest});

  @override
  List<Object> get props => [removeEducationRequest];
}

class UpdateEducation extends ProfileEvent {
  CreateEducationRequest updateEducationRequest;

  UpdateEducation({required this.updateEducationRequest});

  @override
  List<Object> get props => [updateEducationRequest];
}

class UploadImage extends ProfileEvent {
  String imageBytes = "";
  String fileName = "";

  UploadImage({this.imageBytes = "", this.fileName = ""});

  @override
  List<Object> get props => [imageBytes];
}

class UpdateProfile extends ProfileEvent {
  String data = "";

  UpdateProfile({this.data = ""});

  @override
  List<Object> get props => [data];
}

class InitProfile extends ProfileEvent {
  InitProfile();

  @override
  List<Object> get props => [];
}

class FetchCountries extends ProfileEvent {
  FetchCountries();

  @override
  List<Object> get props => [];
}

class ClearTempData extends ProfileEvent {
  ClearTempData();

  @override
  List<Object> get props => [];
}

class AssignProfileVal extends ProfileEvent {
  AssignProfileVal();

  @override
  List<Object> get props => [];
}

class GetProfileHeaderEvent extends ProfileEvent {
  String profileUserId = "";

  GetProfileHeaderEvent({this.profileUserId = ""});

  @override
  List<Object> get props => [this.profileUserId];
}
