/// Arguments for QuizResultPage
class QuizResultArgs {
  final int totalQuestions;
  final int correctAnswers;
  final String? level;

  const QuizResultArgs({
    required this.totalQuestions,
    required this.correctAnswers,
    this.level,
  });
}
