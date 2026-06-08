import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ocalm_colors.dart';

/// Thème principal OCALM — Afro-Futuriste Dark
/// Typographie: Space Grotesk (display) + Inter (body)
class OcalmTheme {
  OcalmTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: OcalmColors.primary,
      scaffoldBackgroundColor: OcalmColors.background,
      colorScheme: const ColorScheme.dark(
        primary: OcalmColors.primary,
        secondary: OcalmColors.statusLocked,
        surface: OcalmColors.surface,
        error: OcalmColors.statusDispute,
        onPrimary: OcalmColors.textOnPrimary,
        onSecondary: OcalmColors.textPrimary,
        onSurface: OcalmColors.textPrimary,
        outline: OcalmColors.surfaceBorder,
      ),

      // ─── Typographie ──────────────────────────────────────────
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        // Display — Space Grotesk
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          fontFamily: 'SpaceGrotesk',
          color: OcalmColors.textPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'SpaceGrotesk',
          color: OcalmColors.textPrimary,
          letterSpacing: -0.5,
        ),
        // Headlines
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: 'SpaceGrotesk',
          color: OcalmColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'SpaceGrotesk',
          color: OcalmColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: OcalmColors.textPrimary,
        ),
        // Titres
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: OcalmColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: OcalmColors.textPrimary,
        ),
        // Corps
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: OcalmColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: OcalmColors.textSecondary,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: OcalmColors.textHint,
        ),
        // Labels
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: OcalmColors.textOnPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: OcalmColors.textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: OcalmColors.textSecondary,
        ),
      ),

      // ─── Bouton principal (orange glow) ───────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OcalmColors.primary,
          foregroundColor: OcalmColors.textOnPrimary,
          elevation: 0,
          shadowColor: OcalmColors.glowOrange,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'SpaceGrotesk',
          ),
        ),
      ),

      // ─── Bouton outline (cream border) ────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: OcalmColors.textPrimary,
          side: const BorderSide(color: OcalmColors.surfaceBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── Text Button ──────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: OcalmColors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─── Cartes (glass-morphism) ──────────────────────────────
      cardTheme: CardThemeData(
        color: OcalmColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: OcalmColors.glassBorder, width: 0.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ─── AppBar ───────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: OcalmColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: OcalmColors.textPrimary,
          fontFamily: 'SpaceGrotesk',
        ),
      ),

      // ─── Bottom Navigation ────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: OcalmColors.backgroundDarker,
        selectedItemColor: OcalmColors.primary,
        unselectedItemColor: OcalmColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),

      // ─── Input ────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OcalmColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: OcalmColors.surfaceBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: OcalmColors.surfaceBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: OcalmColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: OcalmColors.statusDispute, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: const TextStyle(color: OcalmColors.textHint),
        labelStyle: const TextStyle(color: OcalmColors.textSecondary),
      ),

      // ─── Chip (badges statut) ─────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: OcalmColors.surface,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // ─── Divider ──────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: OcalmColors.divider,
        thickness: 0.5,
        space: 1,
      ),

      // ─── Dialog ───────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: OcalmColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'SpaceGrotesk',
          color: OcalmColors.textPrimary,
        ),
      ),

      // ─── Snackbar ─────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: OcalmColors.surfaceLight,
        contentTextStyle: const TextStyle(
          color: OcalmColors.textPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
