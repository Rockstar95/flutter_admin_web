import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/catalog_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/event/notification_event.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/model/accept_request.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/model/notification_response.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/state/notification_state.dart';
import 'package:flutter_admin_web/framework/repository/notifications/notification_repository_builder.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepository notificationRepository;
  NotificationResponse notificationResponse = new NotificationResponse();
  CatalogDetailsResponse notificationDetailRes =
      CatalogDetailsResponse(recordingDetails: RecordingDetails());
  bool isFirstLoading = true;
  AcceptRequest acceptRequest = AcceptRequest();

  NotificationBloc({
    required this.notificationRepository,
  }) : super(NotificationState.completed(null)) {
    on<NotiFicationDataEvent>(onEventHandler);
    on<ClearNotiFicationEvent>(onEventHandler);
    on<RemoveNotiFicationEvent>(onEventHandler);
    on<DeleteNotiFicationEvent>(onEventHandler);
    on<MarkNotificationEvent>(onEventHandler);
    on<NotificationDetailEvent>(onEventHandler);
    on<DoPeopleListingActionEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(NotificationEvent event, Emitter emit) async {
    print("NotificationBloc onEventHandler called for ${event.runtimeType}");
    Stream<NotificationState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (NotificationState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  NotificationState get initialState =>
      IntitialDetailsState.completed("Intitalized");

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    try {
      if (event is NotiFicationDataEvent) {
        // isFirstLoading = true;
        yield NotificationDataState.loading('Please wait');
        Response? apiResponse = await notificationRepository.getNotificationDat(recordCount: event.recordCount);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          notificationResponse = notificationResponseFromJson(apiResponse?.body ?? "{}");
          yield NotificationDataState.completed(apiResponse);
        } else if (apiResponse?.statusCode == 401) {
          isFirstLoading = false;
          yield NotificationDataState.error('401');
        } else {
          isFirstLoading = false;
          yield NotificationDataState.error('Something went wrong');
        }
        print('ApiResponse ${apiResponse?.body}');
      } else if (event is ClearNotiFicationEvent) {
        isFirstLoading = true;
        yield ClearNotificationState.loading('Please wait');
        Response? apiResponse = await notificationRepository.clearNotifiaction(
            userNotificationID: event.userNotificationID);
        if (apiResponse?.statusCode == 200) {
          yield ClearNotificationState.completed(apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield ClearNotificationState.error('401');
        } else {
          yield ClearNotificationState.error('Something went wrong');
        }
        print('ApiResponse ${apiResponse?.body}');
      } else if (event is RemoveNotiFicationEvent) {
        //isFirstLoading = true;
        yield RemoveNotificationState.loading('Please wait');
        Response? apiResponse = await notificationRepository.markRead();
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          yield RemoveNotificationState.completed(apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          isFirstLoading = false;
          yield RemoveNotificationState.error('401');
        } else {
          isFirstLoading = false;
          yield RemoveNotificationState.error('Something went wrong');
        }
        print('ApiResponse ${apiResponse?.body ?? "{}"}');
      } else if (event is DeleteNotiFicationEvent) {
        //isFirstLoading = true;
        yield DeleteNotificationState.loading('Please wait');
        Response? apiResponse = await notificationRepository.deleteNotifiaction(
            userNotificationID: event.userNotificationID);
        if (apiResponse?.statusCode == 200) {
          yield DeleteNotificationState.completed(apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield DeleteNotificationState.error('401');
        } else {
          yield DeleteNotificationState.error('Something went wrong');
        }
        print('ApiResponse ${apiResponse?.body ?? "{}"}');
      } else if (event is MarkNotificationEvent) {
        isFirstLoading = true;
        yield MarkNotificationState.loading('Please wait');
        Response? apiResponse = await notificationRepository.markNotification(userNotificationID: event.userNotificationID);
        if (apiResponse?.statusCode == 200) {
          yield MarkNotificationState.completed(apiResponse?.body ?? "{}");
        }
        else if (apiResponse?.statusCode == 401) {
          yield MarkNotificationState.error('401');
        }
        else {
          yield MarkNotificationState.error('Something went wrong');
        }
        print('ApiResponse ${apiResponse?.body}');
      } else if (event is DoPeopleListingActionEvent) {
        isFirstLoading = true;
        yield DoPeopleListingActionState.loading('Please wait');
        Response? apiResponse =
            await notificationRepository.doPeopleListingAction(
                selectedObjectID: event.selectedObjectID,
                selectAction: event.selectAction,
                userName: event.userName,
                currentMenu: event.currentMenu,
                consolidationType: event.consolidationType);
        if (apiResponse?.statusCode == 200) {
          acceptRequest = new AcceptRequest();
          acceptRequest = acceptRequestFromJson(apiResponse?.body ?? "{}");
          yield DoPeopleListingActionState.completed(apiResponse);
        } else if (apiResponse?.statusCode == 401) {
          yield DoPeopleListingActionState.error('401');
        } else {
          yield DoPeopleListingActionState.error('Something went wrong');
        }
        print('ApiResponse $apiResponse');
      }
    } catch (e) {
      print("Error in NotificationBloc.mapEventToState():$e");
    }
  }
}
