import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiException({
    required this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() => 'ApiException ($statusCode): $message';
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String baseUrl = 'https://api-a5ebkn24va-el.a.run.app';
  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  String? get authToken => _authToken;

  Map<String, String> _buildHeaders([Map<String, String>? extraHeaders]) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_authToken != null && _authToken!.isNotEmpty)
        'Authorization': 'Bearer $_authToken',
    };
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  Future<dynamic> get(String path, {Map<String, String>? headers, Duration timeout = const Duration(seconds: 15)}) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await http.get(uri, headers: _buildHeaders(headers)).timeout(timeout);
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(statusCode: 0, message: 'Network error: $e');
    }
  }

  Future<dynamic> post(String path, {dynamic body, Map<String, String>? headers, Duration timeout = const Duration(seconds: 15)}) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await http.post(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(timeout);
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(statusCode: 0, message: 'Network error: $e');
    }
  }

  Future<dynamic> patch(String path, {dynamic body, Map<String, String>? headers, Duration timeout = const Duration(seconds: 15)}) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await http.patch(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(timeout);
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(statusCode: 0, message: 'Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic bodyData;
    try {
      if (response.body.isNotEmpty) {
        bodyData = jsonDecode(response.body);
      }
    } catch (_) {
      bodyData = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return bodyData;
    } else {
      String errorMessage = 'Request failed with status ${response.statusCode}';
      if (bodyData is Map && bodyData['error'] != null) {
        final err = bodyData['error'];
        errorMessage = err is Map ? (err['message'] ?? errorMessage) : err.toString();
      }
      throw ApiException(
        statusCode: response.statusCode,
        message: errorMessage,
        data: bodyData,
      );
    }
  }
}
