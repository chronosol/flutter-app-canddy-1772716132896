import 'dart:convert';

import 'package:canddy/features/game/domain/entities/score_entry.dart';
import 'package:canddy/features/game/domain/repositories/score_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreRepositoryImpl implements ScoreRepository {
  static const String _highScoresKey = 'high_scores';

  @override
  Future<List<ScoreEntry>> getHighScores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? scoresJson = prefs.getStringList(_highScoresKey);

    if (scoresJson == null) {
      return [];
    }

    return scoresJson
        .map((jsonString) => ScoreEntry.fromJson(json.decode(jsonString) as Map<String, dynamic>))
        .toList()
        ..sort((a, b) => b.score.compareTo(a.score)); // Sort descending
  }

  @override
  Future<void> addHighScore(ScoreEntry score) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<ScoreEntry> currentScores = await getHighScores();

    currentScores.add(score);
    currentScores.sort((a, b) => b.score.compareTo(a.score)); // Sort descending

    // Keep only top N scores, e.g., top 10
    final List<ScoreEntry> topScores = currentScores.take(10).toList();

    final List<String> scoresJson =
        topScores.map((s) => json.encode(s.toJson())).toList();

    await prefs.setStringList(_highScoresKey, scoresJson);
  }

  @override
  Future<void> clearHighScores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoresKey);
  }
}
