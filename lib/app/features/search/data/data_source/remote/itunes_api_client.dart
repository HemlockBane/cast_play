import 'package:dio/dio.dart' hide Headers;

import 'package:podplay_flutter/app/features/search/data/model/response/podcast_response.dart';
import 'package:podplay_flutter/core/data/data_source/remote/api_config.dart';
import 'package:retrofit/http.dart';

part 'itunes_api_client.g.dart';

@RestApi(baseUrl: ApiConfig.iTunesUrl)
abstract class ItunesApiClient {

  factory ItunesApiClient(Dio dio, {String baseUrl}) = _ItunesApiClient;

  @Headers(<String, dynamic>{"content-type": "text/javascript; charset=utf-8"})
  @GET("/search?media=podcast")
  Future<PodcastResponse> getPodcastByTerm(@Query("term") String term);
}