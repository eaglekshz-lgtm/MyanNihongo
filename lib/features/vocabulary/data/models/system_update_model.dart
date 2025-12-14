import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'system_update_model.g.dart';

/// Model for system_update table in Supabase
/// Used to track when vocabulary data was last updated
/// to avoid unnecessary fetches from the server
@HiveType(typeId: 12)
@JsonSerializable()
class SystemUpdateModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String tag;

  @HiveField(2)
  @JsonKey(name: 'last_updated_at')
  final DateTime lastUpdatedAt;

  @HiveField(3)
  final String? description;

  /// Local timestamp when we last checked/synced with server
  @HiveField(4)
  final DateTime? lastCheckedAt;

  const SystemUpdateModel({
    required this.id,
    required this.tag,
    required this.lastUpdatedAt,
    this.description,
    this.lastCheckedAt,
  });

  factory SystemUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$SystemUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$SystemUpdateModelToJson(this);

  /// Create a copy with updated fields
  SystemUpdateModel copyWith({
    int? id,
    String? tag,
    DateTime? lastUpdatedAt,
    String? description,
    DateTime? lastCheckedAt,
  }) {
    return SystemUpdateModel(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      description: description ?? this.description,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
    );
  }

  /// Check if vocabulary needs to be updated
  /// Returns true if server data is newer than our local cache
  /// Compares timestamps at second precision in UTC to avoid microsecond and timezone differences
  bool needsUpdate(DateTime? localLastUpdated) {
    if (localLastUpdated == null) return true;
    
    // Convert both to UTC and normalize to second precision
    final serverUtc = lastUpdatedAt.toUtc();
    final localUtc = localLastUpdated.toUtc();
    
    final serverTime = DateTime.utc(
      serverUtc.year,
      serverUtc.month,
      serverUtc.day,
      serverUtc.hour,
      serverUtc.minute,
      serverUtc.second,
    );
    
    final localTime = DateTime.utc(
      localUtc.year,
      localUtc.month,
      localUtc.day,
      localUtc.hour,
      localUtc.minute,
      localUtc.second,
    );
    
    return serverTime.isAfter(localTime);
  }

  @override
  String toString() {
    return 'SystemUpdateModel(id: $id, tag: $tag, lastUpdatedAt: $lastUpdatedAt, description: $description, lastCheckedAt: $lastCheckedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SystemUpdateModel &&
        other.id == id &&
        other.tag == tag &&
        other.lastUpdatedAt == lastUpdatedAt &&
        other.description == description &&
        other.lastCheckedAt == lastCheckedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      tag,
      lastUpdatedAt,
      description,
      lastCheckedAt,
    );
  }
}
