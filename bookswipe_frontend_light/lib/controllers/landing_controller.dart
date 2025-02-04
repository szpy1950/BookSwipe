// lib/controllers/landing_controller.dart
import 'package:flutter/material.dart';
import '../screens/login_page.dart';
import '../screens/signup_page.dart';

class LandingController {

  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void navigateToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }
}