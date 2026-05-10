import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';

class VocabularyCompletionScreen extends StatelessWidget {
  final int totalCards;
  final int? blockNumber;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const VocabularyCompletionScreen({
    super.key,
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
        ? 'You\'ve completed Set $blockNumber!\n$totalCards vocabulary cards learned.\nKeep up the excellent work!'
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
