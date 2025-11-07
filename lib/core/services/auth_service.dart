import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;

  Future<bool> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (email == "admin@genzcrm.com" && password == "123456") {
        _isLoggedIn = true;
        _userEmail = email;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }
}
