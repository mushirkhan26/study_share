import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/book_card.dart';
import '../../../widgets/skeleton_loaders.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/book_provider.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final ValueNotifier<String> _selectedCourse = ValueNotifier<String>('All');
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>('');
  final TimerContainer _timerContainer = TimerContainer();

  final List<String> _courses = const ['All', 'BCA', 'B.Tech', 'B.Sc', 'BA', 'B.Com', 'Novels', 'Other'];

  String _getCourseLabel(String course, AppLocalizations l10n) {
    switch (course) {
      case 'All': return l10n.all;
      case 'BCA': return l10n.bca;
      case 'B.Tech': return l10n.btech;
      case 'B.Sc': return l10n.bsc;
      case 'BA': return l10n.ba;
      case 'B.Com': return l10n.bcom;
      case 'Novels': return l10n.novels;
      case 'Other': return l10n.other;
      default: return course;
    }
  }

  void _onSearchChanged(BuildContext context, String query) {
    if (_timerContainer.timer?.isActive ?? false) _timerContainer.timer?.cancel();
    _timerContainer.timer = Timer(const Duration(milliseconds: 500), () {
      _searchQuery.value = query;
      Provider.of<BookProvider>(context, listen: false).fetchAllBooks(
        search: query,
        tag: _selectedCourse.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bookProvider = Provider.of<BookProvider>(context);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bookProvider.books.isEmpty && !bookProvider.isLoading) {
        bookProvider.fetchAllBooks();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(l10n.searchBooks, style: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          ValueListenableBuilder<String>(
            valueListenable: _searchQuery,
            builder: (context, query, child) {
              return ValueListenableBuilder<String>(
                valueListenable: _selectedCourse,
                builder: (context, course, child) {
                  if (course != 'All' || query.isNotEmpty) {
                    return IconButton(
                      icon: const Icon(Icons.filter_alt_off_outlined, color: Color(0xFF00BFA5)),
                      onPressed: () {
                        _selectedCourse.value = 'All';
                        _searchQuery.value = '';
                        bookProvider.fetchAllBooks();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }
              );
            }
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (v) => _onSearchChanged(context, v),
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                hintStyle: TextStyle(color: theme.hintColor),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF00BFA5)),
                filled: true,
                fillColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(l10n.courseCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ValueListenableBuilder<String>(
                valueListenable: _selectedCourse,
                builder: (context, currentCourse, child) {
                  return Row(
                    children: _courses.map((course) => _buildFilterChip(
                      label: _getCourseLabel(course, l10n),
                      isSelected: currentCourse == course,
                      onTap: () {
                        _selectedCourse.value = course;
                        bookProvider.fetchAllBooks(
                          search: _searchQuery.value,
                          tag: course,
                        );
                      },
                      theme: theme,
                    )).toList(),
                  );
                }
              ),
            ),

            const SizedBox(height: 25),
            Text(
              bookProvider.isLoading ? l10n.searching : l10n.resultsFound(bookProvider.books.length), 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.hintColor)
            ),
            const SizedBox(height: 15),

            Expanded(
              child: bookProvider.isLoading && bookProvider.books.isEmpty
                ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const BookCardSkeleton(),
                  )
                : bookProvider.books.isEmpty 
                  ? _buildEmptyResults(theme, l10n)
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: bookProvider.books.length,
                      itemBuilder: (context, index) {
                        final book = bookProvider.books[index];
                        return GestureDetector(
                          onTap: () => context.push(AppRoutes.bookDetailRoute, extra: book),
                          child: BookCard(
                            title: book['title'],
                            author: book['author'],
                            sellingPrice: book['sellingPrice'].toInt(),
                            originalPrice: book['originalPrice'].toInt(),
                            condition: book['condition'],
                            tag: book['tag'] ?? "Book",
                            imageUrl: (book['images'] as List).isNotEmpty ? book['images'][0] : null,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResults(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: theme.dividerColor),
          const SizedBox(height: 15),
          Text(l10n.noBooksMatching, style: TextStyle(color: theme.hintColor, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected, required VoidCallback onTap, required ThemeData theme}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00BFA5) : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF00BFA5) : theme.dividerColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class TimerContainer {
  Timer? timer;
}
