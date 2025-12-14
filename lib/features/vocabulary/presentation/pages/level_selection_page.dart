import 'package:flutter/material.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../arguments/learning_mode_config_args.dart';
import '../widgets/page_header_widget.dart';
import '../widgets/level_card_widget.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select JLPT Level'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeaderWidget(
                icon: Icons.school,
                title: 'Choose Your Level',
                subtitle: 'Select the JLPT level you want to practice',
              ),
              SizedBox(height: 32),
              Expanded(
                child: _LevelsList(),
              ),
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
      description: 'Beginner - Basic vocabulary and grammar',
      difficulty: 'Easiest',
    ),
    _LevelData(
      level: 'N4',
      title: 'JLPT N4',
      description: 'Elementary - Simple everyday conversations',
      difficulty: 'Easy',
    ),
    _LevelData(
      level: 'N3',
      title: 'JLPT N3',
      description: 'Intermediate - Daily life situations',
      difficulty: 'Medium',
    ),
    _LevelData(
      level: 'N2',
      title: 'JLPT N2',
      description: 'Upper intermediate - Various topics',
      difficulty: 'Hard',
    ),
    _LevelData(
      level: 'N1',
      title: 'JLPT N1',
      description: 'Advanced - Complex topics and expressions',
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
