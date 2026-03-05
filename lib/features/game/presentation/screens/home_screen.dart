import 'package:canddy/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.diamond_outlined,
              size: 120,
              color: colorScheme.primary,
            ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 32),
            Text(
              'Welcome to ${AppConstants.appName}',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 48),
            _buildMenuButton(
              context,
              'Play Game',
              Icons.play_arrow,
              () => context.go('/game'),
            ).animate().slideX(begin: -0.5, duration: 500.ms, delay: 600.ms),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              'High Scores',
              Icons.leaderboard,
              () => context.go('/high-scores'),
            ).animate().slideX(begin: 0.5, duration: 500.ms, delay: 700.ms),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              'Settings',
              Icons.settings,
              () => context.go('/settings'),
            ).animate().slideX(begin: -0.5, duration: 500.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
