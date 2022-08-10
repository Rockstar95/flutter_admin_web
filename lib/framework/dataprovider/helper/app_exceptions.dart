/// Class for masking the exceptions
class AppException implements Exception {
  final _message;
  final _prefix;
  final StackTrace _stackTrace = StackTrace.current;

  AppException([this._message, this._prefix]);

  String get message => _message;

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  final String responseBody;

  FetchDataException([String message = "", this.responseBody = ""])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message = ""])
      : super(message, "Invalid Input: ");
}

class UnprocessableEntityException extends AppException {
  UnprocessableEntityException(String message)
      : super(message, 'Unprocessable Entity: ');
}

class RateLimitException extends AppException {
  RateLimitException(String message) : super(message, 'Rate limit reached: ');
}

class ConflictException extends AppException {
  ConflictException(String message) : super(message, 'Conflict: ');
}

class TripAlreadyInProgressException extends ConflictException {
  TripAlreadyInProgressException(String message) : super(message);
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, 'Item not found: ');
}
