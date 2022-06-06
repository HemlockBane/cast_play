import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:podplay_flutter/core/data/data_source/remote/interceptors/text_mime_type_converter.dart';

@Singleton()
class ApiClient {
  ApiClient();

  static final _baseOptions = BaseOptions();
  final Dio _dio = Dio(_baseOptions)
    ..options.responseType = ResponseType.plain
    ..interceptors.addAll([
      TextMimeTypeResponseConverter(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: logger,
      )
    ]);

  Dio get dio => _dio;

  static void logger(Object data) {
    log(data.toString());
  }
}