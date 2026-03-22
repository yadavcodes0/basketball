import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../player_card.dart';

class FavoritesService {
  static const String _key = 'favorite_players';

  static Future<List<Player>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((json) => Player.fromJson(jsonDecode(json))).toList();
  }

  static Future<void> addFavorite(Player player) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    // Avoid duplicates
    final exists = jsonList.any((json) {
      final p = jsonDecode(json);
      return p['name'] == player.name;
    });
    if (!exists) {
      jsonList.add(jsonEncode(player.toJson()));
      await prefs.setStringList(_key, jsonList);
    }
  }

  static Future<void> removeFavorite(String playerName) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    jsonList.removeWhere((json) {
      final p = jsonDecode(json);
      return p['name'] == playerName;
    });
    await prefs.setStringList(_key, jsonList);
  }

  static Future<bool> isFavorite(String playerName) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.any((json) {
      final p = jsonDecode(json);
      return p['name'] == playerName;
    });
  }
}
