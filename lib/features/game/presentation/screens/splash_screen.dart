import 'package:canddy/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.diamond,
              size: 100,
              color: colorScheme.onPrimaryContainer,
            ).animate().scale(duration: 1000.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: textTheme.displayMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 1000.ms, delay: 500.ms).slideY(begin: 0.5, end: 0),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimaryContainer),
            ).animate(onPlay: (controller) => controller.repeat())
             .rotate(duration: 2000.ms, curve: Curves.linear),
          ],
        ),
      ),
    );
  }
}
