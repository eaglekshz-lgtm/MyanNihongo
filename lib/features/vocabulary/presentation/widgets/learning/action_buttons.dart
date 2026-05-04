import 'dart:ui';
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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: isDark
                ? Theme.of(context).colorScheme.surfaceContainerHigh
                : Theme.of(
                    context,
                  ).colorScheme.fixedWhite.withValues(alpha: 0.80),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Theme.of(
                        context,
                      ).colorScheme.fixedWhite.withValues(alpha: 0.08)
                    : Theme.of(
                        context,
                      ).colorScheme.fixedBlack.withValues(alpha: 0.05),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                icon: Icons.arrow_back_rounded,
                label: 'Back',
                backgroundColor: canGoBack
                    ? cs.errorMuted
                    : (isDark
                          ? cs.surfaceContainerHighest
                          : Theme.of(context).colorScheme.neutral100),
                foregroundColor: canGoBack
                    ? cs.error
                    : (isDark
                          ? cs.onSurface.withValues(alpha: 0.3)
                          : Theme.of(context).colorScheme.neutral400),
                borderColor: canGoBack
                    ? cs.error.withValues(alpha: 0.3)
                    : (isDark
                          ? cs.outline.withValues(alpha: 0.2)
                          : Theme.of(context).colorScheme.neutral300),
                onPressed: canGoBack ? onBack : null,
              ),
              ActionButton(
                icon: isBookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_add_rounded,
                label: isBookmarked ? 'Saved' : 'Save',
                backgroundColor: isBookmarked
                    ? cs.warningMuted
                    : (isDark
                          ? cs.surfaceContainerHighest
                          : Theme.of(context).colorScheme.neutral100),
                foregroundColor: isBookmarked
                    ? cs.warning
                    : (isDark
                          ? cs.onSurface.withValues(alpha: 0.5)
                          : Theme.of(context).colorScheme.neutral600),
                borderColor: isBookmarked
                    ? cs.warning.withValues(alpha: 0.3)
                    : (isDark
                          ? cs.outline.withValues(alpha: 0.2)
                          : Theme.of(
                              context,
                            ).colorScheme.neutral400.withValues(alpha: 0.3)),
                onPressed: onBookmark,
                isHighlighted: true,
              ),
              ActionButton(
                icon: Icons.arrow_forward_rounded,
                label: 'Next',
                backgroundColor: cs.successMuted,
                foregroundColor: cs.success,
                borderColor: cs.success.withValues(alpha: 0.3),
                onPressed: onNext,
              ),
            ],
          ),
        ),
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
