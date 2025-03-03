import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../widgets/login_form.dart';  // New widget we'll create
import '../widgets/loading_button.dart';  // New reusable widget

// Screen that handles user login with username/password form
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authController = AuthController();
  final _formKey = GlobalKey<FormState>();  // For form validation
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Handles login form submission and navigation on success
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authController.loginAndNavigate(
        context: context,
        username: _usernameController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Displays error message to user using a snackbar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Cleanup controllers when widget is disposed ( typically when leaving a page )
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: LoginFormWidget(
        formKey: _formKey,
        usernameController: _usernameController,
        passwordController: _passwordController,
        isLoading: _isLoading,
        onSubmit: _handleLogin,
      ),
    );
  }
}