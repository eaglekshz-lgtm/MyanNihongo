import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/streak_provider.dart';

/// Modern streak display card for home page
class StreakCardWidget extends ConsumerWidget {
  const StreakCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(streakStatsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.streakGradientEnd,
            Theme.of(context).colorScheme.streakGradientStart,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          // Flame icon container
          Container(
            width: 64,
            height: 72,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.fixedWhite.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.fixedWhite.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 2),
                Text(
                  '${stats.currentStreak}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.fixedWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Streak info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stats.currentStreak > 0
                      ? 'Keep your streak alive!'
                      : 'Start your streak today!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.fixedWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stats.currentStreak > 0
                      ? 'Study daily to build momentum'
                      : 'Study daily to build momentum',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.fixedWhite.withValues(alpha: 0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
