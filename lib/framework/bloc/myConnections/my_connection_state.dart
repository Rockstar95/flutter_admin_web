part of 'my_connection_bloc.dart';

class MyConnectionState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  MyConnectionState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  MyConnectionState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  MyConnectionState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class InitialMyConnectionState extends MyConnectionState {
  InitialMyConnectionState.completed(data) : super.completed(data);
}

class GetDynamicTabsState extends MyConnectionState {
  String message = "";

  GetDynamicTabsState.loading(data) : super.loading(data);

  GetDynamicTabsState.completed({this.message = ""}) : super.completed(message);

  GetDynamicTabsState.error(data) : super.error(data);
}

class GetPeopleState extends MyConnectionState {
  List<PeopleModel> peopleList = [];

  GetPeopleState.loading(data) : super.loading(data);

  GetPeopleState.completed({required this.peopleList})
      : super.completed(peopleList);

  GetPeopleState.error(data) : super.error(data);
}

class AddConnectionState extends MyConnectionState {
  String message = "";

  AddConnectionState.loading(data) : super.loading(data);

  AddConnectionState.completed({this.message = ""}) : super.completed(message);

  AddConnectionState.error(data) : super.error(data);
}
