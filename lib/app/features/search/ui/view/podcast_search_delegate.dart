import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podplay_flutter/app/features/search/ui/bloc/podcast_search_cubit.dart';
import 'package:podplay_flutter/app/features/search/ui/bloc/podcast_search_ui_state.dart';
import 'package:podplay_flutter/app/features/search/ui/view/podcast_summary_item_view.dart';
import 'package:podplay_flutter/core/ui/widgets/app_circular_loading_view.dart';
import 'package:podplay_flutter/core/ui/widgets/app_error_view.dart';

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
  void showSuggestions(BuildContext context) {
    if (_podcastSearchCubit.state is! SearchHistory) {
      _podcastSearchCubit.getSearchHistory();
    }
    super.showSuggestions(context);
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
      buildWhen: (prevState, newState) => newState is SearchHistory,
      // to control rebuilds
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
          return const AppCircularLoadingView();
        }
        if (state is SearchFailure) {
          return const AppErrorView();
        }

        if (state is SearchSuccess) {
          return PodcastListView(
            data: state.data,
          );
        }

        return const SizedBox();
      },
    );
  }
}

class PodcastListView extends StatelessWidget {
  const PodcastListView({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<PodcastSummary> data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(),
      itemBuilder: (ctx, idx) {
        final summary = data[idx];
        return PodcastSummaryItemView(
          name: summary.name ?? "",
          imageUrl: summary.imageUrl ?? "",
          feedUrl: summary.feedUrl ?? "",
          lastUpdated: summary.lastUpdated ?? "",
        );
      },
    );
  }
}
