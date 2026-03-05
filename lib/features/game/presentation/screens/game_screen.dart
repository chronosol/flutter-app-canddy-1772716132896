import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:canddy_app/core/constants/app_constants.dart';
import 'package:canddy_app/features/game/domain/entities/candy.dart';
import 'package:canddy_app/features/game/presentation/controllers/game_controller.dart';
import 'package:canddy_app/features/game/presentation/widgets/candy_widget.dart';
import 'package:canddy_app/features/game/presentation/widgets/game_over_dialog.dart';
import 'package:canddy_app/features/game/presentation/widgets/game_status_widget.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int? _firstSelectedIndex;

  @override
  void initState() {
    super.initState();
    // Ensure game is initialized when screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameControllerProvider.notifier).startGame();
    });
  }

  void _handleCandyTap(int index) {
    if (_firstSelectedIndex == null) {
      setState(() {
        _firstSelectedIndex = index;
      });
    } else {
      // Second candy selected, attempt a move
      ref.read(gameControllerProvider.notifier).makeMove(_firstSelectedIndex!, index);
      setState(() {
        _firstSelectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameStateAsync = ref.watch(gameControllerProvider);

    ref.listen<AsyncValue<dynamic>>(gameControllerProvider, (previous, next) {
      if (next.hasValue && next.value?.isGameOver == true && previous?.value?.isGameOver == false) {
        // Game just ended, show dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GameOverDialog(
            score: next.value!.score,
            onPlayAgain: () {
              Navigator.of(context).pop();
              ref.read(gameControllerProvider.notifier).resetGame();
            },
            onGoHome: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Pop game screen
            },
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Canddy Crush',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: gameStateAsync.when(
                data: (gameState) => GameStatusWidget(
                  score: gameState.score,
                  movesLeft: gameState.movesLeft,
                ),
                loading: () => const GameStatusWidget(score: 0, movesLeft: 0),
                error: (err, stack) => Text('Error: $err'),
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppConstants.spacingMedium),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: gameStateAsync.when(
                      data: (gameState) {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: AppConstants.boardSize,
                            childAspectRatio: 1,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: AppConstants.boardSize * AppConstants.boardSize,
                          itemBuilder: (context, index) {
                            final Candy? candy = gameState.board.candies[index];
                            final bool isSelected = _firstSelectedIndex == index;
                            return GestureDetector(
                              onTap: () => _handleCandyTap(index),
                              child: CandyWidget(
                                candy: candy,
                                isSelected: isSelected,
                              ).animate(
                                key: ValueKey(candy?.id ?? 'empty_$index'), // Key for AnimatedSwitcher
                              ).scale(duration: AppConstants.candyAnimationDuration, curve: Curves.easeOutBack),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                            const SizedBox(height: AppConstants.spacingMedium),
                            Text(
                              'Failed to load game: $err',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: AppConstants.spacingMedium),
                            ElevatedButton(
                              onPressed: () => ref.read(gameControllerProvider.notifier).startGame(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
          ],
        ),
      ),
    );
  }
}
