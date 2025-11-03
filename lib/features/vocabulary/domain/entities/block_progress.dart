import 'package:equatable/equatable.dart';

/// Domain entity representing progress for a vocabulary block
class BlockProgress extends Equatable {
  final String blockId; // Format: '{level}_{wordType}_{blockNumber}'
  final int blockNumber;
  final String level;
  final String? wordType;
  final int startIndex;
  final int totalWords;
  final int completedWords;
  final int completionCount; // Number of times this block has been completed
  final DateTime lastStudied;
  final bool isCompleted;

  const BlockProgress({
    required this.blockId,
    required this.blockNumber,
    required this.level,
    this.wordType,
    required this.startIndex,
    required this.totalWords,
    required this.completedWords,
    required this.completionCount,
    required this.lastStudied,
    required this.isCompleted,
  });

  double get progress {
    if (totalWords == 0) return 0.0;
    return completedWords / totalWords;
  }

  BlockProgress copyWith({
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
    return BlockProgress(
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

  @override
  List<Object?> get props => [
        blockId,
        blockNumber,
        level,
        wordType,
        startIndex,
        totalWords,
        completedWords,
        completionCount,
        lastStudied,
        isCompleted,
      ];
}
