import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/login_page.dart';
import 'views/main_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/news_controller.dart';
import 'controllers/bookmark_controller.dart';
import 'controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Get.put(AuthController());
    Get.put(NewsController());
    Get.put(BookmarkController());
    Get.put(ThemeController());
    
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          title: 'News App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.grey[900],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              elevation: 2,
            ),
          ),
          themeMode: themeController.themeMode,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => GetBuilder<AuthController>(
              builder: (authController) {
                return authController.isLoggedIn ? MainPage() : LoginPage();
              },
            )),
            GetPage(name: '/login', page: () => LoginPage()),
            GetPage(name: '/main', page: () => MainPage()),
          ],
        );
      },
    );
  }
}
