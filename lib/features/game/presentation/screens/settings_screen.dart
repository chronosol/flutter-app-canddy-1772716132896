import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'General Settings',
                    style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
                  ),
                  const Divider(height: 24),
                  ListTile(
                    title: Text('Sound Effects', style: textTheme.bodyLarge),
                    trailing: Switch(
                      value: true, // Placeholder for actual setting
                      onChanged: (bool value) {
                        // Implement sound toggle logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sound effects: ${value ? 'On' : 'Off'}')),
                        );
                      },
                      activeColor: colorScheme.secondary,
                    ),
                  ),
                  ListTile(
                    title: Text('Music', style: textTheme.bodyLarge),
                    trailing: Switch(
                      value: false, // Placeholder for actual setting
                      onChanged: (bool value) {
                        // Implement music toggle logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Music: ${value ? 'On' : 'Off'}')),
                        );
                      },
                      activeColor: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
                  ),
                  const Divider(height: 24),
                  ListTile(
                    title: Text('Version', style: textTheme.bodyLarge),
                    trailing: Text('1.0.0', style: textTheme.bodyMedium),
                  ),
                  ListTile(
                    title: Text('Developer', style: textTheme.bodyLarge),
                    trailing: Text('AI Architect', style: textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
