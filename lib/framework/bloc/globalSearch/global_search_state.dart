import 'package:flutter_admin_web/framework/common/api_state.dart';

class GlobalSearchState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  GlobalSearchState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  GlobalSearchState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  GlobalSearchState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class InitialMyConnectionState extends GlobalSearchState {
  InitialMyConnectionState.completed(data) : super.completed(data);
}

class GetSearchComponentState extends GlobalSearchState {
  String message = "";

  GetSearchComponentState.loading(data) : super.loading(data);

  GetSearchComponentState.completed({this.message = ""})
      : super.completed(message);

  GetSearchComponentState.error(data) : super.error(data);
}

class GetGlobalSearchResultsState extends GlobalSearchState {
  String message = "";

  GetGlobalSearchResultsState.loading(data) : super.loading(data);

  GetGlobalSearchResultsState.completed({this.message = ""})
      : super.completed(message);

  GetGlobalSearchResultsState.error(data) : super.error(data);
}
