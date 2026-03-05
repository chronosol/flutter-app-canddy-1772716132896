import 'dart:convert';

import 'package:canddy_app/features/game/domain/entities/score_entry.dart';
import 'package:canddy_app/features/game/domain/repositories/score_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreRepositoryImpl implements ScoreRepository {
  static const String _highScoresKey = 'high_scores';

  @override
  Future<List<ScoreEntry>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresJson = prefs.getString(_highScoresKey);
    if (scoresJson == null) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(scoresJson) as List<dynamic>;
    return jsonList.map((json) => ScoreEntry.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> addScore(ScoreEntry score) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ScoreEntry> currentScores = await getHighScores();
    currentScores.add(score);
    currentScores.sort((a, b) => b.score.compareTo(a.score)); // Sort descending

    // Keep only top 10 scores
    final List<ScoreEntry> topScores = currentScores.take(10).toList();

    final String scoresJson = jsonEncode(topScores.map((s) => s.toJson()).toList());
    await prefs.setString(_highScoresKey, scoresJson);
  }

  @override
  Future<void> clearHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoresKey);
  }
}

final scoreRepositoryProvider = Provider<ScoreRepository>((ref) => ScoreRepositoryImpl());
