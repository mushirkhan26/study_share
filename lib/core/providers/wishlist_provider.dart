import 'package:flutter/material.dart';
import '../api/network/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistService _wishlistService = WishlistService();

  Set<String> _savedBookIds = {};
  List<dynamic> _savedBooks = [];
  bool _isLoading = false;
  bool _hasFetched = false;

  Set<String> get savedBookIds => _savedBookIds;
  List<dynamic> get savedBooks => _savedBooks;
  bool get isLoading => _isLoading;
  bool get hasFetched => _hasFetched;

  Future<void> checkIfSaved(String bookId) async {
    final response = await _wishlistService.checkIfSaved(bookId);
    if (response.success && response.data == true) {
      _savedBookIds.add(bookId);
      notifyListeners();
    }
  }

  Future<void> toggleWishlist(String bookId) async {
    final response = await _wishlistService.toggleWishlist(bookId);
    if (response.success && response.data != null) {
      final isSaved = response.data!['saved'] as bool;
      if (isSaved) {
        _savedBookIds.add(bookId);
      } else {
        _savedBookIds.remove(bookId);
      }
      notifyListeners();
    }
  }

  Future<void> fetchWishlist() async {
    if (!_hasFetched) {
      _isLoading = true;
      notifyListeners();
    }

    final response = await _wishlistService.getWishlist();
    if (response.success && response.data != null) {
      _savedBooks = response.data!;
      _savedBookIds = _savedBooks.map((b) => (b['id'] ?? b['_id']).toString()).toSet();
    }
    
    _hasFetched = true;
    _isLoading = false;
    notifyListeners();
  }

  bool isBookSaved(String bookId) {
    return _savedBookIds.contains(bookId);
  }
}
