import 'package:injectable/injectable.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/itunes_api_client.dart';

import 'features/search/data/model/response/podcast_response.dart';

@Singleton()
class ItunesRepository {
  ItunesRepository({
    required ItunesApiClient itunesApiClient,
  }) : _itunesApiClient = itunesApiClient;

  final ItunesApiClient _itunesApiClient;

  Future<PodcastResponse?> getPodcastByTerm(String term) async {
    PodcastResponse? response;
    try {
      response = await _itunesApiClient.getPodcastByTerm(term);
    } on Exception catch (e, s) {
      print(e);
      print(s.toString());
    }
    return response;
  }
}
