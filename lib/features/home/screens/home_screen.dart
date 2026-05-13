import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../widgets/book_card.dart';
import '../../../widgets/skeleton_loaders.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/book_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);
    final user = authProvider.user;

    // Initial load logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!bookProvider.hasFetchedBooks && !bookProvider.isLoading) {
        bookProvider.fetchAllBooks();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (user?.isSeller ?? false) 
                  ? l10n.helloSeller(user?.username ?? "") 
                  : l10n.discoverBooks(user?.username ?? ""), 
              style: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 22)
            ),
            Text(l10n.findSecondHandBooks, style: TextStyle(color: theme.hintColor, fontSize: 13)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => bookProvider.fetchAllBooks(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Search Bar
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.searchRoute),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: l10n.searchBooksHint,
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF00BFA5)),
                          filled: true,
                          fillColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Categories (Horizontal Scroll)
                  Text(l10n.categories, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 30),

                  // 📚 Study Materials Banner
                  _buildMaterialsBanner(context, l10n),
                  const SizedBox(height: 30),

                  // Recently Added Books Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.recentlyAdded, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {},
                        child: Text(l10n.viewAll, style: const TextStyle(color: Color(0xFF00BFA5))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ]),
              ),
            ),

            if (bookProvider.isLoading && bookProvider.books.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const BookCardSkeleton(),
                    childCount: 6,
                  ),
                ),
              )
            else if (bookProvider.books.isEmpty)
              SliverFillRemaining(
                child: Center(child: Text(l10n.noBooksFound)),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final book = bookProvider.books[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.bookDetailRoute, extra: book);
                        },
                        child: BookCard(
                          title: book["title"],
                          author: book["author"],
                          sellingPrice: book["sellingPrice"].toInt(),
                          originalPrice: book["originalPrice"].toInt(),
                          condition: book["condition"],
                          tag: book["tag"] ?? "Book",
                          imageUrl: (book["images"] as List).isNotEmpty ? book["images"][0] : null,
                        ),
                      );
                    },
                    childCount: bookProvider.books.length,
                  ),
                ),
              ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }


  Widget _buildMaterialsBanner(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00BFA5).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF00BFA5).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.needStudyNotes,
                  style: const TextStyle(color: Color(0xFF009688), fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.getPDFsAndNotes,
                  style: TextStyle(color: theme.hintColor, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.studyMaterialsRoute),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(l10n.browse, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
