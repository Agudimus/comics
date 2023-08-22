// lib/services/api_service.dart

import 'package:dio/dio.dart';
import '../models/recommended_komik.dart';
import '../models/popular_komik.dart';
import '../models/detail_komik.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<RecommendedKomik>> fetchRecommendedKomik() async {
    final response =
        await _dio.get('https://komikcast-api.cyclic.app/recommended');
    final List<RecommendedKomik> komikList = [];

    if (response.statusCode == 200) {
      for (var komikData in response.data['data']) {
        komikList.add(RecommendedKomik(
          title: komikData['title'],
          href: komikData['href'],
          rating: komikData['rating'],
          chapter: komikData['chapter'],
          type: komikData['type'],
          thumbnail: komikData['thumbnail'],
        ));
      }
    }

    return komikList;
  }

  Future<List<PopularKomik>> fetchPopularKomik() async {
    final response = await _dio.get('https://komikcast-api.cyclic.app/popular');
    final List<PopularKomik> komikList = [];

    if (response.statusCode == 200) {
      for (var komikData in response.data['data']) {
        komikList.add(PopularKomik(
          title: komikData['title'],
          href: komikData['href'],
          genre: komikData['genre'],
          year: komikData['year'],
          thumbnail: komikData['thumbnail'],
        ));
      }
    }

    return komikList;
  }

  Future<DetailKomik> fetchDetailKomik(String href) async {
    final response =
        await _dio.get('https://komikcast-api.cyclic.app/detail$href');
    final data = response.data['data'];

    return DetailKomik(
      title: data['title'],
      rating: data['rating'],
      status: data['status'],
      thumbnail: data['thumbnail'],
      author: data['author'],
      description: data['description'],
    );
  }
}
