import '../errors/failures.dart' as failures;

/// A type that represents either a success or failure result
abstract class Result<T> {
  const Result();

  /// Returns true if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is ResultFailure<T>;

  /// Fold the result into a single value
  R fold<R>(R Function(failures.Failure failure) onFailure,
      R Function(T value) onSuccess) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    } else {
      return onFailure((this as ResultFailure<T>).failure);
    }
  }

  /// Transform the success value
  Result<R> map<R>(R Function(T value) transform) {
    if (this is Success<T>) {
      try {
        return Success(transform((this as Success<T>).value));
      } catch (e) {
        return ResultFailure(failures.UnknownFailure(message: e.toString()));
      }
    } else {
      return ResultFailure((this as ResultFailure<T>).failure);
    }
  }

  /// Chain async operations
  Future<Result<R>> flatMap<R>(
      Future<Result<R>> Function(T value) transform) async {
    if (this is Success<T>) {
      try {
        return await transform((this as Success<T>).value);
      } catch (e) {
        return ResultFailure(failures.UnknownFailure(message: e.toString()));
      }
    } else {
      return ResultFailure((this as ResultFailure<T>).failure);
    }
  }

  /// Get the value if success, otherwise return null
  T? get valueOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return null;
  }

  /// Get the failure if failure, otherwise return null
  failures.Failure? get failureOrNull {
    if (this is ResultFailure<T>) {
      return (this as ResultFailure<T>).failure;
    }
    return null;
  }

  /// Get the value if success, otherwise throw the failure
  T get value {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    } else {
      throw (this as ResultFailure<T>).failure;
    }
  }
}

/// Represents a successful result
class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Represents a failed result
class ResultFailure<T> extends Result<T> {
  final failures.Failure failure;

  const ResultFailure(this.failure);

  @override
  String toString() => 'ResultFailure($failure)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResultFailure<T> && other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;
}

/// Extension methods for easier Result creation
extension ResultExtensions<T> on T {
  /// Wrap value in Success
  Result<T> get success => Success(this);
}

extension FailureExtensions on failures.Failure {
  /// Wrap failure in Result
  Result<T> failure<T>() => ResultFailure<T>(this);
}

/// Helper functions for creating Results
class ResultHelper {
  ResultHelper._();

  /// Create success result
  static Result<T> success<T>(T value) => Success(value);

  /// Create failure result
  static Result<T> failure<T>(failures.Failure failure) =>
      ResultFailure<T>(failure);

  /// Try to execute a function and return Result
  static Result<T> tryCall<T>(T Function() function) {
    try {
      return Success(function());
    } catch (e) {
      return ResultFailure(failures.UnknownFailure(message: e.toString()));
    }
  }

  /// Try to execute an async function and return Result
  static Future<Result<T>> tryCallAsync<T>(
      Future<T> Function() function) async {
    try {
      final result = await function();
      return Success(result);
    } catch (e) {
      return ResultFailure(failures.UnknownFailure(message: e.toString()));
    }
  }
}
