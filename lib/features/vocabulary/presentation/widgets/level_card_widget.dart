import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Reusable level card widget for JLPT level selection
class LevelCardWidget extends StatelessWidget {
  final String level;
  final String title;
  final String description;
  final Color color;
  final String difficulty;
  final VoidCallback onTap;

  const LevelCardWidget({
    super.key,
    required this.level,
    required this.title,
    required this.description,
    required this.color,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.15),
                color.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              _LevelBadge(level: level, color: color),
              const SizedBox(width: 20),
              Expanded(
                child: _LevelInfo(
                  title: title,
                  description: description,
                  difficulty: difficulty,
                  color: color,
                ),
              ),
              _LevelArrow(color: color),
            ],
          ),
        ),
      ),
    );
  }
}

/// Level badge (N5, N4, etc.)
class _LevelBadge extends StatelessWidget {
  final String level;
  final Color color;

  const _LevelBadge({
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          level,
          style: AppTheme.headlineSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Level information section
class _LevelInfo extends StatelessWidget {
  final String title;
  final String description;
  final String difficulty;
  final Color color;

  const _LevelInfo({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: AppTheme.bodyMedium.copyWith(
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        _DifficultyChip(difficulty: difficulty, color: color),
      ],
    );
  }
}

/// Difficulty indicator chip
class _DifficultyChip extends StatelessWidget {
  final String difficulty;
  final Color color;

  const _DifficultyChip({
    required this.difficulty,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: AppTheme.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Forward arrow indicator
class _LevelArrow extends StatelessWidget {
  final Color color;

  const _LevelArrow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward,
      color: color,
      size: 20,
    );
  }
}
