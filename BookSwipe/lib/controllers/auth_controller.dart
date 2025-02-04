// lib/controllers/profile_controller.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfileController {
  final ApiService _api = ApiService();

  // Fetch user preferences from server
  Future<Map<String, Set<String>>> fetchUserPreferences(int userId) async {
    final response = await _api.getUserPreferences(userId);
    final preferences = <String, Set<String>>{};

    if (response['success'] == true && response['preferences'] != null) {
      final prefsData = response['preferences'] as Map<String, dynamic>;

      // Match server's response structure
      preferences['Genres'] = Set<String>.from(prefsData['Genres'] ?? []);
      preferences['Languages'] = Set<String>.from(prefsData['Languages'] ?? []);
      preferences['Book Length'] = Set<String>.from(prefsData['Book Length'] ?? []);
      preferences['Formats'] = Set<String>.from(prefsData['Formats'] ?? []);
    }

    // Provide defaults that match your database enum types
    if (!preferences.containsKey('Genres')) {
      preferences['Genres'] = {'Fiction'};
    }
    if (!preferences.containsKey('Languages')) {
      preferences['Languages'] = {'English'};
    }
    if (!preferences.containsKey('Book Length')) {
      preferences['Book Length'] = {'medium'};  // Match your enum
    }
    if (!preferences.containsKey('Formats')) { // Add this block
      preferences['Formats'] = {'Paperback'};
    }

    return preferences;
  }

  // Update preferences on server
  Future<Map<String, List<String>>> updatePreferences({
    required int userId,
    required Map<String, List<String>> preferences,
  }) async {
    final response = await _api.updateUserPreferences(
      userId: userId,
      preferences: preferences,
    );

    if (response['success'] == true) {
      return preferences;
    } else {
      throw Exception(response['message'] ?? 'Failed to update preferences');
    }
  }

  Future<List<Map<String, dynamic>>> getUserLikedBooks(int userId) async {
    try {
      return await _api.getUserLikedBooks(userId);
    } catch (e) {
      print('Error in ProfileController.getUserLikedBooks: $e');
      return [];
    }
  }

  Future<Map<String, List<String>>> fetchAvailablePreferences() async {
    final response = await _api.getAvailablePreferences();
    final preferences = <String, List<String>>{};

    if (response['success'] == true && response['preferences'] != null) {
      final prefsData = response['preferences'] as Map<String, dynamic>;
      preferences.addAll(prefsData.map((key, value) =>
          MapEntry(key, List<String>.from(value as List))));
    }

    return preferences;
  }

}
