import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../vocabulary/data/providers/vocabulary_provider.dart';
import '../../../vocabulary/data/models/vocabulary_filter.dart';

/// Sentinel value to distinguish between "not passed" and "explicitly null"
class _Undefined {
  const _Undefined();
}

const _undefined = _Undefined();

/// Quiz setup configuration state
class QuizSetupState extends Equatable {
  final JLPTLevel? selectedLevel;
  final int numberOfQuestions;
  final bool showBurmeseMeaning;
  final QuizType quizType;

  const QuizSetupState({
    this.selectedLevel,
    required this.numberOfQuestions,
    this.showBurmeseMeaning = false,
    required this.quizType,
  });

  /// Initial state factory
  factory QuizSetupState.initial() {
    return const QuizSetupState(
      selectedLevel: null,
      numberOfQuestions: 50,
      showBurmeseMeaning: false,
      quizType: QuizType.kanjiToHiragana,
    );
  }

  /// Copy with method for immutable updates
  QuizSetupState copyWith({
    Object? selectedLevel = _undefined,
    int? numberOfQuestions,
    bool? showBurmeseMeaning,
    QuizType? quizType,
  }) {
    return QuizSetupState(
      selectedLevel: selectedLevel is _Undefined
          ? this.selectedLevel
          : selectedLevel as JLPTLevel?,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      showBurmeseMeaning: showBurmeseMeaning ?? this.showBurmeseMeaning,
      quizType: quizType ?? this.quizType,
    );
  }

  @override
  List<Object?> get props => [
    selectedLevel,
    numberOfQuestions,
    showBurmeseMeaning,
    quizType,
  ];
}

/// Quiz setup state notifier
class QuizSetupNotifier extends StateNotifier<QuizSetupState> {
  QuizSetupNotifier() : super(QuizSetupState.initial());

  /// Update selected JLPT level
  void setLevel(JLPTLevel? level) {
    state = state.copyWith(selectedLevel: level);
  }

  /// Update number of questions
  void setNumberOfQuestions(int count) {
    state = state.copyWith(numberOfQuestions: count);
  }

  /// Update show Burmese meaning flag
  void setShowBurmeseMeaning(bool show) {
    state = state.copyWith(showBurmeseMeaning: show);
  }

  /// Update quiz type
  void setQuizType(QuizType type) {
    state = state.copyWith(quizType: type);
  }

  /// Adjust number of questions based on available vocabulary
  /// Returns true if adjustment was made
  bool adjustQuestionsForMaxAvailable(int maxQuestions) {
    if (maxQuestions == 0 && state.numberOfQuestions != 50) {
      state = state.copyWith(numberOfQuestions: 50);
      return true;
    } else if (maxQuestions > 0 && state.numberOfQuestions > maxQuestions) {
      state = state.copyWith(numberOfQuestions: maxQuestions);
      return true;
    }
    return false;
  }

  /// Reset to initial state
  void reset() {
    state = QuizSetupState.initial();
  }
}

/// Provider for quiz setup state
/// Using autoDispose to clean up when navigating away from setup page
final quizSetupProvider =
    StateNotifierProvider.autoDispose<QuizSetupNotifier, QuizSetupState>((ref) {
      return QuizSetupNotifier();
    });

/// Provider to fetch and cache quiz question counts for all JLPT levels at once
final quizCountsProvider = FutureProvider.autoDispose<Map<String?, int>>((
  ref,
) async {
  final repository = ref.read(vocabularyRepositoryProvider);
  final counts = <String?, int>{};
  int totalAll = 0;

  // Fetch vocabulary for each level concurrently
  final results = await Future.wait(
    JLPTLevel.values.map((level) async {
      try {
        final vocab = await repository.getVocabularyByLevelAndType(
          VocabularyFilter(level: level.code, wordType: 'all'),
        );
        final quizCount = vocab.where((item) => item.quizzes != null).length;
        return MapEntry(level.code, quizCount);
      } catch (e) {
        // Fallback for individual level failure
        return MapEntry(level.code, 0);
      }
    }),
  );

  for (final entry in results) {
    counts[entry.key] = entry.value;
    totalAll += entry.value;
  }

  // Store the total for 'All Levels' selection
  counts[null] = totalAll;
  return counts;
});
