import 'package:flutter/material.dart';

class AppTheme {
  // ── Color Tokens ──────────────────────────────
  static const Color background   = Color(0xFF09090F);
  static const Color surface      = Color(0xFF13131F);
  static const Color surface2     = Color(0xFF1C1C2E);
  static const Color surface3     = Color(0xFF252540);
  static const Color border       = Color(0x12FFFFFF);  // rgba(255,255,255,0.07)
  static const Color borderGlow   = Color(0x40FF4E8B);  // primary @ 25%

  static const Color primary      = Color(0xFFFF4E8B);
  static const Color primaryDark  = Color(0xFFC73468);
  static const Color primaryGlow  = Color(0x1FFF4E8B);  // primary @ 12%

  static const Color tension      = Color(0xFFFF6B6B);
  static const Color tensionBg    = Color(0x14FF6B6B);  // tension @ 8%
  static const Color success      = Color(0xFF4ECDC4);
  static const Color gold         = Color(0xFFFFD166);

  static const Color text1        = Color(0xF2FFFFFF);  // 95%
  static const Color text2        = Color(0xA6FFFFFF);  // 65%
  static const Color text3        = Color(0x61FFFFFF);  // 38%
  static const Color muted        = Color(0xFF888888);

  // ── Gradients ──────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  // ── Shadows ────────────────────────────────────
  static List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: primary.withOpacity(0.30),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.30),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  // ── Theme ──────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: primaryDark,
      surface: surface,
      onSurface: text1,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: text1,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: text1,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: text3, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    ),
    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 1,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: text2,
      textColor: text1,
    ),
  );

  static ThemeData get light => dark;
}
