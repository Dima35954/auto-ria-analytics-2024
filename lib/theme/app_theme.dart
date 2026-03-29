import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Клас, що містить налаштування теми застосунку.
class AppTheme {
  /// Основний колір бренду.
  static const Color primaryColor = Color(0xFFDB3022);
  
  /// Другорядний колір бренду (текст, іконки тощо).
  static const Color secondaryColor = Color(0xFF222222);
  
  /// Основний колір фону екранів.
  static const Color backgroundColor = Color(0xFFF9F9F9);
  
  /// Колір поверхні (наприклад, карток, панелей).
  static const Color surfaceColor = Colors.white;
  
  /// Колір для відображення повідомлень про помилки.
  static const Color errorColor = Color(0xFFB00020);

  /// Повертає конфігурацію світлої теми застосунку.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.latoTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: secondaryColor),
        titleTextStyle: TextStyle(
          color: secondaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}