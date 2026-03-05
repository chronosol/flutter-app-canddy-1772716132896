import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final String message;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.message,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        'Game Over!',
        style: textTheme.headlineSmall?.copyWith(color: colorScheme.error),
        textAlign: TextAlign.center,
      ).animate().shake(duration: 500.ms),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 60, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            message,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Final Score: $score',
            style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
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
      actionsAlignment: MainAxisAlignment.spaceAround,
    ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack);
  }
}
