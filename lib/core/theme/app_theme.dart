import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Colors
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A6C48), // Deep Green
        surface: const Color(0xFFFAFAF9),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAF9),
      
      // Typography
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: const Color(0xFF1C1C1E),
        displayColor: const Color(0xFF1C1C1E),
      ),
      
      // Component Themes
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
