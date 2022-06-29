import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podplay_flutter/app/features/search/ui/bloc/podcast_search_cubit.dart';
import 'package:podplay_flutter/app/features/search/ui/view/podcast_search_delegate.dart';

class PodcastSearchView extends StatelessWidget {
  const PodcastSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PodcastSearchCubit(),
      child: const PodcastSearchBody(),
    );
  }
}

class PodcastSearchBody extends StatefulWidget {
  const PodcastSearchBody({Key? key}) : super(key: key);

  @override
  State<PodcastSearchBody> createState() => _PodcastSearchBodyState();
}

class _PodcastSearchBodyState extends State<PodcastSearchBody> {
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
              final searchCubit = context.read<PodcastSearchCubit>();
              searchCubit.getSearchHistory();
              showSearch(
                context: context,
                delegate: PodcastSearchDelegate(
                  podcastSearchCubit: searchCubit,
                  searchFieldLabel: "Type here...",
                  searchFieldStyle: const TextStyle(fontSize: 15),
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
