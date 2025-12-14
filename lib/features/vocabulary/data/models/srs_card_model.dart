import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/srs_card.dart';

part 'srs_card_model.g.dart';

@HiveType(typeId: 11)
@JsonSerializable()
class SRSCardModel extends HiveObject {
  @HiveField(0)
  final String vocabularyId;

  @HiveField(1)
  final double easeFactor;

  @HiveField(2)
  final int interval;

  @HiveField(3)
  final DateTime nextReviewDate;

  @HiveField(4)
  final int repetitions;

  @HiveField(5)
  @JsonKey(name: 'level')
  final String levelString;

  @HiveField(6)
  final DateTime lastReviewDate;

  @HiveField(7)
  final int lapses;

  SRSCardModel({
    required this.vocabularyId,
    required this.easeFactor,
    required this.interval,
    required this.nextReviewDate,
    required this.repetitions,
    required this.levelString,
    required this.lastReviewDate,
    this.lapses = 0,
  });

  factory SRSCardModel.fromJson(Map<String, dynamic> json) =>
      _$SRSCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$SRSCardModelToJson(this);

  factory SRSCardModel.fromEntity(SRSCard card) {
    return SRSCardModel(
      vocabularyId: card.vocabularyId,
      easeFactor: card.easeFactor,
      interval: card.interval,
      nextReviewDate: card.nextReviewDate,
      repetitions: card.repetitions,
      levelString: card.level.name,
      lastReviewDate: card.lastReviewDate,
      lapses: card.lapses,
    );
  }

  SRSCard toEntity() {
    return SRSCard(
      vocabularyId: vocabularyId,
      easeFactor: easeFactor,
      interval: interval,
      nextReviewDate: nextReviewDate,
      repetitions: repetitions,
      level: SRSLevel.values.firstWhere(
        (e) => e.name == levelString,
        orElse: () => SRSLevel.newCard,
      ),
      lastReviewDate: lastReviewDate,
      lapses: lapses,
    );
  }

  factory SRSCardModel.newCard(String vocabularyId) {
    final now = DateTime.now();
    return SRSCardModel(
      vocabularyId: vocabularyId,
      easeFactor: 2.5,
      interval: 0,
      nextReviewDate: now,
      repetitions: 0,
      levelString: SRSLevel.newCard.name,
      lastReviewDate: now,
      lapses: 0,
    );
  }
}
