import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _key = 'quiz_scores';

  static Future<void> saveScore({
    required String category,
    required String difficulty,
    required int score,
    required int total,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String timestamp = DateTime.now().toIso8601String();

    final scoreEntry = {
      'category': category,
      'difficulty': difficulty,
      'score': score,
      'total': total,
      'timestamp': timestamp,
    };

    final List<String> scores = prefs.getStringList(_key) ?? [];
    scores.add(json.encode(scoreEntry));
    await prefs.setStringList(_key, scores);
  }

  static Future<List<Map<String, dynamic>>> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scores = prefs.getStringList(_key) ?? [];
    return scores.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
