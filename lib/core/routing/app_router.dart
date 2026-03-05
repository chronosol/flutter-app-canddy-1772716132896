import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:canddy_app/features/game/presentation/screens/splash_screen.dart';
import 'package:canddy_app/features/game/presentation/screens/home_screen.dart';
import 'package:canddy_app/features/game/presentation/screens/game_screen.dart';
import 'package:canddy_app/features/game/presentation/screens/high_scores_screen.dart';
import 'package:canddy_app/features/game/presentation/screens/settings_screen.dart';

enum AppRoute {
  splash,
  home,
  game,
  highScores,
  settings,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/${AppRoute.splash.name}',
    routes: [
      GoRoute(
        path: '/${AppRoute.splash.name}',
        name: AppRoute.splash.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/${AppRoute.home.name}',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/${AppRoute.game.name}',
        name: AppRoute.game.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const GameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${AppRoute.highScores.name}',
        name: AppRoute.highScores.name,
        builder: (context, state) => const HighScoresScreen(),
      ),
      GoRoute(
        path: '/${AppRoute.settings.name}',
        name: AppRoute.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
