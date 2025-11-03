import 'package:equatable/equatable.dart';

/// Base class for all application failures
abstract class Failure extends Equatable {
  const Failure({required this.message, this.details});

  /// Human-readable error message
  final String message;

  /// Additional error details (optional)
  final String? details;

  @override
  List<Object?> get props => [message, details];
}

/// Failure related to server/API issues
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.details,
    this.statusCode,
  });

  /// HTTP status code (if applicable)
  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Failure related to network connectivity
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.details,
  });
}

/// Failure related to caching operations
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.details,
  });
}

/// Failure related to data parsing/validation
class DataFailure extends Failure {
  const DataFailure({
    required super.message,
    super.details,
  });
}

/// Failure when requested data is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.details,
  });
}

/// Failure related to user permissions or authentication
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.details,
  });
}

/// Unexpected failure that doesn't fit other categories
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.details,
  });
}