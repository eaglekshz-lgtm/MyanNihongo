import 'package:flutter/material.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_theme.dart';

class NoVocabularyWarning extends StatelessWidget {
  const NoVocabularyWarning({super.key, required this.selectedLevel});

  final JLPTLevel? selectedLevel;

  @override
  Widget build(BuildContext context) {
    final levelText = selectedLevel?.code ?? 'All Levels';
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.warningColor.withValues(alpha: 0.15),
            AppTheme.warningColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.warningColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warningColor.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppTheme.warningColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'No vocabulary available for $levelText.',
                style: AppTheme.bodySmall.copyWith(
                  fontSize: 13,
                  color: AppTheme.warningColor.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
