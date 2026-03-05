import 'package:flutter/material.dart';
import 'package:canddy_app/core/constants/app_constants.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent dismissing with back button
      child: AlertDialog(
        title: Text(
          'Game Over!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 60, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: AppConstants.spacingMedium),
            Text(
              'Your Score:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '$score',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Text(
              'Better luck next time!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: onGoHome,
            child: const Text('Go Home'),
          ),
          ElevatedButton(
            onPressed: onPlayAgain,
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
