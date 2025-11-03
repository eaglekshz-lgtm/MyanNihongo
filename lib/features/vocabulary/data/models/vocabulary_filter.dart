class VocabularyFilter {
  final String level;
  final String? wordType;

  const VocabularyFilter({
    required this.level,
    this.wordType,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VocabularyFilter &&
        other.level == level &&
        other.wordType == wordType;
  }

  @override
  int get hashCode => level.hashCode ^ wordType.hashCode;
}