import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../vocabulary/data/models/vocabulary_item_model.dart';
import '../../../vocabulary/data/providers/vocabulary_provider.dart';
import '../../domain/models/vocabulary_quiz_args.dart';
import 'quiz_providers.dart';

const String kKanjiToHiraganaQuizType = 'kanji_to_hiragana';
const String kHiraganaToKanjiQuizType = 'hiragana_to_kanji';
const String kDefaultVocabularyQuizLevel = 'N5';
const int kDefaultVocabularyQuizQuestionCount = 10;
const bool kDefaultShowBurmeseMeaning = false;

class VocabularyQuizConfig extends Equatable {
  const VocabularyQuizConfig({
    required this.level,
    required this.numberOfQuestions,
    required this.showBurmeseMeaning,
    required this.quizType,
  });

  factory VocabularyQuizConfig.fromArgs(VocabularyQuizArgs? args) {
    return VocabularyQuizConfig(
      level: args?.level ?? kDefaultVocabularyQuizLevel,
      numberOfQuestions:
          args?.numberOfQuestions ?? kDefaultVocabularyQuizQuestionCount,
      showBurmeseMeaning:
          args?.showBurmeseMeaning ?? kDefaultShowBurmeseMeaning,
      quizType: args?.quizType ?? kKanjiToHiraganaQuizType,
    );
  }

  final String level;
  final int numberOfQuestions;
  final bool showBurmeseMeaning;
  final String quizType;

  @override
  List<Object?> get props => [
    level,
    numberOfQuestions,
    showBurmeseMeaning,
    quizType,
  ];
}

class VocabularyQuizQuestion extends Equatable {
  const VocabularyQuizQuestion({
    required this.item,
    required this.quizData,
    required this.options,
    required this.correctAnswer,
  });

  final VocabularyItemModel item;
  final QuizQuestionModel quizData;
  final List<String> options;
  final String correctAnswer;

  @override
  List<Object?> get props => [item, quizData, options, correctAnswer];
}

class VocabularyQuizState extends Equatable {
  const VocabularyQuizState({
    required this.level,
    required this.quizType,
    required this.showBurmeseMeaning,
    required this.questions,
    required this.currentQuestionIndex,
    required this.correctAnswers,
    required this.wrongAnswers,
    this.selectedAnswer,
    required this.hasAnswered,
  });

  factory VocabularyQuizState.initial(VocabularyQuizConfig config) {
    return VocabularyQuizState(
      level: config.level,
      quizType: config.quizType,
      showBurmeseMeaning: config.showBurmeseMeaning,
      questions: const [],
      currentQuestionIndex: 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      hasAnswered: false,
    );
  }

  final String level;
  final String quizType;
  final bool showBurmeseMeaning;
  final List<VocabularyQuizQuestion> questions;
  final int currentQuestionIndex;
  final int correctAnswers;
  final int wrongAnswers;
  final String? selectedAnswer;
  final bool hasAnswered;

  int get totalQuestions => questions.length;
  bool get isCompleted => currentQuestionIndex >= questions.length;
  VocabularyQuizQuestion? get currentQuestion =>
      isCompleted ? null : questions[currentQuestionIndex];

  VocabularyQuizState copyWith({
    bool? showBurmeseMeaning,
    List<VocabularyQuizQuestion>? questions,
    int? currentQuestionIndex,
    int? correctAnswers,
    int? wrongAnswers,
    String? selectedAnswer,
    bool clearSelectedAnswer = false,
    bool? hasAnswered,
  }) {
    return VocabularyQuizState(
      level: level,
      quizType: quizType,
      showBurmeseMeaning: showBurmeseMeaning ?? this.showBurmeseMeaning,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      selectedAnswer: clearSelectedAnswer
          ? null
          : selectedAnswer ?? this.selectedAnswer,
      hasAnswered: hasAnswered ?? this.hasAnswered,
    );
  }

  @override
  List<Object?> get props => [
    level,
    quizType,
    showBurmeseMeaning,
    questions,
    currentQuestionIndex,
    correctAnswers,
    wrongAnswers,
    selectedAnswer,
    hasAnswered,
  ];
}

final vocabularyQuizControllerProvider = StateNotifierProvider.autoDispose
    .family<
      VocabularyQuizController,
      AsyncValue<VocabularyQuizState>,
      VocabularyQuizConfig
    >((ref, config) {
      return VocabularyQuizController(ref, config);
    });

class VocabularyQuizController
    extends StateNotifier<AsyncValue<VocabularyQuizState>> {
  VocabularyQuizController(this._ref, this._config)
    : super(const AsyncValue.loading()) {
    _loadQuiz();
  }

  final Ref _ref;
  final VocabularyQuizConfig _config;

  Future<void> _loadQuiz() async {
    try {
      final vocabulary = await _ref.read(
        quizVocabularyProvider(_config.level).future,
      );
      final questions = _buildQuestions(vocabulary);

      state = AsyncValue.data(
        VocabularyQuizState.initial(_config).copyWith(questions: questions),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  List<VocabularyQuizQuestion> _buildQuestions(
    List<VocabularyItemModel> vocabulary,
  ) {
    final selectedQuestions = <VocabularyQuizQuestion>[];
    final random = Random();
    var validQuestionCount = 0;

    for (final item in vocabulary) {
      final quizData = _getQuizData(item);
      final correctAnswer = _getCorrectAnswer(quizData);

      if (quizData == null ||
          correctAnswer == null ||
          item.word.isEmpty ||
          item.reading.isEmpty) {
        continue;
      }

      final options = quizData.options.keys.toList()..shuffle(random);
      final question = VocabularyQuizQuestion(
        item: item,
        quizData: quizData,
        options: options,
        correctAnswer: correctAnswer,
      );

      validQuestionCount++;
      if (selectedQuestions.length < _config.numberOfQuestions) {
        selectedQuestions.add(question);
      } else {
        final replacementIndex = random.nextInt(validQuestionCount);
        if (replacementIndex < selectedQuestions.length) {
          selectedQuestions[replacementIndex] = question;
        }
      }
    }

    selectedQuestions.shuffle(random);
    return selectedQuestions;
  }

  QuizQuestionModel? _getQuizData(VocabularyItemModel item) {
    final quizzes = item.quizzes;
    if (quizzes == null) return null;

    final useKanjiToHiragana = _config.quizType == kKanjiToHiraganaQuizType;
    final primaryQuiz = useKanjiToHiragana
        ? quizzes.kanjiToHiragana
        : quizzes.hiraganaToKanji;
    final fallbackQuiz = useKanjiToHiragana
        ? quizzes.hiraganaToKanji
        : quizzes.kanjiToHiragana;

    return primaryQuiz ?? fallbackQuiz;
  }

  String? _getCorrectAnswer(QuizQuestionModel? quizData) {
    if (quizData == null || quizData.options.isEmpty) return null;

    for (final entry in quizData.options.entries) {
      if (entry.value) return entry.key;
    }

    return null;
  }

  void toggleMeaningLanguage() {
    state = state.whenData(
      (value) => value.copyWith(showBurmeseMeaning: !value.showBurmeseMeaning),
    );
  }

  Future<bool?> selectAnswer(String answer) async {
    final currentState = state.valueOrNull;
    if (currentState == null ||
        currentState.hasAnswered ||
        currentState.isCompleted) {
      return null;
    }

    final currentQuestion = currentState.currentQuestion;
    if (currentQuestion == null) return null;

    final isCorrect = answer == currentQuestion.correctAnswer;
    state = AsyncValue.data(
      currentState.copyWith(
        selectedAnswer: answer,
        hasAnswered: true,
        correctAnswers: isCorrect
            ? currentState.correctAnswers + 1
            : currentState.correctAnswers,
        wrongAnswers: isCorrect
            ? currentState.wrongAnswers
            : currentState.wrongAnswers + 1,
      ),
    );

    await _saveProgress(currentQuestion.item, isCorrect);
    return isCorrect;
  }

  bool goToNextQuestion() {
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.hasAnswered) return false;

    final nextIndex = currentState.currentQuestionIndex + 1;
    state = AsyncValue.data(
      currentState.copyWith(
        currentQuestionIndex: nextIndex,
        clearSelectedAnswer: true,
        hasAnswered: false,
      ),
    );

    return nextIndex >= currentState.questions.length;
  }

  Future<void> _saveProgress(VocabularyItemModel item, bool isCorrect) async {
    try {
      final repository = _ref.read(vocabularyRepositoryProvider);
      await repository.updateUserProgress(item.id.toString(), isCorrect);
      _ref.invalidate(userProgressProvider(item.id.toString()));
    } catch (e) {
      AppLogger.warning('Progress save error: $e', 'VocabularyQuiz');
    }
  }
}
