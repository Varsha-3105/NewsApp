import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article_model.dart';
import '../services/news_service.dart';

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  List<Article> get articles => _articles;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;

  final String apiKey = '54418b2f32f545f1bd239fbf1c8a8935';  
  final String baseUrl = 'https://newsapi.org/v2';

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    _isLoading = true;
    _error = '';
    update();

    try {
      final news = await _newsService.getTopHeadlines();
      _articles = news;
      _error = '';
    } catch (e) {
      _error = 'Failed to load news: ${e.toString()}';
    } finally {
      _isLoading = false;
      update();
    }
  }

  void _loadSampleData() {
    _articles = [
      Article(
        title: 'Breaking: Technology Advances in 2025',
        description: 'Latest developments in artificial intelligence and machine learning are transforming industries worldwide.',
        url: 'https://example.com/tech-news',
        urlToImage: 'https://via.placeholder.com/300x200?text=Tech+News',
        source: 'Tech Daily',
        publishedAt: '2025-05-24T10:30:00Z',
      ),
      Article(
        title: 'Global Climate Summit Concludes',
        description: 'World leaders agree on new measures to combat climate change and reduce carbon emissions.',
        url: 'https://example.com/climate-news',
        urlToImage: 'https://via.placeholder.com/300x200?text=Climate+News',
        source: 'Global News',
        publishedAt: '2025-05-23T15:45:00Z',
      ),
      Article(
        title: 'Sports Championship Final Results',
        description: 'Exciting matches conclude the championship season with record-breaking performances.',
        url: 'https://example.com/sports-news',
        urlToImage: 'https://via.placeholder.com/300x200?text=Sports+News',
        source: 'Sports Weekly',
        publishedAt: '2025-05-22T20:15:00Z',
      ),
    ];
  }

  Future<void> refreshNews() async {
    await fetchNews();
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      await fetchNews();
      return;
    }

    _isLoading = true;
    _error = '';
    update();

    try {
      final results = await _newsService.searchNews(query);
      _articles = results;
      _error = '';
    } catch (e) {
      _error = 'Failed to search news: ${e.toString()}';
    } finally {
      _isLoading = false;
      update();
    }
  }
}