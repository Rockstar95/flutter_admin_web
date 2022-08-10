class AppErrorModel {
  String message;
  Exception? exception;
  StackTrace? stackTrace;
  int code;

  AppErrorModel({
    this.message = "",
    this.exception,
    this.stackTrace,
    this.code = -1,
  });
}