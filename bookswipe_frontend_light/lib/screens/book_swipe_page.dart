import 'package:flutter/material.dart';
import '../models/book.dart';
import '../controllers/book_controller.dart';
import '../services/api_service.dart';
import 'dart:async';


class BookSwipePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const BookSwipePage({
    super.key,
    required this.userData,
  });

  @override
  State<BookSwipePage> createState() => _BookSwipePageState();
}

class _BookSwipePageState extends State<BookSwipePage> {
  late final BookController _bookController;
  bool _isLoading = true;
  String? _error;
  bool _showDescription = false;  // New state variable

  @override
  void initState() {
    super.initState();
    _bookController = BookController(userId: widget.userData['id']);
    _loadBooks();
  }

  Future<void> _showOverlayAnimation(BuildContext context, bool isLike) async {
    final completer = Completer<void>();
    late final OverlayEntry fadeOutOverlay; // Declare it here

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Container(
            color: (isLike ? const Color(0xFFD2691E) : const Color(0xFF8B4513)).withOpacity(0.8),
            child: Center(
              child: Icon(
                isLike ? Icons.favorite : Icons.close,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Wait for the fade in and display duration
    await Future.delayed(const Duration(milliseconds: 600));

    // Create and show fade out overlay
    fadeOutOverlay = OverlayEntry( // Initialize it here
      builder: (context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.0),
        duration: const Duration(milliseconds: 200),
        onEnd: () {
          fadeOutOverlay.remove();
          completer.complete();
        },
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Container(
            color: (isLike ? const Color(0xFFD2691E) : const Color(0xFF8B4513)).withOpacity(0.8),
            child: Center(
              child: Icon(
                isLike ? Icons.favorite : Icons.close,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    overlayEntry.remove();
    Overlay.of(context).insert(fadeOutOverlay);

    return completer.future;
  }

  Future<void> _loadBooks() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _showDescription = false;
      });

      await _bookController.fetchBooks();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading books: $e')),
      );
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: () async {
            await _showOverlayAnimation(context, false);
            if (!mounted) return;
            await _bookController.handleDislike();
            if (mounted) setState(() {});
          },
          backgroundColor: const Color(0xFF8B4513),
          child: const Icon(Icons.close),
        ),
        FloatingActionButton(
          onPressed: () async {
            await _showOverlayAnimation(context, true);
            if (!mounted) return;
            await _bookController.handleLike();
            if (mounted) setState(() {});
          },
          backgroundColor: const Color(0xFFD2691E),
          child: const Icon(Icons.favorite),
        ),
      ],
    );
  }

  Widget _buildBookCard(Book currentBook) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showDescription = !_showDescription;
        });
      },
      child: Card(
        elevation: 8,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    ApiService.getImageUrl(currentBook.coverImageUrl),
                  ),
                  fit: BoxFit.cover,
                  onError: (_, __) => const AssetImage('images/placeholder.jpg') as ImageProvider,
                ),
              ),
            ),
            if (!_showDescription) // Show original info layout
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentBook.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentBook.author,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (currentBook.genres.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: currentBook.genres.map((genre) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              genre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${currentBook.averageRating.toStringAsFixed(1)}/5.0',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.book, color: Colors.white, size: 20),
                          Text(
                            ' ${currentBook.pages} pages',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (currentBook.formats.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: currentBook.formats.map((format) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              format,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                        ),
                      Center(
                        child: Text(
                          'Tap card to view description',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            if (_showDescription) // Show description overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentBook.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'by ${currentBook.author}',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            currentBook.description ?? 'No description available.',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              height: 1.8,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Tap anywhere to close',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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
              onPressed: _loadBooks,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_bookController.books.isEmpty) {
      return const Center(
        child: Text('No recommended books available'),
      );
    }

    final currentBook = _bookController.currentBook!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Dismissible(
                key: Key(currentBook.id.toString()),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await _showOverlayAnimation(context, false);
                    if (!mounted) return;
                    await _bookController.handleDislike();
                    if (mounted) setState(() {
                      _showDescription = false;
                    });
                  } else {
                    await _showOverlayAnimation(context, true);
                    if (!mounted) return;
                    await _bookController.handleLike();
                    if (mounted) setState(() {
                      _showDescription = false;
                    });
                  }
                },
                background: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2691E).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.favorite, color: Color(0xFFD2691E), size: 40),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B4513).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.close, color: Color(0xFF8B4513), size: 40),
                    ),
                  ),
                ),
                child: _buildBookCard(currentBook),
              ),
            ),
            if (!_showDescription) ...[
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}