import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/route_names.dart';
import 'core/routes/app_routes.dart';
import 'core/utils/logger.dart';
import 'features/vocabulary/data/models/vocabulary_item_model.dart';
import 'features/vocabulary/data/models/user_progress_model.dart';
import 'features/vocabulary/data/models/block_progress_model.dart';
import 'features/vocabulary/data/models/bookmark_model.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await _initializeApp();
    runApp(const ProviderScope(child: MyanNihongoApp()));
  } catch (e, stackTrace) {
    AppLogger.error(
      'Critical error during app initialization',
      tag: 'Main',
      error: e,
      stackTrace: stackTrace,
    );
    
    // Run app with error screen
    runApp(
      MaterialApp(
        home: AppInitializationErrorScreen(error: e.toString()),
      ),
    );
  }
}

/// Initialize Hive and register adapters
Future<void> _initializeApp() async {
  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register Hive adapters
    Hive.registerAdapter(VocabularyItemModelAdapter());
    Hive.registerAdapter(UserProgressModelAdapter());
    Hive.registerAdapter(BlockProgressModelAdapter());
    Hive.registerAdapter(BookmarkModelAdapter());
    Hive.registerAdapter(QuizDataModelAdapter());
    Hive.registerAdapter(QuizQuestionModelAdapter());
    Hive.registerAdapter(ExampleSentenceModelAdapter());
    Hive.registerAdapter(TranslationModelAdapter());

    // Open Hive boxes with error handling
    await Future.wait([
      Hive.openBox<VocabularyItemModel>(AppConstants.vocabularyBoxName),
      Hive.openBox<UserProgressModel>(AppConstants.userProgressBoxName),
      Hive.openBox<BlockProgressModel>(AppConstants.blockProgressBoxName),
      Hive.openBox<dynamic>(AppConstants.appPreferencesBoxName),
      Hive.openBox<BookmarkModel>(AppConstants.bookmarksBoxName),
    ]);

    AppLogger.info('App initialization completed successfully', 'Hive');
  } catch (e) {
    AppLogger.error('Error during app initialization', tag: 'Hive', error: e);
    rethrow;
  }
}

class MyanNihongoApp extends StatelessWidget {
  const MyanNihongoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyanNihongo - Learn Burmese to Japanese',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // Use home for splash screen
      home: const SplashScreen(),
      // Named routes configuration
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

/// Splash screen that initializes the app and shows loading state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to home screen using named route
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'MyanNihongo',
              style: AppTheme.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Learn Burmese to Japanese',
              style: AppTheme.titleMedium.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen shown when app fails to initialize
class AppInitializationErrorScreen extends StatelessWidget {
  const AppInitializationErrorScreen({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'App Initialization Failed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'An error occurred while starting the app.\n\nPlease try restarting the application.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Error details: $error',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
