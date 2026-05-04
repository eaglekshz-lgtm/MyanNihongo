import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/srs_provider.dart';

class SRSStatsWidget extends ConsumerWidget {
  const SRSStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(srsStatsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fallback colors for light mode
    final surfaceColor = isDark
        ? Theme.of(context).colorScheme.statsDarkSurface
        : Theme.of(context).colorScheme.fixedWhite;
    final statBoxColor = isDark
        ? Theme.of(context).colorScheme.statsDarkElevated
        : Theme.of(context).colorScheme.softBlueSurface;

    final primaryColor = Theme.of(context).colorScheme.statsPurple;
    final secondaryColor = Theme.of(context).colorScheme.statsOrange;
    final tertiaryColor = Theme.of(context).colorScheme.secondary;
    final successColor = Theme.of(context).colorScheme.statsSuccess;

    final lmDeepBlue1 = Theme.of(context).colorScheme.homePrimary;
    final lmDeepBlue2 = Theme.of(context).colorScheme.secondaryStrong;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Theme.of(context).colorScheme.fixedWhite.withValues(alpha: 0.05)
              : Theme.of(context).colorScheme.transparent,
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.homePrimary.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.school, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review Progress',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Spaced Repetition System',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (stats.dueCards > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${stats.dueCards} due',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.fixedWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats grid
          Column(
            children: [
              // Row 1
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'TOTAL',
                      '${stats.totalCards}',
                      isDark ? primaryColor : lmDeepBlue1,
                      statBoxColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'DUE',
                      '${stats.dueCards}',
                      isDark ? secondaryColor : lmDeepBlue2,
                      statBoxColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'NEW',
                      '${stats.newCards}',
                      isDark ? tertiaryColor : lmDeepBlue1,
                      statBoxColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Row 2
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'LEARNING',
                      '${stats.learningCards}',
                      isDark ? successColor : lmDeepBlue2,
                      statBoxColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'MATURE',
                      '${stats.matureCards}',
                      isDark ? secondaryColor : lmDeepBlue1,
                      statBoxColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'MASTERED',
                      '${stats.masteredCards}',
                      isDark ? tertiaryColor : lmDeepBlue2,
                      statBoxColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Retention indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: successColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: successColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.show_chart_rounded,
                    color: successColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Retention',
                  style: TextStyle(
                    color: successColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(stats.averageRetention * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: successColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
