// It seems using named implementations with generic types doesn't  work...
// GetIt/Injectable both seem to have issues with generic implementation types
import 'package:injectable/injectable.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/local/podcast_search_history_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

const searchItems = "searchItems";

@named
@Injectable(as: PodcastSearchHistoryDao)
class SharedPreferencesSearchHistoryDao implements PodcastSearchHistoryDao {
  SharedPreferencesSearchHistoryDao({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;
  final BehaviorSubject<List<String>> _historySubject = BehaviorSubject();
  Stream<List<String>> get _historyStream => _historySubject.stream;

  @override
  void addToSearchHistory({required String searchTerm}) async {
    List<String> history = _sharedPreferences.getStringList(searchItems) ?? [];
    if (history.length < 5) {
      history.add(searchTerm);
    } else if (history.length == 5) {
      history
        ..removeAt(0)
        ..add(searchTerm);
    }

    _sharedPreferences.setStringList(searchTerm, history);
    final data = _sharedPreferences.getStringList(searchTerm) ?? [];
    _historySubject.add(data.reversed.toList());
  }

  @override
  void clearSearchHistory() {
    _sharedPreferences.setStringList(searchItems, []);
    final history = _sharedPreferences.getStringList(searchItems) ?? [];
    _historySubject.add(history);
  }

  @override
  Stream<List<String>> getSearchHistory() async* {
    final data = _sharedPreferences.getStringList(searchItems) ?? [];
    yield data;
    yield* _historyStream;
  }

  @override
  void removeFromSearchHistory({required String searchTerm}) {
    final history = _sharedPreferences.getStringList(searchItems) ?? [];
    history.remove(searchTerm);
    _sharedPreferences.setStringList(searchItems, history);
    final data = _sharedPreferences.getStringList(searchItems) ?? [];
    _historySubject.add(data);
  }
}
