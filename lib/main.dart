import 'package:flutter/material.dart';
import 'models/recommended_komik.dart';
import 'models/popular_komik.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Komik App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ApiService apiService = ApiService();

  Widget _buildKomikList(Future<List<dynamic>> Function() fetchFunction) {
    return FutureBuilder<List<dynamic>>(
      future: fetchFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error fetching data: ${snapshot.error.toString()}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final komikList = snapshot.data!;

        return ListView.builder(
          itemCount: komikList.length,
          itemBuilder: (context, index) {
            final komik = komikList[index];
            return ListTile(
              title: Text(komik is RecommendedKomik
                  ? komik.title
                  : komik is PopularKomik
                      ? komik.title
                      : ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(komik is RecommendedKomik
                      ? 'Rating: ${komik.rating}'
                      : ''),
                  Text(komik is RecommendedKomik
                      ? 'Last Chapter: ${komik.chapter}'
                      : komik is PopularKomik
                          ? 'Genre: ${komik.genre}'
                          : ''),
                ],
              ),
              leading: Image.network(komik.thumbnail),
            );
          },
        );
      },
    );
  }

  Widget _buildRecommendedKomikList() {
    return _buildKomikList(apiService.fetchRecommendedKomik);
  }

  Widget _buildPopularKomikList() {
    return _buildKomikList(apiService.fetchPopularKomik);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Komik App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Recommended'),
              Tab(text: 'Popular'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecommendedKomikList(),
            _buildPopularKomikList(),
          ],
        ),
      ),
    );
  }
}
