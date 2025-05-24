import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    update();
  }

  Future<bool> login(String email, String password) async {
     
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }
 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    
    _isLoggedIn = true;
    update();
    return true;
  }

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userEmail');
      
      _isLoggedIn = false;
      update();

       
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar('Error', 'Failed to logout properly');
    }
  }
}