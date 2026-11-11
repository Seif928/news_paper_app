import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_paper_app/core/utils/responsive.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A1A1A);
  static const Color secondaryColor = Color(0xFF0054CD);
  static const Color backgroundColor = Color(0xFFF9F9F9);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color notificationRemoveColor = Color(0xFFE20808);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: backgroundColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: secondaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: notificationRemoveColor,
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
      error: notificationRemoveColor,
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

  static final Expando<Map<ScreenSize, ThemeData>> _adaptiveCache =
      Expando<Map<ScreenSize, ThemeData>>('adaptiveTheme');

  /// Returns [base] with a type scale tuned for [size].
  ///
  /// Compact screens keep the original mobile typography. Larger screens get
  /// slightly bigger headlines so the visual hierarchy holds up when content
  /// is displayed in wider layouts. Body text sizes are left unchanged.
  static ThemeData adaptive(ThemeData base, ScreenSize size) {
    if (size.isCompact) return base;

    final cache = _adaptiveCache[base] ??= <ScreenSize, ThemeData>{};
    return cache.putIfAbsent(size, () {
      final t = base.textTheme;
      final bool wide = size.isExpandedOrLarger;
      return base.copyWith(
        textTheme: t.copyWith(
          headlineLarge: t.headlineLarge?.copyWith(fontSize: wide ? 36 : 34),
          headlineMedium: t.headlineMedium?.copyWith(fontSize: wide ? 28 : 26),
          headlineSmall: t.headlineSmall?.copyWith(fontSize: 22),
        ),
      );
    });
  }
}
