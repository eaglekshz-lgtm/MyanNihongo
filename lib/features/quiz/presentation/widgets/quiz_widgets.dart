import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
        _QuizScore(
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
        ),
      ],
    );
  }
}

/// Quiz score display
class _QuizScore extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;

  const _QuizScore({
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: AppTheme.successColor, size: 20),
        const SizedBox(width: 4),
        Text(
          '$correctAnswers',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.successColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.cancel, color: AppTheme.errorColor, size: 20),
        const SizedBox(width: 4),
        Text(
          '$wrongAnswers',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.errorColor,
            fontWeight: FontWeight.bold,
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
    return LinearProgressIndicator(
      value: currentQuestion / totalQuestions,
      backgroundColor: Colors.grey[300],
      valueColor: const AlwaysStoppedAnimation<Color>(
        AppTheme.primaryColor,
      ),
    );
  }
}

/// Quiz question card
class QuizQuestionCard extends StatelessWidget {
  final String japanese;
  final String? romanization;
  final bool showRomanization;

  const QuizQuestionCard({
    super.key,
    required this.japanese,
    this.romanization,
    this.showRomanization = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'What does this mean?',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            japanese,
            style: AppTheme.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          if (showRomanization && romanization != null) ...[
            const SizedBox(height: 8),
            Text(
              romanization!,
              style: AppTheme.bodyLarge.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
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

  Color _getBackgroundColor() {
    if (!hasAnswered) {
      return isSelected
          ? AppTheme.primaryColor.withValues(alpha: 0.1)
          : Colors.white;
    }
    if (isCorrect) {
      return AppTheme.successColor.withValues(alpha: 0.1);
    }
    if (isSelected) {
      return AppTheme.errorColor.withValues(alpha: 0.1);
    }
    return Colors.white;
  }

  Color _getBorderColor() {
    if (!hasAnswered) {
      return isSelected ? AppTheme.primaryColor : Colors.grey[300]!;
    }
    if (isCorrect) {
      return AppTheme.successColor;
    }
    if (isSelected) {
      return AppTheme.errorColor;
    }
    return Colors.grey[300]!;
  }

  IconData? _getIcon() {
    if (!hasAnswered) return null;
    if (isCorrect) return Icons.check_circle;
    if (isSelected) return Icons.cancel;
    return null;
  }

  Color? _getIconColor() {
    if (!hasAnswered) return null;
    if (isCorrect) return AppTheme.successColor;
    if (isSelected) return AppTheme.errorColor;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon();
    final iconColor = _getIconColor();

    final optionPrefix = String.fromCharCode(65 + optionIndex); // A, B, C, D
    Color textColor = Colors.black;
    if (hasAnswered) {
      if (isCorrect) {
        textColor = _getBorderColor();
      } else if (isSelected) {
        textColor = AppTheme.errorColor;
      }
    }
    // Wrap with RepaintBoundary to isolate repaints to this widget only
    return RepaintBoundary(
      child: InkWell(
        onTap: hasAnswered ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getBorderColor(),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$optionPrefix. $option',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ) 
                else
                  Icon(
                  Icons.circle_outlined,
                  color: Colors.grey[500]!,
                  size: 28,
                ) 
            ],
          ),
        ),
      ),
    );
  }
}

/// Quiz result screen
class QuizResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const QuizResultScreen({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.onRetry,
    required this.onExit,
  });

  double get _percentage => (correctAnswers / totalQuestions) * 100;
  int get _wrongAnswers => totalQuestions - correctAnswers;

  String get _message {
    if (_percentage >= 90) return 'Excellent! 🎉';
    if (_percentage >= 70) return 'Great Job! 👏';
    if (_percentage >= 50) return 'Good Effort! 💪';
    return 'Keep Practicing! 📚';
  }

  Color get _color {
    if (_percentage >= 70) return AppTheme.successColor;
    if (_percentage >= 50) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ResultIcon(color: _color),
            const SizedBox(height: 32),
            _ResultTitle(message: _message),
            const SizedBox(height: 16),
            _ResultScore(
              correctAnswers: correctAnswers,
              wrongAnswers: _wrongAnswers,
              percentage: _percentage,
            ),
            const SizedBox(height: 48),
            _ResultActions(
              onRetry: onRetry,
              onExit: onExit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Result icon
class _ResultIcon extends StatelessWidget {
  final Color color;

  const _ResultIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.emoji_events,
        size: 80,
        color: color,
      ),
    );
  }
}

/// Result title
class _ResultTitle extends StatelessWidget {
  final String message;

  const _ResultTitle({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: AppTheme.headlineLarge.copyWith(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Result score display
class _ResultScore extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final double percentage;

  const _ResultScore({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: AppTheme.headlineLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontSize: 48,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ScoreStat(
                  icon: Icons.check_circle,
                  label: 'Correct',
                  value: '$correctAnswers',
                  color: AppTheme.successColor,
                ),
                _ScoreStat(
                  icon: Icons.cancel,
                  label: 'Wrong',
                  value: '$wrongAnswers',
                  color: AppTheme.errorColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Score stat item
class _ScoreStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ScoreStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.headlineMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// Result action buttons
class _ResultActions extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const _ResultActions({
    required this.onRetry,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.replay),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onExit,
            icon: const Icon(Icons.home),
            label: const Text('Back to Home'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
