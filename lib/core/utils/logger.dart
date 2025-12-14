import 'package:flutter/foundation.dart';

/// Centralized logging utility for the application
///
/// Provides different log levels and automatic environment-based logging.
/// In production, only errors are logged. In debug mode, all levels are logged.
class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  /// Enable/disable colored output (set to false if your IDE doesn't support ANSI colors)
  /// Most IDE debug consoles (VS Code, Android Studio) don't support ANSI colors
  /// Set to true if running in a terminal that supports colors
  static bool enableColors = false;

  // ANSI color codes for terminal output
  static const String _reset = '\x1B[0m';
  static const String _blue = '\x1B[34m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _cyan = '\x1B[36m';
  static const String _magenta = '\x1B[35m';
  static const String _white = '\x1B[37m';
  static const String _brightYellow = '\x1B[93m';

  /// Helper method to apply color if enabled
  static String _colorize(String message, String colorCode) {
    return enableColors ? '$colorCode$message$_reset' : message;
  }

  /// Log level prefix for better readability
  static const String _debugPrefix = '🔍 DEBUG';
  static const String _infoPrefix = 'ℹ️ INFO';
  static const String _warningPrefix = '⚠️ WARNING';
  static const String _errorPrefix = '❌ ERROR';

  /// Log debug messages (only in debug mode) - BLUE
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final taggedMessage = tag != null ? '[$tag] $message' : message;
      debugPrint(_colorize('$_debugPrefix: $taggedMessage', _blue));
    }
  }

  /// Log informational messages (only in debug mode) - GREEN
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final taggedMessage = tag != null ? '[$tag] $message' : message;
      debugPrint(_colorize('$_infoPrefix: $taggedMessage', _green));
    }
  }

  /// Log warning messages (only in debug mode) - YELLOW
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final taggedMessage = tag != null ? '[$tag] $message' : message;
      debugPrint(_colorize('$_warningPrefix: $taggedMessage', _yellow));
    }
  }

  /// Log error messages (logged in all modes) - RED
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final taggedMessage = tag != null ? '[$tag] $message' : message;
    debugPrint(_colorize('$_errorPrefix: $taggedMessage', _red));

    if (error != null) {
      debugPrint(_colorize('Error details: $error', _red));
    }

    if (stackTrace != null && kDebugMode) {
      debugPrint(_colorize('Stack trace:\n$stackTrace', _red));
    }
  }

  /// Log network requests (only in debug mode) - MAGENTA
  static void network(String message, {String? method, String? url}) {
    if (kDebugMode) {
      final methodPart = method != null ? '[$method] ' : '';
      final urlPart = url != null ? '$url: ' : '';
      debugPrint(
        _colorize('🌐 NETWORK: $methodPart$urlPart$message', _magenta),
      );
    }
  }

  /// Log data operations (only in debug mode) - CYAN
  static void data(String message, {String? operation}) {
    if (kDebugMode) {
      final opPart = operation != null ? '[$operation] ' : '';
      debugPrint(_colorize('💾 DATA: $opPart$message', _cyan));
    }
  }

  /// Log navigation events (only in debug mode) - WHITE
  static void navigation(String message, {String? from, String? to}) {
    if (kDebugMode) {
      final route = from != null && to != null ? '$from → $to: ' : '';
      debugPrint(_colorize('🧭 NAVIGATION: $route$message', _white));
    }
  }

  /// Log performance metrics (only in debug mode) - BRIGHT YELLOW
  static void performance(String message, {Duration? duration}) {
    if (kDebugMode) {
      final durationPart = duration != null
          ? '(${duration.inMilliseconds}ms) '
          : '';
      debugPrint(
        _colorize('⚡ PERFORMANCE: $durationPart$message', _brightYellow),
      );
    }
  }
}
