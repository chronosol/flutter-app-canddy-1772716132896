import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameStatusWidget extends StatelessWidget {
  final int score;
  final int movesLeft;
  final String? statusMessage;

  const GameStatusWidget({
    super.key,
    required this.score,
    required this.movesLeft,
    this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusItem(
                  context,
                  Icons.score,
                  'Score',
                  score.toString(),
                  colorScheme.primary,
                ),
                _buildStatusItem(
                  context,
                  Icons.swap_horiz,
                  'Moves',
                  movesLeft.toString(),
                  movesLeft <= 5 ? colorScheme.error : colorScheme.secondary,
                ),
              ],
            ),
            if (statusMessage != null && statusMessage!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                statusMessage!,
                style: textTheme.titleMedium?.copyWith(
                  color: statusMessage!.contains('Game Over') ? colorScheme.error : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
      BuildContext context, IconData icon, String label, String value, Color color) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(color: color),
        ),
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
