import 'package:flutter/material.dart';
import 'route_names.dart';
import '../../features/vocabulary/presentation/pages/home_page.dart';
import '../../features/vocabulary/presentation/pages/level_selection_page.dart';
import '../../features/vocabulary/presentation/pages/category_selection_page.dart';
import '../../features/vocabulary/presentation/pages/learning_mode_config_page.dart';
import '../../features/vocabulary/presentation/pages/batch_selection_page.dart';
import '../../features/vocabulary/presentation/pages/vocabulary_learning_page.dart';
import '../../features/vocabulary/presentation/pages/bookmarked_vocabulary_page.dart';
import '../../features/vocabulary/presentation/pages/learning_mode_selection_page.dart';
import '../../features/quiz/presentation/pages/quiz_setup_page.dart';
import '../../features/quiz/presentation/pages/quiz_page.dart';
import '../../features/quiz/presentation/pages/quiz_result_page.dart';
import '../../features/quiz/presentation/pages/vocabulary_quiz_page.dart';

/// App routes configuration
/// Handles route generation for named navigation
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  /// Generate routes based on route settings
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return _buildRoute(const HomePage(), settings);

      case RouteNames.levelSelection:
        return _buildRoute(const LevelSelectionPage(), settings);

      case RouteNames.categorySelection:
        return _buildRoute(
          const CategorySelectionPage(),
          settings,
        );

      case RouteNames.learningModeConfig:
        return _buildRoute(
          const LearningModeConfigPage(),
          settings,
        );

      case RouteNames.batchSelection:
        return _buildRoute(
          const BatchSelectionPage(),
          settings,
        );

      case RouteNames.vocabularyLearning:
        return _buildRoute(
          const VocabularyLearningPage(),
          settings,
        );

      case RouteNames.vocabularyQuiz:
        return _buildRoute(
          const VocabularyQuizPage(),
          settings,
        );

      case RouteNames.bookmarkedVocabulary:
        return _buildRoute(const BookmarkedVocabularyPage(), settings);

      case RouteNames.learningModeSelection:
        return _buildRoute(
          const LearningModeSelectionPage(),
          settings,
        );

      case RouteNames.quizSetup:
        return _buildRoute(const QuizSetupPage(), settings);

      case RouteNames.quiz:
        return _buildRoute(
          const QuizPage(),
          settings,
        );

      case RouteNames.quizResult:
        return _buildRoute(
          const QuizResultPage(),
          settings,
        );

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  /// Build a material page route with custom transition
  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
