/// Arguments for BatchSelectionPage
class BatchSelectionArgs {
  final String level;
  final String? wordType;
  final String learningMode;
  final int blockSize;

  const BatchSelectionArgs({
    required this.level,
    this.wordType,
    required this.learningMode,
    required this.blockSize,
  });
}
