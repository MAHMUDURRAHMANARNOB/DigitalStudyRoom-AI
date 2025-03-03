import 'package:flutter/material.dart';
import '../../../api/api_controller.dart';
import '../models/UserDataModel.dart';

class AuthProvider with ChangeNotifier {
  final ApiController _authService = ApiController();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String userId, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.loginUser(userId, password);

    if (response != null && response['errorcode'] == 200) {
      try {
        _user = User.fromJson(response);
        print("User Logged In: $_user");

        await _saveUserSession(_user!);
        notifyListeners();
        return true;
      } catch (e) {
        print("Error parsing user data: $e");
      }
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> createUser(
      String userId,
      String username,
      String name,
      String email,
      String mobile,
      String password,
      String userType,
      String school,
      String address,
      String marketingSource,
      String classId,
      ) async {
    try {
      final bool success = await _authService.createUser(
        userId,
        username,
        name,
        email,
        mobile,
        password,
        userType,
        school,
        address,
        marketingSource,
        classId,
      );

      // Notify listeners about the result
      notifyListeners();

      return success;
    } catch (e) {
      // Exception occurred
      print('Exception creating user: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final user = await _authService.getLoggedInUser();
    if (user != null) {
      _user = user;
    }
    notifyListeners();
  }

  Future<void> _saveUserSession(User user) async {
    // Implement session saving (SharedPreferences, Secure Storage, etc.)
    print("User session saved successfully");
  }
}
