import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../player_card.dart';
import '../data/player_data.dart';

class BasketballApiService {
  static String get _baseUrl {
    if (kIsWeb) {
      // Automatically uses the Vercel URL in production, or localhost port in debug web
      return '${Uri.base.origin}/api';
    }
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8000/api';
    } catch (e) {}
    return 'http://127.0.0.1:8000/api';
  }

  /// Search players by name via Python Backend
  static Future<List<Player>> searchPlayers(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse('$_baseUrl/search?q=${Uri.encodeComponent(query)}');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          return _searchFallback(query);
        }

        return data.map((jsonItem) => Player.fromJson(jsonItem)).toList();
      } else {
        debugPrint('Failed backend search: ${response.statusCode} - ${response.body}');
        return _searchFallback(query);
      }
    } catch (e) {
      debugPrint('Error searching players via backend: $e');
      return _searchFallback(query);
    }
  }

  static Future<List<Player>> fetchPlayers({
    int teamId = 145,
    String season = "2023-2024",
  }) async {
    return getFallbackPlayers();
  }

  static List<Player> _searchFallback(String query) {
    final lowerQuery = query.toLowerCase();
    return fallbackPlayers
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.team.toLowerCase().contains(lowerQuery) ||
            p.position.toLowerCase().contains(lowerQuery))
        .toList();
  }

  static List<Player> getFallbackPlayers() {
    return fallbackPlayers;
  }
}
