import 'package:flutter_test/flutter_test.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/local/shared_pref_search_history_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;
  late SharedPreferencesSearchHistoryDao searchHistoryDao;
  const historyKey = SharedPreferencesSearchHistoryDao.searchItemsKey;

  setUp(() async {
    //arrange
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    searchHistoryDao =
        SharedPreferencesSearchHistoryDao(sharedPreferences: preferences);
  });

  group("Get History", () {
    test("emits an empty list on start", () {
      //act
      final historyStream = searchHistoryDao.getSearchHistory();

      //assert
      expect(historyStream, emits([]));
    });

    test("emits a list of saved items", () {
      //act
      final dummyHistory = ["foo", "bar", "ls"];
      preferences.setStringList(historyKey, ["foo", "bar", "ls"]);
      final historyStream = searchHistoryDao.getSearchHistory();

      //assert
      expect(
        historyStream,
        emitsInOrder([
          isA<List<String>>()
              .having((history) => history, "history", equals(dummyHistory))
              .having((history) => history.length, "length", equals(3)),
        ]),
      );
    });
  });

  group("Add to History", () {
    test("emits an updated history", () {
      //arrange
      final dummyHistory = ["foo", "bar", "ls"];
      preferences.setStringList(historyKey, dummyHistory);
      final historyStream = searchHistoryDao.getSearchHistory();

      // assert
      expect(
        historyStream,
        emits(["foo", "bar", "ls", "b"]),
      );

      // act
      searchHistoryDao.addToSearchHistory(searchTerm: "b");
    });

    test(
        "when history == 5, pop first, add new item, then emit updated history",
        () {
      //arrange
      final dummyHistory = ["foo", "bar", "ls", "mv", "dir"];
      preferences.setStringList(historyKey, dummyHistory);
      final historyStream = searchHistoryDao.getSearchHistory();

      // assert
      expect(
        historyStream,
        emits(["bar", "ls", "mv", "dir", "b"]),
      );

      // act
      searchHistoryDao.addToSearchHistory(searchTerm: "b");
    });
  });

  group("Remove from History", () {
    test("removes the item and emits the updated list", () {
      //arrange
      final dummyHistory = ["foo", "bar", "ls", "mv", "dir"];
      preferences.setStringList(historyKey, dummyHistory);
      final historyStream = searchHistoryDao.getSearchHistory();

      // assert
      expect(
        historyStream,
        emits(["foo", "bar", "ls", "mv"]),
      );

      // act
      searchHistoryDao.removeFromSearchHistory(searchTerm: "dir");
    });

    test("when history has 1 item, remove the item and emit an empty list", () {
      //arrange
      final dummyHistory = ["foo"];
      preferences.setStringList(historyKey, dummyHistory);
      final historyStream = searchHistoryDao.getSearchHistory();

      // assert
      expect(
        historyStream,
        emits([]),
      );

      // act
      searchHistoryDao.removeFromSearchHistory(searchTerm: "foo");
    });
  });

  group("Clear History", () {
    test("clears saved items and emits an empty list", () {
      //arrange
      final dummyHistory = ["foo", "bar", "ls", "mv", "dir"];
      preferences.setStringList(historyKey, dummyHistory);
      final historyStream = searchHistoryDao.getSearchHistory();

      // assert
      expect(
        historyStream,
        emits([]),
      );

      // act
      searchHistoryDao.clearSearchHistory();
    });
  });

  tearDownAll(() {
    searchHistoryDao.close();
  });
}
