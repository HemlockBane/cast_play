import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:podplay_flutter/app/features/search/data/repository/podcast_search_repository.dart';
import 'package:podplay_flutter/app/features/search/ui/bloc/podcast_search_ui_state.dart';
import 'package:podplay_flutter/core/data/model/resource.dart';
import 'package:podplay_flutter/core/di/di.dart';

import '../../data/model/response/podcast_response.dart';

const saveTermDelay = Duration(milliseconds: 300);

class PodcastSearchCubit extends Cubit<SearchUiState> {
  PodcastSearchCubit({
    PodcastSearchRepository? podcastSearchRepository,
  })  : _podcastSearchRepository =
            podcastSearchRepository ?? locator<PodcastSearchRepository>(),
        super(SearchHistory());

  final PodcastSearchRepository _podcastSearchRepository;
  StreamSubscription<List<String>>? _historyStreamSubscription;

  void getSearchHistory() {
    _historyStreamSubscription?.cancel();
    _historyStreamSubscription =
        _podcastSearchRepository.searchHistory.listen((history) {
      emit(SearchHistory(data: history));
    });
  }

  void _addToSearchHistory({required String searchTerm}) {
    _podcastSearchRepository.addToSearchHistory(searchTerm: searchTerm);
  }

  void removeFromSearchHistory({required String searchTerm}) {
    _podcastSearchRepository.removeFromSearchHistory(searchTerm: searchTerm);
  }

  void clearSearchHistory() {
    _podcastSearchRepository.clearSearchHistory();
  }

  void getPodcastByTerm({
    required String searchTerm,
    bool shouldSaveSearchTerm = true,
  }) async {
    if (shouldSaveSearchTerm) {
      Future.delayed(saveTermDelay, () {
        _addToSearchHistory(searchTerm: searchTerm);
      });

      emit(SearchLoading());
      final resource =
          await _podcastSearchRepository.getPodcastByTerm(searchTerm);
      if (resource is Failure<PodcastResponse>) {
        // TODO: Make error handling robust
        // TODO: Pass some descriptive data to search failure
        emit(SearchFailure());
      } else if (resource is Success<PodcastResponse>) {
        final data = resource.data?.results ?? [];
        emit(SearchSuccess(data: data));
      }
    }
  }

  @override
  Future<void> close() {
    _historyStreamSubscription?.cancel();
    _podcastSearchRepository.close();
    return super.close();
  }
}
