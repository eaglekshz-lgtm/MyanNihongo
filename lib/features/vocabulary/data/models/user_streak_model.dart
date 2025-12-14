import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_streak.dart';

part 'user_streak_model.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class UserStreakModel extends HiveObject {
  @HiveField(0)
  final int currentStreak;

  @HiveField(1)
  final int longestStreak;

  @HiveField(2)
  final DateTime? lastStudyDate;

  @HiveField(3)
  final List<DateTime> studyDates;

  @HiveField(4)
  final int totalStudyDays;

  @HiveField(5)
  final bool studiedToday;

  @HiveField(6)
  final int streakFreezesAvailable;

  @HiveField(7)
  final DateTime? streakStartDate;

  UserStreakModel({
    required this.currentStreak,
    required this.longestStreak,
    this.lastStudyDate,
    required this.studyDates,
    required this.totalStudyDays,
    required this.studiedToday,
    this.streakFreezesAvailable = 2,
    this.streakStartDate,
  });

  factory UserStreakModel.fromJson(Map<String, dynamic> json) =>
      _$UserStreakModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStreakModelToJson(this);

  factory UserStreakModel.fromEntity(UserStreak streak) {
    return UserStreakModel(
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      lastStudyDate: streak.lastStudyDate,
      studyDates: streak.studyDates,
      totalStudyDays: streak.totalStudyDays,
      studiedToday: streak.studiedToday,
      streakFreezesAvailable: streak.streakFreezesAvailable,
      streakStartDate: streak.streakStartDate,
    );
  }

  UserStreak toEntity() {
    return UserStreak(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastStudyDate: lastStudyDate,
      studyDates: studyDates,
      totalStudyDays: totalStudyDays,
      studiedToday: studiedToday,
      streakFreezesAvailable: streakFreezesAvailable,
      streakStartDate: streakStartDate,
    );
  }

  factory UserStreakModel.empty() {
    return UserStreakModel(
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
}
