import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Contemporary Productivity Minimalism design with Adaptive Professional Palette.
class AppTheme {
  AppTheme._();

  // Primary color palette - Deep forest green for primary actions and branding
  static const Color primaryLight = Color(0xFF2C5F41);
  static const Color primaryDark = Color(0xFF4A8B6B);

  // Secondary color - Warm brown accent for notebook elements
  static const Color secondaryLight = Color(0xFF8B4513);
  static const Color secondaryDark = Color(0xFFB8713D);

  // Surface colors with subtle warmth
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF1A1A1A);

  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  // Priority colors for task management
  static const Color priorityHigh = Color(0xFFD32F2F);
  static const Color priorityNormal = Color(0xFF1976D2);
  static const Color priorityLow = Color(0xFF388E3C);

  // Status colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);

  // Text colors with high contrast for mobile readability
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Text colors for dark theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textDisabledDark = Color(0xFF666666);

  // Card and dialog colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF2D2D2D);

  // Border colors - minimal neutral tones
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF333333);

  // Shadow colors with warm undertones
  static const Color shadowLight = Color(0x1A8B4513);
  static const Color shadowDark = Color(0x1AFFFFFF);

  // Divider colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF333333);

  /// Light theme with Contemporary Productivity Minimalism
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryLight,
          onPrimary: Colors.white,
          primaryContainer: primaryLight.withAlpha(26),
          onPrimaryContainer: primaryLight,
          secondary: secondaryLight,
          onSecondary: Colors.white,
          secondaryContainer: secondaryLight.withAlpha(26),
          onSecondaryContainer: secondaryLight,
          tertiary: priorityNormal,
          onTertiary: Colors.white,
          tertiaryContainer: priorityNormal.withAlpha(26),
          onTertiaryContainer: priorityNormal,
          error: error,
          onError: Colors.white,
          surface: surfaceLight,
          onSurface: textPrimary,
          onSurfaceVariant: textSecondary,
          outline: borderLight,
          outlineVariant: dividerLight,
          shadow: shadowLight,
          scrim: Colors.black54,
          inverseSurface: surfaceDark,
          onInverseSurface: textPrimaryDark,
          inversePrimary: primaryDark),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardLight,
      dividerColor: dividerLight,

      // AppBar theme with contextual adaptation
      appBarTheme: AppBarTheme(
          backgroundColor: surfaceLight,
          foregroundColor: textPrimary,
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: shadowLight,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 20, fontWeight: FontWeight.w500, color: textPrimary),
          iconTheme: IconThemeData(color: textPrimary),
          actionsIconTheme: IconThemeData(color: textPrimary)),

      // Card theme with subtle elevation
      cardTheme: CardTheme(
          color: cardLight,
          elevation: 2.0,
          shadowColor: shadowLight,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation with adaptive design
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceLight,
          selectedItemColor: primaryLight,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // Smart floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 4,
          focusElevation: 6,
          hoverElevation: 6,
          highlightElevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),

      // Button themes with consistent styling
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryLight,
              elevation: 2,
              shadowColor: shadowLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: BorderSide(color: primaryLight, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),

      // Typography with Inter and Roboto fonts
      textTheme: _buildLightTextTheme(),

      // Input decoration with clean borders
      inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceLight,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: borderLight, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: borderLight, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: primaryLight, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: error, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: error, width: 2)),
          labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textDisabled, fontSize: 14, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: error, fontSize: 12, fontWeight: FontWeight.w400)),

      // Switch theme
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.grey[300];
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withAlpha(128);
        }
        return Colors.grey[300];
      })),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryLight;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: borderLight, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),

      // Radio theme
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return textSecondary;
      })),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryLight, linearTrackColor: primaryLight.withAlpha(51), circularTrackColor: primaryLight.withAlpha(51)),

      // Slider theme
      sliderTheme: SliderThemeData(activeTrackColor: primaryLight, thumbColor: primaryLight, overlayColor: primaryLight.withAlpha(51), inactiveTrackColor: primaryLight.withAlpha(77), valueIndicatorColor: primaryLight, valueIndicatorTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),

      // Tab bar theme
      tabBarTheme: TabBarTheme(labelColor: primaryLight, unselectedLabelColor: textSecondary, indicatorColor: primaryLight, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),

      // Tooltip theme
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: textPrimary.withAlpha(230), borderRadius: BorderRadius.circular(8)), textStyle: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),

      // SnackBar theme
      snackBarTheme: SnackBarThemeData(backgroundColor: textPrimary, contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: primaryLight, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), elevation: 4),

      // Navigation rail theme for tablets
      navigationRailTheme: NavigationRailThemeData(backgroundColor: surfaceLight, selectedIconTheme: IconThemeData(color: primaryLight), unselectedIconTheme: IconThemeData(color: textSecondary), selectedLabelTextStyle: GoogleFonts.inter(color: primaryLight, fontSize: 12, fontWeight: FontWeight.w500), unselectedLabelTextStyle: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w400)), dialogTheme: DialogThemeData(backgroundColor: dialogLight));

  /// Dark theme with Contemporary Productivity Minimalism
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryDark,
          onPrimary: Colors.black,
          primaryContainer: primaryDark.withAlpha(51),
          onPrimaryContainer: primaryDark,
          secondary: secondaryDark,
          onSecondary: Colors.black,
          secondaryContainer: secondaryDark.withAlpha(51),
          onSecondaryContainer: secondaryDark,
          tertiary: priorityNormal,
          onTertiary: Colors.white,
          tertiaryContainer: priorityNormal.withAlpha(51),
          onTertiaryContainer: priorityNormal,
          error: error,
          onError: Colors.white,
          surface: surfaceDark,
          onSurface: textPrimaryDark,
          onSurfaceVariant: textSecondaryDark,
          outline: borderDark,
          outlineVariant: dividerDark,
          shadow: shadowDark,
          scrim: Colors.black87,
          inverseSurface: surfaceLight,
          onInverseSurface: textPrimary,
          inversePrimary: primaryLight),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardDark,
      dividerColor: dividerDark,

      // AppBar theme with contextual adaptation
      appBarTheme: AppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: textPrimaryDark,
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: shadowDark,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: textPrimaryDark),
          iconTheme: IconThemeData(color: textPrimaryDark),
          actionsIconTheme: IconThemeData(color: textPrimaryDark)),

      // Card theme with subtle elevation
      cardTheme: CardTheme(
          color: cardDark,
          elevation: 2.0,
          shadowColor: shadowDark,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation with adaptive design
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: primaryDark,
          unselectedItemColor: textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // Smart floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryDark,
          foregroundColor: Colors.black,
          elevation: 4,
          focusElevation: 6,
          hoverElevation: 6,
          highlightElevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),

      // Button themes with consistent styling
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: primaryDark,
              elevation: 2,
              shadowColor: shadowDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: BorderSide(color: primaryDark, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),

      // Typography with Inter and Roboto fonts
      textTheme: _buildDarkTextTheme(),

      // Input decoration with clean borders
      inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceDark,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: borderDark, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: borderDark, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: primaryDark, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: error, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: error, width: 2)),
          labelStyle: GoogleFonts.inter(color: textSecondaryDark, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textDisabledDark, fontSize: 14, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: error, fontSize: 12, fontWeight: FontWeight.w400)),

      // Switch theme
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.grey[600];
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withAlpha(128);
        }
        return Colors.grey[600];
      })),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryDark;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.black),
          side: BorderSide(color: borderDark, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),

      // Radio theme
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return textSecondaryDark;
      })),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryDark, linearTrackColor: primaryDark.withAlpha(51), circularTrackColor: primaryDark.withAlpha(51)),

      // Slider theme
      sliderTheme: SliderThemeData(activeTrackColor: primaryDark, thumbColor: primaryDark, overlayColor: primaryDark.withAlpha(51), inactiveTrackColor: primaryDark.withAlpha(77), valueIndicatorColor: primaryDark, valueIndicatorTextStyle: GoogleFonts.inter(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),

      // Tab bar theme
      tabBarTheme: TabBarTheme(labelColor: primaryDark, unselectedLabelColor: textSecondaryDark, indicatorColor: primaryDark, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),

      // Tooltip theme
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: textPrimaryDark.withAlpha(230), borderRadius: BorderRadius.circular(8)), textStyle: GoogleFonts.inter(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),

      // SnackBar theme

      // Navigation rail theme for tablets
      navigationRailTheme: NavigationRailThemeData(backgroundColor: surfaceDark, selectedIconTheme: IconThemeData(color: primaryDark), unselectedIconTheme: IconThemeData(color: textSecondaryDark), selectedLabelTextStyle: GoogleFonts.inter(color: primaryDark, fontSize: 12, fontWeight: FontWeight.w500), unselectedLabelTextStyle: GoogleFonts.inter(color: textSecondaryDark, fontSize: 12, fontWeight: FontWeight.w400)), dialogTheme: DialogThemeData(backgroundColor: dialogDark));

  /// Helper method to build light text theme with Inter and Roboto fonts
  static TextTheme _buildLightTextTheme() {
    return TextTheme(
        // Display styles - Inter for headings
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: -0.25),
        displayMedium: GoogleFonts.inter(
            fontSize: 45, fontWeight: FontWeight.w400, color: textPrimary),
        displaySmall: GoogleFonts.inter(
            fontSize: 36, fontWeight: FontWeight.w400, color: textPrimary),

        // Headline styles - Inter for headings
        headlineLarge: GoogleFonts.inter(
            fontSize: 32, fontWeight: FontWeight.w500, color: textPrimary),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28, fontWeight: FontWeight.w500, color: textPrimary),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24, fontWeight: FontWeight.w500, color: textPrimary),

        // Title styles - Inter for headings
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.15),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1),

        // Body styles - Inter for body text
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.5),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.25),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            letterSpacing: 0.4),

        // Label styles - Roboto for captions and data
        labelLarge: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1),
        labelMedium: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
            letterSpacing: 0.5),
        labelSmall: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: textDisabled,
            letterSpacing: 0.5));
  }

  /// Helper method to build dark text theme with Inter and Roboto fonts
  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
        // Display styles - Inter for headings
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            color: textPrimaryDark,
            letterSpacing: -0.25),
        displayMedium: GoogleFonts.inter(
            fontSize: 45, fontWeight: FontWeight.w400, color: textPrimaryDark),
        displaySmall: GoogleFonts.inter(
            fontSize: 36, fontWeight: FontWeight.w400, color: textPrimaryDark),

        // Headline styles - Inter for headings
        headlineLarge: GoogleFonts.inter(
            fontSize: 32, fontWeight: FontWeight.w500, color: textPrimaryDark),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28, fontWeight: FontWeight.w500, color: textPrimaryDark),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24, fontWeight: FontWeight.w500, color: textPrimaryDark),

        // Title styles - Inter for headings
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textPrimaryDark,
            letterSpacing: 0),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimaryDark,
            letterSpacing: 0.15),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimaryDark,
            letterSpacing: 0.1),

        // Body styles - Inter for body text
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textPrimaryDark,
            letterSpacing: 0.5),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textPrimaryDark,
            letterSpacing: 0.25),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textSecondaryDark,
            letterSpacing: 0.4),

        // Label styles - Roboto for captions and data
        labelLarge: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimaryDark,
            letterSpacing: 0.1),
        labelMedium: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondaryDark,
            letterSpacing: 0.5),
        labelSmall: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: textDisabledDark,
            letterSpacing: 0.5));
  }
}
