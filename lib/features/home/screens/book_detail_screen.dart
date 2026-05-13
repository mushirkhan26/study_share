import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/wishlist_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/url_utils.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? bookData;

  const BookDetailScreen({
    super.key,
    this.bookData,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int _currentPage = 0;

  String _getConditionLabel(String condition, AppLocalizations l10n) {
    switch (condition) {
      case 'Like New': return l10n.likeNew;
      case 'Good': return l10n.good;
      case 'Old': return l10n.old;
      case 'Worn Out': return l10n.wornOut;
      default: return condition;
    }
  }

  Color _getConditionColor(String condition) {
    if (condition == "Like New") return Colors.green;
    if (condition == "Good") return Colors.orange;
    if (condition == "Old") return Colors.red;
    return Colors.grey;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final String bookId = widget.bookData?['id'] ?? widget.bookData?['_id'] ?? '';
    final bool isSaved = wishlistProvider.isBookSaved(bookId);

    // Check status on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bookId.isNotEmpty && !wishlistProvider.isBookSaved(bookId)) {
        wishlistProvider.checkIfSaved(bookId);
      }
    });

    final String title = widget.bookData?['title'] ?? l10n.bookTitle;
    final String author = widget.bookData?['author'] ?? l10n.unknownAuthor;
    final int sellingPrice = (widget.bookData?['sellingPrice'] ?? 0).toInt();
    final int originalPrice = (widget.bookData?['originalPrice'] ?? 0).toInt();
    final String condition = widget.bookData?['condition'] ?? "Good";
    final String description = widget.bookData?['description'] ?? l10n.noBooksMatching;
    final String sellerName = widget.bookData?['seller']?['username'] ?? "Anonymous";
    final bool isPrivateProfile = widget.bookData?['seller']?['isPrivateProfile'] ?? false;
    final String? sellerPhone = widget.bookData?['seller']?['phoneNumber'];
    final bool showPhoneNumber = widget.bookData?['seller']?['showPhoneNumber'] ?? false;
    
    final String currentUserId = Provider.of<AuthProvider>(context, listen: false).user?.id ?? '';
    final String sellerId = widget.bookData?['seller']?['id'] ?? widget.bookData?['sellerId'] ?? '';
    final bool isMyBook = currentUserId == sellerId;
    
    final bool shouldHideDetails = isPrivateProfile && !isMyBook;
    final bool shouldShowCall = !isMyBook && sellerPhone != null && showPhoneNumber;
    
    final List<dynamic>? images = widget.bookData?['images'];
    final int imageCount = images?.length ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: theme.brightness == Brightness.dark 
                ? Colors.grey[900]?.withValues(alpha: 0.8) 
                : Colors.white.withValues(alpha: 0.8),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: theme.brightness == Brightness.dark ? Colors.white : Colors.black, size: 18),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: theme.brightness == Brightness.dark 
                  ? Colors.grey[900]?.withValues(alpha: 0.8) 
                  : Colors.white.withValues(alpha: 0.8),
              child: IconButton(
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border, 
                  color: isSaved ? Colors.red : (theme.brightness == Brightness.dark ? Colors.white : Colors.black), 
                  size: 20
                ),
                onPressed: () => wishlistProvider.toggleWishlist(bookId),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: theme.brightness == Brightness.dark 
                  ? Colors.grey[900]?.withValues(alpha: 0.8) 
                  : Colors.white.withValues(alpha: 0.8),
              child: IconButton(
                icon: Icon(Icons.share_outlined, color: theme.brightness == Brightness.dark ? Colors.white : Colors.black, size: 20),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
              ),
              child: imageCount > 0
                  ? Stack(
                      children: [
                        PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: imageCount,
                          itemBuilder: (context, index) {
                            final String? imageUrl = images![index];
                            return UrlUtils.normalizeImageUrl(imageUrl) != null
                                ? CachedNetworkImage(
                                    imageUrl: UrlUtils.normalizeImageUrl(imageUrl)!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
                                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                    ),
                                    errorWidget: (context, url, error) => Center(
                                      child: Icon(Icons.menu_book, size: 100, color: theme.hintColor),
                                    ),
                                  )
                                : Center(
                                    child: Icon(Icons.menu_book, size: 100, color: theme.hintColor),
                                  );
                          },
                        ),
                        if (imageCount > 1)
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${_currentPage + 1}/$imageCount",
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Center(
                      child: Icon(Icons.menu_book, size: 100, color: theme.hintColor),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("₹", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5))),
                          Text("$sellingPrice", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5))),
                          const SizedBox(width: 10),
                          Text("₹$originalPrice", style: TextStyle(fontSize: 16, color: theme.hintColor, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getConditionColor(condition).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getConditionColor(condition).withValues(alpha: 0.5)),
                        ),
                        child: Text(_getConditionLabel(condition, l10n), style: TextStyle(color: _getConditionColor(condition), fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 5),
                  Text("By $author", style: TextStyle(fontSize: 16, color: theme.hintColor)),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),

                  Text(l10n.description, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(description, style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color, height: 1.5)),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),

                  Text(l10n.sellerDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFF00BFA5).withValues(alpha: 0.2),
                          child: const Icon(Icons.person, color: Color(0xFF00BFA5)),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shouldHideDetails ? l10n.privateSeller : sellerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(shouldHideDetails ? l10n.identityHidden : l10n.studentSeller, style: TextStyle(color: theme.hintColor, fontSize: 13)),
                            ],
                          ),
                        ),
                        if (!shouldHideDetails) Icon(Icons.chevron_right, color: theme.hintColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isMyBook
        ? null
        : shouldHideDetails 
          ? Container(
            padding: const EdgeInsets.all(20),
            color: theme.brightness == Brightness.dark ? Colors.orange.withValues(alpha: 0.1) : Colors.amber.shade50,
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.amber),
                const SizedBox(width: 10),
                Expanded(child: Text(l10n.privateProfileRestricted, style: TextStyle(color: theme.brightness == Brightness.dark ? Colors.orange : Colors.brown, fontSize: 12))),
              ],
            ),
          )
        : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (shouldShowCall) ...[
                IconButton.filled(
                  onPressed: () => _makePhoneCall(sellerPhone),
                  icon: const Icon(Icons.phone),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 15),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(AppRoutes.chatRoute, extra: widget.bookData);
                  },
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  label: Text(l10n.chatWithSeller, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color(0xFF00BFA5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
