import 'package:flutter/material.dart';

/// Floosy Design System — premium dark fintech visual language.
class FloosyDesign {
  FloosyDesign._();

  // ── Colors ──────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF080A18);
  static const Color backgroundAlt = Color(0xFF080D1A);
  static const Color authBackground = Color(0xFF0D1020);
  static const Color primarySurface = Color(0xFF151827);
  static const Color secondarySurface = Color(0xFF191C2D);
  static const Color elevatedSurface = Color(0xFF1D2033);
  static const Color cardSurface = Color(0xFF151F32);
  static const Color inputBackground = Color(0xFF1B2030);
  static const Color toggleBackground = Color(0xFF20253A);
  static const Color navBackground = Color(0xFF0B0D1C);
  static const Color chatBubbleUser = Color(0xFF171A2B);

  static const Color borderSubtle = Color(0x14FFFFFF);
  static const Color borderLight = Color(0x0FFFFFFF);
  static const Color inputBorder = Color(0xFF2A3042);

  static const Color primaryPurple = Color(0xFF7C5CFF);
  static const Color brightPurple = Color(0xFF8B6CFF);
  static const Color purpleStart = Color(0xFF6F5BD3);
  static const Color purpleEnd = Color(0xFF8A78E8);
  static const Color blue = Color(0xFF55AFFF);
  static const Color cyan = Color(0xFF12BFFF);
  static const Color positive = Color(0xFF20D9A6);
  static const Color negative = Color(0xFFFF6B72);
  static const Color orange = Color(0xFFFFB84D);
  static const Color warmYellow = Color(0xFFE8A72E);
  static const Color coralRed = Color(0xFFD9433D);
  static const Color pink = Color(0xFFF05B9A);

  static const Color textPrimary = Color(0xFFF5F4FF);
  static const Color textSecondary = Color(0xFF9699B3);
  static const Color textMuted = Color(0xFF676B86);
  static const Color textInactive = Color(0xFF8D92A5);

  static const Color logoutBg = Color(0x1AFF5A64);
  static const Color logoutBorder = Color(0x33FF646E);

  // ── Gradients ───────────────────────────────────────────────────────────
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [purpleStart, purpleEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient balanceGradient = LinearGradient(
    colors: [Color(0xFF1D2033), Color(0xFF151827)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient profileGradient = LinearGradient(
    colors: [purpleStart, purpleEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Typography ──────────────────────────────────────────────────────────
  static const TextStyle logo = TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -1,
  );

  static const TextStyle pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle financialValue = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle financialValueLarge = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  static const TextStyle bodyTextSmall = TextStyle(
    fontSize: 12,
    color: textSecondary,
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 11,
    color: textSecondary,
  );

  static const TextStyle navLabelActive = TextStyle(
    fontSize: 11,
    color: primaryPurple,
    fontWeight: FontWeight.w600,
  );

  // ── Spacing ─────────────────────────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // ── Radii ───────────────────────────────────────────────────────────────
  static const double radiusLarge = 28;
  static const double radiusXL = 30;
  static const double radiusMedium = 20;
  static const double radiusSmall = 16;
  static const double radiusInput = 20;
  static const double radiusButton = 20;
  static const double radiusPill = 999;

  // ── Animation Durations ─────────────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration entrance = Duration(milliseconds: 450);
  static const Duration chartAnim = Duration(milliseconds: 800);

  // ── Helpers ─────────────────────────────────────────────────────────────
  static EdgeInsets horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return const EdgeInsets.symmetric(horizontal: 16);
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  static double cardPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 16;
    return 20;
  }
}

/// A subtle glowing box shadow used on focused inputs and the AI nav button.
List<BoxShadow> glowShadow(Color color,
    {double radius = 12, double opacity = 0.25}) {
  return [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: radius,
      spreadRadius: 0,
    ),
  ];
}

/// Theme-resolved palette. Dark values mirror the [FloosyDesign] constants
/// exactly; light values are the same geometry with light surfaces and
/// high-contrast text so switching modes only changes colors.
class FloosyPalette {
  final Color background;
  final Color backgroundAlt;
  final Color authBackground;
  final Color primarySurface;
  final Color secondarySurface;
  final Color elevatedSurface;
  final Color cardSurface;
  final Color inputBackground;
  final Color toggleBackground;
  final Color navBackground;
  final Color chatBubbleUser;
  final Color borderSubtle;
  final Color borderLight;
  final Color inputBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInactive;
  final Color logoutBg;
  final Color logoutBorder;
  final LinearGradient balanceGradient;

  const FloosyPalette({
    required this.background,
    required this.backgroundAlt,
    required this.authBackground,
    required this.primarySurface,
    required this.secondarySurface,
    required this.elevatedSurface,
    required this.cardSurface,
    required this.inputBackground,
    required this.toggleBackground,
    required this.navBackground,
    required this.chatBubbleUser,
    required this.borderSubtle,
    required this.borderLight,
    required this.inputBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInactive,
    required this.logoutBg,
    required this.logoutBorder,
    required this.balanceGradient,
  });

  static const FloosyPalette dark = FloosyPalette(
    background: FloosyDesign.background,
    backgroundAlt: FloosyDesign.backgroundAlt,
    authBackground: FloosyDesign.authBackground,
    primarySurface: FloosyDesign.primarySurface,
    secondarySurface: FloosyDesign.secondarySurface,
    elevatedSurface: FloosyDesign.elevatedSurface,
    cardSurface: FloosyDesign.cardSurface,
    inputBackground: FloosyDesign.inputBackground,
    toggleBackground: FloosyDesign.toggleBackground,
    navBackground: FloosyDesign.navBackground,
    chatBubbleUser: FloosyDesign.chatBubbleUser,
    borderSubtle: FloosyDesign.borderSubtle,
    borderLight: FloosyDesign.borderLight,
    inputBorder: FloosyDesign.inputBorder,
    textPrimary: FloosyDesign.textPrimary,
    textSecondary: FloosyDesign.textSecondary,
    textMuted: FloosyDesign.textMuted,
    textInactive: FloosyDesign.textInactive,
    logoutBg: FloosyDesign.logoutBg,
    logoutBorder: FloosyDesign.logoutBorder,
    balanceGradient: FloosyDesign.balanceGradient,
  );

  static const FloosyPalette light = FloosyPalette(
    background: Color(0xFFF3F4FA),
    backgroundAlt: Color(0xFFEDEFF7),
    authBackground: Color(0xFFF6F7FC),
    primarySurface: Color(0xFFFFFFFF),
    secondarySurface: Color(0xFFF7F8FD),
    elevatedSurface: Color(0xFFFBFBFF),
    cardSurface: Color(0xFFFFFFFF),
    inputBackground: Color(0xFFF1F2F9),
    toggleBackground: Color(0xFFE8EAF4),
    navBackground: Color(0xFFFFFFFF),
    chatBubbleUser: Color(0xFFF0F1F8),
    borderSubtle: Color(0x14101428),
    borderLight: Color(0x0F101428),
    inputBorder: Color(0xFFD8DBE9),
    textPrimary: Color(0xFF171A2B),
    textSecondary: Color(0xFF4B4F6B),
    textMuted: Color(0xFF8A8FA8),
    textInactive: Color(0xFF9AA0B5),
    logoutBg: Color(0x14FF5A64),
    logoutBorder: Color(0x33FF646E),
    balanceGradient: LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFF0F1F9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // ── Theme-aware text styles (same geometry as FloosyDesign) ──────────────
  TextStyle get logo => TextStyle(
      fontSize: 52,
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: -1);
  TextStyle get pageTitle =>
      TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: textPrimary);
  TextStyle get sectionTitle =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary);
  TextStyle get financialValue =>
      TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary);
  TextStyle get financialValueLarge =>
      TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: textPrimary);
  TextStyle get cardTitle =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary);
  TextStyle get bodyText => TextStyle(fontSize: 14, color: textSecondary);
  TextStyle get bodyTextSmall => TextStyle(fontSize: 12, color: textSecondary);
  TextStyle get navLabel => TextStyle(fontSize: 11, color: textSecondary);
  TextStyle get navLabelActive => const TextStyle(
      fontSize: 11,
      color: FloosyDesign.primaryPurple,
      fontWeight: FontWeight.w600);
}

/// Resolves the current theme's Floosy palette from any BuildContext:
///
/// ```dart
/// Container(color: context.fc.background)
/// Text('Hi', style: context.fc.pageTitle)
/// ```
extension FloosyThemeResolver on BuildContext {
  FloosyPalette get fc => Theme.of(this).brightness == Brightness.dark
      ? FloosyPalette.dark
      : FloosyPalette.light;
}
