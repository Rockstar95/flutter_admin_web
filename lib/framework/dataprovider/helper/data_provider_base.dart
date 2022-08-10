import 'dart:convert';

import 'package:http/http.dart' as http;

import 'app_exceptions.dart';

/// Generic class for interpreting errors and parsing the response
class DataProviderBase {
  // TODO: Add code to log HTTP calls data
  /// Method to mask and log exception
  ///
  /// passes either a map or a list to the [successResponseParser]
  dynamic returnResponse(
      http.Response response, Function(dynamic) successResponseParser) {
    //removed body as it can be text format
    switch (response.statusCode) {
      case 200:
        // Decode and parse the JSON string
        String responseStr = Utf8Decoder().convert(response.bodyBytes);
        var responseData;
        if (_isResposeTypeText(response)) {
          responseData = successResponseParser(responseStr);
        } else {
          responseData = successResponseParser(json.decode(responseStr));
        }

        //print(responseData);
        return responseData;
      case 201:
        // Decode and parse the JSON string
        var responseData =
            successResponseParser(json.decode(response.body.toString()));
        //print(responseData);
        return responseData;
      case 202: // Request Accepted
        Map body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
        print(response);
        if (body != null &&
            body.containsKey('status') &&
            body.containsKey('driver')) {
          return successResponseParser(body);
        } else {
          return response;
        }
      case 204:
        if (response.body != null) {
          return response;
        }
        return null;
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 410:
        throw UnauthorisedException(response.body);
      case 402:
      case 422:
        Map body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
        throw UnprocessableEntityException(body['message']);
      case 403:
        throw UnauthorisedException(response.body);
      case 404:
        // don't throw if this is an Uber response with an unknown place id
        Map body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
        if (body.containsKey('errors') &&
            body['errors'] != null &&
            body['errors'].isNotEmpty) {
          if (body['errors'][0]['code'] == 'unknown_place_id') {
            break;
          }
        } else {
          throw NotFoundException(response.body);
        }
        break;
      case 409:
        throw ConflictException(response.body);
      case 429:
        throw RateLimitException(response.reasonPhrase ?? "");
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
            response.body);
    }
  }

  bool _isResposeTypeText(http.Response response) {
    if (response.headers["content-type"] != null &&
        (response.headers["content-type"] ?? "").contains("text/html")) {
      return true;
    } else {
      return false;
    }
  }
}
