import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Progress header widget for vocabulary learning
class VocabularyProgressHeader extends StatelessWidget {
  final int displayIndex; // current viewing index
  final int completedCount; // number of completed cards
  final int totalCount;
  final String level;
  final bool highlightSuccess; // when true, use success styling
  final bool animate; // when true, animate progress change
  final double? forcedProgress; // override progress (0..1) when provided

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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                ? AppTheme.successColor
                : AppTheme.primaryColor,
            animate: animate,
            forcedProgress: forcedProgress,
          ),
        ],
      ),
    );
  }
}

/// Progress info row with card count and level badge
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
          ),
        ),
        _LevelBadge(level: level),
      ],
    );
  }
}

/// Level badge widget
class _LevelBadge extends StatelessWidget {
  final String level;

  const _LevelBadge({required this.level});

  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'N5':
        return const Color(0xFF4CAF50); // Green
      case 'N4':
        return const Color(0xFF2196F3); // Blue
      case 'N3':
        return const Color(0xFFFF9800); // Orange
      case 'N2':
        return const Color(0xFFE91E63); // Pink
      case 'N1':
        return const Color(0xFF9C27B0); // Purple
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor(level);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: levelColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: levelColor.withValues(alpha: 0.3),
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

/// Progress bar widget with smooth animation
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
    // Use forcedProgress when provided (e.g., animate to 100% on finish)
    final computed = totalCount == 0 ? 0.0 : (completedCount / totalCount);
    final progress = forcedProgress != null
        ? forcedProgress!.clamp(0.0, 1.0)
        : computed;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      // Animate only when explicitly requested
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
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                TweenAnimationBuilder<int>(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  // Animate percentage only when requested
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
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                          reverseCurve: Curves.easeInCubic,
                        );
                        return FadeTransition(
                          opacity: curved,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.05, 0),
                              end: Offset.zero,
                            ).animate(curved),
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.98,
                                end: 1.0,
                              ).animate(curved),
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        '$animatedPercentage%',
                        key: ValueKey<int>(animatedPercentage),
                        style: style,
                      ),
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
                color: barColor.withValues(alpha: 0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: animatedProgress,
                  backgroundColor: Colors.transparent,
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
  final int? blockNumber; // Block number if in batch mode
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
        color: AppTheme.successColor.withValues(alpha: 0.02),
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

/// Completion icon
class _CompletionIcon extends StatelessWidget {
  const _CompletionIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.successColor.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.successColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          size: 70,
          color: AppTheme.successColor,
        ),
      ),
    );
  }
}

/// Completion title
class _CompletionTitle extends StatelessWidget {
  const _CompletionTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Great Job!',
      style: AppTheme.headlineLarge.copyWith(
        color: AppTheme.successColor,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Completion message
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
      style: AppTheme.bodyLarge.copyWith(color: Colors.grey[700], height: 1.5),
      textAlign: TextAlign.center,
    );
  }
}

/// Completion action buttons
class _CompletionActions extends StatelessWidget {
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const _CompletionActions({required this.onRestart, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRestart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
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
                      color: Colors.white,
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
                side: BorderSide(color: Colors.grey[300]!, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded, size: 22, color: Colors.grey[700]),
                  const SizedBox(width: 10),
                  Text(
                    'Back to Home',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.grey[700],
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
                color: AppTheme.successColor,
                onTap: onKnow,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: _ActionButton(
              icon: Icons.close,
              label: 'Still Learning',
              color: AppTheme.warningColor,
              onTap: onDontKnow,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual action button
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
        foregroundColor: Colors.white,
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
