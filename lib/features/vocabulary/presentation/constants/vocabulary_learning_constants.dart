import 'package:flutter/material.dart';

class VocabularyLearningConstants {
  // Default Values
  static const String defaultLevel = 'N5';
  static const String defaultLearningMode = 'recall';

  // UI Constants
  static const double cardPadding = 32.0;
  static const double cardBorderRadius = 28.0;
  static const double japaneseFontSize = 62.0;
  static const double burmeseFontSize = 35.0;
  static const double readingFontSize = 18.0;
  static const double exampleFontSize = 18.0;

  // Animation Durations
  static const Duration flipDuration = Duration(milliseconds: 200);
  static const Duration snackBarDuration = Duration(milliseconds: 2500);
  static const Duration successAnimationDuration = Duration(milliseconds: 800);

  // Card Colors
  static const Color cardGradientStartColor = Color(0xFF4DB8FF);
  static const Color cardGradientEndColor = Color(0xFF2196F3);
  static const Color cardBackStartColor = Color(0xFF1E88E5);
  static const Color cardBackEndColor = Color(0xFF1565C0);

  // TTS Settings
  static const String japaneseLanguage = 'ja-JP';
  static const double ttsSpeechRate = 0.5;
  static const double ttsVolume = 1.0;
  static const double ttsPitch = 1.0;
}