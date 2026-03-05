import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Canddy App';
  static const int boardSize = 8; // 8x8 board
  static const int minMatchLength = 3;
  static const int initialMoves = 30;
  static const int scorePerCandy = 10;
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration candyAnimationDuration = Duration(milliseconds: 200);

  // Spacing constants
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingExtraLarge = 32.0;

  // Hero tag constants
  static const String heroTagGameTitle = 'gameTitle';
}
