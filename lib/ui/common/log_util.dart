import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LogUtil {
  /// Holds instances of logger to send log messages to the [LogPrinter].
  Logger _logger = Logger();

  JsonEncoder _prettyJsonEncoder = JsonEncoder.withIndent('  ');

  factory LogUtil() {
    return LogUtil._internal();
  }

  LogUtil._internal();

  printLog({String tag = '!@#', String message = ''}) {
    if (!kReleaseMode) {
      print('$tag: $message');
    }
  }

  /// If you are using printLog() and output is too much at once,
  /// then Android sometimes discards some log lines.
  /// To avoid this, use debugPrintLog().
  debugPrintLog({String tag = '!@#', String message = ''}) {
    if (!kReleaseMode) {
      debugPrint('$tag: $message');
    }
  }

  printLogger({String tag = '!@#', String message = '', bool isJson = false}) {
    if (!kReleaseMode) {
      isJson
          ? printPrettyJsonString(tag: tag, jsonString: message)
          : _logger.d('$tag: $message');
    }
  }

  /// converts raw json string to human readable with proper indentation
  /// and new line
  ///
  /// {"data":"","error":""} to
  ///
  /// {
  ///  "data": "",
  ///  "error": ""
  /// }
  ///
  String prettyString(String jsonString) {
    if (jsonString == null) return "";
    try {
      return _prettyJsonEncoder.convert(json.decode(jsonString));
    } catch (e) {
      return "Unable to parse\n $e";
    }
  }

  /// print json string in human readable
  /// [info] optional prefix of output json
  void printPrettyJsonString({String jsonString = "", tag = '!@#'}) {
    _logger.d('${tag ?? ""}\n${prettyString(jsonString)}');
  }

  printBigLog({String tag = '!@#', String message = ''}) {
    if (!kReleaseMode) {
      final pattern = RegExp('.{1,800}'); //Setting 800 as size of each chunk
      pattern.allMatches(message).forEach((element) {
        print(element.group(0));
      });
    }
  }
}
