import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/network/api_config.dart';
import '../../../core/session/app_session.dart';
import '../models/tile_calculation.dart';
import '../models/tile_history_item.dart';

class TileHistoryService {
  TileHistoryService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<void> saveResult(TileCalculationResult result) async {
    final token = AppSession.instance.token;
    if (token == null) {
      throw TileHistoryException('Inicia sesión para guardar resultados.');
    }

    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/tiles/history'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'floorLength': result.floorLength,
        'floorWidth': result.floorWidth,
        'tileLength': result.tileLengthCm,
        'tileWidth': result.tileWidthCm,
        'tilesPerBox': result.tilesPerBox,
        'wastePercentage': result.wastePercentage,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TileHistoryException('No se pudo guardar el resultado.');
    }
  }

  Future<List<TileHistoryItem>> getHistory() async {
    final token = AppSession.instance.token;
    if (token == null) return [];

    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}/tiles/history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) return [];

    final decoded = jsonDecode(response.body);
    if (decoded is! List<dynamic>) return [];

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(TileHistoryItem.fromJson)
        .toList();
  }
}

class TileHistoryException implements Exception {
  const TileHistoryException(this.message);

  final String message;
}
