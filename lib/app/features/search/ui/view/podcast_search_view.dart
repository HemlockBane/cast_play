import 'package:flutter/material.dart';
import 'package:podplay_flutter/app/features/search/ui/view/podcast_search_delegate.dart';

class PodcastSearchView extends StatefulWidget {
  const PodcastSearchView({Key? key}) : super(key: key);

  @override
  State<PodcastSearchView> createState() => _PodcastSearchViewState();
}

class _PodcastSearchViewState extends State<PodcastSearchView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 21, right: 21, top: 40),
          child: TextFormField(
            onTap: () {
              showSearch(
                context: context,
                delegate: PodcastSearchDelegate(
                  searchFieldLabel: "Type here...",
                  searchFieldStyle: const TextStyle(fontSize: 15)
                ),
              );
            },
            enabled: true,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: "Search for podcasts...",
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text("Search Page"),
          ),
        )
      ],
    );
  }
}