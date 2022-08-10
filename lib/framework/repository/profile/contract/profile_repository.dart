import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/create_education_request.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/create_experience_request.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/remove_experience_request.dart';

abstract class ProfileRepository {
//  /// Get the Weather Data
  Future<ApiResponse?> getUserInfo();

  Future<ApiResponse?> getConnectionsProfile(String userId);

  Future<ApiResponse?> createExperience(
      CreateExperienceRequest createExperienceRequest);

  Future<ApiResponse?> removeExperience(
      RemoveExperienceRequest removeExperienceRequest);

  Future<ApiResponse?> updateExperience(
      CreateExperienceRequest updateExperienceRequest);

  Future<ApiResponse?> createEducation(
      CreateEducationRequest createExperienceRequest);

  Future<ApiResponse?> removeEducation(
      RemoveExperienceRequest removeEducationRequest);

  Future<ApiResponse?> updateEducation(
      CreateEducationRequest updateEducationRequest);

  Future<ApiResponse?> getEducationTitleList();

  Future<ApiResponse?> uploadImage(String image, String fileName);

  Future<ApiResponse?> updateProfile(String data);

  Future<ApiResponse?> fetchCountries();

  Future<ApiResponse?> getProfileHeader(String profileUserId);
}
