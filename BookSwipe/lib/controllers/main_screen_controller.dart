// lib/controllers/main_screen_controller.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MainScreenController {
  final ApiService _api = ApiService();

  Future<void> handleLogout(BuildContext context) async {
    final bool shouldLogout = await showLogoutDialog(context);

    if (shouldLogout) {
      // Could add API call to logout on server
      // await _api.logout();

      // Clear any stored credentials/tokens here

      if (context.mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  Future<bool> showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
