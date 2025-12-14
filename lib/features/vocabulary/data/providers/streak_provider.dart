import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_streak_model.dart';
import '../../domain/entities/user_streak.dart';

/// Provider for streak data box
final streakBoxProvider = Provider<Box<UserStreakModel>>((ref) {
  return Hive.box<UserStreakModel>(AppConstants.userStreakBoxName);
});

/// Provider for current user streak
final userStreakProvider =
    StateNotifierProvider<StreakNotifier, AsyncValue<UserStreak>>((ref) {
      final box = ref.watch(streakBoxProvider);
      return StreakNotifier(box);
    });

/// Notifier for managing user streak
class StreakNotifier extends StateNotifier<AsyncValue<UserStreak>> {
  final Box<UserStreakModel> _box;
  static const String _streakKey = 'user_streak';

  StreakNotifier(this._box) : super(const AsyncValue.loading()) {
    _loadStreak();
  }

  /// Load streak from storage
  Future<void> _loadStreak() async {
    try {
      final model = _box.get(_streakKey);
      if (model == null) {
        // Create new streak for first-time users
        final newStreak = UserStreak.empty();
        await _saveStreak(newStreak);
        state = AsyncValue.data(newStreak);
      } else {
        state = AsyncValue.data(model.toEntity());
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Save streak to storage
  Future<void> _saveStreak(UserStreak streak) async {
    try {
      final model = UserStreakModel.fromEntity(streak);
      await _box.put(_streakKey, model);
    } catch (e) {
      // Log error but don't throw
      AppLogger.error('Error saving streak', tag: 'Streak', error: e);
    }
  }

  /// Record a study session for today
  Future<void> recordStudySession() async {
    final currentState = state;
    if (!currentState.hasValue) return;

    final currentStreak = currentState.value!;
    final today = _normalizeDate(DateTime.now());

    // If already studied today, don't record again
    if (currentStreak.studiedToday) return;

    // Check if user has studied today already
    final hasStudiedToday = currentStreak.studyDates.any((date) {
      return _isSameDay(date, today);
    });

    if (hasStudiedToday) return;

    // Calculate new streak
    int newCurrentStreak = currentStreak.currentStreak;
    final lastDate = currentStreak.lastStudyDate;

    if (lastDate == null) {
      // First study session
      newCurrentStreak = 1;
    } else {
      final daysSinceLastStudy = today.difference(lastDate).inDays;

      if (daysSinceLastStudy == 1) {
        // Consecutive day - increment streak
        newCurrentStreak = currentStreak.currentStreak + 1;
      } else if (daysSinceLastStudy > 1) {
        // Streak broken - reset to 1
        newCurrentStreak = 1;
      }
    }

    // Update longest streak if needed
    final newLongestStreak = newCurrentStreak > currentStreak.longestStreak
        ? newCurrentStreak
        : currentStreak.longestStreak;

    // Add today to study dates
    final newStudyDates = List<DateTime>.from(currentStreak.studyDates)
      ..add(today);

    // Create updated streak
    final updatedStreak = currentStreak.copyWith(
      currentStreak: newCurrentStreak,
      longestStreak: newLongestStreak,
      lastStudyDate: today,
      studyDates: newStudyDates,
      totalStudyDays: currentStreak.totalStudyDays + 1,
      studiedToday: true,
      streakStartDate: currentStreak.streakStartDate ?? today,
    );

    // Save and update state
    await _saveStreak(updatedStreak);
    state = AsyncValue.data(updatedStreak);
  }

  /// Check and update streak status (call this on app start)
  Future<void> checkStreakStatus() async {
    final currentState = state;
    if (!currentState.hasValue) return;

    final currentStreak = currentState.value!;
    final today = _normalizeDate(DateTime.now());
    final lastDate = currentStreak.lastStudyDate;

    if (lastDate == null) return;

    // Check if it's a new day
    if (!_isSameDay(lastDate, today)) {
      // Reset studiedToday flag
      final updatedStreak = currentStreak.copyWith(studiedToday: false);

      // Check if streak is broken
      if (currentStreak.isStreakBroken(today)) {
        // Reset streak
        final brokenStreak = updatedStreak.copyWith(
          currentStreak: 0,
          streakStartDate: null,
        );
        await _saveStreak(brokenStreak);
        state = AsyncValue.data(brokenStreak);
      } else {
        await _saveStreak(updatedStreak);
        state = AsyncValue.data(updatedStreak);
      }
    }
  }

  /// Reset streak (for testing or user request)
  Future<void> resetStreak() async {
    final emptyStreak = UserStreak.empty();
    await _saveStreak(emptyStreak);
    state = AsyncValue.data(emptyStreak);
  }

  /// Helper: Normalize date to midnight
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Helper: Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

/// Provider for streak statistics
final streakStatsProvider = Provider<StreakStats>((ref) {
  final streakAsync = ref.watch(userStreakProvider);

  return streakAsync.when(
    data: (streak) {
      final today = DateTime.now();
      final daysUntilBreak = streak.getDaysUntilBreak(today);

      return StreakStats(
        currentStreak: streak.currentStreak,
        longestStreak: streak.longestStreak,
        totalStudyDays: streak.totalStudyDays,
        studiedToday: streak.studiedToday,
        daysUntilBreak: daysUntilBreak,
        streakPercentage: _calculateStreakPercentage(streak),
      );
    },
    loading: () => StreakStats.empty(),
    error: (_, __) => StreakStats.empty(),
  );
});

/// Calculate streak percentage (for progress indicators)
double _calculateStreakPercentage(UserStreak streak) {
  if (streak.currentStreak == 0) return 0.0;

  // Calculate percentage towards next milestone
  final milestones = [7, 30, 100, 365];
  final currentStreak = streak.currentStreak;

  for (int i = 0; i < milestones.length; i++) {
    final milestone = milestones[i];
    if (currentStreak < milestone) {
      final previousMilestone = i == 0 ? 0 : milestones[i - 1];
      final progress =
          (currentStreak - previousMilestone) / (milestone - previousMilestone);
      return progress.clamp(0.0, 1.0);
    }
  }

  return 1.0; // Past all milestones
}

/// Streak statistics data class
class StreakStats {
  final int currentStreak;
  final int longestStreak;
  final int totalStudyDays;
  final bool studiedToday;
  final int daysUntilBreak;
  final double streakPercentage;

  const StreakStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalStudyDays,
    required this.studiedToday,
    required this.daysUntilBreak,
    required this.streakPercentage,
  });

  factory StreakStats.empty() {
    return const StreakStats(
      currentStreak: 0,
      longestStreak: 0,
      totalStudyDays: 0,
      studiedToday: false,
      daysUntilBreak: 0,
      streakPercentage: 0.0,
    );
  }
}
