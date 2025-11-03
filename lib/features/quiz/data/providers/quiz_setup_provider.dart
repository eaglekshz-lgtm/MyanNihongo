import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

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
    JLPTLevel? selectedLevel,
    int? numberOfQuestions,
    bool? showBurmeseMeaning,
    QuizType? quizType,
  }) {
    return QuizSetupState(
      selectedLevel: selectedLevel ?? this.selectedLevel,
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
