import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PodcastSearchHistoryDao {
  Stream<List<String>> getSearchHistory();

  void addToSearchHistory();

  void removeFromSearchHistory();

  void clearSearchHistory();
}


// It seems using named implementations with generic types doesn't  work...
// GetIt/Injectable both seem to have issues with generic implementation types
@named
@Injectable(as: PodcastSearchHistoryDao)
class SharedPreferencesSearchHistoryDao implements PodcastSearchHistoryDao {
  SharedPreferencesSearchHistoryDao({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  void addToSearchHistory() {}

  @override
  void clearSearchHistory() {}

  @override
  Stream<List<String>> getSearchHistory() {
    return const Stream<List<String>>.empty();
  }

  @override
  void removeFromSearchHistory() {}
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
