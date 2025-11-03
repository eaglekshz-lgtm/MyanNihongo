// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressModelAdapter extends TypeAdapter<UserProgressModel> {
  @override
  final int typeId = 5;

  @override
  UserProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgressModel(
      vocabularyId: fields[0] as String,
      timesViewed: fields[1] as int,
      timesAnsweredCorrectly: fields[2] as int,
      timesAnsweredIncorrectly: fields[3] as int,
      lastReviewed: fields[4] as DateTime,
      isMastered: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserProgressModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.vocabularyId)
      ..writeByte(1)
      ..write(obj.timesViewed)
      ..writeByte(2)
      ..write(obj.timesAnsweredCorrectly)
      ..writeByte(3)
      ..write(obj.timesAnsweredIncorrectly)
      ..writeByte(4)
      ..write(obj.lastReviewed)
      ..writeByte(5)
      ..write(obj.isMastered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgressModel _$UserProgressModelFromJson(Map<String, dynamic> json) =>
    UserProgressModel(
      vocabularyId: json['vocabularyId'] as String,
      timesViewed: (json['timesViewed'] as num).toInt(),
      timesAnsweredCorrectly: (json['timesAnsweredCorrectly'] as num).toInt(),
      timesAnsweredIncorrectly:
          (json['timesAnsweredIncorrectly'] as num).toInt(),
      lastReviewed: DateTime.parse(json['lastReviewed'] as String),
      isMastered: json['isMastered'] as bool,
    );

Map<String, dynamic> _$UserProgressModelToJson(UserProgressModel instance) =>
    <String, dynamic>{
      'vocabularyId': instance.vocabularyId,
      'timesViewed': instance.timesViewed,
      'timesAnsweredCorrectly': instance.timesAnsweredCorrectly,
      'timesAnsweredIncorrectly': instance.timesAnsweredIncorrectly,
      'lastReviewed': instance.lastReviewed.toIso8601String(),
      'isMastered': instance.isMastered,
    };
