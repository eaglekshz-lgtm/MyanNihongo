import 'package:equatable/equatable.dart';

/// SRS Level representing the learning stage of a vocabulary item
enum SRSLevel {
  newCard,    // First time seeing (0 days)
  learning,   // < 21 days
  young,      // 21+ days
  mature,     // 2+ months (60 days)
  mastered;   // 6+ months (180 days)

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case SRSLevel.newCard:
        return 'New';
      case SRSLevel.learning:
        return 'Learning';
      case SRSLevel.young:
        return 'Young';
      case SRSLevel.mature:
        return 'Mature';
      case SRSLevel.mastered:
        return 'Mastered';
    }
  }

  /// Get color for UI
  int get colorValue {
    switch (this) {
      case SRSLevel.newCard:
        return 0xFF9E9E9E; // Gray
      case SRSLevel.learning:
        return 0xFF2196F3; // Blue
      case SRSLevel.young:
        return 0xFF4CAF50; // Green
      case SRSLevel.mature:
        return 0xFFFF9800; // Orange
      case SRSLevel.mastered:
        return 0xFFE91E63; // Pink
    }
  }
}

/// Domain entity representing an SRS card for vocabulary learning
class SRSCard extends Equatable {
  final String vocabularyId;
  final double easeFactor; // 1.3 to 2.5 (default 2.5)
  final int interval; // Days until next review
  final DateTime nextReviewDate;
  final int repetitions; // Number of successful reviews
  final SRSLevel level;
  final DateTime lastReviewDate;
  final int lapses; // Number of times forgotten

  const SRSCard({
    required this.vocabularyId,
    required this.easeFactor,
    required this.interval,
    required this.nextReviewDate,
    required this.repetitions,
    required this.level,
    required this.lastReviewDate,
    this.lapses = 0,
  });

  /// Create a new SRS card for a vocabulary item
  factory SRSCard.newCard(String vocabularyId) {
    final now = DateTime.now();
    return SRSCard(
      vocabularyId: vocabularyId,
      easeFactor: 2.5, // Default ease factor
      interval: 0,
      nextReviewDate: now,
      repetitions: 0,
      level: SRSLevel.newCard,
      lastReviewDate: now,
      lapses: 0,
    );
  }

  /// Check if card is due for review
  bool get isDue {
    return DateTime.now().isAfter(nextReviewDate) ||
        DateTime.now().isAtSameMomentAs(nextReviewDate);
  }

  /// Get days until next review
  int get daysUntilReview {
    final now = DateTime.now();
    if (isDue) return 0;
    return nextReviewDate.difference(now).inDays;
  }

  /// Calculate new SRS values based on review quality
  /// quality: 0-5 (0=complete blackout, 5=perfect response)
  SRSCard review(int quality) {
    assert(quality >= 0 && quality <= 5, 'Quality must be between 0 and 5');

    final now = DateTime.now();
    
    // Calculate new ease factor (SM-2 algorithm)
    double newEaseFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    newEaseFactor = newEaseFactor.clamp(1.3, 2.5);

    int newInterval;
    int newRepetitions;
    int newLapses = lapses;

    if (quality < 3) {
      // Failed review - reset to learning
      newInterval = 1;
      newRepetitions = 0;
      newLapses = lapses + 1;
    } else {
      // Successful review
      if (repetitions == 0) {
        newInterval = 1;
      } else if (repetitions == 1) {
        newInterval = 6;
      } else {
        newInterval = (interval * newEaseFactor).round();
      }
      newRepetitions = repetitions + 1;
    }

    // Calculate new level based on interval
    final newLevel = _calculateLevel(newInterval);

    return SRSCard(
      vocabularyId: vocabularyId,
      easeFactor: newEaseFactor,
      interval: newInterval,
      nextReviewDate: now.add(Duration(days: newInterval)),
      repetitions: newRepetitions,
      level: newLevel,
      lastReviewDate: now,
      lapses: newLapses,
    );
  }

  /// Calculate SRS level based on interval
  static SRSLevel _calculateLevel(int interval) {
    if (interval == 0) return SRSLevel.newCard;
    if (interval < 21) return SRSLevel.learning;
    if (interval < 60) return SRSLevel.young;
    if (interval < 180) return SRSLevel.mature;
    return SRSLevel.mastered;
  }

  /// Get retention rate (0.0 to 1.0)
  double get retentionRate {
    if (repetitions == 0) return 0.0;
    final totalReviews = repetitions + lapses;
    return repetitions / totalReviews;
  }

  SRSCard copyWith({
    String? vocabularyId,
    double? easeFactor,
    int? interval,
    DateTime? nextReviewDate,
    int? repetitions,
    SRSLevel? level,
    DateTime? lastReviewDate,
    int? lapses,
  }) {
    return SRSCard(
      vocabularyId: vocabularyId ?? this.vocabularyId,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      repetitions: repetitions ?? this.repetitions,
      level: level ?? this.level,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      lapses: lapses ?? this.lapses,
    );
  }

  @override
  List<Object?> get props => [
        vocabularyId,
        easeFactor,
        interval,
        nextReviewDate,
        repetitions,
        level,
        lastReviewDate,
        lapses,
      ];
}
