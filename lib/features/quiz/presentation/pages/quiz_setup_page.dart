import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/vocabulary_quiz_args.dart';
import '../../data/providers/quiz_setup_provider.dart';
import '../widgets/jlpt_level_selector.dart';
import '../widgets/no_vocabulary_warning.dart';
import '../widgets/question_count_selector.dart';
import '../widgets/start_quiz_button.dart';
import '../widgets/empty_vocabulary_widget.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../../core/widgets/glass_container.dart';

class QuizSetupPage extends ConsumerWidget {
  const QuizSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch quiz setup state
    final setupState = ref.watch(quizSetupProvider);

    // Fetch vocabulary counts for all levels at the beginning
    final countsAsync = ref.watch(quizCountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Setup')),
      body: MeshBackground(
        child: countsAsync.when(
          data: (counts) {
            // Get count for the currently selected level
            final maxQuestions = counts[setupState.selectedLevel?.code] ?? 0;

            // Adjust numberOfQuestions based on available vocabulary
            // Using ref.read to avoid triggering rebuilds
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref
                  .read(quizSetupProvider.notifier)
                  .adjustQuestionsForMaxAvailable(maxQuestions);
            });

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Level selection
                        Text(
                          'JLPT Level',
                          style: AppTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        JLPTLevelSelector(
                          selectedLevel: setupState.selectedLevel,
                          onSelected: (level) {
                            ref
                                .read(quizSetupProvider.notifier)
                                .setLevel(level);
                          },
                        ),
                        const SizedBox(height: 32),

                        // Quiz Type selection
                        Text(
                          'Quiz Type',
                          style: AppTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _QuizTypeSelector(
                          selectedQuizType: setupState.quizType,
                          onChanged: (value) {
                            ref
                                .read(quizSetupProvider.notifier)
                                .setQuizType(value);
                          },
                        ),
                        const SizedBox(height: 24),

                        // Show warning if no vocabulary available
                        if (maxQuestions == 0) ...[
                          NoVocabularyWarning(
                            selectedLevel: setupState.selectedLevel,
                          ),
                        ] else ...[
                          // Number of questions
                          QuestionCountSelector(
                            initialValue: setupState.numberOfQuestions,
                            maxQuestions: maxQuestions,
                            onValueChanged: (value) {
                              ref
                                  .read(quizSetupProvider.notifier)
                                  .setNumberOfQuestions(value);
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                ),
                // Start quiz button at the bottom
                StartQuizButton(
                  isEnabled:
                      maxQuestions > 0 && setupState.numberOfQuestions > 0,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.vocabularyQuiz,
                      arguments: VocabularyQuizArgs(
                        level: setupState.selectedLevel?.code ?? 'all',
                        wordType: null,
                        numberOfQuestions: setupState.numberOfQuestions,
                        showBurmeseMeaning: setupState.showBurmeseMeaning,
                        quizType: setupState.quizType.code,
                      ),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            // Treat error same as empty vocabulary list
            AppLogger.error(
              'Vocabulary error',
              tag: 'QuizSetup',
              error: error,
              stackTrace: stack,
            );
            return EmptyVocabularyWidget(
              selectedLevel: setupState.selectedLevel,
              onLevelSelected: (level) =>
                  ref.read(quizSetupProvider.notifier).setLevel(level),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// Quiz Type Selector Widget (Stateless - just displays options)
// ============================================================================

class _QuizTypeSelector extends StatelessWidget {
  const _QuizTypeSelector({
    required this.selectedQuizType,
    required this.onChanged,
  });

  final QuizType selectedQuizType;
  final ValueChanged<QuizType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuizTypeOptionCard(
          quizType: QuizType.kanjiToHiragana,
          groupValue: selectedQuizType,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        _QuizTypeOptionCard(
          quizType: QuizType.hiraganaToKanji,
          groupValue: selectedQuizType,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ============================================================================
// Quiz Type Option Card (Optimized)
// ============================================================================

class _QuizTypeOptionCard extends StatelessWidget {
  const _QuizTypeOptionCard({
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
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        blur: 15.0,
        tintColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.fixedWhite,
        tintOpacity: isSelected ? 0.18 : 0.06,
        borderRadius: BorderRadius.circular(16),
        borderColor: isSelected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.55)
            : Theme.of(context).colorScheme.fixedWhite.withValues(alpha: 0.12),
        borderWidth: isSelected ? 2 : 1,
        shadow: isSelected,
        child: Row(
          children: [
            Radio<QuizType>(
              value: quizType,
              groupValue: groupValue,
              onChanged: (value) => value != null ? onChanged(value) : null,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quizType.description,
                    style: AppTheme.bodySmall.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
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
