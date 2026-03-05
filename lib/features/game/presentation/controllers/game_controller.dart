import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:canddy_app/features/game/data/repositories/game_repository_impl.dart';
import 'package:canddy_app/features/game/domain/entities/game_state.dart';
import 'package:canddy_app/features/game/domain/entities/score_entry.dart';
import 'package:canddy_app/features/game/presentation/controllers/score_controller.dart';

class GameController extends AsyncNotifier<GameState> {
  @override
  Future<GameState> build() async {
    return ref.read(gameRepositoryProvider).initializeGame();
  }

  Future<void> startGame() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gameRepositoryProvider).initializeGame(),
    );
  }

  Future<void> makeMove(int index1, int index2) async {
    if (state.value == null || state.value!.isGameOver) return;

    final currentState = state.value!;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gameRepositoryProvider).makeMove(currentState, index1, index2),
    );

    if (state.value?.isGameOver == true) {
      _handleGameOver(state.value!); // Handle game over logic
    }
  }

  void _handleGameOver(GameState finalState) {
    // For simplicity, let's just add a score if it's greater than 0
    if (finalState.score > 0) {
      ref.read(scoreControllerProvider.notifier).addScore(
            ScoreEntry(
              playerName: 'Player',
              score: finalState.score,
              date: DateTime.now(),
            ),
          );
    }
  }

  // Method to reset game without re-initializing the controller
  Future<void> resetGame() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gameRepositoryProvider).initializeGame(),
    );
  }
}

final gameControllerProvider = AsyncNotifierProvider<GameController, GameState>(
  GameController.new,
);
