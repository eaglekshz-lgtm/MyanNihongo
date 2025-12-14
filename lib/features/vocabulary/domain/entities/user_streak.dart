import 'package:equatable/equatable.dart';

/// Domain entity representing user's daily streak data
class UserStreak extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastStudyDate;
  final List<DateTime> studyDates;
  final int totalStudyDays;
  final bool studiedToday;
  final int streakFreezesAvailable;
  final DateTime? streakStartDate;

  const UserStreak({
    required this.currentStreak,
    required this.longestStreak,
    this.lastStudyDate,
    required this.studyDates,
    required this.totalStudyDays,
    required this.studiedToday,
    this.streakFreezesAvailable = 2,
    this.streakStartDate,
  });

  /// Creates an empty streak for new users
  factory UserStreak.empty() {
    return const UserStreak(
      currentStreak: 0,
      longestStreak: 0,
      lastStudyDate: null,
      studyDates: [],
      totalStudyDays: 0,
      studiedToday: false,
      streakFreezesAvailable: 2,
      streakStartDate: null,
    );
  }

  /// Check if streak is broken (considering freeze days)
  bool isStreakBroken(DateTime today) {
    if (lastStudyDate == null) return false;

    final daysSinceLastStudy = today.difference(lastStudyDate!).inDays;
    return daysSinceLastStudy > (1 + streakFreezesAvailable);
  }

  /// Get days until streak breaks
  int getDaysUntilBreak(DateTime today) {
    if (lastStudyDate == null) return 0;

    final daysSinceLastStudy = today.difference(lastStudyDate!).inDays;
    final daysRemaining = (1 + streakFreezesAvailable) - daysSinceLastStudy;
    return daysRemaining > 0 ? daysRemaining : 0;
  }

  UserStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastStudyDate,
    List<DateTime>? studyDates,
    int? totalStudyDays,
    bool? studiedToday,
    int? streakFreezesAvailable,
    DateTime? streakStartDate,
  }) {
    return UserStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      studyDates: studyDates ?? this.studyDates,
      totalStudyDays: totalStudyDays ?? this.totalStudyDays,
      studiedToday: studiedToday ?? this.studiedToday,
      streakFreezesAvailable: streakFreezesAvailable ?? this.streakFreezesAvailable,
      streakStartDate: streakStartDate ?? this.streakStartDate,
    );
  }

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        lastStudyDate,
        studyDates,
        totalStudyDays,
        studiedToday,
        streakFreezesAvailable,
        streakStartDate,
      ];
}
