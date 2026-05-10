import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/vocabulary_quiz_args.dart';
import '../../domain/models/quiz_result_args.dart';
import '../../../vocabulary/data/models/vocabulary_item_model.dart';
import '../../data/providers/vocabulary_quiz_controller.dart';
import '../widgets/vocabulary_quiz_widgets.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../../core/widgets/glass_container.dart';

/// UI Constants
const double kQuestionCardPadding = 32.0;
const double kQuestionFontSize = 54.0;
const double kTranslationFontSize = 20.0;
const double kOptionSpacing = 16.0;
const double kCardBorderRadius = 24.0;

/// Animation Durations
const Duration kCorrectAnswerDelay = Duration(seconds: 1);
const Duration kWrongAnswerDelay = Duration(seconds: 2);

class VocabularyQuizPage extends ConsumerStatefulWidget {
  const VocabularyQuizPage({super.key});

  @override
  ConsumerState<VocabularyQuizPage> createState() => _VocabularyQuizPageState();
}

class _VocabularyQuizPageState extends ConsumerState<VocabularyQuizPage> {
  bool hasPlayedCompletionSound = false;
  bool _hasNavigatedToResult = false;
  VocabularyQuizConfig? _config;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _nextQuestionTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_config == null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as VocabularyQuizArgs?;
      _config = VocabularyQuizConfig.fromArgs(args);
    }
  }

  @override
  void dispose() {
    _nextQuestionTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    if (config == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final quizAsync = ref.watch(vocabularyQuizControllerProvider(config));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          quizAsync.maybeWhen(
            data: (quizState) => _MeaningToggleButton(
              showBurmeseMeaning: quizState.showBurmeseMeaning,
              onPressed: () => ref
                  .read(vocabularyQuizControllerProvider(config).notifier)
                  .toggleMeaningLanguage(),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: MeshBackground(child: _buildQuizBody(config, quizAsync)),
    );
  }

  Widget _buildQuizBody(
    VocabularyQuizConfig config,
    AsyncValue<VocabularyQuizState> quizAsync,
  ) {
    return quizAsync.when(
      data: (quizState) => _buildQuizContent(config, quizState),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildQuizContent(
    VocabularyQuizConfig config,
    VocabularyQuizState quizState,
  ) {
    if (quizState.questions.isEmpty) {
      return const Center(
        child: Text('No quiz items available for this level'),
      );
    }

    final currentQuestion = quizState.currentQuestion;
    if (currentQuestion == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Column(
        children: [
          QuizProgressHeader(
            currentQuestion: quizState.currentQuestionIndex + 1,
            totalQuestions: quizState.totalQuestions,
            correctAnswers: quizState.correctAnswers,
            wrongAnswers: quizState.wrongAnswers,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _QuizQuestionCardNew(
                    quizData: currentQuestion.quizData,
                    vocabularyItem: currentQuestion.item,
                    showBurmeseMeaning: quizState.showBurmeseMeaning,
                  ),
                  const SizedBox(height: 32),
                  ...currentQuestion.options.asMap().entries.map((entry) {
                    final option = entry.value;
                    final isSelected = quizState.selectedAnswer == option;
                    final isCorrect = option == currentQuestion.correctAnswer;

                    return Padding(
                      key: ValueKey('option_${entry.key}_$option'),
                      padding: const EdgeInsets.only(bottom: 16),
                      child: QuizOptionButton(
                        key: ValueKey(
                          'button_${entry.key}_${isSelected}_${quizState.hasAnswered}',
                        ),
                        option: option,
                        optionIndex: entry.key,
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        hasAnswered: quizState.hasAnswered,
                        onTap: () => _selectAnswer(config, option),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAnswer(VocabularyQuizConfig config, String answer) async {
    final isCorrect = await ref
        .read(vocabularyQuizControllerProvider(config).notifier)
        .selectAnswer(answer);
    if (isCorrect == null) return;

    await _playAnswerSound(isCorrect);
    _scheduleNextQuestion(config, isCorrect);
  }

  Future<void> _playAnswerSound(bool isCorrect) async {
    try {
      final soundFile = isCorrect
          ? 'audio/correct_answer.wav'
          : 'audio/wrong_answer.wav';
      await _audioPlayer.play(AssetSource(soundFile));
    } catch (e) {
      AppLogger.warning('Audio playback error: $e', 'VocabularyQuiz');
    }
  }

  void _scheduleNextQuestion(VocabularyQuizConfig config, bool isCorrect) {
    final delay = isCorrect ? kCorrectAnswerDelay : kWrongAnswerDelay;
    _nextQuestionTimer?.cancel();
    _nextQuestionTimer = Timer(delay, () {
      if (!mounted) return;

      final isCompleted = ref
          .read(vocabularyQuizControllerProvider(config).notifier)
          .goToNextQuestion();
      if (isCompleted) _finishQuiz(config);
    });
  }

  Future<void> _finishQuiz(VocabularyQuizConfig config) async {
    if (_hasNavigatedToResult || !mounted) return;
    _hasNavigatedToResult = true;

    final quizState = ref
        .read(vocabularyQuizControllerProvider(config))
        .valueOrNull;
    if (quizState == null) return;

    if (!hasPlayedCompletionSound) {
      hasPlayedCompletionSound = true;
      await _playCompletionSound();
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      RouteNames.quizResult,
      arguments: QuizResultArgs(
        totalQuestions: quizState.totalQuestions,
        correctAnswers: quizState.correctAnswers,
        level: quizState.level,
      ),
    );
  }

  Future<void> _playCompletionSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/complete.wav'));
    } catch (e) {
      AppLogger.warning('Completion sound error: $e', 'VocabularyQuiz');
    }
  }
}

// ============================================================================
// Quiz Question Card Widget
// ============================================================================

// New quiz question card that uses embedded quiz data
class _QuizQuestionCardNew extends StatelessWidget {
  final QuizQuestionModel quizData;
  final VocabularyItemModel vocabularyItem;
  final bool showBurmeseMeaning;

  const _QuizQuestionCardNew({
    required this.quizData,
    required this.vocabularyItem,
    required this.showBurmeseMeaning,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Wrap with RepaintBoundary since this card doesn't change during answer selection
    return RepaintBoundary(
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(kQuestionCardPadding),
        borderRadius: BorderRadius.circular(kCardBorderRadius),
        tintColor: cs.vocabularyQuizQuestionTint,
        tintOpacity: cs.vocabularyQuizQuestionTintOpacity,
        borderColor: cs.vocabularyQuizQuestionBorder,
        borderWidth: 1.5,
        blur: 0.0,
        child: Column(
          children: [
            Text(
              'Choose the correct answer:',
              style: AppTheme.bodyMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              quizData.question,
              style: AppTheme.japaneseText.copyWith(
                fontSize: kQuestionFontSize,
                fontWeight: FontWeight.w800,
                color: cs.vocabularyQuizQuestionForeground,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: cs.vocabularyQuizMeaningSurface,
                borderRadius: BorderRadius.circular(20),
                border: cs.vocabularyQuizMeaningBorder,
              ),
              child: Column(
                children: [
                  // Always show Burmese
                  Text(
                    vocabularyItem.translations.burmese,
                    style: AppTheme.burmeseText.copyWith(
                      color: cs.vocabularyQuizQuestionForeground,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Show English if toggle is enabled
                  if (showBurmeseMeaning) ...[
                    const SizedBox(height: 6),
                    Text(
                      vocabularyItem.translations.english,
                      style: AppTheme.bodyLarge.copyWith(
                        color: cs.vocabularyQuizEnglishForeground,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ), // RepaintBoundary closing
    );
  }
}

class _MeaningToggleButton extends StatelessWidget {
  const _MeaningToggleButton({
    required this.showBurmeseMeaning,
    required this.onPressed,
  });

  final bool showBurmeseMeaning;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: showBurmeseMeaning
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          Icons.translate,
          color: showBurmeseMeaning
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        tooltip: showBurmeseMeaning
            ? 'Hide English (Burmese only)'
            : 'Show English translation',
        onPressed: onPressed,
      ),
    );
  }
}
