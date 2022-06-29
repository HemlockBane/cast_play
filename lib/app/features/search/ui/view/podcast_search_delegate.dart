import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podplay_flutter/app/features/search/ui/bloc/podcast_search_cubit.dart';
import 'package:podplay_flutter/app/features/search/ui/bloc/podcast_search_ui_state.dart';

class PodcastSearchDelegate extends SearchDelegate {
  PodcastSearchDelegate({
    required PodcastSearchCubit podcastSearchCubit,
    String? searchFieldLabel,
    TextStyle? searchFieldStyle,
    InputDecorationTheme? searchFieldDecorationTheme,
  })  : _podcastSearchCubit = podcastSearchCubit,
        super(
          searchFieldLabel: searchFieldLabel,
          searchFieldStyle: searchFieldStyle,
          searchFieldDecorationTheme: searchFieldDecorationTheme,
        );
  final PodcastSearchCubit _podcastSearchCubit;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final parentTheme = super.appBarTheme(context);
    return parentTheme.copyWith(
      appBarTheme: parentTheme.appBarTheme.copyWith(
        elevation: 0,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () {
            query = "";
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocProvider.value(
      value: _podcastSearchCubit,
      child: const PodcastSearchResultsView(),
    );
  }

  @override
  void showResults(
    BuildContext context, {
    bool shouldSaveSearchItem = true,
  }) {
    if (query.isEmpty) {
      return;
    }

    _podcastSearchCubit.getPodcastByTerm(
      searchTerm: query,
      shouldSaveSearchTerm: shouldSaveSearchItem,
    );
    super.showResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocProvider.value(
      value: _podcastSearchCubit,
      child: PodcastSearchSuggestionsView(
        onHistoryItemTap: (String term) {
          query = term;
          showResults(context, shouldSaveSearchItem: false);
        },
      ),
    );
  }
}

///==============================================================================
class PodcastSearchSuggestionsView extends StatelessWidget {
  const PodcastSearchSuggestionsView({
    Key? key,
    required this.onHistoryItemTap,
  }) : super(key: key);

  final Function(String term) onHistoryItemTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PodcastSearchCubit, SearchUiState>(
      buildWhen: (_, state) => state is SearchHistory, // to control rebuilds
      builder: (context, state) {
        if (state is SearchHistory) {
          if (state.data.isEmpty) {
            return const SearchInfoView();
          }
          return SearchHistoryView(
            searchHistory: state.data,
            onHistoryItemTap: onHistoryItemTap,
          );
        }

        return const SizedBox();
      },
    );
  }
}

///==============================================================================
class SearchInfoView extends StatelessWidget {
  const SearchInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Search for podcasts"),
    );
  }
}

///==============================================================================
class SearchHistoryView extends StatelessWidget {
  const SearchHistoryView({
    Key? key,
    required this.searchHistory,
    required this.onHistoryItemTap,
  }) : super(key: key);

  final List<String> searchHistory;
  final Function(String term) onHistoryItemTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Search History",
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  final cubit = context.read<PodcastSearchCubit>();
                  cubit.clearSearchHistory();
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 1, 5, 1),
                  child: Text(
                    "Clear",
                  ),
                ),
              )
            ],
          ),
          const Divider(
            thickness: 0.5,
            color: Color(0xFFEEEEEE),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: searchHistory.length,
            separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
            itemBuilder: (ctx, idx) {
              final historyItem = searchHistory[idx];
              final cubit = context.read<PodcastSearchCubit>();
              return SearchHistoryItem(
                context: context,
                item: historyItem,
                onSearchItemClicked: (String item) {
                  onHistoryItemTap(item); // Start search here
                },
                onSearchItemCleared: (String item) {
                  cubit.removeFromSearchHistory(searchTerm: item);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

///==============================================================================
class SearchHistoryItem extends StatelessWidget {
  const SearchHistoryItem({
    Key? key,
    required this.context,
    required this.item,
    required this.onSearchItemClicked,
    required this.onSearchItemCleared,
  }) : super(key: key);

  final BuildContext context;
  final String item;
  final Function(String searchItem) onSearchItemClicked;
  final Function(String searchItem) onSearchItemCleared;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              onSearchItemClicked(item);
            },
            child: Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(width: 8.46),
                Expanded(
                  child: Text(
                    item,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () {
            onSearchItemCleared(item);
          },
          child: const Padding(
            padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
            child: Icon(Icons.close),
          ),
        )
      ],
    );
  }
}

///==============================================================================
class PodcastSearchResultsView extends StatelessWidget {
  const PodcastSearchResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PodcastSearchCubit, SearchUiState>(
      buildWhen: (_, state) => state is! SearchHistory, // to control rebuilds
      builder: (context, state) {
        if (state is SearchLoading) {
          return const CircularProgressIndicator();
        }
        if (state is SearchFailure) {
          return const Text("Failure");
        }

        if (state is SearchSuccess) {
          return const Text("Success");
        }

        return const SizedBox();
      },
    );
  }
}

// We want to be able to search from 2 places:
// - Tapping a search history item
// - Tapping the search icon in the keyboard

// What's the problem?
// The problem is that our initial way of saving the item &
// starting the search in the build results method was causing an
// already saved item to get saved again

// Options:
// - Move the logic for adding item to the search
// methid

// What would have been the best:
// - We can control the switching process from suggestions to results and back
// - We can access the search textfield so we trigger the search process by ourselves
// Flow for search from textfield would be:
// - When user presses enter button, call search method
// - Change from suggestions view to results view
// Flow for search from history item would be:
// - When user taps the history item, set query to history item
// - Call search method with save flag off
// - Change from suggestions view to results view
// Ways to go back to suggestions view would be:
// - Tap, the textfield, clear the text in textfield
