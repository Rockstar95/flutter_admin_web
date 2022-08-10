import 'package:http/http.dart';

abstract class EventModuleRepository {
  Future<Response?> getPeopleTabList();

  Future<Response?> getTabContent(String req);

  Future<Response?> getSessionList(String contentId);

  Future<Response?> badCancelEnroll(String contentId);

  Future<Response?> cancelEnroll(String strContentID, String isBadCancel);

  Future<Response?> expiryEvents(String strContentID);

  Future<Response?> waitingList(String strContentID);

  Future<Response?> viewRecording(String contentId);

  Future<Response?> downloadCompleteInfo(String contentId, int scoID);
}
