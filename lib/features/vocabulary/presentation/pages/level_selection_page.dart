import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/routes/arguments/learning_mode_config_args.dart';
import '../widgets/level_card_widget.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Select JLPT Level'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.bannerGradientStart,
                        Theme.of(context).colorScheme.bannerGradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.bannerGradientStart
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.school,
                    color: Theme.of(context).colorScheme.fixedWhite,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Choose Your Level',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the JLPT level you want to practice',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Expanded(child: _LevelsList()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Separated widget for levels list to prevent unnecessary rebuilds
class _LevelsList extends StatelessWidget {
  const _LevelsList();

  static const _levels = [
    _LevelData(
      level: 'N5',
      title: 'JLPT N5',
      description: 'Beginner · Basic vocabulary and grammar',
      difficulty: 'Easiest',
    ),
    _LevelData(
      level: 'N4',
      title: 'JLPT N4',
      description: 'Elementary · Simple everyday conversations',
      difficulty: 'Easy',
    ),
    _LevelData(
      level: 'N3',
      title: 'JLPT N3',
      description: 'Intermediate · Daily life situations',
      difficulty: 'Medium',
    ),
    _LevelData(
      level: 'N2',
      title: 'JLPT N2',
      description: 'Upper intermediate · Complex topics',
      difficulty: 'Hard',
    ),
    _LevelData(
      level: 'N1',
      title: 'JLPT N1',
      description: 'Advanced · Native-level fluency',
      difficulty: 'Hardest',
    ),
  ];

  void _navigateToLearningConfig(BuildContext context, String level) {
    // Navigate directly to learning mode config, skipping category selection
    // Default to 'all' word types (no filtering by category)
    Navigator.pushNamed(
      context,
      RouteNames.learningModeConfig,
      arguments: LearningModeConfigArgs(
        level: level,
        wordType: null, // null means 'all' word types
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: _levels.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final levelData = _levels[index];
        return LevelCardWidget(
          level: levelData.level,
          title: levelData.title,
          description: levelData.description,
          difficulty: levelData.difficulty,
          onTap: () => _navigateToLearningConfig(context, levelData.level),
        );
      },
    );
  }
}

/// Immutable data class for level information
class _LevelData {
  final String level;
  final String title;
  final String description;
  final String difficulty;

  const _LevelData({
    required this.level,
    required this.title,
    required this.description,
    required this.difficulty,
  });
}
