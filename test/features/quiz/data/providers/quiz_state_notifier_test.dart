import 'package:flutter_test/flutter_test.dart';
import 'package:myan_nihongo/features/quiz/data/providers/quiz_state_notifier.dart';
import 'package:myan_nihongo/features/quiz/domain/entities/quiz_question.dart';

void main() {
  const questions = [
    QuizQuestion(
      id: '1',
      question: 'Question 1',
      options: ['A', 'B', 'C', 'D'],
      correctAnswerIndex: 1,
      explanation: 'B is correct',
      vocabularyId: '101',
    ),
    QuizQuestion(
      id: '2',
      question: 'Question 2',
      options: ['A', 'B', 'C', 'D'],
      correctAnswerIndex: 0,
      explanation: 'A is correct',
      vocabularyId: '102',
    ),
  ];

  group('QuizState', () {
    test('copyWith preserves selected answer when omitted', () {
      const state = QuizState(
        currentQuestionIndex: 0,
        selectedAnswerIndex: 2,
        hasAnswered: true,
        correctAnswers: 1,
        questions: questions,
      );

      final updated = state.copyWith(correctAnswers: 2);

      expect(updated.selectedAnswerIndex, 2);
      expect(updated.correctAnswers, 2);
    });

    test('copyWith can clear selected answer explicitly', () {
      const state = QuizState(
        currentQuestionIndex: 0,
        selectedAnswerIndex: 2,
        hasAnswered: true,
        correctAnswers: 1,
        questions: questions,
      );

      final updated = state.copyWith(selectedAnswerIndex: null);

      expect(updated.selectedAnswerIndex, isNull);
    });
  });

  group('QuizStateNotifier', () {
    test('selectAnswer records correct answer once', () {
      final notifier = QuizStateNotifier(questions);

      notifier.selectAnswer(1);
      notifier.selectAnswer(0);

      expect(notifier.state.hasAnswered, isTrue);
      expect(notifier.state.selectedAnswerIndex, 1);
      expect(notifier.state.correctAnswers, 1);
    });

    test(
      'nextQuestion clears selected answer and completes after final question',
      () {
        final notifier = QuizStateNotifier(questions);

        notifier.selectAnswer(1);
        notifier.nextQuestion();

        expect(notifier.state.currentQuestionIndex, 1);
        expect(notifier.state.selectedAnswerIndex, isNull);
        expect(notifier.state.hasAnswered, isFalse);

        notifier.selectAnswer(0);
        notifier.nextQuestion();

        expect(notifier.state.isCompleted, isTrue);
        expect(notifier.state.currentQuestion, isNull);
        expect(notifier.state.correctAnswers, 2);
      },
    );
  });
}
