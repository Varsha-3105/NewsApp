import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/article_model.dart';

class BookmarkController extends GetxController {
  List<Article> _bookmarkedArticles = [];
  List<Article> get bookmarkedArticles => _bookmarkedArticles;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeBookmarks();
  }

  Future<void> _initializeBookmarks() async {
    if (!_isInitialized) {
      await loadBookmarks();
      _isInitialized = true;
    }
  }

  Future<void> loadBookmarks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? bookmarksJson = prefs.getStringList('bookmarks');
      
      if (bookmarksJson != null && bookmarksJson.isNotEmpty) {
        _bookmarkedArticles = bookmarksJson
            .map((json) => Article.fromJson(jsonDecode(json)))
            .toList();
        update();
        print('Successfully loaded ${_bookmarkedArticles.length} bookmarks');
      } else {
        print('No bookmarks found in storage');
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
      _bookmarkedArticles = [];
    }
  }

  Future<void> saveBookmarks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> bookmarksJson = _bookmarkedArticles
          .map((article) => jsonEncode(article.toJson()))
          .toList();
      
      final bool success = await prefs.setStringList('bookmarks', bookmarksJson);
      if (success) {
        print('Successfully saved ${bookmarksJson.length} bookmarks');
      } else {
        print('Failed to save bookmarks');
      }
    } catch (e) {
      print('Error saving bookmarks: $e');
    }
  }

  bool isBookmarked(Article article) {
    return _bookmarkedArticles.any((bookmarked) => bookmarked.url == article.url);
  }

  Future<void> toggleBookmark(Article article) async {
    try {
      if (isBookmarked(article)) {
        _bookmarkedArticles.removeWhere((bookmarked) => bookmarked.url == article.url);
        Get.snackbar('Removed', 'Article removed from bookmarks');
      } else {
        _bookmarkedArticles.add(article);
        Get.snackbar('Added', 'Article bookmarked successfully');
      }
      await saveBookmarks();
      update();
    } catch (e) {
      print('Error toggling bookmark: $e');
      Get.snackbar('Error', 'Failed to update bookmark');
    }
  }

  Future<void> removeBookmark(Article article) async {
    try {
      _bookmarkedArticles.removeWhere((bookmarked) => bookmarked.url == article.url);
      await saveBookmarks();
      update();
      Get.snackbar('Removed', 'Article removed from bookmarks');
    } catch (e) {
      print('Error removing bookmark: $e');
      Get.snackbar('Error', 'Failed to remove bookmark');
    }
  }
}
