import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Deodar Design System — Flutter Theme
// ─────────────────────────────────────────────
// Colors  : Forest green primary, white, terracotta accent
// Radius  : Minimal — 4 px default, 6 px cards
// Type    : Clean sans-serif, generous weight contrast
// ─────────────────────────────────────────────

abstract final class DeodarColors {
  // Primary greens
  static const Color greenDark    = Color(0xFF1B4332);
  static const Color green        = Color(0xFF2D6A4F);
  static const Color greenMid     = Color(0xFF40916C);
  static const Color greenLight   = Color(0xFF74C69D);
  static const Color greenSurface = Color(0xFFD8F3DC);

  // Neutrals
  static const Color white        = Color(0xFFFFFFFF);
  static const Color background   = Color(0xFFF6FAF7);
  static const Color surfaceGrey  = Color(0xFFEEF2EF);
  static const Color divider      = Color(0xFFD0DDD3);
  static const Color textPrimary  = Color(0xFF0D1F17);
  static const Color textSecondary= Color(0xFF4A6358);
  static const Color textDisabled = Color(0xFF9AB3A4);

  // Accent — terracotta (warm contrast to green)
  static const Color accent       = Color(0xFFE07A5F);
  static const Color accentDark   = Color(0xFFB85C42);
  static const Color accentSurface= Color(0xFFFCEDE9);

  // Semantic
  static const Color error        = Color(0xFFB00020);
  static const Color success      = Color(0xFF2D6A4F);
  static const Color warning      = Color(0xFFF59E0B);
}

abstract final class DeodarRadius {
  static const double none    = 0;
  static const double xs      = 2;
  static const double sm      = 4;   // buttons, chips, inputs
  static const double md      = 6;   // cards, dialogs
  static const double lg      = 10;  // bottom sheets, large cards
  static const double full    = 999; // pills (use sparingly)

  static const BorderRadius noneBR  = BorderRadius.zero;
  static const BorderRadius smBR    = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdBR    = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgBR    = BorderRadius.all(Radius.circular(lg));
}

abstract final class DeodarSpacing {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;
}

ThemeData deodarTheme() {
  final colorScheme = ColorScheme(
    brightness:       Brightness.light,
    primary:          DeodarColors.green,
    onPrimary:        DeodarColors.white,
    primaryContainer: DeodarColors.greenSurface,
    onPrimaryContainer: DeodarColors.greenDark,
    secondary:        DeodarColors.accent,
    onSecondary:      DeodarColors.white,
    secondaryContainer: DeodarColors.accentSurface,
    onSecondaryContainer: DeodarColors.accentDark,
    tertiary:         DeodarColors.greenMid,
    onTertiary:       DeodarColors.white,
    surface:          DeodarColors.white,
    onSurface:        DeodarColors.textPrimary,
    surfaceContainerHighest: DeodarColors.surfaceGrey,
    error:            DeodarColors.error,
    onError:          DeodarColors.white,
    outline:          DeodarColors.divider,
    outlineVariant:   DeodarColors.divider,
  );

  return ThemeData(
    useMaterial3:   true,
    colorScheme:    colorScheme,
    scaffoldBackgroundColor: DeodarColors.background,

    // ── Typography ─────────────────────────────
    textTheme: const TextTheme(
      displayLarge:  TextStyle(fontSize: 57, fontWeight: FontWeight.w300, color: DeodarColors.textPrimary, letterSpacing: -0.5),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w300, color: DeodarColors.textPrimary),
      displaySmall:  TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: DeodarColors.textPrimary),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: DeodarColors.textPrimary, letterSpacing: -0.3),
      headlineMedium:TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: DeodarColors.textPrimary),
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: DeodarColors.textPrimary),
      titleLarge:    TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: DeodarColors.textPrimary),
      titleMedium:   TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: DeodarColors.textPrimary, letterSpacing: 0.1),
      titleSmall:    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: DeodarColors.textPrimary, letterSpacing: 0.1),
      bodyLarge:     TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: DeodarColors.textPrimary),
      bodyMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: DeodarColors.textPrimary),
      bodySmall:     TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: DeodarColors.textSecondary),
      labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: DeodarColors.textPrimary, letterSpacing: 0.5),
      labelMedium:   TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: DeodarColors.textSecondary, letterSpacing: 0.5),
      labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: DeodarColors.textSecondary, letterSpacing: 0.5),
    ),

    // ── AppBar ──────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor:    DeodarColors.white,
      foregroundColor:    DeodarColors.textPrimary,
      surfaceTintColor:   Colors.transparent,
      elevation:          0,
      scrolledUnderElevation: 1,
      shadowColor:        DeodarColors.divider,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: DeodarColors.textPrimary,
        letterSpacing: 0,
      ),
      iconTheme: IconThemeData(color: DeodarColors.textPrimary, size: 22),
    ),

    // ── Elevated Button ─────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:    DeodarColors.green,
        foregroundColor:    DeodarColors.white,
        disabledBackgroundColor: DeodarColors.divider,
        elevation:          0,
        shadowColor:        Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: DeodarRadius.smBR),
        padding: const EdgeInsets.symmetric(horizontal: DeodarSpacing.lg, vertical: 14),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
    ),

    // ── Outlined Button ─────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor:    DeodarColors.green,
        side: const BorderSide(color: DeodarColors.green, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: DeodarRadius.smBR),
        padding: const EdgeInsets.symmetric(horizontal: DeodarSpacing.lg, vertical: 14),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
    ),

    // ── Text Button ─────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DeodarColors.green,
        shape: const RoundedRectangleBorder(borderRadius: DeodarRadius.smBR),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // ── Input / TextField ───────────────────────
    inputDecorationTheme: const InputDecorationTheme(
      filled:           true,
      fillColor:        DeodarColors.surfaceGrey,
      contentPadding:   EdgeInsets.symmetric(horizontal: DeodarSpacing.md, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: DeodarRadius.smBR,
        borderSide:   BorderSide(color: DeodarColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: DeodarRadius.smBR,
        borderSide:   BorderSide(color: DeodarColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: DeodarRadius.smBR,
        borderSide:   BorderSide(color: DeodarColors.green, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: DeodarRadius.smBR,
        borderSide:   BorderSide(color: DeodarColors.error),
      ),
      hintStyle:  TextStyle(color: DeodarColors.textDisabled),
      labelStyle: TextStyle(color: DeodarColors.textSecondary),
    ),

    // ── Card ────────────────────────────────────
    cardTheme: const CardThemeData(
      color:        DeodarColors.white,
      elevation:    0,
      shape:        RoundedRectangleBorder(
        borderRadius: DeodarRadius.mdBR,
        side:         BorderSide(color: DeodarColors.divider),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── Chip ────────────────────────────────────
    chipTheme: const ChipThemeData(
      backgroundColor:  DeodarColors.surfaceGrey,
      selectedColor:    DeodarColors.greenSurface,
      labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: DeodarColors.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: DeodarRadius.smBR),
      side: BorderSide(color: DeodarColors.divider),
      padding: EdgeInsets.symmetric(horizontal: DeodarSpacing.sm, vertical: 4),
    ),

    // ── Divider ─────────────────────────────────
    dividerTheme: const DividerThemeData(
      color:     DeodarColors.divider,
      thickness: 1,
      space:     1,
    ),

    // ── Bottom Navigation ───────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:      DeodarColors.white,
      selectedItemColor:    DeodarColors.green,
      unselectedItemColor:  DeodarColors.textDisabled,
      elevation:            0,
      type: BottomNavigationBarType.fixed,
    ),

    // ── Navigation Bar (M3) ─────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:      DeodarColors.white,
      indicatorColor:       DeodarColors.greenSurface,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: DeodarColors.green, size: 22);
        }
        return const IconThemeData(color: DeodarColors.textDisabled, size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: DeodarColors.green);
        }
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: DeodarColors.textDisabled);
      }),
    ),

    // ── Floating Action Button ──────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DeodarColors.green,
      foregroundColor: DeodarColors.white,
      elevation:       2,
      shape: RoundedRectangleBorder(borderRadius: DeodarRadius.smBR),
    ),

    // ── Dialog ──────────────────────────────────
    dialogTheme: const DialogThemeData(
      backgroundColor:  DeodarColors.white,
      surfaceTintColor: Colors.transparent,
      elevation:        4,
      shape: RoundedRectangleBorder(borderRadius: DeodarRadius.mdBR),
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: DeodarColors.textPrimary),
      contentTextStyle: TextStyle(fontSize: 14, color: DeodarColors.textSecondary),
    ),

    // ── SnackBar ────────────────────────────────
    snackBarTheme: const SnackBarThemeData(
      backgroundColor:  DeodarColors.greenDark,
      contentTextStyle: TextStyle(color: DeodarColors.white, fontSize: 14),
      behavior:         SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: DeodarRadius.smBR),
    ),

    // ── List Tile ───────────────────────────────
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: DeodarSpacing.md, vertical: 4),
      iconColor:      DeodarColors.textSecondary,
      titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: DeodarColors.textPrimary),
      subtitleTextStyle: TextStyle(fontSize: 13, color: DeodarColors.textSecondary),
    ),

    // ── Switch / Checkbox / Radio ───────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? DeodarColors.white : DeodarColors.divider),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? DeodarColors.green : DeodarColors.surfaceGrey),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? DeodarColors.green : Colors.transparent),
      checkColor: WidgetStateProperty.all(DeodarColors.white),
      shape: const RoundedRectangleBorder(borderRadius: DeodarRadius.smBR),
      side: const BorderSide(color: DeodarColors.divider, width: 1.5),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? DeodarColors.green : DeodarColors.textDisabled),
    ),

    // ── Progress Indicator ──────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color:            DeodarColors.green,
      linearTrackColor: DeodarColors.divider,
      circularTrackColor: Colors.transparent,
    ),

    // ── Tab Bar ─────────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor:         DeodarColors.green,
      unselectedLabelColor: DeodarColors.textSecondary,
      indicatorColor:     DeodarColors.green,
      indicatorSize:      TabBarIndicatorSize.label,
      labelStyle:         TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    ),
  );
}
