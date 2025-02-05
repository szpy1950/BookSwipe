// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import 'auth_service.dart';
import 'token_storage.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.153.159:8080';
  final _storage = TokenStorage();

  static String getImageUrl(String? imageUrl) {
    if (imageUrl == null ||
        imageUrl.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9]+\.jpg$').hasMatch(imageUrl)) {
      return '$baseUrl/images/placeholder.jpg';
    }
    return '$baseUrl/images/$imageUrl';
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  Future<Map<String, dynamic>> getUserPreferences(int userId) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId/preferences'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user preferences');
    }
  }

  Future<Map<String, dynamic>> updateUserPreferences({
    required int userId,
    required Map<String, List<String>> preferences,
  }) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/user/$userId/preferences'),
      headers: headers,
      body: json.encode({
        'preferences': preferences,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update preferences');
    }
  }

  Future<List<Map<String, dynamic>>> getUserLikedBooks(int userId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId/liked-books'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] && data['books'] != null) {
          return List<Map<String, dynamic>>.from(data['books']);
        }
        return [];
      } else {
        throw Exception('Failed to fetch liked books');
      }
    } catch (e) {
      print('Error fetching liked books: $e');
      throw Exception('Failed to fetch liked books: $e');
    }
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> verifyToken(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-token'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'token': token}),
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    return json.decode(response.body);
  }

  // Book endpoints
  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    final data = json.decode(response.body);

    if (data['success']) {
      return (data['books'] as List)
          .map((bookJson) => Book.fromJson(bookJson))
          .toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Map<String, dynamic>> getAvailablePreferences() async {
    final response = await http.get(
      Uri.parse('$baseUrl/available-preferences'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch available preferences');
    }
  }

  Future<void> likeBook(int bookId, int userId) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/user/$userId/like-book'),  // Replace 1 with actual user ID
      headers: headers,
      body: json.encode({
        'bookId': bookId,
      }),
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Failed to like book');
    }
  }
  Future<void> dislikeBook(int bookId, int userId) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/user/$userId/dislike-book'),
      headers: headers,
      body: json.encode({
        'bookId': bookId,
      }),
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Failed to dislike book');
    }
  }

  Future<List<Book>> fetchRecommendedBooks() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/recommended-books'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          return (data['books'] as List)
              .map((bookJson) => Book.fromJson(bookJson))
              .toList();
        } else {
          throw Exception('Server returned success: false');
        }
      } else {
        throw Exception('Failed to load recommended books. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Detailed error fetching recommended books: $e');
      rethrow;
    }
  }
}