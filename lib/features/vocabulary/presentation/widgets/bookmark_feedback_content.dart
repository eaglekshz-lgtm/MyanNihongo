import 'package:flutter/material.dart';

class BookmarkFeedbackContent extends StatelessWidget {
  final bool isBookmarked;

  const BookmarkFeedbackContent({super.key, required this.isBookmarked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isBookmarked ? 'Saved!' : 'Removed',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                isBookmarked
                    ? 'Word added to your bookmarks'
                    : 'Word removed from bookmarks',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Icon(
          isBookmarked ? Icons.check_circle_rounded : Icons.info_outline_rounded,
          color: Colors.white.withValues(alpha: 0.9),
          size: 22,
        ),
      ],
    );
  }
}