import 'exceptions.dart';

/// Represents different types of failures that can occur in the app
abstract class Failure {
  final String message;
  final String? details;
  final int? statusCode;

  const Failure({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.message == message &&
        other.details == details &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => message.hashCode ^ details.hashCode ^ statusCode.hashCode;
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory ServerFailure.fromException(ServerException exception) {
    return ServerFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory AuthFailure.fromException(AuthException exception) {
    return AuthFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory ValidationFailure.fromException(ValidationException exception) {
    return ValidationFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// File failure
class FileFailure extends Failure {
  const FileFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory FileFailure.fromException(FileException exception) {
    return FileFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// Database failure
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory DatabaseFailure.fromException(DatabaseException exception) {
    return DatabaseFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory PermissionFailure.fromException(PermissionException exception) {
    return PermissionFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// Timeout failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory TimeoutFailure.fromException(TimeoutException exception) {
    return TimeoutFailure(
      message: exception.message,
      details: exception.details,
      statusCode: exception.statusCode,
    );
  }
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.details,
    super.statusCode,
  });

  factory UnknownFailure.fromException(Exception exception) {
    return UnknownFailure(
      message: exception.toString(),
    );
  }
}
