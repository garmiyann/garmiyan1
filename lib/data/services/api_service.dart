import 'dart:convert';
import 'dart:io';
import '../../core/core.dart';

/// API service for handling HTTP requests
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final HttpClient _httpClient = HttpClient();

  /// Generic GET request
  Future<Result<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      final url = NetworkUtils.buildUrl(endpoint, queryParams: queryParams);
      final uri = Uri.parse(url);

      final request = await _httpClient.getUrl(uri);
      _addHeaders(request, token: token);

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ResultHelper.failure(NetworkFailure(message: e.toString()));
    }
  }

  /// Generic POST request
  Future<Result<Map<String, dynamic>>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final url = NetworkUtils.buildUrl(endpoint);
      final uri = Uri.parse(url);

      final request = await _httpClient.postUrl(uri);
      _addHeaders(request, token: token);

      if (data != null) {
        final jsonData = json.encode(data);
        request.add(utf8.encode(jsonData));
      }

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ResultHelper.failure(NetworkFailure(message: e.toString()));
    }
  }

  /// Generic PUT request
  Future<Result<Map<String, dynamic>>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final url = NetworkUtils.buildUrl(endpoint);
      final uri = Uri.parse(url);

      final request = await _httpClient.putUrl(uri);
      _addHeaders(request, token: token);

      if (data != null) {
        final jsonData = json.encode(data);
        request.add(utf8.encode(jsonData));
      }

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ResultHelper.failure(NetworkFailure(message: e.toString()));
    }
  }

  /// Generic DELETE request
  Future<Result<Map<String, dynamic>>> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final url = NetworkUtils.buildUrl(endpoint);
      final uri = Uri.parse(url);

      final request = await _httpClient.deleteUrl(uri);
      _addHeaders(request, token: token);

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ResultHelper.failure(NetworkFailure(message: e.toString()));
    }
  }

  /// Add headers to request
  void _addHeaders(HttpClientRequest request, {String? token}) {
    final headers = NetworkUtils.getDefaultHeaders(token: token);
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });
  }

  /// Handle HTTP response
  Future<Result<Map<String, dynamic>>> _handleResponse(
    HttpClientResponse response,
  ) async {
    try {
      final responseBody = await response.transform(utf8.decoder).join();

      if (NetworkUtils.isSuccessStatusCode(response.statusCode)) {
        final data = NetworkUtils.parseJsonResponse(responseBody);
        return data != null
            ? ResultHelper.success(data)
            : ResultHelper.failure(ServerFailure(
                message: 'Invalid response format',
                statusCode: response.statusCode,
              ));
      } else {
        final errorMessage = NetworkUtils.getErrorMessage(response.statusCode);
        if (NetworkUtils.isClientError(response.statusCode)) {
          return ResultHelper.failure(NetworkFailure(
            message: errorMessage,
            statusCode: response.statusCode,
          ));
        } else {
          return ResultHelper.failure(ServerFailure(
            message: errorMessage,
            statusCode: response.statusCode,
          ));
        }
      }
    } catch (e) {
      return ResultHelper.failure(UnknownFailure(message: e.toString()));
    }
  }

  /// Upload file
  Future<Result<Map<String, dynamic>>> uploadFile(
    String endpoint,
    File file, {
    String? token,
    Map<String, String>? additionalFields,
  }) async {
    try {
      final url = NetworkUtils.buildUrl(endpoint);
      final uri = Uri.parse(url);

      final request = await _httpClient.postUrl(uri);
      final headers = NetworkUtils.getMultipartHeaders(token: token);
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      // For multipart upload, you would typically use a package like http or dio
      // This is a simplified version
      final fileBytes = await file.readAsBytes();
      request.add(fileBytes);

      final response = await request.close();
      return await _handleResponse(response);
    } catch (e) {
      return ResultHelper.failure(NetworkFailure(message: e.toString()));
    }
  }

  /// Check connectivity
  Future<bool> checkConnectivity() async {
    return await NetworkUtils.hasInternetConnection();
  }

  /// Close HTTP client
  void dispose() {
    _httpClient.close();
  }
}
