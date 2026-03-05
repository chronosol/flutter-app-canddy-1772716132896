import 'package:canddy/core/constants/app_constants.dart';
import 'package:canddy/features/game/domain/entities/candy.dart';
import 'package:canddy/features/game/domain/entities/game_board.dart';
import 'package:canddy/features/game/domain/entities/game_state.dart';
import 'package:canddy/features/game/presentation/controllers/game_controller.dart';
import 'package:canddy/features/game/presentation/widgets/candy_widget.dart';
import 'package:canddy/features/game/presentation/widgets/game_over_dialog.dart';
import 'package:canddy/features/game/presentation/widgets/game_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GameBoard> gameBoardAsync = ref.watch(gameControllerProvider);
    final GameState gameState = ref.watch(gameStateProvider);
    final Candy? selectedCandy = ref.watch(selectedCandyProvider);
    final gameController = ref.read(gameControllerProvider.notifier);

    ref.listen<GameState>(gameStateProvider, (previous, next) {
      if (next.status == GameStatus.gameOver) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return GameOverDialog(
              score: next.score,
              message: next.message ?? 'Game Over!',
              onPlayAgain: () {
                Navigator.of(dialogContext).pop();
                gameController.startGame();
              },
              onGoHome: () {
                Navigator.of(dialogContext).pop();
                context.go('/home');
              },
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canddy Crush'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GameStatusWidget(
              score: gameState.score,
              movesLeft: gameState.movesLeft,
              statusMessage: gameState.message,
            ),
            Expanded(
              child: Center(
                child: gameBoardAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                  data: (gameBoard) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final double boardSize =
                            min(constraints.maxWidth, constraints.maxHeight * 0.8);
                        final double candySize = boardSize / AppConstants.boardSize;

                        return Container(
                          width: boardSize,
                          height: boardSize,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4,
                            ),
                          ),
                          child: Stack(
                            children: [
                              for (int r = 0; r < AppConstants.boardSize; r++)
                                for (int c = 0; c < AppConstants.boardSize; c++)
                                  if (gameBoard.board[r][c] != null)
                                    AnimatedPositioned(
                                      key: ValueKey(gameBoard.board[r][c]!.id), // Key for animation
                                      duration: const Duration(milliseconds: 300), // Fall duration
                                      curve: Curves.easeOutQuad,
                                      left: c * candySize,
                                      top: r * candySize,
                                      width: candySize,
                                      height: candySize,
                                      child: GestureDetector(
                                        onTap: () => gameController.selectCandy(
                                            gameBoard.board[r][c]!),
                                        child: CandyWidget(
                                          candy: gameBoard.board[r][c]!,
                                          isSelected: selectedCandy?.id ==
                                              gameBoard.board[r][c]?.id,
                                          candySize: candySize,
                                        ).animate(
                                          key: ValueKey('candy_appear_${gameBoard.board[r][c]!.id}'), // Unique key for appearance animation
                                        ).fadeIn(duration: 200.ms).scale(begin: 0.8, end: 1.0),
                                      ),
                                    ),
                            ],
                          ),
                        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack);
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: gameState.status == GameStatus.playing || gameState.status == GameStatus.gameOver
                    ? () => gameController.startGame()
                    : null,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart Game'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
