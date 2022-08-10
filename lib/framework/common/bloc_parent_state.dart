import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';

@immutable
abstract class BlocParentState<T> extends Equatable {
  final Status status;
  final T? data;
  final String message;

  const BlocParentState({required this.status, this.data, this.message = '',});

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
