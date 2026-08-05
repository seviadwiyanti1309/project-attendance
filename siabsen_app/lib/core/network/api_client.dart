import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/token_manager.dart';
import 'api_exception.dart';

class ApiClient {
  final TokenManager tokenManager;
  ApiClient(this.tokenManager);

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = {'Accept': 'application/json'};
    if (withAuth) {
      final token = await tokenManager.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(String path, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path')
        .replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: await _headers());
    return _handleResponse(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body, {bool withAuth = true}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final headers = await _headers(withAuth: withAuth);
    headers['Content-Type'] = 'application/json';
    final response = await http.post(uri, headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> multipartPost(String path, Map<String, String> fields, String filePath, String fileFieldName) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _headers());
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath(fileFieldName, filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final headers = await _headers();
    headers['Content-Type'] = 'application/json';
    final response = await http.put(uri, headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final response = await http.delete(uri, headers: await _headers());
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw ApiException(decoded['message'] ?? 'Terjadi kesalahan', statusCode: response.statusCode);
    }
  }
}