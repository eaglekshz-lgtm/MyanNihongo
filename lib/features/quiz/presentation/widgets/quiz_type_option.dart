import 'package:flutter/material.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_theme.dart';

class QuizTypeOption extends StatelessWidget {
  const QuizTypeOption({
    super.key,
    required this.quizType,
    required this.groupValue,
    required this.onChanged,
  });

  final QuizType quizType;
  final QuizType groupValue;
  final ValueChanged<QuizType> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = quizType == groupValue;

    final icon = quizType == QuizType.kanjiToHiragana
        ? Icons.text_fields_rounded
        : Icons.translate_rounded;

    return InkWell(
      onTap: () => onChanged(quizType),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<QuizType>(
              value: quizType,
              groupValue: groupValue,
              onChanged: (value) => value != null ? onChanged(value) : null,
              activeColor: AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withValues(alpha: 0.15)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quizType.displayName,
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quizType.description,
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
