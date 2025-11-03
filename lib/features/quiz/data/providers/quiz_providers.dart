import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/logger.dart';
import '../../../vocabulary/data/models/vocabulary_item_model.dart';
import '../../../vocabulary/data/providers/vocabulary_provider.dart';
import '../../domain/entities/quiz_question.dart';

/// Provider for quiz-enabled vocabulary items
/// Uses autoDispose to clean up when widget is disposed
final quizVocabularyProvider =
    FutureProvider.family.autoDispose<List<VocabularyItemModel>, String?>((
      ref,
      level,
    ) async {
      final allVocabulary = await ref.read(allVocabularyProvider.future);

      // Filter vocabulary items that have quiz data
      final quizVocabulary = allVocabulary
          .where((item) => item.quizzes != null)
          .toList();

      // Note: Level filtering removed as it's no longer part of the model
      // TODO: Add level filtering based on new data structure

      return quizVocabulary;
    });

/// Provider for generating quiz questions using embedded quiz data
/// Uses autoDispose to prevent memory leaks when navigating away from quiz
final quizQuestionsProvider =
    FutureProvider.family.autoDispose<List<QuizQuestion>, QuizConfig>((ref, config) async {
      // Get vocabulary items with quiz data
      final quizVocabulary = await ref.read(
        quizVocabularyProvider(config.level).future,
      );

      if (quizVocabulary.isEmpty) {
        return [];
      }

      // Shuffle and take requested number of questions
      final shuffled = List<VocabularyItemModel>.from(quizVocabulary)
        ..shuffle(Random());
      final selectedItems = shuffled.take(config.numberOfQuestions).toList();

      // Generate questions using embedded quiz data
      final questions = <QuizQuestion>[];
      for (var item in selectedItems) {
        final quizQuestion = _generateQuestionFromEmbeddedData(item);
        if (quizQuestion != null) {
          questions.add(quizQuestion);
        }
      }

      return questions;
    });

/// Generate a quiz question from embedded quiz data
QuizQuestion? _generateQuestionFromEmbeddedData(VocabularyItemModel item) {
  if (item.quizzes == null) {
    AppLogger.warning(
      'No quiz data for vocabulary item ${item.id} (${item.word})',
      'QuizProvider',
    );
    return null;
  }

  final random = Random();

  // Randomly choose between kanji_to_hiragana and hiragana_to_kanji
  final useKanjiToHiragana = random.nextBool();

  final selectedQuiz = useKanjiToHiragana
      ? item.quizzes!.kanjiToHiragana
      : item.quizzes!.hiraganaToKanji;

  // If selected quiz type is not available, try the other type
  if (selectedQuiz == null) {
    final fallbackQuiz = useKanjiToHiragana
        ? item.quizzes!.hiraganaToKanji
        : item.quizzes!.kanjiToHiragana;
    
    if (fallbackQuiz == null) {
      AppLogger.warning(
        'No quiz questions available for item ${item.id} (${item.word})',
        'QuizProvider',
      );
      return null;
    }
    
    // Use fallback quiz
    return QuizQuestion(
      id: item.id.toString(),
      question: fallbackQuiz.question,
      options: fallbackQuiz.options.keys.toList(),
      correctAnswerIndex: fallbackQuiz.options.entries
          .toList()
          .indexWhere((entry) => entry.value),
      explanation:
          '${item.translations.burmese} = ${item.word} (${item.reading})',
      vocabularyId: item.id.toString(),
    );
  }

  return QuizQuestion(
    id: item.id.toString(),
    question: selectedQuiz.question,
    options: selectedQuiz.options.keys.toList(),
    correctAnswerIndex: selectedQuiz.options.entries
        .toList()
        .indexWhere((entry) => entry.value),
    explanation:
        '${item.translations.burmese} = ${item.word} (${item.reading})',
    vocabularyId: item.id.toString(),
  );
}

/// Configuration for quiz generation
/// Uses Equatable for proper equality comparison in family providers
class QuizConfig extends Equatable {
  final int numberOfQuestions;
  final String? level;

  const QuizConfig({required this.numberOfQuestions, this.level});
  
  @override
  List<Object?> get props => [numberOfQuestions, level];
}
