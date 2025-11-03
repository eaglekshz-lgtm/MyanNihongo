import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../domain/models/vocabulary_quiz_args.dart';
import '../../domain/models/quiz_result_args.dart';
import '../../../vocabulary/data/models/vocabulary_item_model.dart';
import '../../../vocabulary/data/providers/vocabulary_provider.dart';
import '../../../vocabulary/data/models/vocabulary_filter.dart';
import '../widgets/quiz_widgets.dart';

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
  String? _wordType;
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
  final Map<int, List<String>> _shuffledOptionsCache = {}; // Cache shuffled options per question
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_level == null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as VocabularyQuizArgs?;
      _level = args?.level ?? kDefaultLevel;
      _wordType = args?.wordType;
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
    final vocabularyAsync = ref.watch(
      vocabularyByLevelAndTypeProvider(
        VocabularyFilter(level: _level ?? 'N5', wordType: _wordType ?? 'all'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          // Toggle between Burmese only and Burmese + English
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _showBurmeseMeaning == true
                  ? AppTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                Icons.translate,
                color: _showBurmeseMeaning == true
                    ? AppTheme.primaryColor
                    : Colors.grey[600],
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
      body: vocabularyAsync.when(
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
          final shuffledOptions = _getShuffledOptions(currentQuestionIndex, optionsList);
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
                              onTap: () => _selectAnswer(option, correctAnswer),
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

  void _updateQuizState(String answer, bool isCorrect, VocabularyItemModel question) {
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
  static const _cardGradientColors = [AppTheme.primaryColor, AppTheme.primaryVariant];
  static const _shadowColor = AppTheme.primaryColor;

  final QuizQuestionModel quizData;
  final VocabularyItemModel vocabularyItem;
  final bool showBurmeseMeaning;

  const _QuizQuestionCardNew({
    required this.quizData,
    required this.vocabularyItem,
    required this.showBurmeseMeaning,
  });

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _cardGradientColors,
      ),
      borderRadius: BorderRadius.circular(kCardBorderRadius),
      boxShadow: [
        BoxShadow(
          color: _shadowColor.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Choose the correct answer:',
      style: AppTheme.bodyMedium.copyWith(
        color: Colors.white.withValues(alpha: 0.9),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildQuestionText(String question) {
    return Text(
      question,
      style: AppTheme.japaneseText.copyWith(
        fontSize: kQuestionFontSize,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  BoxDecoration _buildTranslationBoxDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with RepaintBoundary since this card doesn't change during answer selection
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kQuestionCardPadding),
        decoration: _buildCardDecoration(),
        child: Column(
          children: [
            _buildInstructionText(),
            const SizedBox(height: 24),
            _buildQuestionText(quizData.question),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: _buildTranslationBoxDecoration(),
              child: Column(
                children: [
                  // Always show Burmese
                  Text(
                    vocabularyItem.translations.burmese,
                    style: AppTheme.burmeseText.copyWith(
                      color: Colors.white,
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
                        color: Colors.white.withValues(alpha: 0.9),
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
