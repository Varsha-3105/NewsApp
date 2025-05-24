import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/news_controller.dart';
import '../controllers/bookmark_controller.dart';
import '../models/article_model.dart';
import 'web_view_page.dart';

class NewsFeedPage extends StatelessWidget {
  final NewsController newsController = Get.find<NewsController>();
  final BookmarkController bookmarkController = Get.find<BookmarkController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
      builder: (controller) {
        if (controller.isLoading && controller.articles.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNews,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              Article article = controller.articles[index];
              return _buildArticleCard(article);
            },
          ),
        );
      },
    );
  }

  Widget _buildArticleCard(Article article) {
    return GetBuilder<BookmarkController>(
      builder: (bookmarkController) {
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => WebViewPage(url: article.url, title: article.title));
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    child: article.urlToImage.isNotEmpty
                        ? Image.network(
                            article.urlToImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.newspaper,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 8),
                      
                      
                      Text(
                        article.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 12),
                      
                       Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.source,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  _formatDate(article.publishedAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                           IconButton(
                            onPressed: () {
                              bookmarkController.toggleBookmark(article);
                            },
                            icon: Icon(
                              bookmarkController.isBookmarked(article)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: bookmarkController.isBookmarked(article)
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('d MMMM, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}