import 'package:flutter/material.dart';

/// Base Controller for Professional State Management
///
/// Abstract base class providing common functionality for all controllers
/// following Clean Architecture principles and SOLID design patterns.
abstract class BaseController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  /// Loading state getter
  bool get isLoading => _isLoading;

  /// Error message getter
  String? get errorMessage => _errorMessage;

  /// Check if controller is disposed
  bool get isDisposed => _isDisposed;

  /// Set loading state
  @protected
  void setLoading(bool loading) {
    if (_isDisposed) return;

    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error message
  @protected
  void setError(String? error) {
    if (_isDisposed) return;

    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  /// Clear error
  @protected
  void clearError() {
    setError(null);
  }

  /// Execute operation with loading state and error handling
  @protected
  Future<T?> executeWithLoading<T>(Future<T> Function() operation) async {
    try {
      setLoading(true);
      clearError();

      final result = await operation();
      return result;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Handle errors consistently
  @protected
  void handleError(dynamic error, [StackTrace? stackTrace]) {
    debugPrint('Controller Error: $error');
    if (stackTrace != null) {
      debugPrint('Stack Trace: $stackTrace');
    }

    String errorMessage = _getErrorMessage(error);
    setError(errorMessage);

    // Log to crash reporting service
    // CrashReportingService.recordError(error, stackTrace);
  }

  /// Convert error to user-friendly message
  String _getErrorMessage(dynamic error) {
    if (error == null) return 'Unknown error occurred';

    // Handle common error types
    if (error is String) return error;

    // TODO: Add more specific error handling based on your error types
    return 'An unexpected error occurred. Please try again.';
  }

  /// Reset controller state
  @protected
  void reset() {
    if (_isDisposed) return;

    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Safe notification - only notify if not disposed
  @protected
  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Debug information
  @override
  String toString() {
    return '$runtimeType(loading: $_isLoading, error: $_errorMessage)';
  }
}
