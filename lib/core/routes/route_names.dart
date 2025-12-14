/// Route names for the application
/// This class contains all route constants used for navigation
class RouteNames {
  // Private constructor to prevent instantiation
  RouteNames._();

  // Root routes
  static const String splash = '/';
  static const String home = '/home';

  // Vocabulary routes
  static const String levelSelection = '/level-selection';
  static const String learningModeConfig = '/learning-mode-config';
  static const String batchSelection = '/batch-selection';
  static const String vocabularyLearning = '/vocabulary-learning';
  static const String vocabularyQuiz = '/vocabulary-quiz';
  static const String bookmarkedVocabulary = '/bookmarked-vocabulary';
  static const String learningModeSelection = '/learning-mode-selection';

  // Quiz routes
  static const String quizSetup = '/quiz-setup';
  static const String quiz = '/quiz';
  static const String quizResult = '/quiz-result';

  // Multiplayer routes (moved to backup)
  // static const String multiplayerLobby = '/multiplayer-lobby';
}
