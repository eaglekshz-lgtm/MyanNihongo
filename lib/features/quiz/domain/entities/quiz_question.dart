import 'package:equatable/equatable.dart';

/// Quiz question entity
class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String vocabularyId;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.vocabularyId,
  });

  @override
  List<Object?> get props => [
        id,
        question,
        options,
        correctAnswerIndex,
        explanation,
        vocabularyId,
      ];
}
