import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A1A1A);
  static const Color secondaryColor = Color(0xFF0054CD);
  static const Color backgroundColor = Color(0xFFF9F9F9);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: backgroundColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: secondaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.publicSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),

      headlineMedium: GoogleFonts.publicSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33,
      ),

      headlineSmall: GoogleFonts.publicSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),

      titleMedium: GoogleFonts.publicSans(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.33,
      ),

      bodyLarge: GoogleFonts.publicSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),

      bodyMedium: GoogleFonts.publicSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
      ),

      bodySmall: GoogleFonts.publicSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF3F3F4),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondaryColor, width: 2),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF121212),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4DA3FF),
      brightness: Brightness.dark,
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.publicSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),

      headlineMedium: GoogleFonts.publicSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33,
      ),

      headlineSmall: GoogleFonts.publicSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),

      titleMedium: GoogleFonts.publicSans(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.33,
      ),

      bodyLarge: GoogleFonts.publicSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),

      bodyMedium: GoogleFonts.publicSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
      ),

      bodySmall: GoogleFonts.publicSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
    ),
  );
}
