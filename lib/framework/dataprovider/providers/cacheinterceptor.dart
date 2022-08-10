import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  var _cache = new Map<Uri, Response>();

  @override
  @override
  onRequest(RequestOptions options,
      RequestInterceptorHandler requestInterceptorHandler) async {
    //return options;
  }

  @override
  onResponse(Response response,
      ResponseInterceptorHandler responseInterceptorHandler) async {
    _cache[response.realUri] = response;
  }

  @override
  onError(DioError e, ErrorInterceptorHandler errorInterceptorHandler) async {
    print('onError: $e');
    if (e.type == DioErrorType.connectTimeout ||
        e.type == DioErrorType.receiveTimeout ||
        e.type == DioErrorType.sendTimeout) {
      var cachedResponse = _cache[e.requestOptions.uri];
      if (cachedResponse != null) {
        //return cachedResponse;
      }
    }
    //return e;
  }
}
