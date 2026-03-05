import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:canddy_app/core/constants/app_constants.dart';
import 'package:canddy_app/core/routing/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: AppConstants.heroTagGameTitle,
              child: Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ).animate().fade(duration: 800.ms).slideY(begin: -0.5, end: 0, duration: 800.ms, curve: Curves.easeOutBack),
            const SizedBox(height: AppConstants.spacingExtraLarge),
            _buildMenuButton(
              context,
              'Play Game',
              () => context.goNamed(AppRoute.game.name),
              icon: Icons.play_arrow,
            ).animate().fade(delay: 200.ms, duration: 600.ms).slideX(begin: -0.5, end: 0, delay: 200.ms, duration: 600.ms, curve: Curves.easeOutCubic),
            const SizedBox(height: AppConstants.spacingMedium),
            _buildMenuButton(
              context,
              'High Scores',
              () => context.goNamed(AppRoute.highScores.name),
              icon: Icons.emoji_events,
            ).animate().fade(delay: 400.ms, duration: 600.ms).slideX(begin: 0.5, end: 0, delay: 400.ms, duration: 600.ms, curve: Curves.easeOutCubic),
            const SizedBox(height: AppConstants.spacingMedium),
            _buildMenuButton(
              context,
              'Settings',
              () => context.goNamed(AppRoute.settings.name),
              icon: Icons.settings,
            ).animate().fade(delay: 600.ms, duration: 600.ms).slideX(begin: -0.5, end: 0, delay: 600.ms, duration: 600.ms, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onPressed, {required IconData icon}) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMedium),
          textStyle: Theme.of(context).textTheme.titleMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.spacingMedium),
          ),
        ),
      ),
    );
  }
}
