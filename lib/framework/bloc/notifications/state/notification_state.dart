import 'package:flutter_admin_web/framework/bloc/notifications/model/accept_request.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/model/notification_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class NotificationState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  NotificationState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  NotificationState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  NotificationState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialDetailsState extends NotificationState {
  IntitialDetailsState.completed(data) : super.completed(data);
}

class NotificationDataState extends NotificationState {
  NotificationResponse? notificationResponse;

  NotificationDataState.loading(data) : super.loading(data);

  NotificationDataState.error(data) : super.loading(data);

  NotificationDataState.completed(notificationResponse)
      : super.completed(notificationResponse);
}

class ClearNotificationState extends NotificationState {
  String res = "";

  ClearNotificationState.loading(data) : super.loading(data);

  ClearNotificationState.error(data) : super.loading(data);

  ClearNotificationState.completed(res) : super.completed(res);
}

class RemoveNotificationState extends NotificationState {
  String res = "";

  RemoveNotificationState.loading(data) : super.loading(data);

  RemoveNotificationState.error(data) : super.loading(data);

  RemoveNotificationState.completed(res) : super.completed(res);
}

class DeleteNotificationState extends NotificationState {
  String res = "";

  DeleteNotificationState.loading(data) : super.loading(data);

  DeleteNotificationState.error(data) : super.loading(data);

  DeleteNotificationState.completed(res) : super.completed(res);
}

class MarkNotificationState extends NotificationState {
  String res = "";

  MarkNotificationState.loading(data) : super.loading(data);

  MarkNotificationState.error(data) : super.loading(data);

  MarkNotificationState.completed(res) : super.completed(res);
}

class DoPeopleListingActionState extends NotificationState {
  AcceptRequest? res;

  DoPeopleListingActionState.loading(data) : super.loading(data);

  DoPeopleListingActionState.error(res) : super.loading(res);

  DoPeopleListingActionState.completed(res) : super.completed(res);
}
