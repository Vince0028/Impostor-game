import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Cyberpunk Neon Palette
  static const Color primaryNeon = Color(0xFF00FFC2); // Neon Mint
  static const Color secondaryNeon = Color(0xFFD500F9); // Neon Purple
  static const Color accentNeon = Color(0xFFFF2E93); // Neon Pink
  static const Color alertColor = Color(0xFFFF3D00); // Neon Orange/Red

  // Background Colors - Dark Mode
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color backgroundCard = Color(0xFF1A1A1A);
  static const Color backgroundSurface = Color(0xFF252525);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textHint = Color(0xFF666666);

  // Player Card Colors - Vibrant & Distinct
  static const Color cardCyan = Color(0xFF00E5FF);
  static const Color cardPurple = Color(0xFFAA00FF);
  static const Color cardPink = Color(0xFFFF4081);
  static const Color cardLime = Color(0xFF76FF03);
  static const Color cardOrange = Color(0xFFFF9100);
  static const Color cardBlue = Color(0xFF2979FF);
  static const Color cardRed = Color(0xFFFF1744);
  static const Color cardTeal = Color(0xFF1DE9B6);

  // Special Roles
  static const Color imposterColor = alertColor;

  // UI Colors
  static const Color divider = Color(0xFF333333);
  static const Color splitShadow = Color(0xFF000000);
  static const Color overlayDark = Color(0xCC000000);

  static const List<Color> playerCardColors = [
    cardCyan,
    cardPurple,
    cardPink,
    cardLime,
    cardOrange,
    cardBlue,
    cardRed,
    cardTeal,
  ];

  static Color getPlayerColor(int index) {
    return playerCardColors[index % playerCardColors.length];
  }

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: secondaryNeon,
        surface: backgroundCard,
        error: alertColor,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: backgroundCard,
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNeon,
          foregroundColor: Colors.black,
          elevation: 4,
          shadowColor: primaryNeon.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryNeon,
          side: const BorderSide(color: primaryNeon, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryNeon,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryNeon, width: 2),
        ),
        hintStyle: const TextStyle(color: textHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryNeon;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryNeon.withOpacity(0.3);
          }
          return Colors.white10;
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: titleMedium.copyWith(color: textPrimary),
        contentTextStyle: bodyLarge.copyWith(color: textSecondary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      iconTheme: const IconThemeData(color: textPrimary, size: 24),
      textTheme: const TextTheme(
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        titleLarge: titleLarge,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      fontFamily: 'Roboto',
    );
  }

  // Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: textPrimary,
    letterSpacing: -1.0,
    height: 1.1,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textHint,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: primaryNeon,
    letterSpacing: 1.0,
  );
}
