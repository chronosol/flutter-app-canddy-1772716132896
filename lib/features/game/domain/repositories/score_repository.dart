import 'package:canddy_app/features/game/domain/entities/score_entry.dart';

abstract class ScoreRepository {
  Future<List<ScoreEntry>> getHighScores();
  Future<void> addScore(ScoreEntry score);
  Future<void> clearHighScores();
}
