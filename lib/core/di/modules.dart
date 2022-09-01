import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/remote/itunes_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/remote/interceptors/text_mime_type_converter.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  Dio get dio {
    final baseOptions = BaseOptions();
    void logger(Object data) => log(data.toString());

    return Dio(baseOptions)
      ..options.responseType = ResponseType.plain
      ..interceptors.addAll([
        TextMimeTypeResponseConverter(),
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: logger,
        )
      ]);
  }

  @singleton
  ItunesApiClient get itunesApiClient => ItunesApiClient(dio);
}
