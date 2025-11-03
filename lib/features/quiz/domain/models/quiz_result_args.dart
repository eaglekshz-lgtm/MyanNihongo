import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_result_args.freezed.dart';

/// Arguments for QuizResultPage
///
/// Contains the results of a completed quiz session including
/// score and metadata.
@freezed
class QuizResultArgs with _$QuizResultArgs {
  const factory QuizResultArgs({
    /// Total number of questions in the quiz
    required int totalQuestions,
    
    /// Number of questions answered correctly
    required int correctAnswers,
    
    /// Optional JLPT level of the quiz
    String? level,
  }) = _QuizResultArgs;

  const QuizResultArgs._();

  /// Calculate percentage score
  double get percentage => (correctAnswers / totalQuestions) * 100;

  /// Get number of wrong answers
  int get wrongAnswers => totalQuestions - correctAnswers;

  /// Check if quiz was passed (70% or higher)
  bool get isPassed => percentage >= 70;

  /// Get performance level
  String get performanceLevel {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 70) return 'Good';
    if (percentage >= 50) return 'Fair';
    return 'Needs Improvement';
  }
}
