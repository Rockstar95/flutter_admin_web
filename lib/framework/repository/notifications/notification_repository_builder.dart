import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/notifications/notification_repositry_public.dart';

class NotificationRepositoryBuilder {
  static NotificationRepository repository() {
    return NotificationRepositoryPublic();
  }
}

abstract class NotificationRepository {
  Future<Response?> getNotificationDat({int recordCount});

  Future<Response?> clearNotifiaction({String userNotificationID});

  Future<Response?> markRead();

  Future<Response?> deleteNotifiaction({String userNotificationID});

  Future<Response?> markNotification({String userNotificationID});

  Future<Response?> doPeopleListingAction({
    int selectedObjectID,
    String selectAction,
    String userName,
    String currentMenu,
    String consolidationType,
  });
}
