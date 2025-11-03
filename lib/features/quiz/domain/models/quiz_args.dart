import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_args.freezed.dart';

/// Arguments for QuizPage
///
/// Basic configuration for a generic quiz session.
@freezed
class QuizArgs with _$QuizArgs {
  const factory QuizArgs({
    /// Optional JLPT level filter
    String? level,
    
    /// Number of questions to include in quiz
    required int numberOfQuestions,
  }) = _QuizArgs;

  const QuizArgs._();

  /// Create with default values
  factory QuizArgs.defaults({String? level}) {
    return QuizArgs(
      level: level,
      numberOfQuestions: 10,
    );
  }
}
