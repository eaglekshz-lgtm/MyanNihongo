import 'package:equatable/equatable.dart';

/// Quiz data for a vocabulary item
class QuizData extends Equatable {
  final List<QuizQuestion>? kanjiToHiragana;
  final List<QuizQuestion>? hiraganaToKanji;

  const QuizData({
    this.kanjiToHiragana,
    this.hiraganaToKanji,
  });

  @override
  List<Object?> get props => [kanjiToHiragana, hiraganaToKanji];
}

/// Individual quiz question
class QuizQuestion extends Equatable {
  final String question;
  final List<String> options;
  final String correctAnswer;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [question, options, correctAnswer];
}

class ExampleSentence extends Equatable {
  final String japanese;
  final String english;
  final String burmese;

  const ExampleSentence({
    required this.japanese,
    required this.english,
    required this.burmese,
  });

  factory ExampleSentence.fromEntity(ExampleSentence entity) {
    return ExampleSentence(
      japanese: entity.japanese,
      english: entity.english,
      burmese: entity.burmese,
    );
  }

  @override
  List<Object?> get props => [japanese, english, burmese];
}

/// Domain entity representing a vocabulary item
class VocabularyItem extends Equatable {
  final String id;
  final String burmeseWord;
  final String japaneseWord;
  final String japaneseReading;
  final String meaning;
  final String level;
  final String partOfSpeech;
  final QuizData? quizzes;
  final List<ExampleSentence>? exampleSentences;

  const VocabularyItem({
    required this.id,
    required this.burmeseWord,
    required this.japaneseWord,
    required this.japaneseReading,
    required this.meaning,
    required this.level,
    required this.partOfSpeech,
    this.quizzes,
    this.exampleSentences,
  });

  @override
  List<Object?> get props => [
        id,
        burmeseWord,
        japaneseWord,
        japaneseReading,
        meaning,
        level,
        partOfSpeech,
        quizzes,
        exampleSentences,
      ];
}
