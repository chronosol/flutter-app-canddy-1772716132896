import 'package:canddy/features/game/domain/entities/score_entry.dart';

abstract class ScoreRepository {
  Future<List<ScoreEntry>> getHighScores();
  Future<void> addHighScore(ScoreEntry score);
  Future<void> clearHighScores();
}
