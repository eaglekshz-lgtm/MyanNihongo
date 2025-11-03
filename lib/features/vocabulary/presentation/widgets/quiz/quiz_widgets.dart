import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

/// Progress header showing quiz progress
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
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $currentQuestion of $totalQuestions',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600]),
                  const SizedBox(width: 4),
                  Text(
                    '$correctAnswers',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.cancel, color: Colors.red[600]),
                  const SizedBox(width: 4),
                  Text(
                    '$wrongAnswers',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.red[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: currentQuestion / totalQuestions,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Option button for quiz answers
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

  @override
  Widget build(BuildContext context) {
    final isAnsweredAndSelected = hasAnswered && isSelected;
    final showCorrectness = hasAnswered;

    Color getBackgroundColor() {
      if (!showCorrectness) return Colors.white;
      if (isAnsweredAndSelected) {
        return isCorrect ? Colors.green[50]! : Colors.red[50]!;
      }
      return Colors.white;
    }

    Color getBorderColor() {
      if (!showCorrectness) {
        return isSelected
            ? AppTheme.primaryColor
            : Colors.grey[300]!;
      }
      if (isAnsweredAndSelected) {
        return isCorrect ? Colors.green : Colors.red;
      }
      return Colors.grey[300]!;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: !hasAnswered ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: getBorderColor(),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: getBorderColor(),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + optionIndex),
                      style: AppTheme.bodyMedium.copyWith(
                        color: getBorderColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: AppTheme.japaneseText.copyWith(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (showCorrectness && isAnsweredAndSelected)
                  Icon(
                    isCorrect
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}