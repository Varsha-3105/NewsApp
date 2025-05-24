import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'news_feed_page.dart';
import 'bookmarks_page.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/news_controller.dart';
import '../controllers/bookmark_controller.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _pages = [
    NewsFeedPage(),
    BookmarksPage(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        Get.find<NewsController>().searchNews(_searchController.text);
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Get.find<NewsController>().searchNews(value);
                  }
                },
              )
            : Text(
                'Bookmarks',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => themeController.toggleTheme(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (_currentIndex == 0) {
            await Get.find<NewsController>().refreshNews();
          } else {
            await Get.find<BookmarkController>().loadBookmarks();
          }
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await authController.logout();
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
