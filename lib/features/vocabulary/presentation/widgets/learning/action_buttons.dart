import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

class LearningActionButtons extends StatelessWidget {
  final bool canGoBack;
  final bool isBookmarked;
  final VoidCallback onBack;
  final VoidCallback onBookmark;
  final VoidCallback onNext;

  const LearningActionButtons({
    super.key,
    required this.canGoBack,
    required this.isBookmarked,
    required this.onBack,
    required this.onBookmark,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA), // Brighter background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            icon: Icons.arrow_back_rounded,
            label: 'Back',
            backgroundColor: canGoBack
                ? const Color(0xFFFFEBEE)
                : const Color(0xFFF5F5F5), // Light red or grey
            foregroundColor: canGoBack
                ? const Color(0xFFD32F2F)
                : Colors.grey[400]!, // Red or grey
            borderColor: canGoBack
                ? const Color(0xFFD32F2F).withValues(alpha: 0.3)
                : Colors.grey[300]!, // Red or grey
            onPressed: canGoBack ? onBack : null,
          ),
          ActionButton(
            icon: isBookmarked ? Icons.bookmark : Icons.bookmark_add_rounded,
            label: isBookmarked ? 'Saved' : 'Save',
            backgroundColor: isBookmarked
                ? const Color(0xFFFFF3E0) // Light orange when saved
                : const Color(0xFFF5F5F5), // Light grey when not saved
            foregroundColor: isBookmarked
                ? const Color(0xFFFF9800) // Deep orange when saved
                : const Color(0xFF757575), // Grey when not saved
            borderColor: isBookmarked
                ? const Color(0xFFFF9800).withValues(alpha: 0.3) // Orange border
                : const Color(0xFFBDBDBD).withValues(alpha: 0.3), // Grey border
            onPressed: onBookmark,
            isHighlighted: true,
          ),
          ActionButton(
            icon: Icons.arrow_forward_rounded,
            label: 'Next',
            backgroundColor: const Color(0xFFE8F5E9), // Light green
            foregroundColor: const Color(0xFF43A047), // Green
            borderColor: const Color(0xFF43A047).withValues(alpha: 0.3), // Green border
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final VoidCallback? onPressed;
  final bool isHighlighted;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    this.onPressed,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: isHighlighted ? 92 : 82,
          height: isHighlighted ? 92 : 82,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isHighlighted ? 34 : 30, color: foregroundColor),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}