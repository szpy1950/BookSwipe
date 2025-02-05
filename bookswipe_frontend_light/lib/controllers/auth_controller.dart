// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../screens/main_screen.dart';
import '../screens/landing_page.dart';

class AuthController {
  final ApiService _api;
  final AuthService _auth;

  AuthController({
    ApiService? apiService,
    AuthService? authService
  }) : _api = apiService ?? ApiService(),
        _auth = authService ?? AuthService();

  // login method that takes username and passwords
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _api.login(username, password);
      if (response['success']) {
        await _auth.saveToken(response['token']);
        return response;
      } else {
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // logout method
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.deleteToken();  // Clear stored token
      if (context.mounted) {
        // Navigate back to landing page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
              (route) => false,
        );
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // check if there is already a valid authentication token stored from a previous session
  Future<bool> checkAuth(BuildContext context) async {
    final token = await _auth.getToken();
    if (token != null) {
      final userData = await _auth.verifyToken(token);
      if (userData != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(userData: userData),
          ),
        );
        return true;
      }
    }

    // Return false if:
    // - No token found
    // - Token was invalid
    // - Failed to get user data
    return false;
  }

  // create a new account
  Future<Map<String, dynamic>> signup(String username, String password) async {
    try {
      final response = await _api.signup(username, password);
      if (response['success']) {
        return response;
      } else {
        throw Exception(response['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('Signup error: $e');
    }
  }

  // going to main mage
  Future<void> loginAndNavigate({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    final result = await login(username, password);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(userData: result['user']),
        ),
      );
    }
  }
}