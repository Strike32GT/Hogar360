import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/network/api_config.dart';
import '../../../core/session/app_session.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<void> login(String email, String password) async {
    await _postAuth(
      path: '/auth/login',
      body: {'email': email, 'password': password},
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _postAuth(
      path: '/auth/register',
      body: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<bool> validateStoredSession() async {
    final token = AppSession.instance.token;
    if (token == null) return false;

    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await _saveUserFromSession(response.body, token);
        return true;
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        await AppSession.instance.clear();
        return false;
      }
    } catch (_) {
      return true;
    }

    return AppSession.instance.isAuthenticated;
  }

  Future<void> _postAuth({
    required String path,
    required Map<String, String> body,
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await _saveSession(response.body);
      return;
    }

    throw AuthException(_extractMessage(response.body));
  }

  String _extractMessage(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } catch (_) {
      return 'No se pudo completar la operación.';
    }

    return 'No se pudo completar la operación.';
  }

  Future<void> _saveSession(String responseBody) async {
    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) return;

    final token = decoded['token'];
    final user = decoded['user'];
    if (token is! String || user is! Map<String, dynamic>) return;

    final name = user['name'];
    final email = user['email'];
    if (name is! String || email is! String) return;

    await AppSession.instance.setSession(
      token: token,
      name: name,
      email: email,
    );
  }

  Future<void> _saveUserFromSession(String responseBody, String token) async {
    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) return;

    final name = decoded['name'];
    final email = decoded['email'];
    if (name is! String || email is! String) return;

    await AppSession.instance.setSession(
      token: token,
      name: name,
      email: email,
    );
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}
