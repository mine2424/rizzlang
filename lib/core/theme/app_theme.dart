import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFFF6B9D);
  static const Color primaryDark = Color(0xFFc44b8a);
  static const Color background = Color(0xFF0d0d0d);
  static const Color surface = Color(0xFF161616);
  static const Color surfaceVariant = Color(0xFF242424);
  static const Color onSurface = Color(0xFFf0f0f0);
  static const Color muted = Color(0xFF888888);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: primary,
          secondary: primaryDark,
          background: background,
          surface: surface,
          onBackground: onSurface,
          onSurface: onSurface,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          foregroundColor: onSurface,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primary),
          ),
        ),
        fontFamily: 'NotoSansJP',
      );

  static ThemeData get light => dark; // 現在はダークのみ
}
