import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Progress header widget for vocabulary learning
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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Theme.of(context).colorScheme.outlineVariant
              : Theme.of(context).colorScheme.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.fixedBlack.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProgressInfo(
            displayIndex: displayIndex,
            totalCount: totalCount,
            level: level,
          ),
          const SizedBox(height: 14),
          _ProgressBar(
            completedCount: completedCount,
            totalCount: totalCount,
            barColor: highlightSuccess
                ? Theme.of(context).colorScheme.success
                : cs.primary,
            animate: animate,
            forcedProgress: forcedProgress,
          ),
        ],
      ),
    );
  }
}

class _ProgressInfo extends StatelessWidget {
  final int displayIndex;
  final int totalCount;
  final String level;

  const _ProgressInfo({
    required this.displayIndex,
    required this.totalCount,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Card ${displayIndex + 1} of $totalCount',
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        _LevelBadge(level: level),
      ],
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String level;
  const _LevelBadge({required this.level});

  Color _getLevelColor(BuildContext context, String level) {
    switch (level.toUpperCase()) {
      case 'N5':
        return Theme.of(context).colorScheme.jlptN5;
      case 'N4':
        return Theme.of(context).colorScheme.jlptN4;
      case 'N3':
        return Theme.of(context).colorScheme.jlptN3;
      case 'N2':
        return Theme.of(context).colorScheme.jlptN2;
      case 'N1':
        return Theme.of(context).colorScheme.jlptN1;
      default:
        return Theme.of(context).colorScheme.jlptN4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor(context, level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: levelColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: levelColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_rounded, size: 16, color: levelColor),
          const SizedBox(width: 6),
          Text(
            level.toUpperCase(),
            style: AppTheme.bodyMedium.copyWith(
              color: levelColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final Color barColor;
  final bool animate;
  final double? forcedProgress;

  const _ProgressBar({
    required this.completedCount,
    required this.totalCount,
    required this.barColor,
    this.animate = false,
    this.forcedProgress,
  });

  @override
  Widget build(BuildContext context) {
    final computed = totalCount == 0 ? 0.0 : (completedCount / totalCount);
    final progress = forcedProgress != null
        ? forcedProgress!.clamp(0.0, 1.0)
        : computed;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      tween: animate
          ? Tween<double>(begin: computed, end: progress)
          : Tween<double>(begin: progress, end: progress),
      builder: (context, animatedProgress, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: AppTheme.bodySmall.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                TweenAnimationBuilder<int>(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  tween: IntTween(
                    begin: animate
                        ? (computed * 100).toInt()
                        : (progress * 100).toInt(),
                    end: (progress * 100).toInt(),
                  ),
                  builder: (context, animatedPercentage, child) {
                    final bool isFull = animatedPercentage >= 100;
                    final style = AppTheme.bodySmall.copyWith(
                      color: barColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      shadows: isFull
                          ? [
                              Shadow(
                                color: barColor.withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    );
                    return Text(
                      '$animatedPercentage%',
                      key: ValueKey<int>(animatedPercentage),
                      style: style,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: barColor.withValues(alpha: 0.12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: animatedProgress,
                  backgroundColor: Theme.of(context).colorScheme.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Completion screen widget
class VocabularyCompletionScreen extends StatelessWidget {
  final String level;
  final int totalCards;
  final int? blockNumber;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const VocabularyCompletionScreen({
    super.key,
    required this.level,
    required this.totalCards,
    this.blockNumber,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _CompletionIcon(),
              const SizedBox(height: 32),
              const _CompletionTitle(),
              const SizedBox(height: 16),
              _CompletionMessage(
                totalCards: totalCards,
                blockNumber: blockNumber,
              ),
              const SizedBox(height: 48),
              _CompletionActions(onRestart: onRestart, onExit: onExit),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionIcon extends StatelessWidget {
  const _CompletionIcon();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final successColor = Theme.of(context).colorScheme.success;
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: cs.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: successColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: successColor.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: successColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_circle_rounded, size: 70, color: successColor),
      ),
    );
  }
}

class _CompletionTitle extends StatelessWidget {
  const _CompletionTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Great Job!',
      style: AppTheme.headlineLarge.copyWith(
        color: Theme.of(context).colorScheme.success,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _CompletionMessage extends StatelessWidget {
  final int totalCards;
  final int? blockNumber;
  const _CompletionMessage({required this.totalCards, this.blockNumber});

  @override
  Widget build(BuildContext context) {
    final message = blockNumber != null
        ? 'You\'ve completed Block $blockNumber!\n$totalCards vocabulary cards learned.\nKeep up the excellent work!'
        : 'You\'ve completed all $totalCards vocabulary cards!\nKeep up the excellent work!';

    return Text(
      message,
      style: AppTheme.bodyLarge.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _CompletionActions extends StatelessWidget {
  final VoidCallback onRestart;
  final VoidCallback onExit;
  const _CompletionActions({required this.onRestart, required this.onExit});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRestart,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_rounded, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Practice Again',
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onExit,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: BorderSide(color: cs.outline, width: 1.5),
                foregroundColor: cs.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_rounded,
                    size: 22,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Back to Home',
                    style: AppTheme.bodyLarge.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Action buttons for vocabulary cards
class VocabularyActionButtons extends StatelessWidget {
  final bool showKnowButton;
  final VoidCallback? onKnow;
  final VoidCallback? onDontKnow;

  const VocabularyActionButtons({
    super.key,
    this.showKnowButton = true,
    this.onKnow,
    this.onDontKnow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (showKnowButton) ...[
            Expanded(
              child: _ActionButton(
                icon: Icons.check,
                label: 'I Know This',
                color: Theme.of(context).colorScheme.success,
                onTap: onKnow,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: _ActionButton(
              icon: Icons.close,
              label: 'Still Learning',
              color: Theme.of(context).colorScheme.warning,
              onTap: onDontKnow,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Theme.of(context).colorScheme.fixedWhite,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.fixedWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
