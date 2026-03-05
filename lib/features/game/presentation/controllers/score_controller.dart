import 'package:canddy/features/game/domain/entities/score_entry.dart';
import 'package:canddy/features/game/domain/repositories/score_repository.dart';
import 'package:canddy/features/game/presentation/controllers/game_controller.dart'; // Import for scoreRepositoryProvider
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoreController extends AsyncNotifier<List<ScoreEntry>> {
  @override
  Future<List<ScoreEntry>> build() async {
    return ref.read(scoreRepositoryProvider).getHighScores();
  }

  Future<void> refreshScores() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(scoreRepositoryProvider).getHighScores(),
    );
  }

  Future<void> clearScores() async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(
      () => ref.read(scoreRepositoryProvider).clearHighScores(),
    );
    state = const AsyncValue.data([]);
  }
}

final scoreControllerProvider =
    AsyncNotifierProvider<ScoreController, List<ScoreEntry>>(
  ScoreController.new,
);
