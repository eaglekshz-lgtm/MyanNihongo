/// Custom exceptions for the application
///
/// These exceptions provide better error context and debugging information
/// compared to generic Dart exceptions.
library;

/// Exception thrown when a server request fails
/// 
/// Includes HTTP status code and optional error details for debugging.
class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
    this.details,
  });

  final String message;
  final int? statusCode;
  final String? details;

  @override
  String toString() {
    final buffer = StringBuffer('ServerException: $message');
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    if (details != null && details!.isNotEmpty) {
      buffer.write(' - $details');
    }
    return buffer.toString();
  }
}

/// Exception thrown when network connectivity fails
/// 
/// Used for connectivity issues, timeouts, or DNS failures.
class NetworkException implements Exception {
  const NetworkException({
    required this.message,
    this.details,
  });

  final String message;
  final String? details;

  @override
  String toString() {
    final buffer = StringBuffer('NetworkException: $message');
    if (details != null && details!.isNotEmpty) {
      buffer.write(' - $details');
    }
    return buffer.toString();
  }
}

/// Exception thrown when local cache operations fail
/// 
/// Includes Hive storage errors, file system errors, etc.
class CacheException implements Exception {
  const CacheException({
    required this.message,
    this.details,
  });

  final String message;
  final String? details;

  @override
  String toString() {
    final buffer = StringBuffer('CacheException: $message');
    if (details != null && details!.isNotEmpty) {
      buffer.write(' - $details');
    }
    return buffer.toString();
  }
}

/// Exception thrown when data parsing or validation fails
/// 
/// Used for JSON parsing errors, data format issues, etc.
class DataException implements Exception {
  const DataException({
    required this.message,
    this.details,
  });

  final String message;
  final String? details;

  @override
  String toString() {
    final buffer = StringBuffer('DataException: $message');
    if (details != null && details!.isNotEmpty) {
      buffer.write(' - $details');
    }
    return buffer.toString();
  }
}

/// Exception thrown when a requested resource is not found
/// 
/// Used for 404 errors, missing vocabulary items, etc.
class NotFoundException implements Exception {
  const NotFoundException({
    required this.message,
    this.details,
  });

  final String message;
  final String? details;

  @override
  String toString() {
    final buffer = StringBuffer('NotFoundException: $message');
    if (details != null && details!.isNotEmpty) {
      buffer.write(' - $details');
    }
    return buffer.toString();
  }
}

/// Exception thrown when authentication or authorization fails
/// 
/// Used for login failures, expired tokens, permission errors, etc.
class AuthException implements Exception {
  const AuthException({
    required this.message,
    this.details,
  });

  final String message;
  final String? details;

  @override
  String toString() {
    final buffer = StringBuffer('AuthException: $message');
    if (details != null && details!.isNotEmpty) {
      buffer.write(' - $details');
    }
    return buffer.toString();
  }
}

/// Exception thrown for unexpected or unhandled errors
/// 
/// Fallback exception when the error type is not recognized.
class UnknownException implements Exception {
  const UnknownException({
    required this.message,
    this.details,
  });

  final String message;
  final String? details;

  @override
  String toString() {
    final buffer = StringBuffer('UnknownException: $message');
    if (details != null && details!.isNotEmpty) {
      buffer.write(' - $details');
    }
    return buffer.toString();
  }
}