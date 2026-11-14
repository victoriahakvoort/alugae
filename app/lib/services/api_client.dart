import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_config.dart';
import '../core/constants/app_strings.dart';

/// Erro vindo da API, já com uma mensagem pronta para a tela.
class ApiException implements Exception {
  ApiException(
    this.message, {
    this.statusCode,
    this.fieldErrors = const <String, String>{},
  });

  final String message;
  final int? statusCode;

  /// Erros de validação (422), por campo: `{'name': 'The name field is required.'}`.
  final Map<String, String> fieldErrors;

  @override
  String toString() => message;
}

/// Cliente HTTP da API Laravel.
///
/// Todos os services passam por aqui: o token é enviado em toda requisição,
/// e as respostas de erro viram [ApiException].
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  static const String _tokenKey = 'auth_token';

  final http.Client _http = http.Client();
  String? _token;

  /// Chamado quando a API responde 401 (token inválido ou expirado).
  void Function()? onUnauthorized;

  bool get hasToken => _token != null;

  Future<void> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    _token = token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    _token = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<dynamic> get(String path) => _send('GET', path);

  Future<dynamic> post(String path, [Map<String, dynamic>? body]) =>
      _send('POST', path, body);

  Future<dynamic> put(String path, Map<String, dynamic> body) =>
      _send('PUT', path, body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final http.Request request =
        http.Request(method, Uri.parse('${ApiConfig.baseUrl}$path'))
          ..headers.addAll(<String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (_token != null) 'Authorization': 'Bearer $_token',
          });

    if (body != null) request.body = jsonEncode(body);

    final http.Response response;
    try {
      final http.StreamedResponse streamed = await _http
          .send(request)
          .timeout(ApiConfig.timeout);
      response = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw ApiException(AppStrings.errorTimeout);
    } on Exception {
      throw ApiException(AppStrings.errorConnection);
    }

    // utf8.decode garante os acentos ("Painéis") certos.
    final dynamic data = response.bodyBytes.isEmpty
        ? null
        : jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    if (response.statusCode == 401 && _token != null) {
      await clearToken();
      onUnauthorized?.call();
    }

    throw _toException(response.statusCode, data);
  }

  ApiException _toException(int statusCode, dynamic data) {
    final Map<String, String> fieldErrors = <String, String>{};

    if (data is Map<String, dynamic> &&
        data['errors'] is Map<String, dynamic>) {
      (data['errors'] as Map<String, dynamic>).forEach((field, value) {
        if (value is List && value.isNotEmpty) {
          fieldErrors[field] = value.first.toString();
        }
      });
    }

    final String message;
    if (statusCode == 401) {
      message = AppStrings.errorUnauthorized;
    } else if (fieldErrors.isNotEmpty) {
      message = fieldErrors.values.first;
    } else {
      message = AppStrings.errorGeneric;
    }

    return ApiException(
      message,
      statusCode: statusCode,
      fieldErrors: fieldErrors,
    );
  }
}
