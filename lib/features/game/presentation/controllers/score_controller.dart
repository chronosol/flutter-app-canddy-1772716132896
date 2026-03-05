import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:canddy_app/features/game/data/repositories/score_repository_impl.dart';
import 'package:canddy_app/features/game/domain/entities/score_entry.dart';

class ScoreController extends AsyncNotifier<List<ScoreEntry>> {
  @override
  Future<List<ScoreEntry>> build() async {
    return ref.read(scoreRepositoryProvider).getHighScores();
  }

  Future<void> addScore(ScoreEntry score) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(scoreRepositoryProvider).addScore(score);
        return ref.read(scoreRepositoryProvider).getHighScores();
      },
    );
  }

  Future<void> clearScores() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(scoreRepositoryProvider).clearHighScores();
        return [];
      },
    );
  }
}

final scoreControllerProvider = AsyncNotifierProvider<ScoreController, List<ScoreEntry>>(
  ScoreController.new,
);
