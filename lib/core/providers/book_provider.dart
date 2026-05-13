import 'dart:io';
import 'package:flutter/material.dart';
import '../api/network/book_service.dart';

class BookProvider extends ChangeNotifier {
  final BookService _bookService = BookService();

  List<dynamic> _books = [];
  List<dynamic> _myBooks = [];
  bool _isLoading = false;
  bool _hasFetchedBooks = false;
  bool _hasFetchedMyBooks = false;

  List<dynamic> get books => _books;
  List<dynamic> get myBooks => _myBooks;
  bool get isLoading => _isLoading;
  bool get hasFetchedBooks => _hasFetchedBooks;
  bool get hasFetchedMyBooks => _hasFetchedMyBooks;

  Future<void> fetchAllBooks({String? search, String? tag}) async {
    // Only show loading if we don't have any books or if it's a search/filter change
    if (!_hasFetchedBooks || search != null || tag != null) {
      _isLoading = true;
      notifyListeners();
    }

    final response = await _bookService.getAllBooks(search: search, tag: tag);
    if (response.success && response.data != null) {
      _books = response.data!;
    }
    
    _hasFetchedBooks = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyBooks() async {
    if (!_hasFetchedMyBooks) {
      _isLoading = true;
      notifyListeners();
    }

    final response = await _bookService.getMyAds();
    if (response.success && response.data != null) {
      _myBooks = response.data!;
    }

    _hasFetchedMyBooks = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> uploadBook({
    required String title,
    required String author,
    required double sellingPrice,
    required double originalPrice,
    required String condition,
    required String tag,
    String? description,
    required List<File> imageFiles,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await _bookService.uploadBook(
      title: title,
      author: author,
      sellingPrice: sellingPrice,
      originalPrice: originalPrice,
      condition: condition,
      tag: tag,
      description: description,
      imageFiles: imageFiles,
    );

    _isLoading = false;
    notifyListeners();
    
    if (response.success) {
      fetchAllBooks();
      return true;
    }
    return false;
  }

  Future<bool> deleteBook(String bookId) async {
    final response = await _bookService.deleteBook(bookId);
    if (response.success) {
      _myBooks.removeWhere((book) => (book['id'] ?? book['_id']) == bookId);
      _books.removeWhere((book) => (book['id'] ?? book['_id']) == bookId);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateBookStatus(String bookId, bool isSold) async {
    final response = await _bookService.updateBookStatus(bookId, isSold);
    if (response.success) {
      final index = _myBooks.indexWhere((book) => (book['id'] ?? book['_id']) == bookId);
      if (index != -1) {
        _myBooks[index]['isSold'] = isSold;
        notifyListeners();
      }
      return true;
    }
    return false;
  }
}
