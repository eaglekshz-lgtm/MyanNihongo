import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class VocabularyProgressHeader extends StatelessWidget {
  final int displayIndex;
  final int completedCount;
  final int totalCount;
  final String level;
  final bool highlightSuccess;
  final bool animate;
  final double? forcedProgress;

  const VocabularyProgressHeader({
    super.key,
    required this.displayIndex,
    required this.completedCount,
    required this.totalCount,
    required this.level,
    this.highlightSuccess = false,
    this.animate = false,
    this.forcedProgress,
  });

  @override
  Widget build(BuildContext context) {
    // Use displayIndex for visual progress (shows current card position)
    // This ensures progress bar updates when going back
    final progress = forcedProgress ?? (displayIndex + 1) / totalCount;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildProgressText(context), _buildLevel()],
          ),
          const SizedBox(height: 8),
          _buildProgressBar(progress),
        ],
      ),
    );
  }

  Widget _buildProgressText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: isDark ? 20 : 15,
          fontWeight: isDark ? FontWeight.w700 : FontWeight.w600,
          color: isDark
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSurface,
        ),
        children: [
          TextSpan(
            text: '${displayIndex + 1}',
            style: isDark
                ? null
                : TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
          ),
          const TextSpan(text: ' / '),
          TextSpan(text: totalCount.toString()),
        ],
      ),
    );
  }

  Widget _buildLevel() {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.12),
            width: 1.5,
          ),
        ),
        child: Text(
          level,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return TweenAnimationBuilder<double>(
      duration: animate
          ? const Duration(milliseconds: 1500)
          : const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: progress),
      curve: animate ? Curves.easeOutCubic : Curves.easeInOut,
      builder: (context, value, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: 6,
          decoration: BoxDecoration(
            color: isDark
                ? Theme.of(context).colorScheme.learningDarkSurface
                : Theme.of(context).dividerColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).colorScheme.secondary
                    : (highlightSuccess
                          ? Theme.of(context).colorScheme.success
                          : Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(3),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.6),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
