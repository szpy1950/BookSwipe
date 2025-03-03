import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'book_swipe_page.dart';
import 'profile_page.dart';

// Main screen shown after login - contains bottom navigation between book swipe and profile views
class MainScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const MainScreen({
    super.key,
    required this.userData,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _authController = AuthController();  // Added this line
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  // Initialize pages array with book swipe and profile pages
  @override
  void initState() {
    super.initState();
    _pages = [
      BookSwipePage(userData: widget.userData),  // Pass userData here
      ProfilePage(userData: widget.userData),
    ];
  }
  // Updates selected tab index when user taps bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Shows logout confirmation dialog and handles logout if confirmed
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);  // Close dialog
                await _authController.logout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Builds main screen with app bar, bottom navigation and current page content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookSwipe'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}