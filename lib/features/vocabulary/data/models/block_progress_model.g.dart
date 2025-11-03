// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlockProgressModelAdapter extends TypeAdapter<BlockProgressModel> {
  @override
  final int typeId = 4;

  @override
  BlockProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlockProgressModel(
      blockId: fields[0] as String,
      blockNumber: fields[1] as int,
      level: fields[2] as String,
      wordType: fields[3] as String?,
      startIndex: fields[4] as int,
      totalWords: fields[5] as int,
      completedWords: fields[6] as int,
      completionCount: fields[7] as int,
      lastStudied: fields[8] as DateTime,
      isCompleted: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BlockProgressModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.blockId)
      ..writeByte(1)
      ..write(obj.blockNumber)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.wordType)
      ..writeByte(4)
      ..write(obj.startIndex)
      ..writeByte(5)
      ..write(obj.totalWords)
      ..writeByte(6)
      ..write(obj.completedWords)
      ..writeByte(7)
      ..write(obj.completionCount)
      ..writeByte(8)
      ..write(obj.lastStudied)
      ..writeByte(9)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockProgressModel _$BlockProgressModelFromJson(Map<String, dynamic> json) =>
    BlockProgressModel(
      blockId: json['blockId'] as String,
      blockNumber: (json['blockNumber'] as num).toInt(),
      level: json['level'] as String,
      wordType: json['wordType'] as String?,
      startIndex: (json['startIndex'] as num).toInt(),
      totalWords: (json['totalWords'] as num).toInt(),
      completedWords: (json['completedWords'] as num).toInt(),
      completionCount: (json['completionCount'] as num).toInt(),
      lastStudied: DateTime.parse(json['lastStudied'] as String),
      isCompleted: json['isCompleted'] as bool,
    );

Map<String, dynamic> _$BlockProgressModelToJson(BlockProgressModel instance) =>
    <String, dynamic>{
      'blockId': instance.blockId,
      'blockNumber': instance.blockNumber,
      'level': instance.level,
      'wordType': instance.wordType,
      'startIndex': instance.startIndex,
      'totalWords': instance.totalWords,
      'completedWords': instance.completedWords,
      'completionCount': instance.completionCount,
      'lastStudied': instance.lastStudied.toIso8601String(),
      'isCompleted': instance.isCompleted,
    };
