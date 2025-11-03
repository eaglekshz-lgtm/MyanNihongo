import 'package:flutter/material.dart';

class BookmarkFeedback {
  static SnackBar buildSnackBar(bool isBookmarked) {
    return SnackBar(
      content: _buildContent(isBookmarked),
      backgroundColor: isBookmarked
          ? const Color(0xFFFF9800) // Deep orange for saved
          : const Color(0xFF424242), // Dark grey for removed
      duration: const Duration(milliseconds: 2500),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 6,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  static Widget _buildContent(bool isBookmarked) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _buildIcon(isBookmarked),
          const SizedBox(width: 16),
          _buildMessage(isBookmarked),
          _buildStatusIcon(isBookmarked),
        ],
      ),
    );
  }

  static Widget _buildIcon(bool isBookmarked) {
    return Container(
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
    );
  }

  static Widget _buildMessage(bool isBookmarked) {
    return Expanded(
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
          const SizedBox(height: 2),
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
    );
  }

  static Widget _buildStatusIcon(bool isBookmarked) {
    return Icon(
      isBookmarked ? Icons.check_circle_rounded : Icons.info_outline_rounded,
      color: Colors.white.withValues(alpha: 0.9),
      size: 22,
    );
  }
}