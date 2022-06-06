import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:collection/collection.dart';

/// Helps to deserialize json string to map.
///
/// For context, Dio doesn't seem to able to manually deserialize text mime types.
/// This is a known issue but the Dio developers haven't paid any attention to it
class TextMimeTypeResponseConverter extends Interceptor{

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final headers = response.headers.map;
    final contentType = headers[Headers.contentTypeHeader]?.firstOrNull;
    if (contentType?.contains("text/javascript") == true){
      final data = response.data;
      final jsonDecodedData = jsonDecode(data);
      response.data = jsonDecodedData;
    }
    super.onResponse(response, handler);
  }
}