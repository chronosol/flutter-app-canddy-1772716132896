import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example of a simple setting, not actually implemented with persistence
    final bool isSoundEnabled = true; // Placeholder

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sound Effects',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: isSoundEnabled,
                    onChanged: (bool value) {
                      // In a real app, you'd update a provider/repository here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sound effects ${value ? 'enabled' : 'disabled'} (placeholder)'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Add more settings here
        ],
      ),
    );
  }
}
