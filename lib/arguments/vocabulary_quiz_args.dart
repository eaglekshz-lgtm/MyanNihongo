/// Arguments for VocabularyQuizPage
class VocabularyQuizArgs {
  final String level;
  final String? wordType;
  final int numberOfQuestions;
  final bool showBurmeseMeaning;
  final String quizType;

  const VocabularyQuizArgs({
    required this.level,
    this.wordType,
    required this.numberOfQuestions,
    required this.showBurmeseMeaning,
    required this.quizType,
  });
}
