// State 1: search suggestions state - search history: List<String>
// State 2: search result loading state
// State 3: search result failure state
// State 4: search result success state - podcasts: List<Podcasts>

// View

// Suggestions View:
// - only listens to search suggestion state

// Results View:
// - only listens to result states

import 'package:podplay_flutter/app/features/search/data/model/response/podcast_response.dart';

abstract class SearchUiState {}

class SearchHistory extends SearchUiState {
  SearchHistory({
    this.data = const <String>[],
  });

  final List<String> data;
}

class SearchLoading extends SearchUiState {}

class SearchSuccess extends SearchUiState {
  SearchSuccess({
    this.data = const <ItunesPodcast>[],
  });

  final List<ItunesPodcast> data;
}

class SearchFailure extends SearchUiState {}
