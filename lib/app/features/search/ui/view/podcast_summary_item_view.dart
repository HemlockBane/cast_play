import 'package:flutter/material.dart';
import 'package:podplay_flutter/core/utils/date_utils.dart';

class PodcastSummaryItemView extends StatelessWidget {
  const PodcastSummaryItemView({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.feedUrl,
    required this.lastUpdated,
  }) : super(key: key);

  final String name;
  final String imageUrl;
  final String feedUrl;
  final String lastUpdated;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(name),
      subtitle: Text(DateTimeUtils.getFormattedDate(lastUpdated)),
    );
  }
}
