import 'package:flutter_admin_web/framework/common/enums.dart';

/// Generic class for the API states
abstract class ApiState<T> {
  final Status status;

  final T data;

  final String message;

  const ApiState.loading(this.data, {this.message = ''})
      : status = Status.LOADING;

  const ApiState.completed(this.data, {this.message = ""})
      : status = Status.COMPLETED;

  const ApiState.contact(this.data, {this.message = ""})
      : status = Status.CONTACT;

  const ApiState.error(this.data, {this.message = ""}) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
