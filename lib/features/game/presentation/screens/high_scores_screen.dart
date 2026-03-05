import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:canddy_app/core/constants/app_constants.dart';
import 'package:canddy_app/features/game/presentation/controllers/score_controller.dart';

class HighScoresScreen extends ConsumerWidget {
  const HighScoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScoresAsync = ref.watch(scoreControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'High Scores',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        centerTitle: true,
      ),
      body: highScoresAsync.when(
        data: (scores) {
          if (scores.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events_outlined, size: 80, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: AppConstants.spacingMedium),
                  Text(
                    'No high scores yet!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Text(
                    'Play a game to set your first score.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final scoreEntry = scores[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      '${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ),
                  title: Text(
                    scoreEntry.playerName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().add_jm().format(scoreEntry.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Text(
                    '${scoreEntry.score}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
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
                'Failed to load scores: $err',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              ElevatedButton(
                onPressed: () => ref.invalidate(scoreControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: scoresAsync.whenOrNull(
        data: (scores) => scores.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear High Scores?'),
                      content: const Text('Are you sure you want to clear all high scores? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(scoreControllerProvider.notifier).clearScores();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                          child: const Text('Clear', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                label: const Text('Clear Scores'),
                icon: const Icon(Icons.delete_forever),
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              )
            : null,
      ),
    );
  }
}
