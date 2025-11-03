import 'package:equatable/equatable.dart';

/// Quiz result entity
class QuizResult extends Equatable {
  final String id;
  final DateTime completedAt;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final double score;
  final String level;
  final Duration timeTaken;

  const QuizResult({
    required this.id,
    required this.completedAt,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.score,
    required this.level,
    required this.timeTaken,
  });

  @override
  List<Object?> get props => [
        id,
        completedAt,
        totalQuestions,
        correctAnswers,
        incorrectAnswers,
        score,
        level,
        timeTaken,
      ];
}
