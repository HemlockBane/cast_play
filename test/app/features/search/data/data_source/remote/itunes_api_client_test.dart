import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:podplay_flutter/app/features/search/data/data_source/remote/itunes_api_client.dart';
import 'package:podplay_flutter/app/features/search/data/model/response/podcast_response.dart';
import 'package:podplay_flutter/core/data/data_source/remote/api_client.dart';

import 'itunes_api_client_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  late ItunesApiClient itunesApiClient;
  late MockHttpClientAdapter mockClientAdapter;
  late Dio dio;

  setUp(() {
    // arrange
    dio = Dio();
    mockClientAdapter = MockHttpClientAdapter();
    dio.httpClientAdapter = mockClientAdapter;
    final apiClient = ApiClient(dio: dio);
    itunesApiClient = ItunesApiClient.fromApiClient(apiClient);
  });

  group("Get Podcast", () {
    test("returns an empty list when no podcast is found", () async {
      // arrange
      final payload = jsonEncode(mockEmptyJsonString);
      final responseBody = ResponseBody.fromString(payload, 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      });
      when(mockClientAdapter.fetch(any, any, any))
          .thenAnswer((_) async => responseBody);

      // act
      final response = await itunesApiClient.getPodcastByTerm("");

      // assert
      expect(response.resultCount, equals(0));
      expect(response.results, isA<List<ItunesPodcast>>()
          .having((podcasts) => podcasts.length, "length", equals(0)));

    });

    test("returns a list of podcasts", () async {
      // arrange
      final payload = jsonEncode(mockJsonString);
      final responseBody = ResponseBody.fromString(payload, 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      });
      when(mockClientAdapter.fetch(any, any, any))
          .thenAnswer((_) async => responseBody);

      // act
      final response = await itunesApiClient.getPodcastByTerm("");

      // assert
      expect(response.resultCount, equals(2));
      expect(response.results, isA<List<ItunesPodcast>>()
          .having((podcasts) => podcasts.length, "length", equals(2)));

    });
  });

  tearDownAll(() {
    mockClientAdapter.close();
  });
}


final mockEmptyJsonString = {
  "resultCount": 0,
  "results": []
};

final mockJsonString = {
  "resultCount": 2,
  "results": [
    {
      "wrapperType": "track",
      "kind": "podcast",
      "collectionId": 1553653114,
      "trackId": 1553653114,
      "artistName": "Hhhhh",
      "collectionName": "Girl Talk",
      "trackName": "Girl Talk",
      "collectionCensoredName": "Girl Talk",
      "trackCensoredName": "Girl Talk",
      "collectionViewUrl": "https://podcasts.apple.com/us/podcast/girl-talk/id1553653114?uo=4",
      "feedUrl": "https://anchor.fm/s/4c82ea00/podcast/rss",
      "trackViewUrl": "https://podcasts.apple.com/us/podcast/girl-talk/id1553653114?uo=4",
      "artworkUrl30": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts124/v4/f1/df/35/f1df3510-54cb-d857-9839-fa08d5882dcc/mza_3089396795850473347.jpg/30x30bb.jpg",
      "artworkUrl60": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts124/v4/f1/df/35/f1df3510-54cb-d857-9839-fa08d5882dcc/mza_3089396795850473347.jpg/60x60bb.jpg",
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts124/v4/f1/df/35/f1df3510-54cb-d857-9839-fa08d5882dcc/mza_3089396795850473347.jpg/100x100bb.jpg",
      "collectionPrice": 0.00,
      "trackPrice": 0.00,
      "trackRentalPrice": 0,
      "collectionHdPrice": 0,
      "trackHdPrice": 0,
      "trackHdRentalPrice": 0,
      "releaseDate": "2021-02-12T21:34:00Z",
      "collectionExplicitness": "cleaned",
      "trackExplicitness": "cleaned",
      "trackCount": 1,
      "country": "USA",
      "currency": "USD",
      "primaryGenreName": "Fashion & Beauty",
      "contentAdvisoryRating": "Clean",
      "artworkUrl600": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts124/v4/f1/df/35/f1df3510-54cb-d857-9839-fa08d5882dcc/mza_3089396795850473347.jpg/600x600bb.jpg",
      "genreIds": [
        "1459",
        "26",
        "1301"
      ],
      "genres": [
        "Fashion & Beauty",
        "Podcasts",
        "Arts"
      ]
    },
    {
      "wrapperType": "track",
      "kind": "podcast",
      "collectionId": 1548406703,
      "trackId": 1548406703,
      "artistName": "Mia Collazo",
      "collectionName": "Hhhhh",
      "trackName": "Hhhhh",
      "collectionCensoredName": "Hhhhh",
      "trackCensoredName": "Hhhhh",
      "collectionViewUrl": "https://podcasts.apple.com/us/podcast/hhhhh/id1548406703?uo=4",
      "feedUrl": "https://anchor.fm/s/47880d28/podcast/rss",
      "trackViewUrl": "https://podcasts.apple.com/us/podcast/hhhhh/id1548406703?uo=4",
      "artworkUrl30": "https://is2-ssl.mzstatic.com/image/thumb/Podcasts124/v4/b9/27/bc/b927bc94-9792-3a68-39e6-e807b681f5a5/mza_16645007062338111792.jpg/30x30bb.jpg",
      "artworkUrl60": "https://is2-ssl.mzstatic.com/image/thumb/Podcasts124/v4/b9/27/bc/b927bc94-9792-3a68-39e6-e807b681f5a5/mza_16645007062338111792.jpg/60x60bb.jpg",
      "artworkUrl100": "https://is2-ssl.mzstatic.com/image/thumb/Podcasts124/v4/b9/27/bc/b927bc94-9792-3a68-39e6-e807b681f5a5/mza_16645007062338111792.jpg/100x100bb.jpg",
      "collectionPrice": 0.00,
      "trackPrice": 0.00,
      "trackRentalPrice": 0,
      "collectionHdPrice": 0,
      "trackHdPrice": 0,
      "trackHdRentalPrice": 0,
      "releaseDate": "2021-01-11T22:17:00Z",
      "collectionExplicitness": "cleaned",
      "trackExplicitness": "cleaned",
      "trackCount": 1,
      "country": "USA",
      "currency": "USD",
      "primaryGenreName": "Fashion & Beauty",
      "contentAdvisoryRating": "Clean",
      "artworkUrl600": "https://is2-ssl.mzstatic.com/image/thumb/Podcasts124/v4/b9/27/bc/b927bc94-9792-3a68-39e6-e807b681f5a5/mza_16645007062338111792.jpg/600x600bb.jpg",
      "genreIds": [
        "1459",
        "26",
        "1301"
      ],
      "genres": [
        "Fashion & Beauty",
        "Podcasts",
        "Arts"
      ]
    }
  ]
};