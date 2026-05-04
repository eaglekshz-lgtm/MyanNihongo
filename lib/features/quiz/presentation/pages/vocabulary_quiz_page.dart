import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../domain/models/vocabulary_quiz_args.dart';
import '../../domain/models/quiz_result_args.dart';
import '../../../vocabulary/data/models/vocabulary_item_model.dart';
import '../../../vocabulary/data/providers/vocabulary_provider.dart';
import '../../data/providers/quiz_providers.dart';
import '../widgets/quiz_widgets.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../../core/widgets/glass_container.dart';

/// Quiz Types
const String kKanjiToHiraganaQuizType = 'kanji_to_hiragana';
const String kHiraganaToKanjiQuizType = 'hiragana_to_kanji';

/// Default Quiz Values
const String kDefaultLevel = 'N5';
const int kDefaultQuestionCount = 10;
const bool kDefaultShowBurmeseMeaning = false;

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
  String? _level;
  int? _numberOfQuestions;
  bool? _showBurmeseMeaning;
  String? _quizType;

  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  String? selectedAnswer;
  bool hasAnswered = false;
  bool hasPlayedCompletionSound = false;
  List<VocabularyItemModel> quizItems = [];
  final Map<int, List<String>> _shuffledOptionsCache =
      {}; // Cache shuffled options per question
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_level == null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as VocabularyQuizArgs?;
      _level = args?.level ?? kDefaultLevel;
      _numberOfQuestions = args?.numberOfQuestions ?? kDefaultQuestionCount;
      _showBurmeseMeaning =
          args?.showBurmeseMeaning ?? kDefaultShowBurmeseMeaning;
      _quizType = args?.quizType ?? kKanjiToHiraganaQuizType;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Get embedded quiz data from vocabulary item
  QuizQuestionModel? _getCurrentQuizData(VocabularyItemModel item) {
    if (item.quizzes == null) return null;

    final useKanjiToHiragana = _quizType == kKanjiToHiraganaQuizType;
    final primaryQuiz = useKanjiToHiragana
        ? item.quizzes!.kanjiToHiragana
        : item.quizzes!.hiraganaToKanji;
    final fallbackQuiz = useKanjiToHiragana
        ? item.quizzes!.hiraganaToKanji
        : item.quizzes!.kanjiToHiragana;

    return primaryQuiz ?? fallbackQuiz;
  }

  /// Get shuffled options for the current question (cached to avoid rebuilds)
  List<String> _getShuffledOptions(int questionIndex, List<String> options) {
    // Return cached shuffled options if available
    if (_shuffledOptionsCache.containsKey(questionIndex)) {
      return _shuffledOptionsCache[questionIndex]!;
    }

    // Create and cache shuffled options
    final shuffledOptions = List<String>.from(options);
    shuffledOptions.shuffle();
    _shuffledOptionsCache[questionIndex] = shuffledOptions;

    return shuffledOptions;
  }

  @override
  Widget build(BuildContext context) {
    final vocabularyAsync = ref.watch(quizVocabularyProvider(_level));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          // Toggle between Burmese only and Burmese + English
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _showBurmeseMeaning == true
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                Icons.translate,
                color: _showBurmeseMeaning == true
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              tooltip: _showBurmeseMeaning == true
                  ? 'Hide English (Burmese only)'
                  : 'Show English translation',
              onPressed: () {
                setState(() {
                  _showBurmeseMeaning = !(_showBurmeseMeaning ?? false);
                });
              },
            ),
          ),
        ],
      ),
      body: MeshBackground(
        child: vocabularyAsync.when(
          data: (vocabulary) {
            // Filter vocabulary items that have quiz data
            final quizEnabledVocabulary = vocabulary
                .where(
                  (item) =>
                      (item.quizzes != null) &&
                      (item.word.isNotEmpty && item.reading.isNotEmpty),
                )
                .toList();

            if (quizEnabledVocabulary.isEmpty) {
              return const Center(
                child: Text('No quiz items available for this level'),
              );
            }

            // Initialize quiz items on first load
            if (quizItems.isEmpty) {
              final shuffled = List<VocabularyItemModel>.from(
                quizEnabledVocabulary,
              )..shuffle();
              // Take only the specified number of questions, or all if less available
              final questionsToTake = (_numberOfQuestions ?? 10).clamp(
                1,
                quizEnabledVocabulary.length,
              );
              quizItems = shuffled.take(questionsToTake).toList();
            }

            if (currentQuestionIndex >= quizItems.length) {
              // Navigate to result page (no unnecessary setState)
              if (!hasPlayedCompletionSound) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    hasPlayedCompletionSound =
                        true; // Direct assignment, no rebuild
                    _playCompletionSound();

                    Navigator.pushReplacementNamed(
                      context,
                      RouteNames.quizResult,
                      arguments: QuizResultArgs(
                        totalQuestions: quizItems.length,
                        correctAnswers: correctAnswers,
                        level: _level,
                      ),
                    );
                  }
                });
              }
              return const Center(child: CircularProgressIndicator());
            }

            final currentQuestion = quizItems[currentQuestionIndex];
            final currentQuizData = _getCurrentQuizData(currentQuestion);

            if (currentQuizData == null) {
              // Skip to next question if quiz data is missing
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    currentQuestionIndex++;
                  });
                }
              });
              return const Center(child: CircularProgressIndicator());
            }

            // Get shuffled options for current question (cached, no rebuild)
            // Extract all options from the map (both correct and incorrect)
            final optionsList = currentQuizData.options.keys.toList();
            final shuffledOptions = _getShuffledOptions(
              currentQuestionIndex,
              optionsList,
            );
            // Find the correct answer (the one with value true)
            final correctAnswer = currentQuizData.options.entries
                .firstWhere((entry) => entry.value)
                .key;

            return SafeArea(
              child: Column(
                children: [
                  // Progress header
                  QuizProgressHeader(
                    currentQuestion: currentQuestionIndex + 1,
                    totalQuestions: quizItems.length,
                    correctAnswers: correctAnswers,
                    wrongAnswers: wrongAnswers,
                  ),

                  // Question and options
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Question card
                          _QuizQuestionCardNew(
                            quizData: currentQuizData,
                            vocabularyItem: currentQuestion,
                            showBurmeseMeaning: _showBurmeseMeaning ?? false,
                          ),
                          const SizedBox(height: 32),
                          // Answer options (using shuffled options with keys for optimization)
                          ...shuffledOptions.asMap().entries.map((entry) {
                            final option = entry.value;
                            final isSelected = selectedAnswer == option;
                            final isCorrect = option == correctAnswer;

                            return Padding(
                              key: ValueKey('option_${entry.key}_$option'),
                              padding: const EdgeInsets.only(bottom: 16),
                              child: QuizOptionButton(
                                key: ValueKey(
                                  'button_${entry.key}_${isSelected}_$hasAnswered',
                                ),
                                option: option,
                                optionIndex: entry.key,
                                isSelected: isSelected,
                                isCorrect: isCorrect,
                                hasAnswered: hasAnswered,
                                onTap: () =>
                                    _selectAnswer(option, correctAnswer),
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
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  void _selectAnswer(String answer, String correctAnswer) async {
    if (hasAnswered) return; // Prevent multiple answers

    final currentQuestion = quizItems[currentQuestionIndex];
    final isCorrect = answer == correctAnswer;

    _updateQuizState(answer, isCorrect, currentQuestion);
    await _playAnswerSound(isCorrect);
    _scheduleNextQuestion(isCorrect);
  }

  void _updateQuizState(
    String answer,
    bool isCorrect,
    VocabularyItemModel question,
  ) {
    setState(() {
      selectedAnswer = answer;
      hasAnswered = true;

      if (isCorrect) {
        correctAnswers++;
      } else {
        wrongAnswers++;
      }
      _saveProgress(question, isCorrect);
    });
  }

  Future<void> _playAnswerSound(bool isCorrect) async {
    try {
      final soundFile = isCorrect
          ? 'audio/correct_answer.wav'
          : 'audio/wrong_answer.wav';
      await _audioPlayer.play(AssetSource(soundFile));
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  void _scheduleNextQuestion(bool isCorrect) {
    final delay = isCorrect ? kCorrectAnswerDelay : kWrongAnswerDelay;
    Future.delayed(delay, () {
      if (mounted) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswer = null;
          hasAnswered = false;
        });
      }
    });
  }

  Future<void> _playCompletionSound() async {
    try {
      debugPrint('Playing quiz completion sound');
      await _audioPlayer.play(AssetSource('audio/complete.wav'));
    } catch (e) {
      debugPrint('Completion sound error: $e');
    }
  }

  Future<void> _saveProgress(VocabularyItemModel item, bool isCorrect) async {
    // Use repository method instead of direct data source access
    final repository = ref.read(vocabularyRepositoryProvider);

    await repository.updateUserProgress(item.id.toString(), isCorrect);

    // Invalidate user progress provider to trigger UI updates if needed
    ref.invalidate(userProgressProvider(item.id.toString()));
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
    // Wrap with RepaintBoundary since this card doesn't change during answer selection
    return RepaintBoundary(
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(kQuestionCardPadding),
        borderRadius: BorderRadius.circular(kCardBorderRadius),
        tintColor: Theme.of(context).colorScheme.primary,
        tintOpacity: 0.18,
        borderColor: Theme.of(
          context,
        ).colorScheme.fixedWhite.withValues(alpha: 0.22),
        borderWidth: 1.5,
        blur: 20.0,
        child: Column(
          children: [
            Text(
              'Choose the correct answer:',
              style: AppTheme.bodyMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              quizData.question,
              style: AppTheme.japaneseText.copyWith(
                fontSize: kQuestionFontSize,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Always show Burmese
                  Text(
                    vocabularyItem.translations.burmese,
                    style: AppTheme.burmeseText.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
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
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.8),
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
