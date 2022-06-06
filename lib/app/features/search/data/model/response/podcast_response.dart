
import 'package:json_annotation/json_annotation.dart';

part 'podcast_response.g.dart';

@JsonSerializable()
class PodcastResponse {
  PodcastResponse({
    this.resultCount,
    this.results,
  });

  int? resultCount;
  List<ItunesPodcast>? results;

  factory PodcastResponse.fromJson(Map<String, dynamic> json) => _$PodcastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastResponseToJson(this);
}

@JsonSerializable()
class ItunesPodcast {
  ItunesPodcast({
    this.collectionCensoredName,
    this.feedUrl,
    this.artworkUrl30,
    this.artworkUrl60,
    this.artworkUrl100,
    this.releaseDate,
  });

  String? collectionCensoredName;
  String? feedUrl;
  String? artworkUrl30;
  String? artworkUrl60;
  String? artworkUrl100;
  String? releaseDate;

  factory ItunesPodcast.fromJson(Map<String, dynamic> json) => _$ItunesPodcastFromJson(json);

  Map<String, dynamic> toJson() => _$ItunesPodcastToJson(this);
}
