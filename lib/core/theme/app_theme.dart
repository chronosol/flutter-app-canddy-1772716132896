import 'package:flutter/material.dart';

class AppTheme {
  static final Color _primarySeed = Colors.pink.shade300;
  static final Color _secondarySeed = Colors.purple.shade300;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: Brightness.light,
      primary: _primarySeed,
      secondary: _secondarySeed,
      surface: Colors.pink.shade50,
      onSurface: Colors.grey.shade900,
      background: Colors.pink.shade100,
      onBackground: Colors.grey.shade900,
      error: Colors.red.shade700,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _primarySeed,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: _lightTextTheme.titleLarge?.copyWith(color: Colors.white),
    ),
    textTheme: _lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primarySeed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: _lightTextTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primarySeed,
        textStyle: _lightTextTheme.labelLarge,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: Brightness.dark,
      primary: _primarySeed.shade200,
      secondary: _secondarySeed.shade200,
      surface: Colors.grey.shade900,
      onSurface: Colors.white,
      background: Colors.grey.shade900,
      onBackground: Colors.white,
      error: Colors.red.shade400,
      onError: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _primarySeed.shade800,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: _darkTextTheme.titleLarge?.copyWith(color: Colors.white),
    ),
    textTheme: _darkTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primarySeed.shade800,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: _darkTextTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primarySeed.shade200,
        textStyle: _darkTextTheme.labelLarge,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.grey.shade800,
      surfaceTintColor: Colors.grey.shade800,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade800,
      surfaceTintColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: Colors.white),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: Colors.white),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: Colors.white),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
  );
}
