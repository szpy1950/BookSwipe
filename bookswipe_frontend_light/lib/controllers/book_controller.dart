// lib/controllers/book_controller.dart
import '../services/api_service.dart';
import '../models/book.dart';

// Controller that manages book recommendations and user interactions (likes/dislike)
class BookController {
  final int userId;
  final ApiService _api = ApiService();
  List<Book> _books = [];
  int _currentIndex = 0;

  // Creates controller instance with user ID for tracking preferences
  BookController({required this.userId});

  // Getter methods to access current books and selected book
  List<Book> get books => _books;
  int get currentIndex => _currentIndex;
  Book? get currentBook => _books.isNotEmpty ? _books[_currentIndex] : null;

  // Fetches recommended books, falls back to regular books if none found
  Future<void> fetchBooks() async {
    try {
      // Always try to get recommended books first
      _books = await _api.fetchRecommendedBooks();

      if (_books.isNotEmpty) {
        print('First recommended book details:');
        print('Title: ${_books[0].title}');
        print('Description: ${_books[0].description}');
      }

      // Only fall back to regular books if recommendations are empty
      if (_books.isEmpty) {
        print('No recommendations found, falling back to regular books');
        _books = await _api.fetchBooks();
      }

      _currentIndex = 0;
    } catch (e) {
      print('Error in fetchBooks: $e');
      // If recommended books fail, try regular books
      try {
        _books = await _api.fetchBooks();
        _currentIndex = 0;
      } catch (fallbackError) {
        print('Error in fallback fetchBooks: $fallbackError');
        throw Exception('Failed to fetch any books: $fallbackError');
      }
    }
  }

  // Records user's like for current book and advances to next book
  Future<void> handleLike() async {
    if (currentBook != null) {
      try {
        print('Attempting to like book ${currentBook!.id} for user $userId');
        await _api.likeBook(currentBook!.id, userId);
        print('Successfully liked book');

        // Move to next book or fetch new ones
        // if (_currentIndex < _books.length - 1) {
        //   _currentIndex++;
        // } else {
        //   await fetchBooks();
        // }
        await fetchBooks();
      } catch (e) {
        print('Error liking book: $e');
        throw Exception('Failed to like book: $e');
      }
    }
  }

  // Records user's dislike for current book and advances to next book
  Future<void> handleDislike() async {
    if (currentBook != null) {
      try {
        await _api.dislikeBook(currentBook!.id, userId);

        // if (_currentIndex < _books.length - 1) {
        //   _currentIndex++;
        // } else {
        //   await fetchBooks();
        // }
        await fetchBooks();
      } catch (e) {
        print('Error disliking book: $e');
        throw Exception('Failed to dislike book: $e');
      }
    }
  }

}