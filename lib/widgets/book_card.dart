import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/utils/url_utils.dart';
import 'skeleton_loaders.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final int sellingPrice;
  final int originalPrice;
  final String condition; // Like New, Good, Old
  final String tag; // BCA, B.Tech, etc.
  final String? imageUrl;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.sellingPrice,
    required this.originalPrice,
    required this.condition,
    required this.tag,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Image Placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: UrlUtils.normalizeImageUrl(imageUrl) != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: CachedNetworkImage(
                        imageUrl: UrlUtils.normalizeImageUrl(imageUrl)!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SkeletonLoader(width: double.infinity, height: double.infinity, borderRadius: 0),
                        errorWidget: (context, url, error) => Icon(Icons.menu_book, size: 50, color: theme.hintColor),
                      ),
                    )
                  : Icon(Icons.menu_book, size: 50, color: theme.hintColor),
            ),
          ),

          //Book Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Condition & Tag Badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBadge(condition, _getConditionColor(condition)),
                    Text(tag, style: TextStyle(fontSize: 10, color: theme.hintColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),

                // Title & Author
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
                const SizedBox(height: 8),

                // Prices
                Row(
                  children: [
                    const Text(
                      "₹",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF00BFA5)
                      ),
                    ),
                    Text(
                      "$sellingPrice",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF00BFA5) // Teal Primary Color
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "₹$originalPrice",
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough, // Kata hua price
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getConditionColor(String condition) {
    if (condition == "Like New") return Colors.green;
    if (condition == "Good") return Colors.orange;
    if (condition == "Old") return Colors.red;
    return Colors.grey;
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}