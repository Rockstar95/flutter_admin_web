import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';

abstract class EventTrackListRepository {
  Future<ApiResponse?> mobileGetMobileContentMetaData(String url);

  Future<Response?> setCompleteStatus(String contentId, String scoId);

  Future<Response?> cancelEnrollment(bool isBadCancel, String strContentID);

  Future<Response?> updateMyLearningArchive(bool isArchive, String contentID);

  Future<Response?> getEventTrackTabs(String url);

  Future<Response?> getTrackResources(String contentId);

  Future<Response?> getTrackGlossary(String contentId);

  Future<Response?> getOverview(
      String contentId, int objectTypeId, String userId);

  Future<Response?> badCancelEnroll(String contentId);

  Future<Response?> cancelEnroll(String strContentID, String isBadCancel);

  Future<Response?> downloadCompleteInfo(String contentId, int scoID);
}
