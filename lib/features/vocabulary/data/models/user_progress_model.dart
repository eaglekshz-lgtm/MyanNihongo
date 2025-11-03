import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_progress.dart';

part 'user_progress_model.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class UserProgressModel extends UserProgress {
  @HiveField(0)
  @override
  String get vocabularyId => super.vocabularyId;

  @HiveField(1)
  @override
  int get timesViewed => super.timesViewed;

  @HiveField(2)
  @override
  int get timesAnsweredCorrectly => super.timesAnsweredCorrectly;

  @HiveField(3)
  @override
  int get timesAnsweredIncorrectly => super.timesAnsweredIncorrectly;

  @HiveField(4)
  @override
  DateTime get lastReviewed => super.lastReviewed;

  @HiveField(5)
  @override
  bool get isMastered => super.isMastered;

  const UserProgressModel({
    required super.vocabularyId,
    required super.timesViewed,
    required super.timesAnsweredCorrectly,
    required super.timesAnsweredIncorrectly,
    required super.lastReviewed,
    required super.isMastered,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProgressModelToJson(this);

  factory UserProgressModel.fromEntity(UserProgress entity) {
    return UserProgressModel(
      vocabularyId: entity.vocabularyId,
      timesViewed: entity.timesViewed,
      timesAnsweredCorrectly: entity.timesAnsweredCorrectly,
      timesAnsweredIncorrectly: entity.timesAnsweredIncorrectly,
      lastReviewed: entity.lastReviewed,
      isMastered: entity.isMastered,
    );
  }

  UserProgress toEntity() {
    return UserProgress(
      vocabularyId: vocabularyId,
      timesViewed: timesViewed,
      timesAnsweredCorrectly: timesAnsweredCorrectly,
      timesAnsweredIncorrectly: timesAnsweredIncorrectly,
      lastReviewed: lastReviewed,
      isMastered: isMastered,
    );
  }

  @override
  UserProgressModel copyWith({
    String? vocabularyId,
    int? timesViewed,
    int? timesAnsweredCorrectly,
    int? timesAnsweredIncorrectly,
    DateTime? lastReviewed,
    bool? isMastered,
  }) {
    return UserProgressModel(
      vocabularyId: vocabularyId ?? this.vocabularyId,
      timesViewed: timesViewed ?? this.timesViewed,
      timesAnsweredCorrectly:
          timesAnsweredCorrectly ?? this.timesAnsweredCorrectly,
      timesAnsweredIncorrectly:
          timesAnsweredIncorrectly ?? this.timesAnsweredIncorrectly,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      isMastered: isMastered ?? this.isMastered,
    );
  }
}
