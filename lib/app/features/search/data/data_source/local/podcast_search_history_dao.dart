import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PodcastSearchHistoryDao {
  Stream<List<String>> getSearchHistory();

  void addToSearchHistory({required String searchTerm});

  void removeFromSearchHistory({required String searchTerm});

  void clearSearchHistory();
}
