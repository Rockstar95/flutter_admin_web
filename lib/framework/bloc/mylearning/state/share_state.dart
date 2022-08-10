import 'package:flutter_admin_web/framework/bloc/mylearning/model/connection_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class ShareState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  ShareState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  ShareState.loading(data, {this.displayMessage = true}) : super.loading(data);

  ShareState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class IntitialShareStateState extends ShareState {
  IntitialShareStateState.completed(data) : super.completed(data);
}

class GetConnectiontListState extends ShareState {
  List<ConnectionElement> list = [];

  GetConnectiontListState.loading(data) : super.loading(data);

  GetConnectiontListState.completed({required this.list})
      : super.completed(list);

  GetConnectiontListState.error(data) : super.error(data);
}

class SelectConnectiontState extends ShareState {
  List<String> list = [];

  SelectConnectiontState.loading(data) : super.loading(data);

  SelectConnectiontState.completed({required this.list})
      : super.completed(list);

  SelectConnectiontState.error(data) : super.error(data);
}

class SendMailToPeopleState extends ShareState {
  bool isSucces = false;

  SendMailToPeopleState.loading(data) : super.loading(data);

  SendMailToPeopleState.completed({this.isSucces = false})
      : super.completed(isSucces);

  SendMailToPeopleState.error(data) : super.error(data);
}

class SendviaMailToMyLearn extends ShareState {
  bool isSucces = false;

  SendviaMailToMyLearn.loading(data) : super.loading(data);

  SendviaMailToMyLearn.completed({this.isSucces = false})
      : super.completed(isSucces);

  SendviaMailToMyLearn.error(data) : super.error(data);
}
