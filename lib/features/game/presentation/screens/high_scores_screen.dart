import 'package:canddy/features/game/domain/entities/score_entry.dart';
import 'package:canddy/features/game/presentation/controllers/score_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HighScoresScreen extends ConsumerWidget {
  const HighScoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ScoreEntry>> highScoresAsync = ref.watch(scoreControllerProvider);
    final scoreController = ref.read(scoreControllerProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => scoreController.refreshScores(),
            tooltip: 'Refresh Scores',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => _confirmClearScores(context, scoreController),
            tooltip: 'Clear All Scores',
          ),
        ],
      ),
      body: highScoresAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Failed to load scores: $err', style: textTheme.bodyLarge),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => scoreController.refreshScores(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (scores) {
          if (scores.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events_outlined, size: 80, color: colorScheme.primary),
                  const SizedBox(height: 24),
                  Text(
                    'No high scores yet!',
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Play a game to set your first score.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/game'),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Playing'),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      '#${index + 1}',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    score.playerName,
                    style: textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    'Score: ${score.score}',
                    style: textTheme.bodyMedium,
                  ),
                  trailing: Text(
                    score.formattedDate,
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms).slideX(begin: -0.1, end: 0);
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmClearScores(BuildContext context, ScoreController scoreController) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Clear High Scores?'),
          content: const Text('Are you sure you want to clear all high scores? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Clear', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await scoreController.clearScores();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('High scores cleared!')),
        );
      }
    }
  }
}
