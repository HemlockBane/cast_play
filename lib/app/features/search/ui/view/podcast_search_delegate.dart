import 'package:flutter/material.dart';

class PodcastSearchDelegate extends SearchDelegate {
  PodcastSearchDelegate({
    String? searchFieldLabel,
    TextStyle? searchFieldStyle,
    InputDecorationTheme? searchFieldDecorationTheme,
  }) : super(
          searchFieldLabel: searchFieldLabel,
          searchFieldStyle: searchFieldStyle,
          searchFieldDecorationTheme: searchFieldDecorationTheme,
        );

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
    return const PodcastSearchResultsView();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const PodcastSearchSuggestionsView();
  }
}

///==============================================================================
class PodcastSearchSuggestionsView extends StatelessWidget {
  const PodcastSearchSuggestionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchHistoryView();
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
  }) : super(key: key);

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
                onTap: (){
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
          const Divider(thickness: 0.5, color: Color(0xFFEEEEEE),),
          const SizedBox(height: 12),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: 5,
            separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
            itemBuilder: (ctx, idx) {
              return SearchHistoryItem(
                context: context,
                item: "Item",
                onSearchItemClicked: (String item) {},
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
  }) : super(key: key);

  final BuildContext context;
  final String item;
  final Function(String searchItem) onSearchItemClicked;

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
                const Expanded(
                  child: Text(
                    "Item",
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
            onTap: (){

            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
              child: Icon(Icons.close),
            )
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
    return Container();
  }
}


