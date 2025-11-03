import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/block_progress.dart';

part 'block_progress_model.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class BlockProgressModel extends BlockProgress {
  @HiveField(0)
  @override
  String get blockId => super.blockId;

  @HiveField(1)
  @override
  int get blockNumber => super.blockNumber;

  @HiveField(2)
  @override
  String get level => super.level;

  @HiveField(3)
  @override
  String? get wordType => super.wordType;

  @HiveField(4)
  @override
  int get startIndex => super.startIndex;

  @HiveField(5)
  @override
  int get totalWords => super.totalWords;

  @HiveField(6)
  @override
  int get completedWords => super.completedWords;

  @HiveField(7)
  @override
  int get completionCount => super.completionCount;

  @HiveField(8)
  @override
  DateTime get lastStudied => super.lastStudied;

  @HiveField(9)
  @override
  bool get isCompleted => super.isCompleted;

  const BlockProgressModel({
    required super.blockId,
    required super.blockNumber,
    required super.level,
    super.wordType,
    required super.startIndex,
    required super.totalWords,
    required super.completedWords,
    required super.completionCount,
    required super.lastStudied,
    required super.isCompleted,
  });

  factory BlockProgressModel.fromJson(Map<String, dynamic> json) =>
      _$BlockProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlockProgressModelToJson(this);

  factory BlockProgressModel.fromEntity(BlockProgress entity) {
    return BlockProgressModel(
      blockId: entity.blockId,
      blockNumber: entity.blockNumber,
      level: entity.level,
      wordType: entity.wordType,
      startIndex: entity.startIndex,
      totalWords: entity.totalWords,
      completedWords: entity.completedWords,
      completionCount: entity.completionCount,
      lastStudied: entity.lastStudied,
      isCompleted: entity.isCompleted,
    );
  }

  BlockProgress toEntity() {
    return BlockProgress(
      blockId: blockId,
      blockNumber: blockNumber,
      level: level,
      wordType: wordType,
      startIndex: startIndex,
      totalWords: totalWords,
      completedWords: completedWords,
      completionCount: completionCount,
      lastStudied: lastStudied,
      isCompleted: isCompleted,
    );
  }

  @override
  BlockProgressModel copyWith({
    String? blockId,
    int? blockNumber,
    String? level,
    String? wordType,
    int? startIndex,
    int? totalWords,
    int? completedWords,
    int? completionCount,
    DateTime? lastStudied,
    bool? isCompleted,
  }) {
    return BlockProgressModel(
      blockId: blockId ?? this.blockId,
      blockNumber: blockNumber ?? this.blockNumber,
      level: level ?? this.level,
      wordType: wordType ?? this.wordType,
      startIndex: startIndex ?? this.startIndex,
      totalWords: totalWords ?? this.totalWords,
      completedWords: completedWords ?? this.completedWords,
      completionCount: completionCount ?? this.completionCount,
      lastStudied: lastStudied ?? this.lastStudied,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Generate block ID from parameters
  static String generateBlockId(String level, String? wordType, int blockNumber) {
    final type = wordType ?? 'all';
    return '${level}_${type}_$blockNumber';
  }
}
