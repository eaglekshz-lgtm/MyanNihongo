/// Enum for JLPT difficulty levels
enum JLPTLevel {
  n5('N5', 'JLPT N5', 1),
  n4('N4', 'JLPT N4', 2),
  n3('N3', 'JLPT N3', 3),
  n2('N2', 'JLPT N2', 4),
  n1('N1', 'JLPT N1', 5);

  const JLPTLevel(this.code, this.displayName, this.level);

  /// Short code (e.g., 'N5')
  final String code;

  /// Display name (e.g., 'JLPT N5')
  final String displayName;

  /// Numeric level (1 = easiest, 5 = hardest)
  final int level;

  /// Get JLPTLevel from code string
  static JLPTLevel? fromCode(String? code) {
    if (code == null) return null;
    try {
      return JLPTLevel.values.firstWhere(
        (level) => level.code.toLowerCase() == code.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get JLPTLevel from display name
  static JLPTLevel? fromDisplayName(String displayName) {
    try {
      return JLPTLevel.values.firstWhere(
        (level) => level.displayName == displayName,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all level codes
  static List<String> get allCodes => JLPTLevel.values.map((e) => e.code).toList();

  /// Get all display names
  static List<String> get allDisplayNames => 
      JLPTLevel.values.map((e) => e.displayName).toList();

  /// Default level
  static JLPTLevel get defaultLevel => JLPTLevel.n5;
}

/// Enum for card styles
/// Currently supports 'quizMode' and 'studyMode'
/// 'quizMode' - Shows Japanese word on front, flip to reveal Burmese and reading (quiz yourself)
/// 'recallMode' - Test yourself by recalling information (quiz-style learning)
/// 'absorbMode' - Absorb information with all content visible (comprehensive study)
/// Default is 'recallMode'
enum CardStyle {
  recallMode('recall', 'Recall Mode'),
  absorbMode('absorb', 'Absorb Mode');

  const CardStyle(this.code, this.displayName);

  /// Code used in data storage (e.g., 'flip')
  final String code;

  /// Display name for UI (e.g., 'Flip Card')
  final String displayName;

  /// Get CardStyle from code string
  static CardStyle? fromCode(String? code) {
    if (code == null) return null;
    try {
      return CardStyle.values.firstWhere(
        (style) => style.code == code,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all card style codes
  static List<String> get allCodes => CardStyle.values.map((e) => e.code).toList();

  /// Default card style
  static CardStyle get defaultStyle => CardStyle.recallMode;
}

/// Enum for quiz types
enum QuizType {
  kanjiToHiragana('kanji_to_hiragana', 'Kanji to Hiragana', 
      'Choose the correct hiragana reading for the given kanji'),
  hiraganaToKanji('hiragana_to_kanji', 'Hiragana to Kanji',
      'Choose the correct kanji for the given hiragana');

  const QuizType(this.code, this.displayName, this.description);

  /// Code used in data storage (e.g., 'kanji_to_hiragana')
  final String code;

  /// Display name for UI (e.g., 'Kanji to Hiragana')
  final String displayName;

  /// Description of the quiz type
  final String description;

  /// Get QuizType from code string
  static QuizType? fromCode(String? code) {
    if (code == null) return null;
    try {
      return QuizType.values.firstWhere(
        (type) => type.code == code,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all quiz type codes
  static List<String> get allCodes => QuizType.values.map((e) => e.code).toList();

  /// Default quiz type
  static QuizType get defaultType => QuizType.kanjiToHiragana;
}

/// Extension methods for nullable JLPTLevel
extension JLPTLevelExtension on JLPTLevel? {
  /// Convert to code string, returning null if null
  String? get toCodeOrNull => this?.code;

  /// Convert to code string, returning default if null
  String get toCode => this?.code ?? JLPTLevel.defaultLevel.code;
}

/// Extension methods for nullable QuizType
extension QuizTypeExtension on QuizType? {
  /// Convert to code string, returning null if null
  String? get toCodeOrNull => this?.code;

  /// Convert to code string, returning default if null
  String get toCode => this?.code ?? QuizType.defaultType.code;
}
