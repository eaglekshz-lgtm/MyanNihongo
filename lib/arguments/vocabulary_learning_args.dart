/// Arguments for VocabularyLearningPage
class VocabularyLearningArgs {
  final String level;
  final String? wordType;
  final String learningMode;
  final int? startIndex;
  final int? batchSize;

  const VocabularyLearningArgs({
    required this.level,
    this.wordType,
    required this.learningMode,
    this.startIndex,
    this.batchSize,
  });
}
