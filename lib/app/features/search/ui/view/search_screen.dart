import 'package:flutter/material.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/placeholder_api_client.dart';
import 'package:podplay_flutter/app/itunes_repository.dart';
import 'package:podplay_flutter/core/di/di.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    final itunesRepo = locator<ItunesRepository>();
    itunesRepo.getPodcastByTerm("ios").then((response) {
      print(response);
    });

    // final placeholderApiClient = locator<PlaceholderApiClient>();
    // placeholderApiClient.getPosts().then((response) {
    //   // print(response);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
