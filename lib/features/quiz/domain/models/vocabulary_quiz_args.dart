import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_quiz_args.freezed.dart';

/// Arguments for VocabularyQuizPage
///
/// Defines the configuration for a vocabulary quiz session including
/// difficulty level, number of questions, and quiz type.
@freezed
class VocabularyQuizArgs with _$VocabularyQuizArgs {
  const factory VocabularyQuizArgs({
    /// JLPT level (N5, N4, N3, N2, N1)
    required String level,
    
    /// Optional word type filter (noun, verb, adjective, etc.)
    String? wordType,
    
    /// Number of questions in the quiz (must be positive)
    required int numberOfQuestions,
    
    /// Whether to show Burmese meaning during quiz
    required bool showBurmeseMeaning,
    
    /// Quiz type (kanji_to_hiragana or hiragana_to_kanji)
    required String quizType,
  }) = _VocabularyQuizArgs;
}
