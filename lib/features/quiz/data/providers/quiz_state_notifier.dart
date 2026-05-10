import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_question.dart';

class _Unset {
  const _Unset();
}

const _unset = _Unset();

/// Quiz state model - Immutable state for the quiz
class QuizState extends Equatable {
  final int currentQuestionIndex;
  final int? selectedAnswerIndex;
  final bool hasAnswered;
  final int correctAnswers;
  final List<QuizQuestion> questions;

  const QuizState({
    required this.currentQuestionIndex,
    this.selectedAnswerIndex,
    required this.hasAnswered,
    required this.correctAnswers,
    required this.questions,
  });

  factory QuizState.initial(List<QuizQuestion> questions) {
    return QuizState(
      currentQuestionIndex: 0,
      selectedAnswerIndex: null,
      hasAnswered: false,
      correctAnswers: 0,
      questions: questions,
    );
  }

  QuizState copyWith({
    int? currentQuestionIndex,
    Object? selectedAnswerIndex = _unset,
    bool? hasAnswered,
    int? correctAnswers,
    List<QuizQuestion>? questions,
  }) {
    return QuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswerIndex: selectedAnswerIndex == _unset
          ? this.selectedAnswerIndex
          : selectedAnswerIndex as int?,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      questions: questions ?? this.questions,
    );
  }

  bool get isCompleted => currentQuestionIndex >= questions.length;

  QuizQuestion? get currentQuestion => currentQuestionIndex < questions.length
      ? questions[currentQuestionIndex]
      : null;

  @override
  List<Object?> get props => [
    currentQuestionIndex,
    selectedAnswerIndex,
    hasAnswered,
    correctAnswers,
    questions,
  ];
}

/// Quiz state notifier - Manages quiz state transitions
class QuizStateNotifier extends StateNotifier<QuizState> {
  QuizStateNotifier(List<QuizQuestion> questions)
    : super(QuizState.initial(questions));

  /// Select an answer for the current question
  void selectAnswer(int answerIndex) {
    if (state.hasAnswered || state.isCompleted) return;

    final currentQuestion = state.currentQuestion;
    if (currentQuestion == null) return;

    final isCorrect = answerIndex == currentQuestion.correctAnswerIndex;

    state = state.copyWith(
      selectedAnswerIndex: answerIndex,
      hasAnswered: true,
      correctAnswers: isCorrect
          ? state.correctAnswers + 1
          : state.correctAnswers,
    );
  }

  /// Move to the next question
  void nextQuestion() {
    if (!state.hasAnswered || state.isCompleted) return;

    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
      selectedAnswerIndex: null,
      hasAnswered: false,
    );
  }
}

/// This allows creating quiz state for different question sets
final quizStateProvider = StateNotifierProvider.autoDispose
    .family<QuizStateNotifier, QuizState, List<QuizQuestion>>((ref, questions) {
      return QuizStateNotifier(questions);
    });
