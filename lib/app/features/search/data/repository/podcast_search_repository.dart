import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/remote/itunes_api_client.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/local/podcast_search_history_dao.dart';
import 'package:podplay_flutter/core/data/model/resource.dart';

import '../data_source/local/shared_pref_search_history_dao.dart';
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

  Stream<List<String>> get searchHistory {
    return _podcastSearchHistoryDao.getSearchHistory();
  }

  Future<Resource<PodcastResponse>> getPodcastByTerm(String term) async {
    Resource<PodcastResponse> resource;
    try {
      final response = await _itunesApiClient.getPodcastByTerm(term);
      resource = Resource.success(response);
    } on Exception catch (e, s) {
      resource = Resource.failure(errorMessage: "error");
      log(s.toString());
    }
    return resource;
  }

  void addToSearchHistory({required String searchTerm}) {
    _podcastSearchHistoryDao.addToSearchHistory(searchTerm: searchTerm);
  }

  void removeFromSearchHistory({required String searchTerm}) {
    _podcastSearchHistoryDao.removeFromSearchHistory(searchTerm: searchTerm);
  }

  void clearSearchHistory() {
    _podcastSearchHistoryDao.clearSearchHistory();
  }

  void close() {
    _podcastSearchHistoryDao.close();
  }
}
