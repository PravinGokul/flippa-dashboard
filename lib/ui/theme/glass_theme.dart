import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassTheme {
  static const BorderRadius radius = BorderRadius.all(Radius.circular(16));

  static const Color glassWhiteLow =
      Color.fromRGBO(255, 255, 255, 0.11); // Updated to 0.11

  static const Color glassWhiteHigh =
      Color.fromRGBO(255, 255, 255, 0.4);

  static const Color borderColor =
      Color.fromRGBO(255, 255, 255, 0.21); // Updated to 0.21

  static const double blurStrong = 8.0; // Updated to 8.0
  static const double blurSoft = 4.0;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F9FD),
    primaryColor: const Color(0xFF0F172A),
    textTheme: GoogleFonts.interTextTheme(),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: Colors.black.withOpacity(0.05)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F0F0F),
    primaryColor: Colors.blueAccent,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardThemeData(
      color: const Color.fromRGBO(255, 255, 255, 0.08),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.2)),
      ),
    ),
  );
}
