// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_update_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SystemUpdateModelAdapter extends TypeAdapter<SystemUpdateModel> {
  @override
  final int typeId = 12;

  @override
  SystemUpdateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemUpdateModel(
      id: fields[0] as int,
      tag: fields[1] as String,
      lastUpdatedAt: fields[2] as DateTime,
      description: fields[3] as String?,
      lastCheckedAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SystemUpdateModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tag)
      ..writeByte(2)
      ..write(obj.lastUpdatedAt)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.lastCheckedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemUpdateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemUpdateModel _$SystemUpdateModelFromJson(Map<String, dynamic> json) =>
    SystemUpdateModel(
      id: (json['id'] as num).toInt(),
      tag: json['tag'] as String,
      lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
      description: json['description'] as String?,
      lastCheckedAt: json['lastCheckedAt'] == null
          ? null
          : DateTime.parse(json['lastCheckedAt'] as String),
    );

Map<String, dynamic> _$SystemUpdateModelToJson(SystemUpdateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'last_updated_at': instance.lastUpdatedAt.toIso8601String(),
      'description': instance.description,
      'lastCheckedAt': instance.lastCheckedAt?.toIso8601String(),
    };
