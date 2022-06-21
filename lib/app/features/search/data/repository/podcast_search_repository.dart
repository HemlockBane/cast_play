import 'package:injectable/injectable.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/itunes_api_client.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/podcast_search_history_dao.dart';

import '../model/response/podcast_response.dart';

@Singleton()
class PodcastSearchRepository {
  PodcastSearchRepository({
    required ItunesApiClient itunesApiClient,
    @Named.from(SharedPreferencesSearchHistoryDao)
        required PodcastSearchHistoryDao podcastSearchHistoryDao,
  })  : _itunesApiClient = itunesApiClient,
        _podcastSearchHistoryDao = podcastSearchHistoryDao;

  final ItunesApiClient _itunesApiClient;
  final PodcastSearchHistoryDao _podcastSearchHistoryDao;

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

  void addToSearchHistory() {}

  void clearSearchHistory() {}

  Stream<List<String>> getSearchHistory() {
    return const Stream<List<String>>.empty();
  }

  void removeFromSearchHistory() {}
}
