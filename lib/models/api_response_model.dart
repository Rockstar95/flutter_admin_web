import 'package:flutter/foundation.dart';
import 'app_error_model.dart';

@immutable
class ApiResponseModel<T> {
  final T? data;
  final AppErrorModel? appErrorModel;

  const ApiResponseModel({
    this.data,
    this.appErrorModel,
  });
}