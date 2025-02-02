// lib/services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';
import 'token_storage.dart';

class AuthService {
  final _storage = TokenStorage();
  late final ApiService _api;

  // Method to set the API service after construction
  void setApiService(ApiService api) {
    _api = api;
  }

  Future<void> saveToken(String token) async {
    await _storage.saveToken(token);
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  Future<void> deleteToken() async {
    await _storage.deleteToken();
  }

  Future<Map<String, dynamic>?> verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/verify-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': token}),
      );
      final data = json.decode(response.body);
      if (data['success']) {
        return data['user'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}