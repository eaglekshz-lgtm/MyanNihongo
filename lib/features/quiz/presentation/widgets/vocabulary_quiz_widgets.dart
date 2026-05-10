import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';

/// Quiz progress header widget
class QuizProgressHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;

  const QuizProgressHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _QuizInfo(
            currentQuestion: currentQuestion,
            totalQuestions: totalQuestions,
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers,
          ),
          const SizedBox(height: 8),
          _QuizProgressBar(
            currentQuestion: currentQuestion,
            totalQuestions: totalQuestions,
          ),
        ],
      ),
    );
  }
}

/// Quiz info row
class _QuizInfo extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;

  const _QuizInfo({
    required this.currentQuestion,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Question $currentQuestion of $totalQuestions',
          style: AppTheme.bodyMedium,
        ),
        _QuizScore(correctAnswers: correctAnswers, wrongAnswers: wrongAnswers),
      ],
    );
  }
}

/// Quiz score display
class _QuizScore extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;

  const _QuizScore({required this.correctAnswers, required this.wrongAnswers});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.success.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.success,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$correctAnswers',
                style: AppTheme.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.error,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$wrongAnswers',
                style: AppTheme.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Quiz progress bar
class _QuizProgressBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;

  const _QuizProgressBar({
    required this.currentQuestion,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        minHeight: 6,
        value: currentQuestion / totalQuestions,
        backgroundColor: cs.quizProgressTrack,
        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
      ),
    );
  }
}

/// Quiz option button
/// Optimized quiz option button with RepaintBoundary for better performance
class QuizOptionButton extends StatelessWidget {
  final String option;
  final int optionIndex;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback onTap;

  const QuizOptionButton({
    super.key,
    required this.option,
    required this.optionIndex,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    required this.onTap,
  });

  IconData? _getIcon() {
    if (!hasAnswered) return null;
    if (isCorrect) return Icons.check_circle;
    if (isSelected) return Icons.cancel;
    return null;
  }

  Color? _getIconColor(BuildContext context) {
    if (!hasAnswered) return null;
    if (isCorrect) return Theme.of(context).colorScheme.success;
    if (isSelected) return Theme.of(context).colorScheme.error;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon();
    final iconColor = _getIconColor(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final usesLetterCircle = cs.usesQuizOptionLetterCircle;

    final optionPrefix = String.fromCharCode(65 + optionIndex); // A, B, C, D
    final textColor = cs.quizOptionText(
      hasAnswered: hasAnswered,
      isCorrect: isCorrect,
      isSelected: isSelected,
    );

    // Wrap with RepaintBoundary to isolate repaints to this widget only
    return RepaintBoundary(
      child: InkWell(
        onTap: hasAnswered ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassContainer(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          blur: 0.0,
          tintColor: cs.quizOptionTint(
            hasAnswered: hasAnswered,
            isCorrect: isCorrect,
            isSelected: isSelected,
          ),
          tintOpacity: cs.quizOptionTintOpacity(
            hasAnswered: hasAnswered,
            isCorrect: isCorrect,
            isSelected: isSelected,
          ),
          borderColor: theme.quizOptionBorder(
            hasAnswered: hasAnswered,
            isCorrect: isCorrect,
            isSelected: isSelected,
          ),
          borderWidth: 2,
          borderRadius: BorderRadius.circular(16),
          shadow: false,
          child: Row(
            children: [
              if (usesLetterCircle) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cs.quizOptionLetterCircleSurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cs.quizOptionLetterCircleBorder(
                        hasAnswered: hasAnswered,
                        isCorrect: isCorrect,
                        isSelected: isSelected,
                      ),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    optionPrefix,
                    style: AppTheme.bodyMedium.copyWith(
                      color: cs.quizOptionLetter(
                        hasAnswered: hasAnswered,
                        isCorrect: isCorrect,
                        isSelected: isSelected,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  usesLetterCircle ? option : '$optionPrefix. $option',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (icon != null)
                Icon(icon, color: iconColor, size: cs.quizOptionIconSize)
              else
                Icon(
                  Icons.circle_outlined,
                  color: cs.quizOptionIdleIcon,
                  size: cs.quizOptionIconSize,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
