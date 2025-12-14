/// Application-wide constants
/// 
/// Contains all application constants including API configuration,
/// local storage settings, quiz configuration, and UI defaults.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // API Configuration (deprecated - now using Supabase)
  // Kept for reference if needed in future
  // static const String baseUrl = 'https://api.myannihongo.com'; 
  // static const String apiVersion = 'v1';
  // static const Duration apiTimeout = Duration(seconds: 30);

  // Local Storage - Hive Box Names
  static const String vocabularyBoxName = 'vocabulary_box';
  static const String userProgressBoxName = 'user_progress_box';
  static const String blockProgressBoxName = 'block_progress_box';
  static const String quizResultsBoxName = 'quiz_results_box';
  static const String appPreferencesBoxName = 'app_preferences_box';
  static const String bookmarksBoxName = 'bookmarks_box';
  static const String userStreakBoxName = 'user_streak_box';
  static const String srsCardsBoxName = 'srs_cards_box';
  static const String systemUpdateBoxName = 'system_update_box';

  // Quiz Configuration
  static const int quizOptionsCount = 4;
  static const int defaultQuestionsPerQuiz = 10;
  static const int maxQuestionsPerQuiz = 50;
  
  // JLPT Levels - Use JLPTLevel enum instead
  // Kept for backward compatibility if needed
  static const String defaultJLPTLevel = 'N5';
  static const List<String> jlptLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];
  
  // Quiz Types - Use QuizType enum instead
  static const String quizTypeKanjiToHiragana = 'kanji_to_hiragana';
  static const String quizTypeHiraganaToKanji = 'hiragana_to_kanji';

  // Difficulty Levels (for general use, not JLPT)
  static const String levelBeginner = 'beginner';
  static const String levelIntermediate = 'intermediate';
  static const String levelAdvanced = 'advanced';

  static const List<String> difficultyLevels = [
    levelBeginner,
    levelIntermediate,
    levelAdvanced,
  ];

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration swipeAnimationDuration = Duration(milliseconds: 250);
  static const double cardBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Progress Tracking
  static const int maxSeenCount = 999;
  static const int maxAnswerCount = 999;
  static const double masteryThreshold = 0.8; // 80% success rate for mastery

  // Similarity Calculation
  static const int similaritySearchLimit = 10;
  static const double semanticSimilarityThreshold = 0.7;

  // Caching
  static const Duration cacheValidityDuration = Duration(days: 7);
  static const int maxCacheSize = 10000; // Maximum number of items to cache

  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String cacheErrorMessage = 'Local storage error occurred.';
  static const String dataErrorMessage = 'Data format error occurred.';
  static const String unknownErrorMessage = 'An unexpected error occurred.';
}

/// API endpoint constants (deprecated - now using Supabase)
/// Kept for reference if needed in future
/*
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  static const String vocabulary = '/vocabulary';
  static const String vocabularyByLevel = '/vocabulary/level';
  static const String userProgress = '/user/progress';
  static const String quizQuestions = '/quiz/questions';
  static const String submitQuizResult = '/quiz/submit';
  static const String levels = '/levels';

  // Construct full URL
  static String getFullUrl(String endpoint) {
    return '${AppConstants.baseUrl}/api/${AppConstants.apiVersion}$endpoint';
  }
}
*/

/// Preference keys for local storage
class PreferenceKeys {
  // Private constructor to prevent instantiation
  PreferenceKeys._();

  static const String lastSyncDate = 'last_sync_date';
  static const String selectedLevel = 'selected_level';
  static const String userName = 'user_name';
  static const String isFirstLaunch = 'is_first_launch';
  static const String soundEnabled = 'sound_enabled';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String darkMode = 'dark_mode';
  static const String language = 'language';
}