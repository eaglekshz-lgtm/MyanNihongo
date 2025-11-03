import 'package:flutter/foundation.dart';

/// Centralized logging utility for the application
/// 
/// Provides different log levels and automatic environment-based logging.
/// In production, only errors are logged. In debug mode, all levels are logged.
class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  /// Log level prefix for better readability
  static const String _debugPrefix = '🔍 DEBUG';
  static const String _infoPrefix = 'ℹ️ INFO';
  static const String _warningPrefix = '⚠️ WARNING';
  static const String _errorPrefix = '❌ ERROR';

  /// Log debug messages (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final taggedMessage = tag != null ? '[$tag] $message' : message;
      debugPrint('$_debugPrefix: $taggedMessage');
    }
  }

  /// Log informational messages (only in debug mode)
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final taggedMessage = tag != null ? '[$tag] $message' : message;
      debugPrint('$_infoPrefix: $taggedMessage');
    }
  }

  /// Log warning messages (only in debug mode)
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final taggedMessage = tag != null ? '[$tag] $message' : message;
      debugPrint('$_warningPrefix: $taggedMessage');
    }
  }

  /// Log error messages (logged in all modes)
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final taggedMessage = tag != null ? '[$tag] $message' : message;
    debugPrint('$_errorPrefix: $taggedMessage');
    
    if (error != null) {
      debugPrint('Error details: $error');
    }
    
    if (stackTrace != null && kDebugMode) {
      debugPrint('Stack trace:\n$stackTrace');
    }
  }

  /// Log network requests (only in debug mode)
  static void network(String message, {String? method, String? url}) {
    if (kDebugMode) {
      final methodPart = method != null ? '[$method] ' : '';
      final urlPart = url != null ? '$url: ' : '';
      debugPrint('🌐 NETWORK: $methodPart$urlPart$message');
    }
  }

  /// Log data operations (only in debug mode)
  static void data(String message, {String? operation}) {
    if (kDebugMode) {
      final opPart = operation != null ? '[$operation] ' : '';
      debugPrint('💾 DATA: $opPart$message');
    }
  }

  /// Log navigation events (only in debug mode)
  static void navigation(String message, {String? from, String? to}) {
    if (kDebugMode) {
      final route = from != null && to != null ? '$from → $to: ' : '';
      debugPrint('🧭 NAVIGATION: $route$message');
    }
  }

  /// Log performance metrics (only in debug mode)
  static void performance(String message, {Duration? duration}) {
    if (kDebugMode) {
      final durationPart = duration != null ? '(${duration.inMilliseconds}ms) ' : '';
      debugPrint('⚡ PERFORMANCE: $durationPart$message');
    }
  }
}
