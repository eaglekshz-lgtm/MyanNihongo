// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'srs_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SRSCardModelAdapter extends TypeAdapter<SRSCardModel> {
  @override
  final int typeId = 11;

  @override
  SRSCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SRSCardModel(
      vocabularyId: fields[0] as String,
      easeFactor: fields[1] as double,
      interval: fields[2] as int,
      nextReviewDate: fields[3] as DateTime,
      repetitions: fields[4] as int,
      levelString: fields[5] as String,
      lastReviewDate: fields[6] as DateTime,
      lapses: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SRSCardModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.vocabularyId)
      ..writeByte(1)
      ..write(obj.easeFactor)
      ..writeByte(2)
      ..write(obj.interval)
      ..writeByte(3)
      ..write(obj.nextReviewDate)
      ..writeByte(4)
      ..write(obj.repetitions)
      ..writeByte(5)
      ..write(obj.levelString)
      ..writeByte(6)
      ..write(obj.lastReviewDate)
      ..writeByte(7)
      ..write(obj.lapses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SRSCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SRSCardModel _$SRSCardModelFromJson(Map<String, dynamic> json) => SRSCardModel(
      vocabularyId: json['vocabularyId'] as String,
      easeFactor: (json['easeFactor'] as num).toDouble(),
      interval: (json['interval'] as num).toInt(),
      nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
      repetitions: (json['repetitions'] as num).toInt(),
      levelString: json['level'] as String,
      lastReviewDate: DateTime.parse(json['lastReviewDate'] as String),
      lapses: (json['lapses'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SRSCardModelToJson(SRSCardModel instance) =>
    <String, dynamic>{
      'vocabularyId': instance.vocabularyId,
      'easeFactor': instance.easeFactor,
      'interval': instance.interval,
      'nextReviewDate': instance.nextReviewDate.toIso8601String(),
      'repetitions': instance.repetitions,
      'level': instance.levelString,
      'lastReviewDate': instance.lastReviewDate.toIso8601String(),
      'lapses': instance.lapses,
    };
