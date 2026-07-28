import 'package:flutter/material.dart';

class HogarColors {
  static const primary = Color(0xFF005F98);
  static const primaryContainer = Color(0xFF2378B8);
  static const secondary = Color(0xFF914D00);
  static const orange = Color(0xFFF17F21);
  static const orangeBright = Color(0xFFFC9024);
  static const background = Color(0xFFFAF9F8);
  static const surfaceLow = Color(0xFFF4F3F2);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceContainer = Color(0xFFEEEEED);
  static const surfaceHigh = Color(0xFFE9E8E7);
  static const outline = Color(0xFF717881);
  static const outlineVariant = Color(0xFFC0C7D2);
  static const text = Color(0xFF1A1C1C);
  static const textMuted = Color(0xFF404750);
}

class HogarTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: HogarColors.primary,
        primary: HogarColors.primary,
        secondary: HogarColors.orange,
        surface: HogarColors.background,
      ),
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      scaffoldBackgroundColor: HogarColors.background,
      textTheme: base.textTheme.apply(
        bodyColor: HogarColors.text,
        displayColor: HogarColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: HogarColors.background,
        foregroundColor: HogarColors.text,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: HogarColors.orange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 18,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HogarColors.orange,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
