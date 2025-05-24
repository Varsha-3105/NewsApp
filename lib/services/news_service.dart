import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class NewsService {
  final String baseUrl = 'https://newsapi.org/v2';
  final String apiKey = '54418b2f32f545f1bd239fbf1c8a8935';

  Future<List<Article>> getTopHeadlines() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];
        
        List<Article> articles = articlesJson
            .map((json) => Article.fromJson(json))
            .where((article) => 
              article.title.isNotEmpty && 
              article.description.isNotEmpty &&
              article.url.isNotEmpty
            )
            .toList();

        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<List<Article>> searchNews(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];
        
        List<Article> articles = articlesJson
            .map((json) => Article.fromJson(json))
            .where((article) => 
              article.title.isNotEmpty && 
              article.description.isNotEmpty &&
              article.url.isNotEmpty
            )
            .toList();

        return articles;
      } else {
        throw Exception('Failed to search news');
      }
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }
} 