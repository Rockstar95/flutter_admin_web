import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

// This event is used to initiate app keys to fetch when app starts.
class InitApp extends AppEvent {
  @override
  List<Object> get props => [];
}

class ProfileImageUpdate extends AppEvent {
  final String imageUrl;

  const ProfileImageUpdate({this.imageUrl = ""});

  @override
  List<Object> get props => [imageUrl];
}

// This event is used to check connectivity status.
class ConnectivityStatus extends AppEvent {
  final bool isConnected;

  @override
  List<Object> get props => [isConnected];

  const ConnectivityStatus(this.isConnected);
}

// Event to get the location
class GetLocationEvent extends AppEvent {
  @override
  List<Object> get props => [];
}

// Event to perform the init operations
class PerformInitOperation extends AppEvent {
  @override
  List<Object> get props => [];
}

class SetUiSettingEvent extends AppEvent {
  @override
  List<Object> get props => [];
}

class ChangeLanEvent extends AppEvent {
  final String lanCode;

  const ChangeLanEvent({this.lanCode = ""});

  @override
  List<Object> get props => [lanCode];
}

class NotificationCountEvent extends AppEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class WishlistCountEvent extends AppEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
