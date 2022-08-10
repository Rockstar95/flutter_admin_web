import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotiFicationDataEvent extends NotificationEvent {
  final int recordCount;

  NotiFicationDataEvent({this.recordCount = 0});

  @override
  // TODO: implement props
  List<Object> get props => [recordCount];
}

class ClearNotiFicationEvent extends NotificationEvent {
  final String userNotificationID;

  ClearNotiFicationEvent({this.userNotificationID = ""});

  @override
  // TODO: implement props
  List<Object> get props => [userNotificationID];
}

class RemoveNotiFicationEvent extends NotificationEvent {
  RemoveNotiFicationEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeleteNotiFicationEvent extends NotificationEvent {
  final String userNotificationID;

  DeleteNotiFicationEvent({this.userNotificationID = ""});

  @override
  // TODO: implement props
  List<Object> get props => [userNotificationID];
}

class MarkNotificationEvent extends NotificationEvent {
  final String userNotificationID;

  MarkNotificationEvent({this.userNotificationID = ""});

  @override
  // TODO: implement props
  List<Object> get props => [userNotificationID];
}

class NotificationDetailEvent extends NotificationEvent {
  final String contentID;
  final String metadata;
  final String iCMS;
  final String componentID;
  final String eRitems;
  final String detailsCompID;
  final String detailsCompInsID;
  final String componentDetailsProperties;
  final String hideAdd;
  final String objectTypeID;
  final String scoID;
  final String subscribeERC;
  final String multiInstanceEventEnroll;

  NotificationDetailEvent({
    this.contentID = '',
    this.metadata = '',
    this.iCMS = '',
    this.componentID = '',
    this.eRitems = '',
    this.detailsCompID = '',
    this.detailsCompInsID = '',
    this.componentDetailsProperties = '',
    this.hideAdd = '',
    this.objectTypeID = '',
    this.scoID = '',
    this.subscribeERC = '',
    this.multiInstanceEventEnroll = '',
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        contentID,
        metadata,
        iCMS,
        componentID,
        eRitems,
        detailsCompID,
        detailsCompInsID,
        componentDetailsProperties,
        hideAdd,
        objectTypeID,
        scoID,
        subscribeERC,
        multiInstanceEventEnroll
      ];
}

class DoPeopleListingActionEvent extends NotificationEvent {
  final int selectedObjectID;
  final String selectAction;
  final String userName;
  final String currentMenu;
  final String consolidationType;

  DoPeopleListingActionEvent({
    this.selectedObjectID = 0,
    this.selectAction = "",
    this.userName = "",
    this.currentMenu = "",
    this.consolidationType = "",
  });

  @override
  // TODO: implement props
  List<Object> get props =>
      [selectedObjectID, selectAction, userName, currentMenu];
}
