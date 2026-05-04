import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';

/// Reusable level card widget for JLPT level selection
class LevelCardWidget extends StatelessWidget {
  final String level;
  final String title;
  final String description;
  final String difficulty;
  final VoidCallback onTap;

  const LevelCardWidget({
    super.key,
    required this.level,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.onTap,
  });

  Color _getLevelColor(BuildContext context) {
    switch (level) {
      case 'N5':
        return Theme.of(context).colorScheme.legacyLevelGreen; // Green
      case 'N4':
        return Theme.of(context).colorScheme.legacyLevelTeal; // Teal
      case 'N3':
        return Theme.of(context).colorScheme.legacyLevelBlue; // Blue
      case 'N2':
        return Theme.of(context).colorScheme.legacyLevelOrange; // Orange
      case 'N1':
        return Theme.of(context).colorScheme.legacyLevelRed; // Red
      default:
        return Theme.of(context).colorScheme.learningCardGradientEnd;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Theme.of(context).colorScheme.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Colored Square
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: levelColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      level,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.fixedWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Middle Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: levelColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: levelColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              difficulty,
                              style: TextStyle(
                                color: levelColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Right Arrow
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
