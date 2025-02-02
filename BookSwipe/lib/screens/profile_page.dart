import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({
    super.key,
    required this.userData,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileController = ProfileController();
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _likedBooks = [];

  // Available preferences (all possible options)
  Map<String, List<String>> _availablePreferences = {
    'Genres': [],
    'Languages': [],
    'Book Length': [],
    'Formats': [],
    'Authors': []
  };

  // Selected preferences (which ones are checked)
  Map<String, Set<String>> _selectedPreferences = {
    'Genres': {},
    'Languages': {},
    'Book Length': {},
    'Formats': {},
    'Authors': {}
  };

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch available preferences
      final availablePrefs = await _profileController.fetchAvailablePreferences();
      // Fetch user preferences
      final userPrefs = await _profileController.fetchUserPreferences(widget.userData['id']);
      // Fetch liked books - make sure we pass the correct user ID
      final likedBooks = await _profileController.getUserLikedBooks(widget.userData['id']);

      setState(() {
        _availablePreferences = availablePrefs;
        _selectedPreferences = userPrefs;
        _likedBooks = likedBooks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildUserHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            widget.userData['username'] ?? 'Unknown User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.userData['fname'] != null || widget.userData['lname'] != null)
            Text(
              '${widget.userData['fname'] ?? ''} ${widget.userData['lname'] ?? ''}'.trim(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildLikedBooksSection() {
    if (_likedBooks.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Liked Books',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Center(child: Text('No liked books yet')),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Liked Books',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _likedBooks.length,
            itemBuilder: (context, index) {
              final book = _likedBooks[index];
              return ListTile(
                leading: book['cover_image_url'] != null
                    ? Image.network(
                  book['cover_image_url'],
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.book),
                )
                    : const Icon(Icons.book),
                title: Text(book['title'] ?? 'Unknown Title'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book['author'] ?? 'Unknown Author'),
                    if (book['genres'] != null)
                      Text(
                        List<String>.from(book['genres']).join(', '),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                trailing: book['average_rating'] != null
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(book['average_rating'].toString()),
                  ],
                )
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Reading Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ..._availablePreferences.entries.map((entry) {
            final categoryTitle = entry.key;
            final options = entry.value;

            if (options.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: options.map((option) => FilterChip(
                      label: Text(option),
                      selected: _selectedPreferences[categoryTitle]?.contains(option) ?? false,
                      onSelected: (bool selected) => _handlePreferenceChange(
                        categoryTitle,
                        option,
                        selected,
                      ),
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    )).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _handlePreferenceChange(
      String category,
      String option,
      bool selected,
      ) async {
    final previousSelections = Set<String>.from(_selectedPreferences[category] ?? {});

    setState(() {
      if (selected) {
        _selectedPreferences[category] ??= {};
        _selectedPreferences[category]!.add(option);
      } else {
        _selectedPreferences[category]?.remove(option);
      }
    });

    try {
      final updatedPrefs = _selectedPreferences.map(
            (key, value) => MapEntry(key, value.toList()),
      );

      await _profileController.updatePreferences(
        userId: widget.userData['id'],
        preferences: updatedPrefs,
      );
    } catch (e) {
      setState(() => _selectedPreferences[category] = previousSelections);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating preferences: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadAllData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildUserHeader(),
          _buildLikedBooksSection(),
          _buildPreferencesSection(),
          const SizedBox(height: 16), // Bottom padding
        ],
      ),
    );
  }
}