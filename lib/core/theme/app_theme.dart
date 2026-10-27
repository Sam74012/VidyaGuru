import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.notoSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.notoSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryLight,
      ),
      titleLarge: GoogleFonts.notoSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      titleMedium: GoogleFonts.notoSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryLight,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryLight,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.saffron,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.saffronContainer,
        onSecondaryContainer: AppColors.onSaffronContainer,
        tertiary: AppColors.emerald,
        onTertiary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.cardLight,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.notoSans(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.notoSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.borderLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.borderLight),
        labelStyle: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  static ThemeData dark() {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.notoSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDark,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.notoSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryDark,
      ),
      titleLarge: GoogleFonts.notoSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      titleMedium: GoogleFonts.notoSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.saffronLight,
        onPrimary: Colors.black,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.saffron,
        onSecondary: Colors.black,
        secondaryContainer: AppColors.onSaffronContainer,
        onSecondaryContainer: Colors.white,
        tertiary: AppColors.emeraldLight,
        onTertiary: Colors.black,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.notoSans(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.notoSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.saffronLight,
          side: const BorderSide(color: AppColors.borderDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.saffron, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.borderDark),
        labelStyle: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
