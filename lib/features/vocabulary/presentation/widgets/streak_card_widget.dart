import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/streak_provider.dart';

/// Modern streak display card for home page
class StreakCardWidget extends ConsumerWidget {
  const StreakCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(streakStatsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B35),
            const Color(0xFFFF8C42).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Flame icon with streak count
          _StreakFlameIcon(
            currentStreak: stats.currentStreak,
            studiedToday: stats.studiedToday,
          ),
          const SizedBox(width: 16),
          // Streak info
          Expanded(
            child: _StreakInfo(stats: stats),
          ),
          // Progress indicator
          if (stats.currentStreak > 0)
            _StreakProgressRing(percentage: stats.streakPercentage),
        ],
      ),
    );
  }
}

/// Animated flame icon with streak count
class _StreakFlameIcon extends StatelessWidget {
  final int currentStreak;
  final bool studiedToday;

  const _StreakFlameIcon({
    required this.currentStreak,
    required this.studiedToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            studiedToday ? Icons.local_fire_department : Icons.local_fire_department_outlined,
            color: Colors.white,
            size: 32,
          ),
          Text(
            '$currentStreak',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Streak information text
class _StreakInfo extends StatelessWidget {
  final StreakStats stats;

  const _StreakInfo({required this.stats});

  String get _statusText {
    if (stats.studiedToday) {
      return '🎉 Great! You studied today!';
    } else if (stats.currentStreak > 0) {
      return '⚡ Keep your ${stats.currentStreak}-day streak alive!';
    } else {
      return '🌟 Start your learning streak today!';
    }
  }

  String get _detailsText {
    if (stats.longestStreak > stats.currentStreak) {
      return 'Longest: ${stats.longestStreak} days';
    } else if (stats.currentStreak > 0) {
      return 'Total study days: ${stats.totalStudyDays}';
    } else {
      return 'Study daily to build momentum';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _statusText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _detailsText,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Circular progress ring showing progress to next milestone
class _StreakProgressRing extends StatelessWidget {
  final double percentage;

  const _StreakProgressRing({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          // Progress circle
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 4,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          // Percentage text
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
