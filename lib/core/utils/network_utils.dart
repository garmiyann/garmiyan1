import 'dart:convert';
import 'dart:io';

/// Network utility functions and constants
class NetworkUtils {
  NetworkUtils._();

  /// Base URLs
  static const String baseUrl = 'https://api.goldenprizma.com';
  static const String imageBaseUrl = 'https://images.goldenprizma.com';

  /// API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String profileEndpoint = '/user/profile';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/categories';
  static const String ordersEndpoint = '/orders';
  static const String cartEndpoint = '/cart';
  static const String wishlistEndpoint = '/wishlist';
  static const String notificationsEndpoint = '/notifications';

  /// HTTP Status Codes
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  /// Build full URL
  static String buildUrl(String endpoint, {Map<String, dynamic>? queryParams}) {
    final uri = Uri.parse('$baseUrl$endpoint');

    if (queryParams != null && queryParams.isNotEmpty) {
      return uri
          .replace(
              queryParameters: queryParams.map(
            (key, value) => MapEntry(key, value.toString()),
          ))
          .toString();
    }

    return uri.toString();
  }

  /// Build image URL
  static String buildImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) return imagePath;
    return '$imageBaseUrl/$imagePath';
  }

  /// Get default headers
  static Map<String, String> getDefaultHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Get multipart headers
  static Map<String, String> getMultipartHeaders({String? token}) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Parse JSON response safely
  static Map<String, dynamic>? parseJsonResponse(String responseBody) {
    try {
      return json.decode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Check if status code is successful
  static bool isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if status code indicates client error
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if status code indicates server error
  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }

  /// Get error message from status code
  static String getErrorMessage(int statusCode) {
    switch (statusCode) {
      case badRequest:
        return 'Bad request. Please check your input.';
      case unauthorized:
        return 'Unauthorized. Please login again.';
      case forbidden:
        return 'Access forbidden. You don\'t have permission.';
      case notFound:
        return 'Resource not found.';
      case methodNotAllowed:
        return 'Method not allowed.';
      case conflict:
        return 'Conflict occurred. Resource already exists.';
      case unprocessableEntity:
        return 'Invalid data provided.';
      case tooManyRequests:
        return 'Too many requests. Please try again later.';
      case internalServerError:
        return 'Internal server error. Please try again.';
      case badGateway:
        return 'Bad gateway. Server is unavailable.';
      case serviceUnavailable:
        return 'Service unavailable. Please try again later.';
      case gatewayTimeout:
        return 'Gateway timeout. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  /// Check internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Validate URL format
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Extract domain from URL
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  /// Build query string from parameters
  static String buildQueryString(Map<String, dynamic> params) {
    if (params.isEmpty) return '';

    final queries = params.entries
        .where((entry) => entry.value != null)
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    return queries.isNotEmpty ? '?$queries' : '';
  }

  /// Get file size from URL
  static Future<int?> getFileSize(String url) async {
    try {
      final client = HttpClient();
      final request = await client.headUrl(Uri.parse(url));
      final response = await request.close();
      client.close();

      return response.contentLength;
    } catch (e) {
      return null;
    }
  }

  /// Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}
