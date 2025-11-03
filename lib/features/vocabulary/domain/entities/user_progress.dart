import 'package:equatable/equatable.dart';

/// Domain entity representing user progress for a vocabulary item
class UserProgress extends Equatable {
  final String vocabularyId;
  final int timesViewed;
  final int timesAnsweredCorrectly;
  final int timesAnsweredIncorrectly;
  final DateTime lastReviewed;
  final bool isMastered;

  const UserProgress({
    required this.vocabularyId,
    required this.timesViewed,
    required this.timesAnsweredCorrectly,
    required this.timesAnsweredIncorrectly,
    required this.lastReviewed,
    required this.isMastered,
  });

  double get accuracy {
    final total = timesAnsweredCorrectly + timesAnsweredIncorrectly;
    if (total == 0) return 0.0;
    return timesAnsweredCorrectly / total;
  }

  UserProgress copyWith({
    String? vocabularyId,
    int? timesViewed,
    int? timesAnsweredCorrectly,
    int? timesAnsweredIncorrectly,
    DateTime? lastReviewed,
    bool? isMastered,
  }) {
    return UserProgress(
      vocabularyId: vocabularyId ?? this.vocabularyId,
      timesViewed: timesViewed ?? this.timesViewed,
      timesAnsweredCorrectly: timesAnsweredCorrectly ?? this.timesAnsweredCorrectly,
      timesAnsweredIncorrectly: timesAnsweredIncorrectly ?? this.timesAnsweredIncorrectly,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      isMastered: isMastered ?? this.isMastered,
    );
  }

  @override
  List<Object?> get props => [
        vocabularyId,
        timesViewed,
        timesAnsweredCorrectly,
        timesAnsweredIncorrectly,
        lastReviewed,
        isMastered,
      ];
}
