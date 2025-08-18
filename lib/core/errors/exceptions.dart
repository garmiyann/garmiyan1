/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? details;
  final int? statusCode;

  const AppException({
    required this.message,
    this.details,
    this.statusCode,
  });

  @override
  String toString() {
    if (details != null) {
      return '$message: $details';
    }
    return message;
  }
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// Server related exceptions
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// Validation related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// Cache related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// File operation related exceptions
class FileException extends AppException {
  const FileException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// Database related exceptions
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// Permission related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// Timeout related exceptions
class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.details,
    super.statusCode,
  });
}

/// Unknown/Unexpected exceptions
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.details,
    super.statusCode,
  });
}
