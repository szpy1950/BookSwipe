import 'package:flutter/material.dart';
import '../models/book.dart';
import '../controllers/book_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _bookController = BookController(userId: widget.userData['id']);
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
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

  Widget _buildBookImage(Book book) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: book.coverImageUrl.isNotEmpty &&
          !book.coverImageUrl.startsWith('https://example.com') // Skip example URLs
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          book.coverImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(book);
          },
        ),
      )
          : _buildPlaceholder(book),
    );
  }

  Widget _buildPlaceholder(Book book) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookDetails(Book book) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber),
        Text(
          ' ${book.averageRating.toStringAsFixed(1)}/5.0',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.book, color: Colors.blue),
        Text(
          ' ${book.pages} pages',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: () async {
            await _bookController.handleDislike();
            if (mounted) setState(() {});
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.close),
        ),
        FloatingActionButton(
          onPressed: () async {
            await _bookController.handleLike();
            if (mounted) setState(() {});
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.favorite),
        ),
      ],
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
                    await _bookController.handleDislike();
                    if (mounted) setState(() {});
                  } else {
                    await _bookController.handleLike();
                    if (mounted) setState(() {});
                  }
                },
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.favorite, color: Colors.green, size: 40),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.close, color: Colors.red, size: 40),
                    ),
                  ),
                ),
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildBookImage(currentBook),
                        ),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  currentBook.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currentBook.author,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (currentBook.genres.isNotEmpty)
                                  Wrap(
                                    spacing: 4,
                                    children: currentBook.genres.map((genre) => Chip(
                                      label: Text(genre),
                                      backgroundColor: Colors.blue[100],
                                    )).toList(),
                                  ),
                                const SizedBox(height: 8),
                                _buildBookDetails(currentBook),
                                const SizedBox(height: 8),
                                if (currentBook.formats.isNotEmpty)
                                  Wrap(
                                    spacing: 4,
                                    children: currentBook.formats.map((format) => Chip(
                                      label: Text(format),
                                      backgroundColor: Colors.green[100],
                                    )).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}