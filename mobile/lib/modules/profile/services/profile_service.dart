import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/network/api_config.dart';
import '../../../core/session/app_session.dart';
import '../models/profile_summary.dart';

class ProfileService {
  ProfileService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<ProfileSummary> getSummary() async {
    final token = AppSession.instance.token;
    if (token == null) {
      return const ProfileSummary(
        calculationsCount: 0,
        completionPercentage: 0,
      );
    }

    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}/tiles/summary'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return const ProfileSummary(
        calculationsCount: 0,
        completionPercentage: 0,
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return const ProfileSummary(
        calculationsCount: 0,
        completionPercentage: 0,
      );
    }

    return ProfileSummary.fromJson(decoded);
  }

  Future<String> updateName(String name) async {
    final token = AppSession.instance.token;
    if (token == null) {
      throw ProfileException('Inicia sesión para editar tu perfil.');
    }

    final response = await _client.patch(
      Uri.parse('${ApiConfig.baseUrl}/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProfileException('No se pudo actualizar el nombre.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['name'] is! String) {
      throw ProfileException('No se pudo actualizar el nombre.');
    }

    final updatedName = decoded['name'] as String;
    await AppSession.instance.updateUserName(updatedName);
    return updatedName;
  }
}

class ProfileException implements Exception {
  const ProfileException(this.message);

  final String message;
}
