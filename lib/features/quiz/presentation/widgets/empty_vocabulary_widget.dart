import 'package:flutter/material.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_theme.dart';
import 'jlpt_level_selector.dart';
import 'no_vocabulary_warning.dart';

class EmptyVocabularyWidget extends StatelessWidget {
  const EmptyVocabularyWidget({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  final JLPTLevel? selectedLevel;
  final ValueChanged<JLPTLevel?> onLevelSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Configure Your Quiz',
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the difficulty level and number of questions',
              style: AppTheme.bodyMedium.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            Text(
              'JLPT Level',
              style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            JLPTLevelSelector(
              selectedLevel: selectedLevel,
              onSelected: onLevelSelected,
            ),
            const SizedBox(height: 32),
            NoVocabularyWarning(selectedLevel: selectedLevel),
            const Spacer(),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'No vocabulary available',
                style: AppTheme.titleMedium.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
