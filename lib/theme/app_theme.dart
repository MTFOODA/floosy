import 'package:flutter/material.dart';
import '../core/theme/app_design_system.dart';

class AppTheme {
  // Legacy colors kept for compatibility
  static const Color primaryColor = FloosyDesign.primaryPurple;
  static const Color secondaryColor = FloosyDesign.brightPurple;
  static const Color successColor = FloosyDesign.positive;
  static const Color warningColor = FloosyDesign.orange;
  static const Color errorColor = FloosyDesign.negative;

  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = FloosyDesign.primarySurface;
  static const Color borderColor = FloosyDesign.inputBorder;

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: surfaceLight,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: surfaceLight,
      foregroundColor: Colors.black87,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FloosyDesign.radiusButton),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
    ),
  );

  // Dark Theme — premium Floosy dark mode
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: FloosyDesign.background,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: FloosyDesign.background,
      foregroundColor: FloosyDesign.textPrimary,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: FloosyDesign.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FloosyDesign.radiusButton),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: FloosyDesign.inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
        borderSide: const BorderSide(color: FloosyDesign.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
        borderSide: const BorderSide(color: FloosyDesign.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: FloosyDesign.primarySurface,
      error: errorColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: FloosyDesign.textPrimary),
      bodyMedium: TextStyle(color: FloosyDesign.textSecondary),
      bodySmall: TextStyle(color: FloosyDesign.textMuted),
      titleLarge: TextStyle(color: FloosyDesign.textPrimary),
      titleMedium: TextStyle(color: FloosyDesign.textPrimary),
    ),
  );
}
