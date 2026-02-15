import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppPalette.lightPrimary,
        onPrimary: Colors.white,
        secondary: AppPalette.lightSecondary,
        onSecondary: Colors.white,
        error: Color(0xFFDC2626),
        onError: Colors.white,
        surface: AppPalette.lightSurface,
        onSurface: AppPalette.lightOnSurface,
        tertiary: AppPalette.lightTertiary,
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: AppPalette.lightBackground,
    );

    final textTheme =
        GoogleFonts.spaceGroteskTextTheme(base.textTheme).copyWith(
      bodyLarge: GoogleFonts.sourceSerif4(
        fontSize: 18,
        height: 1.55,
        color: AppPalette.lightOnSurface,
      ),
      bodyMedium: GoogleFonts.sourceSerif4(
        fontSize: 16,
        height: 1.5,
        color: AppPalette.lightOnSurface,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.lightOnSurface,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white.withOpacity(0.82),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: BorderSide(color: base.colorScheme.primary.withOpacity(0.28)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppPalette.darkPrimary,
        onPrimary: Color(0xFF062B29),
        secondary: AppPalette.darkSecondary,
        onSecondary: Color(0xFF3A1A04),
        error: Color(0xFFF87171),
        onError: Color(0xFF24070A),
        surface: AppPalette.darkSurface,
        onSurface: AppPalette.darkOnSurface,
        tertiary: AppPalette.darkTertiary,
        onTertiary: Color(0xFF022638),
      ),
      scaffoldBackgroundColor: AppPalette.darkBackground,
    );

    final textTheme =
        GoogleFonts.spaceGroteskTextTheme(base.textTheme).copyWith(
      bodyLarge: GoogleFonts.sourceSerif4(
        fontSize: 18,
        height: 1.55,
        color: AppPalette.darkOnSurface,
      ),
      bodyMedium: GoogleFonts.sourceSerif4(
        fontSize: 16,
        height: 1.5,
        color: AppPalette.darkOnSurface,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.darkOnSurface,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: AppPalette.darkSurface.withOpacity(0.83),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.07),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: BorderSide(color: base.colorScheme.primary.withOpacity(0.28)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
