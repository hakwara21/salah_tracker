import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primary),
        titleTextStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1,
          letterSpacing: 0.05,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.onSurface,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryFixedDim,
        onPrimary: AppColors.onPrimaryFixed,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondaryFixedDim,
        onSecondary: AppColors.onSecondaryFixed,
        secondaryContainer: AppColors.secondary,
        onSecondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiaryFixedDim,
        onTertiary: AppColors.onTertiaryFixed,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.inverseSurface,
        onSurface: AppColors.inverseOnSurface,
        surfaceContainerHighest: const Color(0xFF3a3d3e),
        onSurfaceVariant: AppColors.surfaceVariant,
        outline: const Color(0xFF8b928a),
        outlineVariant: const Color(0xFF414844),
        inverseSurface: AppColors.surface,
        inversePrimary: AppColors.primary,
        surfaceTint: AppColors.primaryFixedDim,
      ),
      scaffoldBackgroundColor: AppColors.inverseSurface,
    );
  }
}