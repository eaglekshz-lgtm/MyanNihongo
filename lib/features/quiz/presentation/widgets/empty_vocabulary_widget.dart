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
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the difficulty level and number of questions',
              style: AppTheme.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.neutral600,
              ),
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
                backgroundColor: Theme.of(context).colorScheme.neutral300,
                foregroundColor: Theme.of(context).colorScheme.neutral600,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'No vocabulary available',
                style: AppTheme.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.neutral600,
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
