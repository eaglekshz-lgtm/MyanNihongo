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
  final double swipeProgress;
  final bool isSwipingRight;
  final bool isSwiping;

  const VocabularyProgressHeader({
    super.key,
    required this.displayIndex,
    required this.completedCount,
    required this.totalCount,
    required this.level,
    this.highlightSuccess = false,
    this.animate = false,
    this.forcedProgress,
    this.swipeProgress = 0.0,
    this.isSwipingRight = false,
    this.isSwiping = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use displayIndex for visual progress (shows current card position)
    // This ensures progress bar updates when going back
    final progress = forcedProgress ?? (displayIndex + 1) / totalCount;

    return Container(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildProgressText(context), _buildLevel()],
          ),
          const SizedBox(height: 12),
          _buildProgressBar(progress),
          const SizedBox(height: 14),
          _buildDifficultyLabels(context),
        ],
      ),
    );
  }

  Widget _buildProgressText(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: colorScheme.learningProgressNumberFontSize,
          fontWeight: colorScheme.learningProgressNumberFontWeight,
          color: colorScheme.learningProgressForeground,
        ),
        children: [
          TextSpan(
            text: '${displayIndex + 1}',
            style: TextStyle(
              color: colorScheme.learningProgressCurrentForeground,
              fontSize: colorScheme.learningProgressCurrentFontSize,
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
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.learningLevelPillSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colorScheme.learningLevelPillBorder,
              width: 1.5,
            ),
          ),
          child: Text(
            level,
            style: TextStyle(
              color: colorScheme.learningLevelPillForeground,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
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
        final colorScheme = Theme.of(context).colorScheme;
        final segmentCount = totalCount < 5 ? totalCount : 5;
        final filledSegments = (value * segmentCount).ceil();

        return Row(
          children: List.generate(segmentCount, (index) {
            final isFilled = index < filledSegments;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 4.5,
                margin: EdgeInsets.only(
                  right: index == segmentCount - 1 ? 0 : 10,
                ),
                decoration: BoxDecoration(
                  color: isFilled
                      ? colorScheme.learningProgressFill(highlightSuccess)
                      : colorScheme.learningProgressTrack,
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: isFilled ? colorScheme.learningProgressGlow : null,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildDifficultyLabels(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mutedColor = cs.learningDifficultyMutedForeground;

    final hardActive = isSwiping && !isSwipingRight;
    final easyActive = isSwiping && isSwipingRight;

    return Row(
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTheme.bodyMedium.copyWith(
            color: hardActive ? cs.error : mutedColor,
            fontSize: 14,
            fontWeight: hardActive ? FontWeight.w900 : FontWeight.w700,
            letterSpacing: 1.0,
          ),
          child: const Text('‹ HARD'),
        ),
        const Spacer(),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTheme.bodyMedium.copyWith(
            color: easyActive ? cs.success : mutedColor,
            fontSize: 14,
            fontWeight: easyActive ? FontWeight.w900 : FontWeight.w700,
            letterSpacing: 1.0,
          ),
          child: const Text('EASY ›'),
        ),
      ],
    );
  }
}
