import 'package:canddy/features/game/presentation/screens/game_screen.dart';
import 'package:canddy/features/game/presentation/screens/high_scores_screen.dart';
import 'package:canddy/features/game/presentation/screens/home_screen.dart';
import 'package:canddy/features/game/presentation/screens/settings_screen.dart';
import 'package:canddy/features/game/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/game',
        builder: (BuildContext context, GoRouterState state) {
          return const GameScreen();
        },
      ),
      GoRoute(
        path: '/high-scores',
        builder: (BuildContext context, GoRouterState state) {
          return const HighScoresScreen();
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsScreen();
        },
      ),
    ],
  );
}
