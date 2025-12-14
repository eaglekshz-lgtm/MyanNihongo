// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streak_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStreakModelAdapter extends TypeAdapter<UserStreakModel> {
  @override
  final int typeId = 10;

  @override
  UserStreakModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStreakModel(
      currentStreak: fields[0] as int,
      longestStreak: fields[1] as int,
      lastStudyDate: fields[2] as DateTime?,
      studyDates: (fields[3] as List).cast<DateTime>(),
      totalStudyDays: fields[4] as int,
      studiedToday: fields[5] as bool,
      streakFreezesAvailable: fields[6] as int,
      streakStartDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserStreakModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.currentStreak)
      ..writeByte(1)
      ..write(obj.longestStreak)
      ..writeByte(2)
      ..write(obj.lastStudyDate)
      ..writeByte(3)
      ..write(obj.studyDates)
      ..writeByte(4)
      ..write(obj.totalStudyDays)
      ..writeByte(5)
      ..write(obj.studiedToday)
      ..writeByte(6)
      ..write(obj.streakFreezesAvailable)
      ..writeByte(7)
      ..write(obj.streakStartDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStreakModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStreakModel _$UserStreakModelFromJson(Map<String, dynamic> json) =>
    UserStreakModel(
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      lastStudyDate: json['lastStudyDate'] == null
          ? null
          : DateTime.parse(json['lastStudyDate'] as String),
      studyDates: (json['studyDates'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      totalStudyDays: (json['totalStudyDays'] as num).toInt(),
      studiedToday: json['studiedToday'] as bool,
      streakFreezesAvailable:
          (json['streakFreezesAvailable'] as num?)?.toInt() ?? 2,
      streakStartDate: json['streakStartDate'] == null
          ? null
          : DateTime.parse(json['streakStartDate'] as String),
    );

Map<String, dynamic> _$UserStreakModelToJson(UserStreakModel instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastStudyDate': instance.lastStudyDate?.toIso8601String(),
      'studyDates':
          instance.studyDates.map((e) => e.toIso8601String()).toList(),
      'totalStudyDays': instance.totalStudyDays,
      'studiedToday': instance.studiedToday,
      'streakFreezesAvailable': instance.streakFreezesAvailable,
      'streakStartDate': instance.streakStartDate?.toIso8601String(),
    };
