import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../arguments/category_selection_args.dart';
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
      color: AppTheme.successColor,
      difficulty: 'Easiest',
    ),
    _LevelData(
      level: 'N4',
      title: 'JLPT N4',
      description: 'Elementary - Simple everyday conversations',
      color: Colors.lightGreen,
      difficulty: 'Easy',
    ),
    _LevelData(
      level: 'N3',
      title: 'JLPT N3',
      description: 'Intermediate - Daily life situations',
      color: AppTheme.warningColor,
      difficulty: 'Medium',
    ),
    _LevelData(
      level: 'N2',
      title: 'JLPT N2',
      description: 'Upper intermediate - Various topics',
      color: Colors.deepOrange,
      difficulty: 'Hard',
    ),
    _LevelData(
      level: 'N1',
      title: 'JLPT N1',
      description: 'Advanced - Complex topics and expressions',
      color: AppTheme.errorColor,
      difficulty: 'Hardest',
    ),
  ];

  void _navigateToCategory(BuildContext context, String level) {
    Navigator.pushNamed(
      context,
      RouteNames.categorySelection,
      arguments: CategorySelectionArgs(level: level),
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
          color: levelData.color,
          difficulty: levelData.difficulty,
          onTap: () => _navigateToCategory(context, levelData.level),
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
  final Color color;
  final String difficulty;

  const _LevelData({
    required this.level,
    required this.title,
    required this.description,
    required this.color,
    required this.difficulty,
  });
}
